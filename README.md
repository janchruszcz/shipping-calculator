# Shipping Calculator

## Overview

This project is a small, lightweight Ruby service designed to return best shipping options based on input criteria.

## Architectural Choices

### Small Service vs. Full Rails Application

I chose to implement this as a small service rather than a full Ruby on Rails application for several reasons:

1. **Focused Functionality**: The shipping calculator has a specific, well-defined purpose that doesn't require the full feature set of Rails.
2. **Performance**: A smaller, more focused application can be more performant and have a smaller memory footprint.
3. **Scalability**: This design allows for easier horizontal scaling and potential microservice architecture in the future.
4. **Simplicity**: With fewer dependencies and a more straightforward structure, the application is easier to understand, maintain, and deploy.

### Modular Design

The application is structured into several modules and classes, each with a specific responsibility:

- `Models`: Represent core domain objects (Sailing, Rate, ExchangeRate)
- `Repositories`: Handle data access and storage
- `Calculators`: Implement different calculation strategies
- `Services`: Coordinate between different parts of the application
- `Factories`: Create objects based on runtime conditions

This modular approach allows for easy extension and modification of the system.

## Design Patterns

1. **Repository Pattern**: Used for data access abstraction (SailingRepository, RateRepository, ExchangeRateRepository).
2. **Strategy Pattern**: Different calculation strategies (CheapestCalculator, CheapestDirectCalculator, FastestCalculator) implement a common interface.
3. **Factory Pattern**: CalculatorFactory creates the appropriate calculator based on the given criteria.
4. **Dependency Injection**: Dependencies are injected into classes, promoting loose coupling and easier testing.

## SOLID Principles

1. **Single Responsibility Principle**: Each class has a single, well-defined responsibility (e.g., RateRepository is only responsible for managing rates).
2. **Open/Closed Principle**: New calculation strategies can be added without modifying existing code.
3. **Liskov Substitution Principle**: Different calculator types can be used interchangeably.
4. **Interface Segregation Principle**: Interfaces are kept small and focused (e.g., separate repositories for different data types).
5. **Dependency Inversion Principle**: High-level modules depend on abstractions, not concrete implementations.

## Testing

The project uses RSpec for testing, with a focus on unit tests for individual components and integration tests for the overall application behavior. Factory Bot is used to create test data.

## How to Run

### Using Ruby

1. Ensure you have Ruby installed (version 3.2.2 or higher).
2. Clone the repository.
3. Run `bundle install` to install dependencies.
4. Use the `bin/calculate` script to run calculations.
5. Follow the prompts to enter origin port, destination port, and calculation criteria.

### Using Docker

1. Ensure you have Docker installed on your system.
2. Clone the repository.
3. Build the Docker image:
   ```
   docker build -t shipping-calculator .
   ```
4. Run the application in a Docker container:
   ```
   docker run -it shipping-calculator
   ```
5. Follow the prompts to enter origin port, destination port, and calculation criteria.