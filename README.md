# 🎬 MovieTrailer

[![iOS](https://img.shields.io/badge/iOS-16.1%2B-blue.svg)](https://www.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-100%25-green.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A senior-level, portfolio-defining iOS movie discovery app featuring Live Activities, Dynamic Island, and a stunning glassmorphism design.

## ✨ Features

### 🎯 Core Features
- **Discover Movies**: Browse trending, popular, and top-rated movies with infinite scroll
- **Smart Recommendations**: "What to Watch Tonight" engine combining trending + watchlist + genre preferences
- **Advanced Search**: Debounced search with recent searches persistence
- **Watchlist Management**: Add/remove movies with local persistence and social sharing

### 🔴 Live Activity & Dynamic Island
- Real-time watchlist notifications in Dynamic Island
- Beautiful compact and expanded layouts with movie posters
- Timer-based countdown with progress bar updates

### 🎨 Design Excellence
- Full **glassmorphism/liquid-glass** design language
- Custom tab bar with floating glass effect
- Smooth hero transitions between screens
- Full Dark Mode and Dynamic Type support
- Accessibility-first approach

## 🏗️ Architecture

```
SwiftUI + MVVM + Coordinator Pattern
├── Coordinators (Navigation flow control)
├── ViewModels (Business logic)
├── Views (Pure presentation)
├── Services (Networking, Persistence)
└── Models (Data structures)
```

### Key Technologies
- **100% SwiftUI** - No UIKit dependencies
- **Swift Concurrency** - async/await + Actors for thread-safe networking
- **Minimal Combine** - Only for Live Activity timer updates
- **URLCache** - Full HTTP caching strategy
- **Kingfisher** - Image loading and caching

## 📦 Dependencies

Managed via **Swift Package Manager**:
- [Kingfisher](https://github.com/onevcat/Kingfisher) - Image downloading and caching

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 16.1+ (for Live Activities)
- TMDB API Key ([Get one here](https://www.themoviedb.org/settings/api))

### Installation

1. Clone the repository:
```bash
git clone https://github.com/YOUR_USERNAME/MovieTrailer.git
cd MovieTrailer
```

2. Open the project:
```bash
open MovieTrailer.xcodeproj
```

3. Add your TMDB API key:
   - Create a file `APIKeys.swift` in the project
   - Add your key (this file is gitignored for security)

4. Build and run:
   - Select your target device/simulator
   - Press `⌘ + R`

## 🧪 Testing

The project includes comprehensive unit tests with **95%+ coverage** using **Swift Testing**.

Run tests:
```bash
⌘ + U
```

Test coverage includes:
- ✅ Networking layer with mock responses
- ✅ ViewModels state management
- ✅ Coordinator navigation flows
- ✅ Recommendation algorithm
- ✅ Watchlist persistence

## 📱 Screenshots

> Screenshots coming soon...

## 🎯 Project Structure

```
MovieTrailer/
├── App/                    # App entry point & root coordinator
├── Coordinators/           # Navigation coordinators
├── Features/               # Feature modules
│   ├── Discover/
│   ├── Tonight/
│   ├── Search/
│   └── Watchlist/
├── Models/                 # Data models
├── Networking/             # TMDB API service
├── ViewModels/             # Business logic
├── Views/                  # SwiftUI views
├── Services/               # Persistence & utilities
└── Widgets/                # Live Activity implementation
```

## 🔐 Privacy & Security

- **No user data collection**
- **API keys excluded from version control**
- **Privacy manifest included** (PrivacyInfo.xcprivacy)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Daniel Wijono**
- Portfolio: [Your Portfolio URL]
- LinkedIn: [Your LinkedIn]
- GitHub: [@swijono](https://github.com/swijono)

## 🙏 Acknowledgments

- Movie data provided by [The Movie Database (TMDB)](https://www.themoviedb.org/)
- Design inspiration from Apple's Human Interface Guidelines

---

**Built with ❤️ using SwiftUI**
