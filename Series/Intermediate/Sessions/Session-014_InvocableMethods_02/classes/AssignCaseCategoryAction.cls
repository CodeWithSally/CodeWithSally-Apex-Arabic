//Verb + Noun phrase + Action : [Assign → precise verb that tells admins exactly what the action does.
//								 CaseCategory → the main object and concept you’re affecting.
//								 Action → standard suffix that flags the class as a single invocable Flow action.]
public class AssignCaseCategoryAction {

    @InvocableMethod(label='Assign Case Category' description='Assigns a Category to a Case based on Subject' category='Case Management')
    public static List<String> assignCategory(List<Id> lstCaseIds) {
        System.debug('===> checking lstCaseIds: '+lstCaseIds);
        List<String> lstCategories = new List<String>();

        // Query all input cases in one SOQL
        Map<Id, Case> mapCases = new Map<Id, Case>([SELECT Subject FROM Case WHERE Id IN :lstCaseIds]);

        for (Id caseId : lstCaseIds) {
            lstCategories.add(getCaseCategory(mapCases.get(caseId)));
        }
		
        //Demo order is important
        //lstCategories = reverseList(lstCategories);
        
        return lstCategories;
    }
    
    //logic getting the right category per case object
    private static String getCaseCategory(Case caseObj){
        if (caseObj.Subject != null) {
            if (caseObj.Subject.toLowerCase().contains('billing')) {
                return 'Billing';
            } else if (caseObj.Subject.toLowerCase().contains('technical')) {
                return 'Technical';
            } else if (caseObj.Subject.toLowerCase().contains('login') || caseObj.Subject.toLowerCase().contains('password')) {
                return 'Authentication';
            }else {
                return 'General';
            }
        } else {
            return 'Uncategorized';
        }
    }
    
    //temporary method to show case how result order matters!!!!
    private static List<String> reverseList(List<String> lstItems) {
        List<String> lstReversed = new List<String>();
        for (Integer i = lstItems.size() - 1; i >= 0; i--) {
            lstReversed.add(lstItems[i]);
        }
        return lstReversed;
    }
}