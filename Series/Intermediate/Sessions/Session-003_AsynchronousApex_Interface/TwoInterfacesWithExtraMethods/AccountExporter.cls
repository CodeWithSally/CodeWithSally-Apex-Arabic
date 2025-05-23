public with sharing class AccountExporter implements Exportable , Loggable {
    private String delimiter;
    private Boolean isIncludeHeader;
    private String  strLoggPrefix;
    private List<Account> lstAccounts;

    public AccountExporter(String delimiter,Boolean isIncludeHeader,String strLoggPrefix,List<Account> lstAccounts) {
        this.delimiter = delimiter;
        this.isIncludeHeader = isIncludeHeader;
        this.strLoggPrefix = '[AccountExporter] ' + strLoggPrefix;
        this.lstAccounts = lstAccounts;
    }

    // ✅ Method not in any interface
    public List<Account> getAccountsByIndustry(String industry) {
        try {
            List<Account> lstFilteredAccounts=new List<Account>();
            for(Account acocuntObj : lstAccounts){
                if(acocuntObj.Industry==industry){
                    lstFilteredAccounts.add(acocuntObj);
                }
            }
            log('Fetched ' + lstFilteredAccounts.size() + ' accounts of Industry: ' + industry);
            return lstFilteredAccounts;
        } catch (Exception ex) {
            logError(ex);
            return new List<Account>();
        }
    }

    // ✅ From Exportable
    public String export() {
        List<String> lstRows = new List<String>();

        if(this.isIncludeHeader){
            // Add header row
            lstRows.add('Name' + delimiter + 'Industry' + delimiter + 'Annual Revenue');
        }

        for (Account accountObj : this.lstAccounts) {
            lstRows.add(accountObj.Name + delimiter 
                     + (String.isNotEmpty(accountObj.Industry)?accountObj.Industry:'N/A') + delimiter 
                     + (accountObj.AnnualRevenue!=null?accountObj.AnnualRevenue:0));
        }

        String result = String.join(lstRows, '\n');
        log('Exported ' + this.lstAccounts.size() + ' accounts.');
        return result;
    }

    public String getExportFileName() {
        return 'accounts_export_' + DateTime.now().format('yyyyMMdd_HHmmss') + '.csv';
    }

    // ✅ From Loggable
    public void log(String message) {
        System.debug(this.strLoggPrefix  +' : '+  message);
    }

    public void logError(Exception ex) {
        System.debug(this.strLoggPrefix + ' ERROR: ' + ex.getMessage());
    }
}