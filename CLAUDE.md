# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run Commands

```bash
# Build the project
./gradlew build

# Run the application
./gradlew bootRun

# Run all tests
./gradlew test

# Run a single test class
./gradlew test --tests "com.jeju.jeju.JejuApplicationTests"

# Clean build
./gradlew clean build
```

## Project Overview

Spring Boot 4.0.5 application with Java 21, using Gradle 9.4.1 as the build system.

### Technology Stack
- **Web:** Spring MVC with Bean Validation
- **Security:** Spring Security with OAuth2 Client
- **Data:** Spring Data JPA with H2 (dev) and MySQL (prod) support
- **Caching:** Redis

### Package Structure
Base package: `com.jeju.jeju`

## Database Configuration

- H2 in-memory database for development/testing (H2 console enabled)
- MySQL connector available for production
- Redis for caching layer

Configuration file: `src/main/resources/application.yml`