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

class PhotoThumbCVCell: UICollectionViewCell {

    @IBOutlet weak var photoImage: UIImageView!

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
        activityIndicator.isHidden = false
        photoImage.image = nil
        likedImage.image = UIImage(named: "white_heart_icon")
        disposeBag = DisposeBag()
    }
    
    func configure(with vm: PhotoThumbCVCellVM){
        viewModel = vm
        setupUI()
    }
    
    private func setupUI(){

        viewModel.model
            .map({ $0.user?.username ?? "" })
            .asDriver(onErrorJustReturn: "")
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.model
            .map { $0.altDescription ?? "" }
            .asDriver(onErrorJustReturn: "")
            .drive(descLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.model
            .map {  $0.urls?.full ?? ""}
            .subscribe(onNext: {[weak self] urlString in
                
                guard let self = self, let url = URL(string: urlString) else { return }

                self.activityIndicator.startAnimating()
                self.activityIndicator.isHidden = false

                self.photoImage.kf.setImage(
                    with: url,
                    placeholder: nil,
                    options: [.cacheOriginalImage]) { [weak self] _ in
                    guard let self = self else { return }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            })
            .disposed(by: disposeBag)

        viewModel.model
            .map({ $0.likedByUser ? UIImage(named: "red_heart_icon") : UIImage(named: "white_heart_icon") })
            .asDriver(onErrorJustReturn: UIImage())
            .drive(likedImage.rx.image)
            .disposed(by: disposeBag)
    }
}
