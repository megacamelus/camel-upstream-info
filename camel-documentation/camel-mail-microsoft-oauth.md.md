# Mail-microsoft-oauth.md

**Since Camel 3.18.4**

The Mail Microsoft OAuth2 provides an implementation of
`org.apache.camel.component.mail.MailAuthenticator` to authenticate
IMAP/POP/SMTP connections and access to Email via Spring’s Mail support
and the underlying JavaMail system.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-mail-microsoft-oauth</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

Importing `camel-mail-microsoft-oauth` it will automatically import the
camel-mail component.

# Microsoft Exchange Online OAuth2 Mail Authenticator IMAP sample

To use OAuth, an application must be registered with Azure Active
Directory. Follow the instructions listed in [Register an application
with the Microsoft identity
platform](https://learn.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app)
guide to register a new application.  
Enable application to access Exchange mailboxes via client credentials
flow. Instructions
[here](https://learn.microsoft.com/en-us/exchange/client-developer/legacy-protocols/how-to-authenticate-an-imap-pop-smtp-application-by-using-oauth)  
Once everything is set up, declare and register in the registry, an
instance of
`+org.apache.camel.component.mail.MicrosoftExchangeOnlineOAuth2MailAuthenticator+`.  
For example, in a Spring Boot application:

    @BindToRegistry("auth")
    public MicrosoftExchangeOnlineOAuth2MailAuthenticator exchangeAuthenticator(){
        return new MicrosoftExchangeOnlineOAuth2MailAuthenticator(tenantId, clientId, clientSecret, "jon@doe.com");
    }

and then reference it in the Camel URI:

     from("imaps://outlook.office365.com:993"
                        +  "?authenticator=#auth"
                        +  "&mail.imaps.auth.mechanisms=XOAUTH2"
                        +  "&debugMode=true"
                        +  "&delete=false")
