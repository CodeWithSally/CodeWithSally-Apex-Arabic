public class TestTryCatchPlacement {
    
    public static void testTryCatchScenario(){        
        /*try{
            Account acc=new Account(); //no name so it will throw an exception
           insert acc;
        }catch(exception ex){
            System.debug('Error Occurred' + ex.getMessage());
        }
        
        try{
           Contact contactobj=new Contact(FirstName='Test',LastName='Test999'); //this line is reachable now and will be executed 
           insert contactObj;
        }catch(exception ex){
            System.debug('Error Occurred' + ex.getMessage());
        } */  
        
        try{
           Account acc=new Account(); //no name so it will throw an exception
           insert acc;
           Contact contactobj=new Contact(FirstName='Test',LastName='Test9991'); //this line is reachable now and will be executed 
           insert contactObj;
        }catch(exception ex){
            System.debug('Error Occurred' + ex.getMessage());
        }
    }
	
    public static void testCase1(){
        List<Account> accounts = new List<Account>{
            new Account(Name='Test-Arabic1'),
            new Account(Name='Test-Arabic2'),
            new Account(),  // Missing Name (will cause DMLException)
            new Account(Name='Test-Arabic4')
        };
        
        try {
            for (Account acc : accounts) {
                insert acc; //Test-Arabic1|Test-Arabic2|acc3?? ==> exception
             } 
        } catch (DmlException e) {
            System.debug('Error Occurred' + e.getMessage());
        }
    }
    
    public static void testCase2(){
        List<Account> accounts = new List<Account>{
            new Account(Name='TestRuby1'),
            new Account(Name='TestRuby2'),
            new Account(),  // Missing Name (will cause DMLException)
            new Account(Name='TestRuby4')
        };
        
       	for (Account acc : accounts) {
            try {
                insert acc; //TestRuby1|TestRuby2|acc3?? ==> exception|TestRuby4
            } catch (DmlException e) {
            	System.debug('Error Occurred' + e.getMessage());
        	}
            //there is more to run
        } 
    }
    
    //no records will be created at all!!!
    public static void testCase3(){
        List<Account> accounts = new List<Account>{
            new Account(Name='TestCat1'),
            new Account(Name='TestCat2'),
            new Account(),  // Missing Name (will cause DMLException)
            new Account(Name='TestCat4')
        };
        
       	for (Account acc : accounts) {
            insert acc; //TestCat1|TestCat2|acc3==>fail
        } 
    }
}