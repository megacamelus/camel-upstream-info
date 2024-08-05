# Aws2-athena

**Since Camel 3.4**

**Only producer is supported**

The AWS2 Athena component supports running queries with [AWS
Athena](https://aws.amazon.com/athena/) and working with results.

Prerequisites

You must have a valid Amazon Web Services developer account, and be
signed up to use Amazon Athena. More information is available at [AWS
Athena](https://aws.amazon.com/athena/).

# URI Format

    aws2-athena://label[?options]

You can append query options to the URI in the following format:
`?options=value&option2=value&...`

Required Athena component options

You have to provide the amazonAthenaClient in the Registry or your
accessKey and secretKey to access the [AWS
Athena](https://aws.amazon.com/athena/) service.

# Examples

## Producer Examples

For example, to run a simple query, wait up to 60 seconds for
completion, and log the results:

    from("direct:start")
        .setBody(constant("SELECT 1"))
        .to("aws2-athena://label?waitTimeout=60000&outputLocation=s3://bucket/path/")
        .to("aws2-athena://label?operation=getQueryResults&outputType=StreamList")
        .split(body()).streaming()
        .to("log:out")
        .to("mock:result");

Similarly, running the query and returning a path to the results in S3:

    from("direct:start")
        .setBody(constant("SELECT 1"))
        .to("aws2-athena://label?waitTimeout=60000&outputLocation=s3://bucket/path/")
        .to("aws2-athena://label?operation=getQueryResults&outputType=S3Pointer")
        .to("mock:result");

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

## Athena Producer operations

The Camel-AWS Athena component provides the following operation on the
producer side:

-   getQueryExecution

-   getQueryResults

-   listQueryExecutions

-   startQueryExecution

## Advanced AmazonAthena configuration

If your Camel Application is running behind a firewall or if you need to
have more control over the `AthenaClient` instance configuration, you
can create your own instance and refer to it in your Camel aws2-athena
component configuration:

    from("aws2-athena://MyQuery?amazonAthenaClient=#client&...")
    .to("mock:result");

## Overriding query parameters with message headers

Message headers listed in "Message headers evaluated by the Athena
producer" override the corresponding query parameters listed in "Query
Parameters".

For example:

    from("direct:start")
         .setHeader(Athena2Constants.OUTPUT_LOCATION, constant("s3://other/location/"))
         .to("aws2-athena:label?outputLocation=s3://foo/bar/")
         .to("mock:result");

Will cause the output location to be `s3://other/location/`.

## Athena Producer Operation examples

-   getQueryExecution: this operation returns information about a query
    given its query execution ID

<!-- -->

    from("direct:start")
        .to("aws2-athena://label?operation=getQueryExecution&queryExecutionId=11111111-1111-1111-1111-111111111111")
        .to("mock:result");

The preceding example will yield an [Athena
QueryExecution](https://docs.aws.amazon.com/athena/latest/APIReference/API_QueryExecution.html)
in the body.

The getQueryExecution operation also supports retrieving the query
execution ID from a header (`CamelAwsAthenaQueryExecutionId`), and since
startQueryExecution sets the same header, upon starting a query, these
operations can be used together:

    from("direct:start")
        .setBody(constant("SELECT 1"))
        .to("aws2-athena://label?operation=startQueryExecution&outputLocation=s3://bucket/path/")
        .to("aws2-athena://label?operation=getQueryExecution")
        .to("mock:result");

The preceding example will yield an Athena QueryExecution in the body
for the query that was just started.

-   getQueryResults: this operation returns the results of a query that
    has succeeded. The results are returned in the body in one of three
    formats.

`StreamList` - the default - returns a
[GetQueryResultsIterable](https://sdk.amazonaws.com/java/api/latest/software/amazon/awssdk/services/athena/paginators/GetQueryResultsIterable.html)
in the body that can page through all results:

    from("direct:start")
        .setBody(constant("SELECT 1"))
        .to("aws2-athena://label?operation=startQueryExecution&waitTimeout=60000&outputLocation=s3://bucket/path/")
        .to("aws2-athena://label?operation=getQueryResults&outputType=StreamList")
        .to("mock:result");

The output of StreamList can be processed in various ways:

    from("direct:start")
        .setBody(constant(
            "SELECT * FROM ("
                + "    VALUES"
                + "        (1, 'a'),"
                + "        (2, 'b')"
                + ") AS t (id, name)"))
        .to("aws2-athena://label?operation=startQueryExecution&waitTimeout=60000&outputLocation=s3://bucket/path/")
        .to("aws2-athena://label?operation=getQueryResults&outputType=StreamList")
        .split(body()).streaming()
        .process(new Processor() {
    
          @Override
          public void process(Exchange exchange) {
            GetQueryResultsResponse page = exchange
                                            .getMessage()
                                            .getBody(GetQueryResultsResponse.class);
            for (Row row : page.resultSet().rows()) {
              String line = row.data()
                              .stream()
                              .map(Datum::varCharValue)
                              .collect(Collectors.joining(","));
              System.out.println(line);
            }
          }
        })
        .to("mock:result");

The preceding example will print the results of the query as CSV to the
console.

`SelectList` - returns a
[GetQueryResponse](https://sdk.amazonaws.com/java/api/latest/software/amazon/awssdk/services/athena/model/GetQueryResultsResponse.html)
in the body containing at most 1,000 rows, plus the NextToken value as a
header (`CamelAwsAthenaNextToken`), which can be used for manual
pagination of results:

    from("direct:start")
        .setBody(constant("SELECT 1"))
        .to("aws2-athena://label?operation=startQueryExecution&waitTimeout=60000&outputLocation=s3://bucket/path/")
        .to("aws2-athena://label?operation=getQueryResults&outputType=SelectList")
        .to("mock:result");

The preceding example will return a
[GetQueryResponse](https://sdk.amazonaws.com/java/api/latest/software/amazon/awssdk/services/athena/model/GetQueryResultsResponse.html)
in the body plus the NextToken value as a header
(`CamelAwsAthenaNextToken`), which can be used to manually page through
the results 1,000 rows at a time.

`S3Pointer` - return an S3 path (e.g. `s3://bucket/path/`) pointing to
the results:

    from("direct:start")
        .setBody(constant("SELECT 1"))
        .to("aws2-athena://label?operation=startQueryExecution&waitTimeout=60000&outputLocation=s3://bucket/path/")
        .to("aws2-athena://label?operation=getQueryResults&outputType=S3Pointer")
        .to("mock:result");

The preceding example will return an S3 path (e.g. `s3://bucket/path/`)
in the body pointing to the results. The path will also be set in a
header (`CamelAwsAthenaOutputLocation`).

-   listQueryExecutions: this operation returns a list of query
    execution IDs

<!-- -->

    from("direct:start")
        .to("aws2-athena://label?operation=listQueryExecutions")
        .to("mock:result");

The preceding example will return a list of query executions in the
body, plus the NextToken value as a header (`CamelAwsAthenaNextToken`)
than can be used for manual pagination of results.

-   startQueryExecution: this operation starts the execution of a query.
    It supports waiting for the query to complete before proceeding, and
    retrying the query based on a set of configurable failure
    conditions:

<!-- -->

    from("direct:start")
        .setBody(constant("SELECT 1"))
        .to("aws2-athena://label?operation=startQueryExecution&outputLocation=s3://bucket/path/")
        .to("mock:result");

The preceding example will start the query `SELECT 1` and configure the
results to be saved to `s3://bucket/path/`, but will not wait for the
query to complete.

    from("direct:start")
        .setBody(constant("SELECT 1"))
        .to("aws2-athena://label?operation=startQueryExecution&waitTimeout=60000&outputLocation=s3://bucket/path/")
        .to("mock:result");

The preceding example will start a query and wait up to 60 seconds for
it to reach a status that indicates it is complete (one of SUCCEEDED,
FAILED, CANCELLED, or UNKNOWN\_TO\_SDK\_VERSION). Upon failure, the
query would not be retried.

    from("direct:start")
        .setBody(constant("SELECT 1"))
        .to("aws2-athena://label?operation=startQueryExecution&waitTimeout=60000&initialDelay=10000&delay=1000&maxAttempts=3&retry=retryable&outputLocation=s3://bucket/path/")
        .to("mock:result");

The preceding example will start a query and wait up to 60 seconds for
it to reach a status that indicates it is complete (one of SUCCEEDED,
FAILED, CANCELLED, or UNKNOWN\_TO\_SDK\_VERSION). Upon failure, the
query would be automatically retried up to two more times if the failure
state indicates the query may succeed upon retry (Athena queries that
fail with states such as `GENERIC_INTERNAL_ERROR` or "resource limit
exhaustion" will sometimes succeed if retried). While waiting for the
query to complete, the query status would first be checked after an
initial delay of 10 seconds, and subsequently every 1 second until the
query completes.

## Putting it all together

    from("direct:start")
        .setBody(constant("SELECT 1"))
        .to("aws2-athena://label?waitTimeout=60000&&maxAttempts=3&retry=retryable&outputLocation=s3://bucket/path/")
        .to("aws2-athena://label?operation=getQueryResults&outputType=StreamList")
        .to("mock:result");

The preceding example will start the query and wait up to 60 seconds for
it to complete. Upon completion, getQueryResults put the results of the
query into the body of the message for further processing.

For the sake of completeness, a similar outcome could be achieved with
the following:

    from("direct:start")
        .setBody(constant("SELECT 1"))
        .to("aws2-athena://label?operation=startQueryExecution&outputLocation=s3://bucket/path/")
        .loopDoWhile(simple("${header." + Athena2Constants.QUERY_EXECUTION_STATE + "} != 'SUCCEEDED'"))
          .delay(1_000)
          .to("aws2-athena://label?operation=getQueryExecution")
        .end()
        .to("aws2-athena://label?operation=getQueryResults&outputType=StreamList")
        .to("mock:result");

Caution: the preceding example would block indefinitely, however, if the
query did not complete with a status of SUCCEEDED.

# Dependencies

Maven users will need to add the following dependency to their pom.xml.

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-aws2-athena</artifactId>
        <version>${camel-version}</version>
    </dependency>

where `${camel-version}` must be replaced by the actual version of
Camel.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configuration|The component configuration.||object|
|database|The Athena database to use.||string|
|delay|Milliseconds before the next poll for query execution status. See the section Waiting for Query Completion and Retrying Failed Queries to learn more.|2000|integer|
|initialDelay|Milliseconds before the first poll for query execution status. See the section Waiting for Query Completion and Retrying Failed Queries to learn more.|1000|integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|maxAttempts|Maximum number of times to attempt a query. Set to 1 to disable retries. See the section Waiting for Query Completion and Retrying Failed Queries to learn more.|1|integer|
|maxResults|Max number of results to return for the given operation (if supported by the Athena API endpoint). If not set, will use the Athena API default for the given operation.||integer|
|nextToken|Pagination token to use in the case where the response from the previous request was truncated.||string|
|operation|The Athena API function to call.|startQueryExecution|object|
|outputLocation|The location in Amazon S3 where query results are stored, such as s3://path/to/query/bucket/. Ensure this value ends with a forward slash.||string|
|outputType|How query results should be returned. One of StreamList (default - return a GetQueryResultsIterable that can page through all results), SelectList (returns at most 1000 rows at a time, plus a NextToken value as a header than can be used for manual pagination of results), S3Pointer (return an S3 path pointing to the results).|StreamList|object|
|queryExecutionId|The unique ID identifying the query execution.||string|
|queryString|The SQL query to run. Except for simple queries, prefer setting this as the body of the Exchange or as a header using Athena2Constants.QUERY\_STRING to avoid having to deal with URL encoding issues.||string|
|region|The region in which Athena client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example ap-east-1).||string|
|resetWaitTimeoutOnRetry|Reset the waitTimeout countdown in the event of a query retry. If set to true, potential max time spent waiting for queries is equal to waitTimeout x maxAttempts. See the section Waiting for Query Completion and Retrying Failed Queries to learn more.|true|boolean|
|retry|Optional comma separated list of error types to retry the query for. Use: 'retryable' to retry all retryable failure conditions (e.g. generic errors and resources exhausted), 'generic' to retry 'GENERIC\_INTERNAL\_ERROR' failures, 'exhausted' to retry queries that have exhausted resource limits, 'always' to always retry regardless of failure condition, or 'never' or null to never retry (default). See the section Waiting for Query Completion and Retrying Failed Queries to learn more.|never|string|
|waitTimeout|Optional max wait time in millis to wait for a successful query completion. See the section Waiting for Query Completion and Retrying Failed Queries to learn more.|0|integer|
|workGroup|The workgroup to use for running the query.||string|
|amazonAthenaClient|The AmazonAthena instance to use as the client.||object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|clientRequestToken|A unique string to ensure issues queries are idempotent. It is unlikely you will need to set this.||string|
|includeTrace|Include useful trace information at the beginning of queries as an SQL comment (prefixed with --).|false|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|proxyHost|To define a proxy host when instantiating the Athena client.||string|
|proxyPort|To define a proxy port when instantiating the Athena client.||integer|
|proxyProtocol|To define a proxy protocol when instantiating the Athena client.|HTTPS|object|
|accessKey|Amazon AWS Access Key.||string|
|encryptionOption|The encryption type to use when storing query results in S3. One of SSE\_S3, SSE\_KMS, or CSE\_KMS.||object|
|kmsKey|For SSE-KMS and CSE-KMS, this is the KMS key ARN or ID.||string|
|profileCredentialsName|If using a profile credentials provider this parameter will set the profile name||string|
|secretKey|Amazon AWS Secret Key.||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume an IAM role||string|
|useDefaultCredentialsProvider|Set whether the Athena client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in|false|boolean|
|useProfileCredentialsProvider|Set whether the Athena client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the Athena client should expect to use Session Credentials. This is useful in a situation in which the user needs to assume a IAM role for doing operations in Athena.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|label|Logical name||string|
|database|The Athena database to use.||string|
|delay|Milliseconds before the next poll for query execution status. See the section Waiting for Query Completion and Retrying Failed Queries to learn more.|2000|integer|
|initialDelay|Milliseconds before the first poll for query execution status. See the section Waiting for Query Completion and Retrying Failed Queries to learn more.|1000|integer|
|maxAttempts|Maximum number of times to attempt a query. Set to 1 to disable retries. See the section Waiting for Query Completion and Retrying Failed Queries to learn more.|1|integer|
|maxResults|Max number of results to return for the given operation (if supported by the Athena API endpoint). If not set, will use the Athena API default for the given operation.||integer|
|nextToken|Pagination token to use in the case where the response from the previous request was truncated.||string|
|operation|The Athena API function to call.|startQueryExecution|object|
|outputLocation|The location in Amazon S3 where query results are stored, such as s3://path/to/query/bucket/. Ensure this value ends with a forward slash.||string|
|outputType|How query results should be returned. One of StreamList (default - return a GetQueryResultsIterable that can page through all results), SelectList (returns at most 1000 rows at a time, plus a NextToken value as a header than can be used for manual pagination of results), S3Pointer (return an S3 path pointing to the results).|StreamList|object|
|queryExecutionId|The unique ID identifying the query execution.||string|
|queryString|The SQL query to run. Except for simple queries, prefer setting this as the body of the Exchange or as a header using Athena2Constants.QUERY\_STRING to avoid having to deal with URL encoding issues.||string|
|region|The region in which Athena client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example ap-east-1).||string|
|resetWaitTimeoutOnRetry|Reset the waitTimeout countdown in the event of a query retry. If set to true, potential max time spent waiting for queries is equal to waitTimeout x maxAttempts. See the section Waiting for Query Completion and Retrying Failed Queries to learn more.|true|boolean|
|retry|Optional comma separated list of error types to retry the query for. Use: 'retryable' to retry all retryable failure conditions (e.g. generic errors and resources exhausted), 'generic' to retry 'GENERIC\_INTERNAL\_ERROR' failures, 'exhausted' to retry queries that have exhausted resource limits, 'always' to always retry regardless of failure condition, or 'never' or null to never retry (default). See the section Waiting for Query Completion and Retrying Failed Queries to learn more.|never|string|
|waitTimeout|Optional max wait time in millis to wait for a successful query completion. See the section Waiting for Query Completion and Retrying Failed Queries to learn more.|0|integer|
|workGroup|The workgroup to use for running the query.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|amazonAthenaClient|The AmazonAthena instance to use as the client.||object|
|clientRequestToken|A unique string to ensure issues queries are idempotent. It is unlikely you will need to set this.||string|
|includeTrace|Include useful trace information at the beginning of queries as an SQL comment (prefixed with --).|false|boolean|
|proxyHost|To define a proxy host when instantiating the Athena client.||string|
|proxyPort|To define a proxy port when instantiating the Athena client.||integer|
|proxyProtocol|To define a proxy protocol when instantiating the Athena client.|HTTPS|object|
|accessKey|Amazon AWS Access Key.||string|
|encryptionOption|The encryption type to use when storing query results in S3. One of SSE\_S3, SSE\_KMS, or CSE\_KMS.||object|
|kmsKey|For SSE-KMS and CSE-KMS, this is the KMS key ARN or ID.||string|
|profileCredentialsName|If using a profile credentials provider this parameter will set the profile name||string|
|secretKey|Amazon AWS Secret Key.||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume an IAM role||string|
|useDefaultCredentialsProvider|Set whether the Athena client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in|false|boolean|
|useProfileCredentialsProvider|Set whether the Athena client should expect to load credentials through a profile credentials provider.|false|boolean|
|useSessionCredentials|Set whether the Athena client should expect to use Session Credentials. This is useful in a situation in which the user needs to assume a IAM role for doing operations in Athena.|false|boolean|
