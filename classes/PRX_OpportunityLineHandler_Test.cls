@isTest(SeeAllData=true)
public class PRX_OpportunityLineHandler_Test {
    static testMethod void validateOpportunityLine() {
        Test.startTest();
        Account accObj = new Account(Name='Test_Account');
        insert accObj;
        
        //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true And isActive = true limit 1];
        
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook 1', Description='Test Pricebook 1', isActive=true);
        insert pbk1;
        
        Product2 prd1 = new Product2 (Name='Test Product 1', Description='Test Product 1', productCode = 'ABC', isActive = true);
        insert prd1;
        
        
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id , Pricebook2ID=standardPb.id , UnitPrice=50 , isActive=true);
        insert pbe1;
        
        Opportunity oppObj = new Opportunity(Name='TestOpportunityOne', 
                             AccountId=accObj.id , CloseDate=(system.today()+2),
                             StageName='Prospecting');
        insert oppObj;
        
        OpportunityLineItem lineItem1 = new OpportunityLineItem (OpportunityId=oppObj.id , 
                                        PriceBookEntryID=pbe1.id, PRX_Contract_Duration__c=2, 
                                        PRX_Quantity__c=2,PRX_Revenue_Type__c='Existing revenue',
                                        quantity=4 , totalprice=200);
        insert lineItem1;
        update lineItem1;
        delete lineItem1;
        Test.stopTest();
             
    }
}