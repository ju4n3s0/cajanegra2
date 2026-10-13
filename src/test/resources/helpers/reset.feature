@ignore
Feature: Reiniciar el sistema

  Scenario: Reiniciar
    Given url baseUrl
    And path slug, 'reiniciar'
    When method post
    Then status 200
