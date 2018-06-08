#Author: rtripath@adobe.com
# Summary :This feature file will check for the containers

@concurrent


Feature:  This feature file will test all the wsk functions.It will use User3 credentails

  Background:
* configure ssl = true
* def nameSpace = NS_botTester10
* def Auth = Auth_botTester10
* def params = '?blocking=true&result=false'
* def scriptcode = call read('classpath:com/karate/openwhisk/functions/hello-world.js')



  Scenario: TC05_ConcurrentUser10-As a user I want to all the wsk functions available to the user and check if they give the proper response
  
 # Create an Action 
     * def createAction = call read('classpath:com/karate/openwhisk/wskactions/create-action.feature') {script:'#(scriptcode)' ,nameSpace:'#(nameSpace)' ,Auth:'#(Auth)'}
     * def actionName = createAction.actName
     * print actName
     * print "Successfully Created an action"
   
     
 # Get Action Details
  * def actionDetails = call read('classpath:com/karate/openwhisk/wskactions/get-action.feature') {nameSpace:'#(nameSpace)' ,Auth:'#(Auth)',actionName:'#(actionName)'}
  * print "Successfully got the action details"
  
  
  
 #Invoke Action
  * def invokeAction = call read('classpath:com/karate/openwhisk/wskactions/invoke-action.feature') {params:'#(params)',requestBody:'',nameSpace:'#(nameSpace)' ,Auth:'#(Auth)',actionName:'#(actionName)'}
  * def actID = invokeAction.activationId
  * print  = "Successfully invoked the action"
  
 #Get Activation details
  * def getActivationDetails = call read('classpath:com/karate/openwhisk/wskactions/get-activation-details.feature') { activationId: '#(actID)' ,Auth:'#(Auth)'}
  * print "Successfully pulled the activation details"
  
  # Update Action
     * def updateAction = call read('classpath:com/karate/openwhisk/wskactions/update-action.feature') {actionName:'#(actionName)',script:'#(scriptcode)' ,nameSpace:'#(nameSpace)' ,Auth:'#(Auth)'}
     * def actionName = createAction.actName
     * print actionName
     * print "Successfully updated the action"
  
  # List Action
     * def listActions = call read('classpath:com/karate/openwhisk/wskactions/list-action.feature') {nameSpace:'#(nameSpace)' ,Auth:'#(Auth)'}
     * print "Successfully pulled up the list of actions"
  
  # Delete Action   
    * def deleteAction = call read('classpath:com/karate/openwhisk/wskactions/delete-action.feature') {actionName:'#(actionName)' ,nameSpace:'#(nameSpace)' ,Auth:'#(Auth)'}
    * print "Successfully deleted the action"
     

     

 