
@isTest
private class ProductController_2_Tests {

    @testSetup
    static void setup() {
        // Assuming Product_Family__c is a custom object with a 'Name' field and is correctly defined in the org
        Product_Family__c family = new Product_Family__c(Name='TestFamily');
        insert family;

        // Assuming Product__c is a custom object with fields Name and Product_Family__c (which is a lookup to Product_Family__c)
        List<Product__c> products = new List<Product__c>();
        for (Integer i = 0; i < 3; i++) {
            products.add(new Product__c(
                Name = 'TestProduct' + i,
                Product_Family__c = family.Id
            ));
        }
        insert products;
    }

    @isTest
    static void shouldReturnSimilarProducts() {
        // Bypass unrelated triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Query for a product and its family
        Product_Family__c family = [SELECT Id FROM Product_Family__c LIMIT 1];
        Product__c product = [SELECT Id, Product_Family__c FROM Product__c WHERE Product_Family__c = :family.Id LIMIT 1];

        // Act
        Product__c[] similarProducts = ProductController.getSimilarProducts(product.Id, family.Id);

        // Assert
        System.assertNotEquals(null, similarProducts, 'The similar products list should not be null.');
        System.assertEquals(2, similarProducts.size(), 'There should be 2 similar products.');
    }

    @isTest
    static void shouldReturnEmptyWhenNoSimilarProducts() {
        // Bypass unrelated triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Create a new family that is not related to the existing products
        Product_Family__c newFamily = new Product_Family__c(Name='UnrelatedFamily');
        insert newFamily;

        // Query for a product not related to the new family
        Product__c product = [SELECT Id FROM Product__c LIMIT 1];

        // Act
        Product__c[] similarProducts = ProductController.getSimilarProducts(product.Id, newFamily.Id);

        // Assert
        System.assertEquals(0, similarProducts.size(), 'The returned list should be empty as there are no similar products.');
    }
}
