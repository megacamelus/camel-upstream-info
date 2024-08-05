# Minio

**Since Camel 3.5**

**Both producer and consumer are supported**

The Minio component supports storing and retrieving objects from/to
[Minio](https://min.io/) service.

# Prerequisites

You must have valid credentials for authorized access to the
buckets/folders. More information is available at
[Minio](https://min.io/).

# URI Format

    minio://bucketName[?options]

The bucket will be created if it doesn’t already exist.  
You can append query options to the URI in the following format:
`?options=value&option2=value&...`

For example, to read file `hello.txt` from the bucket `helloBucket`, use
the following snippet:

    from("minio://helloBucket?accessKey=yourAccessKey&secretKey=yourSecretKey&objectName=hello.txt")
      .to("file:/var/downloaded");

You have to provide the minioClient in the Registry or your accessKey
and secretKey to access the [Minio](https://min.io/).

# Batch Consumer

This component implements the Batch Consumer.

This allows you, for instance, to know how many messages exist in this
batch and for instance, let the Aggregator aggregate this number of
messages.

## Minio Producer operations

Camel-Minio component provides the following operation on the producer
side:

-   copyObject

-   deleteObject

-   deleteObjects

-   listBuckets

-   deleteBucket

-   listObjects

-   getObject (this will return a MinioObject instance)

-   getObjectRange (this will return a MinioObject instance)

-   createDownloadLink (this will return a Presigned download Url)

-   createUploadLink (this will return a Presigned upload url)

## Advanced Minio configuration

If your Camel Application is running behind a firewall or if you need to
have more control over the `MinioClient` instance configuration, you can
create your own instance and refer to it in your Camel minio component
configuration:

    from("minio://MyBucket?minioClient=#client&delay=5000&maxMessagesPerPoll=5")
    .to("mock:result");

## Minio Producer Operation examples

-   CopyObject: this operation copies an object from one bucket to a
    different one

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(MinioConstants.DESTINATION_BUCKET_NAME, "camelDestinationBucket");
              exchange.getIn().setHeader(MinioConstants.OBJECT_NAME, "camelKey");
              exchange.getIn().setHeader(MinioConstants.DESTINATION_OBJECT_NAME, "camelDestinationKey");
          }
      })
      .to("minio://mycamelbucket?minioClient=#minioClient&operation=copyObject")
      .to("mock:result");

This operation will copy the object with the name expressed in the
header camelDestinationKey to the camelDestinationBucket bucket, from
the bucket mycamelbucket.

-   DeleteObject: this operation deletes an object from a bucket

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(MinioConstants.OBJECT_NAME, "camelKey");
          }
      })
      .to("minio://mycamelbucket?minioClient=#minioClient&operation=deleteObject")
      .to("mock:result");

This operation will delete the object camelKey from the bucket
mycamelbucket.

-   ListBuckets: this operation lists the buckets for this account in
    this region

<!-- -->

      from("direct:start")
      .to("minio://mycamelbucket?minioClient=#minioClient&operation=listBuckets")
      .to("mock:result");

This operation will list the buckets for this account

-   DeleteBucket: this operation deletes the bucket specified as URI
    parameter or header

<!-- -->

      from("direct:start")
      .to("minio://mycamelbucket?minioClient=#minioClient&operation=deleteBucket")
      .to("mock:result");

This operation will delete the bucket mycamelbucket

-   ListObjects: this operation list object in a specific bucket

<!-- -->

      from("direct:start")
      .to("minio://mycamelbucket?minioClient=#minioClient&operation=listObjects")
      .to("mock:result");

This operation will list the objects in the mycamelbucket bucket

-   GetObject: this operation gets a single object in a specific bucket

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(MinioConstants.OBJECT_NAME, "camelKey");
          }
      })
      .to("minio://mycamelbucket?minioClient=#minioClient&operation=getObject")
      .to("mock:result");

This operation will return a MinioObject instance related to the
camelKey object in `mycamelbucket` bucket.

-   GetObjectRange: this operation gets a single object range in a
    specific bucket

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(MinioConstants.OBJECT_NAME, "camelKey");
              exchange.getIn().setHeader(MinioConstants.OFFSET, "0");
              exchange.getIn().setHeader(MinioConstants.LENGTH, "9");
          }
      })
      .to("minio://mycamelbucket?minioClient=#minioClient&operation=getObjectRange")
      .to("mock:result");

