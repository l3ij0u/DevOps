/*
  Comments: This class is used to send HTTP Request with XML Self Format and body of the message is signed with Digital signature
  Date Create: 26-06-2016
  Version: 0.2-Modify signature value calculation with crypto.signwithcertificate()
       a. Create XML Request 
       b. Send it to specific EndPoint 
       c. Receive the Response 
       d. Parse the Response and execute required actions 
    */

public class PRX_SendBCIReqAndUpdate{

@future(callout=true)
    
public static void processRequest(id idn,string name,string EmployeeNumber,String CdbId,String ClosedDate) {

    String url='';
    String b2bmutualauthcert='';
    String docOpenEnvString = '';
    String docOpenHeaderString = '';
    String docClosingHeaderString = ''; 
    String docOpenBodyString = '';
    String docOpenBodyStringContent = '';
    String docSignatureString = '';
    String docClosingBodyString = '';
    String docClosingEnvString = '';
    String docHeaderString = '';

    String OpptyName=name;
    String OppID=idn;
    String EmployeeId=EmployeeNumber;
    String OppType='';
    String SpecificationType='';
    String ProductID='';
    String ProductCategory='';
    String ProductSetid='';
    String ProductRegime='';
    Integer ProductConfidence=0;
    Integer ProductPrice=0;
    Integer ProductQuanity=0;
    String BusinessUnit='';
    String CustomerId=Cdbid;
    String CloseDateVal=ClosedDate;
    String strBCIOppID;
    
    
    PRX_BCI_Integration_Settings__c BCIIntgSett = PRX_BCI_Integration_Settings__c.getValues('PRX-BCI');
    if (BCIIntgSett != null)
    {
    url=BCIIntgSett.PRX_B2B_Gateway_Endpoint__c;
    b2bmutualauthcert=BCIIntgSett.PRX_B2B_Mutual_Auth_Cert__c;
       }
    else
    {
    url = 'https://wsg.belgacom.be/SGF/services/InboundService/BCIFacadeOpportunity/1.0';
    //Bijou
    b2bmutualauthcert='SFDC_SSL_Authentication_DevOrg';
       //b2bmutualauthcert='SFDC_SSL_Authentication_UATOrgs';
     // b2bmutualauthcert='SFDC_SSL_Authentication';
    }
    
    //Custom settings to get the default and mandatory values in request XML
    PRX_BCI_Default_Values__c custSett= PRX_BCI_Default_Values__c.getValues('Default BCI Values');
    if (custSett!=null)
    {
    OppType=custSett.PRX_BCI_Opportunity_Type__c;
    SpecificationType=custSett.PRX_Opp_Specification_Type__c;
    ProductID=custSett.PRX_BCI_ProductID__c;
    BusinessUnit=custSett.PRX_Business_Unit__c;
    ProductCategory=custSett.PROD_CATEGORY__c;
    ProductConfidence=Integer.valueof(custSett.PROD_CONFIDENCE_PCT__c);
    ProductPrice=Integer.valueof(custSett.PROD_PRICE__c);
    ProductQuanity=Integer.valueof(custSett.PROD_QUANTITY__c);
    ProductRegime=custSett.PROD_REGIME__c;
    ProductSetid=custSett.PROD_SETID__c;
    }
    else
    {
    OppType='OPP';
    SpecificationType='Other';
    ProductID='SF0001';
    BusinessUnit='BGC01';
    ProductCategory='Not In AIC';
    ProductConfidence=20;
    ProductPrice=0;
    ProductQuanity=1;
    ProductRegime='01';
    ProductSetid='SHARE';
    }

    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setClientCertificateName(b2bmutualauthcert);    
    req.setEndpoint(url);
    req.setMethod('POST');
    req.setHeader('Content-Type','application/soap+xml');
    req.setHeader('SOAPAction', 'CreateOpportunity');
    req.setTimeout(120000);

    // add xml tag
    docOpenEnvString += '<?xml version="1.0" encoding="UTF-8"?>';
    // open envelope
    docOpenEnvString += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:v4.context.vss.objects.bgc" xmlns:urn1="urn:v1.opportunity.bci-int.services.bgc">';



    // open Body and Service
    // open Request
    docOpenBodyString += '<soapenv:Body wsu:Id="id-8EC61447FA716527EC145501425334336" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">';
    System.debug('Body Start'+ docOpenBodyString);
    docOpenBodyStringContent = '<urn1:RequestDataCreateOpportunity version="1.0">';
    docOpenBodyStringContent += '<urn1:OPP_SPECIFICATION_TYPE>'+SpecificationType+'</urn1:OPP_SPECIFICATION_TYPE>';
    docOpenBodyStringContent += '<urn1:OPPORTUNITY_NAME>'+OpptyName+'</urn1:OPPORTUNITY_NAME>';
    docOpenBodyStringContent += '<urn1:OPPORTUNITY_TYPE>'+OppType+'</urn1:OPPORTUNITY_TYPE>';
    docOpenBodyStringContent += '<urn1:BUSINESS_UNIT>'+BusinessUnit+'</urn1:BUSINESS_UNIT>';
    docOpenBodyStringContent += '<urn1:CUSTOMER_ID>'+CustomerId+'</urn1:CUSTOMER_ID>';
    docOpenBodyStringContent += '<urn1:OPPORTUNITY_OWNER_ID>'+EmployeeId+'</urn1:OPPORTUNITY_OWNER_ID>';
    docOpenBodyStringContent += '<urn1:ESTIMATED_CLOSE_DATE>'+CloseDateVal+'</urn1:ESTIMATED_CLOSE_DATE>';
    docOpenBodyStringContent += ' <urn1:OPPORTUNITY_DESCRIPTION>'+OppID+'</urn1:OPPORTUNITY_DESCRIPTION>';
    docOpenBodyStringContent += '<urn1:PRODUCTS>'; 
    docOpenBodyStringContent += '<urn1:PROD_CATEGORY>'+ProductCategory+'</urn1:PROD_CATEGORY>';
    docOpenBodyStringContent += '<urn1:PROD_SETID>'+ProductSetid+'</urn1:PROD_SETID>';
    docOpenBodyStringContent += '<urn1:PROD_ID>'+ProductID+'</urn1:PROD_ID>';
    docOpenBodyStringContent += '<urn1:PROD_QUANTITY>'+ProductQuanity+'</urn1:PROD_QUANTITY>';
    docOpenBodyStringContent += '<urn1:PROD_REGIME>'+ProductRegime+'</urn1:PROD_REGIME>';
    docOpenBodyStringContent += '<urn1:PROD_PRICE>'+ProductPrice+'</urn1:PROD_PRICE>';
    docOpenBodyStringContent += '<urn1:PROD_CONFIDENCE_PCT>'+ProductConfidence+'</urn1:PROD_CONFIDENCE_PCT>';
    docOpenBodyStringContent += '</urn1:PRODUCTS>';
    docOpenBodyStringContent += '</urn1:RequestDataCreateOpportunity>';
    System.debug('Body Middle'+ docOpenBodyStringContent);+
    docClosingBodyString  +='</soapenv:Body>';
    System.debug('Body End'+ docClosingBodyString);
    docClosingEnvString += '</soapenv:Envelope>';
      
    String docBodyString = docOpenBodyString + docOpenBodyStringContent + docClosingBodyString;
    System.debug('Body final string'+ docBodyString);
     
    //String docBodyString = docOpenBodyString + docClosingBodyString;
     docHeaderString = generateSoapHeader(docBodyString);
    // 2. ADD SIGNATURE
    //docSignatureString = generateXMLSignature(docBodyString);
    System.debug('docSignature String'+ docSignatureString);
    // Open Defect 133365
    docBodyString=docBodyString.replace('&','&amp;');
    // Close of defect fix
    String docString = docOpenEnvString + docHeaderString + docBodyString + docClosingEnvString;
    System.debug('docString Final Envelop'+ docString);
    req.setBody(docString);
    // To handle callout exceptions
    try{
    HttpResponse res = h.send(req);
    //return res;

    //Parse Response

    strBCIOppID=parseResponse(res);

    system.debug(' BCI  Data values'+strBCIOppID);
    }
    catch (Exception e)
        {
            Datetime myDT = Datetime.now();
            String myDate = 'ERR'+myDT.format('yyMMddHHmmssZ');
            strBCIOppID=myDate.left(15);
        }
    //Update BCI Opportunity ID
    list <opportunity> oppList = new list <opportunity>();
 
    if(strBCIOppID!=null)
    {
      opportunity tempObj = new opportunity();
      tempObj.id = idn;
      tempObj.PRX_BCI_Opportunity_ID__c=strBCIOppID;  
      oppList.add( tempObj );
    }
      if(oppList.size()>0)
      update oppList;  
    }

