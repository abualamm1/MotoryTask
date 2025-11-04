//
//  SearchPhotosUseCase.swift
//  MotoryTask
//
//  Created by Ammar Al-amm on 04/11/2025.
//

import RxSwift
import Foundation

struct SearchPhotosUseCase {
    let repo: PhotosRepositoryType

    func execute(query: String) -> Observable<ResponseEvent<SearchPhotosResponse>> {
        return repo.searchPhotos(query: query)
            .asObservable()
            .flatMap { response -> Observable<ResponseEvent<SearchPhotosResponse>> in
                return Observable.create { observer in
                    observer.onNext(.next(response))
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
