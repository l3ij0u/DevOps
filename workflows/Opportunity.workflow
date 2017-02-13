<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Status_to_Inprogress</fullName>
        <field>App_status__c</field>
        <literalValue>InProgress</literalValue>
        <name>Status to Inprogress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_App_Status_to_None</fullName>
        <field>App_status__c</field>
        <name>Update App Status to None</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Status</fullName>
        <field>App_status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Opportunity Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Complex Bid Approval Check</fullName>
        <actions>
            <name>Complex_Bid_Approval_Required</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterOrEqual</operation>
            <value>625000</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financial Check-Credit Check</fullName>
        <actions>
            <name>Financial_Risk_Credit_Check_Approval_Required</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>Amount &gt;Account.PRX_Financial_Value__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity App Status to None</fullName>
        <actions>
            <name>Update_App_Status_to_None</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule is used to set app status to none .</description>
        <formula>if(Number_of_Request_Sent__c=0,true,false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity Status</fullName>
        <actions>
            <name>Update_Opportunity_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(Number_of_Request_Sent__c = Number_of_Responses_Received__c ,Number_of_Request_Sent__c&gt;0)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity Status to Inprogress</fullName>
        <actions>
            <name>Status_to_Inprogress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>if(Number_of_Request_Sent__c&gt;0,  if(AND(Number_of_Request_Sent__c!=Number_of_Responses_Received__c),true,false),false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Complex_Bid_Approval_Required</fullName>
        <assignedToType>owner</assignedToType>
        <description>Hi, 

Complex Bid approval required as this opportunity amount exceeds €625000. 

Please raise the necessary required approval. 

Thanks.</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Complex Bid-Approval Required</subject>
    </tasks>
    <tasks>
        <fullName>Financial_Risk_Credit_Check_Approval_Required</fullName>
        <assignedToType>owner</assignedToType>
        <description>Hi, 

Financial Risk approval is required for this opportunity as the Opportunity amount is greater than Account Solvency Value 

Thanks</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Financial Risk - Credit Check Approval Required</subject>
    </tasks>
</Workflow>
