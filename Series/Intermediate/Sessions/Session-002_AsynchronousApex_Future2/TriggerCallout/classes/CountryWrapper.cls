public class CountryWrapper{
    public translations translations{get;set;}
    public list<String> latlng{get;set;}
    public Boolean landlocked{get;set;}
    public languages languages{get;set;}
    public Decimal area{get;set;}
    public String subregion{get;set;}
    public demonyms demonyms{get;set;}
    public String region{get;set;}
    public String flag{get;set;}
    public list<String> altSpellings{get;set;}
    public maps maps{get;set;}
    public list<String> capital{get;set;}
    public Integer population{get;set;}
    public idd idd{get;set;}
    public String fifa{get;set;}
    public currencies currencies{get;set;}
    public car car{get;set;}
    public Boolean unMember{get;set;}
    public list<String> timezones{get;set;}
    public String status{get;set;}
    public list<String> continents{get;set;}
    public Boolean independent{get;set;}
    public flags flags{get;set;}
    public String cca3{get;set;}
    public coatOfArms coatOfArms{get;set;}
    public String ccn3{get;set;}
    public String startOfWeek{get;set;}
    public String cca2{get;set;}
    public capitalInfo capitalInfo{get;set;}
    public list<String> tld{get;set;}
    public postalCode postalCode{get;set;}
    public name name{get;set;}

    public class zho{
        public String common{get;set;}
        public String official{get;set;}
    }
    public class urd{
        public String common{get;set;}
        public String official{get;set;}
    }
    public class tur{
        public String common{get;set;}
        public String official{get;set;}
    }
    public class translations{
        public slk slk{get;set;}
        public pol pol{get;set;}
        public per per{get;set;}
        public por por{get;set;}
        public nld nld{get;set;}
        public rus rus{get;set;}
        public kor kor{get;set;}
        public jpn jpn{get;set;}
        public ita ita{get;set;}
        public spa spa{get;set;}
        public hun hun{get;set;}
        public hrv hrv{get;set;}
        public fra fra{get;set;}
        public srp srp{get;set;}
        public fin fin{get;set;}
        public est est{get;set;}
        public deu deu{get;set;}
        public swe swe{get;set;}
        public cym cym{get;set;}
        public tur tur{get;set;}
        public ces ces{get;set;}
        public urd urd{get;set;}
        public bre bre{get;set;}
        public zho zho{get;set;}
        public ara ara{get;set;}
    }
    public class swe{
        public String official{get;set;}
        public String common{get;set;}
    }
    public class srp{
        public String official{get;set;}
        public String common{get;set;}
    }
    public class spa{
        public String official{get;set;}
        public String common{get;set;}
    }
    public class slk{
        public String common{get;set;}
        public String official{get;set;}
    }
    public class rus{
        public String common{get;set;}
        public String official{get;set;}
    }
    public class postalCode{
        public String format{get;set;}
        public String regex{get;set;}
    }
    public class por{
        public String common{get;set;}
        public String official{get;set;}
    }
    public class pol{
        public String official{get;set;}
        public String common{get;set;}
    }
    public class per{
        public String common{get;set;}
        public String official{get;set;}
    }
    public class nld{
        public String common{get;set;}
        public String official{get;set;}
    }
    public class nativeName{
        public fao fao{get;set;}
        public dan dan{get;set;}
    }
    public class name{
        public nativeName nativeName{get;set;}
        public String official{get;set;}
        public String common{get;set;}
    }
    public class maps{
        public String googleMaps{get;set;}
        public String openStreetMaps{get;set;}
    }
    public class languages{
        public String dan{get;set;}
        public String fao{get;set;}
    }
    public class kor{
        public String common{get;set;}
        public String official{get;set;}
    }
    public class jpn{
        public String common{get;set;}
        public String official{get;set;}
    }
    public class ita{
        public String official{get;set;}
        public String common{get;set;}
    }
    public class idd{
        public list<String> suffixes{get;set;}
        public String root{get;set;}
    }
    public class hun{
        public String official{get;set;}
        public String common{get;set;}
    }
    public class hrv{
        public String common{get;set;}
        public String official{get;set;}
    }
    public class fra{
        public String official{get;set;}
        public String f{get;set;}
        public String m{get;set;}
        public String common{get;set;}
    }
    public class FOK{
        public String symbol{get;set;}
        public String name{get;set;}
    }
    public class flags{
        public String png{get;set;}
        public String svg{get;set;}
    }
    public class fin{
        public String official{get;set;}
        public String common{get;set;}
    }
    public class fao{
        public String common{get;set;}
        public String official{get;set;}
    }
    public class est{
        public String official{get;set;}
        public String common{get;set;}
    }
    public class eng{
        public String f{get;set;}
        public String m{get;set;}
    }
    public class DKK{
        public String symbol{get;set;}
        public String name{get;set;}
    }
    public class deu{
        public String common{get;set;}
        public String official{get;set;}
    }
    public class demonyms{
        public eng eng{get;set;}
        public fra fra{get;set;}
    }
    public class dan{
        public String common{get;set;}
        public String official{get;set;}
    }
    public class cym{
        public String official{get;set;}
        public String common{get;set;}
    }
    public class currencies{
        public FOK FOK{get;set;}
        public DKK DKK{get;set;}
    }
    public class coatOfArms{
        public String png{get;set;}
        public String svg{get;set;}
    }
    public class ces{
        public String common{get;set;}
        public String official{get;set;}
    }
    public class car{
        public String side{get;set;}
        public list<String> signs{get;set;}
    }
    public class capitalInfo{
        public list<String> latlng{get;set;}
    }
    public class bre{
        public String common{get;set;}
        public String official{get;set;}
    }
    public class ara{
        public String common{get;set;}
        public String official{get;set;}
    }

    public static List<CountryWrapper> parseApiResponse(String jsonResponse) {
        // Escape single backslashes (\) not already escaped
        // Handles cases like \d or \s in regex: → becomes \\d or \\s
        String sanitizedJson = jsonResponse.replaceAll('([^\\\\])\\\\([^\\\\])', '$1\\\\\\\\$2');
        
        // Safeguard: also escape any remaining lone backslashes just in case
        sanitizedJson = sanitizedJson.replaceAll('([^\\\\])\\\\(?![\\\\])', '$1\\\\\\\\');

        // Deserialize to List of CountryWrapper
        return (List<CountryWrapper>) JSON.deserialize(sanitizedJson, List<CountryWrapper>.class);
    }
}