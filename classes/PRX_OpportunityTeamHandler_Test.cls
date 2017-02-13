@isTest
public class PRX_OpportunityTeamHandler_Test {
    static testMethod void validateOpportunityTeam() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='PRX_Sales User Profile' limit 1]; 
        User u = new User(Alias = 'standt', Email='salesuser@prxdev.com', 
                        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                        LocaleSidKey='en_US', ProfileId = p.Id, 
                        TimeZoneSidKey='America/Los_Angeles', UserName='salesuser@prxdev.com');

        System.runAs(u) {
            Account accObj = new Account(Name='Test_Account');
            insert accObj;
            
            Opportunity oppObj = new Opportunity(Name='TestOpportunity', 
                                 AccountId=accObj.id , CloseDate=(system.today()+2),
                                 StageName='Prospecting');
            insert oppObj;
            
            OpportunityTeamMember teamm = new OpportunityTeamMember(OpportunityId=oppObj.Id,TeamMemberRole='Sales',UserId=u.id,OpportunityAccessLevel='Edit');
            insert teamm;
            update teamm;
            delete teamm;
        }
        Test.stopTest();
    }
    
    static testMethod void validateOpportunityTeam_N() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='PRX_Sales User Profile' limit 1]; 
        User u = new User(Alias = 'standt', Email='salesuser@prxdev.com', 
                        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                        LocaleSidKey='en_US', ProfileId = p.Id, 
                        TimeZoneSidKey='America/Los_Angeles', UserName='salesuser@prxdev.com');

        System.runAs(u) {
            Account accObj = new Account(Name='TestAccount');
            insert accObj;
            
            Opportunity oppObj = new Opportunity(Name='TestOpportunity', 
                                 AccountId=accObj.id , CloseDate=(system.today()+2),
                                 StageName='Prospecting');
            insert oppObj;
            oppObj.StageName ='Closed Lost';
            oppObj.PRX_Lost_Reason__c='lost';
            update oppObj;
            
            OpportunityTeamMember teamm = new OpportunityTeamMember(OpportunityId=oppObj.Id,TeamMemberRole='Sales',UserId=u.id,OpportunityAccessLevel='Edit');
            try{
            insert teamm;
            }
            catch(exception e){}
        }
        Test.stopTest();
    }
}