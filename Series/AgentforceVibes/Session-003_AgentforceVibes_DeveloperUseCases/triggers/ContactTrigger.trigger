trigger ContactTrigger on Contact (before insert, before update) {
    for (Contact con : Trigger.new) {
        if (String.isBlank(con.Email)) {
            con.Email = con.FirstName + '.' + con.LastName + '@example.com';
        }
        if (con.LeadSource == 'Web') {
            con.Description = 'Came from website signup';
        }
    }
}