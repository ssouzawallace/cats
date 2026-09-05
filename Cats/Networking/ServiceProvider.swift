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

    func fetchImages() async throws -> PhotoSearchResponse {
        guard let request else { throw ServiceError.requestCreation }

        let data: Data
        do {
            (data, _) = try await URLSession.shared.data(for: request)
        } catch {
            throw ServiceError.requestError(error.localizedDescription)
        }

        do {
            return try decoder.decode(PhotoSearchResponse.self, from: data)
        } catch {
            // A failed request still returns a body, and it explains itself far
            // better than a decoding failure does — "Invalid API key", say.
            guard let response = try? decoder.decode(PhotoSearchErrorResponse.self, from: data) else {
                throw ServiceError.decode
            }
            throw ServiceError.requestError(response.message)
        }
    }
}
