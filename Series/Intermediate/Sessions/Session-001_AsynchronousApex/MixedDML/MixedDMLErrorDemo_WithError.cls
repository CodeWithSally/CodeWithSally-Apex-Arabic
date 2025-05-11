public class MixedDMLErrorDemo {
    
    public static void doMixedDML() {
        // Non-setup object
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // This next operation (insert a user with a role) 
        // can't be mixed with the previous insert unless 
        // it is within a future method. 
        // Call future method to insert a user with a role.
        insertUserWithRole(
            'ss@codeWithSally.com', 'SCode', 
            'sally.elghoul@Testcloud.com', 'SCode');
    }
    
    public static void insertUserWithRole(String uname, String al, String em, String lname) {

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        UserRole r = [SELECT Id FROM UserRole WHERE Name='COO'];
        // Create new user with a non-null user role ID 
        User u = new User(alias = al, email=em, 
            emailencodingkey='UTF-8', lastname=lname, 
            languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, userroleid = r.Id,
            timezonesidkey='America/Los_Angeles', 
            username=uname);
        insert u;
    }
}