# Change log — audit & upgrade

> **Not compiled.** The sandbox had no Flutter/Dart SDK, so `flutter pub get`,
> `flutter analyze`, `flutter test` and a device run were **not** executed.
> Every Dart file was syntax-checked with a parser and all imports / string
> constants were cross-checked, but type errors are still possible.
> **Run these first:** `flutter pub get && flutter analyze && flutter test`.

## Do these yourself (cannot be done from code)

1. **Revoke the leaked Firebase CLI token.** The old repo contained
   `.config/configstore/firebase-tools.json` with a Google OAuth refresh token.
   Deleting the file is not enough: run `firebase logout` and remove "Firebase CLI"
   at <https://myaccount.google.com/permissions>. Then purge the file from git
   history (`git filter-repo --path .config --invert-paths` or BFG) and force-push.
2. Restrict your API keys in Google Cloud Console and set Firestore/Storage
   **Security Rules**; consider enabling **App Check**.
3. Before publishing: change `applicationId` (`com.example.first_app`) and the iOS
   bundle id, re-register both apps in Firebase, re-run `flutterfire configure`,
   and create `android/key.properties` for release signing.

## Security
- Removed `.config/` (token) and the stray `.mvn/` Maven wrapper.
- `.gitignore` rewritten: `.config/`, `.firebase/`, keystores, `google-services.json`
  stay ignored; the over-broad `*.json` / `*.js` rules were removed; `pubspec.lock`
  is no longer ignored (apps should commit it — run `flutter pub get` to create it).
- `AuthService` no longer trims passwords (only the e-mail).
- Raw exception text is never shown to users any more.

## Bugs fixed
| # | Problem | Fix |
|---|---|---|
| 1 | `HomePage.dispose()` disposed the shared `PlayerService` singleton → playback broke after logout/login | Removed; listener is detached instead; `PlayerService.dispose()` is a guarded no-op |
| 2 | `INTERNET` permission missing from the main Android manifest | Added; app label changed `first_app` → `Aurora` |
| 3 | `SongServiceException` branch in `ExceptionHandler` was unreachable | Reordered; new public `messageFor()` |
| 4 | `invalid-credential` (what Firebase returns today) not handled | Mapped to a single "wrong e-mail or password" message |
| 5 | E-mail regex rejected TLDs > 4 chars and `+` tags | Relaxed |
| 6 | Playback errors were silently swallowed | Now shown in a snack bar |
| 7 | Replaying a finished song did nothing | `_hasSource` tracking restarts playback |
| 8 | Rapid taps on different songs could race | Request-id guard in `PlayerService` |
| 9 | One malformed JSON entry broke the whole list | Bad entries are skipped |
| 10 | Persian titles could be garbled when the server omitted the charset | Body decoded as UTF-8 from bytes |
| 11 | Unhandled exception in the e-mail verification timer on a network error | try/catch in the timer |
| 12 | Router ignored auth changes outside navigation | `refreshListenable` (`AuthRefreshNotifier`) |
| 13 | "Forgot password" and social buttons did nothing | Password reset implemented; social buttons say "coming soon" |
| 14 | Drawer items did nothing | Favorites opens the tab; others say "coming soon" |
| 15 | Whole song list rebuilt several times per second while playing | Position/duration moved to `ValueNotifier`s |
| 16 | Tab state (scroll) lost on tab switch | `IndexedStack` |

## Features added
- Next / previous, auto-advance, draggable seek bar, loading spinner, mini player on all tabs
- Favorites (per account, stored on device) + working Favorites tab
- Pull-to-refresh; stale-list fallback when offline
- Password reset e-mail
- 7 new test files, GitHub Actions CI, MIT `LICENSE` (README linked a file that did not exist), refreshed README

## Dependencies
- `firebase_core ^3.15 → ^4.8`, `firebase_auth ^5.7 → ^6.5` (upgrade together)
- Removed unused `cloud_firestore`, `firebase_analytics`, `mockito`, `build_runner`
  (re-add Firestore when you build cloud-synced favorites)
- `flutter_launcher_icons`, `flutter_native_splash` moved to `dev_dependencies`
- iOS deployment target 13 → **15** (+ `ios/Podfile`) — required by Firebase iOS SDK 12
- Android: optional release signing via `android/key.properties`

## Deliberately NOT changed (and why)
- **`audioplayers` → `just_audio` + `audio_service`** (needed for background audio):
  requires native manifest / Info.plist changes that I cannot test here.
- **State management (Provider/Riverpod):** a large refactor best done with a compiler.
  The services now have test constructors as a first step.
- `applicationId`, `firebase_options.dart`, `app_theme.dart`, `welcome_view.dart`,
  `splash_screen.dart`, the Library tab placeholder, the other platform folders.
- Unused files in `assets/images/` (`download (1).png` …) and `extensions.txt`
  (a personal VS Code extension list) were left for you to decide.
