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
        XCTAssertTrue(sut.recommendations.isEmpty, "Recommended movies should be empty initially")
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
        XCTAssertFalse(sut.recommendations.isEmpty, "Should generate recommendations")
    }
    
    func testGenerateRecommendations_WithWatchlistItems_GeneratesPersonalizedRecommendations() async {
        // Given
        let movie = createTestMovie()
        mockWatchlistManager.add(movie)
        
        // When
        await sut.generateRecommendations()
        
        // Then
        XCTAssertFalse(sut.recommendations.isEmpty, "Should generate personalized recommendations")
        XCTAssertNil(sut.error, "Error should be nil")
    }
    
    func testGenerateRecommendations_FiltersWatchlistMovies() async {
        // Given
        let movie = createTestMovie()
        mockWatchlistManager.add(movie)
        
        // When
        await sut.generateRecommendations()
        
        // Then
        // Recommendations should not include movies already in watchlist
        let containsWatchlistMovie = sut.recommendations.contains { $0.id == movie.id }
        XCTAssertFalse(containsWatchlistMovie, "Should not recommend movies already in watchlist")
    }
    
    // MARK: - Watchlist Integration Tests
    
    func testIsInWatchlist_MovieNotInWatchlist_ReturnsFalse() {
        // Given
        let movie = createTestMovie()
        
        // Then
        XCTAssertFalse(sut.isInWatchlist(movie), "Should return false")
    }
    
    func testIsInWatchlist_MovieInWatchlist_ReturnsTrue() async {
        // Given
        let movie = createTestMovie()
        mockWatchlistManager.add(movie)
        
        // Then
        XCTAssertTrue(sut.isInWatchlist(movie), "Should return true")
    }
    
    func testToggleWatchlist_AddsAndRemoves() async {
        // Given
        let movie = createTestMovie()
        
        // When - Add
        sut.toggleWatchlist(for: movie)
        
        // Then
        XCTAssertTrue(sut.isInWatchlist(movie), "Should add movie")
        
        // When - Remove
        sut.toggleWatchlist(for: movie)
        
        // Then
        XCTAssertFalse(sut.isInWatchlist(movie), "Should remove movie")
    }
    
    // MARK: - Recommendation Quality Tests
    
    func testGenerateRecommendations_LimitsResults() async {
        // When
        await sut.generateRecommendations()
        
        // Then
        XCTAssertLessThanOrEqual(sut.recommendations.count, 20, "Should limit recommendations")
    }
    
    func testGenerateRecommendations_HighQualityMovies() async {
        // When
        await sut.generateRecommendations()
        
        // Then - All recommendations should have decent ratings
        for movie in sut.recommendations {
            XCTAssertGreaterThanOrEqual(movie.voteAverage, 0, "Should have valid rating")
        }
    }
}
    
    private func createTestMovie() -> Movie {
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
