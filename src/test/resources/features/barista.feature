@api @baristaBot
Feature: Barista Bot - transicion de estados

  Background:
    * call read('classpath:helpers/reset.feature') { slug: 'barista-bot' }

  @smoketest @Issue-1 @REQ-BARISTA-01
  Scenario: Iniciar pedido desde En Espera pasa a Moliendo
    Given url baseUrl
    And path 'barista-bot', 'evento'
    And request { evento: 'Iniciar Pedido' }
    When method post
    Then status 200
    * def state = call read('classpath:helpers/getState.feature') { slug: 'barista-bot' }
    * match state.response.estadoActual == 'Moliendo'

  @Issue-2 @REQ-BARISTA-02
  Scenario: Terminar molienda pasa a Calentando Agua
    * call read('classpath:helpers/sendEvents.feature') { slug: 'barista-bot', events: ['Iniciar Pedido'] }
    Given url baseUrl
    And path 'barista-bot', 'evento'
    And request { evento: 'Terminar Molienda' }
    When method post
    Then status 200
    * def state = call read('classpath:helpers/getState.feature') { slug: 'barista-bot' }
    * match state.response.estadoActual == 'Calentando Agua'

  @Issue-3 @REQ-BARISTA-03
  Scenario: Alcanzar temperatura pasa a Sirviendo
    * call read('classpath:helpers/sendEvents.feature') { slug: 'barista-bot', events: ['Iniciar Pedido', 'Terminar Molienda'] }
    Given url baseUrl
    And path 'barista-bot', 'evento'
    And request { evento: 'Alcanzar Temperatura' }
    When method post
    Then status 200
    * def state = call read('classpath:helpers/getState.feature') { slug: 'barista-bot' }
    * match state.response.estadoActual == 'Sirviendo'

  @Issue-4 @REQ-BARISTA-04
  Scenario: Terminar llenado vuelve a En Espera
    * call read('classpath:helpers/sendEvents.feature') { slug: 'barista-bot', events: ['Iniciar Pedido', 'Terminar Molienda', 'Alcanzar Temperatura'] }
    Given url baseUrl
    And path 'barista-bot', 'evento'
    And request { evento: 'Terminar Llenado' }
    When method post
    Then status 200
    * def state = call read('classpath:helpers/getState.feature') { slug: 'barista-bot' }
    * match state.response.estadoActual == 'En Espera'

  @Issue-5 @REQ-BARISTA-05
  Scenario: Sin ingredientes pasa a Error de Insumos
    * call read('classpath:helpers/sendEvents.feature') { slug: 'barista-bot', events: ['Iniciar Pedido'] }
    Given url baseUrl
    And path 'barista-bot', 'evento'
    And request { evento: 'Sin Ingredientes' }
    When method post
    Then status 200
    * def state = call read('classpath:helpers/getState.feature') { slug: 'barista-bot' }
    * match state.response.estadoActual == 'Error de Insumos'

  @Issue-6 @REQ-BARISTA-06
  Scenario: Recargar y reiniciar vuelve a En Espera
    * call read('classpath:helpers/sendEvents.feature') { slug: 'barista-bot', events: ['Iniciar Pedido', 'Sin Ingredientes'] }
    Given url baseUrl
    And path 'barista-bot', 'evento'
    And request { evento: 'Recargar y Reiniciar' }
    When method post
    Then status 200
    * def state = call read('classpath:helpers/getState.feature') { slug: 'barista-bot' }
    * match state.response.estadoActual == 'En Espera'

  @Issue-7 @REQ-BARISTA-07
  Scenario Outline: Bloquear transiciones no permitidas
    * def events = setup == 'ninguno' ? [] : setup.split(',')
    * def args = { slug: 'barista-bot', events: [] }
    * set args.events = events
    * call read('classpath:helpers/sendEvents.feature') args
    Given url baseUrl
    And path 'barista-bot', 'evento'
    And request { evento: '#(evento)' }
    When method post
    Then match [200, 400, 409, 422] contains responseStatus
    * def state = call read('classpath:helpers/getState.feature') { slug: 'barista-bot' }
    * match state.response.estadoActual == estado

    Examples:
      | setup                           | estado          | evento               |
      | ninguno                         | En Espera       | Terminar Molienda    |
      | ninguno                         | En Espera       | Alcanzar Temperatura |
      | Iniciar Pedido                  | Moliendo        | Iniciar Pedido       |
      | Iniciar Pedido,Terminar Molienda | Calentando Agua | Terminar Molienda    |