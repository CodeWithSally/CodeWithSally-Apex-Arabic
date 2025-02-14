public class MathUtility {
    
    //Static Method Signature
    //accessModifier static returnType methodName(Parameters)
    public static Integer addNumbers(List<Integer> lstNumbers){ //[1,2,3]
        Integer sum=0;
        for(Integer numberValue : lstNumbers){
            sum+=numberValue; //sum = sum + numberValue
        }
        //print sum value
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

    public Integer SubtractNumbers(Integer number1,Integer number2){ 
        return number1-number2;
    }
}