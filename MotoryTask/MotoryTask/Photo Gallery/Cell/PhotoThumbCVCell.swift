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

    var viewModel: PhotoThumbCVCellVM!
    var disposeBag = DisposeBag()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImage.image = nil
        likedImage.image = UIImage(named: "white_heart_icon")
    }
    
    func configure(with vm: PhotoThumbCVCellVM){
        viewModel = vm
        setupUI()
    }
    
    private func setupUI(){
        
        viewModel.model
            .map({ $0.user?.name ?? "" })
            .asDriver(onErrorJustReturn: "")
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.model
            .map { $0.description ?? "" }
            .asDriver(onErrorJustReturn: "")
            .drive(descLabel.rx.text)
            .disposed(by: disposeBag)
    }

}
