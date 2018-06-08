#Author: rtripath@adobe.com
# Summary :This feature file will check for the containers

@resiliency
@ignore

Feature:  Restart Scenarios.Restart defined services at regular intervals

  Background:
* configure ssl = true
* def sheepCountValue =  '300'

  Scenario: RST1-As an automation tester I want to check the response of the user functions when the Invoker is restarted
     #Sleep for sheepCountValue seconds
    * def sleep =  call read('classpath:com/karate/openwhisk/utils/sleep.feature') {sheepCount:'#(sheepCountValue)'}
    
    #Call the server feature to restart the Invoker Instance
   * def testscenarios = call read('classpath:com/karate/openwhisk/marathonapi/restart-service.feature') {serviceName:'invoker-a'}
   * print  = "Successfully Restarted Invoker"
   #Sleep for sheepCountValue seconds
   * def sleep =  call read('classpath:com/karate/openwhisk/utils/sleep.feature') {sheepCount:'#(sheepCountValue)'}
   * def runtests = call read('classpath:com/karate/openwhisk/resiliency/tests/resiliency-test-cases.feature')    
  
    
       
   Scenario: RST2-As an automation tester I want to check the response of the user functions when the Kafka is restarted
     #Call the server feature to restart the Invoker Instance
   * def testscenarios = call read('classpath:com/karate/openwhisk/marathonapi/restart-service.feature') {serviceName:'kafka-a'}
   * print  = "Successfully Restarted Kafka"
    #Sleep for sheepCountValue seconds
    * def sleep =  call read('classpath:com/karate/openwhisk/utils/sleep.feature') {sheepCount:'#(sheepCountValue)'}
   * def runtests = call read('classpath:com/karate/openwhisk/resiliency/tests/resiliency-test-cases.feature')
    
   
    
    
    Scenario: RST3-As an automation tester I want to check the response of the user functions when the Controller is restarted
    #Call the server feature to restart the Controller Instance
   * def testscenarios = call read('classpath:com/karate/openwhisk/marathonapi/restart-service.feature') {serviceName:'controller-a'}
   * print  = "Successfully Restarted Controller"
   #Sleep for sheepCountValue seconds
    * def sleep =  call read('classpath:com/karate/openwhisk/utils/sleep.feature') {sheepCount:'#(sheepCountValue)'}
   * def runtests = call read('classpath:com/karate/openwhisk/resiliency/tests/resiliency-test-cases.feature')    
  
    
     
       
   Scenario: RST4-As an automation tester I want to check the response of the user functions when the Couch-DB is restarted
     #Call the server feature to restart the Couch-DB Instance
   * def testscenarios = call read('classpath:com/karate/openwhisk/marathonapi/restart-service.feature') {serviceName:'whisk-couchdb'}
   * print  = "Successfully Restarted Couch-DB"
    #Sleep for sheepCountValue seconds
    * def sleep =  call read('classpath:com/karate/openwhisk/utils/sleep.feature') {sheepCount:'#(sheepCountValue)'}
   * def runtests = call read('classpath:com/karate/openwhisk/resiliency/tests/resiliency-test-cases.feature')
    
    
    
    
    Scenario: RST5-As an automation tester I want to check the response of the user functions when the APIgateway is restarted
   #Call the server feature to restart the apigateway Instance
   * def testscenarios = call read('classpath:com/karate/openwhisk/marathonapi/restart-service.feature') {serviceName:'apigateway'}
   * print  = "Successfully Restarted APIgateway"
    #Sleep for sheepCountValue seconds
    * def sleep =  call read('classpath:com/karate/openwhisk/utils/sleep.feature') {sheepCount:'#(sheepCountValue)'}
   * def runtests = call read('classpath:com/karate/openwhisk/resiliency/tests/resiliency-test-cases.feature')    
  
   
     
       
   Scenario: RST6-As an automation tester I want to check the response of the user functions when the aqua-agent is restarted
     #Call the server feature to restart the AQUA-AGENT Instance
   * def testscenarios = call read('classpath:com/karate/openwhisk/marathonapi/restart-service.feature') {serviceName:'aqua-agent'}
   * print  = "Successfully Restarted aqua-agent"
   #Sleep for sheepCountValue seconds
    * def sleep =  call read('classpath:com/karate/openwhisk/utils/sleep.feature') {sheepCount:'#(sheepCountValue)'}
   * def runtests = call read('classpath:com/karate/openwhisk/resiliency/tests/resiliency-test-cases.feature')
    
     
    
    
    
    Scenario: RST7-As an automation tester I want to check the response of the user functions when the 	exhibitor-a is restarted
   #Call the server feature to restart the 	exhibitor-a Instance
   * def testscenarios = call read('classpath:com/karate/openwhisk/marathonapi/restart-service.feature') {serviceName:'exhibitor-a'}
   * print  = "Successfully Restarted exhibitor"
   #Sleep for sheepCountValue seconds
    * def sleep =  call read('classpath:com/karate/openwhisk/utils/sleep.feature') {sheepCount:'#(sheepCountValue)'}
   * def runtests = call read('classpath:com/karate/openwhisk/resiliency/tests/resiliency-test-cases.feature')    
  
    
     
       
   Scenario: RST8-As an automation tester I want to check the response of the user functions when the ethos-fluentd is restarted
     #Call the server feature to restart the Invoker Instance
   * def testscenarios = call read('classpath:com/karate/openwhisk/marathonapi/restart-service.feature') {serviceName:'ethos-fluentd'}
   * print  = "Successfully Restarted fluentd"
   #Sleep for sheepCountValue seconds
    * def sleep =  call read('classpath:com/karate/openwhisk/utils/sleep.feature') {sheepCount:'#(sheepCountValue)'}
   * def runtests = call read('classpath:com/karate/openwhisk/resiliency/tests/resiliency-test-cases.feature')
    
    
     
       
   Scenario: RST09-As an automation tester I want to check the response of the user functions when the ethos-datadog is restarted
     #Call the server feature to restart the Invoker Instance
   * def testscenarios = call read('classpath:com/karate/openwhisk/marathonapi/restart-service.feature') {serviceName:'ethos-datadog'}
   * print  = "Successfully Restarted datadog"
    #Sleep for sheepCountValue seconds
    * def sleep =  call read('classpath:com/karate/openwhisk/utils/sleep.feature') {sheepCount:'#(sheepCountValue)'}
   * def runtests = call read('classpath:com/karate/openwhisk/resiliency/tests/resiliency-test-cases.feature')
    
   
    
   
    Scenario: RST10-As an automation tester I want to check the response of the user functions when the agentfill is restarted
     #Call the server feature to restart the Invoker Instance
   * def testscenarios = call read('classpath:com/karate/openwhisk/marathonapi/restart-service.feature') {serviceName:'agentfill'}
   * print  = "Successfully Restarted agentfill"
   * def runtests = call read('classpath:com/karate/openwhisk/resiliency/tests/resiliency-test-cases.feature')
    
      
  
    
    
    