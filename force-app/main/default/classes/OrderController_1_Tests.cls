
@isTest
private class OrderController_1_Tests {

    @testSetup
    static void setup() {
        // Create test record for Account (assuming Account__c is a custom object or could be a standard Account object)
        Account testAccount = new Account(Name = 'Test Account');
        // Populate other required fields for Account here if any
        insert testAccount;

        // Create test record for Product
        Product__c testProduct = new Product__c(Name = 'Test Product', MSRP__c = 100.00, Picture_URL__c = 'http://example.com/picture.jpg');
        insert testProduct;

        // Create test record for Order linked to the Account
        Order__c testOrder = new Order__c(Account__c = testAccount.Id);
        insert testOrder;

        // Create an Order_Item__c record related to the Order and Product.
        Order_Item__c testOrderItem = new Order_Item__c(
            Order__c = testOrder.Id,
            Product__c = testProduct.Id,
            Qty_S__c = 1,
            Qty_M__c = 2,
            Qty_L__c = 3,
            Price__c = 200.00
        );
        insert testOrderItem;
    }

    // Test when orderId has related Order_Item__c records.
    @isTest
    static void testGetOrderItemsWithResult() {
        Test.startTest();
        // Fetch the test data
        Order__c testOrder = [SELECT Id FROM Order__c LIMIT 1];
        // Execute the method
        Order_Item__c[] orderItems = OrderController.getOrderItems(testOrder.Id);
        Test.stopTest();
        // Assertions
        System.assertEquals(1, orderItems.size(), 'Should return exactly one order item.');
        System.assertEquals(200.00, orderItems[0].Price__c, 'The price of the order item should be 200.00.');
    }

    // Test when orderId doesn't have any related Order_Item__c records.
    @isTest
    static void testGetOrderItemsWithoutResult() {
        Test.startTest();
        // Reuse the Account record created in setup() to satisfy the required field.
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        // Create a new Order record that has no related Order_Item__c records.
        Order__c newOrder = new Order__c(Account__c = testAccount.Id);
        insert newOrder;
        // Execute the method
        Order_Item__c[] orderItems = OrderController.getOrderItems(newOrder.Id);
        Test.stopTest();
        // Assertions
        System.assertEquals(0, orderItems.size(), 'Should return an empty list for an order with no items.');
    }

    // Test when null orderId is passed.
    @isTest
    static void testGetOrderItemsWithNullId() {
        Test.startTest();
        // Execute the method with null Id
        Order_Item__c[] orderItems = OrderController.getOrderItems(null);
        Test.stopTest();
        // Assertions
        System.assertEquals(0, orderItems.size(), 'Should handle null orderId gracefully.');
    }
}
