# Tahu-host

**Since Camel 4.8**

**Only consumer is supported**

# URI format

**Host Application endpoints, where `hostId` is the Sparkplug Host
Application ID**

    tahu-host://hostId?options

**Host Application Consumer for Host App *BasicHostApp* using MQTT
Client ID *HostClient1***

    tahu-host:BasicHostApp?clientId=HostClient1

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|checkClientIdLength|MQTT client ID length check enabled|false|boolean|
|clientId|MQTT client ID to use for all server definitions, rather than specifying the same one for each. Note that if neither the 'clientId' parameter nor an 'MqttClientId' are defined for an MQTT Server, a random MQTT Client ID will be generated automatically, prefaced with 'Camel'||string|
|keepAliveTimeout|MQTT connection keep alive timeout, in seconds|30|integer|
|rebirthDebounceDelay|Delay before recurring node rebirth messages will be sent|5000|integer|
|servers|MQTT server definitions, given with the following syntax in a comma-separated list: MqttServerName:(MqttClientId:)(tcp/ssl)://hostname(:port),...||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|configuration|To use a shared Tahu configuration||object|
|password|Password for MQTT server authentication||string|
|sslContextParameters|SSL configuration for MQTT server connections||object|
|useGlobalSslContextParameters|Enable/disable global SSL context parameters use|false|boolean|
|username|Username for MQTT server authentication||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|hostId|ID for the host application||string|
|checkClientIdLength|MQTT client ID length check enabled|false|boolean|
|clientId|MQTT client ID to use for all server definitions, rather than specifying the same one for each. Note that if neither the 'clientId' parameter nor an 'MqttClientId' are defined for an MQTT Server, a random MQTT Client ID will be generated automatically, prefaced with 'Camel'||string|
|keepAliveTimeout|MQTT connection keep alive timeout, in seconds|30|integer|
|rebirthDebounceDelay|Delay before recurring node rebirth messages will be sent|5000|integer|
|servers|MQTT server definitions, given with the following syntax in a comma-separated list: MqttServerName:(MqttClientId:)(tcp/ssl)://hostname(:port),...||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|password|Password for MQTT server authentication||string|
|sslContextParameters|SSL configuration for MQTT server connections||object|
|username|Username for MQTT server authentication||string|
