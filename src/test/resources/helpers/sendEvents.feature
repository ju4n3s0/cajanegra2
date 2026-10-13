@ignore
Feature: Enviar una lista de eventos en orden

  Scenario: Enviar eventos
    * def calls = karate.map(events, function(e){ return { slug: slug, evento: e } })
    * call read('classpath:helpers/sendOne.feature') calls
