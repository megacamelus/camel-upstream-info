# Aws2-step-functions

**Since Camel 4.0**

**Only producer is supported**

The AWS2 Step Functions component supports the following operations on
[AWS Step Functions](https://aws.amazon.com/step-functions/):

-   Create, delete, update, describe, list state machines.

-   Create, delete, describe, list activities.

-   Start, start sync, stop, list, describe executions.

-   Get activities task.

-   Get execution history

Prerequisites

You must have a valid Amazon Web Services developer account, and be
signed up to use Amazon Step Functions. More information is available at
[AWS Step Functions](https://aws.amazon.com/step-functions/).

# URI Format

    aws2-step-functions://label[?options]

You can append query options to the URI in the following format:

`?options=value&option2=value&...`

Required Step Functions component options

You have to provide the awsSfnClient in the Registry or your accessKey
and secretKey to access the [AWS Step
Functions](https://aws.amazon.com/step-functions/) service.

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

## Step Functions Producer operations

Camel-AWS Step Functions component provides the following operation on
the producer side:

-   createStateMachine

-   deleteStateMachine

-   updateStateMachine

-   describeStateMachine

-   listStateMachines

-   createActivity

-   deleteActivity

-   describeActivity

-   getActivityTask

-   listActivities

-   startExecution

-   startSyncExecution

-   stopExecution

-   describeExecution

-   listExecutions

-   getExecutionHistory

# Examples

## Producer Examples

-   createStateMachine: this operation will create a state machine

<!-- -->

    from("direct:createStateMachine")
        .to("aws2-step-functions://test?awsSfnClient=#awsSfnClient&operation=createMachine")

## Using a POJO as body

Sometimes building an AWS Request can be complex because of multiple
options. We introduce the possibility to use a POJO as the body. In AWS
Step Functions, there are multiple operations you can submit, as an
example for Create state machine request, you can do something like:

    from("direct:start")
      .setBody(CreateStateMachineRequest.builder().name("state-machine").build())
      .to("aws2-step-functions://test?awsSfnClient=#awsSfnClient&operation=createStateMachine&pojoRequest=true")

In this way, you’ll pass the request directly without the need of
passing headers and options specifically related to this operation.

# Dependencies

Maven users will need to add the following dependency to their pom.xml.

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-aws2-step-functions</artifactId>
        <version>${camel-version}</version>
    </dependency>

where `${camel-version}` must be replaced by the actual version of
Camel.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configuration|Component configuration||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|operation|The operation to perform. It can be listFunctions, getFunction, createFunction, deleteFunction or invokeFunction||object|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|pojoRequest|If we want to use a POJO request as body or not|false|boolean|
|profileCredentialsName|If using a profile credentials provider, this parameter will set the profile name||string|
|region|The region in which StepFunctions client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|useDefaultCredentialsProvider|Set whether the StepFunctions client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the StepFunctions client should expect to load credentials through a profile credentials provider.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|awsSfnClient|To use an existing configured AwsStepFunctionsClient client||object|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|proxyHost|To define a proxy host when instantiating the StepFunctions client||string|
|proxyPort|To define a proxy port when instantiating the StepFunctions client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the StepFunctions client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume an IAM role||string|
|useSessionCredentials|Set whether the Step Functions client should expect to use Session Credentials. This is useful in a situation in which the user needs to assume an IAM role for doing operations in Step Functions.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|label|Logical name||string|
|operation|The operation to perform. It can be listFunctions, getFunction, createFunction, deleteFunction or invokeFunction||object|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|pojoRequest|If we want to use a POJO request as body or not|false|boolean|
|profileCredentialsName|If using a profile credentials provider, this parameter will set the profile name||string|
|region|The region in which StepFunctions client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|useDefaultCredentialsProvider|Set whether the StepFunctions client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the StepFunctions client should expect to load credentials through a profile credentials provider.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|awsSfnClient|To use an existing configured AwsStepFunctionsClient client||object|
|proxyHost|To define a proxy host when instantiating the StepFunctions client||string|
|proxyPort|To define a proxy port when instantiating the StepFunctions client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the StepFunctions client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume an IAM role||string|
|useSessionCredentials|Set whether the Step Functions client should expect to use Session Credentials. This is useful in a situation in which the user needs to assume an IAM role for doing operations in Step Functions.|false|boolean|
