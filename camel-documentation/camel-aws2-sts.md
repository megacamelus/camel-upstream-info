# Aws2-sts

**Since Camel 3.5**

**Only producer is supported**

The AWS2 STS component supports assumeRole operation. [AWS
STS](https://aws.amazon.com/sts/).

Prerequisites

You must have a valid Amazon Web Services developer account, and be
signed up to use Amazon STS. More information is available at [Amazon
STS](https://aws.amazon.com/sts/).

The AWS2 STS component works on the aws-global region, and it has
aws-global as the default region.

# URI Format

    aws2-sts://label[?options]

You can append query options to the URI in the following format:

`?options=value&option2=value&...`

Required STS component options

You have to provide the amazonSTSClient in the Registry or your
accessKey and secretKey to access the [Amazon
STS](https://aws.amazon.com/sts/) service.

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

## STS Producer operations

Camel-AWS STS component provides the following operation on the producer
side:

-   assumeRole

-   getSessionToken

-   getFederationToken

# Producer Examples

-   assumeRole: this operation will make an AWS user assume a different
    role temporary

<!-- -->

    from("direct:assumeRole")
        .setHeader(STS2Constants.ROLE_ARN, constant("arn:123"))
        .setHeader(STS2Constants.ROLE_SESSION_NAME, constant("groot"))
        .to("aws2-sts://test?stsClient=#amazonSTSClient&operation=assumeRole")

-   getSessionToken: this operation will return a temporary session
    token

<!-- -->

    from("direct:getSessionToken")
        .to("aws2-sts://test?stsClient=#amazonSTSClient&operation=getSessionToken")

-   getFederationToken: this operation will return a temporary
    federation token

<!-- -->

    from("direct:getFederationToken")
        .setHeader(STS2Constants.FEDERATED_NAME, constant("federation-account"))
        .to("aws2-sts://test?stsClient=#amazonSTSClient&operation=getSessionToken")

# Using a POJO as body

Sometimes building an AWS Request can be complex because of multiple
options. We introduce the possibility to use a POJO as the body. In AWS
STS, as an example for Assume Role request, you can do something like:

    from("direct:createUser")
         .setBody(AssumeRoleRequest.builder().roleArn("arn:123").roleSessionName("groot").build())
        .to("aws2-sts://test?stsClient=#amazonSTSClient&operation=assumeRole&pojoRequest=true")

In this way, you’ll pass the request directly without the need of
passing headers and options specifically related to this operation.

# Dependencies

Maven users will need to add the following dependency to their pom.xml.

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-aws2-sts</artifactId>
        <version>${camel-version}</version>
    </dependency>

where `${camel-version}` must be replaced by the actual version of
Camel.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configuration|Component configuration||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|operation|The operation to perform|assumeRole|object|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|pojoRequest|If we want to use a POJO request as body or not|false|boolean|
|region|The region in which the STS client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()|aws-global|string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|stsClient|To use an existing configured AWS STS client||object|
|proxyHost|To define a proxy host when instantiating the STS client||string|
|proxyPort|To define a proxy port when instantiating the STS client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the STS client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|profileCredentialsName|If using a profile credentials provider, this parameter will set the profile name||string|
|secretKey|Amazon AWS Secret Key||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useDefaultCredentialsProvider|Set whether the STS client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the STS client should expect to load credentials through a profile credentials provider.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|label|Logical name||string|
|operation|The operation to perform|assumeRole|object|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|pojoRequest|If we want to use a POJO request as body or not|false|boolean|
|region|The region in which the STS client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()|aws-global|string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|stsClient|To use an existing configured AWS STS client||object|
|proxyHost|To define a proxy host when instantiating the STS client||string|
|proxyPort|To define a proxy port when instantiating the STS client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the STS client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|profileCredentialsName|If using a profile credentials provider, this parameter will set the profile name||string|
|secretKey|Amazon AWS Secret Key||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useDefaultCredentialsProvider|Set whether the STS client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the STS client should expect to load credentials through a profile credentials provider.|false|boolean|
