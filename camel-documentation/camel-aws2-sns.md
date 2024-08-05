# Aws2-sns

**Since Camel 3.1**

**Only producer is supported**

The AWS2 SNS component allows messages to be sent to an [Amazon Simple
Notification](https://aws.amazon.com/sns) Topic. The implementation of
the Amazon API is provided by the [AWS
SDK](https://aws.amazon.com/sdkforjava/).

Prerequisites

You must have a valid Amazon Web Services developer account, and be
signed up to use Amazon SNS. More information is available at [Amazon
SNS](https://aws.amazon.com/sns).

# URI Format

    aws2-sns://topicNameOrArn[?options]

The topic will be created if they don’t already exist.

You can append query options to the URI in the following format:

`?options=value&option2=value&...`

# URI Options

Required SNS component options

You have to provide the amazonSNSClient in the Registry or your
accessKey and secretKey to access the [Amazon’s
SNS](https://aws.amazon.com/sns).

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

## Advanced AmazonSNS configuration

If you need more control over the `SnsClient` instance configuration you
can create your own instance and refer to it from the URI:

    from("direct:start")
    .to("aws2-sns://MyTopic?amazonSNSClient=#client");

The `#client` refers to a `AmazonSNS` in the Registry.

## Create a subscription between an AWS SNS Topic and an AWS SQS Queue

You can create a subscription of an SQS Queue to an SNS Topic in this
way:

    from("direct:start")
    .to("aws2-sns://test-camel-sns1?amazonSNSClient=#amazonSNSClient&subscribeSNStoSQS=true&queueArn=arn:aws:sqs:eu-central-1:123456789012:test_camel");

The `#amazonSNSClient` refers to a `SnsClient` in the Registry. By
specifying `subscribeSNStoSQS` to true and a `queueArn` of an existing
SQS Queue, you’ll be able to subscribe your SQS Queue to your SNS Topic.

At this point, you can consume messages coming from SNS Topic through
your SQS Queue

    from("aws2-sqs://test-camel?amazonSQSClient=#amazonSQSClient&delay=50&maxMessagesPerPoll=5")
        .to(...);

# Topic Autocreation

With the option `autoCreateTopic` users are able to avoid the
autocreation of an SNS Topic in case it doesn’t exist. The default for
this option is `false`. If set to false, any operation on a non-existent
topic in AWS won’t be successful and an error will be returned.

# SNS FIFO

SNS FIFO are supported. While creating the SQS queue, you will subscribe
to the SNS topic there is an important point to remember, you’ll need to
make possible for the SNS Topic to send the message to the SQS Queue.

This is clear with an example.

Suppose you created an SNS FIFO Topic called Order.fifo and an SQS Queue
called QueueSub.fifo.

In the access Policy of the QueueSub.fifo you should submit something
like this

    {
      "Version": "2008-10-17",
      "Id": "__default_policy_ID",
      "Statement": [
        {
          "Sid": "__owner_statement",
          "Effect": "Allow",
          "Principal": {
            "AWS": "arn:aws:iam::780560123482:root"
          },
          "Action": "SQS:*",
          "Resource": "arn:aws:sqs:eu-west-1:780560123482:QueueSub.fifo"
        },
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "sns.amazonaws.com"
          },
          "Action": "SQS:SendMessage",
          "Resource": "arn:aws:sqs:eu-west-1:780560123482:QueueSub.fifo",
          "Condition": {
            "ArnLike": {
              "aws:SourceArn": "arn:aws:sns:eu-west-1:780410022472:Order.fifo"
            }
          }
        }
      ]
    }

This is a critical step to make the subscription work correctly.

## SNS Fifo Topic Message group ID Strategy and message Deduplication ID Strategy

When sending something to the FIFO topic, you’ll need to always set up a
message group ID strategy.

If the content-based message deduplication has been enabled on the SNS
Fifo topic, where won’t be the need of setting a message deduplication
id strategy, otherwise you’ll have to set it.

# Examples

## Producer Examples

Sending to a topic

    from("direct:start")
      .to("aws2-sns://camel-topic?subject=The+subject+message&autoCreateTopic=true");

# Dependencies

Maven users will need to add the following dependency to their pom.xml.

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-aws2-sns</artifactId>
        <version>${camel-version}</version>
    </dependency>

where `${camel-version}` must be replaced by the actual version of
Camel.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|autoCreateTopic|Setting the auto-creation of the topic|false|boolean|
|configuration|Component configuration||object|
|kmsMasterKeyId|The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|messageDeduplicationIdStrategy|Only for FIFO Topic. Strategy for setting the messageDeduplicationId on the message. It can be one of the following options: useExchangeId, useContentBasedDeduplication. For the useContentBasedDeduplication option, no messageDeduplicationId will be set on the message.|useExchangeId|string|
|messageGroupIdStrategy|Only for FIFO Topic. Strategy for setting the messageGroupId on the message. It can be one of the following options: useConstant, useExchangeId, usePropertyValue. For the usePropertyValue option, the value of property CamelAwsSnsMessageGroupId will be used.||string|
|messageStructure|The message structure to use such as json||string|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|policy|The policy for this topic. Is loaded by default from classpath, but you can prefix with classpath:, file:, or http: to load the resource from different systems.||string|
|queueArn|The ARN endpoint to subscribe to||string|
|region|The region in which the SNS client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|serverSideEncryptionEnabled|Define if Server Side Encryption is enabled or not on the topic|false|boolean|
|subject|The subject which is used if the message header 'CamelAwsSnsSubject' is not present.||string|
|subscribeSNStoSQS|Define if the subscription between SNS Topic and SQS must be done or not|false|boolean|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|amazonSNSClient|To use the AmazonSNS as the client||object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|proxyHost|To define a proxy host when instantiating the SNS client||string|
|proxyPort|To define a proxy port when instantiating the SNS client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the SNS client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|profileCredentialsName|If using a profile credentials provider, this parameter will set the profile name||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume an IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useDefaultCredentialsProvider|Set whether the SNS client should expect to load credentials on an AWS infra instance or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the SNS client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the SNS client should expect to use Session Credentials. This is useful in a situation in which the user needs to assume an IAM role for doing operations in SNS.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|topicNameOrArn|Topic name or ARN||string|
|autoCreateTopic|Setting the auto-creation of the topic|false|boolean|
|headerFilterStrategy|To use a custom HeaderFilterStrategy to map headers to/from Camel.||object|
|kmsMasterKeyId|The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK.||string|
|messageDeduplicationIdStrategy|Only for FIFO Topic. Strategy for setting the messageDeduplicationId on the message. It can be one of the following options: useExchangeId, useContentBasedDeduplication. For the useContentBasedDeduplication option, no messageDeduplicationId will be set on the message.|useExchangeId|string|
|messageGroupIdStrategy|Only for FIFO Topic. Strategy for setting the messageGroupId on the message. It can be one of the following options: useConstant, useExchangeId, usePropertyValue. For the usePropertyValue option, the value of property CamelAwsSnsMessageGroupId will be used.||string|
|messageStructure|The message structure to use such as json||string|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|policy|The policy for this topic. Is loaded by default from classpath, but you can prefix with classpath:, file:, or http: to load the resource from different systems.||string|
|queueArn|The ARN endpoint to subscribe to||string|
|region|The region in which the SNS client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|serverSideEncryptionEnabled|Define if Server Side Encryption is enabled or not on the topic|false|boolean|
|subject|The subject which is used if the message header 'CamelAwsSnsSubject' is not present.||string|
|subscribeSNStoSQS|Define if the subscription between SNS Topic and SQS must be done or not|false|boolean|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|amazonSNSClient|To use the AmazonSNS as the client||object|
|proxyHost|To define a proxy host when instantiating the SNS client||string|
|proxyPort|To define a proxy port when instantiating the SNS client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the SNS client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|profileCredentialsName|If using a profile credentials provider, this parameter will set the profile name||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume an IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useDefaultCredentialsProvider|Set whether the SNS client should expect to load credentials on an AWS infra instance or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the SNS client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the SNS client should expect to use Session Credentials. This is useful in a situation in which the user needs to assume an IAM role for doing operations in SNS.|false|boolean|
