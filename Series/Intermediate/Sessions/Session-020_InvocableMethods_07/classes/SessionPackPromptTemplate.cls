public with sharing class SessionPackPromptTemplate {
    @InvocableMethod(
        label='Load Videos & Playlists By Language'
        description='get current youtube videos and playlists'
    )
    public static List<Response> loadByLanguage(List<Request> lstRequests) {
        // Use first request for config (invocable supports bulk)
        String languageValue = (lstRequests != null && !lstRequests.isEmpty() && String.isNotBlank(lstRequests[0].language))
                      ? lstRequests[0].language.trim()
                      : 'English';

        String mainTopic = (lstRequests != null && !lstRequests.isEmpty() && String.isNotBlank(lstRequests[0].mainTopic))
                      ? lstRequests[0].mainTopic.trim()
                      : 'General';
        
        //Prepare a wrapper Obj that we will serizlize at the end 
        ResponseDetails responseDetails = new ResponseDetails();

        //get current playlists
        responseDetails.playlists = getCurrentPlaylists(languageValue);

        //get current videos and their playlist 
        responseDetails.relatedVideos = getCurrentVideos(languageValue,mainTopic);

        return new List<Response>{ new Response(JSON.serialize(responseDetails)) };
    }

    ///////////////////Start Private Methods////////////////////////////
    public static List<VideoDetails> getCurrentVideos(String languageValue,String mainTopic){
        List<videoDetails> lstVideos = new List<VideoDetails>();
        String topicCheck='%'+String.escapeSingleQuotes(mainTopic)+'%';
        for(YoutubeVideo__c videoObj : [Select Title__c, Url__c, Description__c, Language__c, Published_Date__c,
                                            (Select Playlist__r.Title__c from VideoPlaylists__r) 
                                            from YoutubeVideo__c 
                                            WHERE Language__c = :languageValue 
                                                AND RelatedTopics__c like :topicCheck ORDER BY Published_Date__c DESC]){
            lstVideos.add(new videoDetails(videoObj));
        }
        return lstVideos;
    }

    private static List<PlaylistDetails> getCurrentPlaylists(String languageValue){
        List<PlaylistDetails> lstPlaylists=new List<PlaylistDetails>();
        for(Playlist__c playlistObj : [ SELECT Id, Title__c, Description__c, Language__c FROM Playlist__c WHERE Language__c = :languageValue ORDER BY Title__c ]){
            lstPlaylists.add(new PlaylistDetails(playlistObj));
        }
        return lstPlaylists;
    }
    ///////////////////End Private Methods////////////////////////////

    /////////////////Start Video and Playlist Wrapper & Response/////////////
    public class PlaylistDetails{
        public String title;
        public String description;

        public PlaylistDetails(Playlist__c playlistObj){
            this.title = playlistObj.Title__c;
            this.description = playlistObj.Description__c;
        }
    }

    public class VideoDetails{
        public String title;
        public String url;
        public String description;
        public String publishedDate;
        public List<String> playlists;

        public VideoDetails(YoutubeVideo__c videoObj){
            this.title = videoObj.Title__c;
            this.url = videoObj.Url__c;
            this.description = videoObj.Description__c;
            this.publishedDate = (videoObj.Published_Date__c == null ? null : String.valueOf(videoObj.Published_Date__c));
            this.playlists= new List<String>();
            for(VideoPlaylist__c videoPlaylistObj : videoObj.VideoPlaylists__r){
                this.playlists.add(videoPlaylistObj.Playlist__r.Title__c);
            }
        }
    }

    public class ResponseDetails{
        public List<PlaylistDetails> playlists;
        public List<VideoDetails> relatedVideos;
    }

    /////////////////End Video and Playlist Wrapper & Response/////////////

    /////////////////Input and output Wrappers/////////////////
    public class Request {
        @InvocableVariable(required=true) 
        public String language; // Must match the Template Input api name value

        @InvocableVariable(required=true) 
        public String mainTopic; // Must match the Template Input api name value

        //@InvocableVariable(required=true) 
        //public String newVideoDescription; // If you want to use it it must match the template Input API Name value

        //@InvocableVariable(required=true) 
        //public String newVideoTimestamps; // If you want to use it it must match the template Input API Name value
    }
    public class Response { 
        @InvocableVariable public String Prompt; //Must be named like this with case sensitive P!
        
        public Response(String jsonValue){
            this.Prompt = jsonValue;
        }
    }
}