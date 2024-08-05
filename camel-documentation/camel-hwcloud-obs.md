# Hwcloud-obs

**Since Camel 3.12**

**Both producer and consumer are supported**

Huawei Cloud Object Storage Service (OBS) component allows you to
integrate with
[OBS](https://www.huaweicloud.com/intl/en-us/product/obs.html) provided
by Huawei Cloud.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-huaweicloud-obs</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI Format

    hwcloud-obs:operation[?options]

# Usage

## Message properties evaluated by the OBS producer

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Header</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudObsOperation</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of operation to invoke</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudObsBucketName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Bucket name to invoke operation
on</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudObsBucketLocation</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Bucket location when creating a new
bucket</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudObsObjectName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Name of the object to be used in
operation. You can also configure the name of the object using this
property while performing putObject operation</p></td>
</tr>
</tbody>
</table>

If any of the above properties are set, they will override their
corresponding query parameter.

## Message properties set by the OBS producer

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Header</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>CamelHwCloudObsBucketExists</code></p></td>
<td style="text-align: left;"><p><code>boolean</code></p></td>
<td style="text-align: left;"><p>Return value when invoking the
<code>checkBucketExists</code> operation</p></td>
</tr>
</tbody>
</table>

# List of Supported OBS Operations

-   listBuckets

-   createBucket - `bucketName` parameter is **required**,
    `bucketLocation` parameter is optional

-   deleteBucket - `bucketName` parameter is **required**

-   checkBucketExists - `bucketName` parameter is **required**

-   getBucketMetadata - `bucketName` parameter is **required**

-   listObjects - `bucketName` parameter is **required**

-   getObject - `bucketName` and `objectName` parameters are
    **required**

-   putObject - `bucketName` parameter is **required**. If exchange body
    contains File, then file name is used as default object name unless
    over-ridden via exchange property CamelHwCloudObsObjectName

## Passing Options Through Exchange Body

There are many options that can be submitted to the `createBucket` and
`listObjects` operations, so they can be passed through the exchange
body.

If you would like to configure all the
[parameters](https://support.huaweicloud.com/intl/en-us/api-obs/obs_04_0021.html)
when creating a bucket, you can pass a
[CreateBucketRequest](https://obssdk-intl.obs.ap-southeast-1.myhuaweicloud.com/apidoc/en/java/com/obs/services/model/CreateBucketRequest.html)
object or a Json string into the exchange body. If the exchange body is
empty, a new bucket will be created using the bucketName and
bucketLocation (if provided) passed through the endpoint uri.

    from("direct:triggerRoute")
     .setBody(new CreateBucketRequest("Bucket name", "Bucket location"))
     .to("hwcloud-obs:createBucket?region=cn-north-4&accessKey=********&secretKey=********")
    
    from("direct:triggerRoute")
     .setBody("{\"bucketName\":\"Bucket name\",\"location\":\"Bucket location\"}")
     .to("hwcloud-obs:createBucket?region=cn-north-4&accessKey=********&secretKey=********")

If you would like to configure all the
[parameters](https://support.huaweicloud.com/intl/en-us/api-obs/obs_04_0022.html)
when listing objects, you can pass a
[ListObjectsRequest](https://obssdk-intl.obs.ap-southeast-1.myhuaweicloud.com/apidoc/en/java/com/obs/services/model/ListObjectsRequest.html)
object or a Json string into the exchange body. If the exchange body is
empty, objects will be listed based on the bucketName passed through the
endpoint uri.

    from("direct:triggerRoute")
     .setBody(new ListObjectsRequest("Bucket name", 1000))
     .to("hwcloud-obs:listObjects?region=cn-north-4&accessKey=********&secretKey=********")
    
    from("direct:triggerRoute")
     .setBody("{\"bucketName\":\"Bucket name\",\"maxKeys\":1000"}")
     .to("hwcloud-obs:listObjects?region=cn-north-4&accessKey=********&secretKey=********")

# Using ServiceKey Configuration Bean

Access key and secret keys are required to authenticate against the OBS
cloud. You can avoid having them being exposed and scattered over in
your endpoint uri by wrapping them inside a bean of class
`org.apache.camel.component.huaweicloud.obs.models.ServiceKeys`. Add it
to the registry and let Camel look it up by referring the object via
endpoint query parameter `serviceKeys`.

Check the following code snippets:

    <bean id="myServiceKeyConfig" class="org.apache.camel.component.huaweicloud.obs.models.ServiceKeys">
       <property name="accessKey" value="your_access_key" />
       <property name="secretKey" value="your_secret_key" />
    </bean>
    
    from("direct:triggerRoute")
     .setProperty(OBSPropeties.OPERATION, constant("createBucket"))
     .setProperty(OBSPropeties.BUCKET_NAME ,constant("your_bucket_name"))
     .setProperty(OBSPropeties.BUCKET_LOCATION, constant("your_bucket_location"))
     .to("hwcloud-obs:createBucket?region=cn-north-4&serviceKeys=#myServiceKeyConfig")

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|operation|Operation to be performed||string|
|bucketName|Name of bucket to perform operation on||string|
|endpoint|OBS url. Carries higher precedence than region parameter based client initialization||string|
|objectName|Name of object to perform operation with||string|
|region|OBS service region. This is lower precedence than endpoint based configuration||string|
|deleteAfterRead|Determines if objects should be deleted after it has been retrieved|false|boolean|
|delimiter|The character used for grouping object names||string|
|destinationBucket|Name of destination bucket where objects will be moved when moveAfterRead is set to true||string|
|fileName|Get the object from the bucket with the given file name||string|
|includeFolders|If true, objects in folders will be consumed. Otherwise, they will be ignored and no Exchanges will be created for them|true|boolean|
|maxMessagesPerPoll|The maximum number of messages to poll at each polling|10|integer|
|moveAfterRead|Determines whether objects should be moved to a different bucket after they have been retrieved. The destinationBucket option must also be set for this option to work.|false|boolean|
|prefix|The object name prefix used for filtering objects to be listed||string|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|bucketLocation|Location of bucket when creating a new bucket||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|proxyHost|Proxy server ip/hostname||string|
|proxyPassword|Proxy authentication password||string|
|proxyPort|Proxy server port||integer|
|proxyUser|Proxy authentication user||string|
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
|accessKey|Access key for the cloud user||string|
|ignoreSslVerification|Ignore SSL verification|false|boolean|
|secretKey|Secret key for the cloud user||string|
|serviceKeys|Configuration object for cloud service authentication||object|
