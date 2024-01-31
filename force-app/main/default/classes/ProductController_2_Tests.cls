
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
        // Arrange
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        Product__c product = [SELECT Id, Product_Family__c FROM Product__c LIMIT 1];
        
        // Act
        Product__c[] similarProducts = ProductController.getSimilarProducts(product.Id, product.Product_Family__c);
        
        // Assert
        System.assertNotEquals(null, similarProducts, 'Similar products should not be null');
        System.assert(similarProducts.size() > 0, 'Should return similar products');
    }
    
    @isTest
    static void shouldReturnEmptyWhenNoSimilarProducts() {
        // Arrange
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        Product_Family__c family = new Product_Family__c(Name='UnrelatedFamily');
        insert family;
        
        Product__c product = [SELECT Id, Product_Family__c FROM Product__c LIMIT 1];
        
        // Act
        Product__c[] similarProducts = ProductController.getSimilarProducts(product.Id, family.Id);
        
        // Assert
        System.assertEquals(0, similarProducts.size(), 'Should return empty list when no similar products exist');
    }

    @isTest
    static void shouldHandleNullProductAndFamilyId() {
        // Arrange
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Act and Assert for null product ID
        Boolean caughtExceptionForNullProduct = false;
        try {
            ProductController.getSimilarProducts(null, 'someFamilyId');
        } catch (Exception e) {
            caughtExceptionForNullProduct = true;
        }
        System.assert(caughtExceptionForNullProduct, 'An exception should have been thrown for null product ID.');
        
        // Act and Assert for null family ID
        Boolean caughtExceptionForNullFamily = false;
        try {
            ProductController.getSimilarProducts('someProductId', null);
        } catch (Exception e) {
            caughtExceptionForNullFamily = true;
        }
        System.assert(caughtExceptionForNullFamily, 'An exception should have been thrown for null family ID.');
    }
}
