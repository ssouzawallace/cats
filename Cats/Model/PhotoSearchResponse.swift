//
//  PhotoSearchResponse.swift
//  Cats
//
//  Created by Wallace Silva on 02/02/23.
//

import Foundation

/// A page of results from the Pexels photo search endpoint.
struct PhotoSearchResponse: Decodable {
    let photos: [Photo]
    let page: Int
    let perPage: Int
    let totalResults: Int
}

struct Photo: Decodable {
    /// The photographer's own description of the picture. Occasionally empty.
    let alt: String
    let photographer: String
    let src: Source

    /// Pexels renders every photo at a range of sizes and returns them all.
    struct Source: Decodable {
        let original: URL
        let large: URL
        let medium: URL
    }
}
