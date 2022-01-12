public with sharing class WarehouseCalloutService implements Queueable, Database.AllowsCallouts {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

    public void execute(QueueableContext context) {

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) {
            List<Product2> prodListToInsert = new List<Product2>();
            List<Object> objectsList = (List<Object>)JSON.deserializeUntyped(response.getBody());
            for (Object key : objectsList) {
                Map<String, Object> mapItem = (Map<String, Object>) key;
                Product2 newProduct = new Product2();
                newProduct.Replacement_Part__c = True;
                newProduct.Cost__c = Integer.valueOf(mapItem.get('cost'));
                newProduct.Current_Inventory__c = Integer.valueOf(mapItem.get('quantity'));
                newProduct.Lifespan_Months__c = Integer.valueOf(mapItem.get('lifespan'));
                newProduct.Maintenance_Cycle__c = Integer.valueOf(mapItem.get('maintenanceperiod'));
                newProduct.Warehouse_SKU__c = String.valueOf(mapItem.get('sku'));
                newProduct.Name = String.valueOf(mapItem.get('name'));
                prodListToInsert.add(newProduct);
            }
            if (prodListToInsert.size() > 0) {
                upsert prodListToInsert Warehouse_SKU__c;
            }
        }
    }
}