# SwiftMVI

A minimal GitHub client built to demonstrate the Model View Intent (MVI) pattern in SwiftUI, without TCA, stores, or reducers. The goal is to keep the architecture explicit and easy to follow, so every screen reads top to bottom as State, Interactor, and View.

## What it does

The app authenticates against GitHub using the device flow and then shows:

- A **Dashboard** with a large header title and the signed in user's avatar, plus the three most recently active repositories.
- A **Repositories** tab listing every repository with a native search field.
- A **Profile** tab with the user's details, statistics, and a log out action.
- A **Repository detail** screen with activity, metadata, topics, and external links.
- **Followers** and **Following** lists, reached from the Profile statistics.

Navigation uses a native tab bar and value based navigation. The visual style follows the iOS Settings app, using inset grouped lists, grouped backgrounds, and tinted symbol icons.

## Architecture

The codebase favours clarity over abstraction, so the MVI pieces are visible rather than hidden behind generic wrappers.

- **State**: an `@Observable` class holding a single state enum (`idle`, `loading`, `loaded`, `failed`). It describes what the screen should render.
- **Interactor**: handles intent. It is annotated `@MainActor`, performs asynchronous work through services, and writes the result back onto the state.
- **View**: a SwiftUI view that switches over the state and renders the matching case.
- **Service**: a thin layer that maps transport DTOs into domain models and normalises errors.
- **GitHubClient**: the networking boundary that talks to the GitHub REST API.

Dependency injection is provided by FactoryKit. All registrations live in `Container.swift`.

### Project layout

```
SwiftMVI/
  Components/        Reusable UI pieces (avatar, settings icon, repository row)
  DTOs/              Decodable transport models
  Models/            Domain models
  Screens/           One folder per screen, each with State, Interactor, View
  Services/          AuthService, UserService, RepositoryService
  GitHubClient.swift Networking boundary
  Container.swift    FactoryKit registrations
  MainTabView.swift  The tab bar
  TabRouter.swift    Programmatic tab selection
```

## Authentication

Sign in uses the GitHub device flow. The client identifier belongs to a GitHub App, so user tokens are limited by the App's configured permissions rather than only by OAuth scopes.

This has one practical consequence worth noting. The endpoints for the authenticated user's own followers and following are gated behind a separate App permission, so the app reads followers and following through the public `users/{username}` endpoints instead, which return the same data without that permission requirement.

## Requirements

- Xcode with an iOS 26.2 SDK or newer.
- An iOS 26.2 simulator or device.
- The Factory (FactoryKit) Swift package, resolved automatically by Xcode.

## Building

Open `SwiftMVI.xcodeproj` in Xcode, choose an iOS simulator, and run. The project uses Xcode's file system synchronised groups, so new source files placed under `SwiftMVI/` are picked up automatically.

To build from the command line:

```
xcodebuild build -scheme SwiftMVI -project SwiftMVI.xcodeproj \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Notes

- There is no token persistence. Each launch requires the device flow sign in again, which keeps the demo self contained.
- The repetition across screens is intentional. Because the purpose of the project is to teach the MVI pattern, each screen spells out its own state machine rather than sharing a generic container.
