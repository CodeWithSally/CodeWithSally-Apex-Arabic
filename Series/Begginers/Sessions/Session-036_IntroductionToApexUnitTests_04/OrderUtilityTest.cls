@isTest
public class OrderUtilityTest {
    
    @testSetup 
    static void prepareData(){
        //can be move to test Data factory 
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    }

    //Positive: valid Product Id, Valid Quantity and account id ==> Order to be created
    @isTest
    static void testCreateOrderPositive() {
        // Prepare Data
        Account accountObj = [Select Id FROM Account limit 1];
        String productId = 'PROD-123';
        Integer quantity = 5;

        // Call the code we want to test
        Order result = OrderUtility.createOrder(productId, quantity,accountObj.Id);

        // Assert
        Order addedOrder = [SELECT Quantity__c, ProductId__c, Status, AccountId 
                            FROM Order 
                            WHERE Id = :result.Id];
        
        Assert.isNotNull(addedOrder, 'Order should not be null.');
        Assert.areEqual('PROD-123', addedOrder.ProductId__c, 'Product ID should match input.');
        Assert.areEqual(5, addedOrder.Quantity__c, 'Quantity should match input.');
        Assert.areEqual('Draft', addedOrder.Status, 'Status should be Draft.');
        Assert.areEqual(accountObj.Id, addedOrder.AccountId, 'AccountId should match the associated Account.');
    }
    
     
    //Negative 1: Invalid product id
    @isTest
    static void testCreateOrderMissingProductId() {
        //prepare the data 
        Integer quantity=5;
        Account accountObj = [Select Id FROM Account limit 1];
        
        try{
            Order result = OrderUtility.createOrder(null, quantity,accountObj.Id);
            Assert.fail('Expected an error for missing Product ID.'); //forcing test method to fail 
        }catch (IllegalArgumentException e) {
            Assert.areEqual('Product ID is required.', e.getMessage(), 'Expected error message for missing Product ID.');
        }
    }
    
    
    //Negative 2: Valid Product id but invalid quantity (HW)
    //Negative 3:valid product id and quantity but invalid Account ID (HW)
}