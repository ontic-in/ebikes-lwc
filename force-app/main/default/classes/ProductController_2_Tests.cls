
@isTest
private class ProductController_2_Tests {
    
    @testSetup
    static void setup() {
        // Assuming Product_Family__c is a valid object and relates to Product__c
        // Set up test data
        Product_Family__c family = new Product_Family__c(Name = 'Test Family');
        insert family;
        
        List<Product__c> products = new List<Product__c>();
        for (Integer i = 0; i < 5; i++) {
            products.add(new Product__c(
                Name = 'Test Product ' + i,
                Product_Family__c = family.Id
            ));
        }
        insert products;
    }
    
    @isTest
    static void testGetSimilarProductsWithValidIds() {
        // Arrange
        Product_Family__c family = [SELECT Id FROM Product_Family__c LIMIT 1];
        List<Product__c> existingProducts = [SELECT Id FROM Product__c WHERE Product_Family__c = :family.Id];
        Id testProductId = existingProducts[0].Id;
        
        // Act
        Product__c[] similarProducts = ProductController.getSimilarProducts(testProductId, family.Id);
        
        // Assert
        System.assertNotEquals(null, similarProducts, 'The result should not be null.');
        System.assertEquals(existingProducts.size() - 1, similarProducts.size(), 'There should be one less product returned since we are excluding the test product.');
    }
    
    @isTest
    static void testGetSimilarProductsWithNoMatches() {
        // Arrange
        Product_Family__c family = [SELECT Id FROM Product_Family__c LIMIT 1];
        Product__c testProduct = new Product__c(
            Name = 'Non-Family Product',
            Product_Family__c = null // Product not part of the family
        );
        insert testProduct;
        
        // Act
        Product__c[] similarProducts = ProductController.getSimilarProducts(testProduct.Id, family.Id);
        
        // Assert
        System.assertNotEquals(null, similarProducts, 'The result should not be null.');
        System.assertEquals(0, similarProducts.size(), 'There should be no similar products returned.');
    }
    
    @isTest
    static void testGetSimilarProductsNullProductId() {
        // Arrange
        Product_Family__c family = [SELECT Id FROM Product_Family__c LIMIT 1];
        
        // Act
        Product__c[] similarProducts = ProductController.getSimilarProducts(null, family.Id);
        
        // Assert
        System.assertEquals(0, similarProducts.size(), 'The method should handle null productId gracefully and return an empty list.');
    }
    
    @isTest
    static void testGetSimilarProductsNullFamilyId() {
        // Arrange
        List<Product__c> existingProducts = [SELECT Id FROM Product__c LIMIT 1];
        Id testProductId = existingProducts[0].Id;
        
        // Act
        Product__c[] similarProducts = ProductController.getSimilarProducts(testProductId, null);
        
        // Assert
        System.assertEquals(0, similarProducts.size(), 'The method should handle null familyId gracefully and return an empty list.');
    }
}
