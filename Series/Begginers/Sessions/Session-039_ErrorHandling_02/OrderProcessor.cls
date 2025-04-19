// ✅ Calling Class: Catches and handles the exception
public class OrderProcessor {
    
    public static void processOrder(Decimal orderAmount) {
        try {
            Decimal discount = DiscountUtility.calculateDiscount(orderAmount);
            System.debug('Discount applied: ' + discount);
        } catch (IllegalArgumentException e) {
            System.debug('Error: ' + e.getMessage());
        }catch (exception ex){
            System.debug('Other Error: ' + ex.getMessage());
        }
    }
    
    public static void processOrderWithCustomMessage(Decimal orderAmount) {
        try {
            Decimal discount = DiscountUtility.calculateDiscount(orderAmount);
            System.debug('Discount applied: ' + discount);
        } catch (IllegalArgumentException e) {
            System.debug('Custom Error amount value is invalid please try again');
        }catch (exception ex){
            System.debug('Other Error: ' + ex.getMessage());
        }
    }
}