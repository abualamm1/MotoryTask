//
//  PhotoThumbCVCellVM.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 04/11/2025.
//


import RxSwift
import RxCocoa
import Foundation
import UIKit

class PhotoThumbCVCellVM {
    var model: BehaviorRelay<PhotoModel>
    var likedButtonTap =  PublishSubject<Void>()
    var showPhotoTapped =  PublishSubject<UIImage>()
    
    init(model: PhotoModel) {
        
        self.model = BehaviorRelay(value: model)
    }
}
