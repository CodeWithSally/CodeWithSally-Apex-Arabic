public class InvocableExample {
    
    @InvocableMethod  // annotation
    public static List<String> exampleMethod(List<String> lstInputs) {
        List<String> lstResults=new List<String>{'sally','Bassem'};
        // input: List<String>
        // (method logic goes here;)
        return lstResults;  // output: List<String>
    }
}