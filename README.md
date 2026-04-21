# Flutter Delivery Partner Application

A professional Flutter application for delivery partners, featuring a modern UI, real-time order tracking, and comprehensive delivery management.

## Features

- **Modern UI**: Clean, intuitive interface with smooth animations.
- **Real-time Updates**: Live tracking of delivery status and order updates.
- **Order Management**: Efficient handling of active and past deliveries.
- **User Authentication**: Secure login and profile management.
- **Connectivity**: Built-in network status detection and handling.

## Getting Started

### Prerequisites

- Flutter SDK (stable channel)
- Android Studio or VS Code
- Android device or emulator

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd flutter_delivery_partner_application
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Build Instructions

### Android

**Debug APK:**
```bash
flutter build apk --debug
```

**Release APK:**
```bash
flutter build apk --release
```

**Release App Bundle:**
```bash
flutter build appbundle --release
```

## Project Structure

```
lib/
├── presentation/
│   ├── controllers/    # Business logic and state management
│   ├── pages/          # UI screens
│   ├── widgets/        # Reusable components
│   └── main.dart       # Application entry point
└── data/               # Data layer (models, repositories)
```

## License

This project is licensed under the MIT License.