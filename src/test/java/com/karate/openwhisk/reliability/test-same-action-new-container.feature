#Author: rtripath@adobe.com
# Summary :This feature file can be used to get action destils using action name
@ignore
Feature: Get Action

Background:
* configure ssl = true
 
  Scenario: Get Activation Details
     
#Get Activation details
    * def path = '/api/v1/namespaces/_/activations/'+activationId
    Given url BaseUrl+path
    And header Authorization = Auth
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    And def activationDetails = response
    * print 'Activation ID for the Invoke action(I was here in activation details ' + activationId
    * def json = response.annotations[4]
     And match json contains { "key": "initTime"}
     * print 'Test Case Passed with Activation ID'+activationId
   
     