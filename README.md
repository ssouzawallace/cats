# Cats

An iOS app that browses cat pictures from the Imgur gallery, written in UIKit with a Core Data image cache.

## What it does

Fetches results for the Imgur gallery search `q=cats` and lays them out in a collection view. Tapping an image opens it full screen, where a bar button toggles between aspect-fit and filled presentation.

Downloaded images are cached in Core Data — the `Image` entity stores the URL, the raw data and the response — so repeat views don't re-download.

## Requirements

- Xcode with Swift 5
- iOS 16.1 or later
- An [Imgur API application](https://api.imgur.com/oauth2/addclient) for the client credentials

No third-party dependencies and no package manager step.

## Setup

The app reads its Imgur credentials from environment variables at launch. Without them it starts, logs a warning, and every request fails.

In Xcode: **Product → Scheme → Edit Scheme → Run → Arguments → Environment Variables**, then add:

| Name | Value |
|---|---|
| `client_id` | Your Imgur application's Client ID |
| `client_secret` | Your Imgur application's Client Secret |

Only `client_id` is sent — it goes out as the `Authorization: Client-ID …` header. `client_secret` is read and stored but never used by any request; it is required only because the initialiser checks for both.

Environment variables set this way live in the scheme, which is per-user and not committed. Nothing needs to be added to the repository.

## Build and run

1. Open `Cats.xcodeproj`
2. If no scheme is listed, open **Product → Scheme → Manage Schemes…** and click **Autocreate Schemes Now** — the project is set to autocreate them, but they are not always generated on first open
3. Add the environment variables above
4. Run

## Structure

```
Cats/
├── Views/         # CatsViewController, fullscreen viewer, cells, layout
├── ViewModels/    # CatsViewModel
├── Providers/     # ServiceProvider and its ServiceProviding protocol
├── Managers/      # ImageDownloadManager
├── Model/         # Imgur response and error types
├── Coordinators/  # Coordinator
├── CoreData/      # Cats.xcdatamodeld — the Image cache entity
└── Extensions/
```

MVVM with a coordinator for navigation. `ServiceProvider` sits behind the `ServiceProviding` protocol, so tests substitute their own implementation; `Resources/mockResponse.json` holds a recorded Imgur payload for that purpose.

## Known issues

- The `Swift` GitHub Actions workflow runs `swift build` and `swift test`. This is an Xcode app project with no `Package.swift`, so those commands cannot succeed — the workflow needs `xcodebuild` instead.
- `WikipediaViewModel` and `WikipediaTerm` are unreferenced. Nothing constructs them, and the default `WebViewLoader` implementation does nothing.
- The warning printed when credentials are missing misspells the variable as `clinet_id`.
