# Aurora Music Player

> A Flutter music player with online streaming, Firebase authentication, a Persian (RTL) interface, and full player controls, built as a first Flutter app.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey?style=for-the-badge)

> Note: this is a music player. It is not the Aurora anime franchise tracker; the anime tracker lives in [Aurora](https://github.com/GoldenTitab/Aurora) and [AuroraList](https://github.com/GoldenTitab/AuroraList).

## Overview

Aurora Music Player streams songs from a remote JSON source and plays them with a full set of controls, while keeping the experience local to each account: favorites are saved on the device per account, and the last downloaded song list is kept as an offline fallback.

Authentication is handled by Firebase, with sign-up, login, email verification and password reset. The interface is fully Persian (RTL) with the Vazir font, Material 3 theming, and light and dark themes that follow the system setting.

## Features

### Currently available

- **Online music streaming** — fetches and streams songs from a remote JSON source.
- **Firebase Authentication** — sign-up, login, email verification and password reset.
- **Light and dark theme** — full Material 3 theme support with automatic system switching.
- **RTL and Persian support** — full Persian localization with the Vazir font.
- **Full player controls** — play, pause, resume, stop, next and previous, a draggable seek bar, and auto-advance to the next track.
- **Favorites** — heart any song; favorites are saved on the device per account.
- **Song list** — cover art, artist info, duration, active-song highlighting, and pull-to-refresh.
- **Smart caching** — a 10-minute in-memory cache, with an offline fallback to the last downloaded list.
- **Error handling** — user-friendly Persian error messages; raw exception text is never shown.
- **Tests and CI** — unit and widget tests and a GitHub Actions workflow (`flutter analyze` + `flutter test`).

### In development

- Playlist creation and management
- Background audio with a media notification
- Library organization (the Library tab is still a placeholder)
- Social sign-in (Google, Apple and Spotify buttons currently show "coming soon")
- Local file playback
- Settings page (equalizer, sleep timer, quality)
- Offline mode with a local database (Hive)

## Tech Stack

| Area | Technology |
| --- | --- |
| Framework | Flutter / Dart `^3.11.3` |
| Authentication | Firebase Auth (`firebase_core` 4.x, `firebase_auth` 6.x) |
| Localization | `flutter_localizations` (fa_IR) |
| Audio and playback | Audio player with a play queue (ChangeNotifier) |
| State and services | Service classes for auth, songs, playback, favorites and onboarding |
| Navigation | GoRouter with auth redirect |
| Platform | Android and iOS |

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) — latest stable (the project needs Dart `^3.11.3`, see `pubspec.yaml`)
- Android Studio or VS Code with the Flutter extension
- A Firebase project with **Authentication** enabled (Email / Password)
- iOS builds: Xcode 16+ and iOS 15+ (required by the Firebase iOS SDK 12)

### Installation

```bash
git clone https://github.com/GoldenTitab/First-App.git
cd First-App
flutter pub get
```

### Configure Firebase (use your own Firebase project)

```bash
flutterfire configure
```

This regenerates `lib/firebase_options.dart` and `firebase.json`. Download `android/app/google-services.json` (git-ignored) from the Firebase console. Make sure **Email / Password** sign-in is enabled in your Firebase Console under Authentication, then Sign-in methods.

No `.env` file is needed. Firebase configuration is handled by `firebase_options.dart`.

### Run

```bash
flutter run
```

### Run the tests

```bash
flutter test
```

## Project Structure

```
lib/
  models/
    song.dart                  # Song model with Equatable and copyWith
  services/
    auth_service.dart          # Firebase Auth (singleton, test constructor)
    song_service.dart          # HTTP fetch, cache and stale fallback (test constructor)
    player_service.dart        # Audio player and play queue (ChangeNotifier)
    favorites_service.dart     # Per-account favorites (SharedPreferences)
    onboarding_service.dart    # "Welcome seen" flag
  screens/
    splash_screen.dart         # Animated splash with RTL progress bar
    welcome_view.dart          # Onboarding
    login_view.dart            # Login and password reset
    register_view.dart         # Register and confirm password
    verify_email_view.dart     # Email verification polling
    home_page.dart             # 4-tab layout (IndexedStack) and mini player
  widgets/
    song_list_view.dart
    song_list_item.dart
    song_player_controls.dart  # Mini player (prev, play, next, stop)
    song_seek_bar.dart         # Draggable seek bar
    song_progress_indicator.dart
    custom_bottom_navigation_bar.dart
    custom_dialog.dart
    custom_drawer.dart
    custom_elevated_button.dart
    custom_text_field.dart     # Text form field with visibility toggle
    loading_overlay.dart
  routes/
    app_routes.dart            # GoRouter with auth redirect and refresh
```

## Usage

Create an account or sign in, verify your email, then browse the song list, tap a song to play it, use the mini player or the full player controls to seek and skip, and heart songs to keep them in your favorites for that account.

## Release Signing (Android)

Create `android/key.properties` (git-ignored) with `storeFile`, `storePassword`, `keyAlias` and `keyPassword`. When the file exists, release builds are signed with it; otherwise they fall back to the debug key. Before publishing, also change the `applicationId` (`com.example.first_app`) and re-register the app in Firebase.

## Security Notes

- **Never commit** `google-services.json`, keystores, `.env` files, or any tool config directory such as `.config/` (the Firebase CLI stores a login token there).
- Firebase API keys in `firebase_options.dart` are identifiers, not secrets; protect the project with **Security Rules**, **App Check** and API-key restrictions.

## Contributing

Run `flutter analyze` and `flutter test` before submitting a pull request.

## License

MIT — see [LICENSE](LICENSE).
