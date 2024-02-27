
@isTest
private class ProductController_1_Tests {

    @testSetup
    static void setup() {
        // Create test data for Product__c
        List<Product__c> products = new List<Product__c>{
            // Add Product__c records with various attributes
            new Product__c(Name='Test Product 1', MSRP__c=100.0, Category__c='Electronics', Level__c='High', Material__c='Plastic'),
            new Product__c(Name='Test Product 2', MSRP__c=150.0, Category__c='Home Appliances', Level__c='Medium', Material__c='Metal')
            // Note: Ensure that the fields and values are valid as per your Salesforce org's schema
        };
        
        // Insert test data into the database
        insert products;
        
        // If necessary, bypass triggers here using your org's specific trigger management framework
    }

    @isTest
    static void testGetProductsHappyPath() {
        ProductController.Filters filters = new ProductController.Filters();
        filters.maxPrice = 200.0;
        filters.categories = new String[]{'Electronics'};
        Integer pageNumber = 1;

        Test.startTest();
        ProductController.PagedResult result = ProductController.getProducts(filters, pageNumber);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertTrue(result.records.size() <= ProductController.PAGE_SIZE, 'Should not exceed page size');
    }

    @isTest
    static void testGetProductsWithoutFilters() {
        Integer pageNumber = 1;

        Test.startTest();
        ProductController.PagedResult result = ProductController.getProducts(null, pageNumber);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertTrue(result.records.size() <= ProductController.PAGE_SIZE, 'Should not exceed page size');
    }

    @isTest
    static void testGetProductsWithInvalidPageNumber() {
        ProductController.Filters filters = new ProductController.Filters();
        Integer pageNumber = -1;

        Test.startTest();
        try {
            ProductController.PagedResult result = ProductController.getProducts(filters, pageNumber);
            System.assert(false, 'Method should throw an exception for an invalid page number');
        } catch (Exception e) {
            // Expected exception was thrown, test passes
        }
        Test.stopTest();
    }

    @isTest
    static void testGetProductsWithSpecificFilters() {
        ProductController.Filters filters = new ProductController.Filters();
        filters.maxPrice = 150.0;
        filters.categories = new String[]{'Home Appliances'};
        Integer pageNumber = 1;

        Test.startTest();
        ProductController.PagedResult result = ProductController.getProducts(filters, pageNumber);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, result, 'Result should not be null');
        for (Product__c prod : result.records) {
            System.assert(prod.MSRP__c <= 150.0, 'Product price should be less than or equal to 150.0');
            System.assert(prod.Category__c.equals('Home Appliances'), 'Product category should be Home Appliances');
        }
    }

    @isTest
    static void testGetProductsBoundaryTest() {
        ProductController.Filters filters = new ProductController.Filters();
        filters.maxPrice = 200.0;
        Integer pageNumber = 1; // Testing the first page

        Test.startTest();
        ProductController.PagedResult result = ProductController.getProducts(filters, pageNumber);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(1, result.pageNumber, 'The page number should be 1');
        System.assertTrue(result.records.size() <= ProductController.PAGE_SIZE, 'Should not exceed page size');
    }

    @isTest
    static void testGetProductsWithInvalidFilters() {
        ProductController.Filters filters = new ProductController.Filters();
        filters.categories = new String[]{'NonExistentCategory'};
        Integer pageNumber = 1;

        Test.startTest();
        ProductController.PagedResult result = ProductController.getProducts(filters, pageNumber);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(0, result.totalItemCount, 'Total item count should be 0 for invalid filters');
    }
}
