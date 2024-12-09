//
//  TestAssigmentDemoTests.swift
//  TestAssigmentDemoTests
//
//  Created by ginger on 05/12/24.
//

import XCTest
import CoreData
@testable import TestAssigmentDemo

final class TestAssigmentDemoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        try? super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try? super.tearDownWithError()
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        self.measure {
            // Put the code you want to measure here
            _ = (1...1000).map { $0 * 2 } // Example workload
        }
    }
    
    func testSearchMoviesSuccess() throws {
        // Arrange
        let mockService = MockMovieService()
        mockService.shouldReturnError = false
        let expectation = self.expectation(description: "Movies fetched successfully")
        
        // Act
        mockService.searchMovies(query: "Avengers") { result in
            // Assert
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.count, 1)
                XCTAssertEqual(movies.first?.title, "Mock Movie")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testSaveFavoriteMovie() throws {
        // Arrange
        let coreDataManager = CoreDataManager(inMemory: true)
        let movie = Movie(id: 1, title: "Test Movie", posterPath: nil, releaseDate: "2023-01-01", overview: "Test Overview", rating: 7.5)

        // Act
        coreDataManager.saveFavorite(movie: movie)
        let favorites = coreDataManager.fetchFavorites()

        // Assert
        XCTAssertEqual(favorites.count, 1)
        XCTAssertEqual(favorites.first?.title, "Test Movie")
    }
    
    func testEmptySearchQuery() throws {
        // Arrange
        let mockService = MockMovieService()
        mockService.shouldReturnError = true
        let expectation = self.expectation(description: "Handled empty search query")
        
        // Act
        mockService.searchMovies(query: "") { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Mock error")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    

}


class CoreDataManagerTests: XCTestCase {
    var coreDataManager: CoreDataManager!

    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager(inMemory: true)
    }

    func testSaveFavorite() {
        let movie = Movie(id: 1, title: "Test Movie", posterPath: nil, releaseDate: "2023-01-01", overview: "Test Overview", rating: 7.5)
        coreDataManager.saveFavorite(movie: movie)

        let favorites = coreDataManager.fetchFavorites()
        XCTAssertEqual(favorites.count, 1)
        XCTAssertEqual(favorites.first?.title, "Test Movie")
    }

    func testRemoveFavorite() {
        let movie = Movie(id: 1, title: "Test Movie", posterPath: nil, releaseDate: "2023-01-01", overview: "Test Overview", rating: 7.5)
        coreDataManager.saveFavorite(movie: movie)
        coreDataManager.removeFavorite(movieId: 1)

        let favorites = coreDataManager.fetchFavorites()
        XCTAssertTrue(favorites.isEmpty)
    }
}

extension CoreDataManager {
    convenience init(inMemory: Bool) {
        self.init(inMemory: false)
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            persistentContainer.persistentStoreDescriptions = [description]
        }
    }
}
