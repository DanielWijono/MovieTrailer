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
    
    init(viewModel: SearchViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            searchBar
            
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
        .background(Color(uiColor: .systemBackground))
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - Search Bar
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search movies...", text: $viewModel.searchQuery)
                    .textFieldStyle(.plain)
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
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(uiColor: .systemGray6))
            )
        }
        .padding()
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
                            // Navigate to detail
                        },
                        onWatchlistToggle: {
                            viewModel.toggleWatchlist(for: movie)
                        }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
    }
    
    // MARK: - Empty Search State
    
    private var emptySearchState: some View {
        VStack(spacing: 24) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("Search for Movies")
                .font(.title2.bold())
            
            Text("Find your favorite movies, discover new ones, and add them to your watchlist")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - No Results State
    
    private var noResultsState: some View {
        VStack(spacing: 24) {
            Image(systemName: "film.stack")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.gray, .secondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("No Results Found")
                .font(.title2.bold())
            
            Text("Try searching with different keywords")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
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
