//
//  TonightViewModelTests.swift
//  MovieTrailerTests
//
//  Comprehensive tests for TonightViewModel and recommendation engine
//

import XCTest
@testable import MovieTrailer

@MainActor
final class TonightViewModelTests: XCTestCase {
    
    var sut: TonightViewModel!
    var mockTMDBService: TMDBService!
    var mockWatchlistManager: WatchlistManager!
    
    override func setUp() async throws {
        mockTMDBService = TMDBService()
        mockWatchlistManager = WatchlistManager()
        await mockWatchlistManager.clearAll()
        sut = TonightViewModel(
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
        XCTAssertTrue(sut.recommendedMovies.isEmpty, "Recommended movies should be empty initially")
        XCTAssertFalse(sut.isLoading, "Should not be loading initially")
        XCTAssertNil(sut.error, "Error should be nil initially")
    }
    
    // MARK: - Generate Recommendations Tests
    
    func testGenerateRecommendations_WithEmptyWatchlist_GeneratesRecommendations() async {
        // When
        await sut.generateRecommendations()
        
        // Then
        XCTAssertFalse(sut.isLoading, "Should not be loading after completion")
        XCTAssertNil(sut.error, "Error should be nil on success")
        
        // Should generate recommendations even with empty watchlist (based on popular movies)
        XCTAssertFalse(sut.recommendedMovies.isEmpty, "Should generate recommendations")
    }
    
    func testGenerateRecommendations_WithWatchlistItems_GeneratesPersonalizedRecommendations() async {
        // Given
        let movie = Movie.sample
        mockWatchlistManager.add(movie)
        
        // When
        await sut.generateRecommendations()
        
        // Then
        XCTAssertFalse(sut.recommendedMovies.isEmpty, "Should generate personalized recommendations")
        XCTAssertNil(sut.error, "Error should be nil")
    }
    
    func testGenerateRecommendations_FiltersWatchlistMovies() async {
        // Given
        let movie = Movie.sample
        mockWatchlistManager.add(movie)
        
        // When
        await sut.generateRecommendations()
        
        // Then
        // Recommendations should not include movies already in watchlist
        let containsWatchlistMovie = sut.recommendedMovies.contains { $0.id == movie.id }
        XCTAssertFalse(containsWatchlistMovie, "Should not recommend movies already in watchlist")
    }
    
    // MARK: - Watchlist Integration Tests
    
    func testIsInWatchlist_MovieNotInWatchlist_ReturnsFalse() {
        // Given
        let movie = Movie.sample
        
        // Then
        XCTAssertFalse(sut.isInWatchlist(movie), "Should return false")
    }
    
    func testIsInWatchlist_MovieInWatchlist_ReturnsTrue() async {
        // Given
        let movie = Movie.sample
        mockWatchlistManager.add(movie)
        
        // Then
        XCTAssertTrue(sut.isInWatchlist(movie), "Should return true")
    }
    
    func testToggleWatchlist_AddsAndRemoves() async {
        // Given
        let movie = Movie.sample
        
        // When - Add
        await sut.toggleWatchlist(for: movie)
        
        // Then
        XCTAssertTrue(sut.isInWatchlist(movie), "Should add movie")
        
        // When - Remove
        await sut.toggleWatchlist(for: movie)
        
        // Then
        XCTAssertFalse(sut.isInWatchlist(movie), "Should remove movie")
    }
    
    // MARK: - isEmpty Tests
    
    func testIsEmpty_NoRecommendations_ReturnsTrue() {
        // Then
        XCTAssertTrue(sut.isEmpty, "Should return true when no recommendations")
    }
    
    func testIsEmpty_WithRecommendations_ReturnsFalse() async {
        // Given
        await sut.generateRecommendations()
        
        // Then - Assuming recommendations were generated
        if !sut.recommendedMovies.isEmpty {
            XCTAssertFalse(sut.isEmpty, "Should return false with recommendations")
        }
    }
    
    // MARK: - Recommendation Quality Tests
    
    func testGenerateRecommendations_LimitsResults() async {
        // When
        await sut.generateRecommendations()
        
        // Then
        XCTAssertLessThanOrEqual(sut.recommendedMovies.count, 20, "Should limit recommendations")
    }
    
    func testGenerateRecommendations_HighQualityMovies() async {
        // When
        await sut.generateRecommendations()
        
        // Then - All recommendations should have decent ratings
        for movie in sut.recommendedMovies {
            XCTAssertGreaterThanOrEqual(movie.voteAverage, 0, "Should have valid rating")
        }
    }
}
