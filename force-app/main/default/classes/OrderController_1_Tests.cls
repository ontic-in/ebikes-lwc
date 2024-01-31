
@isTest
private class OrderController_1_Tests {
    // Existing test setup and other test methods remain the same

    // Exceptional Scenario
    @isTest
    static void testGetOrderItemsWithNullId() {
        // Act
        Test.startTest();
        Order_Item__c[] orderItems = OrderController.getOrderItems(null);
        Test.stopTest();
        
        // Assert
        System.assertEquals(0, orderItems.size(), 'Should return an empty list for null orderId');
    }
}
