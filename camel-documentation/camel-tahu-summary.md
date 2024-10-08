# Tahu-summary.md

**Since Camel 4.8**

**Both producer and consumer are supported**

The Tahu components adapt the [Eclipse
Tahu](https://projects.eclipse.org/projects/iot.tahu) library for Camel.
These components support creating Sparkplug Edge Nodes, Devices, and
Host Applications as described by [Eclipse
Sparkplug](https://projects.eclipse.org/projects/iot.sparkplug) using
Sparkplug B payload encoding.

For more information regarding Sparkplug concepts and required behavior,
consult the [Sparkplug 3.0.0
Specification](https://www.eclipse.org/tahu/spec/sparkplug_spec.pdf)

Neither the use of the Eclipse Tahu library nor the Camel Tahu
Components implies Sparkplug 3.0.0 specification compliance. While it
**should** be possible to create Sparkplug 3.0.0-compliant applications
using the Camel Tahu Components, no claims or guarantees are expressed
or implied.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>{artifactid}</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# Tahu components

See the following for usage of each component:

indexDescriptionList::\[attributes=*group=Tahu*,descriptionformat=description\]

# URI format

## Edge Nodes and Devices (Producers)

**Edge Node and Device endpoints, where `groupId`, `edgeNodeId`, and
`deviceId` are the Sparkplug Group, Edge Node, and Device IDs describing
the Edge Node or Device.**

    tahu-edge://groupId/edgeNodeId[/deviceId]?options

**Edge Node Producer for Group *Basic* and Edge Node *EdgeNode* using
MQTT Client ID *EdgeClient1* connecting to Host Application
*BasicHostApp***

    tahu-edge://Basic/EdgeNode?clientId=EdgeClient1&primaryHostId=BasicHostApp&deviceIds=D2,D3,D4

**Device Producers for Devices *D2*, *D3*, and *D4* connected to Edge
Node *EdgeNode* in Group *Basic*, i.e. the Devices of the Edge Node in
the example above**

    tahu-device://Basic/EdgeNode/D2
    tahu-device://Basic/EdgeNode/D3
    tahu-device://Basic/EdgeNode/D4

## Host Applications (Consumers)

**Host Application endpoints, where `hostId` is the Sparkplug Host
Application ID**

    tahu-host://hostId?options

**Host Application Consumer for Host App *BasicHostApp* using MQTT
Client ID *HostClient1***

    tahu-host:BasicHostApp?clientId=HostClient1

# Endpoints

Tahu component endpoints describe a Sparkplug Edge Node, Device, or Host
Application. All Sparkplug specification requirements must be observed
when defining the endpoint URIs, including allowed characters in names,
uniqueness in IDs, etc. Device IDs can include additional hierarchy with
*/* characters as allowed by the specification.

Tahu Edge Node and Device endpoints only allow Producers to be created.
Tahu Host Application endpoints only allow Consumers to be created.

# Usage

The Sparkplug 3.0.0 specification requires Sparkplug B MQTT message
payloads to follow a Google Protobuf format with an specific structure
and message order. Many of these requirements necessitate careful Tahu
Component and Endpoint configurations.

## Component Configuration

Tahu Component configuration is primarily composed of MQTT Server
connection information. These properties may be configured on Endpoint
URIs or the Tahu Component to cover all Endpoints created using that
Component instance.

The `servers` property is a comma-separated list with the following
syntax:

    MqttServerName:[MqttClientId:](tcp|ssl)://hostname[:port],...

This gives a unique server name to each MQTT Server as well as its
connection scheme (`tcp` or `ssl`), hostname, and optionally the port
number. A connection-specific MQTT Client ID may also be assigned when
connecting to this particular server. MQTT Client ID uniqueness
requirements apply.

A common MQTT Client ID may also be configured through the `clientId`
property and will apply to all MQTT Server connections NOT specifying a
connection-specific `MqttClientId` in the `servers` list. Should neither
the `clientId` nor the `MqttClientId` be set, a random MQTT Client ID
will be generated prefaced by "Camel".

MQTT Client IDs are limited to 23 characters in MQTT v3.1. However, MQTT
v3.1.1 increased that limit to 256 characters. When connecting to MQTT
Servers only supporting v3.1, setting the `checkClientIdLength` flag to
`true` will add a 23-character length check to ensure proper Client ID
lengths. This is a configuration-time check and is not required to
connect to MQTT v3.1 Servers.

MQTT Server authentication can be configured using the `username` and
`password` properties. TLS configuration can also be configured by
providing an `SSLContextParameters` instance or through the
`useGlobalSslContextParameters` flag.

An MQTT connection keep alive timeout can be configured using
`keepAliveTimeout`.

A delay can be added between Edge Node Rebirth publishing through the
`rebirthDebounceDelay` property.
