# RemindMi

**Software Engineering Group Project**

A collaborative to-do list and reminder app designed for users with special needs, featuring admin accounts that can create and manage tasks while dependent accounts complete assigned tasks.

*Developed as part of Software Engineering coursework, demonstrating collaborative development practices, Firebase integration, and accessible mobile application design.*

## Features

- **Family Task Management**: Create and assign tasks between family members
- **User Roles**: Support for parent (assigner) and dependent (assignee) accounts
- **Task Tracking**: Monitor task completion status and progress
- **Firebase Integration**: Real-time data synchronization with Cloud Firestore
- **Authentication**: Secure user registration and login with Firebase Auth
- **Privacy & Terms**: Built-in privacy policy and terms & conditions
- **Accessibility**: Customizable accessibility settings

## Technology Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Firestore, Authentication)
- **State Management**: GetX
- **Local Storage**: GetStorage & SharedPreferences
- **UI/Fonts**: Google Fonts, Material Design

## Getting Started

### Prerequisites

- Flutter SDK (3.32.8 or later)
- Dart SDK (2.18.2 or later)
- Android Studio or VS Code
- Firebase project setup

### Installation

1. Clone the repository:
```bash
git clone https://github.com/dderheim00/RemindMi.git
cd RemindMi
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Add your `google-services.json` to `android/app/`
   - Configure Firebase project settings

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── app/
│   ├── components/        # Reusable UI components
│   ├── helper/           # Utility functions
│   ├── models/           # Data models
│   ├── modules/          # Feature modules (MVC pattern)
│   ├── routes/           # App navigation
│   ├── services/         # Firebase services
│   └── widget/           # Custom widgets
├── constants/            # App constants
└── main.dart            # App entry point
```

## Key Features Overview

### Task Management
- Create tasks with descriptions, deadlines, and priority levels
- Assign tasks to family members
- Track completion status
- View all tasks or filter by status

### User Management
- Parent accounts can create dependent accounts
- Secure authentication flow
- Profile management
- Role-based access control

### Real-time Updates
- Tasks sync across all devices in real-time
- Instant notifications for task updates
- Offline support with data persistence

## Dependencies

Key packages used:
- `firebase_core` & `firebase_auth` - Authentication
- `cloud_firestore` - Database
- `get` - State management and navigation
- `google_fonts` - Typography
- `cached_network_image` - Image caching
- `shared_preferences` - Local storage

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and ensure code quality
5. Submit a pull request

## Code Quality

The project maintains high code quality standards:
- Flutter analysis passing (1 minor configuration warning only)
- Proper error handling
- Clean architecture with MVC pattern
- Consistent code formatting

## License

This project is open source and available under the MIT License.

## Support

For issues or questions, please create an issue in the GitHub repository.