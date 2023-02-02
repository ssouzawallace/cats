//
//  CatsViewModel.swift
//  Cats
//
//  Created by Wallace Silva on 02/02/23.
//

import Foundation

protocol CatsGalleryView {
    func present(cats: [CatModel])
    func present(errorMessage: String)
}

struct CatsViewModel {
    let view: CatsGalleryView?
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
                    guard response.success else {
                        view?.present(errorMessage: "Status: \(response.status)")
                        return
                    }
                    let cats = response.data?.reduce([]) { partialResult, item in
                        partialResult + (item.images ?? []).map({ itemImage in
                            CatModel(url: itemImage.link, title: item.title ?? "no title")
                        })
                    }
                    view?.present(cats: cats ?? [])
                case .failure(let error):
                    view?.present(errorMessage: error.description)
                }
            }
        }
    }
}
