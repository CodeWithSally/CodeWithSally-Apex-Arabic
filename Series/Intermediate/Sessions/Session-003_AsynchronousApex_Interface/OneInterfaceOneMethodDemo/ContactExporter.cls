public class ContactExporter implements Exportable {
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
        return result;
    }
}
