@no-database-cleaner
Feature: Products

  Background:
    Given the current user is:
      | email    | mail@mail.com |
      | password | 123456        |

  Scenario: Create Data
    Given the following "Brands":
      | id | name |
      | 1  | Moça |

  Scenario: Create a product
    When I send a POST request to "/v1/products" with the following:
      | name  | brand_id |
      | Leite | 1        |
    Then the response status should be "201"
    And the JSON response should be:
      """
        {"name": "Leite", "brand": {"name": "Moça"}}
      """

  Scenario: Get all products
    When I send a GET request to "/v1/products"
    Then the response status should be "200"
    And the JSON response should be:
      """
        [
          {"name": "Leite", "brand": {"name": "Moça"}}
        ]
      """

  Scenario: Returns specific product
    When I send a GET request to "/v1/products/1"
    Then the response status should be "200"
    And the JSON response should be:
      """
        {"name": "Leite", "brand": {"name": "Moça"}}
      """

  Scenario: Update a product
    When I send a PUT request to "/v1/products/1" with the following:
      | name             | brand_id |
      | Leite condensado | 1        |
    Then the response status should be "200"
    And the JSON response should be:
      """
        {"name": "Leite condensado", "brand": {"name": "Moça"}}
      """

  Scenario: Delete a product
    When I send a DELETE request to "/v1/products/1"
    Then the response status should be "204"
