# MadaniChat

MadaniChat is a Flutter chat application backed by Firebase Authentication and
Cloud Firestore. It supports account registration, realtime contacts, friend
requests, one-to-one chat sessions, unread message indicators, profile editing,
security settings, and account deletion.

## Features

- Email/password authentication with Firebase Auth
- Onboarding, login, and registration flows
- Realtime friend requests by email
- Accept or decline incoming friend requests
- Realtime contact list with contact deletion
- One-to-one chat sessions with realtime messages
- Unread message badges in the message list and bottom navigation
- Pending friend request badge in the bottom navigation
- Profile editing for name and description
- Security editing for email, phone number, and password
- Account deletion with password confirmation
- Firestore security rules for users, contacts, friend requests, chats, and messages

## Tech Stack

- Flutter
- Dart
- Firebase Core
- Firebase Auth
- Cloud Firestore
- Google Fonts
- Google Nav Bar
- Flutter SVG

## Screenshots

Here are snapshots showcasing the mobile application's user interface.

1. **Onboarding Screen**

   This screen introduces MadaniChat and guides new users into account creation.

   <img width="1917" alt="Screens_rounded_1" src="https://github.com/H4MZ403/MadaniChat/assets/93478160/67fceea4-e70c-4b89-8e59-96318b009874">

2. **Messages, Contacts, and Settings**

   These screens cover chat sessions, contact management, friend requests, and
   account settings.

   <img width="1917" alt="Screens-2" src="https://github.com/H4MZ403/MadaniChat/assets/93478160/2b0109af-4ddc-4505-9e2c-54eedf849425">

## Requirements

- Flutter SDK
- Dart SDK bundled with Flutter
- Android Studio or Android SDK tools for Android emulator/device testing
- Firebase CLI for deploying Firestore rules
- A Firebase project with Authentication and Cloud Firestore enabled

For iPhone testing, you need macOS with Xcode. From Windows, use Android,
Chrome/Edge, or another supported Flutter target.

## Installation

1. Clone the repository:

   ```powershell
   git clone https://github.com/H4MZ403/MadaniChat.git
   cd MadaniChat
   ```

2. Install Flutter dependencies:

   ```powershell
   flutter pub get
   ```

3. Configure Firebase if you are setting up a new Firebase project:

   ```powershell
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

   This generates or updates `lib/firebase_options.dart`.

4. Enable Firebase services:

   - Authentication: enable Email/Password sign-in.
   - Cloud Firestore: create a Firestore database.

5. Deploy Firestore security rules:

   ```powershell
   firebase login
   firebase deploy --only firestore:rules
   ```

## Usage

Run the app on an available device or emulator:

```powershell
flutter run
```

Useful device commands:

```powershell
flutter devices
flutter emulators
flutter emulators --launch <emulator_id>
```

Basic app flow:

1. Open the app and tap `Get Started`.
2. Create an account from the registration screen.
3. Add another registered user by email from the Contacts page.
4. The receiver accepts or declines the friend request.
5. After acceptance, open the contact to start a chat session.
6. Unread messages and pending friend requests appear as badges in the bottom navigation.

## Testing

Run the widget tests:

```powershell
flutter test
```

Run static analysis:

```powershell
flutter analyze
```

## Firebase Data Model

The app uses these main Firestore collections:

- `users/{uid}` stores user profile and security metadata.
- `users/{uid}/contacts/{contactUid}` stores denormalized contact cards.
- `friendRequests/{fromUid_toUid}` stores pending friend requests.
- `chats/{chatId}` stores chat metadata, participants, last message, and unread counts.
- `chats/{chatId}/messages/{messageId}` stores individual chat messages.

## Firestore Rules

Firestore rules live in:

```text
firestore.rules
```

Deploy them after any security-rule change:

```powershell
firebase deploy --only firestore:rules
```

## Project Structure

```text
lib/
  components/      Reusable UI components
  models/          App data models
  pages/           Screens and navigation pages
  services/        Firebase and repository logic
  utils/           Colors and shared UI utilities
  widgets/         Settings/profile widgets
```

## Notes

- If Android builds fail with Java/Gradle compatibility errors, check your local
  Java version with `flutter doctor --verbose`.
- If Firestore operations fail with `permission-denied`, deploy the latest
  `firestore.rules` and verify the signed-in user is part of the requested data.
- Use a hot restart after changing navigation or Firebase initialization code.
