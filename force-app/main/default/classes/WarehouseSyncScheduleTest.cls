@isTest
public with sharing class WarehouseSyncScheduleTest {
    // implement scheduled code here
    public static String cronExp = '0 0 1 * * ?';

    @isTest
    static void testSyncShedule() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 

        Test.startTest();
        String jobId = System.schedule('WarehouseSyncScheduleTest', cronExp, new WarehouseSyncSchedule());
        Test.stopTest();

        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
        NextFireTime
        FROM CronTrigger WHERE id = :jobId];

        // Verify the expressions are the same
        System.assertEquals(cronExp, ct.CronExpression);

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
    }
}