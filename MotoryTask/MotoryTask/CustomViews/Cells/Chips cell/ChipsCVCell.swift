//
//  ChipsCVCell.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 03/11/2025.
//

import UIKit
import RxSwift
import RxCocoa

class ChipsCVCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var baseView: CustomUIView!
    
    var viewModel: ChipsCVCellVM!
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configure(with viewModel: ChipsCVCellVM) {
        self.viewModel = viewModel
        setupUI()
    }
    
    private func setupUI() {
        
        viewModel.model
            .map{$0.title}
            .asDriver(onErrorJustReturn: "")
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.model
            .map { $0.isSelected ? .ghostWhiteColor : .whiteColor }
            .asDriver(onErrorJustReturn: UIColor())
            .drive(titleLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        viewModel.model
            .map { $0.isSelected ? .primaryColor : .secondaryColor }
            .asDriver(onErrorJustReturn: UIColor())
            .drive(titleLabel.rx.textColor)
            .disposed(by: disposeBag)
    }
}
