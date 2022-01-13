trigger MaintenanceRequest on Case (after update) {

    if (Trigger.isAfter)
    {
        if (Trigger.isUpdate) {
            MaintenanceRequestHelper.afterUpdateMethod(Trigger.new, Trigger.oldMap);
        }
    }
}