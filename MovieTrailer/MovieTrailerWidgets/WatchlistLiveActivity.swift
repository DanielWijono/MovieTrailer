//
//  WatchlistLiveActivity.swift
//  MovieTrailerWidgets
//
//  Premium Live Activity UI with glassmorphism design
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WatchlistLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WatchlistActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            lockScreenView(context: context)
        } dynamicIsland: {context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    // Movie poster thumbnail
                    if let posterURL = context.attributes.posterURL {
                        AsyncImage(url: posterURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color.blue.opacity(0.3)
                        }
                        .frame(width: 50, height: 75)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    // Rating and countdown
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.caption2)
                                .foregroundColor(.yellow)
                            Text(context.attributes.formattedRating)
                                .font(.caption.bold())
                        }
                        
                        Text(context.state.timeUntilTonight)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    // Movie title
                    Text(context.attributes.movieTitle)
                        .font(.subheadline.bold())
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    // Progress bar and message
                    VStack(spacing: 8) {
                        // Progress to tonight
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                // Background
                                Capsule()
                                    .fill(Color.gray.opacity(0.2))
                                
                                // Progress
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geometry.size.width * context.state.progressToTonight)
                            }
                        }
                        .frame(height: 6)
                        
                        Text(context.state.message)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            } compactLeading: {
                // Star icon
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            } compactTrailing: {
                // Countdown
                Text(context.state.timeUntilTonight)
                    .font(.caption2.bold())
                    .foregroundColor(.white)
            } minimal: {
                // Just star icon
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            .keylineTint(Color.purple)
        }
    }
    
    // MARK: - Lock Screen View
    
    @ViewBuilder
    private func lockScreenView(context: ActivityViewContext<WatchlistActivityAttributes>) -> some View {
        HStack(spacing: 16) {
            // Movie poster
            if let posterURL = context.attributes.posterURL {
                AsyncImage(url: posterURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    LinearGradient(
                        colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
                .frame(width: 60, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Info
            VStack(alignment: .leading, spacing: 8) {
                Text(context.attributes.movieTitle)
                    .font(.headline.bold())
                    .lineLimit(2)
                
                // Rating
                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(context.attributes.rating / 2) ? "star.fill" : "star")
                            .font(.caption2)
                            .foregroundColor(.yellow)
                    }
                    Text(context.attributes.formattedRating)
                        .font(.caption.bold())
                }
                
                Spacer()
                
                // Countdown
                HStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .font(.caption)
                    Text("\(context.state.timeUntilTonight) until tonight")
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.2),
                    Color.purple.opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

// MARK: - Preview

#Preview("Notification", as: .content, using: WatchlistActivityAttributes.sample) {
   WatchlistLiveActivity()
} contentStates: {
    WatchlistActivityAttributes.sampleState
}
