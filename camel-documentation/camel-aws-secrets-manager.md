# Aws-secrets-manager

**Since Camel 3.9**

**Only producer is supported**

The AWS Secrets Manager component supports list secret [AWS Secrets
Manager](https://aws.amazon.com/secrets-manager/) service.

Prerequisites

You must have a valid Amazon Web Services developer account, and be
signed up to use Amazon Secrets Manager. More information is available
at [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/).

# URI Format

    aws-secrets-manager://label[?options]

You can append query options to the URI in the following format:

`?options=value&option2=value&...`

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

## Using AWS Secrets Manager Property Function

To use this function, you’ll need to provide credentials to AWS Secrets
Manager Service as environment variables:

    export $CAMEL_VAULT_AWS_ACCESS_KEY=accessKey
    export $CAMEL_VAULT_AWS_SECRET_KEY=secretKey
    export $CAMEL_VAULT_AWS_REGION=region

You can also configure the credentials in the `application.properties`
file such as:

    camel.vault.aws.accessKey = accessKey
    camel.vault.aws.secretKey = secretKey
    camel.vault.aws.region = region

If you want instead to use the [AWS default credentials
provider](https://docs.aws.amazon.com/sdk-for-java/latest/developer-guide/credentials.html),
you’ll need to provide the following env variables:

    export $CAMEL_VAULT_AWS_USE_DEFAULT_CREDENTIALS_PROVIDER=true
    export $CAMEL_VAULT_AWS_REGION=region

You can also configure the credentials in the `application.properties`
file such as:

    camel.vault.aws.defaultCredentialsProvider = true
    camel.vault.aws.region = region

It is also possible to specify a particular profile name for accessing
AWS Secrets Manager

    export $CAMEL_VAULT_AWS_USE_PROFILE_CREDENTIALS_PROVIDER=true
    export $CAMEL_VAULT_AWS_PROFILE_NAME=test-account
    export $CAMEL_VAULT_AWS_REGION=region

You can also configure the credentials in the `application.properties`
file such as:

    camel.vault.aws.profileCredentialsProvider = true
    camel.vault.aws.profileName = test-account
    camel.vault.aws.region = region

`camel.vault.aws` configuration only applies to the AWS Secrets Manager
properties function (E.g when resolving properties). When using the
`operation` option to create, get, list secrets etc., you should provide
the usual options for connecting to AWS Services.

At this point, you’ll be able to reference a property in the following
way:

    <camelContext>
        <route>
            <from uri="direct:start"/>
            <to uri="{{aws:route}}"/>
        </route>
    </camelContext>

Where route will be the name of the secret stored in the AWS Secrets
Manager Service.

You could specify a default value in case the secret is not present on
AWS Secret Manager:

    <camelContext>
        <route>
            <from uri="direct:start"/>
            <to uri="{{aws:route:default}}"/>
        </route>
    </camelContext>

In this case, if the secret doesn’t exist, the property will fall back
to "default" as value.

Also, you are able to get a particular field of the secret, if you have,
for example, a secret named database of this form:

    {
      "username": "admin",
      "password": "password123",
      "engine": "postgres",
      "host": "127.0.0.1",
      "port": "3128",
      "dbname": "db"
    }

You’re able to do get single secret value in your route, like for
example:

    <camelContext>
        <route>
            <from uri="direct:start"/>
            <log message="Username is {{aws:database#username}}"/>
        </route>
    </camelContext>

Or re-use the property as part of an endpoint.

You could specify a default value in case the particular field of secret
is not present on AWS Secret Manager:

    <camelContext>
        <route>
            <from uri="direct:start"/>
            <log message="Username is {{aws:database#username:admin}}"/>
        </route>
    </camelContext>

In this case, if the secret doesn’t exist or the secret exists, but the
username field is not part of the secret, the property will fall back to
"admin" as value.

There is also the syntax to get a particular version of the secret for
both the approach, with field/default value specified or only with
secret:

    <camelContext>
        <route>
            <from uri="direct:start"/>
            <to uri="{{aws:route@bf9b4f4b-8e63-43fd-a73c-3e2d3748b451}}"/>
        </route>
    </camelContext>

This approach will return the RAW route secret with the version
*bf9b4f4b-8e63-43fd-a73c-3e2d3748b451*.

    <camelContext>
        <route>
            <from uri="direct:start"/>
            <to uri="{{aws:route:default@bf9b4f4b-8e63-43fd-a73c-3e2d3748b451}}"/>
        </route>
    </camelContext>

This approach will return the route secret value with version
*bf9b4f4b-8e63-43fd-a73c-3e2d3748b451* or default value in case the
secret doesn’t exist or the version doesn’t exist.

    <camelContext>
        <route>
            <from uri="direct:start"/>
            <log message="Username is {{aws:database#username:admin@bf9b4f4b-8e63-43fd-a73c-3e2d3748b451}}"/>
        </route>
    </camelContext>

This approach will return the username field of the database secret with
version *bf9b4f4b-8e63-43fd-a73c-3e2d3748b451* or admin in case the
secret doesn’t exist or the version doesn’t exist.

For the moment we are not considering the rotation function if any are
applied, but it is in the work to be done.

The only requirement is adding the camel-aws-secrets-manager jar to your
Camel application.

## Automatic Camel context reloading on Secret Refresh

Being able to reload Camel context on a Secret Refresh could be done by
specifying the usual credentials (the same used for AWS Secret Manager
Property Function).

With Environment variables:

    export $CAMEL_VAULT_AWS_USE_DEFAULT_CREDENTIALS_PROVIDER=accessKey
    export $CAMEL_VAULT_AWS_REGION=region

or as plain Camel main properties:

    camel.vault.aws.useDefaultCredentialProvider = true
    camel.vault.aws.region = region

Or by specifying accessKey/SecretKey and region, instead of using the
default credentials provider chain.

To enable the automatic refresh, you’ll need additional properties to
set:

    camel.vault.aws.refreshEnabled=true
    camel.vault.aws.refreshPeriod=60000
    camel.vault.aws.secrets=Secret
    camel.main.context-reload-enabled = true

where `camel.vault.aws.refreshEnabled` will enable the automatic context
reload, `camel.vault.aws.refreshPeriod` is the interval of time between
two different checks for update events and `camel.vault.aws.secrets` is
a regex representing the secrets we want to track for updates.

Note that `camel.vault.aws.secrets` is not mandatory: if not specified
the task responsible for checking updates events will take into accounts
or the properties with an `aws:` prefix.

## Automatic Camel context reloading on Secret Refresh with Eventbridge and AWS SQS Services

Another option is to use AWS EventBridge in conjunction with the AWS SQS
service.

On the AWS side, the following resources need to be created:

-   an AWS Couldtrail trail

-   an AWS SQS Queue

-   an Eventbridge rule of the following kind

<!-- -->

    {
      "source": ["aws.secretsmanager"],
      "detail-type": ["AWS API Call via CloudTrail"],
      "detail": {
        "eventSource": ["secretsmanager.amazonaws.com"]
      }
    }

This rule will make the event related to AWS Secrets Manager filtered

-   You need to set the a Rule target to the AWS SQS Queue for
    Eventbridge rule

-   You need to give permission to the Eventbrige rule, to write on the
    above SQS Queue. For doing this you’ll need to define a json file
    like this:

<!-- -->

    {
        "Policy": "{\"Version\":\"2012-10-17\",\"Id\":\"<queue_arn>/SQSDefaultPolicy\",\"Statement\":[{\"Sid\": \"EventsToMyQueue\", \"Effect\": \"Allow\", \"Principal\": {\"Service\": \"events.amazonaws.com\"}, \"Action\": \"sqs:SendMessage\", \"Resource\": \"<queue_arn>\", \"Condition\": {\"ArnEquals\": {\"aws:SourceArn\": \"<eventbridge_rule_arn>\"}}}]}"
    }

Change the values for queue\_arn and eventbridge\_rule\_arn, save the
file with policy.json name and run the following command with AWS CLI

    aws sqs set-queue-attributes --queue-url <queue_url> --attributes file://policy.json

where queue\_url is the AWS SQS Queue URL of the just created Queue.

Now you should be able to set up the configuration on the Camel side. To
enable the SQS notification add the following properties:

    camel.vault.aws.refreshEnabled=true
    camel.vault.aws.refreshPeriod=60000
    camel.vault.aws.secrets=Secret
    camel.main.context-reload-enabled = true
    camel.vault.aws.useSqsNotification=true
    camel.vault.aws.sqsQueueUrl=<queue_url>

where queue\_url is the AWS SQS Queue URL of the just created Queue.

Whenever an event of PutSecretValue for the Secret named *Secret* will
happen, a message will be enqueued in the AWS SQS Queue and consumed on
the Camel side and a context reload will be triggered.

## Secrets Manager Producer operations

Camel-AWS-Secrets-manager component provides the following operation on
the producer side:

-   listSecrets

-   createSecret

-   deleteSecret

-   describeSecret

-   rotateSecret

-   getSecret

-   batchGetSecret

-   updateSecret

-   replicateSecretToRegions

# Dependencies

Maven users will need to add the following dependency to their pom.xml.

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-aws-secrets-manager</artifactId>
        <version>${camel-version}</version>
    </dependency>

where `${camel-version}` must be replaced by the actual version of
Camel.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|binaryPayload|Set if the secret is binary or not|false|boolean|
|configuration|Component configuration||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|operation|The operation to perform||object|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|pojoRequest|If we want to use a POJO request as body or not|false|boolean|
|profileCredentialsName|If using a profile credentials provider, this parameter will set the profile name||string|
|region|The region in which a Secrets Manager client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|useProfileCredentialsProvider|Set whether the Secrets Manager client should expect to load credentials through a profile credentials provider.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|secretsManagerClient|To use an existing configured AWS Secrets Manager client||object|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|proxyHost|To define a proxy host when instantiating the Secrets Manager client||string|
|proxyPort|To define a proxy port when instantiating the Secrets Manager client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the Secrets Manager client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume an IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useDefaultCredentialsProvider|Set whether the Translate client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useSessionCredentials|Set whether the Secrets Manager client should expect to use Session Credentials. This is useful in a situation in which the user needs to assume an IAM role for doing operations in Secrets Manager.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|label|Logical name||string|
|binaryPayload|Set if the secret is binary or not|false|boolean|
|operation|The operation to perform||object|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|pojoRequest|If we want to use a POJO request as body or not|false|boolean|
|profileCredentialsName|If using a profile credentials provider, this parameter will set the profile name||string|
|region|The region in which a Secrets Manager client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|useProfileCredentialsProvider|Set whether the Secrets Manager client should expect to load credentials through a profile credentials provider.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|secretsManagerClient|To use an existing configured AWS Secrets Manager client||object|
|proxyHost|To define a proxy host when instantiating the Secrets Manager client||string|
|proxyPort|To define a proxy port when instantiating the Secrets Manager client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the Secrets Manager client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume an IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useDefaultCredentialsProvider|Set whether the Translate client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useSessionCredentials|Set whether the Secrets Manager client should expect to use Session Credentials. This is useful in a situation in which the user needs to assume an IAM role for doing operations in Secrets Manager.|false|boolean|
