trigger PRX_OpportunityTeamMemberTrigger on OpportunityTeamMember (after delete, after insert, after update, before delete, before insert, before update) {
    PRX_TriggerFactory.createHandler(OpportunityTeamMember.sObjectType); //
}