public class OrderUtility {
    public static Order createOrder(String productId, Integer quantity,Id accountId) {
        
        //check Product id is valid
        if (String.isEmpty(productId)) {
            throw new IllegalArgumentException('Product ID is required.');
            //productId='1234';
        }
        
        //check if quantity value is valid
        if (quantity == null || quantity <= 0) {
            throw new IllegalArgumentException('Quantity must be greater than zero.');
        }
        
        //check if quantity value is valid
        if (accountId == null) {
            throw new IllegalArgumentException('Account Id is required');
        }
        
        // Mock creation of an Order
        Order newOrder = new Order(ProductId__c = productId, Quantity__c = quantity, Status = 'Draft', EffectiveDate =Date.today(),AccountId=accountId);
        insert newOrder;
        return newOrder;
    }
}