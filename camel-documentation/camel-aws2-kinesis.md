# Aws2-kinesis

**Since Camel 3.2**

**Both producer and consumer are supported**

The AWS2 Kinesis component supports consuming messages from and
producing messages to Amazon Kinesis service.

The AWS2 Kinesis component also supports Synchronous and Asynchronous
Client, which means you choose what fits best your requirements, so if
you need the connection (client) to be async, there’s a property of
*asyncClient* (in DSL also can be found) needs to be turned true.

Prerequisites

You must have a valid Amazon Web Services developer account, and be
signed up to use Amazon Kinesis. More information is available at [AWS
Kinesis](https://aws.amazon.com/kinesis/)

# URI Format

    aws2-kinesis://stream-name[?options]

The stream needs to be created prior to it being used.

You can append query options to the URI in the following format:

`?options=value&option2=value&...`

Required Kinesis component options

You have to provide the KinesisClient in the Registry with proxies and
relevant credentials configured.

# Batch Consumer

This component implements the Batch Consumer.

This allows you, for instance, to know how many messages exist in this
batch and for instance, let the Aggregator aggregate this number of
messages.

The consumer is able to consume either from a single specific shard or
all available shards (multiple shards consumption) of Amazon Kinesis,
therefore, if you leave the *shardId* property in the DSL configuration
empty, then it’ll consume all available shards otherwise only the
specified shard corresponding to the shardId will be consumed.

# Batch Producer

This component implements the Batch Producer.

This allows you to send multiple messages in a single request to Amazon
Kinesis. Messages with batch size more than 500 is allowed. Producer
will split them into multiple requests.

The batch type needs to implement the `Iterable` interface. For example,
it can be a `List`, `Set` or any other collection type. The message type
can be one or more of types `byte[]`, `ByteBuffer`, UTF-8 `String`, or
`InputStream`. Other types are not supported.

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

## AmazonKinesis configuration

You then have to reference the KinesisClient in the
`amazonKinesisClient` URI option.

    from("aws2-kinesis://mykinesisstream?amazonKinesisClient=#kinesisClient")
      .to("log:out?showAll=true");

## Providing AWS Credentials

It is recommended that the credentials are obtained by using the
[DefaultAWSCredentialsProviderChain](http://docs.aws.amazon.com/AWSJavaSDK/latest/javadoc/com/amazonaws/auth/DefaultAWSCredentialsProviderChain.html)
that is the default when creating a new ClientConfiguration instance,
however, a different
[AWSCredentialsProvider](http://docs.aws.amazon.com/AWSJavaSDK/latest/javadoc/com/amazonaws/auth/AWSCredentialsProvider.html)
can be specified when calling createClient(…).

## AWS Kinesis KCL Consumer

The component supports also the KCL (Kinesis Client Library) for
consuming from a Kinesis Data Stream.

To enable this feature you’ll need to set two different parameter in
your endpoint:

    from("aws2-kinesis://mykinesisstream?asyncClient=true&useDefaultCredentialsProvider=true&useKclConsumers=true")
      .to("log:out?showAll=true");

This feature will make possible to automatically checkpointing the Shard
Iterations by combining the usage of KCL, DynamoDB Table and CloudWatch
alarms.

Everything will work out of the box, by simply using your AWS
Credentials.

In the beginning the consumer will require 60/70 seconds for preparing
everything, listing the shards, creating/querying the Lease table on
Dynamo DB. Keep it in mind while working with the KCL consumer.

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
|region|The region in which Kinesis Firehose client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|iteratorType|Defines where in the Kinesis stream to start getting records|TRIM\_HORIZON|object|
|maxResultsPerRequest|Maximum number of records that will be fetched in each poll|1|integer|
|sequenceNumber|The sequence number to start polling from. Required if iteratorType is set to AFTER\_SEQUENCE\_NUMBER or AT\_SEQUENCE\_NUMBER||string|
|shardClosed|Define what will be the behavior in case of shard closed. Possible value are ignore, silent and fail. In case of ignore a message will be logged and the consumer will restart from the beginning,in case of silent there will be no logging and the consumer will start from the beginning,in case of fail a ReachedClosedStateException will be raised|ignore|object|
|shardId|Defines which shardId in the Kinesis stream to get records from||string|
|shardMonitorInterval|The interval in milliseconds to wait between shard polling|10000|integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|amazonKinesisClient|Amazon Kinesis client to use for all requests for this endpoint||object|
|asyncClient|If we want to a KinesisAsyncClient instance set it to true|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|cloudWatchAsyncClient|If we want to a KCL Consumer, we can pass an instance of CloudWatchAsyncClient||object|
|dynamoDbAsyncClient|If we want to a KCL Consumer, we can pass an instance of DynamoDbAsyncClient||object|
|useKclConsumers|If we want to a KCL Consumer set it to true|false|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|proxyHost|To define a proxy host when instantiating the Kinesis client||string|
|proxyPort|To define a proxy port when instantiating the Kinesis client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the Kinesis client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|profileCredentialsName|If using a profile credentials provider this parameter will set the profile name.||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume a IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useDefaultCredentialsProvider|Set whether the Kinesis client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the Kinesis client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the Kinesis client should expect to use Session Credentials. This is useful in situation in which the user needs to assume a IAM role for doing operations in Kinesis.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|streamName|Name of the stream||string|
|cborEnabled|This option will set the CBOR\_ENABLED property during the execution|true|boolean|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with uriEndpointOverride option|false|boolean|
|region|The region in which Kinesis Firehose client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|iteratorType|Defines where in the Kinesis stream to start getting records|TRIM\_HORIZON|object|
|maxResultsPerRequest|Maximum number of records that will be fetched in each poll|1|integer|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|sequenceNumber|The sequence number to start polling from. Required if iteratorType is set to AFTER\_SEQUENCE\_NUMBER or AT\_SEQUENCE\_NUMBER||string|
|shardClosed|Define what will be the behavior in case of shard closed. Possible value are ignore, silent and fail. In case of ignore a message will be logged and the consumer will restart from the beginning,in case of silent there will be no logging and the consumer will start from the beginning,in case of fail a ReachedClosedStateException will be raised|ignore|object|
|shardId|Defines which shardId in the Kinesis stream to get records from||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|shardMonitorInterval|The interval in milliseconds to wait between shard polling|10000|integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|amazonKinesisClient|Amazon Kinesis client to use for all requests for this endpoint||object|
|asyncClient|If we want to a KinesisAsyncClient instance set it to true|false|boolean|
|cloudWatchAsyncClient|If we want to a KCL Consumer, we can pass an instance of CloudWatchAsyncClient||object|
|dynamoDbAsyncClient|If we want to a KCL Consumer, we can pass an instance of DynamoDbAsyncClient||object|
|useKclConsumers|If we want to a KCL Consumer set it to true|false|boolean|
|proxyHost|To define a proxy host when instantiating the Kinesis client||string|
|proxyPort|To define a proxy port when instantiating the Kinesis client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the Kinesis client|HTTPS|object|
|backoffErrorThreshold|The number of subsequent error polls (failed due some error) that should happen before the backoffMultipler should kick-in.||integer|
|backoffIdleThreshold|The number of subsequent idle polls that should happen before the backoffMultipler should kick-in.||integer|
|backoffMultiplier|To let the scheduled polling consumer backoff if there has been a number of subsequent idles/errors in a row. The multiplier is then the number of polls that will be skipped before the next actual attempt is happening again. When this option is in use then backoffIdleThreshold and/or backoffErrorThreshold must also be configured.||integer|
|delay|Milliseconds before the next poll.|500|integer|
|greedy|If greedy is enabled, then the ScheduledPollConsumer will run immediately again, if the previous run polled 1 or more messages.|false|boolean|
|initialDelay|Milliseconds before the first poll starts.|1000|integer|
|repeatCount|Specifies a maximum limit of number of fires. So if you set it to 1, the scheduler will only fire once. If you set it to 5, it will only fire five times. A value of zero or negative means fire forever.|0|integer|
|runLoggingLevel|The consumer logs a start/complete log line when it polls. This option allows you to configure the logging level for that.|TRACE|object|
|scheduledExecutorService|Allows for configuring a custom/shared thread pool to use for the consumer. By default each consumer has its own single threaded thread pool.||object|
|scheduler|To use a cron scheduler from either camel-spring or camel-quartz component. Use value spring or quartz for built in scheduler|none|object|
|schedulerProperties|To configure additional properties when using a custom scheduler or any of the Quartz, Spring based scheduler.||object|
|startScheduler|Whether the scheduler should be auto started.|true|boolean|
|timeUnit|Time unit for initialDelay and delay options.|MILLISECONDS|object|
|useFixedDelay|Controls if fixed delay or fixed rate is used. See ScheduledExecutorService in JDK for details.|true|boolean|
|accessKey|Amazon AWS Access Key||string|
|profileCredentialsName|If using a profile credentials provider this parameter will set the profile name.||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume a IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useDefaultCredentialsProvider|Set whether the Kinesis client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the Kinesis client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the Kinesis client should expect to use Session Credentials. This is useful in situation in which the user needs to assume a IAM role for doing operations in Kinesis.|false|boolean|