This operation will return a MinioObject instance related to the
camelKey object in `mycamelbucket` bucket, containing bytes from 0 to 9.

-   createDownloadLink: this operation will return a presigned url
    through which a file can be downloaded using GET method

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(MinioConstants.OBJECT_NAME, "camelKey");
              exchange.getIn().setHeader(MinioConstants.PRESIGNED_URL_EXPIRATION_TIME, 60 * 60);
          }
      })
      .to("minio://mycamelbucket?minioClient=#minioClient&operation=createDownloadLink")
      .to("mock:result");

-   createUploadLink: this operation will return a presigned url through
    which a file can be uploaded using PUT method

<!-- -->

      from("direct:start").process(new Processor() {
    
          @Override
          public void process(Exchange exchange) throws Exception {
              exchange.getIn().setHeader(MinioConstants.OBJECT_NAME, "camelKey");
              exchange.getIn().setHeader(MinioConstants.PRESIGNED_URL_EXPIRATION_TIME, 60 * 60);
          }
      })
      .to("minio://mycamelbucket?minioClient=#minioClient&operation=createUploadLink")
      .to("mock:result");

createDownLink and createUploadLink have a default expiry of 3600s which
can be overridden by setting the header
MinioConstants.PRESIGNED\_URL\_EXPIRATION\_TIME (value in seconds)

# Bucket Auto-creation

With the option `autoCreateBucket` users are able to avoid the
autocreation of a Minio Bucket in case it doesn’t exist. The default for
this option is `true`. If set to false, any operation on a not-existent
bucket in Minio won’t be successful, and an error will be returned.

# Automatic detection of a Minio client in registry

The component is capable of detecting the presence of a Minio bean into
the registry. If it’s the only instance of that type, it will be used as
the client, and you won’t have to define it as uri parameter, like the
example above. This may be really useful for smarter configuration of
the endpoint.

# Moving stuff between a bucket and another bucket

Some users like to consume stuff from a bucket and move the content in a
different one without using the `copyObject` feature of this component.
If this is the case for you, remember to remove the `bucketName` header
from the incoming exchange of the consumer. Otherwise, the file will
always be overwritten on the same original bucket.

# MoveAfterRead consumer option

In addition to `deleteAfterRead`, it has been added another option,
`moveAfterRead`. With this option enabled, the consumed object will be
moved to a target `destinationBucket` instead of being only deleted.
This will require specifying the destinationBucket option. As example:

      from("minio://mycamelbucket?minioClient=#minioClient&moveAfterRead=true&destinationBucketName=myothercamelbucket")
      .to("mock:result");

In this case, the objects consumed will be moved to `myothercamelbucket`
bucket and deleted from the original one (because of `deleteAfterRead`
set to true as default).

# Using a POJO as body

Sometimes build a Minio Request can be complex because of multiple
options. We introduce the possibility to use a POJO as the body. In
Minio, there are multiple operations you can submit, as an example for
List brokers request, you can do something like:

    from("direct:minio")
         .setBody(ListObjectsArgs.builder()
                        .bucket(bucketName)
                        .recursive(getConfiguration().isRecursive())))
         .to("minio://test?minioClient=#minioClient&operation=listObjects&pojoRequest=true")

In this way, you’ll pass the request directly without the need of
passing headers and options specifically related to this operation.

# Dependencies

Maven users will need to add the following dependency to their pom.xml.

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-minio</artifactId>
        <version>${camel-version}</version>
    </dependency>

