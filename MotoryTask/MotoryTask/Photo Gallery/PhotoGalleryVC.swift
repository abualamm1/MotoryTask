//
//  PhotoGalleryVC.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 03/11/2025.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class PhotoGalleryVC: BaseViewController {

    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchTextField: CustomTextField!
    @IBOutlet weak var chipsCollectionView: UICollectionView!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

