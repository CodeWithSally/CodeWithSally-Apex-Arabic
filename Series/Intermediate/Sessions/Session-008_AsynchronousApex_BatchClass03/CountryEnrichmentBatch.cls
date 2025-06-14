public class CountryEnrichmentBatch implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful {

    // Track successful updates across chunks
    private Integer updatedCount = 0;

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Name 
            FROM Country__c 
            WHERE Capital__c = NULL 
               OR Region__c = NULL 
               OR FlagURL__c = NULL 
               OR MapURL__c = NULL
        ]);
    }

    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<Country__c> countries = (List<Country__c>) scope;
        List<Country__c> lstUpdateCountries = new List<Country__c>();

        for (Country__c countryObj : countries) {
            try {
                List<CountryWrapper> result = CountryCalloutUtility.getCountryByName(countryObj.Name);
                if (!result.isEmpty()) {
                    CountryWrapper c = result[0];
                    countryObj.Capital__c = (c.capital != null && !c.capital.isEmpty()) ? c.capital[0] : null;
                    countryObj.Region__c = c.region;
                    countryObj.FlagURL__c = c.flags.png;
                    countryObj.MapURL__c = c.maps.googleMaps;
                    lstUpdateCountries.add(countryObj);
                }
            } catch (Exception e) {
                System.debug('⚠️ Skipped ' + countryObj.Name + ': ' + e.getMessage());
            }
        }

        update lstUpdateCountries;
        updatedCount+=(lstUpdateCountries.isEmpty()?0:lstUpdateCountries.size());
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('🌍 Done enriching Country__c records.');
        System.debug('✅ Total countries updated: ' + updatedCount);
    }
}



///////Execute
//Database.executeBatch(new CountryEnrichmentBatch());
//Database.executeBatch(new CountryEnrichmentBatch(), 10); // 10 records per chunk for testing


/*
List<String> countryNames = new List<String>{
    'Afghanistan', 'Albania', 'Algeria', 'Andorra', 'Angola',
    'Argentina', 'Armenia', 'Australia', 'Austria', 'Azerbaijan',
    'Bahamas', 'Bahrain', 'Bangladesh', 'Barbados', 'Belarus',
    'Belgium', 'Belize', 'Benin', 'Bhutan', 'Bolivia',
    'Bosnia and Herzegovina', 'Botswana', 'Brazil', 'Brunei', 'Bulgaria',
    'Burkina Faso', 'Burundi', 'Cambodia', 'Cameroon', 'Canada',
    'Cape Verde', 'Central African Republic', 'Chad', 'Chile', 'China',
    'Colombia', 'Comoros', 'Costa Rica', 'Croatia', 'Cuba',
    'Cyprus', 'Czech Republic', 'Denmark', 'Djibouti', 'Dominica',
    'Dominican Republic', 'East Timor', 'Ecuador', 'Egypt', 'El Salvador',
    'Equatorial Guinea', 'Eritrea', 'Estonia', 'Eswatini', 'Ethiopia',
    'Fiji', 'Finland', 'France', 'Gabon', 'Gambia',
    'Georgia', 'Germany', 'Ghana', 'Greece', 'Grenada',
    'Guatemala', 'Guinea', 'Guinea-Bissau', 'Guyana', 'Haiti',
    'Honduras', 'Hungary', 'Iceland', 'India', 'Indonesia',
    'Iran', 'Iraq', 'Ireland', 'Israel', 'Italy',
    'Ivory Coast', 'Jamaica', 'Japan', 'Jordan', 'Kazakhstan',
    'Kenya', 'Kiribati', 'Kuwait', 'Kyrgyzstan', 'Laos',
    'Latvia', 'Lebanon', 'Lesotho', 'Liberia', 'Libya',
    'Liechtenstein', 'Lithuania', 'Luxembourg', 'Madagascar', 'Malawi',
    'Malaysia' // #101
};

List<Country__c> countries = new List<Country__c>();

for (String name : countryNames) {
    countries.add(new Country__c(Name = name));
}

insert countries;

System.debug('✅ Inserted ' + countries.size() + ' Country__c records.');
*/
