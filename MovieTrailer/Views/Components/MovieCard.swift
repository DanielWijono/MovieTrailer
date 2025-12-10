//
//  MovieCard.swift
//  MovieTrailer
//
//  Created by Daniel Wijono on 10/12/2025.
//

import SwiftUI
import Kingfisher

/// Glassmorphism movie card component
struct MovieCard: View {
    
    let movie: Movie
    let isInWatchlist: Bool
    let onTap: () -> Void
    let onWatchlistToggle: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .topTrailing) {
                // Main card content
                VStack(alignment: .leading, spacing: 8) {
                    // Poster image
                    posterImage
                    
                    // Movie info
                    VStack(alignment: .leading, spacing: 4) {
                        Text(movie.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                        
                        HStack(spacing: 8) {
                            // Rating
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                                
                                Text(movie.formattedRating)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                            }
                            
                            // Year
                            if let year = movie.releaseYear {
                                Text("•")
                                    .foregroundColor(.secondary)
                                
                                Text(year)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.2),
                                            Color.white.opacity(0.05)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                // Watchlist button
                watchlistButton
                    .padding(8)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    // MARK: - Subviews
    
    private var posterImage: some View {
        KFImage(movie.posterURL)
            .placeholder {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.blue.opacity(0.3),
                                Color.purple.opacity(0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Image(systemName: "film")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.5))
                    )
            }
            .resizable()
            .aspectRatio(2/3, contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var watchlistButton: some View {
        Button(action: onWatchlistToggle) {
            Image(systemName: isInWatchlist ? "bookmark.fill" : "bookmark")
                .font(.system(size: 20))
                .foregroundColor(isInWatchlist ? .yellow : .white)
                .padding(8)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Scale Button Style

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Preview

#if DEBUG
struct MovieCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            MovieCard(
                movie: Movie.sample,
                isInWatchlist: false,
                onTap: {},
                onWatchlistToggle: {}
            )
            .frame(width: 160)
            
            MovieCard(
                movie: Movie.sample,
                isInWatchlist: true,
                onTap: {},
                onWatchlistToggle: {}
            )
            .frame(width: 160)
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
    }
}
#endif
