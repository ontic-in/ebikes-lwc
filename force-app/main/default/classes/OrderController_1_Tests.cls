
@isTest
private class OrderController_1_Tests {
    
    // Setup method to create test data
    @testSetup
    static void setupTestData() {
        // As Order__c is a custom object, we need to ensure that it is created correctly as an SObject
        // Create Order
        Order__c testOrder = new Order__c(Name = 'Test Order');
        insert testOrder; // Correct usage of DML operation on a single SObject

        // Create Order Items
        Order_Item__c item1 = new Order_Item__c(
            Order__c = testOrder.Id,
            Qty_S__c = 5,
            Price__c = 100
        );
        Order_Item__c item2 = new Order_Item__c(
            Order__c = testOrder.Id,
            Qty_M__c = 10,
            Price__c = 200
        );
        // Insert the order items using a List of SObjects
        insert new List<Order_Item__c>{item1, item2}; // Correct usage of DML operation on a list of SObjects
    }

    // Happy Path scenario
    @isTest
    static void testGetOrderItemsWithValidOrderId() {
        // Use SOQL to get a valid Order Id for testing
        Test.startTest();
        Id orderId = [SELECT Id FROM Order__c LIMIT 1].Id;
        
        // Act
        Order_Item__c[] orderItems = OrderController.getOrderItems(orderId);
        Test.stopTest();
        
        // Assert
        System.assertEquals(2, orderItems.size(), 'Should return 2 order items for the order');
        System.assertNotEquals(null, orderItems[0].Product__r.Name, 'Product name should not be null');
    }

    // Sad Path scenario
    @isTest
    static void testGetOrderItemsWithNoAssociatedItems() {
        // Create a second Order with no associated items
        Order__c testOrder = new Order__c(Name = 'Test Order 2');
        insert testOrder; // Correct usage of DML operation on a single SObject
        
        Test.startTest();
        
        // Act
        Order_Item__c[] orderItems = OrderController.getOrderItems(testOrder.Id);
        Test.stopTest();
        
        // Assert
        System.assertEquals(0, orderItems.size(), 'Should return an empty list for order with no items');
    }

    // Exceptional Scenario
    @isTest
    static void testGetOrderItemsWithNullId() {
        Exception caughtException = null;
        try {
            // Act
            Test.startTest();
            Order_Item__c[] orderItems = OrderController.getOrderItems(null);
            Test.stopTest();
        } catch (Exception e) {
            // Catch any type of exception thrown by passing null
            caughtException = e;
        }
        
        // Assert that an exception was thrown
        System.assertNotEquals(null, caughtException, 'An exception should have been thrown for passing null as orderId');
        // Also, we can assert on the exception message if needed, and if it is specific to the scenario
    }
}
