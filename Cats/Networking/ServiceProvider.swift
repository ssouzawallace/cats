//
//  ServiceProvider.swift
//  Cats
//
//  Created by Wallace Silva on 02/02/23.
//

import Foundation

struct ServiceProvider {
    private let apiKey: String

    private let url = URL(string: "https://api.pexels.com/v1/search?query=cats&per_page=80")

    init() {
        guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
            self.apiKey = ""
            print("WARNING! Set the `API_KEY` environment variable. The Pexels API needs it to return photos. See the README.")
            return
        }
        self.apiKey = apiKey
    }
}

extension ServiceProvider: ServiceProviding {

    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    private var request: URLRequest? {
        guard let url else { return nil }
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        return request
    }

    func fetchImages(with completion: @escaping (Result<PhotoSearchResponse, ServiceError>) -> Void) {
        guard let request else { return completion(.failure(.requestCreation)) }

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error {
                return completion(.failure(.requestError(error.localizedDescription)))
            }

            guard let data else { return completion(.failure(.decode)) }

            do {
                completion(.success(try decoder.decode(PhotoSearchResponse.self, from: data)))
            } catch {
                tryToDecodeErrorResponse(for: data, with: completion)
            }
        }
        .resume()
    }

    /// A failed request still returns a body, and it explains itself far better
    /// than a decoding failure does — "Invalid API key", say.
    private func tryToDecodeErrorResponse(for data: Data,
                                          with completion: @escaping (Result<PhotoSearchResponse, ServiceError>) -> Void) {
        do {
            let response = try decoder.decode(PhotoSearchErrorResponse.self, from: data)
            completion(.failure(.requestError(response.message)))
        } catch {
            completion(.failure(.decode))
        }
    }
}
