# Azure-storage-queue

**Since Camel 3.3**

**Both producer and consumer are supported**

The Azure Storage Queue component supports storing and retrieving the
messages to/from [Azure Storage
Queue](https://azure.microsoft.com/services/storage/queues/) service
using **Azure APIs v12**. However, in the case of versions above v12, we
will see if this component can adopt these changes depending on how much
breaking changes can result.

Prerequisites

You must have a valid Windows Azure Storage account. More information is
available at [Azure Documentation
Portal](https://docs.microsoft.com/azure/).

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-azure-storage-queue</artifactId>
        <version>x.x.x</version>
      <!-- use the same version as your Camel core version -->
    </dependency>

# URI Format

    azure-storage-queue://accountName[/queueName][?options]

In the case of consumer, `accountName` and `queueName` are required.

In the case of producer, it depends on the operation that being
requested, for example, if operation is on a service level, e.b:
`listQueues`, only `accountName` is required, but in the case of
operation being requested on the queue level, e.g.:
``createQueue, `sendMessage``, etc., both `accountName` and
`queueName` are required.

The queue will be created if it does not already exist. You can append
query options to the URI in the following format:
`?options=value&option2=value&...`

**Required information options:**

**Required information options:**

To use this component, you have multiple options to provide the required
Azure authentication information:

-   By providing your own QueueServiceClient instance which can be
    injected into `serviceClient`.

-   Via Azure Identity, when specifying `credentialType=AZURE_IDENTITY`
    and providing required [environment
    variables](https://github.com/Azure/azure-sdk-for-java/tree/main/sdk/identity/azure-identity#environment-variables).
    This enables service principal (e.g. app registration)
    authentication with secret/certificate as well as username password.

-   Via shared storage account key, when specifying
    `credentialType=SHARED_ACCOUNT_KEY` and providing `accountName` and
    `accessKey` for your Azure account, this is the simplest way to get
    started. The accessKey can be generated through your Azure portal.
    Note that this is the default authentication strategy.

-   Via shared storage account key, when specifying
    `credentialType=SHARED_KEY_CREDENTIAL` and providing a
    [StorageSharedKeyCredential](https://azuresdkartifacts.blob.core.windows.net/azure-sdk-for-java/staging/apidocs/com/azure/storage/common/StorageSharedKeyCredential.html)
    instance which can be injected into `credentials` option.

# Usage

For example, to get a message content from the queue `messageQueue` in
the `storageAccount` storage account and, use the following snippet:

    from("azure-storage-queue://storageAccount/messageQueue?accessKey=yourAccessKey").
    to("file://queuedirectory");

## Advanced Azure Storage Queue configuration

If your Camel Application is running behind a firewall or if you need to
have more control over the `QueueServiceClient` instance configuration,
you can create your own instance:

    StorageSharedKeyCredential credential = new StorageSharedKeyCredential("yourAccountName", "yourAccessKey");
    String uri = String.format("https://%s.queue.core.windows.net", "yourAccountName");
    
    QueueServiceClient client = new QueueServiceClientBuilder()
                              .endpoint(uri)
                              .credential(credential)
                              .buildClient();
    // This is camel context
    context.getRegistry().bind("client", client);

Then refer to this instance in your Camel `azure-storage-queue`
component configuration:

    from("azure-storage-queue://cameldev/queue1?serviceClient=#client")
    .to("file://outputFolder?fileName=output.txt&fileExist=Append");

## Automatic detection of QueueServiceClient client in registry

The component is capable of detecting the presence of an
QueueServiceClient bean into the registry. If it’s the only instance of
that type, it will be used as the client, and you won’t have to define
it as uri parameter, like the example above. This may be really useful
for smarter configuration of the endpoint.

## Azure Storage Queue Producer operations

Camel Azure Storage Queue component provides a wide range of operations
on the producer side:

**Operations on the service level**

For these operations, `accountName` is **required**.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>listQueues</code></p></td>
<td style="text-align: left;"><p>Lists the queues in the storage account
that pass the filter starting at the specified marker.</p></td>
</tr>
</tbody>
</table>

**Operations on the queue level**

For these operations, `accountName` and `queueName` are **required**.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>createQueue</code></p></td>
<td style="text-align: left;"><p>Creates a new queue.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>deleteQueue</code></p></td>
<td style="text-align: left;"><p>Permanently deletes the queue.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>clearQueue</code></p></td>
<td style="text-align: left;"><p>Deletes all messages in the
queue..</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>sendMessage</code></p></td>
<td style="text-align: left;"><p><strong>Default Producer
Operation</strong> Sends a message with a given time-to-live and timeout
period where the message is invisible in the queue. The message text is
evaluated from the exchange message body. By default, if the queue
doesn’t exist, it will create an empty queue first. If you want to
disable this, set the config <code>createQueue</code> or header
<code>CamelAzureStorageQueueCreateQueue</code> to
<code>false</code>.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>deleteMessage</code></p></td>
<td style="text-align: left;"><p>Deletes the specified message in the
queue.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>receiveMessages</code></p></td>
<td style="text-align: left;"><p>Retrieves up to the maximum number of
messages from the queue and hides them from other operations for the
timeout period. However, it will not dequeue the message from the queue
due to reliability reasons.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>peekMessages</code></p></td>
<td style="text-align: left;"><p>Peek messages from the front of the
queue up to the maximum number of messages.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>updateMessage</code></p></td>
<td style="text-align: left;"><p>Updates the specific message in the
queue with a new message and resets the visibility timeout. The message
text is evaluated from the exchange message body.</p></td>
</tr>
</tbody>
</table>

Refer to the example section in this page to learn how to use these
operations into your camel application.

## Consumer Examples

To consume a queue into a file component with maximum five messages in
one batch, this can be done like this:

    from("azure-storage-queue://cameldev/queue1?serviceClient=#client&maxMessages=5")
    .to("file://outputFolder?fileName=output.txt&fileExist=Append");

## Producer Operations Examples

-   `listQueues`:

<!-- -->

    from("direct:start")
        .process(exchange -> {
          // set the header you want the producer to evaluate, refer to the previous
          // section to learn about the headers that can be set
          // e.g., to only returns a list of queues with 'awesome' prefix:
          exchange.getIn().setHeader(QueueConstants.QUEUES_SEGMENT_OPTIONS, new QueuesSegmentOptions().setPrefix("awesome"));
         })
        .to("azure-storage-queue://cameldev?serviceClient=#client&operation=listQueues")
        .log("${body}")
        .to("mock:result");

-   `createQueue`:

<!-- -->

    from("direct:start")
        .process(exchange -> {
          // set the header you want the producer to evaluate, refer to the previous
          // section to learn about the headers that can be set
          // e.g.:
          exchange.getIn().setHeader(QueueConstants.QUEUE_NAME, "overrideName");
         })
        .to("azure-storage-queue://cameldev/test?serviceClient=#client&operation=createQueue");

-   `deleteQueue`:

<!-- -->

    from("direct:start")
        .process(exchange -> {
          // set the header you want the producer to evaluate, refer to the previous
          // section to learn about the headers that can be set
          // e.g.:
          exchange.getIn().setHeader(QueueConstants.QUEUE_NAME, "overrideName");
         })
        .to("azure-storage-queue://cameldev/test?serviceClient=#client&operation=deleteQueue");

-   `clearQueue`:

<!-- -->

    from("direct:start")
        .process(exchange -> {
          // set the header you want the producer to evaluate, refer to the previous
          // section to learn about the headers that can be set
          // e.g.:
          exchange.getIn().setHeader(QueueConstants.QUEUE_NAME, "overrideName");
         })
        .to("azure-storage-queue://cameldev/test?serviceClient=#client&operation=clearQueue");

-   `sendMessage`:

<!-- -->

    from("direct:start")
        .process(exchange -> {
          // set the header you want the producer to evaluate, refer to the previous
          // section to learn about the headers that can be set
          // e.g.:
          exchange.getIn().setBody("message to send");
          // we set a visibility of 1min
          exchange.getIn().setHeader(QueueConstants.VISIBILITY_TIMEOUT, Duration.ofMinutes(1));
         })
        .to("azure-storage-queue://cameldev/test?serviceClient=#client");

-   `deleteMessage`:

<!-- -->

    from("direct:start")
        .process(exchange -> {
          // set the header you want the producer to evaluate, refer to the previous
          // section to learn about the headers that can be set
          // e.g.:
          // Mandatory header:
          exchange.getIn().setHeader(QueueConstants.MESSAGE_ID, "1");
          // Mandatory header:
          exchange.getIn().setHeader(QueueConstants.POP_RECEIPT, "PAAAAHEEERXXX-1");
         })
        .to("azure-storage-queue://cameldev/test?serviceClient=#client&operation=deleteMessage");

-   `receiveMessages`:

<!-- -->

    from("direct:start")
        .to("azure-storage-queue://cameldev/test?serviceClient=#client&operation=receiveMessages")
        .process(exchange -> {
            final List<QueueMessageItem> messageItems = exchange.getMessage().getBody(List.class);
            messageItems.forEach(messageItem -> System.out.println(messageItem.getMessageText()));
        })
       .to("mock:result");

-   `peekMessages`:

<!-- -->

    from("direct:start")
        .to("azure-storage-queue://cameldev/test?serviceClient=#client&operation=peekMessages")
        .process(exchange -> {
            final List<PeekedMessageItem> messageItems = exchange.getMessage().getBody(List.class);
            messageItems.forEach(messageItem -> System.out.println(messageItem.getMessageText()));
        })
       .to("mock:result");

-   `updateMessage`:

<!-- -->

    from("direct:start")
       .process(exchange -> {
           // set the header you want the producer to evaluate, refer to the previous
           // section to learn about the headers that can be set
           // e.g.:
           exchange.getIn().setBody("new message text");
           // Mandatory header:
           exchange.getIn().setHeader(QueueConstants.MESSAGE_ID, "1");
           // Mandatory header:
           exchange.getIn().setHeader(QueueConstants.POP_RECEIPT, "PAAAAHEEERXXX-1");
           // Mandatory header:
           exchange.getIn().setHeader(QueueConstants.VISIBILITY_TIMEOUT, Duration.ofMinutes(1));
        })
        .to("azure-storage-queue://cameldev/test?serviceClient=#client&operation=updateMessage");

## Development Notes (Important)

When developing on this component, you will need to obtain your Azure
`accessKey` to run the integration tests. In addition to the mocked unit
tests, you **will need to run the integration tests with every change
you make or even client upgrade as the Azure client can break things
even on minor versions upgrade.** To run the integration tests, on this
component directory, run the following maven command:

    mvn verify -DaccountName=myacc -DaccessKey=mykey

Whereby `accountName` is your Azure account name and `accessKey` is the
access key being generated from Azure portal.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configuration|The component configurations||object|
|credentialType|Determines the credential strategy to adopt|SHARED\_ACCOUNT\_KEY|object|
|serviceClient|Service client to a storage account to interact with the queue service. This client does not hold any state about a particular storage account but is instead a convenient way of sending off appropriate requests to the resource on the service. This client contains all the operations for interacting with a queue account in Azure Storage. Operations allowed by the client are creating, listing, and deleting queues, retrieving and updating properties of the account, and retrieving statistics of the account.||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|createQueue|When is set to true, the queue will be automatically created when sending messages to the queue.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|operation|Queue service operation hint to the producer||object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|maxMessages|Maximum number of messages to get, if there are less messages exist in the queue than requested all the messages will be returned. If left empty only 1 message will be retrieved, the allowed range is 1 to 32 messages.|1|integer|
|messageId|The ID of the message to be deleted or updated.||string|
|popReceipt|Unique identifier that must match for the message to be deleted or updated.||string|
|timeout|An optional timeout applied to the operation. If a response is not returned before the timeout concludes a RuntimeException will be thrown.||object|
|timeToLive|How long the message will stay alive in the queue. If unset the value will default to 7 days, if -1 is passed the message will not expire. The time to live must be -1 or any positive number. The format should be in this form: PnDTnHnMn.nS., e.g: PT20.345S -- parses as 20.345 seconds, P2D -- parses as 2 days However, in case you are using EndpointDsl/ComponentDsl, you can do something like Duration.ofSeconds() since these Java APIs are typesafe.||object|
|visibilityTimeout|The timeout period for how long the message is invisible in the queue. The timeout must be between 1 seconds and 7 days. The format should be in this form: PnDTnHnMn.nS., e.g: PT20.345S -- parses as 20.345 seconds, P2D -- parses as 2 days However, in case you are using EndpointDsl/ComponentDsl, you can do something like Duration.ofSeconds() since these Java APIs are typesafe.||object|
|accessKey|Access key for the associated azure account name to be used for authentication with azure queue services||string|
|credentials|StorageSharedKeyCredential can be injected to create the azure client, this holds the important authentication information||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|accountName|Azure account name to be used for authentication with azure queue services||string|
|queueName|The queue resource name||string|
|credentialType|Determines the credential strategy to adopt|SHARED\_ACCOUNT\_KEY|object|
|serviceClient|Service client to a storage account to interact with the queue service. This client does not hold any state about a particular storage account but is instead a convenient way of sending off appropriate requests to the resource on the service. This client contains all the operations for interacting with a queue account in Azure Storage. Operations allowed by the client are creating, listing, and deleting queues, retrieving and updating properties of the account, and retrieving statistics of the account.||object|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|createQueue|When is set to true, the queue will be automatically created when sending messages to the queue.|false|boolean|
|operation|Queue service operation hint to the producer||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|maxMessages|Maximum number of messages to get, if there are less messages exist in the queue than requested all the messages will be returned. If left empty only 1 message will be retrieved, the allowed range is 1 to 32 messages.|1|integer|
|messageId|The ID of the message to be deleted or updated.||string|
|popReceipt|Unique identifier that must match for the message to be deleted or updated.||string|
|timeout|An optional timeout applied to the operation. If a response is not returned before the timeout concludes a RuntimeException will be thrown.||object|
|timeToLive|How long the message will stay alive in the queue. If unset the value will default to 7 days, if -1 is passed the message will not expire. The time to live must be -1 or any positive number. The format should be in this form: PnDTnHnMn.nS., e.g: PT20.345S -- parses as 20.345 seconds, P2D -- parses as 2 days However, in case you are using EndpointDsl/ComponentDsl, you can do something like Duration.ofSeconds() since these Java APIs are typesafe.||object|
|visibilityTimeout|The timeout period for how long the message is invisible in the queue. The timeout must be between 1 seconds and 7 days. The format should be in this form: PnDTnHnMn.nS., e.g: PT20.345S -- parses as 20.345 seconds, P2D -- parses as 2 days However, in case you are using EndpointDsl/ComponentDsl, you can do something like Duration.ofSeconds() since these Java APIs are typesafe.||object|
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
|accessKey|Access key for the associated azure account name to be used for authentication with azure queue services||string|
|credentials|StorageSharedKeyCredential can be injected to create the azure client, this holds the important authentication information||object|
