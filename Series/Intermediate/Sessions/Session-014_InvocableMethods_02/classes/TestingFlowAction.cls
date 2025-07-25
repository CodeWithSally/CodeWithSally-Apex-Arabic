public class TestingFlowAction {

    //case 1:example of passing single string
    /*@InvocableMethod(label='Test Passing One String' category='_Testing')
    public static List<String> exampleMethodOneString(List<String> inputs) {
        List<String> lstResults=new List<String>{'sally','Bassem'};
        return lstResults;  // output: List<String>
    }*/
    
    //case 2:example for passing a list of strings
    /*@InvocableMethod(label='Test Passing List Of Strings' category='_Testing')
    public static List<String> exampleMethodListString(List<List<String>> inputs) {
        List<String> lstResults=new List<String>{'sally','Bassem'};
        return lstResults;  // output: List<String>
    }*/
    
    //case 3: 
    /*@InvocableMethod(label='Test Passing Custom Apex' category='_Testing')
    public static List<String> exampleMethodCustomApex(List<CustomApexType> inputs) {
        List<String> lstResults=new List<String>{'sally','Bassem'};
        return lstResults;  // output: List<String>
    }
    
    public class CustomApexType{
        @InvocableVariable(label='Country Name' placeholderText='enter Country Name'required=true)
        public String stringValue;

        @InvocableVariable(label='String 2 Value' defaultValue='Sally Testing')
        public String stringValueTwo; 
        
        @InvocableVariable
        public String stringValue3;
        
        @InvocableVariable(label='List Of Strings')
        public List<String> lstStringValues;
    }*/
}