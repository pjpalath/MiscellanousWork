public class GetCryptoValuesController
{   
    // Final entries that should be modified in case the server or details change    
    private static final String UNAME = 'sfcloudsherpa';
    private static final String PWD = 'Sf@36781';

    // Body of response
    public String unameCryptoValue { get; set; }
    public String pwdCryptoValue { get; set; }

    // Constructor
    public GetCryptoValuesController() 
    {        
        Blob cryptoKey = blob.valueOf('00000000000000000000000000000000');
        
        Blob unameData = Blob.valueOf(UNAME);
        Blob encryptedUnameData = Crypto.encryptWithManagedIV('AES256', cryptoKey, unameData);
        String encryptedUname = EncodingUtil.base64Encode(encryptedUnameData);
        
        Blob pwdData = Blob.valueOf(PWD);
        Blob encryptedPwdData = Crypto.encryptWithManagedIV('AES256', cryptoKey, pwdData);
        String encryptedPwd = EncodingUtil.base64Encode(encryptedPwdData);
        
        unameCryptoValue = 'Encrypted Username=|' + encryptedUname + '|';
        pwdCryptoValue = 'Encrypted Password=|' + encryptedPwd + '|';
    }
}