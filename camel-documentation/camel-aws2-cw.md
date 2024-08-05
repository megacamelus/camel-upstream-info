# Aws2-cw

**Since Camel 3.1**

**Only producer is supported**

The AWS2 Cloudwatch component allows messages to be sent to an [Amazon
CloudWatch](https://aws.amazon.com/cloudwatch/) metrics. The
implementation of the Amazon API is provided by the [AWS
SDK](https://aws.amazon.com/sdkforjava/).

Prerequisites

You must have a valid Amazon Web Services developer account, and be
signed up to use Amazon CloudWatch. More information is available at
[Amazon CloudWatch](https://aws.amazon.com/cloudwatch/).

# URI Format

    aws2-cw://namespace[?options]

The metrics will be created if they don’t already exist.

You can append query options to the URI in the following format:
`?options=value&option2=value&...`

Required CW component options

You have to provide the amazonCwClient in the Registry or your accessKey
and secretKey to access the [Amazon’s
CloudWatch](https://aws.amazon.com/cloudwatch/).

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

## Advanced CloudWatchClient configuration

If you need more control over the `CloudWatchClient` instance
configuration you can create your own instance and refer to it from the
URI:

    from("direct:start")
    .to("aws2-cw://namespace?amazonCwClient=#client");

The `#client` refers to a `CloudWatchClient` in the Registry.

# Dependencies

Maven users will need to add the following dependency to their pom.xml.

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-aws2-cw</artifactId>
        <version>${camel-version}</version>
    </dependency>

where `${camel-version`} must be replaced by the actual version of
Camel.

# Examples

## Producer Example

    from("direct:start")
      .to("aws2-cw://http://camel.apache.org/aws-cw");

and sends something like

    exchange.getIn().setHeader(Cw2Constants.METRIC_NAME, "ExchangesCompleted");
    exchange.getIn().setHeader(Cw2Constants.METRIC_VALUE, "2.0");
    exchange.getIn().setHeader(Cw2Constants.METRIC_UNIT, "Count");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configuration|The component configuration||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|name|The metric name||string|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|region|The region in which CW client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|timestamp|The metric timestamp||object|
|unit|The metric unit||string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|value|The metric value||number|
|amazonCwClient|To use the AmazonCloudWatch as the client||object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|proxyHost|To define a proxy host when instantiating the CW client||string|
|proxyPort|To define a proxy port when instantiating the CW client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the CW client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|profileCredentialsName|If using a profile credentials provider, this parameter will set the profile name||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume an IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useDefaultCredentialsProvider|Set whether the S3 client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the Cloudwatch client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the CloudWatch client should expect to use Session Credentials. This is useful in a situation in which the user needs to assume an IAM role for doing operations in CloudWatch.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|namespace|The metric namespace||string|
|name|The metric name||string|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|region|The region in which CW client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|timestamp|The metric timestamp||object|
|unit|The metric unit||string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|value|The metric value||number|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|amazonCwClient|To use the AmazonCloudWatch as the client||object|
|proxyHost|To define a proxy host when instantiating the CW client||string|
|proxyPort|To define a proxy port when instantiating the CW client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the CW client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|profileCredentialsName|If using a profile credentials provider, this parameter will set the profile name||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume an IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useDefaultCredentialsProvider|Set whether the S3 client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the Cloudwatch client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the CloudWatch client should expect to use Session Credentials. This is useful in a situation in which the user needs to assume an IAM role for doing operations in CloudWatch.|false|boolean|
