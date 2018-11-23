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
@smoketests

Feature: This feature file will test the Api gateway internal redirect feature for web actions

  Background:
    * configure ssl = true
    * configure readTimeout = 1200000
    * def nameSpace = test_user_ns
    * def webActionFunc = read('classpath:com/karate/openwhisk/functions/webAction.js')
    * def getAuth = callonce read('classpath:com/karate/openwhisk/utils/get-auth.feature')
    * def Auth = getAuth.Auth

    # Actions to test
    * def actionNameOkEcho = 'apigw-redirect-ok-echo'
    * def actionNameBadXAccelRedirect = 'apigw-redirect-bad-x-accel-redirect'
    * def actionNameBadRedirectBackToCluster = 'apigw-redirect-bad-back-to-cluster'
    * def actionNameBadRedirectPrivateIpV4 = 'apigw-redirect-bad-ipv4'
    * def actionNameBadRedirectPrivateIpV6 = 'apigw-redirect-bad-ipv6'
    * def actionNameBadRedirectResolvesPrivateIpV4 = 'apigw-redirect-bad-resolves-ipv4'
    * def actionNameBadRedirectResolvesPrivateIpV6 = 'apigw-redirect-bad-resolves-ipv6'

    # Redirction urls for each test action
    * def echoEndpoint = 'https://postman-echo.com/get'
    * def resolvesPrivateIpv4 = 'http://testprivatev4.qe.adobe-runtime.com'
    * def resolvesPrivateIpv6 = 'http://testprivatev6.qe.adobe-runtime.com'
    * def privateIpv4 = 'http://10.66.20.126'
    * def privateIpv6 = 'http://[fdad:bc8e:2787:a258::]'
    * def xAccelRedirectUri = '/'
    * def backToClusterUrl = BaseUrl + "/api/v1/web/" + nameSpace + "/default/" + actionNameOkEcho

  Scenario: TC08-A- Test API-Gateway redirect feature
    * print 'TC08 STARTS'

    # Create Actions.
    * def actionCodeOkEcho = webActionFunc('{"X-Action-Redirect-Url": "' + echoEndpoint + '", "X-Action-Redirect-Headers": ["x-test-req: test", "x-test-req2: test2"], "X-Action-Response-Headers": ["x-test-res: test", "x-test-res2: test2"] }')
    * def createOkAction = call read('classpath:com/karate/openwhisk/wskactions/create-action.feature') {script:'#(actionCodeOkEcho)' ,nameSpace:'#(nameSpace)' ,Auth:'#(Auth)',actionName:'#(actionNameOkEcho)', webAction: 'true'}
    * print "Successfully created needed web actions for test case"

    # Invoke Actions and match.
    * print 'invoking good action x accel redirect expected 200 and echo redirect headers + correct response headers'
    * def invokeAction = call read('classpath:com/karate/openwhisk/wskactions/invoke-web-action.feature') {nameSpace:'#(nameSpace)',actionName: '#(actionNameOkEcho)'}
    * match invokeAction.responseStatus == 200
    * match invokeAction.response contains {'url': '#(echoEndpoint)'}
    # here headers are the redirect request headers echoed from the service (in the body)
    * match invokeAction.response.headers contains {'x-test-req': 'test', 'x-test-req2': 'test2'}
    # here we check that custom response headers were set after apigw redirected to echoing service
    * match invokeAction.responseHeaders contains {'x-test-res': [test], 'x-test-res2': [test2]}
    * match invokeAction.responseHeaders contains {'X-Action-Redirected': ['1']} || {'x-action-redirected': ['1']}

    * print "Successfully invoked web action with api-gw redirect feature to " + echoEndpoint + " + checked that redirect and response headers are fine."

    # Delete Actions
    * def deleteAction = call read('classpath:com/karate/openwhisk/wskactions/delete-action.feature') {actionName: '#(actionNameOkEcho)' ,nameSpace:'#(nameSpace)' ,Auth:'#(Auth)'}
    * print "Successfully deleted the actions"

    Scenario: TC08-B- Test API-Gateway redirect feature security
    # Create Actions.
    * def actionCodeBadXAccelRedirect = webActionFunc('{"X-Accel-Redirect": "'+ xAccelRedirectUri +'"}', '{"notRedirected": "true"}')
    * def actionCodeBadRedirectBackToCluster = webActionFunc('{"X-Action-Redirect-Url": "' + backToClusterUrl + '"}')
    * def actionCodeBadRedirectPrivateIpV4 = webActionFunc('{"X-Action-Redirect-Url": "' + privateIpv4 + '"}')
    * def actionCodeBadRedirectPrivateIpV6 = webActionFunc('{"X-Action-Redirect-Url": "' + privateIpv6 + '"}')
    * def actionCodeBadRedirectResolvesPrivateIpV4 = webActionFunc('{"X-Action-Redirect-Url": "' + resolvesPrivateIpv4 + '"}')
    * def actionCodeBadRedirectResolvesPrivateIpV6 = webActionFunc('{"X-Action-Redirect-Url": "' + resolvesPrivateIpv6 + '"}')
    * call read('classpath:com/karate/openwhisk/wskactions/create-action.feature') {script:'#(actionCodeBadXAccelRedirect)' ,nameSpace:'#(nameSpace)' ,Auth:'#(Auth)',actionName:'#(actionNameBadXAccelRedirect)', webAction: 'true'}
    * call read('classpath:com/karate/openwhisk/wskactions/create-action.feature') {script:'#(actionCodeBadRedirectBackToCluster)' ,nameSpace:'#(nameSpace)' ,Auth:'#(Auth)',actionName:'#(actionNameBadRedirectBackToCluster)', webAction: 'true'}
    * call read('classpath:com/karate/openwhisk/wskactions/create-action.feature') {script:'#(actionCodeBadRedirectPrivateIpV4)' ,nameSpace:'#(nameSpace)' ,Auth:'#(Auth)',actionName:'#(actionNameBadRedirectPrivateIpV4)', webAction: 'true'}
    * call read('classpath:com/karate/openwhisk/wskactions/create-action.feature') {script:'#(actionCodeBadRedirectPrivateIpV6)' ,nameSpace:'#(nameSpace)' ,Auth:'#(Auth)',actionName:'#(actionNameBadRedirectPrivateIpV6)', webAction: 'true'}
    * call read('classpath:com/karate/openwhisk/wskactions/create-action.feature') {script:'#(actionCodeBadRedirectResolvesPrivateIpV4)' ,nameSpace:'#(nameSpace)' ,Auth:'#(Auth)',actionName:'#(actionNameBadRedirectResolvesPrivateIpV4)', webAction: 'true'}
    * call read('classpath:com/karate/openwhisk/wskactions/create-action.feature') {script:'#(actionCodeBadRedirectResolvesPrivateIpV6)' ,nameSpace:'#(nameSpace)' ,Auth:'#(Auth)',actionName:'#(actionNameBadRedirectResolvesPrivateIpV6)', webAction: 'true'}
    * print "Successfully created needed web actions for test case"

    * print 'invoking bad action x accel redirect expected 200 {"notRedirected": "true"}'
    * def invokeAction = call read('classpath:com/karate/openwhisk/wskactions/invoke-web-action.feature') {nameSpace:'#(nameSpace)',actionName: '#(actionNameBadXAccelRedirect)'}
    * match invokeAction.responseStatus == 200
    * match invokeAction.response contains {"notRedirected": "true"}

    * print 'invoking bad action redirect back to cluster expecting 502'
    * def invokeAction = call read('classpath:com/karate/openwhisk/wskactions/invoke-web-action.feature') {nameSpace:'#(nameSpace)',actionName: '#(actionNameBadRedirectBackToCluster)'}
    * match invokeAction.responseStatus == 502

    * print 'invoking bad action redirect to private ipv4 expecting 200 with empty body (dont let attacker now)'
    * def invokeAction = call read('classpath:com/karate/openwhisk/wskactions/invoke-web-action.feature') {nameSpace:'#(nameSpace)',actionName: '#(actionNameBadRedirectPrivateIpV4)'}
    * match invokeAction.responseStatus == 200
    * match invokeAction.response == ''

    * print 'invoking bad action redirect to private ipv6 expecting 200 with empty body (dont let attacker now)'
    * def invokeAction = call read('classpath:com/karate/openwhisk/wskactions/invoke-web-action.feature') {nameSpace:'#(nameSpace)',actionName: '#(actionNameBadRedirectPrivateIpV6)'}
    * match invokeAction.responseStatus == 200

    * print 'invoking bad action redirect to host resolving to private ipv4 expecting 200 with empty body (dont let attacker now)'
    * def invokeAction = call read('classpath:com/karate/openwhisk/wskactions/invoke-web-action.feature') {nameSpace:'#(nameSpace)',actionName: '#(actionNameBadRedirectResolvesPrivateIpV4)'}
    * match invokeAction.responseStatus == 200

    * print 'invoking bad action redirect to host resolving to private ipv4 expecting 200 with empty body (dont let attacker now)'
    * def invokeAction = call read('classpath:com/karate/openwhisk/wskactions/invoke-web-action.feature') {nameSpace:'#(nameSpace)',actionName: '#(actionNameBadRedirectResolvesPrivateIpV6)'}
    * match invokeAction.responseStatus == 200

    * print "Successfully passed security tests for api gw redirect feature"

    # Delete Actions
    * def deleteAction = call read('classpath:com/karate/openwhisk/wskactions/delete-action.feature') {actionName: '#(actionNameOkEcho)' ,nameSpace:'#(nameSpace)' ,Auth:'#(Auth)'}
    * def deleteAction = call read('classpath:com/karate/openwhisk/wskactions/delete-action.feature') {actionName: '#(actionNameBadXAccelRedirect)' ,nameSpace:'#(nameSpace)' ,Auth:'#(Auth)'}
    * def deleteAction = call read('classpath:com/karate/openwhisk/wskactions/delete-action.feature') {actionName: '#(actionNameBadRedirectBackToCluster)' ,nameSpace:'#(nameSpace)' ,Auth:'#(Auth)'}
    * def deleteAction = call read('classpath:com/karate/openwhisk/wskactions/delete-action.feature') {actionName: '#(actionNameBadRedirectPrivateIpV4)' ,nameSpace:'#(nameSpace)' ,Auth:'#(Auth)'}
    * def deleteAction = call read('classpath:com/karate/openwhisk/wskactions/delete-action.feature') {actionName: '#(actionNameBadRedirectPrivateIpV6)' ,nameSpace:'#(nameSpace)' ,Auth:'#(Auth)'}
    * def deleteAction = call read('classpath:com/karate/openwhisk/wskactions/delete-action.feature') {actionName: '#(actionNameBadRedirectResolvesPrivateIpV4)' ,nameSpace:'#(nameSpace)' ,Auth:'#(Auth)'}
    * def deleteAction = call read('classpath:com/karate/openwhisk/wskactions/delete-action.feature') {actionName: '#(actionNameBadRedirectResolvesPrivateIpV6)' ,nameSpace:'#(nameSpace)' ,Auth:'#(Auth)'}
    * print "Successfully deleted the actions"

    * print 'TC08 ENDS'
