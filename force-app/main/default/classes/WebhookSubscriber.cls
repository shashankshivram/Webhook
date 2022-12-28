@RestResource(urlMapping='/api/wehbooks/incoming/gitPushDetails/*')
/*******************************Steps for Creating a webhook***********************
 * 1) Create a Apex Rest API - POST
 * 2) Create a Public Site
 * 3) Enable Apex Class Access for Site
 * **********************************************************************************/

global with sharing  class WebhookSubscriber {
    @HttpPost
    global static void handleNotification(){
        //Request
        RestRequest request = RestContext.request;
        //getBody
        Blob requestBody  = request.requestBody;
        
    }
}