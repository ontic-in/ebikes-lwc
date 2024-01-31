
@isTest
private class ProductController_1_Tests {

    private class PagedResultStub {
        public Integer pageSize;
        public Integer pageNumber;
        public Integer totalItemCount;
        public List<Product__c> records;
    }
    
    @testSetup
    static void setup() {
        // Disable triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Create test products
        List<Product__c> products = new List<Product__c>();
        for(Integer i = 0; i < 25; i++) {
            products.add(new Product__c(
                Name = 'TestProduct' + i,
                MSRP__c = 100 + i // Assuming MSRP__c is a currency field
                // Add other required fields as per your custom object definition
            ));
        }
        insert products;
    }

    @isTest
    static void testGetProductsWithFilters() {
        // Assume filters are set correctly and pageNumber is valid
        ProductController.Filters filters = new ProductController.Filters();
        filters.searchKey = 'TestProduct1';
        filters.maxPrice = 150;
        // ... other filter settings ...

        Test.startTest();
        PagedResultStub results = (PagedResultStub) JSON.deserialize(JSON.serialize(ProductController.getProducts(filters, 1)), PagedResultStub.class);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, results, 'Results should not be null.');
        System.assert(results.records.size() > 0, 'Expected at least one matching product.');
    }

    @isTest
    static void testGetProductsWithNoFilters() {
        // Assume no filters are set and pageNumber is valid
        ProductController.Filters filters = new ProductController.Filters();
        
        Test.startTest();
        PagedResultStub results = (PagedResultStub) JSON.deserialize(JSON.serialize(ProductController.getProducts(filters, 1)), PagedResultStub.class);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, results, 'Results should not be null.');
        System.assert(results.records.size() > 0, 'Expected some products without filters.');
    }

    // ... Additional test methods here ...

}
