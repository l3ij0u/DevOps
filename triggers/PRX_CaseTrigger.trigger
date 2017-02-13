/*
* For POC donot deploy
*/
trigger PRX_CaseTrigger on Case (after delete, after insert, after update, before delete, before insert, before update) {
	try{
		if(Trigger.isAfter && Trigger.isInsert){
			system.debug('--Owner After Insert--' +trigger.new[0].OwnerId);
		}
		if(Trigger.isAfter && Trigger.isUpdate){
			system.debug('--Owner After Update--' +trigger.new[0].OwnerId);
		}
		if(Trigger.isBefore && Trigger.isInsert){
			Map<String,String> caseSubjectToTypeMap = new Map<String,String>();
			caseSubjectToTypeMap.put('complaints' , 'Complaint');
			caseSubjectToTypeMap.put('inquiry' , 'Inquiry');
			caseSubjectToTypeMap.put('interaction' , 'Interaction');
			 
			for(Case caseObj : trigger.new){
				//system.debug('--subject--' + caseObj.Subject); system.debug('----' + caseObj.Description); system.debug('----' + caseObj.Origin); system.debug('----' + caseObj.Priority); system.debug('----' + caseObj.SuppliedEmail);
				String strSub = caseObj.Subject;
				String strBody = caseObj.Description;
				String strCheck = '';
				if(strSub.contains('<') && strSub.contains('>')){
				    strSub = strSub.substring(strSub.IndexOf('<')+1 , strSub.length());
				    strCheck = strSub.substring(0 , strSub.IndexOf('>'));
				}
				else if(strBody.contains('<') && strBody.contains('>')){
					strBody = strBody.substring(strBody.IndexOf('<')+1 , strBody.length());
				    strCheck = strBody.substring(0 , strBody.IndexOf('>'));
				}
				system.debug('--strCheck--' + strCheck);
				if(String.isNotBlank(strCheck) && caseSubjectToTypeMap.containsKey(strCheck.toLowerCase()) && caseObj.Origin == 'Email' && String.isNotBlank(caseObj.SuppliedEmail)){

					caseObj.Type = caseSubjectToTypeMap.get(strCheck.toLowerCase());
								
				}
			}    
		}
	}
	catch(exception ex){
		PRX_SystemUtility.sysLog('PRX_CaseTrigger' , 'Exception' , ex.getStackTraceString());
	}
}