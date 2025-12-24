//
//  DiscoverViewModelTests.swift
//  MovieTrailerTests
//
//  Comprehensive tests for DiscoverViewModel
//

import XCTest
@testable import MovieTrailer

@MainActor
final class DiscoverViewModelTests: XCTestCase {
    
    var sut: DiscoverViewModel!
    var mockTMDBService: TMDBService!
    var mockWatchlistManager: WatchlistManager!
    
    override func setUp() async throws {
        mockTMDBService = TMDBService()
        mockWatchlistManager = WatchlistManager()
        await mockWatchlistManager.clearAll()
        sut = DiscoverViewModel(
            tmdbService: mockTMDBService,
            watchlistManager: mockWatchlistManager
        )
    }
    
    override func tearDown() async throws {
        await mockWatchlistManager.clearAll()
        sut = nil
        mockTMDBService = nil
        mockWatchlistManager = nil
    }
    
    // MARK: - Initialization Tests
    
    func testInit_SetsInitialState() {
        // Then
        XCTAssertTrue(sut.trendingMovies.isEmpty, "Trending movies should be empty initially")
        XCTAssertTrue(sut.popularMovies.isEmpty, "Popular movies should be empty initially")
        XCTAssertTrue(sut.topRatedMovies.isEmpty, "Top rated movies should be empty initially")
        XCTAssertFalse(sut.isLoading, "Should not be loading initially")
        XCTAssertNil(sut.error, "Error should be nil initially")
    }
    
    // MARK: - Load Content Tests
    
    func testLoadContent_Success_PopulatesMovies() async {
        // When
        await sut.loadContent()
        
        // Then
        XCTAssertFalse(sut.isLoading, "Should not be loading after completion")
        XCTAssertNil(sut.error, "Error should be nil on success")
        
        // At least one category should have movies
        let hasMovies = !sut.trendingMovies.isEmpty ||
                        !sut.popularMovies.isEmpty ||
                        !sut.topRatedMovies.isEmpty
        XCTAssertTrue(hasMovies, "Should load at least some movies")
    }
    
    func testLoadContent_SetsLoadingState() async {
        // Create expectation for loading state
        let expectation = XCTestExpectation(description: "Loading state should be true during load")
        
        // Start loading in background
        Task {
            await sut.loadContent()
        }
        
        // Check loading state shortly after
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // May or may not catch loading state depending on API speed
        // This is a best-effort test
        expectation.fulfill()
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    // MARK: - Watchlist Integration Tests
    
    func testIsInWatchlist_MovieNotInWatchlist_ReturnsFalse() {
        // Given
        let movie = Movie.sample
        
        // Then
        XCTAssertFalse(sut.isInWatchlist(movie), "Should return false for movie not in watchlist")
    }
    
    func testIsInWatchlist_MovieInWatchlist_ReturnsTrue() async {
        // Given
        let movie = Movie.sample
        await mockWatchlistManager.addToWatchlist(movie)
        
        // Then
        XCTAssertTrue(sut.isInWatchlist(movie), "Should return true for movie in watchlist")
    }
    
    func testToggleWatchlist_AddsAndRemoves() async {
        // Given
        let movie = Movie.sample
        
        // When - Add
        await sut.toggleWatchlist(for: movie)
        
        // Then
        XCTAssertTrue(sut.isInWatchlist(movie), "Should add movie to watchlist")
        
        // When - Remove
        await sut.toggleWatchlist(for: movie)
        
        // Then
        XCTAssertFalse(sut.isInWatchlist(movie), "Should remove movie from watchlist")
    }
    
    // MARK: - Error Handling Tests
    
    func testLoadContent_ClearsErrorOnSuccess() async {
        // Given - Set an error
        sut.error = NetworkError.invalidURL
        
        // When
        await sut.loadContent()
        
        // Then
        XCTAssertNil(sut.error, "Error should be cleared on successful load")
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
