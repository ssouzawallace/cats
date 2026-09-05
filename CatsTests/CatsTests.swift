//
//  CatsTests.swift
//  CatsTests
//
//  Created by Wallace Silva on 02/02/23.
//

import XCTest
@testable import Cats

final class CatsTests: XCTestCase {

    func testViewModelSuccess() throws {
        final class MockView: CatsGalleryView {
            let expectation: XCTestExpectation

            init(expectation: XCTestExpectation) {
                self.expectation = expectation
            }
            
            func present(cats: [Cats.Cat]) {
                expectation.fulfill()
            }
            func present(errorMessage: String) {
                
            }
        }
        struct MockProvider: ServiceProviding {
            func fetchImages(with completion: @escaping (Result<PhotoSearchResponse, ServiceError>) -> Void) {
                completion(.success(PhotoSearchResponse(photos: [], page: 1, perPage: 0, totalResults: 0)))
            }
        }
        
        let expectation = self.expectation(description: "Request Success")
        let mockView = MockView(expectation: expectation)
        let mockProvider = MockProvider()
        let viewModel = CatsViewModel(view: mockView,
                                      provider: mockProvider)

        viewModel.fetchImages()
        wait(for: [expectation], timeout: 5)

        // The view model holds the view weakly, so the mock has to be kept
        // alive until the callback has run.
        withExtendedLifetime(mockView) { }
    }
    
    func testViewModelFailure() throws {
        final class MockView: CatsGalleryView {
            let expectation: XCTestExpectation

            init(expectation: XCTestExpectation) {
                self.expectation = expectation
            }
            
            func present(cats: [Cats.Cat]) {
                
            }
            func present(errorMessage: String) {
                let expectedMessage = "There was an error with the request\n" + "Error"
                XCTAssertEqual(errorMessage, expectedMessage)
                expectation.fulfill()
            }
        }
        struct MockProvider: ServiceProviding {
            func fetchImages(with completion: @escaping (Result<PhotoSearchResponse, ServiceError>) -> Void) {
                completion(.failure(.requestError("Error")))
            }
        }
        let expectation = self.expectation(description: "Request Failure")
        let mockView = MockView(expectation: expectation)
        let mockProvider = MockProvider()
        let viewModel = CatsViewModel(view: mockView,
                                      provider: mockProvider)
        
        viewModel.fetchImages()
        wait(for: [expectation], timeout: 5)

        // The view model holds the view weakly, so the mock has to be kept
        // alive until the callback has run.
        withExtendedLifetime(mockView) { }
    }

}
