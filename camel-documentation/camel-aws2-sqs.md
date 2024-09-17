# Aws2-sqs

**Since Camel 3.1**

**Both producer and consumer are supported**

The AWS2 SQS component supports sending and receiving messages to
[Amazon’s SQS](https://aws.amazon.com/sqs) service.

Prerequisites

You must have a valid Amazon Web Services developer account, and be
signed up to use Amazon SQS. More information is available at [Amazon
SQS](https://aws.amazon.com/sqs).

# URI Format

    aws2-sqs://queueNameOrArn[?options]

The queue will be created if they don’t already exist.

You can append query options to the URI in the following format:

`?options=value&option2=value&...`

Required SQS component options

You have to provide the amazonSQSClient in the Registry or your
accessKey and secretKey to access the [Amazon’s
SQS](https://aws.amazon.com/sqs).

# Usage

## Batch Consumer

This component implements the Batch Consumer.

This allows you, for instance, to know how many messages exist in this
batch and for instance, let the Aggregator aggregate this number of
messages.

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

# Examples

## Advanced AmazonSQS configuration

If your Camel Application is running behind a firewall or if you need to
have more control over the SqsClient instance configuration, you can
create your own instance, and configure Camel to use your instance by
the bean id.

In the example below, we use *myClient* as the bean id:

    // crate my own instance of SqsClient
    SqsClient sqs = ...
    
    // register the client into Camel registry
    camelContext.getRegistry().bind("myClient", sqs);
    
    // refer to the custom client via myClient as the bean id
    from("aws2-sqs://MyQueue?amazonSQSClient=#m4yClient&delay=5000&maxMessagesPerPoll=5")
    .to("mock:result");

## DelayQueue VS Delay for Single message

When the option delayQueue is set to true, the SQS Queue will be a
DelayQueue with the DelaySeconds option as delay. For more information
about DelayQueue you can read the [AWS SQS
documentation](https://docs.aws.amazon.com/en_us/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-delay-queues.html).
One important information to take into account is the following:

-   For standard queues, the per-queue delay setting is not
    retroactively—changing the setting doesn’t affect the delay of
    messages already in the queue.

-   For FIFO queues, the per-queue delay setting is
    retroactively—changing the setting affects the delay of messages
    already in the queue.

as stated in the official documentation. If you want to specify a delay
on single messages, you can ignore the delayQueue option, while you can
set this option to true if you need to add a fixed delay to all messages
enqueued.

## Server Side Encryption

There is a set of Server Side Encryption attributes for a queue. The
related option are: `serverSideEncryptionEnabled`, `keyMasterKeyId` and
`kmsDataKeyReusePeriod`. The SSE is disabled by default. You need to
explicitly set the option to true and set the related parameters as
queue attributes.

## JMS-style Selectors

SQS does not allow selectors, but you can effectively achieve this by
using the Camel Filter EIP and setting an appropriate
`visibilityTimeout`. When SQS dispatches a message, it will wait up to
the visibility timeout before it tries to dispatch the message to a
different consumer unless a DeleteMessage is received. By default, Camel
will always send the DeleteMessage at the end of the route, unless the
route ended in failure. To achieve appropriate filtering and not send
the DeleteMessage even on successful completion of the route, use a
Filter:

    from("aws2-sqs://MyQueue?amazonSQSClient=#client&defaultVisibilityTimeout=5000&deleteIfFiltered=false&deleteAfterRead=false")
    .filter("${header.login} == true")
      .setProperty(Sqs2Constants.SQS_DELETE_FILTERED, constant(true))
      .to("mock:filter");

In the above code, if an exchange doesn’t have an appropriate header, it
will not make it through the filter AND also not be deleted from the SQS
queue. After 5000 milliseconds, the message will become visible to other
consumers.

Note we must set the property `Sqs2Constants.SQS_DELETE_FILTERED` to
`true` to instruct Camel to send the DeleteMessage, if being filtered.

## Available Producer Operations

-   single message (default)

-   sendBatchMessage

-   deleteMessage

-   listQueues

## Send Message

    from("direct:start")
      .setBody(constant("Camel rocks!"))
      .to("aws2-sqs://camel-1?accessKey=RAW(xxx)&secretKey=RAW(xxx)&region=eu-west-1");

## Send Batch Message

You can set a `SendMessageBatchRequest` or an `Iterable`

    from("direct:start")
      .setHeader(SqsConstants.SQS_OPERATION, constant("sendBatchMessage"))
      .process(new Processor() {
          @Override
          public void process(Exchange exchange) throws Exception {
              List c = new ArrayList();
              c.add("team1");
              c.add("team2");
              c.add("team3");
              c.add("team4");
              exchange.getIn().setBody(c);
          }
      })
      .to("aws2-sqs://camel-1?accessKey=RAW(xxx)&secretKey=RAW(xxx)&region=eu-west-1");

As result, you’ll get an exchange containing a
`SendMessageBatchResponse` instance, that you can examine to check what
messages were successful and what not. The id set on each message of the
batch will be a Random UUID.

## Delete single Message

Use deleteMessage operation to delete a single message. You’ll need to
set a receipt handle header for the message you want to delete.

    from("direct:start")
      .setHeader(SqsConstants.SQS_OPERATION, constant("deleteMessage"))
      .setHeader(SqsConstants.RECEIPT_HANDLE, constant("123456"))
      .to("aws2-sqs://camel-1?accessKey=RAW(xxx)&secretKey=RAW(xxx)&region=eu-west-1");

As result, you’ll get an exchange containing a `DeleteMessageResponse`
instance, that you can use to check if the message was deleted or not.

## List Queues

Use listQueues operation to list queues.

    from("direct:start")
      .setHeader(SqsConstants.SQS_OPERATION, constant("listQueues"))
      .to("aws2-sqs://camel-1?accessKey=RAW(xxx)&secretKey=RAW(xxx)&region=eu-west-1");

As result, you’ll get an exchange containing a `ListQueuesResponse`
instance, that you can examine to check the actual queues.

## Purge Queue

Use purgeQueue operation to purge queue.

    from("direct:start")
      .setHeader(SqsConstants.SQS_OPERATION, constant("purgeQueue"))
      .to("aws2-sqs://camel-1?accessKey=RAW(xxx)&secretKey=RAW(xxx)&region=eu-west-1");

As result you’ll get an exchange containing a `PurgeQueueResponse`
instance.

## Queue Auto-creation

With the option `autoCreateQueue` users are able to avoid the
autocreation of an SQS Queue in case it doesn’t exist. The default for
this option is `false`. If set to *false*, any operation on a
non-existent queue in AWS won’t be successful and an error will be
returned.

## Send Batch Message and Message Deduplication Strategy

In case you’re using a SendBatchMessage Operation, you can set two
different kinds of Message Deduplication Strategy: - useExchangeId -
useContentBasedDeduplication

The first one will use a ExchangeIdMessageDeduplicationIdStrategy, that
will use the Exchange ID as parameter The other one will use a
NullMessageDeduplicationIdStrategy, that will use the body as a
deduplication element.

In case of send batch message operation, you’ll need to use the
`useContentBasedDeduplication` and on the Queue you’re pointing you’ll
need to enable the `content based deduplication` option.

# Dependencies

Maven users will need to add the following dependency to their pom.xml.

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-aws2-sqs</artifactId>
        <version>${camel-version}</version>
    </dependency>

where `${camel-version}` must be replaced by the actual version of
Camel.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|amazonAWSHost|The hostname of the Amazon AWS cloud.|amazonaws.com|string|
|autoCreateQueue|Setting the auto-creation of the queue|false|boolean|
|configuration|The AWS SQS default configuration||object|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|protocol|The underlying protocol used to communicate with SQS|https|string|
|queueOwnerAWSAccountId|Specify the queue owner aws account id when you need to connect the queue with a different account owner.||string|
|region|The region in which SQS client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|attributeNames|A list of attribute names to receive when consuming. Multiple names can be separated by comma.||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|concurrentConsumers|Allows you to use multiple threads to poll the sqs queue to increase throughput|1|integer|
|concurrentRequestLimit|The maximum number of concurrent receive request send to AWS in single consumer polling.|50|integer|
|defaultVisibilityTimeout|The default visibility timeout (in seconds)||integer|
|deleteAfterRead|Delete message from SQS after it has been read|true|boolean|
|deleteIfFiltered|Whether to send the DeleteMessage to the SQS queue if the exchange has property with key Sqs2Constants#SQS\_DELETE\_FILTERED (CamelAwsSqsDeleteFiltered) set to true.|true|boolean|
|extendMessageVisibility|If enabled, then a scheduled background task will keep extending the message visibility on SQS. This is needed if it takes a long time to process the message. If set to true defaultVisibilityTimeout must be set. See details at Amazon docs.|false|boolean|
|kmsDataKeyReusePeriodSeconds|The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again. An integer representing seconds, between 60 seconds (1 minute) and 86,400 seconds (24 hours). Default: 300 (5 minutes).||integer|
|kmsMasterKeyId|The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK.||string|
|messageAttributeNames|A list of message attribute names to receive when consuming. Multiple names can be separated by comma.||string|
|serverSideEncryptionEnabled|Define if Server Side Encryption is enabled or not on the queue|false|boolean|
|sortAttributeName|The name of the message attribute used for sorting the messages. When specified, the messages polled by the consumer will be sorted by this attribute. This configuration may be of importance when you configure maxMessagesPerPoll parameter exceeding 10. In such cases, the messages will be fetched concurrently so the ordering is not guaranteed.||string|
|visibilityTimeout|The duration (in seconds) that the received messages are hidden from subsequent retrieve requests after being retrieved by a ReceiveMessage request to set in the com.amazonaws.services.sqs.model.SetQueueAttributesRequest. This only makes sense if it's different from defaultVisibilityTimeout. It changes the queue visibility timeout attribute permanently.||integer|
|waitTimeSeconds|Duration in seconds (0 to 20) that the ReceiveMessage action call will wait until a message is in the queue to include in the response.||integer|
|batchSeparator|Set the separator when passing a String to send batch message operation|,|string|
|delaySeconds|Delay sending messages for a number of seconds.||integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|messageDeduplicationIdStrategy|Only for FIFO queues. Strategy for setting the messageDeduplicationId on the message. It can be one of the following options: useExchangeId, useContentBasedDeduplication. For the useContentBasedDeduplication option, no messageDeduplicationId will be set on the message.|useExchangeId|string|
|messageGroupIdStrategy|Only for FIFO queues. Strategy for setting the messageGroupId on the message. It can be one of the following options: useConstant, useExchangeId, usePropertyValue. For the usePropertyValue option, the value of property CamelAwsMessageGroupId will be used.||string|
|messageHeaderExceededLimit|What to do if sending to AWS SQS has more messages than AWS allows (currently only maximum 10 message headers are allowed). WARN will log a WARN about the limit is for each additional header, so the message can be sent to AWS. WARN\_ONCE will only log one time a WARN about the limit is hit, and drop additional headers, so the message can be sent to AWS. IGNORE will ignore (no logging) and drop additional headers, so the message can be sent to AWS. FAIL will cause an exception to be thrown and the message is not sent to AWS.|WARN|string|
|operation|The operation to do in case the user don't want to send only a message||object|
|amazonSQSClient|To use the AmazonSQS client||object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|delayQueue|Define if you want to apply delaySeconds option to the queue or on single messages|false|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|proxyHost|To define a proxy host when instantiating the SQS client||string|
|proxyPort|To define a proxy port when instantiating the SQS client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the SQS client|HTTPS|object|
|maximumMessageSize|The maximumMessageSize (in bytes) an SQS message can contain for this queue.||integer|
|messageRetentionPeriod|The messageRetentionPeriod (in seconds) a message will be retained by SQS for this queue.||integer|
|policy|The policy for this queue. It can be loaded by default from classpath, but you can prefix with classpath:, file:, or http: to load the resource from different systems.||string|
|queueUrl|To define the queueUrl explicitly. All other parameters, which would influence the queueUrl, are ignored. This parameter is intended to be used to connect to a mock implementation of SQS, for testing purposes.||string|
|receiveMessageWaitTimeSeconds|If you do not specify WaitTimeSeconds in the request, the queue attribute ReceiveMessageWaitTimeSeconds is used to determine how long to wait.||integer|
|redrivePolicy|Specify the policy that send message to DeadLetter queue. See detail at Amazon docs.||string|
|accessKey|Amazon AWS Access Key||string|
|profileCredentialsName|If using a profile credentials provider, this parameter will set the profile name||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume an IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useDefaultCredentialsProvider|Set whether the SQS client should expect to load credentials on an AWS infra instance or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the SQS client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the SQS client should expect to use Session Credentials. This is useful in a situation in which the user needs to assume an IAM role for doing operations in SQS.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|queueNameOrArn|Queue name or ARN||string|
|amazonAWSHost|The hostname of the Amazon AWS cloud.|amazonaws.com|string|
|autoCreateQueue|Setting the auto-creation of the queue|false|boolean|
|headerFilterStrategy|To use a custom HeaderFilterStrategy to map headers to/from Camel.||object|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|protocol|The underlying protocol used to communicate with SQS|https|string|
|queueOwnerAWSAccountId|Specify the queue owner aws account id when you need to connect the queue with a different account owner.||string|
|region|The region in which SQS client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|attributeNames|A list of attribute names to receive when consuming. Multiple names can be separated by comma.||string|
|concurrentConsumers|Allows you to use multiple threads to poll the sqs queue to increase throughput|1|integer|
|concurrentRequestLimit|The maximum number of concurrent receive request send to AWS in single consumer polling.|50|integer|
|defaultVisibilityTimeout|The default visibility timeout (in seconds)||integer|
|deleteAfterRead|Delete message from SQS after it has been read|true|boolean|
|deleteIfFiltered|Whether to send the DeleteMessage to the SQS queue if the exchange has property with key Sqs2Constants#SQS\_DELETE\_FILTERED (CamelAwsSqsDeleteFiltered) set to true.|true|boolean|
|extendMessageVisibility|If enabled, then a scheduled background task will keep extending the message visibility on SQS. This is needed if it takes a long time to process the message. If set to true defaultVisibilityTimeout must be set. See details at Amazon docs.|false|boolean|
|kmsDataKeyReusePeriodSeconds|The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again. An integer representing seconds, between 60 seconds (1 minute) and 86,400 seconds (24 hours). Default: 300 (5 minutes).||integer|
|kmsMasterKeyId|The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK.||string|
|maxMessagesPerPoll|Gets the maximum number of messages as a limit to poll at each polling. Is default unlimited, but use 0 or negative number to disable it as unlimited.||integer|
|messageAttributeNames|A list of message attribute names to receive when consuming. Multiple names can be separated by comma.||string|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|serverSideEncryptionEnabled|Define if Server Side Encryption is enabled or not on the queue|false|boolean|
|sortAttributeName|The name of the message attribute used for sorting the messages. When specified, the messages polled by the consumer will be sorted by this attribute. This configuration may be of importance when you configure maxMessagesPerPoll parameter exceeding 10. In such cases, the messages will be fetched concurrently so the ordering is not guaranteed.||string|
|visibilityTimeout|The duration (in seconds) that the received messages are hidden from subsequent retrieve requests after being retrieved by a ReceiveMessage request to set in the com.amazonaws.services.sqs.model.SetQueueAttributesRequest. This only makes sense if it's different from defaultVisibilityTimeout. It changes the queue visibility timeout attribute permanently.||integer|
|waitTimeSeconds|Duration in seconds (0 to 20) that the ReceiveMessage action call will wait until a message is in the queue to include in the response.||integer|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|batchSeparator|Set the separator when passing a String to send batch message operation|,|string|
|delaySeconds|Delay sending messages for a number of seconds.||integer|
|messageDeduplicationIdStrategy|Only for FIFO queues. Strategy for setting the messageDeduplicationId on the message. It can be one of the following options: useExchangeId, useContentBasedDeduplication. For the useContentBasedDeduplication option, no messageDeduplicationId will be set on the message.|useExchangeId|string|
|messageGroupIdStrategy|Only for FIFO queues. Strategy for setting the messageGroupId on the message. It can be one of the following options: useConstant, useExchangeId, usePropertyValue. For the usePropertyValue option, the value of property CamelAwsMessageGroupId will be used.||string|
|messageHeaderExceededLimit|What to do if sending to AWS SQS has more messages than AWS allows (currently only maximum 10 message headers are allowed). WARN will log a WARN about the limit is for each additional header, so the message can be sent to AWS. WARN\_ONCE will only log one time a WARN about the limit is hit, and drop additional headers, so the message can be sent to AWS. IGNORE will ignore (no logging) and drop additional headers, so the message can be sent to AWS. FAIL will cause an exception to be thrown and the message is not sent to AWS.|WARN|string|
|operation|The operation to do in case the user don't want to send only a message||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|amazonSQSClient|To use the AmazonSQS client||object|
|delayQueue|Define if you want to apply delaySeconds option to the queue or on single messages|false|boolean|
|proxyHost|To define a proxy host when instantiating the SQS client||string|
|proxyPort|To define a proxy port when instantiating the SQS client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the SQS client|HTTPS|object|
|maximumMessageSize|The maximumMessageSize (in bytes) an SQS message can contain for this queue.||integer|
|messageRetentionPeriod|The messageRetentionPeriod (in seconds) a message will be retained by SQS for this queue.||integer|
|policy|The policy for this queue. It can be loaded by default from classpath, but you can prefix with classpath:, file:, or http: to load the resource from different systems.||string|
|queueUrl|To define the queueUrl explicitly. All other parameters, which would influence the queueUrl, are ignored. This parameter is intended to be used to connect to a mock implementation of SQS, for testing purposes.||string|
|receiveMessageWaitTimeSeconds|If you do not specify WaitTimeSeconds in the request, the queue attribute ReceiveMessageWaitTimeSeconds is used to determine how long to wait.||integer|
|redrivePolicy|Specify the policy that send message to DeadLetter queue. See detail at Amazon docs.||string|
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
|profileCredentialsName|If using a profile credentials provider, this parameter will set the profile name||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume an IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useDefaultCredentialsProvider|Set whether the SQS client should expect to load credentials on an AWS infra instance or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the SQS client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the SQS client should expect to use Session Credentials. This is useful in a situation in which the user needs to assume an IAM role for doing operations in SQS.|false|boolean|
