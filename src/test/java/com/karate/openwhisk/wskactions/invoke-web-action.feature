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
#Author: raho@adobe.com
# Summary :This feature file will check for the containers

@ignore
Feature:  Invoke web action and return activation ID

  Background:
    * configure ssl = true

  Scenario: As a user I want to invoke a web action by sending a GET a request
    * eval
 		"""
			if (typeof packageName == 'undefined') {
				karate.set('packageName', 'default');
			}
      if (typeof params == 'undefined') {
				karate.set('params', '');
			}
 		"""
    * def path = '/api/v1/web/'+nameSpace+'/'+packageName+'/'+actionName+params
    Given url BaseUrl+path
    When method get
    #check response, responseHeaders and responseStatus
