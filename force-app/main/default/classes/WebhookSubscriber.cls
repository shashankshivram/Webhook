@RestResource(urlMapping='/api/wehbooks/incoming/gitPushDetails/*')
/*******************************Steps for Creating a webhook***********************
 * 1) Create a Apex Rest API - POST
 * 2) Create a Public Site
 * 3) Enable Apex Class Access for Site
 * **********************************************************************************/

global with sharing  class WebhookSubscriber {
@HttpPost
global static void handleNotification(){
RestRequest request = RestContext.request;
RestResponse response = RestContext.response;
try{


String hashedval = request.headers.get('X-Hub-Signature-256');
Blob requestBody  = request.requestBody;

JSONParser parser = JSON.createParser(requestBody.toString());
Pusher pusher;
HeadCommit headcommit;
String repo = '';
while(parser.nextToken()!=null){
if(parser.getText() == 'pusher'){
parser.nextToken();
pusher = (Pusher)parser.readValueAs(Pusher.class);
}
if(parser.getText() == 'head_commit'){
parser.nextToken();
headcommit = (HeadCommit)parser.readValueAs(HeadCommit.class);
}
if(parser.getText() == 'full_name'){

parser.nextToken();
repo = parser.getText();
}
Git_Hub_Details__c githubDetails = new Git_Hub_Details__c();
githubDetails.Added_Component__c  = headcommit!=null && headcommit.added!=null?  String.join(headcommit.added,','):'';
githubDetails.Commit_Message__c = headcommit!=null?headcommit.message:'';
githubDetails.Commit_Time_Stamp__c =  headcommit!=null?headcommit.timestamp:'';
githubDetails.Commited_Url__c = headcommit!=null?headcommit.url:'';
githubDetails.Commiter_Email__c = pusher!=null?pusher.email:'';
githubDetails.Commiter_Name__c =pusher!=null?pusher.name:'';
githubDetails.Modified_Components__c = headcommit!=null && headcommit.modified!=null?String.join(headcommit.modified,','):'';
githubDetails.Removed_Components__c = headcommit!=null && headcommit.removed!=null?String.join(headcommit.removed,','):'';
githubDetails.Repository_Name__c = repo;
insert githubDetails;
response.statusCode = 200;
response.responseBody = Blob.valueOf(JSON.serialize((new Response('Success','Record created Successfully'))));
}
}  catch(Exception e){
    System.debug('Exception e ===>'+e);
    response.statusCode = 404;
response.responseBody = Blob.valueOf(JSON.serialize((new Response('Error',e.getMessage()))));
}  

}
public class Response{
String response;
String message;
public Response(String resp,String msg){
    response = resp;
    message = msg;
    
}
}
public class Pusher{
public string name;
public string email;
public Pusher(String name,String email){
    name = name;
    email= email;
}
}
public class HeadCommit{
public string message;
public string timestamp;
public string url;
public List<string> added ;
public List<string> removed ;
public List<string> modified ;
public HeadCommit(String message,String timestamp,String url,List<string> added,List<string> removed,List<string> modified){
    message = message;
    timestamp= timestamp;
    url= url;
    added= added;
    removed= removed;
    modified= modified;
}
}
}