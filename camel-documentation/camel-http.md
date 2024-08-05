# Http

**Since Camel 2.3**

**Only producer is supported**

The HTTP component provides HTTP-based endpoints for calling external
HTTP resources (as a client to call external servers using HTTP).

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-http</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    http:hostname[:port][/resourceUri][?options]

Will by default use port 80 for HTTP and 443 for HTTPS.

# Message Body

Camel will store the HTTP response from the external server on the *OUT*
body. All headers from the *IN* message will be copied to the *OUT*
message, so headers are preserved during routing. Additionally, Camel
will add the HTTP response headers as well to the *OUT* message headers.

# Using System Properties

When setting useSystemProperties to true, the HTTP Client will look for
the following System Properties, and it will use it:

-   `ssl.TrustManagerFactory.algorithm`

-   `javax.net.ssl.trustStoreType`

-   `javax.net.ssl.trustStore`

-   `javax.net.ssl.trustStoreProvider`

-   `javax.net.ssl.trustStorePassword`

-   `java.home`

-   `ssl.KeyManagerFactory.algorithm`

-   `javax.net.ssl.keyStoreType`

-   `javax.net.ssl.keyStore`

-   `javax.net.ssl.keyStoreProvider`

-   `javax.net.ssl.keyStorePassword`

-   `http.proxyHost`

-   `http.proxyPort`

-   `http.nonProxyHosts`

-   `http.keepAlive`

-   `http.maxConnections`

# Response code

Camel will handle, according to the HTTP response code:

-   Response code is in the range 100..299, Camel regards it as a
    success response.

-   Response code is in the range 300..399, Camel regards it as a
    redirection response and will throw a `HttpOperationFailedException`
    with the information.

-   Response code is 400+, Camel regards it as an external server
    failure and will throw a `HttpOperationFailedException` with the
    information.

**throwExceptionOnFailure**

The option, `throwExceptionOnFailure`, can be set to `false` to prevent
the `HttpOperationFailedException` from being thrown for failed response
codes. This allows you to get any response from the remote server.

# Exceptions

`HttpOperationFailedException` exception contains the following
information:

-   The HTTP status code

-   The HTTP status line (text of the status code)

-   Redirect location if server returned a redirect

-   Response body as a `java.lang.String`, if server provided a body as
    response

# Which HTTP method will be used

The following algorithm is used to determine what HTTP method should be
used:

1. Use method provided as endpoint configuration (`httpMethod`).
2. Use method provided in header (`Exchange.HTTP_METHOD`).
3. `GET` if query string is provided in header.
4. `GET` if endpoint is configured with a query string.
5. `POST` if there is data to send (body is not `null`).
6. `GET` otherwise.

# Configuring URI to call

You can set the HTTP producer’s URI directly from the endpoint URI. In
the route below, Camel will call out to the external server, `oldhost`,
using HTTP.

    from("direct:start")
        .to("http://oldhost");

And the equivalent XML DSL:

    <route>
      <from uri="direct:start"/>
      <to uri="http://oldhost"/>
    </route>

You can override the HTTP endpoint URI by adding a header with the key
`Exchange.HTTP_URI` on the message.

    from("direct:start")
      .setHeader(Exchange.HTTP_URI, constant("http://newhost"))
      .to("http://oldhost");

