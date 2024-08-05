# Aws2-ses

**Since Camel 3.1**

**Only producer is supported**

The AWS2 SES component supports sending emails with [Amazon’s
SES](https://aws.amazon.com/ses) service.

Prerequisites

You must have a valid Amazon Web Services developer account, and be
signed up to use Amazon SES. More information is available at [Amazon
SES](https://aws.amazon.com/ses).

# URI Format

    aws2-ses://from[?options]

You can append query options to the URI in the following format:

`?options=value&option2=value&...`

Required SES component options

You have to provide the amazonSESClient in the Registry or your
accessKey and secretKey to access the [Amazon’s
SES](https://aws.amazon.com/ses).

# Usage

## Static credentials, Default Credential Provider and Profile Credentials Provider

You have the possibility of avoiding the usage of explicit static
credentials by specifying the useDefaultCredentialsProvider option and
set it to true.

The order of evaluation for Default Credentials Provider is the
following:

-   Java system properties - `aws.accessKeyId` and `aws.secretKey`.

-   Environment variables - `AWS_ACCESS_KEY_ID` and
    `AWS_SECRET_ACCESS_KEY`.

-   Web Identity Token from AWS STS.

-   The shared credentials and config files.

-   Amazon ECS container credentials - loaded from the Amazon ECS if the
    environment variable `AWS_CONTAINER_CREDENTIALS_RELATIVE_URI` is
    set.

-   Amazon EC2 Instance profile credentials.

You have also the possibility of using Profile Credentials Provider, by
specifying the useProfileCredentialsProvider option to true and
profileCredentialsName to the profile name.

Only one of static, default and profile credentials could be used at the
same time.

For more information about this you can look at [AWS credentials
documentation](https://docs.aws.amazon.com/sdk-for-java/latest/developer-guide/credentials.html)

## Advanced SesClient configuration

If you need more control over the `SesClient` instance configuration you
can create your own instance and refer to it from the URI:

    from("direct:start")
    .to("aws2-ses://example@example.com?amazonSESClient=#client");

The `#client` refers to a `SesClient` in the Registry.

# Examples

## Producer Examples

    from("direct:start")
        .setHeader(SesConstants.SUBJECT, constant("This is my subject"))
        .setHeader(SesConstants.TO, constant(Collections.singletonList("to@example.com"))
        .setBody(constant("This is my message text."))
        .to("aws2-ses://from@example.com?accessKey=xxx&secretKey=yyy");

# Dependencies

Maven users will need to add the following dependency to their pom.xml.

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-aws2-ses</artifactId>
        <version>${camel-version}</version>
    </dependency>

where `${camel-version}` must be replaced by the actual version of
Camel.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bcc|List of comma-separated destination blind carbon copy (bcc) email address. Can be overridden with 'CamelAwsSesBcc' header.||string|
|cc|List of comma-separated destination carbon copy (cc) email address. Can be overridden with 'CamelAwsSesCc' header.||string|
|configuration|component configuration||object|
|configurationSet|Set the configuration set to send with every request. Override it with 'CamelAwsSesConfigurationSet' header.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|region|The region in which SES client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|replyToAddresses|List of comma separated reply-to email address(es) for the message, override it using 'CamelAwsSesReplyToAddresses' header.||string|
|returnPath|The email address to which bounce notifications are to be forwarded, override it using 'CamelAwsSesReturnPath' header.||string|
|subject|The subject which is used if the message header 'CamelAwsSesSubject' is not present.||string|
|to|List of comma separated destination email address. Can be overridden with 'CamelAwsSesTo' header.||string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|amazonSESClient|To use the AmazonSimpleEmailService as the client||object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|proxyHost|To define a proxy host when instantiating the SES client||string|
|proxyPort|To define a proxy port when instantiating the SES client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the SES client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|profileCredentialsName|If using a profile credentials provider, this parameter will set the profile name||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume an IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useDefaultCredentialsProvider|Set whether the Ses client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the SES client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the SES client should expect to use Session Credentials. This is useful in a situation in which the user needs to assume an IAM role for doing operations in SES.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|from|The sender's email address.||string|
|bcc|List of comma-separated destination blind carbon copy (bcc) email address. Can be overridden with 'CamelAwsSesBcc' header.||string|
|cc|List of comma-separated destination carbon copy (cc) email address. Can be overridden with 'CamelAwsSesCc' header.||string|
|configurationSet|Set the configuration set to send with every request. Override it with 'CamelAwsSesConfigurationSet' header.||string|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|region|The region in which SES client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|replyToAddresses|List of comma separated reply-to email address(es) for the message, override it using 'CamelAwsSesReplyToAddresses' header.||string|
|returnPath|The email address to which bounce notifications are to be forwarded, override it using 'CamelAwsSesReturnPath' header.||string|
|subject|The subject which is used if the message header 'CamelAwsSesSubject' is not present.||string|
|to|List of comma separated destination email address. Can be overridden with 'CamelAwsSesTo' header.||string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|amazonSESClient|To use the AmazonSimpleEmailService as the client||object|
|proxyHost|To define a proxy host when instantiating the SES client||string|
|proxyPort|To define a proxy port when instantiating the SES client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the SES client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|profileCredentialsName|If using a profile credentials provider, this parameter will set the profile name||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume an IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useDefaultCredentialsProvider|Set whether the Ses client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the SES client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the SES client should expect to use Session Credentials. This is useful in a situation in which the user needs to assume an IAM role for doing operations in SES.|false|boolean|
