# Traffic Lights Game

A Flutter implementation of the Traffic Lights game, where players take turns changing the colors of traffic lights in a 3x4 grid. The goal is to get three lights of the same color in a row, column, or diagonal.

## Game Rules

1. The game is played on a 3x4 grid of traffic lights
2. Each light can be in one of four states: Off, Green, Yellow, or Red
3. Players take turns clicking on lights to change their colors
4. When a light is clicked, it cycles through the colors in order: Off → Green → Yellow → Red
5. A player wins by getting three lights of the same color in a row, column, or diagonal
6. The game ends when a player wins or when all lights are red

## Features

- Clean, intuitive user interface
- Color-blind friendly design
- Clear game state indication
- Turn-based gameplay
- Win detection
- Reset functionality

## Deployment

### Web Version
The web version is available at: http://cs.gettysburg.edu/~shahaa01/traffic_lights/
To run locally:
1. Navigate to the project directory
2. Run `flutter build web`
3. The built files will be in the `build/web` directory

### Android Version
The Android APK is available at: http://cs.gettysburg.edu/~shahaa01/traffic_lights/app-release.apk
To build locally:
1. Navigate to the project directory
2. Run `flutter build apk`
3. The APK will be in `build/app/outputs/flutter-apk/app-release.apk`

## Development

### Prerequisites
- Flutter SDK
- Android Studio (for Android development)
- Chrome (for web development)

### Running the Project
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## Credits
Developed by Aaditya Shah
Course: CS112
Instructor: Todd W. Neller
