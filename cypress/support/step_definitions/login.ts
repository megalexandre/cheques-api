import { Given, Then, When } from "@badeball/cypress-cucumber-preprocessor";

Given("I visit the page {string}", (url: string) => {
  cy.visit(url);
});

Then("I should see the login form", () => {
    // Assuming there is a form on the login page
    cy.get("form").should("exist");
});

When("I enter valid credentials name {string} and password {string}", (email: string, password: string) => {
    // Intercept the API call to mock a successful login response
    cy.intercept("POST", "**/auth/signin", {
        statusCode: 200,
        body: {
            status: "success",
            data: {
                _id: "fake-id",
                username: "Test User",
                email: "test@example.com"
            },
            token: "fake-jwt-token"
        }
    }).as("loginRequest");

    // Use specific selectors based on the formControlName
    cy.get('input[formControlName="email"]').clear().type(email);
    cy.get('input[formControlName="password"]').clear().type(password);
});

When("I click the login button", () => {
    cy.get('button[type="submit"]').click();
});

Then("I should be redirected to the dashboard", () => {
    // Wait for the login request to finish
    cy.wait("@loginRequest");
    
    // Check if the URL changed to the root (dashboard)
    // The component redirects to '/' on success
    cy.url().should("eq", Cypress.config().baseUrl + "/");
});