In the sample above, Camel will call the [http://newhost](http://newhost) despite the
endpoint is configured with [http://oldhost](http://oldhost).  
If the http endpoint is working in bridge mode, it will ignore the
message header of `Exchange.HTTP_URI`.

# Configuring URI Parameters

The **http** producer supports URI parameters to be sent to the HTTP
server. The URI parameters can either be set directly on the endpoint
URI or as a header with the key `Exchange.HTTP_QUERY` on the message.

    from("direct:start")
      .to("http://oldhost?order=123&detail=short");

Or options provided in a header:

    from("direct:start")
      .setHeader(Exchange.HTTP_QUERY, constant("order=123&detail=short"))
      .to("http://oldhost");

# How to set the http method (GET/PATCH/POST/PUT/DELETE/HEAD/OPTIONS/TRACE) to the HTTP producer

The HTTP component provides a way to set the HTTP request method by
setting the message header. Here is an example:

    from("direct:start")
      .setHeader(Exchange.HTTP_METHOD, constant(org.apache.camel.component.http.HttpMethods.POST))
      .to("http://www.google.com")
      .to("mock:results");

The method can be written a bit shorter using the string constants:

    .setHeader("CamelHttpMethod", constant("POST"))

And the equivalent XML DSL:

    <route>
      <from uri="direct:start"/>
      <setHeader name="CamelHttpMethod">
          <constant>POST</constant>
      </setHeader>
      <to uri="http://www.google.com"/>
      <to uri="mock:results"/>
    </route>

# Using client timeout - SO\_TIMEOUT

See the
[HttpSOTimeoutTest](https://github.com/apache/camel/blob/main/components/camel-http/src/test/java/org/apache/camel/component/http/HttpSOTimeoutTest.java)
unit test.

# Configuring a Proxy

The HTTP component provides a way to configure a proxy.

    from("direct:start")
      .to("http://oldhost?proxyAuthHost=www.myproxy.com&proxyAuthPort=80");

There is also support for proxy authentication via the
`proxyAuthUsername` and `proxyAuthPassword` options.

## Using proxy settings outside of URI

To avoid System properties conflicts, you can set proxy configuration
only from the CamelContext or URI.  
Java DSL :

    context.getGlobalOptions().put("http.proxyHost", "172.168.18.9");
    context.getGlobalOptions().put("http.proxyPort", "8080");

Spring XML

    <camelContext>
        <properties>
            <property key="http.proxyHost" value="172.168.18.9"/>
            <property key="http.proxyPort" value="8080"/>
       </properties>
    </camelContext>

Camel will first set the settings from Java System or CamelContext
Properties and then the endpoint proxy options if provided. So you can
override the system properties with the endpoint options.

There is also a `http.proxyScheme` property you can set to explicitly
configure the scheme to use.

# Configuring charset

If you are using `POST` to send data you can configure the `charset`
using the `Exchange` property:

    exchange.setProperty(Exchange.CHARSET_NAME, "ISO-8859-1");

## Sample with scheduled poll

This sample polls the Google homepage every 10 seconds and write the
page to the file `message.html`:

    from("timer://foo?fixedRate=true&delay=0&period=10000")
      .to("http://www.google.com")
      .setHeader(FileComponent.HEADER_FILE_NAME, "message.html")
      .to("file:target/google");

## URI Parameters from the endpoint URI

In this sample, we have the complete URI endpoint that is just what you
would have typed in a web browser. Multiple URI parameters can of course
be set using the `&` character as separator, just as you would in the
web browser. Camel does no tricks here.

    // we query for Camel at the Google page
    template.sendBody("http://www.google.com/search?q=Camel", null);

## URI Parameters from the Message

    Map headers = new HashMap();
    headers.put(Exchange.HTTP_QUERY, "q=Camel&lr=lang_en");
    // we query for Camel and English language at Google
    template.sendBody("http://www.google.com/search", null, headers);

In the header value above notice that it should **not** be prefixed with
`?` and you can separate parameters as usual with the `&` char.

## Getting the Response Code

You can get the HTTP response code from the HTTP component by getting
the value from the Out message header with
`Exchange.HTTP_RESPONSE_CODE`.

    Exchange exchange = template.send("http://www.google.com/search", new Processor() {
      public void process(Exchange exchange) throws Exception {
        exchange.getIn().setHeader(Exchange.HTTP_QUERY, constant("hl=en&q=activemq"));
      }
    });
    Message out = exchange.getOut();
    int responseCode = out.getHeader(Exchange.HTTP_RESPONSE_CODE, Integer.class);

# Disabling Cookies

To disable cookies in the CookieStore, you can set the HTTP Client to
ignore cookies by adding this URI option:
`httpClient.cookieSpec=ignore`. This doesn’t affect cookies manually set
in the `Cookie` header

# Basic auth with the streaming message body

To avoid the `NonRepeatableRequestException`, you need to do the
Preemptive Basic Authentication by adding the option:
`authenticationPreemptive=true`

# OAuth2 Support

To get an access token from an Authorization Server and fill that in
Authorization header to do requests to protected services, you will need
to use `oauth2ClientId`, `oauth2ClientSecret` and `oauth2TokenEndpoint`
properties, and those should be defined as specified at RFC 6749 and
provided by your Authorization Server.

In below example camel will do an underlying request to
`https://localhost:8080/realms/master/protocol/openid-connect/token`
using provided credentials (client id and client secret), then will get
`access_token` from response and lastly will fill it at `Authorization`
header of request which will be done to `https://localhost:9090`.

    String clientId = "my-client-id";
    String clientSecret = "my-client-secret";
    String tokenEndpoint = "https://localhost:8080/realms/master/protocol/openid-connect/token";
    String scope = "my-scope"; // optional scope
    
    from("direct:start")
      .to("https://localhost:9090/?oauth2ClientId=" + clientId + "&oauth2ClientSecret=" + clientSecret + "&oauth2TokenEndpoint=" + tokenEndpoint + "&oauth2Scope=" + scope);

Camel only provides support for OAuth2 client credentials flow

Camel does not perform any validation in access token. It’s up to the
underlying service to validate it.

# Advanced Usage

If you need more control over the HTTP producer, you should use the
`HttpComponent` where you can set various classes to give you custom
behavior.

## Setting up SSL for HTTP Client

Using the JSSE Configuration Utility

The HTTP component supports SSL/TLS configuration through the [Camel
JSSE Configuration
Utility](#manual::camel-configuration-utilities.adoc). This utility
greatly decreases the amount of component-specific code you need to
write and is configurable at the endpoint and component levels. The
following examples demonstrate how to use the utility with the HTTP
component.

Programmatic configuration of the component

    KeyStoreParameters ksp = new KeyStoreParameters();
    ksp.setResource("file:/users/home/server/keystore.jks");
    ksp.setPassword("keystorePassword");
    
    KeyManagersParameters kmp = new KeyManagersParameters();
    kmp.setKeyStore(ksp);
    kmp.setKeyPassword("keyPassword");
    
    SSLContextParameters scp = new SSLContextParameters();
    scp.setKeyManagers(kmp);
    
    HttpComponent httpComponent = getContext().getComponent("https", HttpComponent.class);
    httpComponent.setSslContextParameters(scp);

Spring DSL based configuration of endpoint

      <camel:sslContextParameters
          id="sslContextParameters">
        <camel:keyManagers
            keyPassword="keyPassword">
          <camel:keyStore
              resource="file:/users/home/server/keystore.jks"
              password="keystorePassword"/>
        </camel:keyManagers>
      </camel:sslContextParameters>
    
      <to uri="https://127.0.0.1/mail/?sslContextParameters=#sslContextParameters"/>

Configuring Apache HTTP Client Directly

Basically, a camel-http component is built on the top of [Apache
HttpClient](https://hc.apache.org/httpcomponents-client-5.1.x/). Please
refer to [SSL/TLS
customization](https://hc.apache.org/httpcomponents-client-4.5.x/current/tutorial/html/connmgmt.html)
(even if the link is referring to an article about version 4, it is
still more or less relevant moreover there is no equivalent for version
5\) for details or have a look into the
`org.apache.camel.component.http.HttpsServerTestSupport` unit test base
class.  
You can also implement a custom
`org.apache.camel.component.http.HttpClientConfigurer` to do some
configuration on the http client if you need full control of it.

However, if you *just* want to specify the keystore and truststore, you
can do this with Apache HTTP `HttpClientConfigurer`, for example:

    KeyStore keystore = ...;
    KeyStore truststore = ...;
    
    SchemeRegistry registry = new SchemeRegistry();
    registry.register(new Scheme("https", 443, new SSLSocketFactory(keystore, "mypassword", truststore)));

And then you need to create a class that implements
`HttpClientConfigurer`, and registers https protocol providing a
keystore or truststore per the example above. Then, from your camel
route builder class, you can hook it up like so:

    HttpComponent httpComponent = getContext().getComponent("http", HttpComponent.class);
    httpComponent.setHttpClientConfigurer(new MyHttpClientConfigurer());

If you are doing this using the Spring DSL, you can specify your
`HttpClientConfigurer` using the URI. For example:

    <bean id="myHttpClientConfigurer"
     class="my.https.HttpClientConfigurer">
    </bean>
    
    <to uri="https://myhostname.com:443/myURL?httpClientConfigurer=myHttpClientConfigurer"/>

As long as you implement the `HttpClientConfigurer` and configure your
keystore and truststore as described above, it will work fine.

Using HTTPS to authenticate gotchas

An end user reported that he had a problem with authenticating with
HTTPS. The problem was eventually resolved by providing a custom
configured `org.apache.hc.core5.http.protocol.HttpContext`:

-   1\. Create a (Spring) factory for HttpContexts:

<!-- -->

    public class HttpContextFactory {
    
      private String httpHost = "localhost";
      private String httpPort = 9001;
      private String user = "some-user";
      private String password = "my-secret";
    
      private HttpClientContext context = HttpClientContext.create();
      private BasicAuthCache authCache = new BasicAuthCache();
      private BasicScheme basicAuth = new BasicScheme();
    
      public HttpContext getObject() {
        UsernamePasswordCredentials credentials = new UsernamePasswordCredentials(user, password.toCharArray());
        BasicCredentialsProvider provider = new BasicCredentialsProvider();
        HttpHost host = new HttpHost(httpHost, httpPort);
        provider.setCredentials(host, credentials);
    
        authCache.put(host, basicAuth);
    
        httpContext.setAuthCache(authCache);
        httpContext.setCredentialsProvider(provider);
    
        return httpContext;
      }
    
      // getter and setter
    }

-   2\. Declare an\` HttpContext\` in the Spring application context
    file:

<!-- -->

    <bean id="myHttpContext" factory-bean="httpContextFactory" factory-method="getObject"/>

-   3\. Reference the context in the http URL:

<!-- -->

    <to uri="https://myhostname.com:443/myURL?httpContext=myHttpContext"/>

Using different SSLContextParameters

The [HTTP](#http-component.adoc) component only supports one instance of
`org.apache.camel.support.jsse.SSLContextParameters` per component. If
you need to use two or more different instances, then you need to set up
multiple [HTTP](#http-component.adoc) components as shown below. Where
we have two components, each using their own instance of
`sslContextParameters` property.

    <bean id="http-foo" class="org.apache.camel.component.http.HttpComponent">
       <property name="sslContextParameters" ref="sslContextParams1"/>
       <property name="x509HostnameVerifier" ref="hostnameVerifier"/>
    </bean>
    
    <bean id="http-bar" class="org.apache.camel.component.http.HttpComponent">
       <property name="sslContextParameters" ref="sslContextParams2"/>
       <property name="x509HostnameVerifier" ref="hostnameVerifier"/>
    </bean>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|skipRequestHeaders|Whether to skip mapping all the Camel headers as HTTP request headers. If there are no data from Camel headers needed to be included in the HTTP request then this can avoid parsing overhead with many object allocations for the JVM garbage collector.|false|boolean|
|skipResponseHeaders|Whether to skip mapping all the HTTP response headers to Camel headers. If there are no data needed from HTTP headers then this can avoid parsing overhead with many object allocations for the JVM garbage collector.|false|boolean|
|cookieStore|To use a custom org.apache.hc.client5.http.cookie.CookieStore. By default the org.apache.hc.client5.http.cookie.BasicCookieStore is used which is an in-memory only cookie store. Notice if bridgeEndpoint=true then the cookie store is forced to be a noop cookie store as cookie shouldn't be stored as we are just bridging (eg acting as a proxy).||object|
|copyHeaders|If this option is true then IN exchange headers will be copied to OUT exchange headers according to copy strategy. Setting this to false, allows to only include the headers from the HTTP response (not propagating IN headers).|true|boolean|
|followRedirects|Whether to the HTTP request should follow redirects. By default the HTTP request does not follow redirects|false|boolean|
|responsePayloadStreamingThreshold|This threshold in bytes controls whether the response payload should be stored in memory as a byte array or be streaming based. Set this to -1 to always use streaming mode.|8192|integer|
|allowJavaSerializedObject|Whether to allow java serialization when a request uses context-type=application/x-java-serialized-object. This is by default turned off. If you enable this then be aware that Java will deserialize the incoming data from the request to Java and that can be a potential security risk.|false|boolean|
|authCachingDisabled|Disables authentication scheme caching|false|boolean|
|automaticRetriesDisabled|Disables automatic request recovery and re-execution|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|clientConnectionManager|To use a custom and shared HttpClientConnectionManager to manage connections. If this has been configured then this is always used for all endpoints created by this component.||object|
|connectionsPerRoute|The maximum number of connections per route.|20|integer|
|connectionStateDisabled|Disables connection state tracking|false|boolean|
|connectionTimeToLive|The time for connection to live, the time unit is millisecond, the default value is always keep alive.||integer|
|contentCompressionDisabled|Disables automatic content decompression|false|boolean|
|cookieManagementDisabled|Disables state (cookie) management|false|boolean|
|defaultUserAgentDisabled|Disables the default user agent set by this builder if none has been provided by the user|false|boolean|
|httpBinding|To use a custom HttpBinding to control the mapping between Camel message and HttpClient.||object|
|httpClientConfigurer|To use the custom HttpClientConfigurer to perform configuration of the HttpClient that will be used.||object|
|httpConfiguration|To use the shared HttpConfiguration as base configuration.||object|
|httpContext|To use a custom org.apache.hc.core5.http.protocol.HttpContext when executing requests.||object|
|maxTotalConnections|The maximum number of connections.|200|integer|
|redirectHandlingDisabled|Disables automatic redirect handling|false|boolean|
|headerFilterStrategy|To use a custom org.apache.camel.spi.HeaderFilterStrategy to filter header to and from Camel message.||object|
|proxyAuthDomain|Proxy authentication domain to use||string|
|proxyAuthHost|Proxy authentication host||string|
|proxyAuthMethod|Proxy authentication method to use||string|
|proxyAuthNtHost|Proxy authentication domain (workstation name) to use with NTML||string|
|proxyAuthPassword|Proxy authentication password||string|
|proxyAuthPort|Proxy authentication port||integer|
|proxyAuthScheme|Proxy authentication protocol scheme||string|
|proxyAuthUsername|Proxy authentication username||string|
|sslContextParameters|To configure security using SSLContextParameters. Important: Only one instance of org.apache.camel.support.jsse.SSLContextParameters is supported per HttpComponent. If you need to use 2 or more different instances, you need to define a new HttpComponent per instance you need.||object|
|useGlobalSslContextParameters|Enable usage of global SSL context parameters.|false|boolean|
|x509HostnameVerifier|To use a custom X509HostnameVerifier such as DefaultHostnameVerifier or NoopHostnameVerifier.||object|
|connectionRequestTimeout|Returns the connection lease request timeout used when requesting a connection from the connection manager. A timeout value of zero is interpreted as a disabled timeout.|3 minutes|object|
|connectTimeout|Determines the timeout until a new connection is fully established. A timeout value of zero is interpreted as an infinite timeout.|3 minutes|object|
|responseTimeout|Determines the timeout until arrival of a response from the opposite endpoint. A timeout value of zero is interpreted as an infinite timeout. Please note that response timeout may be unsupported by HTTP transports with message multiplexing.|0|object|
|soTimeout|Determines the default socket timeout value for blocking I/O operations.|3 minutes|object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|httpUri|The url of the HTTP endpoint to call.||string|
|disableStreamCache|Determines whether or not the raw input stream from Servlet is cached or not (Camel will read the stream into a in memory/overflow to file, Stream caching) cache. By default Camel will cache the Servlet input stream to support reading it multiple times to ensure it Camel can retrieve all data from the stream. However you can set this option to true when you for example need to access the raw stream, such as streaming it directly to a file or other persistent store. DefaultHttpBinding will copy the request input stream into a stream cache and put it into message body if this option is false to support reading the stream multiple times. If you use Servlet to bridge/proxy an endpoint then consider enabling this option to improve performance, in case you do not need to read the message payload multiple times. The http producer will by default cache the response body stream. If setting this option to true, then the producers will not cache the response body stream but use the response stream as-is as the message body.|false|boolean|
|headerFilterStrategy|To use a custom HeaderFilterStrategy to filter header to and from Camel message.||object|
|bridgeEndpoint|If the option is true, HttpProducer will ignore the Exchange.HTTP\_URI header, and use the endpoint's URI for request. You may also set the option throwExceptionOnFailure to be false to let the HttpProducer send all the fault response back.|false|boolean|
|connectionClose|Specifies whether a Connection Close header must be added to HTTP Request. By default connectionClose is false.|false|boolean|
|httpMethod|Configure the HTTP method to use. The HttpMethod header cannot override this option if set.||object|
|skipRequestHeaders|Whether to skip mapping all the Camel headers as HTTP request headers. If there are no data from Camel headers needed to be included in the HTTP request then this can avoid parsing overhead with many object allocations for the JVM garbage collector.|false|boolean|
|skipResponseHeaders|Whether to skip mapping all the HTTP response headers to Camel headers. If there are no data needed from HTTP headers then this can avoid parsing overhead with many object allocations for the JVM garbage collector.|false|boolean|
|throwExceptionOnFailure|Option to disable throwing the HttpOperationFailedException in case of failed responses from the remote server. This allows you to get all responses regardless of the HTTP status code.|true|boolean|
|clearExpiredCookies|Whether to clear expired cookies before sending the HTTP request. This ensures the cookies store does not keep growing by adding new cookies which is newer removed when they are expired. If the component has disabled cookie management then this option is disabled too.|true|boolean|
|cookieHandler|Configure a cookie handler to maintain a HTTP session||object|
|cookieStore|To use a custom CookieStore. By default the BasicCookieStore is used which is an in-memory only cookie store. Notice if bridgeEndpoint=true then the cookie store is forced to be a noop cookie store as cookie shouldn't be stored as we are just bridging (eg acting as a proxy). If a cookieHandler is set then the cookie store is also forced to be a noop cookie store as cookie handling is then performed by the cookieHandler.||object|
|copyHeaders|If this option is true then IN exchange headers will be copied to OUT exchange headers according to copy strategy. Setting this to false, allows to only include the headers from the HTTP response (not propagating IN headers).|true|boolean|
|customHostHeader|To use custom host header for producer. When not set in query will be ignored. When set will override host header derived from url.||string|
|deleteWithBody|Whether the HTTP DELETE should include the message body or not. By default HTTP DELETE do not include any HTTP body. However in some rare cases users may need to be able to include the message body.|false|boolean|
|followRedirects|Whether to the HTTP request should follow redirects. By default the HTTP request does not follow redirects|false|boolean|
|getWithBody|Whether the HTTP GET should include the message body or not. By default HTTP GET do not include any HTTP body. However in some rare cases users may need to be able to include the message body.|false|boolean|
|ignoreResponseBody|If this option is true, The http producer won't read response body and cache the input stream|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|okStatusCodeRange|The status codes which are considered a success response. The values are inclusive. Multiple ranges can be defined, separated by comma, e.g. 200-204,209,301-304. Each range must be a single number or from-to with the dash included.|200-299|string|
|preserveHostHeader|If the option is true, HttpProducer will set the Host header to the value contained in the current exchange Host header, useful in reverse proxy applications where you want the Host header received by the downstream server to reflect the URL called by the upstream client, this allows applications which use the Host header to generate accurate URL's for a proxied service|false|boolean|
|userAgent|To set a custom HTTP User-Agent request header||string|
|clientBuilder|Provide access to the http client request parameters used on new RequestConfig instances used by producers or consumers of this endpoint.||object|
|clientConnectionManager|To use a custom HttpClientConnectionManager to manage connections||object|
|connectionsPerRoute|The maximum number of connections per route.|20|integer|
|httpClient|Sets a custom HttpClient to be used by the producer||object|
|httpClientConfigurer|Register a custom configuration strategy for new HttpClient instances created by producers or consumers such as to configure authentication mechanisms etc.||object|
|httpClientOptions|To configure the HttpClient using the key/values from the Map.||object|
|httpConnectionOptions|To configure the connection and the socket using the key/values from the Map.||object|
|httpContext|To use a custom HttpContext instance||object|
|maxTotalConnections|The maximum number of connections.|200|integer|
|useSystemProperties|To use System Properties as fallback for configuration|false|boolean|
|proxyAuthDomain|Proxy authentication domain to use with NTML||string|
|proxyAuthHost|Proxy authentication host||string|
|proxyAuthMethod|Proxy authentication method to use||string|
|proxyAuthNtHost|Proxy authentication domain (workstation name) to use with NTML||string|
|proxyAuthPassword|Proxy authentication password||string|
|proxyAuthPort|Proxy authentication port||integer|
|proxyAuthScheme|Proxy authentication scheme to use||string|
|proxyAuthUsername|Proxy authentication username||string|
|proxyHost|Proxy hostname to use||string|
|proxyPort|Proxy port to use||integer|
|authDomain|Authentication domain to use with NTML||string|
|authenticationPreemptive|If this option is true, camel-http sends preemptive basic authentication to the server.|false|boolean|
|authHost|Authentication host to use with NTML||string|
|authMethod|Authentication methods allowed to use as a comma separated list of values Basic, Digest or NTLM.||string|
|authMethodPriority|Which authentication method to prioritize to use, either as Basic, Digest or NTLM.||string|
|authPassword|Authentication password||string|
|authUsername|Authentication username||string|
|oauth2ClientId|OAuth2 client id||string|
|oauth2ClientSecret|OAuth2 client secret||string|
|oauth2TokenEndpoint|OAuth2 Token endpoint||string|
|sslContextParameters|To configure security using SSLContextParameters. Important: Only one instance of org.apache.camel.util.jsse.SSLContextParameters is supported per HttpComponent. If you need to use 2 or more different instances, you need to define a new HttpComponent per instance you need.||object|
|x509HostnameVerifier|To use a custom X509HostnameVerifier such as DefaultHostnameVerifier or NoopHostnameVerifier||object|
