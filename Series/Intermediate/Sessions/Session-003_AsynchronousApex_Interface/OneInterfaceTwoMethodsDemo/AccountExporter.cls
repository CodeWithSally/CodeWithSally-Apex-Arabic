public class AccountExporter implements Exportable {
    private String  delimiter;
    private Boolean isIncludeHeader;
    private List<Account> lstAccounts;

    public AccountExporter(String delimiter,Boolean isIncludeHeader,List<Account> lstAccounts) {
        this.delimiter = delimiter;
        this.isIncludeHeader = isIncludeHeader;
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
        return result;
    }

    // ✅ From Exportable
    public String getExportFileName() {
        return 'accounts_export_' + DateTime.now().format('yyyyMMdd_HHmmss') + '.csv';
    }
}