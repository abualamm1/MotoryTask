//
//  PhotoThumbCVCellVM.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 04/11/2025.
//


import RxSwift
import RxCocoa
import Foundation

class PhotoThumbCVCellVM {
    var model: BehaviorRelay<photoModel>
    var likedButtonTap: PublishSubject<Void>
    
    init(model: photoModel) {
        
        self.model = BehaviorRelay(value: model)
        likedButtonTap = PublishSubject()
    }
}