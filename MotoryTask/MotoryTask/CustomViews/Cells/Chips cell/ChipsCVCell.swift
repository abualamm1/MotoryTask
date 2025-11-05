//
//  ChipsCVCell.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 03/11/2025.
//

import UIKit
import RxSwift
import RxCocoa

/// Collection view cell representing a selectable chip.
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
        // Reset disposables to avoid duplicate bindings on reuse
        disposeBag = DisposeBag()
    }

    /// Binds the cell to its view model.
    func configure(with viewModel: ChipsCVCellVM) {
        self.viewModel = viewModel
        setupUI()
        
        //Note: baseView has a cornerRadius 16 as design but is not the same becouse in design it add just for the view corners not for the full view 
    }
    
    /// Sets up UI bindings for reactive updates.
    private func setupUI() {
        // Bind title text
        viewModel.model
            .map { $0.title }
            .asDriver(onErrorDriveWith: .empty())
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)

        // Bind text color based on selection state
        viewModel.model
            .map { $0.isSelected ? .ghostWhiteColor : .whiteColor }
            .asDriver(onErrorDriveWith: .empty())
            .drive(titleLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        // Bind background color based on selection state
        viewModel.model
            .map { $0.isSelected ? .primaryColor : .secondaryColor }
            .asDriver(onErrorDriveWith: .empty())
            .drive(baseView.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
}
