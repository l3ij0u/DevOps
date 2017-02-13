/* ---This trigger is used to call the CreateOpporutnity service in BCI by Pass the parameters of opportunity record by invoking the PRX_SendBCIReqAndUpdate class, Process request method -----------
       Date Created: 20-06-2016
       Version 1-Excite Project Release 1
*/

trigger PRX_InvokeBCICreateOppty on Opportunity (After insert,Before Update) {
 
    //Collect opportunity list as per opportunity id to update the records.
    List<Opportunity> oppList = new list<Opportunity>(); 
    
    if(trigger.IsInsert)
    {
        oppList = [select id,name,Owner.EmployeeNumber,CloseDate, Account.PRX_Proximus_CDB_Id__c,PRX_BCI_Opportunity_ID__c from opportunity where id IN:Trigger.new]; 
          //if opportunity list is not null then call helper class.     
           if(oppList.size()>0)
           {
          
                 for(opportunity opp:oppList)
                  {
                  string OppName ='';
                 Datetime cdt = datetime.newInstance(opp.CloseDate.year(), opp.CloseDate.month(),opp.CloseDate.day());
                  String closedatefmt=cdt.format('yyyy-MM-dd');
                    //Added by Nutan for BCI production issue on 13/7/2016
                    OppName = opp.Name.left(50);
                    
                  //DateStringFormat=opp.dateStr;
                  if(opp.PRX_BCI_Opportunity_ID__c==null)
                 PRX_SendBCIReqAndUpdate.processRequest(opp.id,OppName,opp.Owner.EmployeeNumber,opp.Account.PRX_Proximus_CDB_Id__c,closedatefmt);
                  }
           }
               
               
     }
     
 
}