//
//  ListPhotosUseCase.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 04/11/2025.
//

import Foundation
import RxSwift

/// Use case for fetching a list of photos.
struct ListPhotosUseCase {
    let repo: PhotosRepositoryType

    /// Executes the photo fetch and emits response events.
    func execute() -> Observable<ResponseEvent<[PhotoModel]>> {
        return repo.listPhotos()
            .asObservable()
            .flatMap { photos -> Observable<ResponseEvent<[PhotoModel]>> in
                return Observable.create { observer in
                    observer.onNext(.next(photos))
                    observer.onNext(.completed)
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
            .catch { error in
                return Observable.just(.error(error))
            }
    }
}
