# Aws-cloudtrail

**Since Camel 3.19**

**Only consumer is supported**

The AWS Cloudtrail component supports receiving events from Amazon
Cloudtrail service.

Prerequisites

You must have a valid Amazon Web Services developer account, and be
signed up to use Amazon Cloudtrail. More information is available at
[AWS Cloudtrail](https://aws.amazon.com/cloudtrail/)

# URI Format

    aws-cloudtrail://label[?options]

The stream needs to be created prior to it being used.

You can append query options to the URI in the following format:

`?options=value&option2=value&...`

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

## Cloudtrail Events consumed

The Cloudtrail consumer will use an API method called LookupEvents.

This method will only take into account management events like
create/update/delete of resources and Cloudtrail insight events where
enabled.

This means you won’t consume the events registered in the Cloudtrail
logs stored on S3, in case of creation of a new Trail.

This is important to notice, and it must be taken into account when
using this component.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|configuration|Component configuration||object|
|eventSource|Specify an event source to select events||string|
|maxResults|Maximum number of records that will be fetched in each poll|1|integer|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with uriEndpointOverride option|false|boolean|
|region|The region in which Cloudtrail client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|cloudTrailClient|Amazon Cloudtrail client to use for all requests for this endpoint||object|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|proxyHost|To define a proxy host when instantiating the Cloudtrail client||string|
|proxyPort|To define a proxy port when instantiating the Cloudtrail client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the Cloudtrail client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|profileCredentialsName|If using a profile credentials provider this parameter will set the profile name.||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume a IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useDefaultCredentialsProvider|Set whether the Cloudtrail client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the Cloudtrail client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the CloudTrail client should expect to use Session Credentials. This is useful in situation in which the user needs to assume a IAM role for doing operations in CloudTrail.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|label|A label for indexing cloudtrail endpoints||string|
|eventSource|Specify an event source to select events||string|
|maxResults|Maximum number of records that will be fetched in each poll|1|integer|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with uriEndpointOverride option|false|boolean|
|region|The region in which Cloudtrail client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|cloudTrailClient|Amazon Cloudtrail client to use for all requests for this endpoint||object|
|proxyHost|To define a proxy host when instantiating the Cloudtrail client||string|
|proxyPort|To define a proxy port when instantiating the Cloudtrail client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the Cloudtrail client|HTTPS|object|
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
|useDefaultCredentialsProvider|Set whether the Cloudtrail client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the Cloudtrail client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the CloudTrail client should expect to use Session Credentials. This is useful in situation in which the user needs to assume a IAM role for doing operations in CloudTrail.|false|boolean|
