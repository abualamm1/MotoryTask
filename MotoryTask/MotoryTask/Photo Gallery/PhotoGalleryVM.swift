//
//  PhotoGalleryVM.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 04/11/2025.
//

import RxSwift
import RxCocoa
import Foundation
import UIKit

final class PhotoGalleryVM {

    // MARK: - Outputs
    let photosObs = BehaviorRelay<[PhotoModel]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishRelay<String>()
    let searchObs = BehaviorSubject<String>(value: "")
    let showZoomVC = PublishSubject<UIImage>()
    let categoriesObs: BehaviorRelay<[ChipsModel]>
    let likedButtonTap = PublishSubject<PhotoModel>()

    // MARK: - Private
    private let listUseCase: ListPhotosUseCase
    private let searchUseCase: SearchPhotosUseCase
    private let disposeBag = DisposeBag()
    
    init() {
        // Dependency setup
        let client = NetworkClient()
        let repo = PhotosRepository(client: client)
        self.listUseCase = ListPhotosUseCase(repo: repo)
        self.searchUseCase = SearchPhotosUseCase(repo: repo)
        
        // Default chip categories
        let chips: [ChipsModel] = [
            .init(title: "Images", isSelected: true, code: "images"),
            .init(title: "My Favourite", isSelected: false, code: "my_favourite"),
        ]
        categoriesObs = .init(value: chips)
    }

    // MARK: - Public API

    /// Fetches default photo list.
    func fetchPhotos() {
        isLoading.accept(true)

        listUseCase.execute()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .next(let response):
                    self.isLoading.accept(false)
                    self.photosObs.accept(response)
                case .error(let err):
                    self.isLoading.accept(false)
                    self.error.accept(err.localizedDescription)
                case .completed:
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    /// Performs search for photos by query.
    func searchPhotos(query: String) {
        isLoading.accept(true)
        
        searchUseCase.execute(query: query)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .next(let response):
                    self.isLoading.accept(false)
                    self.photosObs.accept(response.results ?? [])
                case .error(let err):
                    self.isLoading.accept(false)
                    self.error.accept(err.localizedDescription)
                case .completed:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
