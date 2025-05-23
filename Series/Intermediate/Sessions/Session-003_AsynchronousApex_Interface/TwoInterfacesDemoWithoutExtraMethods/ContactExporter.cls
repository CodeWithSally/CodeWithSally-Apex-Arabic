public with sharing class ContactExporter implements Exportable, Loggable{
    private String  delimiter;
    private Boolean isIncludeHeader;
    private List<Contact> lstContacts;

    public ContactExporter(String delimiter, Boolean isIncludeHeader, List<Contact> lstContacts) {
        this.delimiter = delimiter;
        this.isIncludeHeader = isIncludeHeader;
        this.lstContacts = lstContacts;
    }

    // ✅ From Exportable 
    public String export() {
        List<String> lstRows = new List<String>();

        if (this.isIncludeHeader) {
            lstRows.add('FirstName' + delimiter + 'LastName' + delimiter + 'Email');
        }

        for (Contact contactObj : lstContacts) {
            lstRows.add(contactObj.FirstName + delimiter
                     + contactObj.LastName + delimiter
                     + (String.isNotEmpty(contactObj.Email) ? contactObj.Email : 'N/A'));
        }

        String result = String.join(lstRows, '\n');
        log('Contacts Exported ' + lstContacts.size() );

        return result;
    }

    public String getExportFileName() {
        return 'contacts_export_' + DateTime.now().format('yyyyMMdd_HHmmss') + '.csv';
    }

    // ✅ From Loggable
    public void log(String message) {
        System.debug('Message Value:  '+  message);
    }

    public void logError(Exception ex) {
        System.debug(' ERROR for contacts: ' + ex.getMessage());
    }
}