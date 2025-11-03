//
//  BaseViewController.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 03/11/2025.
//


import UIKit

/// A base view controller that automatically dismisses the keyboard
/// when the user taps anywhere outside of a text input view.
///
/// When Creat new `ViewController`use  Subclass `BaseViewController` instead of `UIViewController`

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDismissKeyboardGesture()
    }
    
    /// Adds a tap gesture recognizer to the view that triggers keyboard dismissal.
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // So buttons, sliders, etc. still work
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
