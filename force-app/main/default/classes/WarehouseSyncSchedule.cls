global class WarehouseSyncSchedule implements Schedulable {
    global void execute(SchedulableContext SC) {
        System.enqueueJob(new WarehouseCalloutService()); 
    }
}