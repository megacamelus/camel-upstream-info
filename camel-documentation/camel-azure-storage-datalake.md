# Azure-storage-datalake

**Since Camel 3.8**

**Both producer and consumer are supported**

The Azure storage datalake component is used for storing and retrieving
file from Azure Storage Data Lake Service using the **Azure APIs v12**.

Prerequisites

You need to have a valid Azure account with Azure storage set up. More
information can be found at [Azure Documentation
Portal](https://docs.microsoft.com/azure/).

Maven users will need to add the following dependency to their `pom.xml`
for this component.

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-azure-storage-datalake</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your camel core version -->
    </dependency>

# Uri Format

    azure-storage-datalake:accountName[/fileSystemName][?options]

In the case of the consumer, both `accountName` and `fileSystemName` are
required. In the case of the producer, it depends on the operation being
requested.

You can append query options to the URI in the following format:
`?option1=value&option2=value&...`

## Methods of authentication

To use this component, you will have to provide at least one of the
specific credentialType parameters:

-   `SHARED_KEY_CREDENTIAL`: Provide `accountName` and `accessKey` for
    your azure account or provide StorageSharedKeyCredential instance
    which can be provided into `sharedKeyCredential` option.

-   `CLIENT_SECRET`: Provide ClientSecretCredential instance which can
    be provided into `clientSecretCredential` option or provide
    `accountName`, `clientId`, `clientSecret` and `tenantId` for
    authentication with Azure Active Directory.

-   `SERVICE_CLIENT_INSTANCE`: Provide a DataLakeServiceClient instance
    which can be provided into `serviceClient` option.

-   `AZURE_IDENTITY`: Use the Default Azure Credential Provider Chain

-   `AZURE_SAS`: Provide `sasSignature` or `sasCredential` parameters to
    use SAS mechanism

The default is `CLIENT_SECRET`.

# Usage

For example, to download content from file `test.txt` located on the
`filesystem` in `camelTesting` storage account, use the following
snippet:

    from("azure-storage-datalake:camelTesting/filesystem?fileName=test.txt&accountKey=key").
    to("file://fileDirectory");

## Automatic detection of a service client

The component is capable of automatically detecting the presence of a
DataLakeServiceClient bean in the registry. Hence, if your registry has
only one instance of type DataLakeServiceClient, it will be
automatically used as the default client. You won’t have to explicitly
define it as an uri parameter.

## Azure Storage DataLake Producer Operations

The various operations supported by Azure Storage DataLake are as given
below:

**Operations on Service level**

For these operations, `accountName` option is required

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Operation</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>listFileSystem</code></p></td>
<td style="text-align: left;"><p>List all the file systems that are
present in the given azure account.</p></td>
</tr>
</tbody>
</table>

**Operations on File system level**

For these operations, `accountName` and `fileSystemName` options are
required

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Operation</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>createFileSystem</code></p></td>
<td style="text-align: left;"><p>Create a new file System with the
storage account</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>deleteFileSystem</code></p></td>
<td style="text-align: left;"><p>Delete the specified file system within
the storage account</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>listPaths</code></p></td>
<td style="text-align: left;"><p>Returns list of all the files within
the given path in the given file system, with folder structure
flattened</p></td>
</tr>
</tbody>
</table>

**Operations on Directory level**

For these operations, `accountName`, `fileSystemName` and
`directoryName` options are required

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Operation</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>createFile</code></p></td>
<td style="text-align: left;"><p>Create a new file in the specified
directory within the fileSystem</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>deleteDirectory</code></p></td>
<td style="text-align: left;"><p>Delete the specified directory within
the file system</p></td>
</tr>
</tbody>
</table>

**Operations on file level**

For these operations, `accountName`, `fileSystemName` and `fileName`
options are required

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Operation</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>getFile</code></p></td>
<td style="text-align: left;"><p>Get the contents of a file</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>downloadToFile</code></p></td>
<td style="text-align: left;"><p>Download the entire file from the file
system into a path specified by fileDir.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>downloadLink</code></p></td>
<td style="text-align: left;"><p>Generate a download link for the
specified file using Shared Access Signature (SAS). The expiration time
to be set for the link can be specified otherwise 1 hour is taken as
default.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>deleteFile</code></p></td>
<td style="text-align: left;"><p>Delete the specified file.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>appendToFile</code></p></td>
<td style="text-align: left;"><p>Appends the data passed to the
specified file in the file System. Flush command is required after
append.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>flushToFile</code></p></td>
<td style="text-align: left;"><p>Flushes the data already appended to
the specified file.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>openQueryInputStream</code></p></td>
<td style="text-align: left;"><p>Opens an <code>InputStream</code> based
on the query passed to the endpoint. For this operation, you must first
register the query acceleration feature with your subscription.</p></td>
</tr>
</tbody>
</table>

Refer to the examples section below for more details on how to use these
operations

# Examples

## Consumer Examples

To consume a file from the storage datalake into a file using the file
component, this can be done like this:

    from("azure-storage-datalake":cameltesting/filesystem?fileName=test.txt&accountKey=yourAccountKey").
    to("file:/filelocation");

You can also directly write to a file without using the file component.
For this, you will need to specify the path in `fileDir` option, to save
it to your machine.

    from("azure-storage-datalake":cameltesting/filesystem?fileName=test.txt&accountKey=yourAccountKey&fileDir=/test/directory").
    to("mock:results");

This component also supports batch consumer. So, you can consume
multiple files from a file system by specifying the path from where you
want to consume the files.

    from("azure-storage-datalake":cameltesting/filesystem?accountKey=yourAccountKey&fileDir=/test/directory&path=abc/test").
    to("mock:results");

## Producer Examples

-   `listFileSystem`

<!-- -->

    from("direct:start")
        .process(exchange -> {
            //required headers can be added here
            exchange.getIn().setHeader(DataLakeConstants.LIST_FILESYSTEMS_OPTIONS, new ListFileSystemsOptions().setMaxResultsPerPage(10));
        })
        .to("azure-storage-datalake:cameltesting?operation=listFileSystem&dataLakeServiceClient=#serviceClient")
        .to("mock:results");

-   `createFileSystem`

<!-- -->

    from("direct:start")
        .process(exchange -> {
            exchange.getIn().setHeader(DataLakeConstants.FILESYSTEM_NAME, "test1");
        })
        .to("azure-storage-datalake:cameltesting?operation=createFileSystem&dataLakeServiceClient=#serviceClient")
        .to("mock:results");

-   `deleteFileSystem`

<!-- -->

    from("direct:start")
        .process(exchange -> {
            exchange.getIn().setHeader(DataLakeConstants.FILESYSTEM_NAME, "test1");
        })
        .to("azure-storage-datalake:cameltesting?operation=deleteFileSystem&dataLakeServiceClient=#serviceClient")
        .to("mock:results");

-   `listPaths`

<!-- -->

    from("direct:start")
        .process(exchange -> {
            exchange.getIn().setHeader(DataLakeConstants.LIST_PATH_OPTIONS, new ListPathsOptions().setPath("/main"));
        })
        .to("azure-storage-datalake:cameltesting/filesystem?operation=listPaths&dataLakeServiceClient=#serviceClient")
        .to("mock:results");

-   `getFile`

This can be done in two ways, We can either set an `OutputStream` in the
exchange body

    from("direct:start")
        .process(exchange -> {
            // set an OutputStream where the file data can should be written
            exchange.getIn().setBody(outputStream);
        })
        .to("azure-storage-datalake:cameltesting/filesystem?operation=getFile&fileName=test.txt&dataLakeServiceClient=#serviceClient")
        .to("mock:results");

Or if the body is not set, the operation will give an `InputStream`,
given that you have already registered for query acceleration in azure
portal.

    from("direct:start")
        .to("azure-storage-datalake:cameltesting/filesystem?operation=getFile&fileName=test.txt&dataLakeServiceClient=#serviceClient")
        .process(exchange -> {
            InputStream inputStream = exchange.getMessage().getBody(InputStream.class);
            System.out.Println(IOUtils.toString(inputStream, StandardCharcets.UTF_8.name()));
        })
        .to("mock:results");

-   `deleteFile`

<!-- -->

    from("direct:start")
        .to("azure-storage-datalake:cameltesting/filesystem?operation=deleteFile&fileName=test.txt&dataLakeServiceClient=#serviceClient")
        .to("mock:results");

-   `downloadToFile`

<!-- -->

    from("direct:start")
        .to("azure-storage-datalake:cameltesting/filesystem?operation=downloadToFile&fileName=test.txt&fileDir=/test/mydir&dataLakeServiceClient=#serviceClient")
        .to("mock:results");

-   `downloadLink`

<!-- -->

    from("direct:start")
        .to("azure-storage-datalake:cameltesting/filesystem?operation=downloadLink&fileName=test.txt&dataLakeServiceClient=#serviceClient")
        .process(exchange -> {
            String link = exchange.getMessage().getBody(String.class);
            System.out.println(link);
        })
        .to("mock:results");

-   `appendToFile`

<!-- -->

    from("direct:start")
        .process(exchange -> {
            final String data = "test data";
            final InputStream inputStream = new ByteArrayInputStream(data.getBytes(StandardCharsets.UTF_8));
            exchange.getIn().setBody(inputStream);
        })
        .to("azure-storage-datalake:cameltesting/filesystem?operation=appendToFile&fileName=test.txt&dataLakeServiceClient=#serviceClient")
        .to("mock:results");

-   `flushToFile`

<!-- -->

    from("direct:start")
        .process(exchange -> {
            exchange.getIn().setHeader(DataLakeConstants.POSITION, 0);
        })
        .to("azure-storage-datalake:cameltesting/filesystem?operation=flushToFile&fileName=test.txt&dataLakeServiceClient=#serviceClient")
        .to("mock:results");

-   `openQueryInputStream`

For this operation, you should have already registered for query
acceleration on the azure portal

    from("direct:start")
        .process(exchange -> {
            exchange.getIn().setHeader(DataLakeConstants.QUERY_OPTIONS, new FileQueryOptions("SELECT * from BlobStorage"));
        })
        .to("azure-storage-datalake:cameltesting/filesystem?operation=openQueryInputStream&fileName=test.txt&dataLakeServiceClient=#serviceClient")
        .to("mock:results");

-   `upload`

<!-- -->

    from("direct:start")
        .process(exchange -> {
            final String data = "test data";
            final InputStream inputStream = new ByteArrayInputStream(data.getBytes(StandardCharsets.UTF_8));
            exchange.getIn().setBody(inputStream);
        })
        .to("azure-storage-datalake:cameltesting/filesystem?operation=upload&fileName=test.txt&dataLakeServiceClient=#serviceClient")
        .to("mock:results");

-   `uploadFromFile`

<!-- -->

    from("direct:start")
        .process(exchange -> {
            exchange.getIn().setHeader(DataLakeConstants.PATH, "test/file.txt");
        })
        .to("azure-storage-datalake:cameltesting/filesystem?operation=uploadFromFile&fileName=test.txt&dataLakeServiceClient=#serviceClient")
        .to("mock:results");

-   `createFile`

<!-- -->

    from("direct:start")
        .process(exchange -> {
            exchange.getIn().setHeader(DataLakeConstants.DIRECTORY_NAME, "test/file/");
        })
        .to("azure-storage-datalake:cameltesting/filesystem?operation=createFile&fileName=test.txt&dataLakeServiceClient=#serviceClient")
        .to("mock:results");

-   `deleteDirectory`

<!-- -->

    from("direct:start")
        .process(exchange -> {
            exchange.getIn().setHeader(DataLakeConstants.DIRECTORY_NAME, "test/file/");
        })
        .to("azure-storage-datalake:cameltesting/filesystem?operation=deleteDirectory&dataLakeServiceClient=#serviceClient")
        .to("mock:results");

## Testing

Please run all the unit tests and integration tests while making changes
to the component as changes or version upgrades can break things. For
running all the tests in the component, you will need to obtain azure
`accountName` and `accessKey`. After obtaining the same, you can run the
full test on this component directory by running the following maven
command

    mvn verify -Dazure.storage.account.name=<accountName> -Dazure.storage.account.key=<accessKey>

You can also skip the integration test and run only basic unit test by
using the command

    mvn test

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|clientId|client id for azure account||string|
|close|Whether or not a file changed event raised indicates completion (true) or modification (false)||boolean|
|closeStreamAfterRead|check for closing stream after read||boolean|
|configuration|configuration object for data lake||object|
|credentialType|Determines the credential strategy to adopt|CLIENT\_SECRET|object|
|dataCount|count number of bytes to download||integer|
|directoryName|directory of the file to be handled in component||string|
|downloadLinkExpiration|download link expiration time||integer|
|expression|expression for queryInputStream||string|
|fileDir|directory of file to do operations in the local system||string|
|fileName|name of file to be handled in component||string|
|fileOffset|offset position in file for different operations||integer|
|maxResults|maximum number of results to show at a time||integer|
|maxRetryRequests|no of retries to a given request||integer|
|openOptions|set open options for creating file||object|
|path|path in azure data lake for operations||string|
|permission|permission string for the file||string|
|position|This parameter allows the caller to upload data in parallel and control the order in which it is appended to the file.||integer|
|recursive|recursively include all paths||boolean|
|regex|regular expression for matching file names||string|
|retainUncommitedData|Whether or not uncommitted data is to be retained after the operation||boolean|
|serviceClient|data lake service client for azure storage data lake||object|
|sharedKeyCredential|shared key credential for azure data lake gen2||object|
|tenantId|tenant id for azure account||string|
|timeout|Timeout for operation||object|
|umask|umask permission for file||string|
|userPrincipalNameReturned|whether or not to use upn||boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|operation|operation to be performed|listFileSystem|object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|accountKey|account key for authentication||string|
|clientSecret|client secret for azure account||string|
|clientSecretCredential|client secret credential for authentication||object|
|sasCredential|SAS token credential||object|
|sasSignature|SAS token signature||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|accountName|name of the azure account||string|
|fileSystemName|name of filesystem to be used||string|
|clientId|client id for azure account||string|
|close|Whether or not a file changed event raised indicates completion (true) or modification (false)||boolean|
|closeStreamAfterRead|check for closing stream after read||boolean|
|credentialType|Determines the credential strategy to adopt|CLIENT\_SECRET|object|
|dataCount|count number of bytes to download||integer|
|dataLakeServiceClient|service client of data lake||object|
|directoryName|directory of the file to be handled in component||string|
|downloadLinkExpiration|download link expiration time||integer|
|expression|expression for queryInputStream||string|
|fileDir|directory of file to do operations in the local system||string|
|fileName|name of file to be handled in component||string|
|fileOffset|offset position in file for different operations||integer|
|maxResults|maximum number of results to show at a time||integer|
|maxRetryRequests|no of retries to a given request||integer|
|openOptions|set open options for creating file||object|
|path|path in azure data lake for operations||string|
|permission|permission string for the file||string|
|position|This parameter allows the caller to upload data in parallel and control the order in which it is appended to the file.||integer|
|recursive|recursively include all paths||boolean|
|regex|regular expression for matching file names||string|
|retainUncommitedData|Whether or not uncommitted data is to be retained after the operation||boolean|
|serviceClient|data lake service client for azure storage data lake||object|
|sharedKeyCredential|shared key credential for azure data lake gen2||object|
|tenantId|tenant id for azure account||string|
|timeout|Timeout for operation||object|
|umask|umask permission for file||string|
|userPrincipalNameReturned|whether or not to use upn||boolean|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|operation|operation to be performed|listFileSystem|object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
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
|accountKey|account key for authentication||string|
|clientSecret|client secret for azure account||string|
|clientSecretCredential|client secret credential for authentication||object|
|sasCredential|SAS token credential||object|
|sasSignature|SAS token signature||string|
