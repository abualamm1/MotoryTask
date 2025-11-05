//
//  ImageZoomVC.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 04/11/2025.
//


import UIKit

/// Displays a zoomable image with a close button overlay.
class ImageZoomVC: BaseViewController, UIScrollViewDelegate {
        
    var image: UIImage? // Set by the presenting view controller
    
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal) // SF Symbol
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        button.layer.cornerRadius = 20
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    /// Configures scroll view, image view, and close button.
    func setupUI() {
        view.backgroundColor = .black.withAlphaComponent(0.3)
        
        // ScrollView setup
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        view.addSubview(scrollView)
        
        // ImageView setup
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.frame = scrollView.bounds
        scrollView.addSubview(imageView)

        centerImage()
        
        // Close button setup
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        // Button constraints (top-right corner)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 50),
            closeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        closeButton.imageView?.contentMode = .scaleAspectFit
    }
    
    /// Centers the image within the scroll view.
    private func centerImage() {
        let scrollViewSize = scrollView.bounds.size
        let imageSize = imageView.frame.size

        let horizontalInset = imageSize.width < scrollViewSize.width ? (scrollViewSize.width - imageSize.width) / 2 : 0
        let verticalInset = imageSize.height < scrollViewSize.height ? (scrollViewSize.height - imageSize.height) / 2 : 0

        scrollView.contentInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
    }

    // MARK: - UIScrollViewDelegate

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    // Update centering after zoom
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
    
    /// Dismisses the zoom view.
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}
