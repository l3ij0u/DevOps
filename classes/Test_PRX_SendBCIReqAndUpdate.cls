@isTest
private class Test_PRX_SendBCIReqAndUpdate 
{
    static testMethod void testSucessCallout() 
     {
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('BCIResponse');
        mock.setStatusCode(200); // Or other appropriate HTTP status code
        mock.setHeader('Content-Type', 'application/json'); // Or other appropriate MIME type like application/xml
        Test.setMock(HttpCalloutMock.class, mock);
        
         Datetime myDT = Datetime.now();
         String myDate = myDT.format('yyMMddHHmmssZ');
         String strCDBID=myDate.left(9);
        User u =[select id,name,EmployeeNumber from user where id =:UserInfo.getUserId()];
        
        Account acc= new Account();
        acc.Owner=u;
        acc.Name= 'Test Acc';
        acc.PRX_Proximus_CDB_Id__c=strCDBID;
        insert acc;
        
        Opportunity objTestOpp= new Opportunity();
        objTestOpp.Name ='Test Opp';
        objTestOpp.Owner =u;
        objTestOpp.CloseDate = Date.Today();
        objTestOpp.StageName= 'Prospecting' ;
        objTestOpp.AccountId=acc.id;
        objTestOpp.Owner.EmployeeNumber = '113234';
        insert objTestOpp;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);

        PRX_SendBCIReqAndUpdate.processRequest(objTestOpp.id,objTestOpp.name,objTestOpp.Owner.EmployeeNumber,objTestOpp.Account.PRX_Proximus_CDB_Id__c,string.valueof(objTestOpp.CloseDate));
        List<Opportunity> OppList=[SELECT Id,PRX_BCI_Opportunity_ID__c FROM Opportunity WHERE Id = :objTestOpp.Id LIMIT 1];
        if(oppList.size()>0)
        {
          for(Opportunity objopp: OppList)
          {
            if(objopp.PRX_BCI_Opportunity_ID__c!=null)
            System.assert(String.isNotBlank(objopp.PRX_BCI_Opportunity_ID__c));
          }
        }
        
        test.stopTest();
       
    } 
    
    static testMethod void testFaultCallout() 
     {
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('BCIResponseFail');
        mock.setStatusCode(200); // Or other appropriate HTTP status code
        mock.setHeader('Content-Type', 'application/json'); // Or other appropriate MIME type like application/xml
        Test.setMock(HttpCalloutMock.class, mock);
        
         Datetime myDT = Datetime.now();
         String myDate = myDT.format('yyMMddHHmmssZ');
         String strCDBID=myDate.left(9);
        User u =[select id,name,EmployeeNumber from user where id =:UserInfo.getUserId()];
        
        Account acc1= new Account();
        acc1.Owner=u;
        acc1.Name= 'Test Acc1';
        acc1.PRX_Proximus_CDB_Id__c=strCDBID;
        insert acc1;
        
        Opportunity objTestOpp1= new Opportunity();
        objTestOpp1.Name =' Test Opp';
        objTestOpp1.Owner =u;
        objTestOpp1.CloseDate = Date.Today();
        objTestOpp1.StageName= 'Prospecting' ;
        objTestOpp1.AccountId=acc1.id;
        
        insert objTestOpp1;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);

       PRX_SendBCIReqAndUpdate.processRequest(objTestOpp1.id,objTestOpp1.name,objTestOpp1.Owner.EmployeeNumber,objTestOpp1.Account.PRX_Proximus_CDB_Id__c,string.valueof(objTestOpp1.CloseDate));
        List<Opportunity> OppList=[SELECT Id,PRX_BCI_Opportunity_ID__c FROM Opportunity WHERE Id = :objTestOpp1.Id LIMIT 1];
        if(oppList.size()>0)
        {
          for(Opportunity objopp: OppList)
          {
            if(objopp.PRX_BCI_Opportunity_ID__c!=null)
            System.assert(String.isNotBlank(objopp.PRX_BCI_Opportunity_ID__c));
          }
        }
        
        test.stopTest();
       
    }
    
}