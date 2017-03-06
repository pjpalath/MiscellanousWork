/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CognosReportControllerHttpTest 
{

	// Test constants
	@IsTest
    public static void testConstants() 
    {
		System.assertEquals(CognosReportControllerHttp.NO_REPORT_DAYS, CognosReportControllerHttp.NO_REPORT_DAYS);         
    }
    
    // Test constructors
    @IsTest
    public static void testConstructors()
    {
    	// Test the standard constructor
    	CognosReportControllerHttp cognosReportControllerHttp = new CognosReportControllerHttp();
    	
    	// Test the constructor with a controller
    	//Standard controller of Account is just an example
    	//Create a new instance of Account
		Account testAccount = new Account(Name = 'TestAccountName');
		//Insert the object virtually
    	insert testAccount;
		//Create a new instance of standard controller
		ApexPages.StandardController testStandardController = new ApexPages.standardController(testAccount);
		CognosReportControllerHttp cognosReportControllerHttpWithController =
			new CognosReportControllerHttp(testStandardController);
    	
    }
    
    //Test methods
    @IsTest
    public static void testGetHttpResponseAndSetBody()
    {
    	CognosReportControllerHttp cognosReportControllerHttp = new CognosReportControllerHttp();    	
    	String testUrl = 'testUrl';
    	// Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new HttpCallOutMockImpl());
    	HttpResponse testHttpResponse = cognosReportControllerHttp.getHttpResponseAndSetBody(testUrl);
    }
    
    //Test methods
    @IsTest
    public static void testGetResponseCodeForUrl()
    {
    	CognosReportControllerHttp cognosReportControllerHttp = new CognosReportControllerHttp();
    	// Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new HttpCallOutMockImpl());
    	String testUrl = 'testUrl';
    	Integer testHttpResponse = cognosReportControllerHttp.getResponseCodeForUrl(testUrl);
    }
    
    //Test methods
    @IsTest
    public static void testGetFormattedURL()
    {
    	CognosReportControllerHttp cognosReportControllerHttp = new CognosReportControllerHttp();
    	// Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new HttpCallOutMockImpl());
    	String testReportType = 'testReportType';
    	Boolean testIsCurrent = true;
    	String testReportDate = 'testReportDate';
    	String testRscAccountNumber = 'testRscAccountNumber';
    	String testFormattedUrl = cognosReportControllerHttp.getFormattedURL(testReportType, testIsCurrent,
    		testReportDate, testRscAccountNumber);
    }
    
    //Test methods
    @IsTest
    public static void testGetAccountNotFoundURL()
    {
    	CognosReportControllerHttp cognosReportControllerHttp = new CognosReportControllerHttp();
    	// Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new HttpCallOutMockImpl());
    	String testAccountNotFoundUrl = cognosReportControllerHttp.getAccountNotFoundURL();
    }
    
    //Test methods
    @IsTest
    public static void testGetReportNotFoundURL()
    {
    	CognosReportControllerHttp cognosReportControllerHttp = new CognosReportControllerHttp();
    	// Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new HttpCallOutMockImpl());
    	String testReportNotFoundUrl = cognosReportControllerHttp.getReportNotFoundURL();
    }
    
    //Test methods
    @IsTest
    public static void testGetAccountSearchResults()
    {
    	//Create a new instance of Account
		Account testAccount = new Account(Name = 'TestAccountName');
		//Insert the object virtually
    	insert testAccount;
		//Create a new instance of standard controller
		ApexPages.StandardController testStandardController = new ApexPages.standardController(testAccount);
    	CognosReportControllerHttp cognosReportControllerHttp = new CognosReportControllerHttp(testStandardController);
    	List<Account> testAccountSearchResults = cognosReportControllerHttp.getAccountSearchResults();
    }
    
    //Test methods
    @IsTest
    public static void testGetAccountNumber()
    {
    	//Create a new instance of Account
		Account testAccount = new Account(Name = 'TestAccountName');
		//Insert the object virtually
    	insert testAccount;
		//Create a new instance of standard controller
		ApexPages.StandardController testStandardController = new ApexPages.standardController(testAccount);
    	CognosReportControllerHttp cognosReportControllerHttp = new CognosReportControllerHttp(testStandardController);
    	List<Account> testAccountSearchResults = cognosReportControllerHttp.getAccountSearchResults();
    	String testAccountNumber = cognosReportControllerHttp.getAccountNumber(testAccountSearchResults);
    }
    
    //Test methods
    @IsTest
    public static void testSetSalesReportURL()
    {
    	//Create a new instance of Account
		Account testAccount = new Account(Name = 'TestAccountName');
		//Insert the object virtually
    	insert testAccount;
		//Create a new instance of standard controller
		ApexPages.StandardController testStandardController = new ApexPages.standardController(testAccount);
    	CognosReportControllerHttp cognosReportControllerHttp = new CognosReportControllerHttp(testStandardController);
    	Test.startTest();
    	// Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new HttpCallOutMockImpl());
    	cognosReportControllerHttp.setSalesReportURL();
    	Test.stopTest();
    }
    
    //Test methods
    @IsTest
    public static void testSetSalesReportURLAfterChange()
    {
    	//Create a new instance of Account
		Account testAccount = new Account(Name = 'TestAccountName');
		//Insert the object virtually
    	insert testAccount;
		//Create a new instance of standard controller
		ApexPages.StandardController testStandardController = new ApexPages.standardController(testAccount);
    	CognosReportControllerHttp cognosReportControllerHttp = new CognosReportControllerHttp(testStandardController);
    	CognosReportControllerHttp.reportDateIndex = 'Current';
    	Test.startTest();
    	// Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new HttpCallOutMockImpl());
    	cognosReportControllerHttp.setSalesReportURLAfterChange();
    	Test.stopTest();
    }
}