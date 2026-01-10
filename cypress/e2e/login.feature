Feature: Login functionality

  Scenario: User performs login successfully

    Given I visit the page "/auth/login"
    When I enter valid credentials name "admin@themesbrand.com" and password "123456"
    And I click the login button
    Then I should be redirected to the dashboard
