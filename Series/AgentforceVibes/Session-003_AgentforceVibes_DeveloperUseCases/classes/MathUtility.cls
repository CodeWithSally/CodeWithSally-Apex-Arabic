public class MathUtility { 
    
    public static Integer addNumbers(List<Integer> lstNumbers){ 
        Integer sum=0;
        for(Integer numberValue : lstNumbers){
            sum+=numberValue; 
        } 
       
        System.debug('Sum Value: '+sum);
        return sum;
    }
    
    public static Integer addNumbers(Integer num1, Integer num2) {
        return addNumbers(new List<Integer>{num1,num2});
    }
    
    public static decimal divideNumbers(decimal num1, decimal num2) {
        if (num2 == 0) {
            throw new IllegalArgumentException('Cannot divide by zero');
        }
        return num1 / num2;
    }

    public static Integer subtractNumbers(Integer number1,Integer number2){ 
        return number1-number2;
    }   

    public static Boolean isPositiveNumber(Integer numberValue){
        Boolean isPositive=false;
        if(numberValue >=0 ){
            isPositive = true;
        }else if(numberValue<0){
            isPositive = false;
        }
        return isPositive;
    }
}