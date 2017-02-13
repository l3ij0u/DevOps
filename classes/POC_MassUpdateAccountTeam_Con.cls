public class POC_MassUpdateAccountTeam_Con {
    public List<AccountWithTeamWrapper> accTeamWrpList  {get;set;}
    public List<AccountSearchWrapper> accSearchWrpList  {get;set;}    
    public String  accName                              {get;set;}
    public Integer rowToRemove                          {get;set;}
    public Integer rowToTeam                            {get;set;}

    public POC_MassUpdateAccountTeam_Con (){
        accTeamWrpList = new List<AccountWithTeamWrapper>();
        accSearchWrpList = new List<AccountSearchWrapper>();
        accName = '';
    }

    public void accSearch(){
        system.debug('--accName--' + accName);
        if(String.isNotBlank(accName)){
            accSearchWrpList = new List<AccountSearchWrapper>();
            //accName = '';
            for(Account ac : [Select Id,Name,Website,Account_Group__c,Owner.Name from Account where Name Like : '%' + accName + '%' Limit 10]){
                AccountSearchWrapper awobj = new AccountSearchWrapper();
                awobj.acc = ac;
                accSearchWrpList.add(awobj);
            }
        }
    }
    
    public void addSearchToTeamList(){
        Set<Account> accSet = new Set<Account>();
        for(AccountSearchWrapper ac : accSearchWrpList){
            system.debug('--ac.isCheck--' + ac.isCheck);
            if(ac.isCheck){             
                accSet.add(ac.acc);
            }
        }
        
        List<AccountTeamMember> teamList = new List<AccountTeamMember>();
        teamList = [Select AccountAccessLevel,OpportunityAccessLevel,CaseAccessLevel,AccountId,PhotoURL,TeamMemberRole,Title,UserId 
                    from AccountTeamMember where AccountId IN: accSet];
        Map<Id,List<AccountTeamMember>> accTeamMap = new Map<Id,List<AccountTeamMember>>();
        for(AccountTeamMember atm : teamList){
            if(accTeamMap.containsKey(atm.AccountId)){
                accTeamMap.get(atm.AccountId).add(atm);
            }
            else{
                accTeamMap.put(atm.AccountId, new List<AccountTeamMember>{atm});
            }
        }
        
        Set<Id> presentAccId = new Set<Id>();
        for(AccountWithTeamWrapper awrObj : accTeamWrpList){
        	presentAccId.add(awrObj.acc.ParentId);
        }
        
        for(Account accObj : accSet){
            AccountWithTeamWrapper awt = new AccountWithTeamWrapper(accTeamWrpList.size());
            awt.acc.ParentId = accObj.Id;
            if(accTeamMap.containsKey(accObj.Id)){
                awt.accTeamList = accTeamMap.get(accObj.Id);
                awt.removeTeamList = accTeamMap.get(accObj.Id).clone();
            }
            
            if(accTeamWrpList.size() < 500 && !presentAccId.contains(awt.acc.ParentId)){
            	accTeamWrpList.add(awt);
            }
        }
        
        accSearchWrpList = new List<AccountSearchWrapper>();
        accName = '';
    }

    public void addRow(){
        if(accTeamWrpList.size() < 500){
        	accTeamWrpList.add(new AccountWithTeamWrapper(accTeamWrpList.size()));
        }
    }
    
    public void removeRow(){
        system.debug('--rowToRemove--' + rowToRemove);
        system.debug('--accTeamWrpList.size()--' + accTeamWrpList.size());
        if(accTeamWrpList.size() >= rowToRemove){
            accTeamWrpList.remove(rowToRemove);
        }
    }
    
    public void getAccountTeamData(){
        system.debug('--rowToRemove--' + rowToRemove);
        system.debug('--rowToRemove--' + accTeamWrpList[rowToRemove].acc.ParentId);
                       
        if(String.isNotBlank(accTeamWrpList[rowToRemove].acc.ParentId)){
            List<AccountTeamMember> teamList = new List<AccountTeamMember>();
            teamList = [Select AccountAccessLevel,AccountId,PhotoURL,TeamMemberRole,Title,UserId 
                        from AccountTeamMember where AccountId =: accTeamWrpList[rowToRemove].acc.ParentId];
            accTeamWrpList[rowToRemove].accTeamList =   teamList;
            accTeamWrpList[rowToRemove].removeTeamList = teamList.clone();
        }
    }
    
    public void addTeamRow(){
        system.debug('--rowToRemove--' + rowToRemove);
        
        if(accTeamWrpList[rowToRemove].accTeamList.size() < 10){
	        List<AccountTeamMember> teamList = new List<AccountTeamMember>();
	        AccountTeamMember atwObj = new AccountTeamMember();
	        
	        teamList = accTeamWrpList[rowToRemove].accTeamList;
	                
	        atwObj.AccountId = accTeamWrpList[rowToRemove].acc.ParentId;
	        teamList.add(atwObj);
	        accTeamWrpList[rowToRemove].accTeamList = teamList;
        }
        system.debug('---' + accTeamWrpList[rowToRemove].accTeamList.size());
    }
    
    public void removeTeamRow(){
        system.debug('--rowToRemove--' + rowToRemove);
        system.debug('--rowToTeam--' + rowToTeam);

        if(accTeamWrpList[rowToRemove].accTeamList.size() >= rowToTeam){
            accTeamWrpList[rowToRemove].accTeamList.remove(rowToTeam);
        }
    }
    
    public pagereference saveRecords(){
        try{
	        if(accTeamWrpList.isEmpty() && accTeamWrpList.size() == 0){
	        	ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Empty List!'));
	        	return null;
	        }
	        
	        List<AccountTeamMember> insertTeamList = new List<AccountTeamMember>();
	        List<AccountTeamMember> deleteTeamList = new List<AccountTeamMember>();
	        
	        for(AccountWithTeamWrapper awtObj : accTeamWrpList){
	            insertTeamList.addAll(awtObj.accTeamList);
	            deleteTeamList.addAll(awtObj.removeTeamList);
	        }
	        
	        system.debug('--insertTeamList--' + insertTeamList);
	        system.debug('--deleteTeamList--' + deleteTeamList);
	        
	        if(!deleteTeamList.isEmpty()){
	            delete deleteTeamList;
	        }
	        
	        for(AccountTeamMember awtObj : insertTeamList){
	            awtObj.Id = null;
	        }
	        if(!insertTeamList.isEmpty()){
	            insert insertTeamList;
	        }
	        
	        accTeamWrpList = new List<AccountWithTeamWrapper>();
	        accSearchWrpList = new List<AccountSearchWrapper>();
	        accName = '';
	
	        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'Success'));
        }
        catch(Exception ex){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Error Occured!')); 
        }
        return null;
    }

    public class AccountWithTeamWrapper{
        public integer rowNo                            {get;set;}
        public Account acc                              {get;set;}
        public List<AccountTeamMember> accTeamList      {get;set;}
        public List<AccountTeamMember> removeTeamList   {get;set;}
        
        public AccountWithTeamWrapper(integer rowN){
            rowNo = rowN;
            acc = new Account();
            accTeamList = new List<AccountTeamMember>();
            removeTeamList = new List<AccountTeamMember>();
        }
    }
    
    public class AccountSearchWrapper{
        public boolean isCheck                        {get;set;}
        public Account acc                            {get;set;}
        
        
        public AccountSearchWrapper(){
            isCheck = false;
            acc = new Account();
        }
    }
}