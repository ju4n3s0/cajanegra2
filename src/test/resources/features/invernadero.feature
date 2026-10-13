@api @invernadero
Feature: Invernadero hidroponico - tabla de decision

  Background:
    Given url baseUrl
    And path 'decision', 'invernadero', 'reiniciar'
    When method post
    Then status 200

  @smoketest @Issue-8 @REQ-INVERNADERO-00
  Scenario: La definicion expone 3 condiciones y 4 reglas
    Given url baseUrl
    And path 'decision', 'invernadero', 'definicion'
    When method get
    Then status 200
    And match response.totalReglas == 4
    And match response.condiciones == '#[3]'
    And match response.historial == '#[0]'

  @smoketest @Issue-9 @REQ-INVERNADERO-01
  Scenario: Regla 1 - helada activa calefactores y suspende riego
    Given url baseUrl
    And path 'decision', 'invernadero', 'evaluar'
    And request { valores: [false, false, true] }
    When method post
    Then status 200
    And match karate.toString(response) contains 'calefactores'
    Given path 'decision', 'invernadero', 'definicion'
    When method get
    Then status 200
    And match response.historial == '#[1]'

  @Issue-10 @REQ-INVERNADERO-02
  Scenario: Regla 2 - sustrato seco inicia riego estandar
    Given url baseUrl
    And path 'decision', 'invernadero', 'evaluar'
    And request { valores: [true, false, false] }
    When method post
    Then status 200
    And match karate.toString(response) contains 'nutritiva'
    Given path 'decision', 'invernadero', 'definicion'
    When method get
    Then status 200
    And match response.historial == '#[1]'

  @Issue-11 @REQ-INVERNADERO-03
  Scenario: Regla 3 - seco con pH acido bloquea riego y neutraliza
    Given url baseUrl
    And path 'decision', 'invernadero', 'evaluar'
    And request { valores: [true, true, false] }
    When method post
    Then status 200
    And match karate.toString(response) contains 'neutralizaci'
    Given path 'decision', 'invernadero', 'definicion'
    When method get
    Then status 200
    And match response.historial == '#[1]'

  @Issue-12 @REQ-INVERNADERO-04
  Scenario: Regla 4 - sin condiciones mantiene sistemas en espera
    Given url baseUrl
    And path 'decision', 'invernadero', 'evaluar'
    And request { valores: [false, false, false] }
    When method post
    Then status 200
    And match karate.toString(response) contains 'espera'
    Given path 'decision', 'invernadero', 'definicion'
    When method get
    Then status 200
    And match response.historial == '#[1]'
