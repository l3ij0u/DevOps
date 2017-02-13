/*
 * Class PRX_SystemUtility 
 *
 * Class used for System related methods and reusable code.
 */
public class PRX_SystemUtility {
    
    /*
    * Name: checkOpprtunityBeforeAddUpdateDelete
    * Description: Used to check and add error for CR3239
    * Author: Ankit
    */
    public static void checkOpprtunityBeforeAddUpdateDelete(List<sObject> oppLineList , String currentUserprofile , Set<String> adminProfileToNotRestrict , Set<String> opprtunityStageRestrictName , Map<Id,Opportunity> oppLineIdWithOpportunity , String customErromsg){
        /*system.debug('---1---' + adminProfileToNotRestrict.contains(currentUserprofile));
        system.debug('---2---' + opprtunityStageRestrictName);*/
        for(SObject opp : oppLineList){
            if(!adminProfileToNotRestrict.contains(currentUserprofile) && opprtunityStageRestrictName.contains((String)oppLineIdWithOpportunity.get(opp.Id).get('StageName'))){
                system.debug('---3---');
                opp.addError(customErromsg + (String)oppLineIdWithOpportunity.get(opp.Id).get('StageName'));
            }
        }
    }
    
    public static void checkOpprtunityBeforeAddUpdateDelete(List<sObject> oppLineList , String currentUserprofile , Set<String> adminProfileToNotRestrict , String currentUserRole , Set<String> adminRoleToNotRestrict , Set<String> opprtunityStageRestrictName , Map<Id,Opportunity> oppLineIdWithOpportunity , String customErromsg){
        for(SObject opp : oppLineList){
            if(!adminProfileToNotRestrict.contains(currentUserprofile) && !adminRoleToNotRestrict.contains(currentUserRole) && opprtunityStageRestrictName.contains((String)oppLineIdWithOpportunity.get(opp.Id).get('StageName'))){
                system.debug('---3---'); 
                opp.addError(customErromsg + (String)oppLineIdWithOpportunity.get(opp.Id).get('StageName'));
            }
        }
    }
    
    /*
    * Name: sysLog
    * Description: Used to insert log object
    * Author: Ankit
    */
    public static void sysLog(String originatingClassName , String logType , String stack ){
        if(String.isNotBlank(originatingClassName) && String.isNotBlank(logType) && String.isNotBlank(stack)){
            stack = stack.length() > 131000 ? stack.substring(0,131000) : stack;
            PRX_SystemLog__c sysObj = new PRX_SystemLog__c(
                                        Originating_Class_Name__c=originatingClassName , Log_Type__c=logType ,
                                        Stack_Trace__c=stack , Running_User__c=userinfo.getUserId());
            insert sysObj;
        }
    }
}