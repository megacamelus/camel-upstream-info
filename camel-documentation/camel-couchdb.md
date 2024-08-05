# Couchdb

**Since Camel 2.11**

**Both producer and consumer are supported**

The **couchdb:** component allows you to treat
[CouchDB](http://couchdb.apache.org/) instances as a producer or
consumer of messages. Using the lightweight LightCouch API, this camel
component has the following features:

-   As a consumer, monitors couch changesets for inserts, updates and
    deletes and publishes these as messages into camel routes.

-   As a producer, can save, update, delete (by using `CouchDbMethod`
    with `DELETE` value) documents and get documents by id (by using
    `CouchDbMethod` with GET value) into CouchDB.

-   Can support as many endpoints as required, eg for multiple databases
    across multiple instances.

-   Ability to have events trigger for only deletes, only
    inserts/updates or all (default).

-   Headers set for sequenceId, document revision, document id, and HTTP
    method type.

CouchDB 3.x is not supported.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-couchdb</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    couchdb:http://hostname[:port]/database?[options]

Where **hostname** is the hostname of the running couchdb instance. Port
is optional and if not specified, then defaults to 5984.

Headers are set by the consumer once the message is received. The
producer will also set the headers for downstream processors once the
insert/update has taken place. Any headers set prior to the producer are
ignored. That means, for example, if you set CouchDbId as a header, it
will not be used as the id for insertion, the id of the document will
still be used.

# Message Body

The component will use the message body as the document to be inserted.
If the body is an instance of String, then it will be marshaled into a
GSON object before insert. This means that the string must be valid JSON
or the insert / update will fail. If the body is an instance of a
`com.google.gson.JsonElement` then it will be inserted as is. Otherwise,
the producer will throw an unsupported body type exception.

To update a CouchDB document, its `id` and `rev` field must be part of
the json payload routed to CouchDB by Camel.

# Samples

For example, if you wish to consume all inserts, updates and deletes
from a CouchDB instance running locally, on port 9999, then you could
use the following:

    from("couchdb:http://localhost:9999").process(someProcessor);

If you were only interested in deleting, then you could use the
following:

    from("couchdb:http://localhost:9999?updates=false").process(someProcessor);

If you want to insert a message as a document, then the body of the
exchange is used:

    from("someProducingEndpoint").process(someProcessor).to("couchdb:http://localhost:9999")

To start tracking the changes immediately after an update sequence,
implement a custom resume strategy. To do so, it is necessary to
implement a CouchDbResumeStrategy and use the resumable to set the last
(update) offset to start tracking the changes:

\`\`\` public class CustomSequenceResumeStrategy implements
CouchDbResumeStrategy { @Override public void resume(CouchDbResumable
resumable) { resumable.setLastOffset("custom-last-update"); } } \`\`\`

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|protocol|The protocol to use for communicating with the database.||string|
|hostname|Hostname of the running couchdb instance||string|
|port|Port number for the running couchdb instance|5984|integer|
|database|Name of the database to use||string|
|createDatabase|Creates the database if it does not already exist|false|boolean|
|deletes|Document deletes are published as events|true|boolean|
|heartbeat|How often to send an empty message to keep socket alive in millis|30000|duration|
|maxMessagesPerPoll|Gets the maximum number of messages as a limit to poll at each polling. Gets the maximum number of messages as a limit to poll at each polling. The default value is 10. Use 0 or a negative number to set it as unlimited.|10|integer|
|style|Specifies how many revisions are returned in the changes array. The default, main\_only, will only return the current winning revision; all\_docs will return all leaf revisions (including conflicts and deleted former conflicts.)|main\_only|string|
|updates|Document inserts/updates are published as events|true|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|password|Password for authenticated databases||string|
|username|Username in case of authenticated databases||string|
