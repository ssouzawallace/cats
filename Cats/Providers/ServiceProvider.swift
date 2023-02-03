//
//  ServiceProvider.swift
//  Cats
//
//  Created by Wallace Silva on 02/02/23.
//

import Foundation

struct ServiceProvider {
    private let clientId: String
    private let clientSecret: String
    
    let url = URL(string: "https://api.imgur.com/3/gallery/search/?q=cats")
    
    init() {
        guard let clientId = ProcessInfo.processInfo.environment["client_id"], let clientSecret = ProcessInfo.processInfo.environment["client_secret"] else {
            self.clientId = ""
            self.clientSecret = ""
            print("WARNING! You have to set the `clinet_id` and `client_secret` environment variables which are the two required keys in order to fetch the images from the Imgur API.")
            return
        }
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
}

extension ServiceProvider: ServiceProviding {
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    private var request: URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(clientId)",
                         forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchImages(with completion: @escaping (Result<GallerySearchResponse, ServiceError>) -> Void) {
        guard let request = request else { return completion(.failure(.requestCreation)) }
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { return completion(.failure(.requestError(error?.localizedDescription ?? ""))) }
            
            guard let data = data else { return completion(.failure(.decode)) }
            
            do {
                let decodedResponse = try decoder.decode(GallerySearchResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                tryToDecodeErrorResponse(for: data, with: completion)
            }
        }
        .resume()
    }
    
    private func tryToDecodeErrorResponse(for data: Data, with completion: @escaping (Result<GallerySearchResponse, ServiceError>) -> Void) {
        do {
            let decodedResponse = try decoder.decode(GallerySearchErrorResponse.self, from: data)
            completion(.failure(.requestError(decodedResponse.data.error)))
        } catch {
            completion(.failure(.decode))
        }
    }
}

