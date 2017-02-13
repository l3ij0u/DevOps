@isTest
private class Test_PRX_ChatterAnswers 
{

     static testMethod void validateCreateAccount() 
     {
        string firstname = 'FNTest';
        String lastname = 'lnTest';
        id adminid= UserInfo.getUserId();
        ChatterAnswers objCA = new ChatterAnswers();
        id Accountid;
        Accountid = objCA.createAccount(firstname,lastname,adminid);
       
     }
}