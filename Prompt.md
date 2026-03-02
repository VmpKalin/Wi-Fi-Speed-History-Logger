# Cursor Prompt — NetLog Flutter App

> Paste this into Cursor **Composer** (Cmd+I) inside a fresh Flutter project created with `flutter create netlog`

---

## Prompt

Create a Flutter/Dart mobile app called "NetLog" — a Wi-Fi Speed History Logger.

---

## Core Functionality

- Runs internet speed tests automatically twice per day in the background (every 12 hours)
- Stores all results locally using SQLite
- Displays a chart of internet speed history grouped by day
- Allows manual "Run Test Now" on demand

---

## Tech Stack

| Area | Package |
|---|---|
| State management | `riverpod` |
| Background tasks | `workmanager` |
| Database | `drift` (SQLite ORM) |
| Charts | `fl_chart` |
| Connectivity | `connectivity_plus` |
| HTTP | `http` |

---

## Speed Measurement Implementation

Implement speed testing via raw HTTP — no third-party speed test SDK:

- **Download speed:** fetch `https://speed.cloudflare.com/__down?bytes=10000000` (10MB), measure `(bytesReceived * 8) / (elapsedSeconds * 1_000_000)` = Mbps
- **Upload speed:** POST 2MB payload to `https://speed.cloudflare.com/__up`, same formula
- **Ping:** measure round-trip time to `https://speed.cloudflare.com/__down?bytes=0` in milliseconds

---

## Data Model

```dart
class SpeedResult {
  final int id;
  final DateTime timestamp;
  final double downloadMbps;
  final double uploadMbps;
  final int pingMs;
  final String networkType; // 'wifi' or 'cellular'
}
```

---

## Background Task

- Use `workmanager` to register a periodic task every 12 hours
- The `callbackDispatcher` must be a top-level function annotated with `@pragma('vm:entry-point')`
- Only run the test when device has network connectivity
- On iOS this uses `BGAppRefreshTask` under the hood — approximate timing is acceptable

---

## Database Queries Needed

- `insertResult(SpeedResult result)`
- `getAllResults()` — ordered by timestamp desc
- `getResultsByDay()` — returns `Map<DateTime, List<SpeedResult>>` grouped by calendar day
- `deleteAllResults()`
- `getLast30DaysResults()`

---

## Project Structure

```
lib/
├── main.dart
├── services/
│   ├── speed_test_service.dart
│   ├── background_service.dart
│   └── database_service.dart
├── models/
│   └── speed_result.dart
├── providers/
│   └── speed_providers.dart
├── screens/
│   ├── home_screen.dart
│   └── history_screen.dart
└── widgets/
    └── speed_chart.dart
```

---

## Home Screen UI

- Show today's latest download / upload / ping at the top as large numbers
- Show "Last tested: X hours ago" timestamp
- Line chart (`fl_chart`) for the last 30 days:
  - X axis = days
  - Y axis = Mbps
  - Line = daily average download speed
  - Shaded area below line = min/max range per day (visually shows ISP instability)
  - Toggle buttons to switch between Download / Upload / Ping views
- Prominent **"Run Test Now"** button that triggers an immediate test and updates the UI

---

## History Screen UI

- Scrollable list of all individual test entries
- Grouped by date with sticky date headers
- Each row shows: time, download Mbps, upload Mbps, ping ms, network type icon

---

## Settings Screen

- Test frequency selector: 6h / 12h / 24h
- WiFi-only toggle (skip test on cellular)
- Clear all history button

---

## Additional Requirements

- Handle errors gracefully — if a speed test fails, store a failed result with null values and show it clearly in history
- Show a loading indicator while a manual test is running
- The chart must handle the case where there are only 1–2 days of data without crashing
- Support both Android and iOS
- Use Material 3 design with dark theme as default

---

## Platform Setup

### iOS — `ios/Runner/Info.plist`

Add the following keys:

```xml
<key>UIBackgroundModes</key>
<array>
  <string>fetch</string>
  <string>processing</string>
</array>
<key>BGTaskSchedulerPermittedIdentifiers</key>
<array>
  <string>com.netlog.speedtest</string>
</array>
```

### Android — `AndroidManifest.xml`

Add the following permissions:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

---

## Output Requirements

Generate all files completely — no placeholders, no TODO comments. The app should compile and run after `flutter pub get`.

---

## Tips for After Generation

1. Run `flutter pub get` and verify all package versions in `pubspec.yaml` are compatible
2. If Drift code generation is missing, prompt separately:
   > *"Set up drift code generation with build_runner for this project and generate the database files"*
3. To test background tasks on iOS locally use the Xcode simulator debug command:
   > `e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.netlog.speedtest"]`