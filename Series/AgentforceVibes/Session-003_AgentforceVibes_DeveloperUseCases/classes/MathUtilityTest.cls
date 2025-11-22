@isTest
private class MathUtilityTest {
    
    //static void method name
    @isTest
    static void testAddition(){
        //prepare data
        Integer number1=5;
        Integer number2=2;
        
        //execute code that we want to test
        Integer resultAddition=MathUtility.addNumbers(number1,number2);
        
        //validate result as expected
        //areEqual(expected, actual, msg)
        //System.assertEquals(7, resultAddition, 'Addition result should be 15');
		Assert.areEqual(7,resultAddition,'Addition result should have been 7!!');
    }
    
    @isTest
    static void testDivision(){ //positive
        //prepare data
        Decimal value1=10;
        Decimal value2=2;
        
        //execute code that we want to test
        Decimal valueResult= MathUtility.divideNumbers(value1,value2);
        
        //validate result as expected
        //System.assertEquals(5, result, '10 divided by 2 should be 5');
        Assert.areEqual(5, valueResult, '10 divided by 2 should be 5');
    }
    
    @isTest
    static void testDivideByZero(){//negative scenario
        //prepare data
        Decimal value1=10;
        Decimal value2=0;
        
        try{
            //execute code that we want to test
        	Decimal valueResult= MathUtility.divideNumbers(value1,value2);  
            //Assert2
            //System.assert(false, 'Expected an exception for division by zero'); 
            Assert.fail('Expected an exception for division by zero'); //forcing test method to fail
        }catch(Exception ex){
            //areEqual(expected, actual, msg)
            //Assert1
            ////System.assertEquals('Cannot divide by zero', e.getMessage(), 'Expected division by zero error message');
            Assert.areEqual('Cannot divide by zero', ex.getMessage(), 'Expected division by zero error message');
        }
    }
}