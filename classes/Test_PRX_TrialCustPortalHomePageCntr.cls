@isTest
private class Test_PRX_TrialCustPortalHomePageCntr
{
    static testMethod void TestHomePagecntr()
    {
      User u =[Select id,contactId,Contact.AccountId from User where id = :UserInfo.getUserId()];
      
      //Create the Account Record
      Account testAccount = new Account(name='Test Company Name',owner=u);
      insert testAccount;
     
      //Create the Contact Record   
      Contact testContact = new Contact(firstname='test',lastname='contact',accountid= testAccount.id,Email='test@gmail.com',Department='Employee',Title='CEO',PRX_Gender__c='Female',PRX_Language__c='Dutch',Owner=u);
      insert testContact;
            
     //Create the Case Record.
        Case objcase = new Case(Status ='New', Priority = 'Medium', Origin = 'Email',AccountId=testAccount.id); 
        Case objcase1 = new Case(Status ='New', Priority = 'Medium', Origin = 'Email',AccountId=testAccount.id); 
        list<case>  lstcase= new list<case>();
        lstcase.add(objcase);
        lstcase.add(objcase1);
        insert lstcase;
      
     //create the Asset record
         list<Asset> lstass= new list<Asset>();
         Asset obass = new asset(Name ='test',SerialNumber='test123',InstallDate =Date.Today(),UsageEndDate=Date.Today(),Status='shipped',ContactId=testContact.id);    
         Asset obass1 = new asset(Name ='test1',SerialNumber='test1231',InstallDate =Date.Today(),UsageEndDate=Date.Today(),Status='shipped',ContactId=testContact.id);    
         Asset obass2 = new asset(Name ='test2',SerialNumber='test1232',InstallDate =Date.Today(),UsageEndDate=Date.Today(),Status='shipped',ContactId=testContact.id);    
          lstass.add(obass);
          lstass.add(obass1);
          lstass.add(obass2);
          insert lstass;
        
      //Create the soluation record
         Solution objsol=new Solution( SolutionName='tst');
         Solution objsol1=new Solution( SolutionName='tst1');
         Solution objsol2=new Solution( SolutionName='tst2');
         list<Solution> lstsol= new list<Solution>();
         lstsol.add(objsol);
         lstsol.add(objsol1);
         lstsol.add(objsol2);
         
         insert lstsol ;
     
     List<Community> listCommunity = [Select c.Name, c.IsActive, c.Id From Community c where IsActive=true];
       list<idea> lstidea= new list<idea>();
     //Create the Idea Record
     if(listCommunity.size()>0)
     {
     Idea objIdea1= new Idea(Title='test1',Categories='test',CommunityId=listCommunity[0].id);
     Idea objIdea2= new Idea(Title='test2',Categories='test',CommunityId=listCommunity[0].id);
     Idea objIdea3= new Idea(Title='test3',Categories='test',CommunityId=listCommunity[0].id);
   
     lstidea.add(objIdea1);
     lstidea.add(objIdea2);
     lstidea.add(objIdea3);
     insert lstidea; 
      }     
                   
        TrialCustomerPortalHomePageController objHomeCtr = new TrialCustomerPortalHomePageController();
         objHomeCtr.sortField1='Name';
         objHomeCtr.sortField2='Status';
         objHomeCtr.sortField3='SolutionName';
         objHomeCtr.sortField4='Title';
            
            objHomeCtr.MyRegisteredProducts=new list<Asset>();
            objHomeCtr.MyRegisteredProducts=lstass;
           
            system.debug ('objHomeCtr.MyRegisteredProducts' +objHomeCtr.MyRegisteredProducts);
            objHomeCtr.SortProducts();
            
            objHomeCtr.MyRecentCases =new list<case>();
            objHomeCtr.MyRecentCases=lstcase;
            objHomeCtr.SortCases();
            
            objHomeCtr.TopSolutions= new list<solution>();
            objHomeCtr.TopSolutions =lstsol;
            objHomeCtr.SortSolutions();
            
            objHomeCtr.PopularIdeas = new list<idea>();
            objHomeCtr.PopularIdeas = lstidea;
            objHomeCtr.SortIdeas();
            
            //Previous fields are same.
             objHomeCtr.previousSortField1='Name';
             objHomeCtr.previousSortField1='Status';
             objHomeCtr.previousSortField1='SolutionName';
             objHomeCtr.previousSortField1='Title';
            
             
             objHomeCtr.SortProducts();
            
             
     }
     
}