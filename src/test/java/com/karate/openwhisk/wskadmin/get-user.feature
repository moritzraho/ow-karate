#Author: rtripath@adobe.com
# Summary :This feature file can be used to get action destils using action name
@ignore
Feature: Create Namespace

Background:
* configure ssl = true
 
 
  Scenario: Get NS credentials
    Given url AdminBaseUrl
    * print "I am here in get-user"
    * def DBpath =
    """
   
    if (BaseUrl == 'https://controller-a-rtbetaa-ue1-b.runtime.adobe.io')
    {
     DBpath = '/whisk_local_subjects/';
    }
    else{
     DBpath = '/local_subjects/';
    }
    
    """
    #And path '/whisk_local_subjects/'+nameSpace
    And path DBpath+nameSpace
    And header Authorization = AdminAuth
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    And string NScreds = response
   * def uuid = $response.namespaces[*].uuid
   * def key = $response.namespaces[*].key
   * def result = uuid[0]+':'+ key[0]
    #* def uuid = $response.namespaces[*].uuid
    * print result
    
    

 
