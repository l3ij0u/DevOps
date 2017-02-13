global class PRX_ConvertCase
{
    webservice static Id Copyingtask(Id taskID) // you can pass parameters
    {
        system.debug('=====Id========'+taskID);
        List<task> tasklist = new List<task>();
        tasklist = [select id,WhatId,WhoId,Subject,Description from Task where id =:taskID limit 1];
        Case Caseobj = new case();
        if(!tasklist.isEmpty()){
            
            Caseobj.AccountId = tasklist[0].WhatId;
            Caseobj.ContactId = tasklist[0].WhoId;
            Caseobj.Status  = 'New';
            Caseobj.Origin  = 'Other';
            Caseobj.Description = tasklist[0].Description;
            Caseobj.Subject = tasklist[0].Subject;
            try{
            insert Caseobj;
            delete tasklist; 
            }catch(exception ex){}
        }
        return Caseobj.id; 
    }
}