# Kanban Board

## Overview

This Kanban board application is built with Flutter, providing users with a visual board to manage tasks. Tasks are organized into columns representing different statuses (To Do, In Progress, Done). The application supports adding tasks, viewing task details, and updating task statuses through a drag-and-drop interface.

## Features

- **Task Management:** Add, edit, and delete tasks.
- **Kanban Board Layout:** View tasks organized in columns based on their status.
- **Drag and Drop:** Move tasks between columns using drag-and-drop functionality.
- **Task Details:** View detailed information about each task, including creation date, description, and time tracking.
- **Comments:** Add and view comments on tasks.
- **Time Tracking:** Start and stop a timer for each task to track time spent.

## Technologies Used

- **Flutter:** For building the cross-platform mobile application.
- **GetX:** For state management and dependency injection.
- **Google Fonts:** For custom text styling.
- **Dio:** For network requests (if used for API interactions).
- **Hive:** For local storage (if used).

## Getting Started

### Prerequisites

- Flutter SDK installed on your machine.
- An IDE or text editor of your choice (e.g., VSCode, Android Studio).

### Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/yourusername/kanban_board.git
    cd kanban_board
    ```

2. Install dependencies:

    ```bash
    flutter pub get
    ```

3. Run the app:

    ```bash
    flutter run
    ```

## Usage

### Adding a Task

- Tap the floating action button (+) to open the task modal.
- Enter the task title and description, then submit.

### Viewing Task Details

- Tap on a task card to view its details.
- Use the options to start/stop the timer or update the task status.

### Dragging Tasks

- Long press and drag a task card to move it between columns.

### Comments

- Add comments in the comment section of the task details screen.

## Folder Structure

- **lib/**
    - **controllers/**: Contains controllers for managing state and business logic.
    - **models/**: Data models for tasks and comments.
    - **views/**: Screens and widgets for the UI.
    - **widgets/**: Reusable UI components.
    - **services/**: API services and local storage handling.

## Dependencies

- `flutter`
- `get`
- `google_fonts`
- (Additional dependencies if any)

## Contributing

Feel free to submit issues or pull requests. Please ensure to follow the coding standards and write clear commit messages.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
