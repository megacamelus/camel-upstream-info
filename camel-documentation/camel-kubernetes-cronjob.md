# Kubernetes-cronjob

**Since Camel 4.3**

**Only producer is supported**

The Kubernetes CronJob component is one of [Kubernetes
Components](#kubernetes-summary.adoc) which provides a producer to
execute kubernetes CronJob operations.

# Supported producer operation

-   `listCronJob`

-   `listCronJobByLabels`

-   `getCronJob`

-   `createCronJob`

-   `updateCronJob`

-   `deleteCronJob`

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|kubernetesClient|To use an existing kubernetes client.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|masterUrl|URL to a remote Kubernetes API server. This should only be used when your Camel application is connecting from outside Kubernetes. If you run your Camel application inside Kubernetes, then you can use local or client as the URL to tell Camel to run in local mode. If you connect remotely to Kubernetes, then you may also need some of the many other configuration options for secured connection with certificates, etc.||string|
|apiVersion|The Kubernetes API Version to use||string|
|dnsDomain|The dns domain, used for ServiceCall EIP||string|
|kubernetesClient|Default KubernetesClient to use if provided||object|
|namespace|The namespace||string|
|operation|Producer operation to do on Kubernetes||string|
|portName|The port name, used for ServiceCall EIP||string|
|portProtocol|The port protocol, used for ServiceCall EIP|tcp|string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|connectionTimeout|Connection timeout in milliseconds to use when making requests to the Kubernetes API server.||integer|
|caCertData|The CA Cert Data||string|
|caCertFile|The CA Cert File||string|
|clientCertData|The Client Cert Data||string|
|clientCertFile|The Client Cert File||string|
|clientKeyAlgo|The Key Algorithm used by the client||string|
|clientKeyData|The Client Key data||string|
|clientKeyFile|The Client Key file||string|
|clientKeyPassphrase|The Client Key Passphrase||string|
|oauthToken|The Auth Token||string|
|password|Password to connect to Kubernetes||string|
|trustCerts|Define if the certs we used are trusted anyway or not||boolean|
|username|Username to connect to Kubernetes||string|
