# Corporate - Cheques App

This project was generated with [Angular CLI](https://github.com/angular/angular-cli).

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The app will automatically reload if you change any of the source files.

## Build

Run `ng build` to build the project. The build artifacts will be stored in the `dist/` directory.

## Running Tests

### End-to-End Tests (Cypress + Cucumber)

This project uses Cypress with Cucumber for BDD/TDD.

**Run in Interactive Mode (TDD workflow):**
Opens the Cypress Test Runner. Useful for writing tests and debugging.
```bash
npm run cypress:open
```

**Run in Headless Mode (CI/CD):**
Runs all feature files in the terminal without opening the browser UI.
```bash
npm run cypress:run
```

### Unit Tests

Run `ng test` to execute the unit tests via [Karma](https://karma-runner.github.io).
