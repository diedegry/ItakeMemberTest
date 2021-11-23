@isTest
public with sharing class IntakeMemberControllerTest {
    
    //Create and insert intake record
    @TestSetup
    static void createIntake(){
        Account acc = new Account(
            Name = 'Test acc'
        );
        insert acc;

        List<Contact> contactListTest = new List<Contact>();
        for(Integer i = 0; i < 3; i++){
            Contact con = new Contact(
                LastName = 'Test contact',
                AccountId = acc.Id
            );
            contactListTest.add(con);
        }
        insert contactListTest;
        
        Intake__c intake = new Intake__c(
            Name = 'test',
            Contact__c = contactListTest[0].Id
        );
        insert intake;
    }
    @isTest
    public static void getIntakeMemberRecords() {

        Intake__c intake = [SELECT Id FROM Intake__c LIMIT 1];

        List<Intake_Member__c> returnList = new List<Intake_Member__c>();
        String searchKeyword = 'test';
        String recordId = intake.Id;

        Test.startTest();
        returnList = IntakeMemberController.getIntakeMemberRecords(searchKeyword, recordId);
        Test.stopTest();

        List<Intake_Member__c> intakeMemberList = [SELECT Id FROM Intake_Member__c WHERE Intake__c = :intake.Id];
        System.assertEquals(intakeMemberList.size(), returnList.size(), 'Expected 3 intake member records');
    }
    @isTest
    public static void getAllIntakeMemberTest(){

        Intake__c intake = [SELECT Id FROM Intake__c LIMIT 1];
        
        List<Intake_Member__c> returnList = new List<Intake_Member__c>();

        Test.startTest();
        returnList = IntakeMemberController.getAllIntakeMember(intake.Id);
        Test.stopTest();

        System.assertEquals(3, returnList.size(), 'Expected 3 intake member records');
    }
    @isTest
    public static void updateIntakeMemberTest(){

        List<Intake_Member__c> updatedList = new List<Intake_Member__c>();

        Intake_Member__c intakeMember = [SELECT Age__c FROM Intake_Member__c LIMIT 1];
        intakeMember.Age__c = 25;
        updatedList.add(intakeMember);

        Test.startTest();
        IntakeMemberController.updateIntakeMember(updatedList);
        Test.stopTest();

        List<Intake_Member__c> updatedIntakeMember = [SELECT Age__c FROM Intake_Member__c WHERE Age__c = 25];
        System.assertEquals(1, updatedIntakeMember.size(), 'Expected one intake member with Age = 25');
    }
}
