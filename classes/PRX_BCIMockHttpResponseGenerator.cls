@isTest
global class PRX_BCIMockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        string url='';
        PRX_BCI_Integration_Settings__c BCIIntgSett = PRX_BCI_Integration_Settings__c.getValues('PRX-BCI');
if (BCIIntgSett != null)
{
url=BCIIntgSett.PRX_B2B_Gateway_Endpoint__c;

}
else
{
//url = 'https://wsg-uat.belgacom.be/SGF/services/InboundService/BCIFacadeOpportunity/1.0';
url = 'https://wsg.belgacom.be/SGF/services/InboundService/BCIFacadeOpportunity/1.0';


}

        //System.assertEquals('https://g86s9om8nsl5.runscope.net', req.getEndpoint());
        System.assertEquals(url, req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ResponseDataCreateOpportunity xmlns="urn:v1.opportunity.bci-int.services.bgc"><notification>1</notification><detail><keyinformation><OPPORTUNITY_ID>9242777</OPPORTUNITY_ID></keyinformation></detail></ResponseDataCreateOpportunity></soapenv:Body></soapenv:Envelope>');
        res.setStatusCode(200);
        return res;
    }
}