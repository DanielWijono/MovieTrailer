//
//  SearchView.swift
//  MovieTrailer
//
//  Created by Daniel Wijono on 10/12/2025.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject private var viewModel: SearchViewModel
    @FocusState private var isSearchFocused: Bool
    let onMovieTap: (Movie) -> Void
    
    init(viewModel: SearchViewModel, onMovieTap: @escaping (Movie) -> Void = { _ in }) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onMovieTap = onMovieTap
    }
    
    var body: some View {
        ZStack {
            // Glassmorphism animated background
            GlassBackgroundView()
            
            VStack(spacing: 0) {
                // Premium glass search bar
                searchBar
                    .padding(.top, 8)
                
                // Content
                if viewModel.isSearching {
                    LoadingView()
                } else if let error = viewModel.error, !viewModel.searchResults.isEmpty {
                    ErrorView(error: error) {
                        viewModel.search()
                    }
                } else if viewModel.searchQuery.isEmpty {
                    emptySearchState
                } else if viewModel.searchResults.isEmpty {
                    noResultsState
                } else {
                    searchResultsView
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Search Bar
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.title3)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                TextField("Search movies...", text: $viewModel.searchQuery)
                    .textFieldStyle(.plain)
                    .foregroundColor(.white)
                    .focused($isSearchFocused)
                    .autocorrectionDisabled()
                    .onChange(of: viewModel.searchQuery) { _ in
                        viewModel.search()
                    }
                
                if !viewModel.searchQuery.isEmpty {
                    Button {
                        viewModel.clearSearch()
                        isSearchFocused = true
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .glassCard()
        }
        .padding(.horizontal)
    }
    
    // MARK: - Search Results
    
    private var searchResultsView: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ],
                spacing: 20
            ) {
                ForEach(viewModel.searchResults) { movie in
                    MovieCard(
                        movie: movie,
                        isInWatchlist: viewModel.isInWatchlist(movie),
                        onTap: {
                            onMovieTap(movie)
                        },
                        onWatchlistToggle: {
                            viewModel.toggleWatchlist(for: movie)
                        }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 32)
        }
    }
    
    // MARK: - Empty Search State
    
    private var emptySearchState: some View {
        VStack(spacing: 24) {
            ZStack {
                // Glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.blue.opacity(0.2),
                                Color.purple.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 120
                        )
                    )
                    .frame(width: 200, height: 200)
                
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(spacing: 12) {
                Text("Search for Movies")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Text("Find your favorite movies, discover new ones, and add them to your watchlist")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding()
            .glassCard()
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - No Results State
    
    private var noResultsState: some View {
        VStack(spacing: 24) {
            ZStack {
                // Glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.gray.opacity(0.2),
                                Color.secondary.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 100
                        )
                    )
                    .frame(width: 160, height: 160)
                
                Image(systemName: "film.stack")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.gray, .secondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(spacing: 12) {
                Text("No Results Found")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Text("Try searching with different keywords")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding()
            .glassCard()
            .padding(.horizontal)
            
            Button {
                viewModel.clearSearch()
                isSearchFocused = true
            } label: {
                Text("Clear Search")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .buttonStyle(ScaleButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview

#if DEBUG
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SearchView(viewModel: .mock())
        }
    }
}
#endif
