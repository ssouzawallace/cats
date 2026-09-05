//
//  Cat.swift
//  Cats
//
//  Created by Wallace Silva on 03/02/23.
//

import Foundation

struct Cat {
    let url: URL
    let title: String
}

extension Cat {
    /// Pexels offers each photo at several sizes; `large` is big enough to fill
    /// the fullscreen view without pulling down the multi-megabyte original.
    ///
    /// `alt` is the photographer's description and is the more useful title, but
    /// it is occasionally empty, in which case the credit stands in for it.
    init(photo: Photo) {
        url = photo.src.large
        title = photo.alt.isEmpty ? "Photo by \(photo.photographer)" : photo.alt
    }
}
