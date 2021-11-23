@isTest
public with sharing class IntakeTriggerHandlerTest {
    //Test setup to simulate trigger.insert
    @TestSetup
    static void createIntake(){
        //insert test account
        Account account = new Account(
            Name = 'TestAcc'
        );
        insert account;
        //insert test contacts with relation to TestAcc
        List<Contact> contactListTest = new List<Contact>();
        for(Integer i = 0; i < 3; i++){
            Contact con = new Contact(
                LastName = 'TestContact ' + i,
                AccountId = account.Id
            );
            contactListTest.add(con);
        }
        insert contactListTest;
    }
    //Test method to verify intake member is created
    @isTest
    public static void createIntakeMembersTest(){
        List<Contact> contactList = [SELECT Id FROM Contact LIMIT 1];
        Intake__c intake = new Intake__c(
            Name = 'Test',
            Contact__c = contactList[0].Id
        );
        insert intake;
        //create list of test intake members created by trigger on before insert
        List<Intake_Member__c> intakeMembers = [SELECT Id, Name, Contact__c, Contact__r.LastName FROM Intake_Member__c WHERE Intake__c = :intake.Id];
        //verify that created 3 intake members in accordance to TestContact
        System.assertEquals(3, intakeMembers.size(), 'Expected 3 intake members');
    }
    
}
