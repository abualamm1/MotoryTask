//
//  PhotoThumbCVCell.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 04/11/2025.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

/// Collection view cell displaying a photo thumbnail with user info and like state.
class PhotoThumbCVCell: UICollectionViewCell {

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var showPhotoButton: UIButton!
    
    @IBOutlet weak var likedImage: UIImageView!
    @IBOutlet weak var likedButton: UIButton!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: PhotoThumbCVCellVM!
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset UI and disposables for reuse
        activityIndicator.isHidden = false
        photoImage.image = nil
        likedImage.image = UIImage(named: "white_heart_icon")
        disposeBag = DisposeBag()
    }
    
    /// Binds the cell to its view model.
    func configure(with vm: PhotoThumbCVCellVM) {
        viewModel = vm
        setupUI()
    }
    
    /// Sets up reactive bindings for UI updates.
    private func setupUI() {

        // Bind username
        viewModel.model
            .map { $0.user?.username ?? "" }
            .asDriver(onErrorDriveWith: .empty())
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)

        // Bind photo description
        viewModel.model
            .map { $0.altDescription ?? "" }
            .asDriver(onErrorDriveWith: .empty())
            .drive(descLabel.rx.text)
            .disposed(by: disposeBag)

        // Load image asynchronously with Kingfisher
        viewModel.model
            .map { $0.urls?.full ?? "" }
            .subscribe(onNext: { [weak self] urlString in
                guard let self = self, let url = URL(string: urlString) else { return }

                self.activityIndicator.startAnimating()
                self.activityIndicator.isHidden = false

                //NOTE: The imgae is Stretched becouse it has a stsic hight and the all images have the same hight even when useing the full or regular ones
                self.photoImage.kf.setImage(
                    with: url,
                    placeholder: nil,
                    options: [.cacheOriginalImage]
                ) { [weak self] _ in
                    guard let self = self else { return }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.viewModel.model.value.image = self.photoImage.image ?? UIImage()
                }
            })
            .disposed(by: disposeBag)

        // Bind liked state icon
        viewModel.model
            .map{ $0.likedByUser ? UIImage(named: "red_heart_icon") : UIImage(named: "white_heart_icon") }
            .asDriver(onErrorDriveWith: .empty())
            .drive(likedImage.rx.image)
            .disposed(by: disposeBag)
       
        // Handle photo tap to show full image
        showPhotoButton.rx.tap
            .withLatestFrom(viewModel.model)
            .map {$0.image ?? UIImage()}
            .bind(to: viewModel.showPhotoTapped)
            .disposed(by: disposeBag)
        
        likedButton.rx.tap
            .bind(to: viewModel.likedButtonTap)
            .disposed(by: disposeBag)
    }
}
