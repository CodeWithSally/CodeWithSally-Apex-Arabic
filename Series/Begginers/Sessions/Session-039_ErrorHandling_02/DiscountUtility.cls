public class DiscountUtility {

    public static Decimal calculateDiscount(Decimal amount) {
        if (amount < 0) {
            throw new IllegalArgumentException('Amount cannot be negative.');
        }
        //logic
        return amount * 0.10;
    }
    
    /*public static Decimal calculateDiscountWithTryCatch(Decimal amount) { //not recommended 
        try{
            if (amount < 0) {
                throw new IllegalArgumentException('Amount cannot be negative.');
            }
            return amount * 0.10;
        }catch(exception ex){
            system.debug('no exception thrown...we are in DiscountUtility');
        }
        return 0;
    }*/
}     