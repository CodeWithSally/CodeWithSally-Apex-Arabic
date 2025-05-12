
@isTest
private class CountryTriggerHandlerTest {

    @isTest
    static void testCountryAPICallout() {
        // Set up mock response
        Test.setMock(HttpCalloutMock.class, new CountryMockResponse());

        Test.startTest();
            Country__c countryObj = new Country__c(Name = 'Canada');
            insert countryObj;
        Test.stopTest();

        // Assert fields were updated by the callout future method
        Country__c result = [SELECT Capital__c, Region__c FROM Country__c WHERE Name = 'Canada'];
        System.assertEquals('Ottawa', result.Capital__c, 'Capital should match mock data.');
        System.assertEquals('Americas', result.Region__c, 'Region should match mock data.');
    }
}