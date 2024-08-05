# Zookeeper

**Since Camel 2.9**

**Both producer and consumer are supported**

The ZooKeeper component allows interaction with a
[ZooKeeper](https://zookeeper.apache.org/) cluster and exposes the
following features to Camel:

1.  Creation of nodes in any of the ZooKeeper create modes.

2.  Get and Set the data contents of arbitrary cluster nodes (data being
    set must be convertible to `byte[]`).

3.  Create and retrieve the list of the child nodes attached to a
    particular node.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-zookeeper</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    zookeeper://zookeeper-server[:port][/path][?options]

The path from the URI specifies the node in the ZooKeeper server (a.k.a.
*znode*) that will be the target of the endpoint:

# Use cases

## Reading from a *znode*

The following snippet will read the data from the *znode*
`/somepath/somenode/` provided that it already exists. The data
retrieved will be placed into an exchange and passed onto the rest of
the route:

    from("zookeeper://localhost:39913/somepath/somenode").to("mock:result");

If the node does not yet exist, then a flag can be supplied to have the
endpoint await its creation:

    from("zookeeper://localhost:39913/somepath/somenode?awaitCreation=true").to("mock:result");

## Reading from a *znode*

When data is read due to a `WatchedEvent` received from the ZooKeeper
ensemble, the `CamelZookeeperEventType` header holds ZooKeeper’s
[`EventType`](http://zookeeper.apache.org/doc/current/api/org/apache/zookeeper/Watcher.Event.EventType.html)
value from that `WatchedEvent`. If the data is read initially (not
triggered by a `WatchedEvent`) the `CamelZookeeperEventType` header will
not be set.

## Writing to a *znode*

The following snippet will write the payload of the exchange into the
znode at `/somepath/somenode/` provided that it already exists:

    from("direct:write-to-znode")
        .to("zookeeper://localhost:39913/somepath/somenode");

For flexibility, the endpoint allows the target *znode* to be specified
dynamically as a message header. If a header keyed by the string
`CamelZooKeeperNode` is present then the value of the header will be
used as the path to the *znode* on the server. For instance using the
same route definition above, the following code snippet will write the
data not to `/somepath/somenode` but to the path from the header
`/somepath/someothernode`.

the `testPayload` must be convertible to `byte[]` as the data stored in
ZooKeeper is byte-based.

    Object testPayload = ...
    template.sendBodyAndHeader("direct:write-to-znode", testPayload, "CamelZooKeeperNode", "/somepath/someothernode");

To also create the node if it does not exist the `create` option should
be used.

    from("direct:create-and-write-to-znode")
        .to("zookeeper://localhost:39913/somepath/somenode?create=true");

It is also possible to **delete** a node using the header
`CamelZookeeperOperation` by setting it to `DELETE`:

    from("direct:delete-znode")
        .setHeader(ZooKeeperMessage.ZOOKEEPER_OPERATION, constant("DELETE"))
        .to("zookeeper://localhost:39913/somepath/somenode");

or equivalently:

    <route>
      <from uri="direct:delete-znode" />
      <setHeader name="CamelZookeeperOperation">
         <constant>DELETE</constant>
      </setHeader>
      <to uri="zookeeper://localhost:39913/somepath/somenode" />
    </route>

ZooKeeper nodes can have different types; they can be *Ephemeral* or
*Persistent* and *Sequenced* or *Unsequenced*. For further information
of each type, you can check
[here](http://zookeeper.apache.org/doc/trunk/zookeeperProgrammers.html#Ephemeral+Nodes).
By default, endpoints will create unsequenced, ephemeral nodes, but the
type can be easily manipulated via an URI config parameter or via a
special message header. The values expected for the create mode are
simply the names from the `CreateMode` enumeration:

-   `PERSISTENT`

-   `PERSISTENT_SEQUENTIAL`

-   `EPHEMERAL`

-   `EPHEMERAL_SEQUENTIAL`

For example, to create a persistent *znode* via the URI config:

    from("direct:create-and-write-to-persistent-znode")
        .to("zookeeper://localhost:39913/somepath/somenode?create=true&createMode=PERSISTENT");

or using the header `CamelZookeeperCreateMode`.

the `testPayload` must be convertible to `byte[]` as the data stored in
ZooKeeper is byte-based.

    Object testPayload = ...
    template.sendBodyAndHeader("direct:create-and-write-to-persistent-znode", testPayload, "CamelZooKeeperCreateMode", "PERSISTENT");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|listChildren|Whether the children of the node should be listed|false|boolean|
|timeout|The time interval to wait on connection before timing out.|5000|integer|
|backoff|The time interval to backoff for after an error before retrying.|5000|integer|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|repeat|Should changes to the znode be 'watched' and repeatedly processed.|false|boolean|
|sendEmptyMessageOnDelete|Upon the delete of a znode, should an empty message be send to the consumer|true|boolean|
|create|Should the endpoint create the node if it does not currently exist.|false|boolean|
|createMode|The create mode that should be used for the newly created node|EPHEMERAL|string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|configuration|To use a shared ZooKeeperConfiguration||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|serverUrls|The zookeeper server hosts (multiple servers can be separated by comma)||string|
|path|The node in the ZooKeeper server (aka znode)||string|
|listChildren|Whether the children of the node should be listed|false|boolean|
|timeout|The time interval to wait on connection before timing out.|5000|integer|
|backoff|The time interval to backoff for after an error before retrying.|5000|integer|
|repeat|Should changes to the znode be 'watched' and repeatedly processed.|false|boolean|
|sendEmptyMessageOnDelete|Upon the delete of a znode, should an empty message be send to the consumer|true|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|create|Should the endpoint create the node if it does not currently exist.|false|boolean|
|createMode|The create mode that should be used for the newly created node|EPHEMERAL|string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
