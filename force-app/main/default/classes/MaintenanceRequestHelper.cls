public with sharing class MaintenanceRequestHelper {

    public static void afterUpdateMethod(List<Case> newCaseList, Map<id, Case> oldCaseMap) {

        //Get Set od Id's to clone
        Set<Case> toCloneCases = new Set<Case>();        
        for (Case c : newCaseList) {
            if ((c.Type == 'Repair' || c.Type == 'Routine Maintenance')  && c.Status == 'Closed' && c.Status <> oldCaseMap.get(c.id).Status) {
                toCloneCases.add(c);
            }
        }

        if (toCloneCases.size() == 0) {
            return;
        }

        //Get minimum of days to add to new Case Due_date
        Map<id, Decimal> addToDueDate = new Map<Id, Decimal>();
        AggregateResult[] groupedResults = [SELECT Maintenance_Request__c, MIN(Equipment__r.Maintenance_Cycle__c) daysAdd
                                                FROM Equipment_Maintenance_Item__c
                                                WHERE Maintenance_Request__c IN :toCloneCases
                                                GROUP BY Maintenance_Request__c];

        for (AggregateResult ar : groupedResults) {
            addToDueDate.put((Id)ar.get('Maintenance_Request__c'), (Decimal)ar.get('daysAdd'));
        }

        List<Case> insertCaseList = new List<Case>();
        //id of old Case and list of Equipment_Maintenance_Item__c to clone to new Cases
        Map<Id, List<Equipment_Maintenance_Item__c>> MaintenanceItemToCloneMap = new Map<Id, List<Equipment_Maintenance_Item__c>>();
        for (Case c : [SELECT Id, Vehicle__c, (SELECT id, Equipment__c, Quantity__c FROM Equipment_Maintenance_Items__r)
                        FROM Case
                        WHERE Id IN :toCloneCases]) {
            MaintenanceItemToCloneMap.put(c.id, c.Equipment_Maintenance_Items__r);
            Case newCase = new Case();
            newCase.Type = 'Routine Maintenance';
            newCase.Subject = 'Not emty';
            newCase.Date_Reported__c = Date.today();
            Integer addDays = addToDueDate.get(c.Id) != null ? Integer.ValueOf(addToDueDate.get(c.Id)) : 0;
            newCase.Date_Due__c = Date.today().addDays(addDays);
            newCase.Vehicle__c = c.Vehicle__c;
            newCase.Origin = 'Web';
            newCase.ParentId = c.id; //old Case id
            insertCaseList.add(newCase);
        }
        if (insertCaseList.size() > 0) {
            insert insertCaseList;
        }
        
        //Clone Equipment_Maintenance_Item__c and create them with new id of Cases
        List<Equipment_Maintenance_Item__c> equipmentMaintenanceItemToInsert = new List<Equipment_Maintenance_Item__c>();
        for (Case c : insertCaseList) {
            for(Equipment_Maintenance_Item__c em : MaintenanceItemToCloneMap.get(c.ParentId)) {
                Equipment_Maintenance_Item__c newEMI = em.clone();
                newEMI.Maintenance_Request__c = c.Id;
                equipmentMaintenanceItemToInsert.add(newEMI);
            }
        }
        if (equipmentMaintenanceItemToInsert.size() > 0) {
            insert equipmentMaintenanceItemToInsert;
        }
    }
}