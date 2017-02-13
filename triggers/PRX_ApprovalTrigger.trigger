trigger PRX_ApprovalTrigger on PRX_Approvals__c (after delete, after insert, after update, before delete, before insert, before update) {
    PRX_TriggerFactory.createHandler(PRX_Approvals__c.sObjectType); //
}