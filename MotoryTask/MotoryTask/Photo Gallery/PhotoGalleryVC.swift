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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupUI() {
        setupCell()
        setupCollectionViewLayout()
    }
    
    private func setupBindings() {
        
        viewModel.isLoading
            .map { !$0 }
            .asDriver(onErrorDriveWith: .empty())
            .drive(activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .map { $0 }
            .asDriver(onErrorDriveWith: .empty())
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        searchTextField.rx
            .controlEvent([.editingDidEnd])
            .withLatestFrom(searchTextField.rx.text)
            .map { $0 ?? "" }
            .bind(to: viewModel.searchObs)
            .disposed(by: disposeBag)
        
        viewModel.searchObs
            .subscribe(onNext: { [weak self] query in
                guard let self = self else { return }
                if query.isEmpty {
                    self.viewModel.fetchPhotos()
                }else {
                    self.viewModel.searchPhotos(query: query)
                }
            }).disposed(by: disposeBag)

    }
    
    private func setupChipsCollectionView() {
        
        viewModel.categoriesObs
            .asDriver(onErrorDriveWith: .empty())
            .drive(chipsCollectionView.rx.items(cellIdentifier: "ChipsCVCell")){ row ,model, cell in
                if let cell = cell as? ChipsCVCell  {
                    let vm = ChipsCVCellVM(model: model)
                    cell.configure(with: vm)
                }
            }
            .disposed(by: disposeBag)
        
        
        chipsCollectionView.rx.modelSelected(ChipsModel.self)
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                
                var updated = self.viewModel.categoriesObs.value.map { item -> ChipsModel in
                    var newItem = item
                    newItem.isSelected = (item.code == model.code)
                    return newItem
                }
                self.viewModel.categoriesObs.accept(updated)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func setupPhotosCollectionView() {
        
        viewModel.photosObs
            .asDriver(onErrorDriveWith: .empty())
            .drive(photosCollectionView.rx.items(cellIdentifier: "PhotoThumbCVCell")){ row ,model, cell in
                if let cell = cell as? PhotoThumbCVCell  {
                    let vm = PhotoThumbCVCellVM(model: model)
                    cell.configure(with: vm)
                    
                    cell.viewModel.showPhotoTapped
                        .bind(to: self.viewModel.showZoomVC)
                        .disposed(by: cell.disposeBag)
                }
            }
            .disposed(by: disposeBag)
        
        
        viewModel.showZoomVC
            .subscribe(onNext: { [weak self] image in
                guard let self = self else { return }
                
                self.navigatToZoom(with: image)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func setupCell(){

        let nib = UINib(nibName: "ChipsCVCell", bundle: nil)
        chipsCollectionView.register(nib, forCellWithReuseIdentifier: "ChipsCVCell")

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        layout.sectionInset = .zero
        chipsCollectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    
    private func setupCollectionViewLayout() {

        let nib = UINib(nibName: "PhotoThumbCVCell", bundle: nil)
        photosCollectionView.register(nib, forCellWithReuseIdentifier: "PhotoThumbCVCell")

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = 22
        layout.minimumInteritemSpacing = 36
        let itemWidth = Int((photosCollectionView.bounds.width - 62) / 2)
        let itemHeight = 300
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .vertical
        photosCollectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    private func navigatToZoom(with image: UIImage ) {
        
        let zoomVC = ImageZoomVC()
        zoomVC.image = image
        self.present(zoomVC, animated: true)
        
    }
}
