//
//  GlassTabBar.swift
//  MovieTrailer
//
//  Custom glassmorphism tab bar component
//

import SwiftUI

/// Custom tab bar with glassmorphism design
struct GlassTabBar: View {
    
    @Binding var selectedTab: Int
    let tabs: [TabItem]
    
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs) { tab in
                GlassTabButton(
                    tab: tab,
                    isSelected: selectedTab == tab.tag,
                    namespace: animation,
                    action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = tab.tag
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
}

/// Individual tab button with glassmorphism
struct GlassTabButton: View {
    
    let tab: TabItem
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    // Selection indicator background
                    if isSelected {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.blue.opacity(0.6),
                                        Color.purple.opacity(0.6)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 36)
                            .matchedGeometryEffect(id: "tab_selection", in: namespace)
                    }
                    
                    // Icon
                    Image(systemName: isSelected ? tab.iconFilled : tab.icon)
                        .font(.system(size: 24))
                        .foregroundStyle(
                            isSelected ?
                            LinearGradient(
                                colors: [.white],
                                startPoint: .top,
                                endPoint: .bottom
                            ) :
                            LinearGradient(
                                colors: [.white.opacity(0.6)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
                
                // Label
                Text(tab.title)
                    .font(.caption2.weight(isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

/// Tab item model
struct TabItem: Identifiable {
    let id = UUID()
    let tag: Int
    let icon: String
    let iconFilled: String
    let title: String
}

// MARK: - Preview

#if DEBUG
struct GlassTabBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                GlassTabBar(
                    selectedTab: .constant(0),
                    tabs: [
                        TabItem(tag: 0, icon: "square.grid.2x2", iconFilled: "square.grid.2x2.fill", title: "Discover"),
                        TabItem(tag: 1, icon: "star.circle", iconFilled: "star.circle.fill", title: "Tonight"),
                        TabItem(tag: 2, icon: "magnifyingglass", iconFilled: "magnifyingglass", title: "Search"),
                        TabItem(tag: 3, icon: "bookmark", iconFilled: "bookmark.fill", title: "Watchlist")
                    ]
                )
            }
        }
    }
}
#endif
