# Workout Tracker - Flutter Application

## Overview

This project is a **Workout Tracker** app built using **Flutter**. It allows users to track their workouts, manage exercises, and log the number of repetitions and weights used for each set. The app's architecture follows the **MVVM** (Model-View-ViewModel) design pattern, ensuring a clean separation of concerns between the UI, business logic, and state management.

---

## Features

- **Workout Management**: Add, edit, and delete workout sets.
- **State Management**: Utilizes Riverpod for efficient and scalable state management.
- **Navigation**: GoRouter is used for handling app navigation.
- **Test Coverage**: Includes unit and widget tests to ensure reliability and robustness.

---

## Project Architecture

### Model-View-ViewModel (MVVM)

1. **Model**: Represents the core data objects, such as `Workout` and `WorkoutSet`. These classes contain necessary properties and methods for serialization, comparison, and data manipulation.
2. **View**: Flutter UI code that renders the user interface.
3. **ViewModel**: Manages the state of the UI, using **Riverpod** for state management. The `WorkoutListNotifier` and `WorkoutSetNotifier` act as the ViewModel for this app, encapsulating business logic and controlling UI behavior.

### Components

- **Workout Model**: Defines the structure of the workout data, including fields like `date` and `sets`. It includes methods for copying, serializing, and comparing instances.
- **WorkoutSet Model**: Represents a single exercise set with properties such as `exercise`, `weight`, and `repetitions`.
- **State Management**: **Riverpod** is used to manage the application's state globally, ensuring reactive UI updates based on state changes.

---

## Third-Party Packages

### 1. **Riverpod**
   - **Purpose**: Riverpod is used for state management. It provides a clean and testable way to manage states globally without tightly coupling them to the widget tree.
   - **Reason**: Riverpod provides a more scalable and flexible state management solution, especially when dealing with complex app logic.

### 2. **GoRouter**
   - **Purpose**: GoRouter is used for handling the app's navigation.
   - **Reason**: GoRouter simplifies the management of named and URL-based navigation, enabling easy integration of deep linking and path-based navigation in the app.

### 3. **Flutter Test**
   - **Purpose**: Flutter's built-in testing framework is used to write unit and widget tests to verify that the app's features behave as expected.
   - **Reason**: Testing ensures that the app remains reliable and helps catch potential bugs early in the development process.
