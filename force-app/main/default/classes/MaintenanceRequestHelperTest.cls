@isTest
public with sharing class MaintenanceRequestHelperTest {
    // implement scheduled code here
    @isTest static void afterUpdateMethodTest() {
        
        Case[] cases = TestDataFactory.createCases(300);
        List<Case> toInsert = new List<Case>();
        for (Case c : cases) {
            c.Status = 'Closed';
            toInsert.add(c);
        }
        if (toInsert.size() == 0) {
            return ;
        }

        Test.startTest();
        Database.update(toInsert);
        Test.stopTest();
        System.assertEquals(600, [SELECT id FROM Case].size());
    }

    @isTest static void afterUpdateMethodTest2() {
        
        Case[] cases = TestDataFactory.createCases(300);
        List<Case> toInsert = new List<Case>();
        for (Case c : cases) {
            c.Status = 'New';
            toInsert.add(c);
        }
        Test.startTest();
        Database.update(toInsert);
        Test.stopTest();
        System.assertEquals(300, [SELECT id FROM Case].size());
    }
}