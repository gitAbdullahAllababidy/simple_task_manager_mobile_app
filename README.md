# Flutter Project - Task Manager App

This Flutter project is a task manager application that allows users to log in, register, view all tasks, create new tasks, and update existing tasks. The project utilizes the Provider package for state management, applying the Stacked architecture pattern and the Facade design pattern. It is built and tested on Flutter version 3.16.9.

## Overview

The Task Manager App provides users with a seamless experience for managing their tasks. It consists of three main layers:

1. **Presentation Layer**: Responsible for handling the user interface and user interactions.
2. **Application Layer**: Acts as an intermediary between the presentation layer and the data layer, containing business logic and application-specific rules.
3. **Data Layer**: Handles data persistence and retrieval from external sources.

## Features

- **User Authentication**: Allows users to register for a new account or log in with existing credentials.
- **Task Management**: Users can view all tasks, create new tasks, and update existing tasks.
- **Provider State Management**: Utilizes the Provider package for efficient state management across the app.
- **Stacked Architecture**: Organizes the codebase into separate layers, promoting maintainability and scalability.
- **Facade Design Pattern**: Implements a facade to provide a simplified interface for interacting with complex subsystems.
- **Modular Design**: Utilizes modular design principles for components, promoting reusability and maintainability.
- **App Generic List Component**: Implements a generic list component for displaying tasks in the HomeView.
- **Paging and Pull-to-Refresh**: The list component handles paging and pull-to-refresh features for improved user experience.
- **Local Storage with Isar Database**: Tasks are stored locally using Isar database, enabling offline access and data persistence.
- **Secure Storage for User Credentials**: User credentials are securely stored using shared secure storage, ensuring data privacy.

## Installation

To run the Task Manager App locally, follow these steps:

1. Make sure you have Flutter SDK version 3.16.9 installed.
2. Clone this repository to your local machine.
3. Navigate to the project directory.
4. Run `flutter pub get` to install dependencies.
5. Run `flutter run` to launch the app on your emulator or physical device.

## Project Structure

The project follows a structured architecture with clear separation of concerns:

- **presentation**: Contains UI components, screens, and view models.
- **application**: Houses application-specific logic, such as authentication and task management.
- **data**: Handles data persistence and retrieval, including database operations and API calls.
- Each layer contains its dependencies to maintain modularity and encapsulation.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
