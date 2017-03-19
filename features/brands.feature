@no-database-cleaner
Feature: Brands

  Background:
    Given the current user is:
      | email    | mail@mail.com |
      | password | 123456        |

  Scenario: Create a brand
    When I send a POST request to "/v1/brands" with the following:
      | name |
      | Moca |
    Then the response status should be "201"
    And the JSON response should be:
      """
        {"name": "Moca"}
      """

  Scenario: Get all brands
    When I send a GET request to "/v1/brands"
    Then the response status should be "200"
    And the JSON response should be:
      """
        [
          {"name": "Moca"}
        ]
      """

  Scenario: Returns specific brand
    When I send a GET request to "/v1/brands/1"
    Then the response status should be "200"
    And the JSON response should be:
      """
        {"name": "Moca"}
      """

  Scenario: Update a brand
    When I send a PUT request to "/v1/brands/1" with the following:
      | name |
      | Moça |
    Then the response status should be "200"
    And the JSON response should be:
      """
        {"name": "Moça"}
      """

  Scenario: Delete a brand
    When I send a DELETE request to "/v1/brands/1"
    Then the response status should be "204"
