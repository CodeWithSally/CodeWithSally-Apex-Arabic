public class ContactRegionWrapper {
    public List<Contact> contacts;
    public String regionName;
    public Id assignedBy;

    public ContactRegionWrapper(List<Contact> contacts, String region, Id userId) {
        this.contacts = contacts;
        this.regionName = region;
        this.assignedBy = userId;
    }
}
