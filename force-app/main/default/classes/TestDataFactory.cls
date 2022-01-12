@isTest
public with sharing class TestDataFactory {
    public static List<Case> createCases(Integer numCases) {

        //create Vehicle
        Vehicle__c veh = new Vehicle__c(Name='For test'); 
        
        insert veh;

        //Create Product2 (Equipment)
        List<Product2> equipmentList = new List<Product2>();
        for (Integer i = 0; i < 5; i++) {
            Product2 eq = new Product2();
            eq.Name = 'Prod ' + i;
            eq.Maintenance_Cycle__c = i + 20;
            eq.Replacement_Part__c = true; // for lookupfilter on Equipment Maintenance Item when creating error
            equipmentList.add(eq);
        }
        insert equipmentList;

        //Create Case (Maintenance Request)
        List<Case> cases = new List<Case>();
        for(Integer i=0; i<numCases; i++) {
            Case newCase = new Case();
            newCase.Type = 'Routine Maintenance';
            newCase.Origin = 'Web';
            newCase.Subject = 'Not emty_' + i;
            newCase.Status = 'New';
            newCase.Vehicle__c = veh.id;
            // newCase.ProductId = equipmentList[Math.Mod(i, 5)].id;
            newCase.Date_Due__c = Date.today().addDays(-i);
            cases.add(newCase);
        }
        insert cases;
        
        //Create Equipment Maintenance Item
        List<Equipment_Maintenance_Item__c> equipmentMainenanceList = new List<Equipment_Maintenance_Item__c>();
        for (Integer i = 0; i < numCases; i++) {
            Equipment_Maintenance_Item__c eqMI = new Equipment_Maintenance_Item__c();
            eqMI.Maintenance_Request__c = cases[i].id;
            eqMI.Equipment__c = equipmentList[Math.Mod(i, 5)].id;
            eqMI.Quantity__c = i + 1;
            equipmentMainenanceList.add(eqMI);
        }
        insert equipmentMainenanceList;

        return cases;
    }
}