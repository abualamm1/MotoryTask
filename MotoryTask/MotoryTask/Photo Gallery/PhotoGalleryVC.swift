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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupUI() {
        setupCollectionViewLayout()
    }
    
    private func setupBindings() {
        
        viewModel.isLoading
            .map { !$0 }
            .asDriver(onErrorJustReturn: true)
            .drive(activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .map { $0 }
            .asDriver(onErrorJustReturn: false)
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.photosObs
            .asDriver(onErrorJustReturn: [])
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
        
        viewModel.showZoomVC
            .subscribe(onNext: { [weak self] image in
                guard let self = self else { return }
                
                self.navigatToZoom(with: image)
            })
            .disposed(by: disposeBag)
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
