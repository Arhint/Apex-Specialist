@isTest
public with sharing class WarehouseSyncScheduleTest {
    // implement scheduled code here
    private static String cron_exp = '0 0 0 * * 2022';

    @isTest
    static void testSyncShedule() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 
        Test.startTest();

        Test.stopTest();
    }
}