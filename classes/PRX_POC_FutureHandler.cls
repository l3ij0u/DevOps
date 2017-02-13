global class PRX_POC_FutureHandler
{
    @future
    public static void updateCaseOwnerFromEmailToCase(Map<id,id> caseOwnerUpdateMap){   
        if(!caseOwnerUpdateMap.isEmpty()){
            List<Case> updateCaseOwner = new List<Case>();
            for(id idx : caseOwnerUpdateMap.keySet()){
                updateCaseOwner.add(new Case(Id=idx , OwnerId=caseOwnerUpdateMap.get(idx)));
            }
            
            if(!updateCaseOwner.isEmpty()){
                update updateCaseOwner;
            }
        }
    }
    
    webservice static String updateAdmDataService(String adlID , String Type){
        if(Type == 'Account Team Update'){
            Map<Id,Attachment> PRXAttachmentDataMap = new Map<Id,Attachment>([Select Id,ParentId,Body from Attachment where ParentId =: adlID]);
            updateAdmData(PRXAttachmentDataMap.keySet());
        }
        return 'Queued';
    }
    
    @future
    public static void updateAdmData(Set<Id> PRXAttachmentSet ){ 
        if(!PRXAttachmentSet.isEmpty()){
            List<Attachment> PRXAttachmentDataList = [Select Id,ParentId,Body from Attachment where Id =: PRXAttachmentSet];
            System.debug('------b------' + PRXAttachmentDataList[0].body.toString());
            
            Map<String,Id> userPerByIdMap = new Map<String,Id>();
            for(user uObj : [Select Id,EmployeeNumber from User where EmployeeNumber != '']){
                userPerByIdMap.put(uObj.EmployeeNumber , uObj.Id);
            }
            
            List<String> filelines = new List<String>();
            String nameFile = PRXAttachmentDataList[0].body.toString();        
            filelines = nameFile.split('\n');       
            System.debug('------b------' + filelines);
            System.debug('------b------' + filelines.size());
            
            if(!filelines.isEmpty() && filelines.size() > 1){
                List<AccountTeamMember> accTeamList = new List<AccountTeamMember>();
                for(integer fileCounter = 1; fileCounter < filelines.size() ; fileCounter++){
                   List<String> innerFieds = new List<String>(); 
                   innerFieds = filelines[fileCounter].split(',' , -1);
                   AccountTeamMember atmObj = new AccountTeamMember();
                   
                   for(integer innerCounter = 0; innerCounter < innerFieds.size() ; innerCounter++){
                       if(!String.isBlank(innerFieds[0])) { 
                           Account accountReference = new Account(PRX_Proximus_CDB_Id__c = innerFieds[0]);
                           atmObj.Account = accountReference; 
                       }
                       
                       if(!String.isBlank(innerFieds[1])) { 
                           atmObj.UserId = userPerByIdMap.get(innerFieds[1]); 
                       }
                       
                       if(!String.isBlank(innerFieds[2]) && innerFieds[2].toLowerCase() != 'all') { 
                           atmObj.AccountAccessLevel = innerFieds[2]; 
                       }
                       
                       if(!String.isBlank(innerFieds[3]) && innerFieds[3].toLowerCase() != 'all') { 
                           atmObj.OpportunityAccessLevel = innerFieds[3]; 
                       }
                       
                       if(!String.isBlank(innerFieds[4]) && innerFieds[4].toLowerCase() != 'all') { 
                           atmObj.CaseAccessLevel = innerFieds[4]; 
                       }
                       
                       if(!String.isBlank(innerFieds[5])) { 
                           atmObj.TeamMemberRole = innerFieds[5]; 
                       } 
                   }
                   accTeamList.add(atmObj);
                }
                System.debug('-----accTeamList-----' + accTeamList + '---' + accTeamList.size());
                
                if(!accTeamList.isEmpty()){
                    List<AccountShare> accShare = new List<AccountShare>();
                    for(AccountTeamMember atmObj : accTeamList){
                        Account accountReference = atmObj.Account;
                        accShare.add(new AccountShare(Account=accountReference, UserOrGroupId=atmObj.UserId, AccountAccessLevel=atmObj.AccountAccessLevel));
                    }
                    
                    List<Database.UpsertResult> results = Database.upsert(accTeamList, false);
                    String result = 'Completed';
                    String resultLog = 'Total Records : ' + accTeamList.size() + ' ';
                    Integer failedCounter = 0;
                    
                    for(Database.UpsertResult upsertResult : results){
                        if(!upsertResult.isSuccess()){ 
                            result = 'Failed';
                            failedCounter++;
                            System.debug('-----upsertResult.getErrors()-----' + upsertResult.getErrors());
                        }
                    }
                    if(failedCounter > 0) System.debug('-----failedCounter-----' + failedCounter); resultLog += 'Failed Records : ' + failedCounter ;
                    
                    PRX_Admin_Data_Load__c adlObj = new PRX_Admin_Data_Load__c(Id=PRXAttachmentDataList[0].ParentId, PRX_Status__c = result, PRX_Error_Log__c=resultLog  );
                    update adlObj;
                }
            }
        }
                
    }
}