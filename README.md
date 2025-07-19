# Mini-POS Checkout Core

This project is a logic-only, headless checkout engine for a mini (POS) system. It's built with pure Dart and the BLoC pattern for state management, focusing entirely on robust business logic and comprehensive unit testing without a UI layer.

-----

## ✨ Features

  - [cite\_start]**Product Catalog Management**: Loads a static product catalog from a JSON asset. [cite: 49]
  - [cite\_start]**Comprehensive Shopping Cart**: Supports adding, removing, changing item quantities, and applying line-item discounts. [cite: 50]
  - [cite\_start]**Totals Calculation**: Instantly calculates subtotal, VAT (15%), total discount, and grand total. [cite: 51]
  - [cite\_start]**Receipt Generation**: A pure function `buildReceipt` creates a clean receipt model (DTO) ready for printing or UI rendering. [cite: 52]
  - [cite\_start]**Undo/Redo Functionality**: Revert and re-apply the last cart actions. [cite: 62]
  - [cite\_start]**State Persistence**: The cart state survives app restarts using `hydrated_bloc`. [cite: 63]
  - [cite\_start]**Currency Formatting Helper**: A Dart extension (`.asMoney`) to format numbers into a two-decimal currency string. [cite: 66]

-----

## 🛠️ Tech Stack & Dependencies

  - **Flutter**: 3.x
  - **Dart**: 3.x
  - [cite\_start]**bloc**: `^9.0.0` [cite: 92]
  - [cite\_start]**hydrated\_bloc**: `^10.1.1` For state persistence [cite: 63]
  - [cite\_start]**equatable**: `^2.0.7` [cite: 93]
  - [cite\_start]**bloc\_test**: `^10.0.0` [cite: 95]
  - [cite\_start]**path\_provider**: `^2.1.5` [cite: 95]

-----

## 🚀 Setup & Running Tests

To set up the project and run the test suite, follow these steps from your terminal:

1.  **Get Dependencies:**

    ```bash
    flutter pub get
    ```

2.  **Run All Unit Tests:**

    ```bash
    flutter test
    ```

3.  **Run Tests with Coverage Report:**

    ```bash
    flutter test --coverage
    ```

-----

## ✅ Task Fulfillment Summary

  - **Time Spent**: Approximately 4 hours (including implementation, debugging, and testing).
  - **Completed Requirements**:
      - [cite\_start]All mandatory requirements (1-7) from the task description were fully implemented. [cite: 54]
      - [cite\_start]All key optional ("Nice-to-have") features were also completed, including Undo/Redo [cite: 62][cite\_start], state hydration [cite: 63][cite\_start], and the currency formatting extension. [cite: 66]