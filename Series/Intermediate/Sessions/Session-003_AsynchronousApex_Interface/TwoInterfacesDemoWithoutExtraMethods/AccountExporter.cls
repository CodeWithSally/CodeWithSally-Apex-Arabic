public class AccountExporter implements Exportable, Loggable {
    private String  delimiter;
    private Boolean isIncludeHeader;
    private String  strLoggPrefix;
    private List<Account> lstAccounts;

    public AccountExporter(String delimiter,Boolean isIncludeHeader,String strLoggPrefix,List<Account> lstAccounts) {
        this.delimiter = delimiter;
        this.isIncludeHeader = isIncludeHeader;
        this.strLoggPrefix = '[AccountExporter] ' + strLoggPrefix;
        this.lstAccounts = lstAccounts;
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

    // ✅ From Exportable
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