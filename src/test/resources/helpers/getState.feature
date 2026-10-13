@ignore
Feature: Consultar el estado actual

  Scenario: Consultar estado
    Given url baseUrl
    And path slug, 'estado'
    When method get
    Then status 200
