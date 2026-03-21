# Stitch Music — Material 3 Expressive Dark Music Player

A Flutter Android music app featuring Material You Design 3 with an expressive dark theme, custom color palette, and immersive glassmorphic UI.

## Design Specs

**Theme & Palette:**
- **Primary**: #DACDFF (light lavender)
- **Accent/Violet**: #7C4DFF (vibrant purple)
- **Background**: #120B1A (near-black)
- **Surface**: #120B1A, with tonal containers at multiple depths
- **Typography**: Epilogue (headlines) + Manrope (body)

**Key Features:**
- Material 3 Glassmorphism: Frosted glass mini-player + navigation
- Expressive animations (ambient mesh, album glow, equalizer)
- No-line design rules (shape/color define boundaries, not strokes)
- Asymmetric grids, organic typography, floating action pills
- Reorderable queue with drag handles
- Search/library with filter chips
- Bottom navigation with gradient indicators

## Project Structure

```
lib/
├── main.dart                     # Entry point
├── theme/
│   └── app_theme.dart            # Material 3 color scheme & typography
├── models/
│   └── music_models.dart         # Track, Mix data models + sample data
├── screens/
│   ├── main_shell.dart           # Tab navigator (Home, Discover, Library, Profile)
│   ├── home_screen.dart          # Discovery feed (hero, recent plays, daily mixes, new releases)
│   ├── now_playing_screen.dart   # Full-screen now playing with album art + controls
│   ├── queue_screen.dart         # Reorderable queue (modal bottom sheet)
│   ├── library_screen.dart       # Searchable track library with filters
│   └── profile_screen.dart       # User profile stub
└── widgets/
    ├── mini_player.dart          # Floating glassmorphic mini-player
    └── glass_nav_bar.dart        # Gradient-fill bottom nav with blur effect
```

## Dependencies

- `flutter`: SDK
- `google_fonts`: Epilogue + Manrope typefaces
- `cupertino_icons`: iOS-style icons

## Building & Running

### Prerequisites
- Flutter SDK 3.4.0+ installed
- Android toolchain / emulator configured
- (Windows Developer Mode enabled for symlinks)

### Install & Run
```bash
# Install dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Run on specific device (e.g., Android)
flutter run -d android

# Build release APK
flutter build apk --release
```

### Debug/Analysis
```bash
# Check for lint issues
flutter analyze

# Format code
dart format lib/

# Run widget tests
flutter test
```

## Screens Overview

### 1. **Home Screen** (Discovery feed)
   - Hero section (Trending now)
   - Asymmetric "Recent Plays" grid
   - Horizontal scrolling "Daily Mixes" carousel
   - Bento-style "New Releases" layout

### 2. **Now Playing Screen**
   - Animated glossy album art with vinyl ring pattern
   - Track metadata (title, artist, album)
   - Expressive progress bar with interactive slider
   - Playback controls (shuffle, skip, play/pause, repeat)
   - Secondary controls (volume, speed, EQ, share)
   - Glassmorphic bottom bar (Devices, Queue, Share)

### 3. **Queue Screen** (Modal)
   - "Now Playing" highlight with equalizer animation
   - Reorderable track list (drag handles)
   - Track duration, artist, album info
   - Glassmorphic header with track count

### 4. **Library Screen**
   - Search bar (dark "well" aesthetic)
   - Filter chips (All, Songs, Albums, Artists, Playlists)
   - List of library tracks with duration + context menu
   - Empty state for no results

### 5. **Discover Screen**
   - Genre grid with gradient overlays
   - Expandable genre browsing (stub)

### 6. **Profile Screen**
   - User avatar + info
   - Stats (songs, artists, hours listened)
   - Menu items (Edit Profile, History, Downloads, Settings)

## Styling Highlights

✨ **Glassmorphism**
- 70% opacity surfaces with 28px blur
- Subtle 0.08 opacity borders

��� **Color Layering**
- Surface (base) → Surface Container Low → High → Highest
- Tokens define depth without explicit borders

��� **Typography**
- Epilogue (variable weight) for editorial, expressive headlines
- Manrope (geometric) for clean body text & labels
- Bold tracking on labels for Material 3 expressiveness

��� **Animation**
- Mesh gradient background (15s loop)
- Album art glow pulse (3s reverse)
- Equalizer bars in queue (staggered)
- Page slide transitions

## Customization

Edit `lib/theme/app_theme.dart` to adjust:
- Color palette (AppColors constants)
- Typography (text/headline styles in buildAppTheme())
- Component radii (CardTheme, NavigationBar, etc.)

Edit `lib/models/music_models.dart` to add more sample tracks/mixes.

## Notes

- Uses Material 3 with `useMaterial3: true`
- No explicit shadows; relies on gradient depth + ambient glow
- Supports dark theme only (no light variant)
- Android-focused (uses BouncingScrollPhysics)
- Ready to expand with actual music API integration

---

## 📊 Implementation Status

See [`docs/backlog.md`](docs/backlog.md) for the full visual roadmap and feature tracker.

| Phase | Status |
|-------|--------|
| 🏗️ Foundation (screens, design, navigation) | ✅ Complete |
| ⚙️ Core Engine (playback, MediaStore) | 🔄 In Progress |
| 💾 Persistence (queue, favorites) | 🔜 Next Up |
| 🎵 Features (playlists, library diagnostics) | 🔜 Next Up |
| 🔍 YouTube Streaming | 🔍 Discovery |
| 🌐 Future (artist pages, recommendations) | 🌐 Planned |

**Status**: Ready to build & run. All lint checks pass. No syntax errors.
