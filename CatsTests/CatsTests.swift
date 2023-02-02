//
//  CatsTests.swift
//  CatsTests
//
//  Created by Wallace Silva on 02/02/23.
//

import XCTest
@testable import Cats

final class CatsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModelSuccess() throws {
        struct MockView: CatsGalleryView {
            let expectation: XCTestExpectation
            
            func present(cats: [Cats.CatModel]) {
                expectation.fulfill()
            }
            func present(errorMessage: String) {
                
            }
        }
        struct MockProvider: ServiceProviding {
            func fetchImages(with completion: @escaping (Result<GallerySearchResponse, ServiceError>) -> Void) {
                completion(.success(GallerySearchResponse(data: [], success: true, status: 200)))
            }
        }
        
        let expectation = self.expectation(description: "Request Success")
        let mockView = MockView(expectation: expectation)
        let mockProvider = MockProvider()
        let viewModel = CatsViewModel(view: mockView,
                                      provider: mockProvider)

        viewModel.fetchImages()
        wait(for: [expectation], timeout: 5)
    }
    
    func testViewModelFailure() throws {
        struct MockView: CatsGalleryView {
            let expectation: XCTestExpectation
            
            func present(cats: [Cats.CatModel]) {
                
            }
            func present(errorMessage: String) {
                let expectedMessage = "There was an error with the request\n" + "Error"
                XCTAssertEqual(errorMessage, expectedMessage)
                expectation.fulfill()
            }
        }
        struct MockProvider: ServiceProviding {
            func fetchImages(with completion: @escaping (Result<GallerySearchResponse, ServiceError>) -> Void) {
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
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
