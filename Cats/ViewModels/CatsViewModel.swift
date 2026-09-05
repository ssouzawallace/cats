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
    func present(cats: [Cat])
    func present(errorMessage: String)
}

/// On the main actor because everything it does ends in a call to the view.
@MainActor
struct CatsViewModel {
    weak var view: CatsGalleryView?
    let provider: ServiceProviding

    init(view: CatsGalleryView? = nil, provider: ServiceProviding = ServiceProvider()) {
        self.view = view
        self.provider = provider
    }

    func fetchImages() async {
        do {
            let response = try await provider.fetchImages()
            view?.present(cats: response.photos.map { Cat(photo: $0) })
        } catch let error as ServiceError {
            view?.present(errorMessage: error.description)
        } catch {
            view?.present(errorMessage: error.localizedDescription)
        }
    }
}
