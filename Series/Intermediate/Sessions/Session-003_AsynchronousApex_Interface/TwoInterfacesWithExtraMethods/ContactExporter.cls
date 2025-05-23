public class ContactExporter implements Exportable, Loggable {
    private String  delimiter;
    private Boolean isIncludeHeader;
    private String  strLoggPrefix;
    private List<Contact> lstContacts;

    public ContactExporter(String delimiter, Boolean isIncludeHeader, String strLoggPrefix, List<Contact> lstContacts) {
        this.delimiter = delimiter;
        this.isIncludeHeader = isIncludeHeader;
        this.strLoggPrefix = '[ContactExporter] ' + strLoggPrefix;
        this.lstContacts = lstContacts;
    }

    // ✅ Extra Method - not in the interface
    public List<Contact> getContactsMissingEmail() {
        List<Contact> result = new List<Contact>();
        for (Contact c : lstContacts) {
            if (String.isBlank(c.Email)) {
                result.add(c);
            }
        }
        log('Found ' + result.size() + ' contacts with missing emails.');
        return result;
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
                     + (String.isNotEmpty(contactObj.Email) ? contactObj.Email : ''));
        }

        String result = String.join(lstRows, '\n');
        log('Exported ' + lstContacts.size() + ' contacts.');
        return result;
    }

    public String getExportFileName() {
        return 'contacts_export_' + DateTime.now().format('yyyyMMdd_HHmmss') + '.csv';
    }

    // ✅ From Loggable
    public void log(String message) {
        System.debug(this.strLoggPrefix + message);
    }

    public void log(String message, SObject recordObj) {
        System.debug(this.strLoggPrefix + message + ' | Record: ' + JSON.serialize(recordObj));
    }

    public void logError(Exception ex) {
        System.debug(this.strLoggPrefix + ' ERROR: ' + ex.getMessage());
    }
}
