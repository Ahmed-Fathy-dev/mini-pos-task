# Mini-POS Checkout Core

This project is a logic-only, headless checkout engine for a mini (POS) system. It's built with pure Dart and the BLoC pattern for state management, focusing entirely on robust business logic and comprehensive unit testing without a UI layer.

-----

## Features

  - **Product Catalog Management**: Loads a static product catalog from a JSON asset. 
  - **Comprehensive Shopping Cart**: Supports adding, removing, changing item quantities, and applying line-item discounts. 
  - **Totals Calculation**: Instantly calculates subtotal, VAT (15%), total discount, and grand total. 
  - **Receipt Generation**: A pure function `buildReceipt` creates a clean receipt model (DTO) ready for printing or UI rendering. 
  - **Undo/Redo Functionality**: Revert and re-apply the last cart actions. 
  - **State Persistence**: The cart state survives app restarts using `hydrated_bloc`. 
  - **Currency Formatting Helper**: A Dart extension (`.asMoney`) to format numbers into a two-decimal currency string. 

-----

##  Tech Stack & Dependencies

  - **Flutter**: `3.32.4`
  - **Dart**: `3.8.1`
  - **bloc**: `^9.0.0` 
  - **hydrated\_bloc**: `^10.1.1` For state persistence 
  - **equatable**: `^2.0.7` 
  - **bloc\_test**: `^10.0.0` 
  - **path\_provider**: `^2.1.5` 

-----

##  Setup & Running Tests

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

##  Task Fulfillment Summary

  - **Time Spent**: Approximately 4 hours (including implementation, debugging, and testing).
  - **Completed Requirements**:
      - All mandatory requirements (1-7) from the task description were fully implemented. 
      - All key optional ("Nice-to-have") features were also completed, including Undo/Redo  state hydration  and the currency formatting extension. 
