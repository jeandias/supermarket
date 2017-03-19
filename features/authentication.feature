@no-database-cleaner
Feature: Authentication

  @cleaner
  Scenario: Create Data
    Given the following "Users":
      | id | name | email         | password | password_confirmation |
      | 1  | user | mail@mail.com | 123456   | 123456                |

  Scenario: User is not authorized
    When I send a POST request to "/v1/authenticate" with the following:
      | email         | password |
      | mail@mail.com | 12345    |
    Then the response status should be "401"
    And the JSON response should be:
      """
        { "message": { "user_authentication": ["invalid credentials"] } }
      """

  Scenario: User is authorized
    When I send a POST request to "/v1/authenticate" with the following:
      | email         | password |
      | mail@mail.com | 123456   |
    Then the response status should be "201"
    And the JSON response should be:
      """
        {"auth_token": "%r{[a-zA-Z0-9.-]+}"}
      """
