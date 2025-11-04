//
//  CustomTextField.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 03/11/2025.
//

import Foundation
import UIKit

/// A customizable `UITextField` subclass that allows you to set the
/// placeholder text color directly from Interface Builder.
///
/// Use this class when you want design-time control over the placeholder
/// appearance without writing additional code.

@IBDesignable class CustomTextField: UITextField {
    
    /// Whenever this property is set, the placeholder color will be updated.
    override var placeholder: String? {
        didSet {
            updatePlaceholderColor()
        }
    }
    
    /// The color of the placeholder text.
    @IBInspectable var placeholderColor: UIColor? {
        didSet {
            updatePlaceholderColor()
        }
    }
    
    /// Updates the placeholder with the selected color.
    private func updatePlaceholderColor() {
            guard let placeholder = placeholder, let color = placeholderColor else { return }
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: color]
            )
        }
}
