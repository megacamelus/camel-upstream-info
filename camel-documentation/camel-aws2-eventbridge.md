# Aws2-eventbridge

**Since Camel 3.6**

**Only producer is supported**

The AWS2 Eventbridge component supports assumeRole operation. [AWS
Eventbridge](https://aws.amazon.com/eventbridge/).

Prerequisites

You must have a valid Amazon Web Services developer account, and be
signed up to use Amazon Eventbridge. More information is available at
[Amazon Eventbridge](https://aws.amazon.com/eventbridge/).

To create a rule that triggers on an action by an AWS service that does
not emit events, you can base the rule on API calls made by that
service. The API calls are recorded by AWS CloudTrail, so you’ll need to
have CloudTrail enabled. For more information, check [Services Supported
by CloudTrail Event
History](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/view-cloudtrail-events.html).

# URI Format

    aws2-eventbridge://label[?options]

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

## AWS2-Eventbridge Producer operations

Camel-AWS2-Eventbridge component provides the following operation on the
producer side:

-   putRule

-   putTargets

-   removeTargets

-   deleteRule

-   enableRule

-   disableRule

-   listRules

-   describeRule

-   listTargetsByRule

-   listRuleNamesByTarget

-   putEvent

-   PutRule: this operation creates a rule related to an eventbus

<!-- -->

      from("direct:putRule").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(EventbridgeConstants.RULE_NAME, "firstrule");
          }
      })
      .to("aws2-eventbridge://test?operation=putRule&eventPatternFile=file:src/test/resources/eventpattern.json")
      .to("mock:result");

This operation will create a rule named *firstrule*, and it will use a
json file for defining the EventPattern.

-   PutTargets: this operation will add a target to the rule

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(EventbridgeConstants.RULE_NAME, "firstrule");
              Target target = Target.builder().id("sqs-queue").arn("arn:aws:sqs:eu-west-1:780410022472:camel-connector-test")
                    .build();
              List<Target> targets = new ArrayList<Target>();
              targets.add(target);
              exchange.getIn().setHeader(EventbridgeConstants.TARGETS, targets);
          }
      })
      .to("aws2-eventbridge://test?operation=putTargets")
      .to("mock:result");

This operation will add the target sqs-queue with the arn reported to
the targets of the *firstrule* rule.

-   RemoveTargets: this operation will remove a collection of targets
    from the rule

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(EventbridgeConstants.RULE_NAME, "firstrule");
              List<String> ids = new ArrayList<String>();
              targets.add("sqs-queue");
              exchange.getIn().setHeader(EventbridgeConstants.TARGETS_IDS, targets);
          }
      })
      .to("aws2-eventbridge://test?operation=removeTargets")
      .to("mock:result");

This operation will remove the target sqs-queue from the *firstrule*
rule.

-   DeleteRule: this operation will delete a rule related to an eventbus

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(EventbridgeConstants.RULE_NAME, "firstrule");
          }
      })
      .to("aws2-eventbridge://test?operation=deleteRule")
      .to("mock:result");

This operation will remove the *firstrule* rule from the test eventbus.

-   EnableRule: this operation will enable a rule related to an eventbus

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(EventbridgeConstants.RULE_NAME, "firstrule");
          }
      })
      .to("aws2-eventbridge://test?operation=enableRule")
      .to("mock:result");

This operation will enable the *firstrule* rule from the test eventbus.

-   DisableRule: this operation will disable a rule related to an
    eventbus

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(EventbridgeConstants.RULE_NAME, "firstrule");
          }
      })
      .to("aws2-eventbridge://test?operation=disableRule")
      .to("mock:result");

This operation will disable the *firstrule* rule from the test eventbus.

-   ListRules: this operation will list all the rules related to an
    eventbus with prefix first

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(EventbridgeConstants.RULE_NAME_PREFIX, "first");
          }
      })
      .to("aws2-eventbridge://test?operation=listRules")
      .to("mock:result");

This operation will list all the rules with prefix first from the test
eventbus.

-   DescribeRule: this operation will describe a specified rule related
    to an eventbus

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(EventbridgeConstants.RULE_NAME, "firstrule");
          }
      })
      .to("aws2-eventbridge://test?operation=describeRule")
      .to("mock:result");

This operation will describe the *firstrule* rule from the test
eventbus.

-   ListTargetsByRule: this operation will return a list of targets
    associated with a rule

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(EventbridgeConstants.RULE_NAME, "firstrule");
          }
      })
      .to("aws2-eventbridge://test?operation=listTargetsByRule")
      .to("mock:result");

this operation will return a list of targets associated with the
*firstrule* rule.

-   ListRuleNamesByTarget: this operation will return a list of rules
    associated with a target

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(EventbridgeConstants.TARGET_ARN, "firstrule");
          }
      })
      .to("aws2-eventbridge://test?operation=listRuleNamesByTarget")
      .to("mock:result");

this operation will return a list of rules associated with a target.

-   PutEvent: this operation will send an event to the Servicebus

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
                    exchange.getIn().setHeader(EventbridgeConstants.EVENT_RESOURCES_ARN, "arn:aws:sqs:eu-west-1:780410022472:camel-connector-test");
                    exchange.getIn().setHeader(EventbridgeConstants.EVENT_SOURCE, "com.pippo");
                    exchange.getIn().setHeader(EventbridgeConstants.EVENT_DETAIL_TYPE, "peppe");
                    exchange.getIn().setBody("Test Event");
          }
      })
      .to("aws2-eventbridge://test?operation=putEvent")
      .to("mock:result");

this operation will return a list of entries with related ID sent to
servicebus.

## Updating the rule

To update a rule, you’ll need to perform the putRule operation again.
There is no explicit update rule operation in the Java SDK.

# Dependencies

Maven users will need to add the following dependency to their pom.xml.

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-aws2-eventbridge</artifactId>
        <version>${camel-version}</version>
    </dependency>

where `${camel-version}` must be replaced by the actual version of
Camel.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configuration|Component configuration||object|
|eventPatternFile|EventPattern File||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|operation|The operation to perform|putRule|object|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|pojoRequest|If we want to use a POJO request as body or not|false|boolean|
|region|The region in which the Eventbridge client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|eventbridgeClient|To use an existing configured AWS Eventbridge client||object|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|proxyHost|To define a proxy host when instantiating the Eventbridge client||string|
|proxyPort|To define a proxy port when instantiating the Eventbridge client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the Eventbridge client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|profileCredentialsName|If using a profile credentials provider this parameter will set the profile name||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume an IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useDefaultCredentialsProvider|Set whether the Eventbridge client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the Eventbridge client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the Eventbridge client should expect to use Session Credentials. This is useful in a situation in which the user needs to assume an IAM role for doing operations in Eventbridge.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|eventbusNameOrArn|Event bus name or ARN||string|
|eventPatternFile|EventPattern File||string|
|operation|The operation to perform|putRule|object|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|pojoRequest|If we want to use a POJO request as body or not|false|boolean|
|region|The region in which the Eventbridge client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|eventbridgeClient|To use an existing configured AWS Eventbridge client||object|
|proxyHost|To define a proxy host when instantiating the Eventbridge client||string|
|proxyPort|To define a proxy port when instantiating the Eventbridge client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the Eventbridge client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|profileCredentialsName|If using a profile credentials provider this parameter will set the profile name||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume an IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useDefaultCredentialsProvider|Set whether the Eventbridge client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the Eventbridge client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the Eventbridge client should expect to use Session Credentials. This is useful in a situation in which the user needs to assume an IAM role for doing operations in Eventbridge.|false|boolean|
