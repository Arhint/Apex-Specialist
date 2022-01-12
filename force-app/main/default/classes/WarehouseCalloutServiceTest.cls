@IsTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    @isTest 
    static void testGetCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 
        WarehouseCalloutService w = new WarehouseCalloutService();
        Test.startTest();
        System.enqueueJob(w);
        Test.stopTest();
        List<Product2> prod2 = [SELECT Replacement_Part__c,
                                    Cost__c,
                                    Maintenance_Cycle__c,
                                    Current_Inventory__c
                            FROM Product2];
        System.assertEquals(true, prod2[0].Replacement_Part__c);
    }
}