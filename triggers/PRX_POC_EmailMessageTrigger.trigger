trigger PRX_POC_EmailMessageTrigger on EmailMessage (after delete, after insert, after update, before delete, before insert, before update) {
    if(Trigger.isBefore && Trigger.isInsert){
        Map<string,id> emailUserMap = new Map<string,id>();
        for(User userObj : [Select Id,Email from User where isActive = true]){
            emailUserMap.put(userObj.Email , userObj.Id);
        }
        Map<id,id> caseOwnerUpdateMap = new Map<id,id>();
        
        for(EmailMessage emObj : trigger.new){
            
            system.debug('---FromAddress---' + emObj.FromAddress);
            system.debug('---Headers---' + emObj.Headers);
            system.debug('---Incoming---' + emObj.Incoming);
            system.debug('---ParentId---' + emObj.ParentId);
            system.debug('---Subject---' + emObj.Subject);
            system.debug('---ToAddress---' + emObj.ToAddress);
            
            String authMsg = '';
            if(String.isNotBlank(emObj.Headers)){
                authMsg = emObj.Headers.substring(emObj.Headers.indexOf('Authentication-Results') , emObj.Headers.indexOf('Received:'));
                system.debug('---authMsg---' + authMsg);
                authMsg = authMsg.substring(authMsg.indexOf('auth=') , (authMsg.indexOf('auth=')+10));
            }
            system.debug('---authMsg---' + authMsg);
            
            if(!authMsg.contains('pass')){
                emObj.addError('Error Occured while creating case as it is ristricted!!');
            }
            else{
                if(!emObj.Subject.contains('ref:') && emailUserMap.containsKey(emObj.FromAddress)){
                    system.debug('---QwnerId---' + emailUserMap.get(emObj.FromAddress));
                    caseOwnerUpdateMap.put(emObj.ParentId , emailUserMap.get(emObj.FromAddress));
                }
            }
        }
        
        if(!caseOwnerUpdateMap.isEmpty()){
            PRX_POC_FutureHandler.updateCaseOwnerFromEmailToCase(caseOwnerUpdateMap);
        }
    }
}