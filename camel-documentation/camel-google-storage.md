# Google-storage

**Since Camel 3.9**

**Both producer and consumer are supported**

The Google Storage component provides access to [Google Cloud
Storage](https://cloud.google.com/storage/) via the [Google java storage
library](https://github.com/googleapis/java-storage).

Maven users will need to add the following dependency to their pom.xml
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-google-storage</artifactId>
        <!-- use the same version as your Camel core version -->
        <version>x.x.x</version>
    </dependency>

# Authentication Configuration

Google Storage component authentication is targeted for use with the GCP
Service Accounts. For more information, please refer to [Google Storage
Auth
Guide](https://cloud.google.com/storage/docs/reference/libraries#setting_up_authentication).

When you have the **service account key**, you can provide
authentication credentials to your application code. Google security
credentials can be set through the component endpoint:

    String endpoint = "google-storage://myCamelBucket?serviceAccountKey=/home/user/Downloads/my-key.json";

Or by providing the path to the GCP credentials file location:

Provide authentication credentials to your application code by setting
the environment variable `GOOGLE_APPLICATION_CREDENTIALS` :

    export GOOGLE_APPLICATION_CREDENTIALS="/home/user/Downloads/my-key.json"

# URI Format

    google-storage://bucketNameOrArn?[options]

By default, the bucket will be created if it doesn’t already exist. You
can append query options to the URI in the following format:
`?options=value&option2=value&...`

For example, to read file `hello.txt` from bucket `myCamelBucket`, use
the following snippet:

    from("google-storage://myCamelBucket?serviceAccountKey=/home/user/Downloads/my-key.json&objectName=hello.txt")
      .to("file:/var/downloaded");

# Usage

## Google Storage Producer operations

Google Storage component provides the following operations on the
producer side:

-   `copyObject`

-   `listObjects`

-   `deleteObject`

-   `deleteBucket`

-   `listBuckets`

-   `getObject`

-   `createDownloadLink`

If you don’t specify an operation explicitly, the producer will a file
upload.

## Advanced component configuration

If you need to have more control over the `storageClient` instance
configuration, you can create your own instance and refer to it in your
Camel google-storage component configuration:

    from("google-storage://myCamelBucket?storageClient=#client")
    .to("mock:result");

## Google Storage Producer Operation examples

-   File Upload: This operation will upload a file to the Google Storage
    based on the body content

<!-- -->

    //upload a file
    byte[] payload = "Camel rocks!".getBytes();
    ByteArrayInputStream bais = new ByteArrayInputStream(payload);
    from("direct:start")
    .process( exchange -> {
        exchange.getIn().setHeader(GoogleCloudStorageConstants.OBJECT_NAME, "camel.txt");
        exchange.getIn().setBody(bais);
    })
    .to("google-storage://myCamelBucket?serviceAccountKey=/home/user/Downloads/my-key.json")
    .log("uploaded file object:${header.CamelGoogleCloudStorageObjectName}, body:${body}");

This operation will upload the file `camel.txt` with the content
`"Camel rocks!"` in the myCamelBucket bucket

-   `CopyObject`: this operation copies an object from one bucket to a
    different one

<!-- -->

      from("direct:start").process( exchange -> {
        exchange.getIn().setHeader(GoogleCloudStorageConstants.OPERATION, GoogleCloudStorageOperations.copyObject);
        exchange.getIn().setHeader(GoogleCloudStorageConstants.OBJECT_NAME, "camel.txt" );
        exchange.getIn().setHeader(GoogleCloudStorageConstants.DESTINATION_BUCKET_NAME, "myCamelBucket_dest");
        exchange.getIn().setHeader(GoogleCloudStorageConstants.DESTINATION_OBJECT_NAME, "camel_copy.txt");
      })
      .to("google-storage://myCamelBucket?serviceAccountKey=/home/user/Downloads/my-key.json")
      .to("mock:result");

This operation will copy the object with the name expressed in the
header DESTINATION\_OBJECT\_NAME to the DESTINATION\_BUCKET\_NAME
bucket, from the bucket myCamelBucket.

-   `DeleteObject`: this operation deletes an object from a bucket

<!-- -->

      from("direct:start").process( exchange -> {
        exchange.getIn().setHeader(GoogleCloudStorageConstants.OPERATION, GoogleCloudStorageOperations.deleteObject);
        exchange.getIn().setHeader(GoogleCloudStorageConstants.OBJECT_NAME, "camel.txt" );
      })
      .to("google-storage://myCamelBucket?serviceAccountKey=/home/user/Downloads/my-key.json")
      .to("mock:result");

This operation will delete the object from the bucket myCamelBucket.

-   `ListBuckets`: this operation lists the buckets for this account in
    this region

<!-- -->

    from("direct:start")
    .to("google-storage://myCamelBucket?serviceAccountKey=/home/user/Downloads/my-key.json&operation=listBuckets")
    .to("mock:result");

This operation will list the buckets for this account.

-   `DeleteBucket`: this operation deletes the bucket specified as URI
    parameter or header

<!-- -->

    from("direct:start")
    .to("google-storage://myCamelBucket?serviceAccountKey=/home/user/Downloads/my-key.json&operation=deleteBucket")
    .to("mock:result");

This operation will delete the bucket myCamelBucket.

-   `ListObjects`: this operation list object in a specific bucket

<!-- -->

    from("direct:start")
    .to("google-storage://myCamelBucket?serviceAccountKey=/home/user/Downloads/my-key.json&operation=listObjects")
    .to("mock:result");

This operation will list the objects in the myCamelBucket bucket.

-   `GetObject`: this operation gets a single object in a specific
    bucket

<!-- -->

    from("direct:start")
    .process( exchange -> {
      exchange.getIn().setHeader(GoogleCloudStorageConstants.OBJECT_NAME, "camel.txt");
    })
    .to("google-storage://myCamelBucket?serviceAccountKey=/home/user/Downloads/my-key.json&operation=getObject")
    .to("mock:result");

This operation will return a Blob object instance related to the
`OBJECT_NAME` object in `myCamelBucket` bucket.

-   `CreateDownloadLink`: this operation will return a download link

<!-- -->

    from("direct:start")
    .process( exchange -> {
      exchange.getIn().setHeader(GoogleCloudStorageConstants.OBJECT_NAME, "camel.txt" );
      exchange.getIn().setHeader(GoogleCloudStorageConstants.DOWNLOAD_LINK_EXPIRATION_TIME, 86400000L); //1 day
    })
    .to("google-storage://myCamelBucket?serviceAccountKey=/home/user/Downloads/my-key.json&operation=createDownloadLink")
    .to("mock:result");

This operation will return a download link url for the file OBJECT\_NAME
in the bucket myCamelBucket. It’s possible to specify the expiration
time for the created link through the header
DOWNLOAD\_LINK\_EXPIRATION\_TIME. If not specified, by default it is 5
minutes.

## Bucket Auto creation

With the option `autoCreateBucket` users are able to avoid the
autocreation of a Bucket in case it doesn’t exist. The default for this
option is `true`. If set to false, any operation on a not-existent
bucket won’t be successful and an error will be returned.

## MoveAfterRead consumer option

In addition to `deleteAfterRead` it has been added another option,
`moveAfterRead`. With this option enabled the consumed object will be
moved to a target `destinationBucket` instead of being only deleted.
This will require specifying the destinationBucket option. As example:

      from("google-storage://myCamelBucket?serviceAccountKey=/home/user/Downloads/my-key.json"
        + "&autoCreateBucket=true"
        + "&destinationBucket=myCamelProcessedBucket"
        + "&moveAfterRead=true"
        + "&deleteAfterRead=true"
        + "&includeBody=true"
      )
      .to("mock:result");

In this case, the objects consumed will be moved to
myCamelProcessedBucket bucket and deleted from the original one (because
of deleteAfterRead).

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|autoCreateBucket|Setting the autocreation of the bucket bucketName.|true|boolean|
|configuration|The component configuration||object|
|serviceAccountKey|The Service account key that can be used as credentials for the Storage client. It can be loaded by default from classpath, but you can prefix with classpath:, file:, or http: to load the resource from different systems.||string|
|storageClass|The Cloud Storage class to use when creating the new buckets|STANDARD|object|
|storageClient|The storage client||object|
|storageLocation|The Cloud Storage location to use when creating the new buckets|US-EAST1|string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|deleteAfterRead|Delete objects from the bucket after they have been retrieved. The delete is only performed if the Exchange is committed. If a rollback occurs, the object is not deleted. If this option is false, then the same objects will be retrieve over and over again on the polls.|true|boolean|
|destinationBucket|Define the destination bucket where an object must be moved when moveAfterRead is set to true.||string|
|downloadFileName|The folder or filename to use when downloading the blob. By default, this specifies the folder name, and the name of the file is the blob name. For example, setting this to mydownload will be the same as setting mydownload/${file:name}. You can use dynamic expressions for fine-grained control. For example, you can specify ${date:now:yyyyMMdd}/${file:name} to store the blob in sub folders based on today's day. Only ${file:name} and ${file:name.noext} is supported as dynamic tokens for the blob name.||string|
|filter|A regular expression to include only blobs with name matching it.||string|
|includeBody|If it is true, the Object exchange will be consumed and put into the body. If false the Object stream will be put raw into the body and the headers will be set with the object metadata.|true|boolean|
|includeFolders|If it is true, the folders/directories will be consumed. If it is false, they will be ignored, and Exchanges will not be created for those|true|boolean|
|moveAfterRead|Move objects from the origin bucket to a different bucket after they have been retrieved. To accomplish the operation the destinationBucket option must be set. The copy bucket operation is only performed if the Exchange is committed. If a rollback occurs, the object is not moved.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|objectName|The Object name inside the bucket||string|
|operation|Set the operation for the producer||object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bucketName|Bucket name or ARN||string|
|autoCreateBucket|Setting the autocreation of the bucket bucketName.|true|boolean|
|serviceAccountKey|The Service account key that can be used as credentials for the Storage client. It can be loaded by default from classpath, but you can prefix with classpath:, file:, or http: to load the resource from different systems.||string|
|storageClass|The Cloud Storage class to use when creating the new buckets|STANDARD|object|
|storageClient|The storage client||object|
|storageLocation|The Cloud Storage location to use when creating the new buckets|US-EAST1|string|
|deleteAfterRead|Delete objects from the bucket after they have been retrieved. The delete is only performed if the Exchange is committed. If a rollback occurs, the object is not deleted. If this option is false, then the same objects will be retrieve over and over again on the polls.|true|boolean|
|destinationBucket|Define the destination bucket where an object must be moved when moveAfterRead is set to true.||string|
|downloadFileName|The folder or filename to use when downloading the blob. By default, this specifies the folder name, and the name of the file is the blob name. For example, setting this to mydownload will be the same as setting mydownload/${file:name}. You can use dynamic expressions for fine-grained control. For example, you can specify ${date:now:yyyyMMdd}/${file:name} to store the blob in sub folders based on today's day. Only ${file:name} and ${file:name.noext} is supported as dynamic tokens for the blob name.||string|
|filter|A regular expression to include only blobs with name matching it.||string|
|includeBody|If it is true, the Object exchange will be consumed and put into the body. If false the Object stream will be put raw into the body and the headers will be set with the object metadata.|true|boolean|
|includeFolders|If it is true, the folders/directories will be consumed. If it is false, they will be ignored, and Exchanges will not be created for those|true|boolean|
|moveAfterRead|Move objects from the origin bucket to a different bucket after they have been retrieved. To accomplish the operation the destinationBucket option must be set. The copy bucket operation is only performed if the Exchange is committed. If a rollback occurs, the object is not moved.|false|boolean|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|objectName|The Object name inside the bucket||string|
|operation|Set the operation for the producer||object|
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