   public static String generateSoapHeader(String docBodyString){
        
            
        //Create XMLSignature Element
        String signatureElement = generateXMLSignature(docBodyString);

        //Create Security Element
        String signatureString = '<wsse:Security  xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">';
        signatureString+=signatureElement;
       
        signatureString+='</wsse:Security>';
        signatureString += '<urn:Context version="4.0">';
        signatureString += '<urn:correlationId>?</urn:correlationId><urn:consumerApplicationId>?</urn:consumerApplicationId><urn:endUserId>?</urn:endUserId><urn:endUserLanguage>EN</urn:endUserLanguage><urn:propagatedKey>?</urn:propagatedKey>';
        signatureString+='</urn:Context>';
        //Create Header Element
        String headerElement = '<soapenv:Header>'+signatureString+'</soapenv:Header>';
        return headerElement;
    }

    public static String generateXMLSignature(String docBodyString){
        // 1. Apply the Transforms, as determined by the application, to the data object.
        // (no transforms are done, since the body should be delivered in canonicalized form (Force.com offers no canonicalization algorithm))

        // 2. Calculate the digest value over the resulting data object.
 
        String MessageSigncertName='';
         PRX_BCI_Integration_Settings__c BCIIntgSett = PRX_BCI_Integration_Settings__c.getValues('PRX-BCI');
        if (BCIIntgSett != null)
        {
           MessageSigncertName=BCIIntgSett.PRX_Message_Sign_Cert__c;
        }
        else
           {
          //MessageSigncertName='Message_Signing_Certificate_DEV';
          // MessageSigncertName='Message_Signing_Certificate_UAT';
          // MessageSigncertName='Message_Signing_Certificate_Prod';

       }

        System.debug('In Signature Method display body string'+ docBodyString);
        System.debug('In Signature Method display body string with blob new'+ Blob.valueOf(docBodyString));
        Blob bodyDigest = Crypto.generateDigest('SHA256',Blob.valueOf(docBodyString));
        system.debug('Display body digest'+bodyDigest);
        
        // 3. Create a Reference element, including the (optional) identification of the data object, any (optional) transform elements, the digest algorithm and the DigestValue.
        // (Note, it is the canonical form of these references that are signed and validated in next steps.)

        String referenceString = '';
        referenceString += '';
        referenceString += '<ds:Reference URI="#id-8EC61447FA716527EC145501425334336">';
        referenceString += '<ds:Transforms>';
        referenceString += '<ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>';
        referenceString += '</ds:Transforms>';
        referenceString += '<ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>';
       // </ds:DigestMethod>';
        referenceString += '<ds:DigestValue>'+EncodingUtil.base64Encode(bodyDigest)+'</ds:DigestValue>';
        referenceString += '</ds:Reference>';

        // 4. Create SignedInfo element with SignatureMethod, CanonicalizationMethod and Reference(s).
        String signedInfoString = '';
        signedInfoString += '<ds:SignedInfo>';
        signedInfoString += '<ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>';
        signedInfoString += '<ds:SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"/>';
        signedInfoString += referenceString;
        System.debug('In Signature Method referencestring'+ referenceString);
        signedInfoString += '</ds:SignedInfo>';
        System.debug('In Signature Method signedInfoString'+ signedInfoString);
        
        // 5. Canonicalize and then calculate the SignatureValue over SignedInfo based on algorithms specified in SignedInfo.
        // (no canonicalization is done, since the signedinfo element should be delivered in canonicalized form (Force.com offers no canonicalization algorithm))

        String algorithmName = 'RSA-SHA256';
        // decrypted private key pkcs8 format from certificate
        
        Blob siBlob = Blob.valueOf(signedInfoString);
        System.debug('In Signature Method siBlob'+ siBlob);
  
        Blob signatureValue = Crypto.signWithCertificate(algorithmName, siBlob, MessageSigncertName);

        System.debug('In Signature Method signatureValue'+ signatureValue);

        String signatureValueString = EncodingUtil.base64Encode(signatureValue);

        System.debug('In Signature Method signatureValueString'+ signatureValueString);
               
        // 6. Construct the Signature element that includes SignedInfo, Object(s) (if desired, encoding may be different than that used for signing), KeyInfo (if required), and SignatureValue.
        String signatureString = '';
        //signatureString += '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">';
        //signatureString += '<wsse:BinarySecurityToken EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary" ValueType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509v3" wsu:Id="CertId-1828792" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">CERTIFICATE</wsse:BinarySecurityToken>';
        signatureString += '<ds:Signature Id="SIG-FE8390E7B87C62FC14146604832364215" xmlns:ds="http://www.w3.org/2000/09/xmldsig#">';
        signatureString += signedInfoString;
        signatureString += '<ds:SignatureValue>'+signatureValueString+'</ds:SignatureValue>';
        signatureString += '</ds:Signature>';
        //signatureString += '</wsse:Security>';
          
        System.debug('In Signature Method signatureString'+ signatureString);
 
        return signatureString;
        }

//This method accept the http response from apex call out.
public Static String parseResponse(HttpResponse responseBody)
    {      
        Dom.Document responseDoc = new Dom.Document();
        DateTime dt = System.now();
        try
        {
        //Log the XML content
        responseDoc.load(responseBody.getBody());
        //Get all Root Element
         Dom.XMLNode envelope = responseDoc.getRootElement();

         if (envelope<> null)
        {
        
       
        Dom.XmlNode bodynode=envelope.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/'); 

        //Read all the child elements and find and return BCI Opportunity ID 
             
           if (bodynode <> null )
            {
                Dom.XmlNode ReqDatanode=bodynode.getChildElement ('ResponseDataCreateOpportunity','urn:v1.opportunity.bci-int.services.bgc');
                Dom.XMLNode DetailNode=ReqDatanode.getChildElement('detail', 'urn:v1.opportunity.bci-int.services.bgc');
                 system.debug(DetailNode);
                Dom.XMLNode KeyInfoNode=DetailNode.getChildElement('keyinformation', 'urn:v1.opportunity.bci-int.services.bgc');
                 system.debug(KeyInfoNode);
                Dom.XMLNode OppIdNode=KeyInfoNode.getChildElement('OPPORTUNITY_ID', 'urn:v1.opportunity.bci-int.services.bgc');
                 system.debug(OppIdNode);
                String OppIDText=OppIdNode.getText();
                System.debug('OppIDText: ' + OppIDText);
                return OppIDText;
            }
            else
            {
            Datetime myDT = Datetime.now();
            String myDate = 'ERR'+myDT.format('yyMMddHHmmssZ');
            return myDate.left(15);
            }
        }
        
        else
        {
            Datetime myDT = Datetime.now();
            String myDate = 'ERR'+myDT.format('yyMMddHHmmssZ');
            return myDate.left(15);
        }
        }
        catch (Exception e)
        {
            Datetime myDT = Datetime.now();
            String myDate = 'ERR'+myDT.format('yyMMddHHmmssZ');
            return myDate.left(15);
        }
        
        
        
    }

}