public with sharing class CountryFallbackLoader {
    // Private helper to read the static resource content
    private static String loadFromStaticResource() {
        // Query the StaticResource named 'Fallback_Countries'
        StaticResource resource = [
            SELECT Body 
            FROM StaticResource 
            WHERE Name = 'Fallback_Countries' 
            LIMIT 1
        ];
        
        // Convert the binary blob into a string
        Blob bodyBlob = resource.Body;
        return bodyBlob.toString();
    }

    // Deserialize the entire fallback JSON into a list of CountryWrapper objects
    public static List<CountryWrapper> getAllFallbackCountries() {
        String json = loadFromStaticResource();
        return CountryWrapper.parseApiResponse(json);
    }

    // Retrieve a single country by its common name (case-insensitive)
    public static CountryWrapper getByCountryName(String name) {
        List<CountryWrapper> all = getAllFallbackCountries();
        
        // Loop through the list to find a matching country
        for (CountryWrapper c : all) {
            if (c.name != null && c.name.common != null &&
                c.name.common.toLowerCase() == name.toLowerCase()) {
                return c;
            }
        }

        // If no match found, return null
        return null;
    }
}