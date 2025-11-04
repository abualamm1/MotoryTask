//
//  PhotoGalleryVM.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 04/11/2025.
//

import RxSwift
import RxCocoa

final class PhotoGalleryVM {

    // MARK: Outputs
    let photosObs = BehaviorRelay<[PhotoModel]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishRelay<String>()
    let searchObs = BehaviorSubject<String>(value: "")

    // MARK: Private
    private let listUseCase: ListPhotosUseCase
    private let searchUseCase: SearchPhotosUseCase
    private let disposeBag = DisposeBag()
    
    init() {
        let client = NetworkClient()
        let repo = PhotosRepository(client: client)
        self.listUseCase = ListPhotosUseCase(repo: repo)
        self.searchUseCase = SearchPhotosUseCase(repo: repo)
    }

    // MARK: - Public API

    func fetchPhotos() {
        isLoading.accept(true)
        listUseCase.execute()
            .subscribe(
                onNext: { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .next(let response):
                        self.isLoading.accept(false)
                        let model = response
                        self.photosObs.accept(model)
                    case .error(let err):
                        self.isLoading.accept(false)
                        self.error.accept(err.localizedDescription)
                    case .completed:
                        print()
                    }
                }
            )
            .disposed(by: disposeBag)
    }

    func searchPhotos(query: String) {
        isLoading.accept(true)
        
        searchUseCase.execute(query: query)
            .subscribe(
                onNext: { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .next(let response):
                        self.isLoading.accept(false)
                        let model = response.results ?? []
                        self.photosObs.accept(model)
                    case .error(let err):
                        self.isLoading.accept(false)
                        self.error.accept(err.localizedDescription)
                    case .completed:
                        print()
                    }
                }
            )
            .disposed(by: disposeBag)
    }
}
