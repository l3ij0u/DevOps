/**
 * Class PRX_OpportunityTeamHandler 
 *
 * Trigger Handler for the OpportunityTeam SObject. This class implements the PRX_ITrigger
 * interface to help ensure the trigger code is bulkified and all in one place.
 */
public with sharing class PRX_OpportunityTeamHandler implements PRX_ITrigger{
    private Set<String> opprtunityStageRestrictName = new Set<String>{PRX_VariableConstant.oppClosedWon ,PRX_VariableConstant.oppClosedLost};
    private Set<String> adminProfileSet = new Set<String>{PRX_VariableConstant.oppSystemAdmin};
    private Set<String> adminProfileToNotRestrict = new Set<String>();
    private Map<Id,Opportunity> oppTeamIdWithOpportunity = new Map<Id,Opportunity>();
    private String currentUserprofile = userinfo.getProfileId();
    private String customErromsg  = PRX_VariableConstant.oppErrorStr;
    
    // Constructor
    public PRX_OpportunityTeamHandler ()
    {
    }

    /**
     * Name: bulkBefore 
     *
     * Description: This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore()
    {   
		
    }
    
    public void bulkAfter()
    {
    	system.debug('---In Before Bulk--');
        system.debug('--' + String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')));
        try{
            List<OpportunityTeamMember> oppTeamList = new List<OpportunityTeamMember>();
            if(Trigger.isDelete) oppTeamList = trigger.old; 
            else                 oppTeamList = trigger.new;
            
            Set<Id> oppIds = new Set<Id>();
            for(OpportunityTeamMember oppItemObj : oppTeamList ){ system.debug('---oppItemObj--' + oppItemObj.Id);
                oppIds.add(oppItemObj.OpportunityId);
            }
            
            for(Profile proObj : [Select Id from Profile where Name IN: adminProfileSet ]){
                adminProfileToNotRestrict.add(proObj.Id);
            }
            
            Map<Id,Opportunity> getOppDetailsMap = new Map<Id,Opportunity>([Select Id,StageName from Opportunity where Id IN: oppIds]);
            for(OpportunityTeamMember oppItemObj : oppTeamList ){
                oppTeamIdWithOpportunity.put(oppItemObj.Id, getOppDetailsMap.get(oppItemObj.OpportunityId));
            }
    
            PRX_SystemUtility.checkOpprtunityBeforeAddUpdateDelete(oppTeamList, currentUserprofile , 
                                                                    adminProfileToNotRestrict , opprtunityStageRestrictName , 
                                                                    oppTeamIdWithOpportunity , customErromsg);
        }
        catch(exception ex){
            PRX_SystemUtility.sysLog(String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')) , 'Exception' , ex.getStackTraceString());
        }
    }
        
    public void beforeInsert(SObject so)
    {
        
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        
    }
    
    /**
     * beforeDelete
     *
     * This method is called iteratively for each record to be deleted during a BEFORE
     * trigger.
     */
    public void beforeDelete(SObject so)
    {   
        
    }
    
    public void afterInsert(SObject so)
    {
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
    }
    
    public void afterDelete(SObject so)
    {
    }
    
    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally()
    {
        
    }    
}