# Aws2-ddb

**Since Camel 3.1**

**Only producer is supported**

The AWS2 DynamoDB component supports storing and retrieving data from/to
[Amazon’s DynamoDB](https://aws.amazon.com/dynamodb) service.

Prerequisites

You must have a valid Amazon Web Services developer account, and be
signed up to use Amazon DynamoDB. More information is available at
[Amazon DynamoDB](https://aws.amazon.com/dynamodb).

# URI Format

    aws2-ddb://domainName[?options]

You can append query options to the URI in the following format:

`?options=value&option2=value&...`

Required DDB component options

You have to provide the amazonDDBClient in the Registry or your
accessKey and secretKey to access the [Amazon’s
DynamoDB](https://aws.amazon.com/dynamodb).

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

## Advanced AmazonDynamoDB configuration

If you need more control over the `AmazonDynamoDB` instance
configuration you can create your own instance and refer to it from the
URI:

    public class MyRouteBuilder extends RouteBuilder {
    
        private String accessKey = "myaccessKey";
        private String secretKey = "secretKey";
    
        @Override
        public void configure() throws Exception {
    
            DynamoDbClient client = DynamoDbClient.builder()
            .region(Region.AP_SOUTHEAST_2)
            .credentialsProvider(StaticCredentialsProvider.create(AwsBasicCredentials.create(accessKey, secretKey)))
            .build();
    
            getCamelContext().getRegistry().bind("client", client);
    
            from("direct:start")
            .to("aws2-ddb://domainName?amazonDDBClient=#client");
        }
    }

The `#client` refers to a `DynamoDbClient` in the Registry.

# Supported producer operations

-   BatchGetItems

-   DeleteItem

-   DeleteTable

-   DescribeTable

-   GetItem

-   PutItem

-   Query

-   Scan

-   UpdateItem

-   UpdateTable

# Dependencies

Maven users will need to add the following dependency to their pom.xml.

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-aws2-ddb</artifactId>
        <version>${camel-version}</version>
    </dependency>

where `${camel-version}` must be replaced by the actual version of
Camel.

# Examples

## Producer Examples

-   PutItem: this operation will create an entry into DynamoDB

<!-- -->

    Map<String, AttributeValue> attributeMap = new HashMap<>();
    attributeMap.put("partitionKey", AttributeValue.builder().s("3000").build());
    attributeMap.put("id", AttributeValue.builder().s("1001").build());
    attributeMap.put("barcode", AttributeValue.builder().s("9002811220001").build());
    
    from("direct:start")
      .setHeader(Ddb2Constants.OPERATION,  constant(Ddb2Operations.PutItem))
      .setHeader(Ddb2Constants.CONSISTENT_READ, constant("true"))
      .setHeader(Ddb2Constants.RETURN_VALUES, constant("ALL_OLD"))
      .setHeader(Ddb2Constants.ITEM, constant(attributeMap))
      .setHeader(Ddb2Constants.ATTRIBUTE_NAMES, constant(attributeMap.keySet()))
      .to("aws2-ddb://" + tableName + "?amazonDDBClient=#client");

-   UpdateItem: this operation will update an entry into DynamoDB

<!-- -->

    Map<String, AttributeValueUpdate> attributeMap = new HashMap<>();
    attributeMap.put("partitionKey", AttributeValueUpdate.builder().value(AttributeValue.builder().s("3000").build()).build());
    attributeMap.put("sortKey",  AttributeValueUpdate.builder().value(AttributeValue.builder().s("1001").build()).build());
    attributeMap.put("borcode",  AttributeValueUpdate.builder().value(AttributeValue.builder().s("900281122").build()).build());
    
    Map<String, AttributeValue> keyMap = new HashMap<>();
    keyMap.put("partitionKey", AttributeValue.builder().s("3000").build());
    keyMap.put("sortKey", AttributeValue.builder().s("1001").build());
    
    from("direct:start")
      .setHeader(Ddb2Constants.OPERATION,  constant(Ddb2Operations.UpdateItem))
      .setHeader(Ddb2Constants.UPDATE_VALUES,  constant(attributeMap))
      .setHeader(Ddb2Constants.KEY,  constant(keyMap))
      .to("aws2-ddb://" + tableName + "?amazonDDBClient=#client");

-   GetItem: this operation will retrieve an entry from DynamoDB

<!-- -->

    from("direct:get")
      .process(exchange -> {
          final Map<String, AttributeValue> keyMap = new HashMap<>();
          keyMap.put("table-key", AttributeValue.builder().s("1").build());
    
          exchange.getIn().setHeader(Ddb2Constants.OPERATION, Ddb2Operations.GetItem);
          exchange.getIn().setHeader(Ddb2Constants.ATTRIBUTE_NAMES, constant(List.of("table-key", "message")));
          exchange.getIn().setHeader(Ddb2Constants.KEY, keyMap);
      })
      .toF("aws2-ddb://%s?amazonDDBClient=#client&consistentRead=true", tableName);

-   DeleteItem: this operation will delete an entry from DynamoDB

<!-- -->

    from("direct:delete")
      .process(exchange -> {
          final Map<String, AttributeValue> keyMap = new HashMap<>();
          keyMap.put("table-key", AttributeValue.builder().s("1").build());
    
          exchange.getIn().setHeader(Ddb2Constants.OPERATION, Ddb2Operations.DeleteItem);
          exchange.getIn().setHeader(Ddb2Constants.KEY, keyMap);
      })
      .toF("aws2-ddb://%s?amazonDDBClient=#client&consistentRead=true", tableName);

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configuration|The component configuration||object|
|consistentRead|Determines whether strong consistency should be enforced when data is read.|false|boolean|
|enabledInitialDescribeTable|Set whether the initial Describe table operation in the DDB Endpoint must be done, or not.|true|boolean|
|keyAttributeName|Attribute name when creating table||string|
|keyAttributeType|Attribute type when creating table||string|
|keyScalarType|The key scalar type, it can be S (String), N (Number) and B (Bytes)||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|operation|What operation to perform|PutItem|object|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with uriEndpointOverride option|false|boolean|
|readCapacity|The provisioned throughput to reserve for reading resources from your table||integer|
|region|The region in which DDB client needs to work||string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|writeCapacity|The provisioned throughput to reserved for writing resources to your table||integer|
|amazonDDBClient|To use the AmazonDynamoDB as the client||object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|proxyHost|To define a proxy host when instantiating the DDB client||string|
|proxyPort|The region in which DynamoDB client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||integer|
|proxyProtocol|To define a proxy protocol when instantiating the DDB client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|profileCredentialsName|If using a profile credentials provider this parameter will set the profile name||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume a IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useDefaultCredentialsProvider|Set whether the S3 client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the DDB client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the DDB client should expect to use Session Credentials. This is useful in situation in which the user needs to assume a IAM role for doing operations in DDB.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|tableName|The name of the table currently worked with.||string|
|consistentRead|Determines whether strong consistency should be enforced when data is read.|false|boolean|
|enabledInitialDescribeTable|Set whether the initial Describe table operation in the DDB Endpoint must be done, or not.|true|boolean|
|keyAttributeName|Attribute name when creating table||string|
|keyAttributeType|Attribute type when creating table||string|
|keyScalarType|The key scalar type, it can be S (String), N (Number) and B (Bytes)||string|
|operation|What operation to perform|PutItem|object|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with uriEndpointOverride option|false|boolean|
|readCapacity|The provisioned throughput to reserve for reading resources from your table||integer|
|region|The region in which DDB client needs to work||string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|writeCapacity|The provisioned throughput to reserved for writing resources to your table||integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|amazonDDBClient|To use the AmazonDynamoDB as the client||object|
|proxyHost|To define a proxy host when instantiating the DDB client||string|
|proxyPort|The region in which DynamoDB client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||integer|
|proxyProtocol|To define a proxy protocol when instantiating the DDB client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|profileCredentialsName|If using a profile credentials provider this parameter will set the profile name||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume a IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useDefaultCredentialsProvider|Set whether the S3 client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the DDB client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the DDB client should expect to use Session Credentials. This is useful in situation in which the user needs to assume a IAM role for doing operations in DDB.|false|boolean|
