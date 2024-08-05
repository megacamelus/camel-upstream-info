# Google-bigquery-sql

**Since Camel 2.23**

**Only producer is supported**

The Google BigQuery SQL component provides access to [Cloud BigQuery
Infrastructure](https://cloud.google.com/bigquery/) via the [Google
Client Services
API](https://developers.google.com/apis-explorer/#p/bigquery/v2/bigquery.jobs.query).

The current implementation supports only standard SQL [DML
queries](https://cloud.google.com/bigquery/docs/reference/standard-sql/dml-syntax).

Maven users will need to add the following dependency to their pom.xml
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-google-bigquery</artifactId>
        <!-- use the same version as your Camel core version -->
        <version>x.x.x</version>
    </dependency>

# Authentication Configuration

Google BigQuery component authentication is targeted for use with the
GCP Service Accounts. For more information please refer to [Google Cloud
Platform Auth Guide](https://cloud.google.com/docs/authentication)

Google security credentials can be set explicitly by providing the path
to the GCP credentials file location.

Or they are set implicitly, where the connection factory falls back on
[Application Default
Credentials](https://developers.google.com/identity/protocols/application-default-credentials#howtheywork).

When you have the **service account key** you can provide authentication
credentials to your application code. Google security credentials can be
set through the component endpoint:

    String endpoint = "google-bigquery-sql://project-id:query?serviceAccountKey=/home/user/Downloads/my-key.json";

You can also use the base64 encoded content of the authentication
credentials file if you don’t want to set a file system path.

    String endpoint = "google-bigquery-sql://project-id:query?serviceAccountKey=base64:<base64 encoded>";

Or by setting the environment variable `GOOGLE_APPLICATION_CREDENTIALS`
:

    export GOOGLE_APPLICATION_CREDENTIALS="/home/user/Downloads/my-key.json"

# URI Format

    google-bigquery-sql://project-id:query?[options]

Examples:

    google-bigquery-sql://project-17248459:delete * from test.table where id=@myId
    
    google-bigquery-sql://project-17248459:delete * from ${datasetId}.${tableId} where id=@myId

where

-   parameters in form ${name} are extracted from message headers and
    formed the translated query.

-   parameters in form @name are extracted from body or message headers
    and sent to Google Bigquery. The
    `com.google.cloud.bigquery.StandardSQLTypeName` of the parameter is
    detected from the type of the parameter using
    `<T> QueryParameterValue<T>.of(T value, Class<T> type)`

You can externalize your SQL queries to files in the classpath or file
system as shown:

    google-bigquery-sql://project-17248459::classpath:delete.sql

# Producer Endpoints

Google BigQuery SQL endpoint expects the payload to be either empty or a
map of query parameters.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|connectionFactory|ConnectionFactory to obtain connection to Bigquery Service. If not provided the default one will be used||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|projectId|Google Cloud Project Id||string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|projectId|Google Cloud Project Id||string|
|queryString|BigQuery standard SQL query||string|
|connectionFactory|ConnectionFactory to obtain connection to Bigquery Service. If not provided the default one will be used||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|serviceAccountKey|Service account key in json format to authenticate an application as a service account to google cloud platform||string|
