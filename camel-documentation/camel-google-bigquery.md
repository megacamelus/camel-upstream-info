# Google-bigquery

**Since Camel 2.20**

**Only producer is supported**

The Google Bigquery component provides access to [Cloud BigQuery
Infrastructure](https://cloud.google.com/bigquery/) via the [Google
Client Services
API](https://developers.google.com/api-client-library/java/apis/bigquery/v2).

The current implementation does not use gRPC.

The current implementation does not support querying BigQuery, i.e., is
a producer only.

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
GCP Service Accounts. For more information, please refer to [Google
Cloud Platform Auth Guide](https://cloud.google.com/docs/authentication)

Google security credentials can be set explicitly by providing the path
to the GCP credentials file location.

Or they are set implicitly, where the connection factory falls back on
[Application Default
Credentials](https://developers.google.com/identity/protocols/application-default-credentials#howtheywork).

When you have the **service account key**, you can provide
authentication credentials to your application code. Google security
credentials can be set through the component endpoint:

    String endpoint = "google-bigquery://project-id:datasetId[:tableId]?serviceAccountKey=/home/user/Downloads/my-key.json";

You can also use the base64 encoded content of the authentication
credentials file if you don’t want to set a file system path.

    String endpoint = "google-bigquery://project-id:datasetId[:tableId]?serviceAccountKey=base64:<base64 encoded>";

Or by setting the environment variable `GOOGLE_APPLICATION_CREDENTIALS`
:

    export GOOGLE_APPLICATION_CREDENTIALS="/home/user/Downloads/my-key.json"

# URI Format

    google-bigquery://project-id:datasetId[:tableId]?[options]

# Producer Endpoints

Producer endpoints can accept and deliver to BigQuery individual and
grouped exchanges alike. Grouped exchanges have
`Exchange.GROUPED_EXCHANGE` property set.

Google BigQuery producer will send a grouped exchange in a single api
call unless different table suffix or partition decorators are
specified. In that case, it will break it down to ensure data is written
with the correct suffix or partition decorator.

Google BigQuery endpoint expects the payload to be either a map or list
of maps. A payload containing a map will insert a single row, and a
payload containing a list of maps will insert a row for each entry in
the list.

# Template tables

Reference:
[https://cloud.google.com/bigquery/streaming-data-into-bigquery#template-tables](https://cloud.google.com/bigquery/streaming-data-into-bigquery#template-tables)

Templated tables can be specified using the
`GoogleBigQueryConstants.TABLE_SUFFIX` header.

I.e. the following route will create tables and insert records sharded
on a per-day basis:

    from("direct:start")
      .header(GoogleBigQueryConstants.TABLE_SUFFIX, "_${date:now:yyyyMMdd}")
      .to("google-bigquery:sampleDataset:sampleTable")

Note it is recommended to use partitioning for this use case.

# Partitioning

Reference:
[https://cloud.google.com/bigquery/docs/creating-partitioned-tables](https://cloud.google.com/bigquery/docs/creating-partitioned-tables)

Partitioning is specified when creating a table and if set data will be
automatically partitioned into separate tables. When inserting data a
specific partition can be specified by setting the
`GoogleBigQueryConstants.PARTITION_DECORATOR` header on the exchange.

# Ensuring data consistency

Reference:
[https://cloud.google.com/bigquery/streaming-data-into-bigquery#dataconsistency](https://cloud.google.com/bigquery/streaming-data-into-bigquery#dataconsistency)

An insert id can be set on the exchange with the header
`GoogleBigQueryConstants.INSERT_ID` or by specifying query parameter
`useAsInsertId`. As an insert id need to be specified per row inserted
the exchange header can’t be used when the payload is a list. If the
payload is a list the `GoogleBigQueryConstants.INSERT_ID` will be
ignored. In that case use the query parameter `useAsInsertId`.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|connectionFactory|ConnectionFactory to obtain connection to Bigquery Service. If not provided the default one will be used||object|
|datasetId|BigQuery Dataset Id||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|projectId|Google Cloud Project Id||string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|projectId|Google Cloud Project Id||string|
|datasetId|BigQuery Dataset Id||string|
|tableId|BigQuery table id||string|
|connectionFactory|ConnectionFactory to obtain connection to Bigquery Service. If not provided the default one will be used||object|
|useAsInsertId|Field name to use as insert id||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|serviceAccountKey|Service account key in json format to authenticate an application as a service account to google cloud platform||string|
