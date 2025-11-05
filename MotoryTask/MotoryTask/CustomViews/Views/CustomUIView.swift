//
//  CustomUIView.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 03/11/2025.
//

import Foundation
import UIKit


/// A customizable `UIView` subclass that provides design-time control
/// over corner radius, border width, and border color directly from
/// Interface Builder.
///
/// This view also supports an option to make itself fully rounded
/// (useful for creating circular views such as avatars or buttons).

@IBDesignable
class CustomUIView: UIView {

    private var isFullRounded = false


    // MARK: - Inspectable Properties

    /// A Boolean value that determines whether the view’s corners
    /// should be fully rounded based on its height.
    @IBInspectable var cornerRadiusFull: Bool {
        get{
            return isFullRounded
        }
        set{
            self.isFullRounded = newValue
            if newValue {
                fullRounded()
            }else{
                self.reset()
            }
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get{
            return 0.0
        }
        set{
            self.layer.cornerRadius = newValue
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get{
            return self.layer.borderWidth
        }
        set{
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get{
            
            if let color = self.layer.borderColor{
                return UIColor(cgColor: color)
            }
            return nil
        }
        set{
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.fullRounded()
    }
    
    // MARK: - Helper Methods

    /// Resets the view’s corner radius to zero.
    func reset(){
        self.layer.cornerRadius = 0
    }

    /// Applies a fully rounded corner radius equal to half of the view’s height.
    ///
    /// This method only has an effect if `cornerRadiusFull` is enabled.
    func fullRounded(){
        if isFullRounded {
            self.layer.cornerRadius = self.bounds.height / 2
        }
    }
}
