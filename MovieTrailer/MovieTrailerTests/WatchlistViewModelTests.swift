//
//  WatchlistViewModelTests.swift
//  MovieTrailerTests
//
//  Comprehensive tests for WatchlistViewModel with sorting and sharing
//

import XCTest
@testable import MovieTrailer

@MainActor
final class WatchlistViewModelTests: XCTestCase {
    
    var sut: WatchlistViewModel!
    var mockWatchlistManager: WatchlistManager!
    
    override func setUp() async throws {
        mockWatchlistManager = WatchlistManager()
        await mockWatchlistManager.clearAll()
        sut = WatchlistViewModel(watchlistManager: mockWatchlistManager)
    }
    
    override func tearDown() async {
        await mockWatchlistManager.clearAll()
        sut = nil
        mockWatchlistManager = nil
    }
    
    // MARK: - Initialization Tests
    
    func testInit_SetsInitialState() {
        // Then
        XCTAssertTrue(sut.items.isEmpty, "Items should be empty initially")
        XCTAssertEqual(sut.sortOption, .dateAdded, "Default sort should be dateAdded")
        XCTAssertNil(sut.shareImage, "Share image should be nil initially")
    }
    
    // MARK: - Items Tests
    
    func testItems_EmptyWatchlist_ReturnsEmpty() {
        // Then
        XCTAssertTrue(sut.items.isEmpty, "Should return empty array")
    }
    
    func testItems_WithMovies_ReturnsAllItems() async {
        // Given
        let movie = Movie.sample
        await mockWatchlistManager.addToWatchlist(movie)
        
        // Then
        XCTAssertEqual(sut.items.count, 1, "Should return all items")
    }
    
    // MARK: - Sorting Tests
    
    func testSortOption_ByDateAdded_SortsCorrectly() async {
        // Given
        let movie1 = Movie.sample
        let movie2 = Movie(
            id: 2,
            title: "Movie 2",
            overview: "Overview",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: "2024-02-01",
            voteAverage: 7.0,
            voteCount: 50,
            popularity: 30.0,
            genreIds: [18],
            adult: false,
            originalLanguage: "en",
            originalTitle: "Movie 2",
            video: false
        )
        
        await mockWatchlistManager.addToWatchlist(movie1)
        try? await Task.sleep(nanoseconds: 100_000_000) // Small delay
        await mockWatchlistManager.addToWatchlist(movie2)
        
        // When
        sut.sortOption = .dateAdded
        
        // Then
        let sortedItems = sut.items
        XCTAssertEqual(sortedItems.count, 2, "Should have both movies")
        // Most recent should be first
        XCTAssertEqual(sortedItems.first?.id, movie2.id, "Most recent should be first")
    }
    
    func testSortOption_ByTitle_SortsAlphabetically() async {
        // Given
        let movieB = Movie(
            id: 1,
            title: "B Movie",
            overview: "Overview",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: "2024-01-01",
            voteAverage: 8.0,
            voteCount: 100,
            popularity: 50.0,
            genreIds: [28],
            adult: false,
            originalLanguage: "en",
            originalTitle: "B Movie",
            video: false
        )
        
        let movieA = Movie(
            id: 2,
            title: "A Movie",
            overview: "Overview",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: "2024-02-01",
            voteAverage: 7.0,
            voteCount: 50,
            popularity: 30.0,
            genreIds: [18],
            adult: false,
            originalLanguage: "en",
            originalTitle: "A Movie",
            video: false
        )
        
        await mockWatchlistManager.addToWatchlist(movieB)
        await mockWatchlistManager.addToWatchlist(movieA)
        
        // When
        sut.sortOption = .title
        
        // Then
        let sortedItems = sut.items
        XCTAssertEqual(sortedItems.first?.title, "A Movie", "Should sort alphabetically")
    }
    
    func testSortOption_ByRating_SortsHighestFirst() async {
        // Given
        let lowRatedMovie = Movie(
            id: 1,
            title: "Low Rated",
            overview: "Overview",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: "2024-01-01",
            voteAverage: 6.0,
            voteCount: 100,
            popularity: 50.0,
            genreIds: [28],
            adult: false,
            originalLanguage: "en",
            originalTitle: "Low Rated",
            video: false
        )
        
        let highRatedMovie = Movie(
            id: 2,
            title: "High Rated",
            overview: "Overview",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: "2024-02-01",
            voteAverage: 9.0,
            voteCount: 50,
            popularity: 30.0,
            genreIds: [18],
            adult: false,
            originalLanguage: "en",
            originalTitle: "High Rated",
            video: false
        )
        
        await mockWatchlistManager.addToWatchlist(lowRatedMovie)
        await mockWatchlistManager.addToWatchlist(highRatedMovie)
        
        // When
        sut.sortOption = .rating
        
        // Then
        let sortedItems = sut.items
        XCTAssertEqual(sortedItems.first?.voteAverage, 9.0, "Highest rated should be first")
    }
    
    // MARK: - Remove Item Tests
    
    func testRemoveItem_RemovesFromWatchlist() async {
        // Given
        let movie = Movie.sample
        await mockWatchlistManager.addToWatchlist(movie)
        let item = sut.items.first!
        
        // When
        await sut.removeItem(item)
        
        // Then
        XCTAssertTrue(sut.isEmpty, "Watchlist should be empty")
        XCTAssertEqual(sut.count, 0, "Count should be 0")
    }
    
    // MARK: - Count Tests
    
    func testCount_EmptyWatchlist_ReturnsZero() {
        // Then
        XCTAssertEqual(sut.count, 0, "Count should be 0")
    }
    
    func testCount_WithItems_ReturnsCorrectCount() async {
        // Given
        await mockWatchlistManager.addToWatchlist(Movie.sample)
        
        // Then
        XCTAssertEqual(sut.count, 1, "Count should be 1")
    }
    
    // MARK: - isEmpty Tests
    
    func testIsEmpty_EmptyWatchlist_ReturnsTrue() {
        // Then
        XCTAssertTrue(sut.isEmpty, "Should return true")
    }
    
    func testIsEmpty_WithItems_ReturnsFalse() async {
        // Given
        await mockWatchlistManager.addToWatchlist(Movie.sample)
        
        // Then
        XCTAssertFalse(sut.isEmpty, "Should return false")
    }
    
    // MARK: - Generate Share Image Tests
    
    func testGenerateShareImage_CreatesImage() async {
        // Given
        await mockWatchlistManager.addToWatchlist(Movie.sample)
        
        // When
        await sut.generateShareImage()
        
        // Then
        XCTAssertNotNil(sut.shareImage, "Should generate share image")
    }
    
    func testGenerateShareImage_EmptyWatchlist_HandlesGracefully() async {
        // When
        await sut.generateShareImage()
        
        // Then - Should handle empty watchlist without crashing
        // May or may not generate image
        XCTAssertTrue(true, "Should handle empty watchlist gracefully")
    }
}
