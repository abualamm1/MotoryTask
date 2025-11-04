//
//  ChipsModel.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 03/11/2025.
//


import Foundation
class ChipsModel: Codable {
    
    var title: String?
    var isSelected: Bool
    var code: String?
    
    init(title: String? = nil, isSelected: Bool = false, code: String? = nil) {
        self.title = title
        self.isSelected = isSelected
        self.code = code
    }
    
}
