//
//  TabCoordinator.swift
//  MovieTrailer
//
//  Created by Daniel Wijono on 10/12/2025.
//

import SwiftUI
import Combine

/// Coordinator for managing the main tab bar
@MainActor
final class TabCoordinator: ObservableObject, TabCoordinatorProtocol {
    
    // MARK: - Published Properties
    
    @Published var selectedTab: Int = 0
    @Published var childCoordinators: [any Coordinator] = []
    
    // MARK: - Dependencies
    
    let tmdbService: TMDBService
    let watchlistManager: WatchlistManager
    let liveActivityManager: LiveActivityManager
    
    // MARK: - Child Coordinators
    
    private(set) var discoverCoordinator: DiscoverCoordinator?
    private(set) var tonightCoordinator: TonightCoordinator?
    private(set) var searchCoordinator: SearchCoordinator?
    private(set) var watchlistCoordinator: WatchlistCoordinator?
    
    // MARK: - Tab Enum
    
    enum Tab: Int, CaseIterable {
        case discover = 0
        case tonight = 1
        case search = 2
        case watchlist = 3
        
        var title: String {
            switch self {
            case .discover: return "Discover"
            case .tonight: return "Tonight"
            case .search: return "Search"
            case .watchlist: return "Watchlist"
            }
        }
        
        var icon: String {
            switch self {
            case .discover: return "film"
            case .tonight: return "star.circle"
            case .search: return "magnifyingglass"
            case .watchlist: return "bookmark"
            }
        }
        
        var iconFilled: String {
            switch self {
            case .discover: return "film.fill"
            case .tonight: return "star.circle.fill"
            case .search: return "magnifyingglass"
            case .watchlist: return "bookmark.fill"
            }
        }
    }
    
    // MARK: - Initialization
    
    init(
        tmdbService: TMDBService,
        watchlistManager: WatchlistManager,
        liveActivityManager: LiveActivityManager
    ) {
        self.tmdbService = tmdbService
        self.watchlistManager = watchlistManager
        self.liveActivityManager = liveActivityManager
        
        // Initialize child coordinators immediately
        self.discoverCoordinator = DiscoverCoordinator(
            tmdbService: tmdbService,
            watchlistManager: watchlistManager
        )
        
        self.tonightCoordinator = TonightCoordinator(
            tmdbService: tmdbService,
            watchlistManager: watchlistManager
        )
        
        self.searchCoordinator = SearchCoordinator(
            tmdbService: tmdbService,
            watchlistManager: watchlistManager
        )
        
        self.watchlistCoordinator = WatchlistCoordinator(
            watchlistManager: watchlistManager,
            liveActivityManager: liveActivityManager,
            tmdbService: tmdbService
        )
    }
    
    // MARK: - Coordinator Protocol
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Content view switcher
            Group {
                switch selectedTab {
                case Tab.discover.rawValue:
                    discoverTab()
                case Tab.tonight.rawValue:
                    tonightTab()
                case Tab.search.rawValue:
                    searchTab()
                case Tab.watchlist.rawValue:
                    watchlistTab()
                default:
                    discoverTab()
                }
            }
            .ignoresSafeArea(edges: .bottom)
            
            // Custom glassmorphism tab bar
            GlassTabBar(
                selectedTab: Binding(
                    get: { self.selectedTab },
                    set: { self.selectedTab = $0 }
                ),
                tabs: [
                    TabItem(tag: Tab.discover.rawValue, icon: Tab.discover.icon, iconFilled: Tab.discover.iconFilled, title: Tab.discover.title),
                    TabItem(tag: Tab.tonight.rawValue, icon: Tab.tonight.icon, iconFilled: Tab.tonight.iconFilled, title: Tab.tonight.title),
                    TabItem(tag: Tab.search.rawValue, icon: Tab.search.icon, iconFilled: Tab.search.iconFilled, title: Tab.search.title),
                    TabItem(tag: Tab.watchlist.rawValue, icon: Tab.watchlist.icon, iconFilled: Tab.watchlist.iconFilled, title: Tab.watchlist.title)
                ]
            )
        }
        .onAppear {
            self.start()
        }
    }
    
    func start() {
        // Add coordinators to child array
        if let discover = discoverCoordinator { addChild(discover) }
        if let tonight = tonightCoordinator { addChild(tonight) }
        if let search = searchCoordinator { addChild(search) }
        if let watchlist = watchlistCoordinator { addChild(watchlist) }
    }
    
    func finish() {
        removeAllChildren()
    }
    
    // MARK: - Tab Views
    
    @ViewBuilder
    private func discoverTab() -> some View {
        if let coordinator = discoverCoordinator {
            coordinator.body
        } else {
            placeholderView(for: .discover)
        }
    }
    
    @ViewBuilder
    private func tonightTab() -> some View {
        if let coordinator = tonightCoordinator {
            coordinator.body
        } else {
            placeholderView(for: .tonight)
        }
    }
    
    @ViewBuilder
    private func searchTab() -> some View {
        if let coordinator = searchCoordinator {
            coordinator.body
        } else {
            placeholderView(for: .search)
        }
    }
    
    @ViewBuilder
    private func watchlistTab() -> some View {
        if let coordinator = watchlistCoordinator {
            coordinator.body
        } else {
            placeholderView(for: .watchlist)
        }
    }
    
    // MARK: - Placeholder
    
    private func placeholderView(for tab: Tab) -> some View {
        VStack(spacing: 20) {
            Image(systemName: tab.iconFilled)
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text(tab.title)
                .font(.title.bold())
            
            Text("Coming soon...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
}
