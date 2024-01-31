
@isTest
private class ProductController_1_Tests {

    @testSetup
    static void setup() {
        // Create test data here
        // Disable triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        List<Product__c> products = new List<Product__c>();
        // Create a list of products with various attributes
        for(Integer i = 0; i < 30; i++) {
            Product__c prod = new Product__c(
                Name = 'TestProduct' + i,
                MSRP__c = 100 + i
                // ... other fields ...
            );
            products.add(prod);
        }
        insert products; // Bulk insert to use in tests
    }

    @isTest
    static void testGetProductsWithFilters() {
        // Test with some filters applied
        ProductController.Filters filters = new ProductController.Filters();
        filters.searchKey = 'TestProduct1';
        filters.maxPrice = 150;
        // ... other filter settings ...

        Test.startTest();
        ProductController.PagedResult results = ProductController.getProducts(filters, 1);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, results, 'Results should not be null.');
        System.assertEquals(1, results.records.size(), 'Expected one matching product.');
    }

    @isTest
    static void testGetProductsWithNoFilters() {
        // Test with no filters
        ProductController.Filters filters = new ProductController.Filters();
        
        Test.startTest();
        ProductController.PagedResult results = ProductController.getProducts(filters, 1);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, results, 'Results should not be null.');
        System.assertTrue(results.records.size() > 0, 'Expected some products without filters.');
        System.assertEquals(results.pageNumber, 1, 'Expected the requested page number.');
    }

    @isTest
    static void testGetProductsPagination() {
        // Test pagination by querying the second page
        ProductController.Filters filters = new ProductController.Filters();
        
        Test.startTest();
        ProductController.PagedResult results = ProductController.getProducts(filters, 2);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, results, 'Results should not be null.');
        System.assertEquals(ProductController.PAGE_SIZE, results.pageSize, 'Page size should be as defined.');
        System.assertEquals(2, results.pageNumber, 'Should be the second page.');
        System.assertTrue(results.records.size() <= ProductController.PAGE_SIZE, 'Results should be within page size.');
    }

    @isTest
    static void testGetProductsWithNullFilters() {
        // Test with null filters
        Test.startTest();
        ProductController.PagedResult results = ProductController.getProducts(null, 1);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, results, 'Results should not be null.');
        System.assertTrue(results.records.size() > 0, 'Expected some products with null filters.');
        System.assertEquals(results.pageNumber, 1, 'Expected the requested page number.');
    }

    @isTest
    static void testGetProductsWithInvalidPageNumber() {
        // Test with invalid page number; Expect an exception or no results
        ProductController.Filters filters = new ProductController.Filters();
        ProductController.PagedResult results = null;

        Boolean exceptionThrown = false;
        try {
            Test.startTest();
            results = ProductController.getProducts(filters, -1);
            Test.stopTest();
        } catch (Exception e) {
            exceptionThrown = true;
            // Assert the exception type or message if needed
            System.assert(e instanceof QueryException, 'Expected a QueryException due to invalid page number.');
        }

        // Perform assertions only if no exception was thrown
        if (!exceptionThrown && results != null) {
            System.assertEquals(0, results.records.size(), 'Expected no results with invalid page number.');
        }
    }
}
