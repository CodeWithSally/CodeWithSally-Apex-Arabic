public class TryCatchDemo {

    //test catching specific error 
    public static void runErrorScenarios() {
        String resultMessage='';
        try{
            // Simulate a math error (division by zero)
            //System.debug(ErrorHandlingScenarios.divideNumber(10,0)); 
            System.debug(ErrorHandlingScenarios.divideNumber(10,2));
            
            //System.debug(ErrorHandlingScenarios.missingDataError('nonexistent@example.com')); //queryexception
            System.debug(ErrorHandlingScenarios.missingDataError('bond_john@grandhotels.com'));
            
            AccountService.createAccount(null, null);
            
            //System.debug(ErrorHandlingScenarios.dmlError(null));
            //System.debug(ErrorHandlingScenarios.dmlError('Account1'));
            
            
            //ErrorHandlingScenarios.governorLimitError(100);  
            resultMessage ='Payment succeeded';      
        }catch( MathException  mathError){ //if exception type is MathException
            System.debug('Catch Math Error mathError : '+mathError.getMessage());
            resultMessage='Math Issue';
        }catch(QueryException queryEx){
            System.debug('Catch QueryException : '+queryEx.getMessage());
            resultMessage='Query Issue';
        }catch(MissingRequiredFieldException customError){
            System.debug('=======> MissingRequiredFieldException : '+customError.getMessage());
            resultMessage='Custom Issue Issue';
        }catch(Exception ex){
            System.debug('Catch Error ex : '+ex.getMessage());
            resultMessage='Payment Failed';
        }finally{
            //system.debug('Finally Code to be executed!!!');
            system.debug('Result: '+resultMessage);
        }
    }
    
    
    //catching custom exception    
    public static void createAndLogAccount() {
        try {
            // Attempt to create an account without Industry (will throw MissingRequiredFieldException)
            AccountService.createAccount('TechCorpThursday', '');
        } catch (MissingRequiredFieldException e) {  
            System.debug('Custom Exception Caught: ' + e.getMessage());  
        } catch (Exception e) {  
            System.debug('Unexpected Error: ' + e.getMessage()); 
        }finally {  
            System.debug('✅ Log: Account creation attempted.');
        }
    }
}