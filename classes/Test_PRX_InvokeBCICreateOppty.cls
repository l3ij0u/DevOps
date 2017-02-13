@isTest
private class Test_PRX_InvokeBCICreateOppty {

    
    static testMethod void myTriggUnitTest() {
        
        
        Account acc= new Account();
        acc.Name= 'PrxTestAccount';
        insert acc;
        
        Opportunity TrigTestOpp= new Opportunity();
        TrigTestOpp.Name='TrigTest';
        TrigTestOpp.CloseDate=system.today()+3;
        TrigTestOpp.StageName='Prospecting';
        TrigTestOpp.PRX_BCI_Opportunity_ID__c='';
        TrigTestOpp.AccountId=acc.Id;
        insert TrigTestOpp;
       

       Test.startTest();
            // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new PRX_BCIMockHttpResponseGenerator());

       Opportunity QueryTrig = [Select PRX_BCI_Opportunity_ID__c From Opportunity where id =: TrigTestOpp.id];
       //System.assert(QueryTrig.PRX_BCI_Opportunity_ID__c!= null);
       Test.stopTest();
        
    }
}