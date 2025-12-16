//
//  TonightView.swift
//  MovieTrailer
//
//  Created by Daniel Wijono on 10/12/2025.
//

import SwiftUI

struct TonightView: View {
    
    @StateObject private var viewModel: TonightViewModel
    let onMovieTap: (Movie) -> Void
    
    init(viewModel: TonightViewModel, onMovieTap: @escaping (Movie) -> Void = { _ in }) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onMovieTap = onMovieTap
    }
    
    var body: some View {
        ZStack {
            // Glassmorphism animated background
            GlassBackgroundView()
            
            if viewModel.isLoading && viewModel.recommendations.isEmpty {
                LoadingView()
            } else if let error = viewModel.error, viewModel.recommendations.isEmpty {
                ErrorView(error: error) {
                    Task {
                        await viewModel.generateRecommendations()
                    }
                }
            } else if viewModel.recommendations.isEmpty {
                emptyStateView
            } else {
                recommendationsView
            }
        }
        .navigationTitle("Tonight")
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            if viewModel.recommendations.isEmpty {
                await viewModel.generateRecommendations()
            }
        }
    }
    
    // MARK: - Recommendations View
    
    private var recommendationsView: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Premium glass header
                headerSection
                
                // Recommendations grid
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ],
                    spacing: 20
                ) {
                    ForEach(viewModel.recommendations) { movie in
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
            }
            .padding(.bottom, 32)
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Animated icon
            ZStack {
                // Pulsing glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.orange.opacity(0.3),
                                Color.pink.opacity(0.2),
                                Color.purple.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 10,
                            endRadius: 80
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .pink, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(spacing: 8) {
                Text("What to Watch Tonight")
                    .font(.title.bold())
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("Personalized picks just for you")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                
                // Recommendation count badge
                Text("\(viewModel.recommendations.count) movies curated")
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Capsule()
                                    .stroke(
                                        LinearGradient(
                                            colors: [.orange.opacity(0.5), .pink.opacity(0.5)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .padding(.horizontal)
        .glassCard()
        .padding(.horizontal)
        .padding(.top, 20)
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            ZStack {
                // Glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.orange.opacity(0.2),
                                Color.pink.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 100
                        )
                    )
                    .frame(width: 160, height: 160)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(spacing: 12) {
                Text("No Recommendations Yet")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Text("Add some movies to your watchlist to get personalized recommendations!")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding()
            .glassCard()
            .padding(.horizontal)
            
            Button {
                Task {
                    await viewModel.generateRecommendations()
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                    Text("Generate Recommendations")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [.orange, .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
                .shadow(color: Color.orange.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .buttonStyle(ScaleButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview

#if DEBUG
struct TonightView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TonightView(viewModel: .mock())
        }
    }
}
#endif
