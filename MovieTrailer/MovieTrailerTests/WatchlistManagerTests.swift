//
//  WatchlistManagerTests.swift
//  MovieTrailerTests
//
//  Comprehensive tests for WatchlistManager
//

import XCTest
@testable import MovieTrailer

@MainActor
final class WatchlistManagerTests: XCTestCase {
    
    var sut: WatchlistManager!
    var testMovie: Movie!
    
    override func setUp() async throws {
        sut = WatchlistManager()
        await sut.clearAll() // Start fresh
        
        testMovie = Movie(
            id: 999,
            title: "Test Movie",
            overview: "Test Overview",
            posterPath: "/test.jpg",
            backdropPath: nil,
            releaseDate: "2024-01-01",
            voteAverage: 8.0,
            voteCount: 100,
            popularity: 50.0,
            genreIds: [28],
            adult: false,
            originalLanguage: "en",
            originalTitle: "Test Movie",
            video: false
        )
    }
    
    override func tearDown() async {
        await sut.clearAll()
        sut = nil
        testMovie = nil
    }
    
    // MARK: - Add to Watchlist Tests
    
    func testAddToWatchlist_NewMovie_AddsSuccessfully() async {
        // When
        await sut.addToWatchlist(testMovie)
        
        // Then
        XCTAssertTrue(sut.isInWatchlist(testMovie), "Movie should be in watchlist")
        XCTAssertEqual(sut.count, 1, "Watchlist count should be 1")
    }
    
    func testAddToWatchlist_DuplicateMovie_DoesNotAddTwice() async {
        // Given
        await sut.addToWatchlist(testMovie)
        
        // When
        await sut.addToWatchlist(testMovie)
        
        // Then
        XCTAssertEqual(sut.count, 1, "Should not add duplicate")
    }
    
    func testAddToWatchlist_MultipleMovies_AddsAll() async {
        // Given
        let movie2 = Movie(
            id: 1000,
            title: "Movie 2",
            overview: "Overview 2",
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
        
        // When
        await sut.addToWatchlist(testMovie)
        await sut.addToWatchlist(movie2)
        
        // Then
        XCTAssertEqual(sut.count, 2, "Should have 2 movies")
        XCTAssertTrue(sut.isInWatchlist(testMovie), "First movie should be in watchlist")
        XCTAssertTrue(sut.isInWatchlist(movie2), "Second movie should be in watchlist")
    }
    
    // MARK: - Remove from Watchlist Tests
    
    func testRemoveFromWatchlist_ExistingMovie_RemovesSuccessfully() async {
        // Given
        await sut.addToWatchlist(testMovie)
        
        // When
        await sut.removeFromWatchlist(testMovie)
        
        // Then
        XCTAssertFalse(sut.isInWatchlist(testMovie), "Movie should not be in watchlist")
        XCTAssertEqual(sut.count, 0, "Watchlist should be empty")
    }
    
    func testRemoveFromWatchlist_NonExistentMovie_NoError() async {
        // When
        await sut.removeFromWatchlist(testMovie)
        
        // Then
        XCTAssertEqual(sut.count, 0, "Watchlist should still be empty")
    }
    
    // MARK: - Toggle Watchlist Tests
    
    func testToggleWatchlist_NotInList_Adds() async {
        // When
        await sut.toggleWatchlist(for: testMovie)
        
        // Then
        XCTAssertTrue(sut.isInWatchlist(testMovie), "Movie should be added")
    }
    
    func testToggleWatchlist_InList_Removes() async {
        // Given
        await sut.addToWatchlist(testMovie)
        
        // When
        await sut.toggleWatchlist(for: testMovie)
        
        // Then
        XCTAssertFalse(sut.isInWatchlist(testMovie), "Movie should be removed")
    }
    
    // MARK: - IsInWatchlist Tests
    
    func testIsInWatchlist_MovieInList_ReturnsTrue() async {
        // Given
        await sut.addToWatchlist(testMovie)
        
        // Then
        XCTAssertTrue(sut.isInWatchlist(testMovie), "Should return true for movie in watchlist")
    }
    
    func testIsInWatchlist_MovieNotInList_ReturnsFalse() {
        // Then
        XCTAssertFalse(sut.isInWatchlist(testMovie), "Should return false for movie not in watchlist")
    }
    
    // MARK: - Clear All Tests
    
    func testClearAll_WithMovies_RemovesAll() async {
        // Given
        await sut.addToWatchlist(testMovie)
        let movie2 = Movie(
            id: 1000,
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
        await sut.addToWatchlist(movie2)
        
        // When
        await sut.clearAll()
        
        // Then
        XCTAssertEqual(sut.count, 0, "Watchlist should be empty")
        XCTAssertFalse(sut.isInWatchlist(testMovie), "No movies should be in watchlist")
    }
    
    // MARK: - Count Tests
    
    func testCount_EmptyWatchlist_ReturnsZero() {
        // Then
        XCTAssertEqual(sut.count, 0, "Empty watchlist should have count 0")
    }
    
    func testCount_WithMovies_ReturnsCorrectCount() async {
        // Given
        await sut.addToWatchlist(testMovie)
        
        // Then
        XCTAssertEqual(sut.count, 1, "Count should match number of movies")
    }
    
    // MARK: - Items Tests
    
    func testItems_EmptyWatchlist_ReturnsEmptyArray() {
        // Then
        XCTAssertTrue(sut.items.isEmpty, "Items should be empty array")
    }
    
    func testItems_WithMovies_ReturnsAllItems() async {
        // Given
        await sut.addToWatchlist(testMovie)
        
        // Then
        XCTAssertEqual(sut.items.count, 1, "Should return all items")
        XCTAssertEqual(sut.items.first?.id, testMovie.id, "Should contain correct movie")
    }
    
    // MARK: - isEmpty Tests
    
    func testIsEmpty_EmptyWatchlist_ReturnsTrue() {
        // Then
        XCTAssertTrue(sut.isEmpty, "Empty watchlist should return true")
    }
    
    func testIsEmpty_WithMovies_ReturnsFalse() async {
        // Given
        await sut.addToWatchlist(testMovie)
        
        // Then
        XCTAssertFalse(sut.isEmpty, "Watchlist with movies should return false")
    }
}
