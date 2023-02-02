//
//  ServiceProviding.swift
//  Cats
//
//  Created by Wallace Silva on 02/02/23.
//

import Foundation

protocol ServiceProviding {
    func fetchImages(with completion: @escaping (Result<GallerySearchResponse, ServiceError>) -> Void)
}
