
@isTest
private class ProductController_2_Tests {

    @testSetup
    static void setup() {
        // Create test data here
        Product_Family__c family = new Product_Family__c(Name='TestFamily');
        insert family;

        List<Product__c> products = new List<Product__c>();
        for (Integer i = 0; i < 5; i++) {
            products.add(new Product__c(
                Name = 'TestProduct' + i,
                Product_Family__c = family.Id
            ));
        }
        insert products;
    }

    @isTest
    static void shouldReturnSimilarProducts() {
        // Bypass Account triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Retrieve a product to use for the test
        Product__c product = [SELECT Id, Product_Family__c FROM Product__c LIMIT 1];

        // Call the method under test
        Product__c[] similarProducts = ProductController.getSimilarProducts(product.Id, product.Product_Family__c);

        // Assert that the returned products are not null and there are similar products
        System.assertNotEquals(null, similarProducts, 'Similar products should not be null');
        System.assert(similarProducts.size() > 0, 'Should return similar products');
    }

    @isTest
    static void shouldReturnEmptyWhenNoSimilarProducts() {
        // Bypass Account triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Create a new family to ensure no similar products exist
        Product_Family__c family = new Product_Family__c(Name='UnrelatedFamily');
        insert family;

        // Retrieve a product from the test setup data
        Product__c product = [SELECT Id, Product_Family__c FROM Product__c LIMIT 1];

        // Call the method under test with a family that has no products associated
        Product__c[] similarProducts = ProductController.getSimilarProducts(product.Id, family.Id);

        // Assert that the returned list is empty
        System.assertEquals(0, similarProducts.size(), 'Should return empty list when no similar products exist');
    }

    @isTest
    static void shouldHandleNullProductAndFamilyId() {
        // Bypass Account triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Test for null productId and familyId
        // Since the method parameters are not annotated as Nullable, passing null will result in a runtime error
        // The test verifies that the method throws an exception when null values are passed

        Boolean exceptionThrownProduct = false;
        Boolean exceptionThrownFamily = false;

        // Test with null productId
        try {
            ProductController.getSimilarProducts(null, 'someFamilyId');
        } catch (Exception e) {
            exceptionThrownProduct = true;
            // Check if the exception message is as expected
            System.assert(e.getMessage().contains('Argument 1 cannot be null'), 'Expected exception for null product ID.');
        }

        // Assert that an exception was thrown for null productId
        System.assert(exceptionThrownProduct, 'An exception should have been thrown for null product ID.');

        // Test with null familyId
        try {
            ProductController.getSimilarProducts('someProductId', null);
        } catch (Exception e) {
            exceptionThrownFamily = true;
            // Check if the exception message is as expected
            System.assert(e.getMessage().contains('Argument 2 cannot be null'), 'Expected exception for null family ID.');
        }

        // Assert that an exception was thrown for null familyId
        System.assert(exceptionThrownFamily, 'An exception should have been thrown for null family ID.');
    }
}