where `${camel-version}` must be replaced by the actual version of
Camel.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|autoCreateBucket|Setting the autocreation of the bucket if bucket name not exist.|true|boolean|
|configuration|The component configuration||object|
|endpoint|Endpoint can be an URL, domain name, IPv4 address or IPv6 address.||string|
|minioClient|Reference to a Minio Client object in the registry.||object|
|objectLock|Set when creating new bucket.|false|boolean|
|policy|The policy for this queue to set in the method.||string|
|proxyPort|TCP/IP port number. 80 and 443 are used as defaults for HTTP and HTTPS.||integer|
|region|The region in which Minio client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example ap-east-1). You'll need to use the name Region.EU\_WEST\_1.id()||string|
|secure|Flag to indicate to use secure connection to minio service or not.|false|boolean|
|autoCloseBody|If this option is true and includeBody is true, then the MinioObject.close() method will be called on exchange completion. This option is strongly related to includeBody option. In case of setting includeBody to true and autocloseBody to false, it will be up to the caller to close the MinioObject stream. Setting autocloseBody to true, will close the MinioObject stream automatically.|true|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|bypassGovernanceMode|Set this flag if you want to bypassGovernanceMode when deleting a particular object.|false|boolean|
|deleteAfterRead|Delete objects from Minio after they have been retrieved. The delete is only performed if the Exchange is committed. If a rollback occurs, the object is not deleted. If this option is false, then the same objects will be retrieve over and over again on the polls. Therefore you need to use the Idempotent Consumer EIP in the route to filter out duplicates. You can filter using the MinioConstants#BUCKET\_NAME and MinioConstants#OBJECT\_NAME headers, or only the MinioConstants#OBJECT\_NAME header.|true|boolean|
|delimiter|The delimiter which is used in the ListObjectsRequest to only consume objects we are interested in.||string|
|destinationBucketName|Destination bucket name.||string|
|destinationObjectName|Destination object name.||string|
|includeBody|If it is true, the exchange body will be set to a stream to the contents of the file. If false, the headers will be set with the Minio object metadata, but the body will be null. This option is strongly related to autocloseBody option. In case of setting includeBody to true and autocloseBody to false, it will be up to the caller to close the MinioObject stream. Setting autocloseBody to true, will close the MinioObject stream automatically.|true|boolean|
|includeFolders|The flag which is used in the ListObjectsRequest to set include folders.|false|boolean|
|includeUserMetadata|The flag which is used in the ListObjectsRequest to get objects with user meta data.|false|boolean|
|includeVersions|The flag which is used in the ListObjectsRequest to get objects with versioning.|false|boolean|
|length|Number of bytes of object data from offset.||integer|
|matchETag|Set match ETag parameter for get object(s).||string|
|maxConnections|Set the maxConnections parameter in the minio client configuration|60|integer|
|maxMessagesPerPoll|Gets the maximum number of messages as a limit to poll at each polling. Gets the maximum number of messages as a limit to poll at each polling. The default value is 10. Use 0 or a negative number to set it as unlimited.|10|integer|
|modifiedSince|Set modified since parameter for get object(s).||object|
|moveAfterRead|Move objects from bucket to a different bucket after they have been retrieved. To accomplish the operation the destinationBucket option must be set. The copy bucket operation is only performed if the Exchange is committed. If a rollback occurs, the object is not moved.|false|boolean|
|notMatchETag|Set not match ETag parameter for get object(s).||string|
|objectName|To get the object from the bucket with the given object name.||string|
|offset|Start byte position of object data.||integer|
|prefix|Object name starts with prefix.||string|
|recursive|List recursively than directory structure emulation.|false|boolean|
|startAfter|list objects in bucket after this object name.||string|
|unModifiedSince|Set un modified since parameter for get object(s).||object|
|useVersion1|when true, version 1 of REST API is used.|false|boolean|
|versionId|Set specific version\_ID of a object when deleting the object.||string|
|deleteAfterWrite|Delete file object after the Minio file has been uploaded.|false|boolean|
|keyName|Setting the key name for an element in the bucket through endpoint parameter.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|operation|The operation to do in case the user don't want to do only an upload.||object|
|pojoRequest|If we want to use a POJO request as body or not.|false|boolean|
|storageClass|The storage class to set in the request.||string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|customHttpClient|Set custom HTTP client for authenticated access.||object|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|accessKey|Amazon AWS Secret Access Key or Minio Access Key. If not set camel will connect to service for anonymous access.||string|
|secretKey|Amazon AWS Access Key Id or Minio Secret Key. If not set camel will connect to service for anonymous access.||string|
|serverSideEncryption|Server-side encryption.||object|
|serverSideEncryptionCustomerKey|Server-side encryption for source object while copy/move objects.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bucketName|Bucket name||string|
|autoCreateBucket|Setting the autocreation of the bucket if bucket name not exist.|true|boolean|
|endpoint|Endpoint can be an URL, domain name, IPv4 address or IPv6 address.||string|
|minioClient|Reference to a Minio Client object in the registry.||object|
|objectLock|Set when creating new bucket.|false|boolean|
|policy|The policy for this queue to set in the method.||string|
|proxyPort|TCP/IP port number. 80 and 443 are used as defaults for HTTP and HTTPS.||integer|
|region|The region in which Minio client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example ap-east-1). You'll need to use the name Region.EU\_WEST\_1.id()||string|
|secure|Flag to indicate to use secure connection to minio service or not.|false|boolean|
|autoCloseBody|If this option is true and includeBody is true, then the MinioObject.close() method will be called on exchange completion. This option is strongly related to includeBody option. In case of setting includeBody to true and autocloseBody to false, it will be up to the caller to close the MinioObject stream. Setting autocloseBody to true, will close the MinioObject stream automatically.|true|boolean|
|bypassGovernanceMode|Set this flag if you want to bypassGovernanceMode when deleting a particular object.|false|boolean|
|deleteAfterRead|Delete objects from Minio after they have been retrieved. The delete is only performed if the Exchange is committed. If a rollback occurs, the object is not deleted. If this option is false, then the same objects will be retrieve over and over again on the polls. Therefore you need to use the Idempotent Consumer EIP in the route to filter out duplicates. You can filter using the MinioConstants#BUCKET\_NAME and MinioConstants#OBJECT\_NAME headers, or only the MinioConstants#OBJECT\_NAME header.|true|boolean|
|delimiter|The delimiter which is used in the ListObjectsRequest to only consume objects we are interested in.||string|
|destinationBucketName|Destination bucket name.||string|
|destinationObjectName|Destination object name.||string|
|includeBody|If it is true, the exchange body will be set to a stream to the contents of the file. If false, the headers will be set with the Minio object metadata, but the body will be null. This option is strongly related to autocloseBody option. In case of setting includeBody to true and autocloseBody to false, it will be up to the caller to close the MinioObject stream. Setting autocloseBody to true, will close the MinioObject stream automatically.|true|boolean|
|includeFolders|The flag which is used in the ListObjectsRequest to set include folders.|false|boolean|
|includeUserMetadata|The flag which is used in the ListObjectsRequest to get objects with user meta data.|false|boolean|
|includeVersions|The flag which is used in the ListObjectsRequest to get objects with versioning.|false|boolean|
|length|Number of bytes of object data from offset.||integer|
|matchETag|Set match ETag parameter for get object(s).||string|
|maxConnections|Set the maxConnections parameter in the minio client configuration|60|integer|
|maxMessagesPerPoll|Gets the maximum number of messages as a limit to poll at each polling. Gets the maximum number of messages as a limit to poll at each polling. The default value is 10. Use 0 or a negative number to set it as unlimited.|10|integer|
|modifiedSince|Set modified since parameter for get object(s).||object|
|moveAfterRead|Move objects from bucket to a different bucket after they have been retrieved. To accomplish the operation the destinationBucket option must be set. The copy bucket operation is only performed if the Exchange is committed. If a rollback occurs, the object is not moved.|false|boolean|
|notMatchETag|Set not match ETag parameter for get object(s).||string|
|objectName|To get the object from the bucket with the given object name.||string|
|offset|Start byte position of object data.||integer|
|prefix|Object name starts with prefix.||string|
|recursive|List recursively than directory structure emulation.|false|boolean|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|startAfter|list objects in bucket after this object name.||string|
|unModifiedSince|Set un modified since parameter for get object(s).||object|
|useVersion1|when true, version 1 of REST API is used.|false|boolean|
|versionId|Set specific version\_ID of a object when deleting the object.||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|deleteAfterWrite|Delete file object after the Minio file has been uploaded.|false|boolean|
|keyName|Setting the key name for an element in the bucket through endpoint parameter.||string|
|operation|The operation to do in case the user don't want to do only an upload.||object|
|pojoRequest|If we want to use a POJO request as body or not.|false|boolean|
|storageClass|The storage class to set in the request.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|customHttpClient|Set custom HTTP client for authenticated access.||object|
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
|accessKey|Amazon AWS Secret Access Key or Minio Access Key. If not set camel will connect to service for anonymous access.||string|
|secretKey|Amazon AWS Access Key Id or Minio Secret Key. If not set camel will connect to service for anonymous access.||string|
|serverSideEncryption|Server-side encryption.||object|
|serverSideEncryptionCustomerKey|Server-side encryption for source object while copy/move objects.||object|
