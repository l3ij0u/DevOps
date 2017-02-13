/**
 * Class PRX_OpportunityLineHandler 
 *
 * Trigger Handler for the OpportunityLine SObject. This class implements the PRX_ITrigger
 * interface to help ensure the trigger code is bulkified and all in one place.
 */
public with sharing class PRX_OpportunityLineHandler implements PRX_ITrigger {  
    private Set<String> opprtunityStageRestrictName = new Set<String>{PRX_VariableConstant.oppClosedWon ,PRX_VariableConstant.oppClosedLost};
    
    private Set<String> adminProfileSet = new Set<String>{PRX_VariableConstant.oppSystemAdmin};
    private Set<String> adminProfileToNotRestrict = new Set<String>();
    
    private Set<String> adminRoleSet = new Set<String>{PRX_VariableConstant.oppSystemAdminRole};
    private Set<String> adminRoleToNotRestrict = new Set<String>();
    
    private Map<Id,Opportunity> oppLineIdWithOpportunity = new Map<Id,Opportunity>();
    private String currentUserprofile = userinfo.getProfileId();
    private String currentUserRole = userinfo.getUserRoleId();
    private String customErromsg  = PRX_VariableConstant.oppErrorStr;
    
    // Constructor
    public PRX_OpportunityLineHandler ()
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
        try{
            List<OpportunityLineItem> oppLineList = new List<OpportunityLineItem>();
            if(Trigger.isDelete) oppLineList = trigger.old;
            else                 oppLineList = trigger.new;
            
            Set<Id> oppIds = new Set<Id>();
            for(OpportunityLineItem oppItemObj : oppLineList ){ 
                oppIds.add(oppItemObj.OpportunityId);
            }
            
            for(Profile proObj : [Select Id from Profile where Name IN: adminProfileSet ]){
                adminProfileToNotRestrict.add(proObj.Id);
            }
            
            for(UserRole userobj: [select Id,DeveloperName from UserRole where DeveloperName IN: adminRoleSet] ){
            	adminRoleToNotRestrict.add(userobj.Id);
            }
            
            Map<Id,Opportunity> getOppDetailsMap = new Map<Id,Opportunity>([Select Id,StageName from Opportunity where Id IN: oppIds]);
            for(OpportunityLineItem oppItemObj : oppLineList ){
                oppLineIdWithOpportunity.put(oppItemObj.Id, getOppDetailsMap.get(oppItemObj.OpportunityId));
            }
    		
            PRX_SystemUtility.checkOpprtunityBeforeAddUpdateDelete(oppLineList, currentUserprofile , adminProfileToNotRestrict , 
                                                                    currentUserRole , adminRoleToNotRestrict,
                                                                    opprtunityStageRestrictName , 
                                                                    oppLineIdWithOpportunity , customErromsg);
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
    
    /*public void checkForOpportunityUpdate()
    {   
        system.debug('---checkForOpportunityUpdate---');
        if(Trigger.isUpdate){ 

            for(Profile proObj : [Select Id from Profile where Name IN: adminProfileSet ]){
                adminProfileToNotRestrict.add(proObj.Id);
            }
            
            List<Opportunity> oppList = new List<Opportunity>();
            List<Opportunity> oppListOld = new List<Opportunity>();
            Map<Id,Opportunity> oppOldMap = new Map<Id,Opportunity>();
            oppListOld = trigger.old;
            oppList = trigger.new;
            for(Opportunity oppOld : oppListOld){
                oppOldMap.put(oppOld.Id , oppOld);
            }

            for(Opportunity opp : oppList){
                if(!adminProfileToNotRestrict.contains(currentUserprofile) 
                    && opprtunityStageRestrictName.contains(opp.StageName)
                    && opprtunityStageRestrictName.contains(oppOldMap.get(opp.Id).StageName)){
                    system.debug('---1---' + adminProfileToNotRestrict.contains(currentUserprofile));
                    opp.addError(customErromsg + opp.StageName);
                }
            }
        }
    }*/

}