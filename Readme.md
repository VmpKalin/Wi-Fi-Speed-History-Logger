# NetLog — Wi-Fi Speed History Logger

A Flutter app that automatically runs internet speed tests and keeps a local history, so you can track your ISP's real-world performance over time.

## Features

- **Automatic speed tests** every 6, 12, or 24 hours in the background
- **Manual "Run Test Now"** for on-demand measurements
- **Download, Upload, and Ping** measured via Cloudflare's speed test endpoints
- **30-day chart** with daily averages and min/max range shading
- **Full history** list grouped by date
- **Settings** for test frequency, Wi-Fi-only mode, and data management
- **Dark theme** with Material 3 design
- **Local-only storage** — all data stays on your device (SQLite via Drift)

## Getting Started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Project Structure

```
lib/
├── main.dart                    # App entry point, theme, navigation
├── models/
│   └── speed_result.dart        # Drift table definition
├── services/
│   ├── database_service.dart    # Drift database + queries
│   ├── speed_test_service.dart  # HTTP-based speed measurement
│   └── background_service.dart  # Workmanager periodic task
├── providers/
│   └── speed_providers.dart     # Riverpod state management
├── screens/
│   ├── home_screen.dart         # Dashboard with chart
│   ├── history_screen.dart      # Full test history list
│   └── settings_screen.dart     # App settings
└── widgets/
    └── speed_chart.dart         # fl_chart line chart
```

## Tech Stack

| Area | Package |
|---|---|
| State management | `flutter_riverpod` |
| Background tasks | `workmanager` |
| Database | `drift` (SQLite ORM) |
| Charts | `fl_chart` |
| Connectivity | `connectivity_plus` |
| HTTP | `http` |

## Speed Measurement

Speed is measured using raw HTTP requests to Cloudflare's test endpoints:

- **Download:** 10 MB file from `speed.cloudflare.com/__down`
- **Upload:** 2 MB POST to `speed.cloudflare.com/__up`
- **Ping:** round-trip time to `speed.cloudflare.com/__down?bytes=0`

## Testing Background Tasks on iOS

In Xcode simulator debug console:

```
e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.netlog.speedtest"]
```
