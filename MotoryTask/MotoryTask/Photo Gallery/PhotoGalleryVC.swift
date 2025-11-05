//
//  PhotoGalleryVC.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 03/11/2025.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoGalleryVC: BaseViewController {

    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchTextField: CustomTextField!
    @IBOutlet weak var chipsCollectionView: UICollectionView!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel = PhotoGalleryVM()
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupChipsCollectionView()
        setupPhotosCollectionView()
    }
    
    private func setupUI() {
        setupCell()
        setupCollectionViewLayout()
    }
    
    /// Loading state + search triggers.
    private func setupBindings() {
        // Activity indicator visibility/animation
        viewModel.isLoading
            .map { !$0 }
            .asDriver(onErrorDriveWith: .empty())
            .drive(activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .asDriver(onErrorDriveWith: .empty())
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        // Trigger search only when the user finishes editing (editingDidEnd)
        // Instead of on every keystroke — this avoids sending too many requests.
        // We’re limited to ~50 requests per hour, so this approach conserves quota
        // and improves overall performance and responsiveness.
        searchTextField.rx
            .controlEvent([.editingDidEnd])
            .withLatestFrom(searchTextField.rx.text)
            .map { $0 ?? "" }
            .bind(to: viewModel.searchObs)
            .disposed(by: disposeBag)

        
        // Fetch or search based on query
        viewModel.searchObs
            .subscribe(onNext: { [weak self] query in
                guard let self = self else { return }
                if query.isEmpty { self.viewModel.fetchPhotos() }
                else { self.viewModel.searchPhotos(query: query) }
            })
            .disposed(by: disposeBag)
    }
    
    /// Chips data source + selection handling.
    private func setupChipsCollectionView() {
        // Bind chips
        viewModel.categoriesObs
            .asDriver(onErrorDriveWith: .empty())
            .drive(chipsCollectionView.rx.items(cellIdentifier: "ChipsCVCell")){ row ,model, cell in
                if let cell = cell as? ChipsCVCell  {
                    let vm = ChipsCVCellVM(model: model)
                    cell.configure(with: vm)
                }
            }
            .disposed(by: disposeBag)
        
        // Single-select chip
        chipsCollectionView.rx.modelSelected(ChipsModel.self)
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                let updated = self.viewModel.categoriesObs.value.map { item -> ChipsModel in
                    let copy = item
                    copy.isSelected = (item.code == model.code)
                    return copy
                }
                self.viewModel.categoriesObs.accept(updated)
            })
            .disposed(by: disposeBag)
    }
    
    /// Photos grid data source + navigation to zoom.
    private func setupPhotosCollectionView() {
        // Bind photos
        viewModel.photosObs
            .asDriver(onErrorDriveWith: .empty())
            .drive(photosCollectionView.rx.items(cellIdentifier: "PhotoThumbCVCell")) { [weak self] _, model, cell in
                guard let self = self else { return }
                if let cell = cell as? PhotoThumbCVCell  {
                    cell.configure(with: PhotoThumbCVCellVM(model: model))
                    // Propagate tap to VM output
                    cell.viewModel.showPhotoTapped
                        .bind(to: self.viewModel.showZoomVC)
                        .disposed(by: cell.disposeBag)
                    
                    cell.viewModel.likedButtonTap
                        .map{ _ in model}
                        .bind(to: self.viewModel.likedButtonTap)
                        .disposed(by: cell.disposeBag)
                }
            }
            .disposed(by: disposeBag)
        
        // Present zoom VC
        viewModel.showZoomVC
            .subscribe(onNext: { [weak self] image in
                self?.navigatToZoom(with: image)
            })
            .disposed(by: disposeBag)
        
        viewModel.likedButtonTap
            .subscribe(onNext: { [weak self] selectedModel in
                guard let self = self else { return }
                
                // Toggle the liked state of the tapped photo
                let updated = self.viewModel.photosObs.value.map { item -> PhotoModel in
                    var copy = item
                    if copy.id == selectedModel.id {
                        copy.likedByUser.toggle()
                    }
                    return copy
                }
                
                // Optionally: Continues this change via API or local storage
                self.viewModel.photosObs.accept(updated)
            })
            .disposed(by: disposeBag)
    }
    
    /// Register cells + chips layout.
    private func setupCell() {
        let nib = UINib(nibName: "ChipsCVCell", bundle: nil)
        chipsCollectionView.register(nib, forCellWithReuseIdentifier: "ChipsCVCell")

        let lineSpacing: CGFloat = 22 // LineSpacing
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = lineSpacing
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        layout.sectionInset = .zero
        chipsCollectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    /// Register photo cell + grid layout.
    private func setupCollectionViewLayout() {
        // Layout constants
        let lineSpacing: CGFloat = 22 // LineSpacing
        let sideInset: CGFloat = 20 // Leading and triling spacing
        let columnSpacing: CGFloat = 36 // Spacing between items in the same column
        
        let totalHorizontalSpacing = lineSpacing + (sideInset * 2)
        let itemWidth = Int((photosCollectionView.bounds.width - totalHorizontalSpacing) / 2) // 2 Items in same row
        let itemHeight = 300

        let nib = UINib(nibName: "PhotoThumbCVCell", bundle: nil)
        photosCollectionView.register(nib, forCellWithReuseIdentifier: "PhotoThumbCVCell")

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = columnSpacing
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .vertical
        photosCollectionView.setCollectionViewLayout(layout, animated: false)
    }

    
    /// Pushes the zoom controller modally.
    private func navigatToZoom(with image: UIImage) {
        let zoomVC = ImageZoomVC()
        zoomVC.image = image
        self.present(zoomVC, animated: true)
    }
}
