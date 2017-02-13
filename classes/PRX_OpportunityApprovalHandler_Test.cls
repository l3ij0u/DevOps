@isTest
public class PRX_OpportunityApprovalHandler_Test {
    static testMethod void validateOpportunityApproval() {
        Test.startTest();
        Account accObj = new Account(Name='TestAccount');
        insert accObj;
        
        Opportunity oppObj = new Opportunity(Name='TestOpportunity', 
                             AccountId=accObj.id , CloseDate=(system.today()+2),
                             StageName='Prospecting');
        insert oppObj;
        
        Id recordTypeId = Schema.SObjectType.PRX_Approvals__c.getRecordTypeInfosByName().get('Pricing').getRecordTypeId();
        PRX_Approvals__c appObj = new PRX_Approvals__c(Name='Test_Approval1', RecordTypeId=recordTypeId,
                                  PRX_Approval_Type__c='Pricing Telco Fix',PRX_Opportunity_Name__c=oppObj.Id);
        insert appObj;
        PRX_SystemUtility.sysLog('PRX_OpportunityApprovalHandler_Test' , 'Exception' , '123');
        PRX_VariableConstant c = new PRX_VariableConstant();
        Test.stopTest(); 
    }
    
    static testMethod void validateOpportunityApproval_N() {
        Test.startTest();
        Account accObj = new Account(Name='TestAccount');
        insert accObj;
        
        Opportunity oppObj = new Opportunity(Name='TestOpportunity', 
                             AccountId=accObj.id , CloseDate=(system.today()+2),
                             StageName='Prospecting');
        insert oppObj;
        
        Id recordTypeId = Schema.SObjectType.PRX_Approvals__c.getRecordTypeInfosByName().get('Pricing').getRecordTypeId();
        PRX_Approvals__c appObj = new PRX_Approvals__c(Name='Test_Approval1', RecordTypeId=recordTypeId,
                                  PRX_Approval_Type__c='Pricing Telco Fix',PRX_Opportunity_Name__c=oppObj.Id);
        insert appObj;
        update appObj;
        delete appObj;
        Test.stopTest();
    }
}