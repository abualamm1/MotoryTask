//
//  Color+Extension.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 03/11/2025.
//

import Foundation



import Foundation
import UIKit


// Manual color accessor — it’s fine for small projects or a handful of colors
/// Centralized color palette loaded from asset catalog.
extension UIColor {
    @nonobjc class var ashGreyColor: UIColor {
        return UIColor(named: "AshGreyColor")!
    }
    
    @nonobjc class var backgroundColor: UIColor {
        return UIColor(named: "BackgroundColor")!
    }
    
        @nonobjc class var ghostWhiteColor: UIColor {
        return UIColor(named: "GhostWhiteColor")!
    }
    
    
        @nonobjc class var grayLightColor: UIColor {
        return UIColor(named: "GrayLightColor")!
    }
        
        @nonobjc class var primaryColor: UIColor {
        return UIColor(named: "PrimaryColor")!
    }
    
        @nonobjc class var secondaryColor: UIColor {
        return UIColor(named: "SecondaryColor")!
    }
         
    @nonobjc class var whiteColor: UIColor {
        return UIColor(named: "WhiteColor")!
    }
}
