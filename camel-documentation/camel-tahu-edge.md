# Tahu-edge

**Since Camel 4.8**

**Only producer is supported**

# URI format

Tahu Edge Nodes and Devices use the same URI scheme and Tahu Edge
Component and Endpoint.

**Edge Node endpoints, where `groupId` and `edgeNodeId` are the
Sparkplug Group and Edge Node IDs describing the Edge Node.**

    tahu-edge://groupId/edgeNodeId?options

**Edge Node Producer for Group *Basic* and Edge Node *EdgeNode* using
MQTT Client ID *EdgeClient1* connecting to Host Application
*BasicHostApp***

    tahu-edge://Basic/EdgeNode?clientId=EdgeClient1&primaryHostId=BasicHostApp&deviceIds=D2,D3,D4

**Device endpoints, where `groupId`, `edgeNodeId`, and `deviceId` are
the Sparkplug Group, Edge Node, and Device IDs describing the Device.**

    tahu-edge://groupId/edgeNodeId/deviceId

**Device Producers for Devices *D2*, *D3*, and *D4* connected to Edge
Node *EdgeNode* in Group *Basic*, i.e. the Devices of the Edge Node in
the example above**

    tahu-edge://Basic/EdgeNode/D2
    tahu-edge://Basic/EdgeNode/D3
    tahu-edge://Basic/EdgeNode/D4

# Usage

## Edge Node Endpoint Configuration

Sparkplug Edge Nodes are identified by a unique combination of Group ID
and Edge Node ID, the Edge Node Descriptor. These two elements form the
path of an Edge Node Endpoint URI. All other Edge Node Endpoint
configuration properties use query string variables or are set via
Endpoint property setters.

If an Edge Node is tied to a particular Host Application, the
`primaryHostId` query string variable can be set to enable the required
Sparkplug behavior.

Metric aliasing is handled automatically by the Eclipse Tahu library and
enabled with the `useAliases` query string variable.

### Birth/Death Sequence Numbers

The Sparkplug specification requires careful handling of NBIRTH/NDEATH
sequence numbers for Host Applications to correlate Edge Nodes' session
behavior with the metrics the Host Application receives.

By default, each Edge Node Endpoint writes a local file to store the
next sequence number that Edge Node should use when publishing its
NBIRTH message and setting its NDEATH MQTT Will Message when
establishing an MQTT Server connection. The local path for this file can
be set using the `bdSeqNumPath` query string variable.

Should another Sparkplug spec-compliant Eclipse Tahu `BdSeqManager`
instance be required, use the `bdSeqManager` Endpoint property setter
method.

## Device Endpoint Configuration

Sparkplug Devices are identified by a unique combination of the Edge
Node Descriptor to which the Device is connected and the Device’s Device
ID. These three elements form the path of a Device Endpoint URI. Since
any Sparkplug Device is associated with exactly one Edge Node, an MQTT
Server connection and its associated Sparkplug behavior is managed per
Edge Node, not per Device. This means all Device Endpoint configuration
must be completed prior to starting the Edge Node Producer for a given
Device Endpoint.

Device Endpoints inherit all MQTT Server connection information from
their associated Edge Node Endpoint. Setting Component- or
Endpoint-level configuration values on Device Components or Endpoints is
unnecessary and should be avoided.

## Edge Node and Device Endpoint Interaction

Sparkplug Edge Nodes are not required to have a Device hierarchy and
physical devices may be represented directly as Edge Nodes—this decision
is left to Sparkplug application developers.

However if an Edge Node will be reporting Device-level metrics in
addition to and Edge Node-level metrics, the Edge Node Endpoint is
required to have a `deviceIds` list configured to publish correct NBIRTH
and DBIRTH payloads required by the Sparkplug specification.

Additionally, a Tahu `SparkplugBPayloadMap` instance is required to be
set on each Edge Node and Device Endpoint to populate the NBIRTH/DBIRTH
message with the required Sparkplug Metric names and data types. This is
accomplished using the `metricDataTypePayloadMap` Endpoint property
setter method.

These requirements allow Sparkplug 3.0.0 compliant behavior.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|checkClientIdLength|MQTT client ID length check enabled|false|boolean|
|clientId|MQTT client ID to use for all server definitions, rather than specifying the same one for each. Note that if neither the 'clientId' parameter nor an 'MqttClientId' are defined for an MQTT Server, a random MQTT Client ID will be generated automatically, prefaced with 'Camel'||string|
|keepAliveTimeout|MQTT connection keep alive timeout, in seconds|30|integer|
|rebirthDebounceDelay|Delay before recurring node rebirth messages will be sent|5000|integer|
|servers|MQTT server definitions, given with the following syntax in a comma-separated list: MqttServerName:(MqttClientId:)(tcp/ssl)://hostname(:port),...||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|configuration|To use a shared Tahu configuration||object|
|password|Password for MQTT server authentication||string|
|sslContextParameters|SSL configuration for MQTT server connections||object|
|useGlobalSslContextParameters|Enable/disable global SSL context parameters use|false|boolean|
|username|Username for MQTT server authentication||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|groupId|ID of the group||string|
|edgeNode|ID of the edge node||string|
|deviceId|ID of this edge node device||string|
|checkClientIdLength|MQTT client ID length check enabled|false|boolean|
|clientId|MQTT client ID to use for all server definitions, rather than specifying the same one for each. Note that if neither the 'clientId' parameter nor an 'MqttClientId' are defined for an MQTT Server, a random MQTT Client ID will be generated automatically, prefaced with 'Camel'||string|
|keepAliveTimeout|MQTT connection keep alive timeout, in seconds|30|integer|
|rebirthDebounceDelay|Delay before recurring node rebirth messages will be sent|5000|integer|
|servers|MQTT server definitions, given with the following syntax in a comma-separated list: MqttServerName:(MqttClientId:)(tcp/ssl)://hostname(:port),...||string|
|metricDataTypePayloadMap|Tahu SparkplugBPayloadMap to configure metric data types for this edge node or device. Note that this payload is used exclusively as a Sparkplug B spec-compliant configuration for all possible edge node or device metric names, aliases, and data types. This configuration is required to publish proper Sparkplug B NBIRTH and DBIRTH payloads.||object|
|headerFilterStrategy|To use a custom HeaderFilterStrategy to filter headers used as Sparkplug metrics. Default value notice: Defaults to sending all Camel Message headers with name prefixes of CamelTahuMetric., including those with null values||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|bdSeqManager|To use a specific org.eclipse.tahu.message.BdSeqManager implementation to manage edge node birth-death sequence numbers|org.apache.camel.component.tahu.CamelBdSeqManager|object|
|bdSeqNumPath|Path for Sparkplug B NBIRTH/NDEATH sequence number persistence files. This path will contain files named as -bdSeqNum and must be writable by the executing process' user|${sys:java.io.tmpdir}/CamelTahuTemp|string|
|useAliases|Flag enabling support for metric aliases|false|boolean|
|deviceIds|ID of each device connected to this edge node, as a comma-separated list||string|
|primaryHostId|Host ID of the primary host application for this edge node||string|
|password|Password for MQTT server authentication||string|
|sslContextParameters|SSL configuration for MQTT server connections||object|
|username|Username for MQTT server authentication||string|
