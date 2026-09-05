//
//  CatsTests.swift
//  CatsTests
//
//  Created by Wallace Silva on 02/02/23.
//

import XCTest
@testable import Cats

@MainActor
final class CatsTests: XCTestCase {

    /// Records what the view model asked the view to show.
    private final class SpyView: CatsGalleryView {
        private(set) var cats: [Cat]?
        private(set) var errorMessage: String?

        func present(cats: [Cat]) {
            self.cats = cats
        }

        func present(errorMessage: String) {
            self.errorMessage = errorMessage
        }
    }

    private struct StubProvider: ServiceProviding {
        let result: Result<PhotoSearchResponse, ServiceError>

        func fetchImages() async throws -> PhotoSearchResponse {
            try result.get()
        }
    }

    func testPresentsTheCatsFromASuccessfulResponse() async {
        let response = PhotoSearchResponse(photos: [], page: 1, perPage: 0, totalResults: 0)
        let view = SpyView()
        let viewModel = CatsViewModel(view: view, provider: StubProvider(result: .success(response)))

        await viewModel.fetchImages()

        XCTAssertEqual(view.cats?.count, 0)
        XCTAssertNil(view.errorMessage)
    }

    func testPresentsTheDescriptionOfAFailure() async {
        let view = SpyView()
        let viewModel = CatsViewModel(view: view,
                                      provider: StubProvider(result: .failure(.requestError("Error"))))

        await viewModel.fetchImages()

        XCTAssertEqual(view.errorMessage, "There was an error with the request\nError")
        XCTAssertNil(view.cats)
    }
}
