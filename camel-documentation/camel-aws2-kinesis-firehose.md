# Aws2-kinesis-firehose

**Since Camel 3.2**

**Only producer is supported**

The AWS2 Kinesis Firehose component supports sending messages to Amazon
Kinesis Firehose service (Batch not supported).

Prerequisites

You must have a valid Amazon Web Services developer account, and be
signed up to use Amazon Kinesis Firehose. More information is available
at [AWS Kinesis Firehose](https://aws.amazon.com/kinesis/firehose/)

# URI Format

    aws2-kinesis-firehose://delivery-stream-name[?options]

The stream needs to be created prior to it being used.

You can append query options to the URI in the following format:

`?options=value&option2=value&...`

# URI Options

Required Kinesis Firehose component options

You have to provide the FirehoseClient in the Registry with proxies and
relevant credentials configured.

# Usage

## Static credentials, Default Credential Provider and Profile Credentials Provider

You have the possibility of avoiding the usage of explicit static
credentials by specifying the useDefaultCredentialsProvider option and
set it to true.

The order of evaluation for Default Credentials Provider is the
following:

-   Java system properties - `aws.accessKeyId` and `aws.secretKey`

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

## Amazon Kinesis Firehose configuration

You then have to reference the FirehoseClient in the
`amazonKinesisFirehoseClient` URI option.

    from("aws2-kinesis-firehose://mykinesisdeliverystream?amazonKinesisFirehoseClient=#kinesisClient")
      .to("log:out?showAll=true");

## Providing AWS Credentials

It is recommended that the credentials are obtained by using the
[DefaultAWSCredentialsProviderChain](http://docs.aws.amazon.com/AWSJavaSDK/latest/javadoc/com/amazonaws/auth/DefaultAWSCredentialsProviderChain.html)
that is the default when creating a new ClientConfiguration instance,
however, a different
[AWSCredentialsProvider](http://docs.aws.amazon.com/AWSJavaSDK/latest/javadoc/com/amazonaws/auth/AWSCredentialsProvider.html)
can be specified when calling createClient(…).

## Kinesis Firehose Producer operations

Camel-AWS s3 component provides the following operation on the producer
side:

-   SendBatchRecord

-   CreateDeliveryStream

-   DeleteDeliveryStream

-   DescribeDeliveryStream

-   UpdateDestination

## Send Batch Records Example

You can send an iterable of Kinesis Record (as the following example
shows), or you can send directly a PutRecordBatchRequest POJO instance
in the body.

        @Test
        public void testFirehoseBatchRouting() throws Exception {
            Exchange exchange = template.send("direct:start", ExchangePattern.InOnly, new Processor() {
                public void process(Exchange exchange) throws Exception {
                    List<Record> recs = new ArrayList<Record>();
                    Record rec = Record.builder().data(SdkBytes.fromString("Test1", Charset.defaultCharset())).build();
                    Record rec1 = Record.builder().data(SdkBytes.fromString("Test2", Charset.defaultCharset())).build();
                    recs.add(rec);
                    recs.add(rec1);
                    exchange.getIn().setBody(recs);
                }
            });
            assertNotNull(exchange.getIn().getBody());
        }
    
    from("direct:start").to("aws2-kinesis-firehose://cc?amazonKinesisFirehoseClient=#FirehoseClient&operation=sendBatchRecord");

In the deliveryStream you’ll find "Test1Test2".

# Dependencies

Maven users will need to add the following dependency to their pom.xml.

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-aws2-kinesis</artifactId>
        <version>${camel-version}</version>
    </dependency>

where `${camel-version}` must be replaced by the actual version of
Camel.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|cborEnabled|This option will set the CBOR\_ENABLED property during the execution|true|boolean|
|configuration|Component configuration||object|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with uriEndpointOverride option|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|operation|The operation to do in case the user don't want to send only a record||object|
|region|The region in which Kinesis Firehose client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|useDefaultCredentialsProvider|Set whether the Kinesis Firehose client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|amazonKinesisFirehoseClient|Amazon Kinesis Firehose client to use for all requests for this endpoint||object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|proxyHost|To define a proxy host when instantiating the Kinesis Firehose client||string|
|proxyPort|To define a proxy port when instantiating the Kinesis Firehose client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the Kinesis Firehose client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|profileCredentialsName|If using a profile credentials provider this parameter will set the profile name.||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume a IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useProfileCredentialsProvider|Set whether the Kinesis Firehose client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the Kinesis Firehose client should expect to use Session Credentials. This is useful in situation in which the user needs to assume a IAM role for doing operations in Kinesis Firehose.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|streamName|Name of the stream||string|
|cborEnabled|This option will set the CBOR\_ENABLED property during the execution|true|boolean|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with uriEndpointOverride option|false|boolean|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|operation|The operation to do in case the user don't want to send only a record||object|
|region|The region in which Kinesis Firehose client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|useDefaultCredentialsProvider|Set whether the Kinesis Firehose client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|amazonKinesisFirehoseClient|Amazon Kinesis Firehose client to use for all requests for this endpoint||object|
|proxyHost|To define a proxy host when instantiating the Kinesis Firehose client||string|
|proxyPort|To define a proxy port when instantiating the Kinesis Firehose client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the Kinesis Firehose client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|profileCredentialsName|If using a profile credentials provider this parameter will set the profile name.||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume a IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useProfileCredentialsProvider|Set whether the Kinesis Firehose client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the Kinesis Firehose client should expect to use Session Credentials. This is useful in situation in which the user needs to assume a IAM role for doing operations in Kinesis Firehose.|false|boolean|
