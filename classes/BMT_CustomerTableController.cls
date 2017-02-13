public class BMT_CustomerTableController {
@AuraEnabled
 Public static String customerData(){
        
 //Http h = new Http();
 //HttpRequest req = new HttpRequest();
 //req.setEndpoint('callout:githubusercontent/parthiban019/samplejson/master/customer.json');
 //req.setMethod('GET');
 Http h = new Http();
    HttpRequest req = new HttpRequest();
    //req.setClientCertificateName(b2bmutualauthcert);    
    req.setEndpoint('http://www.webservicex.net/stockquote.asmx');
    req.setMethod('POST');
    req.setHeader('Content-Type','text/xml');
    req.setHeader('SOAPAction', 'http://www.webserviceX.NET/GetQuote');
    req.setTimeout(120000);
     String     docOpenEnvString= '<?xml version="1.0" encoding="utf-8"?>';
     docOpenEnvString += '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">';
        String docBodyString='<soap:Body><GetQuote xmlns="http://www.webserviceX.NET/"><symbol>MSFT</symbol></GetQuote></soap:Body>';
     String docCloseEnvString ='</soap:Envelope>';
     //docHeaderString = generateSoapHeader(docBodyString);
     String FinalString=docOpenEnvString+docBodyString+docCloseEnvString;
    String docString = docOpenEnvString + docBodyString + docCloseEnvString;
    System.debug('docString Final Envelop'+ docString);
    req.setBody(docString);
 HttpResponse res = h.send(req);
     System.debug(res.getBody());
 //return (List<BMT_CustomerWrapper>)JSON.deserialize(res.getBody(), List<BMT_CustomerWrapper>.class);
 //List<String> ls1= new List<String>();
     String ls1=res.getBody();
     return ls1;
 //return res;
    }
}