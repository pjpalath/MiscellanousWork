public class CognosReportControllerHttp
{   
    // Final entries that should be modified in case the server or details change
    private static final String URL_FIRST_PART = 'https://sf.petsafe.net/';
    private static final String ENC_UNAME = 'ENSsDUo526KkZWat7zqcrl5qwomvWWMvZeUZTxwMbxE=';
    private static final String ENC_PWD = 'V6eRcfeOZxqUPHaB/GpARaYxjnjZ2FBHzwUrNEqYlQk=';
    private static final String REPORT_TYPE_SALES_REPORT = 'SalesReport';
    
    // Final static entries that probably will remain constant
    @TestVisible
    private static final Integer NO_REPORT_DAYS = 7;
    private static final String CURRENT_STRING = 'Current';    
    private static final String REPORT_NOT_FOUND_FILE = 'ReportNotFound.html';
    private static final String ACCOUNT_NOT_FOUND_FILE = 'AccountNotFound.html';
    
    // The URL to use as source in iframe
    public String cognosReportURL { get; set; }
    //added an instance varaible for the standard controller
    public ApexPages.StandardController controller {get; set;}
    // the actual account
    public Account accountFromPage;
    // Allowable report dates
    public List<SelectOption> options{ get; set; }    
    // Report date string
    public String reportDateIndex { get; set; }
    // Body of response
    public String bodyOfUrl { get; set; }
    
    // Decrypted username and password
    private String username;
    private String password;		

	// Constructor
	public CognosReportControllerHttp ()
	{
		
	}

    // Constructor
    public CognosReportControllerHttp (ApexPages.StandardController controller) 
    {
        //initialize the stanrdard controller
        controller = controller;
        accountFromPage = (Account)controller.getRecord();

        options = new List<SelectOption>();
        DateTime reportDate = DateTime.now();
        reportDate = reportDate.addDays(-1 * NO_REPORT_DAYS);
        options.add(new SelectOption(CURRENT_STRING, CURRENT_STRING));                
        for (integer i = 1; i <= NO_REPORT_DAYS-1; i++)
        {
            reportDate = reportDate.addDays(1);
            options.add(new SelectOption(getFormattedDate(reportDate), getFormattedDate(reportDate)));
        }
        
        Blob cryptoKey = blob.valueOf('00000000000000000000000000000000');
        Blob decodedUname = EncodingUtil.base64Decode(ENC_UNAME);
        Blob decryptedUnameData = Crypto.decryptWithManagedIV('AES256', cryptoKey, decodedUname);
        username = decryptedUnameData.toString();

        Blob decodedPwd = EncodingUtil.base64Decode(ENC_PWD);
        Blob decryptedPwdData = Crypto.decryptWithManagedIV('AES256', cryptoKey, decodedPwd);
        password = decryptedPwdData.toString();
    }

    // Format date
    private String getFormattedDate(DateTime reportDate)
    {   
        return reportDate.format('yyyy-MM-dd');   
    }        
    
    // Get the http response
    @TestVisible
    private HttpResponse getHttpResponseAndSetBody(String url)
    {        
        Http http = new Http();
        HttpRequest httpRequest= new HttpRequest();
        httpRequest.setEndpoint(url);        
        Blob headerValue = Blob.valueOf(username + ':' + password);        
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        httpRequest.setHeader('Authorization', authorizationHeader);
        httpRequest.setMethod('GET');
        HttpResponse httpResponse = http.send(httpRequest);
        bodyOfUrl = httpResponse.getBody();
        System.debug('BODY OF URL: ' + bodyOfUrl);
        return httpResponse;
    }
    
    // Get response code for get
    @TestVisible
    private Integer getResponseCodeForUrl(String url)
    {
        HttpResponse httpResponse = getHttpResponseAndSetBody(url);
        return httpResponse.getStatusCode();
    }
    
    // Formatted URL
    @TestVisible
    private String getFormattedURL(String reportType, boolean isCurrent, String reportDate, String rscAccountNumber)
    {
        String returnUrl;
        
        if (isCurrent)
        {
            returnUrl = URL_FIRST_PART + reportType + '/' + CURRENT_STRING + '/' + rscAccountNumber + '.html';
        }
        else
        {           
            returnUrl = URL_FIRST_PART + reportType + '/' + reportDate + '/0/' + rscAccountNumber + '.html';                      
        }              
        
        // Try to retrieve the document and see if the resource exists        
        if (getResponseCodeForUrl(returnUrl) == 404)
        {
            getReportNotFoundURL();            
        }
        
        return returnUrl;
    }   
    
    // Account not found URL
    @TestVisible
    private String getAccountNotFoundURL()
    {
        getHttpResponseAndSetBody(URL_FIRST_PART  + ACCOUNT_NOT_FOUND_FILE);
        return URL_FIRST_PART  + ACCOUNT_NOT_FOUND_FILE;
    }
    
    // Report for this date not found URL
    @TestVisible    
    private String getReportNotFoundURL()
    {
        getHttpResponseAndSetBody(URL_FIRST_PART  + REPORT_NOT_FOUND_FILE);
        return URL_FIRST_PART  + REPORT_NOT_FOUND_FILE;
    }
    
    // Get account search results
    @TestVisible
    private List<Account> getAccountSearchResults()
    {
        // Query to find the account record
        String qry = 'Select a.Account_Number__c from Account a Where Id = \'' + accountFromPage.Id + '\'';
        return Database.query(qry);        
    }
    
    // Get accountNumber
    @TestVisible
    private String getAccountNumber(List<Account> searchResults)
    {
        Account accountAfterQuery = searchResults.get(0);
        return accountAfterQuery.Account_Number__c;
    }
    
    // Get URL for Sales Report
    public void setSalesReportURL()
    {        
        List<Account> searchResults = getAccountSearchResults();
        String accountNumberString;
        if (searchResults.size() > 0)
        {            
            accountNumberString = getAccountNumber(searchResults);
            cognosReportURL = getFormattedURL(REPORT_TYPE_SALES_REPORT, true, null, accountNumberString);                  
        }
        else
        {
            cognosReportURL = getAccountNotFoundURL();            
        }        
    }

    // Get URL for Sales Report after Date Change
    public void setSalesReportURLAfterChange()
    {        
        List<Account> searchResults = getAccountSearchResults();
        boolean isCurrent = true;
        String accountNumberString;
        if (searchResults.size() > 0)
        {           
            accountNumberString = getAccountNumber(searchResults);
            if (!(reportDateIndex.trim()).equals(CURRENT_STRING))
            {
                isCurrent = false;              
            }
            cognosReportURL = getFormattedURL(REPORT_TYPE_SALES_REPORT, isCurrent, reportDateIndex, accountNumberString);           
        }
        else
        {
            cognosReportURL = getAccountNotFoundURL();            
        }        
    }
}