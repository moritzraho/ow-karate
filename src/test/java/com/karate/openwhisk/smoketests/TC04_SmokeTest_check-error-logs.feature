#/*
 #*  Copyright 2017-2018 Adobe.
 #*
 #*  Licensed under the Apache License, Version 2.0 (the "License");
 #*  you may not use this file except in compliance with the License.
 #*  You may obtain a copy of the License at
 #*
 #*          http://www.apache.org/licenses/LICENSE-2.0
 #*
 #*  Unless required by applicable law or agreed to in writing, software
 #*  distributed under the License is distributed on an "AS IS" BASIS,
 #*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 #*  See the License for the specific language governing permissions and
 #*  limitations under the License.
 #*/
#Author: rtripath@adobe.com
#Summary :This feature file will check for any erros in the logs
@smoketests

Feature: This feature file will test for the presence of any error in the logs pulled using the activationID

  Background: 
    * configure ssl = true
    * def nameSpace = test_user_ns
    * def params = '?blocking=true&result=false'
    * def scriptcode = call read('classpath:com/karate/openwhisk/functions/hello-world.js')
    * def getAuth = callonce read('classpath:com/karate/openwhisk/utils/get-auth.feature')
    * def Auth = getAuth.Auth

  Scenario: TC04-As a user I want verify that there are no errors in the logs pulled using the ActivationID
    * print "TC04 STARTS"
    # Create an Action .Create an action for the above defined guest name
    #* def createAction = call read('classpath:com/karate/openwhisk/wskactions/create-action.feature') {script:'#(scriptcode)' ,nameSpace:'#(nameSpace)' ,Auth:'#(Auth)', actionName:'Dammyyy'}
    * def createAction = call read('classpath:com/karate/openwhisk/wskactions/create-action.feature') {script:'#(scriptcode)' ,nameSpace:'#(nameSpace)' ,Auth:'#(Auth)'}
    * def actionName = createAction.actName
    * print actionName
    * print "Successfully Created an action"
    
    # Get Action Details
    * def actionDetails = call read('classpath:com/karate/openwhisk/wskactions/get-action.feature') {nameSpace:'#(nameSpace)' ,Auth:'#(Auth)',actionName:'#(actionName)'}
    * print "Successfully got the action details"
    
    #Invoke Action
    * def invokeAction = call read('classpath:com/karate/openwhisk/wskactions/invoke-action.feature') {params:'#(params)',requestBody:'',nameSpace:'#(nameSpace)' ,Auth:'#(Auth)',actionName:'#(actionName)'}
    * def actID = invokeAction.activationId
    * print  = "Successfully invoked the action"
    * def webhooks = callonce read('classpath:com/karate/openwhisk/utils/sleep.feature') {sheepCount:'20'}
    
    #Get Activation details
    * def getActivationLogs = call read('classpath:com/karate/openwhisk/wskactions/get-activation-logs.feature') { activationId: '#(actID)' ,Auth:'#(Auth)'}
    * def activationLogsResponse = getActivationLogs.response
    * print activationLogsResponse
    * match activationLogsResponse.logs contains ['#regex .* stdout: hello stdout','#regex .* stderr: hello stderr']
    * print "Successfully pulled the activation logs"
    * print "TC04 ENDS"
