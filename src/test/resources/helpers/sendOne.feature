@ignore
Feature: Enviar un evento

  Scenario: Enviar evento
    Given url baseUrl
    And path slug, 'evento'
    And request { evento: '#(evento)' }
    When method post
    Then status 200
