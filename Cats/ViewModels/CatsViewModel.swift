//
//  CatsViewModel.swift
//  Cats
//
//  Created by Wallace Silva on 02/02/23.
//

import Foundation

/// Class-bound so the view model can hold the view weakly. Without that the
/// view controller owns the view model, the view model owns the view
/// controller, and neither is ever released.
protocol CatsGalleryView: AnyObject {
    func present(cats: [CatModel])
    func present(errorMessage: String)
}

struct CatsViewModel {
    weak var view: CatsGalleryView?
    let provider: ServiceProviding
    
    init(view: CatsGalleryView? = nil, provider: ServiceProviding = ServiceProvider()) {
        self.view = view
        self.provider = provider
    }
    
    func fetchImages() {
        provider.fetchImages { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    view?.present(cats: response.photos.map { CatModel(photo: $0) })
                case .failure(let error):
                    view?.present(errorMessage: error.description)
                }
            }
        }
    }
}
