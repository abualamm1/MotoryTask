//
//  ChipsCVCellVM.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 03/11/2025.
//

import RxSwift
import RxCocoa

class ChipsCVCellVM {
    
    var model: BehaviorRelay<ChipsModel>
    
    init(model: ChipsModel) {
        self.model = BehaviorRelay(value: model)
    }
}
