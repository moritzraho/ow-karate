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
# Summary :This feature file will check for the containers

@ignore
Feature:  Invoke action and return activation ID

  Background:
* configure ssl = true


  Scenario: As a user I want to invoke an action and return the activationID which can be used for other Test Cases
    * string payload = requestBody
    * def requestBody = {}    
    * def path = '/api/v1/namespaces/'+nameSpace+'/actions/'+actionName+params
    Given url BaseUrl+path
    And header Authorization = Auth
    And header Content-Type = 'application/json'
    And request payload
    When method post
    * def responseStatusCode = responseStatus
    * print 'The value of responseStatusCode is:',responseStatusCode
    
    * eval 
    """
    if(responseStatusCode==200||202){
    	 karate.log("Action got invoked");
    	 karate.set('activationId', response.activationId);
    	 }
    else if(responseStatusCode == 404){
       karate.log("The requested Action does not exist.");
       }
    """
    * print response.activationId
  