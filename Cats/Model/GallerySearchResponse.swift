//
//  GallerySearchResponse.swift
//  Cats
//
//  Created by Wallace Silva on 03/02/23.
//

import Foundation

struct GallerySearchResponse: Decodable {
    let data: [GalleryItem]?
    let success: Bool
    let status: UInt
}

struct GalleryItem: Decodable {
    let title: String?
    let images: [GalleryItemImage]?
}

struct GalleryItemImage: Decodable {
    let link: URL
}
