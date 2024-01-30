
@isTest
private class ProductController_1_Tests {

    @testSetup
    static void setup() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Create test products
        List<Product__c> products = new List<Product__c>();
        for(Integer i = 0; i < 30; i++) {
            Product__c prod = new Product__c(
                Name = 'TestProduct' + i,
                MSRP__c = 100 + i
                // Populate other necessary fields as required
            );
            products.add(prod);
        }
        insert products; // Insert all products at once
    }

    @isTest
    static void testGetProductsWithFilters() {
        // Create sample filters
        ProductController.Filters filters = new ProductController.Filters();
        filters.searchKey = 'TestProduct1';
        filters.maxPrice = 150;
        // Set other filters if needed

        // Perform test
        Test.startTest();
        ProductController.PagedResult results = ProductController.getProducts(filters, 1);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, results, 'Results should not be null.');
        System.assertEquals(1, results.records.size(), 'Expected one matching product.');
    }

    @isTest
    static void testGetProductsWithNoFilters() {
        // Create empty filters
        ProductController.Filters filters = new ProductController.Filters();
        
        // Perform test
        Test.startTest();
        ProductController.PagedResult results = ProductController.getProducts(filters, 1);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, results, 'Results should not be null.');
        System.assertTrue(results.records.size() > 0, 'Expected some products without filters.');
    }

    @isTest
    static void testGetProductsPagination() {
        // Create empty filters for pagination test
        ProductController.Filters filters = new ProductController.Filters();
        
        // Perform test
        Test.startTest();
        ProductController.PagedResult results = ProductController.getProducts(filters, 2);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, results, 'Results should not be null.');
        System.assertEquals(ProductController.PAGE_SIZE, results.pageSize, 'Expected page size to be as defined.');
        System.assertEquals(2, results.pageNumber, 'Expected to retrieve the second page of products.');
    }

    @isTest
    static void testGetProductsWithNullFilters() {
        // Perform test with null filters
        Test.startTest();
        ProductController.PagedResult results = ProductController.getProducts(null, 1);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, results, 'Results should not be null.');
        System.assertTrue(results.records.size() > 0, 'Expected some products even when no filters are applied.');
    }

    @isTest
    static void testGetProductsWithInvalidPageNumber() {
        // Perform test with invalid page number
        Boolean exceptionThrown = false;
        ProductController.Filters filters = new ProductController.Filters();
        
        // Attempt to retrieve products with an invalid page number
        Test.startTest();
        try {
            ProductController.PagedResult results = ProductController.getProducts(filters, -1);
        } catch (Exception e) {
            exceptionThrown = e instanceof System.QueryException;
        }
        Test.stopTest();

        // Assertions
        System.assertTrue(exceptionThrown, 'An exception of type System.QueryException should be thrown for invalid page number.');
    }
}
