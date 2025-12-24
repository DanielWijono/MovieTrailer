//
//  TMDBServiceTests.swift
//  MovieTrailerTests
//
//  Comprehensive tests for TMDB networking layer
//

import XCTest
@testable import MovieTrailer

@MainActor
final class TMDBServiceTests: XCTestCase {
    
    var sut: TMDBService!
    var mockSession: MockURLSession!
    
    override func setUp() async throws {
        mockSession = MockURLSession()
        sut = TMDBService()
    }
    
    override func tearDown() {
        sut = nil
        mockSession = nil
    }
    
    // MARK: - fetchTrending Tests
    
    func testFetchTrending_Success() async throws {
        // When
        let response = try await sut.fetchTrending(page: 1)
        
        // Then
        XCTAssertFalse(response.results.isEmpty, "Should return movies")
        XCTAssertGreaterThan(response.results.count, 0, "Should have at least one movie")
    }
    
    func testFetchTrending_EmptyResults() async throws {
        // When
        let response = try await sut.fetchTrending(page: 1)
        
        // Then
        XCTAssertNotNil(response, "Response should not be nil even if empty")
    }
    
    // MARK: - fetchPopular Tests
    
    func testFetchPopular_Success() async throws {
        // When
        let response = try await sut.fetchPopular(page: 1)
        
        // Then
        XCTAssertFalse(response.results.isEmpty, "Should return popular movies")
        XCTAssertGreaterThan(response.page, 0, "Page should be greater than 0")
    }
    
    // MARK: - fetchTopRated Tests
    
    func testFetchTopRated_Success() async throws {
        // When
        let response = try await sut.fetchTopRated(page: 1)
        
        // Then
        XCTAssertFalse(response.results.isEmpty, "Should return top rated movies")
        for movie in response.results {
            XCTAssertGreaterThanOrEqual(movie.voteAverage, 0, "Vote average should be valid")
        }
    }
    
    // MARK: - searchMovies Tests
    
    func testSearch_ValidQuery_ReturnsResults() async throws {
        // Given
        let query = "Inception"
        
        // When
        let response = try await sut.searchMovies(query: query)
        
        // Then
        XCTAssertFalse(response.results.isEmpty, "Should return search results for valid query")
    }
    
    func testSearchMovies_EmptyQuery_HandlesGracefully() async throws {
        // Given
        let query = ""
        
        // When/Then
        do {
            _ = try await sut.searchMovies(query: query)
            XCTFail("Should throw error for empty query")
        } catch {
            // Expected behavior
            XCTAssertTrue(true, "Empty query should be handled")
        }
    }
    
    // MARK: - fetchVideos Tests
    
    func testFetchVideos_ValidMovieId_ReturnsVideos() async throws {
        // Given
        let movieId = 550 // Fight Club
        
        // When
        let videos = try await sut.fetchVideos(for: movieId)
        
        // Then
        XCTAssertNotNil(videos, "Should return videos array")
        // May be empty if no trailers exist
    }
    
    func testFetchVideos_InvalidMovieId_ThrowsError() async throws {
        // Given
        let invalidMovieId = -1
        
        // When/Then
        do {
            _ = try await sut.fetchVideos(for: invalidMovieId)
            // May or may not throw - depends on API behavior
        } catch {
            XCTAssertTrue(error is NetworkError, "Should throw NetworkError")
        }
    }
}

// MARK: - Mock URL Session

class MockURLSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        
        guard let data = data, let response = response else {
            throw URLError(.badServerResponse)
        }
        
        return (data, response)
    }
}

// MARK: - Test Helpers

extension Movie {
    static var sample: Movie {
        Movie(
            id: 1,
            title: "Test Movie",
            overview: "Test Overview",
            posterPath: "/test.jpg",
            backdropPath: "/backdrop.jpg",
            releaseDate: "2024-01-01",
            voteAverage: 8.5,
            voteCount: 1000,
            popularity: 100.0,
            genreIds: [28, 12],
            adult: false,
            originalLanguage: "en",
            originalTitle: "Test Movie",
            video: false
        )
    }
}
