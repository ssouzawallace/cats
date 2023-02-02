//
//  GallerySearchErrorResponse.swift
//  Cats
//
//  Created by Wallace Silva on 03/02/23.
//

import Foundation

struct GallerySearchErrorResponse: Decodable {
    struct Data: Decodable {
        let error: String
        let request: String
        let method: String
    }
    let data: Data
    let success: Bool
    let status: UInt
}
