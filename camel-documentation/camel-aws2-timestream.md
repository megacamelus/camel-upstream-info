# Aws2-timestream

**Since Camel 4.1**

**Only producer is supported**

The AWS2 Timestream component supports the following operations on [AWS
Timestream](https://aws.amazon.com/timestream/):

-   Write Operations
    
    -   Describe Write Endpoints
    
    -   Create, Describe, Resume, List Batch Load Tasks
    
    -   Create, Delete, Update, Describe, List Databases
    
    -   Create, Delete, Update, Describe, List Tables
    
    -   Write Records

-   Query Operations
    
    -   Describe Query Endpoints
    
    -   Prepare Query, Query, Cancel Query
    
    -   Create, Delete, Execute, Update, Describe, List Scheduled
        Queries

Prerequisites

You must have a valid Amazon Web Services developer account, and be
signed up to use Amazon Timestream. More information is available at
[AWS Timestream](https://aws.amazon.com/timestream/).

# URI Format

    aws2-timestream://clientType:label[?options]

You can append query options to the URI in the following format:

`?options=value&option2=value&...`

Required Timestream component options

Based on the type of operation to be performed, the type of client
(write/query) needs to be provided as clientType URI path parameter

You have to provide either the awsTimestreamWriteClient(for write
operations) or awsTimestreamQueryClient(for query operations) in the
Registry or your accessKey and secretKey to access the [AWS
Timestream](https://aws.amazon.com/timestream/) service.

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

## Timestream Producer operations

Camel-AWS Timestream component provides the following operation on the
producer side:

-   Write Operations
    
    -   describeEndpoints
    
    -   createBatchLoadTask
    
    -   describeBatchLoadTask
    
    -   resumeBatchLoadTask
    
    -   listBatchLoadTasks
    
    -   createDatabase
    
    -   deleteDatabase
    
    -   describeDatabase
    
    -   updateDatabase
    
    -   listDatabases
    
    -   createTable
    
    -   deleteTable
    
    -   describeTable
    
    -   updateTable
    
    -   listTables
    
    -   writeRecords

-   Query Operations
    
    -   describeEndpoints
    
    -   createScheduledQuery
    
    -   deleteScheduledQuery
    
    -   executeScheduledQuery
    
    -   updateScheduledQuery
    
    -   describeScheduledQuery
    
    -   listScheduledQueries
    
    -   prepareQuery
    
    -   query
    
    -   cancelQuery

# Examples

## Producer Examples

-   Write Operation
    
    -   createDatabase: this operation will create a timestream database

<!-- -->

    from("direct:createDatabase")
        .setHeader(Timestream2Constants.DATABASE_NAME, constant("testDb"))
        .setHeader(Timestream2Constants.KMS_KEY_ID, constant("testKmsKey"))
        .to("aws2-timestream://write:test?awsTimestreamWriteClient=#awsTimestreamWriteClient&operation=createDatabase")

-   Query Operation
    
    -   query: this operation will execute a timestream query

<!-- -->

    from("direct:query")
        .setHeader(Timestream2Constants.QUERY_STRING, constant("SELECT * FROM testDb.testTable ORDER BY time DESC LIMIT 10"))
        .to("aws2-timestream://query:test?awsTimestreamQueryClient=#awsTimestreamQueryClient&operation=query")

## Using a POJO as body

Sometimes building an AWS Request can be complex because of multiple
options. We introduce the possibility to use a POJO as the body. In AWS
Timestream there are multiple operations you can submit, as an example
for Create state machine request, you can do something like:

-   Write Operation
    
    -   createDatabase: this operation will create a timestream database

<!-- -->

    from("direct:start")
      .setBody(CreateDatabaseRequest.builder().database(Database.builder().databaseName("testDb").kmsKeyId("testKmsKey").build()).build())
      .to("aws2-timestream://write:test?awsTimestreamWriteClient=#awsTimestreamWriteClient&operation=createDatabase&pojoRequest=true")

-   Query Operation
    
    -   query: this operation will execute a timestream query

<!-- -->

    from("direct:query")
        .setBody(QueryRequest.builder().queryString("SELECT * FROM testDb.testTable ORDER BY time DESC LIMIT 10").build())
        .to("aws2-timestream://query:test?awsTimestreamQueryClient=#awsTimestreamQueryClient&operation=query&pojoRequest=true")

In this way, you’ll pass the request directly without the need of
passing headers and options specifically related to this operation.

# Dependencies

Maven users will need to add the following dependency to their pom.xml.

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-aws2-timestream</artifactId>
        <version>${camel-version}</version>
    </dependency>

where `${camel-version}` must be replaced by the actual version of
Camel.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configuration|Component configuration||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|operation|The operation to perform. It can be describeEndpoints,createBatchLoadTask,describeBatchLoadTask, resumeBatchLoadTask,listBatchLoadTasks,createDatabase,deleteDatabase,describeDatabase,updateDatabase, listDatabases,createTable,deleteTable,describeTable,updateTable,listTables,writeRecords, createScheduledQuery,deleteScheduledQuery,executeScheduledQuery,updateScheduledQuery, describeScheduledQuery,listScheduledQueries,prepareQuery,query,cancelQuery||object|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|pojoRequest|If we want to use a POJO request as body or not|false|boolean|
|profileCredentialsName|If using a profile credentials provider, this parameter will set the profile name||string|
|region|The region in which the Timestream client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|useDefaultCredentialsProvider|Set whether the Timestream client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the Timestream client should expect to load credentials through a profile credentials provider.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|awsTimestreamQueryClient|To use an existing configured AwsTimestreamQueryClient client||object|
|awsTimestreamWriteClient|To use an existing configured AwsTimestreamWriteClient client||object|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|proxyHost|To define a proxy host when instantiating the Timestream client||string|
|proxyPort|To define a proxy port when instantiating the Timestream client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the Timestream client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|secretKey|Amazon AWS Secret Key||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|clientType|Type of client - write/query||object|
|label|Logical name||string|
|operation|The operation to perform. It can be describeEndpoints,createBatchLoadTask,describeBatchLoadTask, resumeBatchLoadTask,listBatchLoadTasks,createDatabase,deleteDatabase,describeDatabase,updateDatabase, listDatabases,createTable,deleteTable,describeTable,updateTable,listTables,writeRecords, createScheduledQuery,deleteScheduledQuery,executeScheduledQuery,updateScheduledQuery, describeScheduledQuery,listScheduledQueries,prepareQuery,query,cancelQuery||object|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|pojoRequest|If we want to use a POJO request as body or not|false|boolean|
|profileCredentialsName|If using a profile credentials provider, this parameter will set the profile name||string|
|region|The region in which the Timestream client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|useDefaultCredentialsProvider|Set whether the Timestream client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the Timestream client should expect to load credentials through a profile credentials provider.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|awsTimestreamQueryClient|To use an existing configured AwsTimestreamQueryClient client||object|
|awsTimestreamWriteClient|To use an existing configured AwsTimestreamWriteClient client||object|
|proxyHost|To define a proxy host when instantiating the Timestream client||string|
|proxyPort|To define a proxy port when instantiating the Timestream client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the Timestream client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|secretKey|Amazon AWS Secret Key||string|
