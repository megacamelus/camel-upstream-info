# Docker

**Since Camel 2.15**

**Both producer and consumer are supported**

Camel component for communicating with Docker.

The Docker Camel component leverages the
[docker-java](https://github.com/docker-java/docker-java) via the
[Docker Remote
API](https://docs.docker.com/reference/api/docker_remote_api).

# URI format

    docker://[operation]?[options]

Where **operation** is the specific action to perform on Docker.

# Usage

## Header Strategy

All URI options can be passed as Header properties. Values found in a
message header take precedence over URI parameters. A header property
takes the form of a URI option prefixed with **CamelDocker** as shown
below

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">URI Option</th>
<th style="text-align: left;">Header Property</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>containerId</p></td>
<td style="text-align: left;"><p>CamelDockerContainerId</p></td>
</tr>
</tbody>
</table>

# Examples

The following example consumes events from Docker:

    from("docker://events?host=192.168.59.103&port=2375").to("log:event");

The following example queries Docker for system-wide information

    from("docker://info?host=192.168.59.103&port=2375").to("log:info");

# Dependencies

To use Docker in your Camel routes, you need to add a dependency on
**camel-docker**, which implements the component.

If you use Maven, you can add the following to your pom.xml,
substituting the version number for the latest and greatest release (see
the download page for the latest versions).

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-docker</artifactId>
      <version>x.x.x</version>
    </dependency>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configuration|To use the shared docker configuration||object|
|email|Email address associated with the user||string|
|host|Docker host|localhost|string|
|port|Docker port|2375|integer|
|requestTimeout|Request timeout for response (in seconds)||integer|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|cmdExecFactory|The fully qualified class name of the DockerCmdExecFactory implementation to use|com.github.dockerjava.netty.NettyDockerCmdExecFactory|string|
|followRedirectFilter|Whether to follow redirect filter|false|boolean|
|loggingFilter|Whether to use logging filter|false|boolean|
|maxPerRouteConnections|Maximum route connections|100|integer|
|maxTotalConnections|Maximum total connections|100|integer|
|parameters|Additional configuration parameters as key/value pairs||object|
|serverAddress|Server address for docker registry.|https://index.docker.io/v1/|string|
|socket|Socket connection mode|true|boolean|
|certPath|Location containing the SSL certificate chain||string|
|password|Password to authenticate with||string|
|secure|Use HTTPS communication|false|boolean|
|tlsVerify|Check TLS|false|boolean|
|username|User name to authenticate with||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|operation|Which operation to use||object|
|email|Email address associated with the user||string|
|host|Docker host|localhost|string|
|port|Docker port|2375|integer|
|requestTimeout|Request timeout for response (in seconds)||integer|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|cmdExecFactory|The fully qualified class name of the DockerCmdExecFactory implementation to use|com.github.dockerjava.netty.NettyDockerCmdExecFactory|string|
|followRedirectFilter|Whether to follow redirect filter|false|boolean|
|loggingFilter|Whether to use logging filter|false|boolean|
|maxPerRouteConnections|Maximum route connections|100|integer|
|maxTotalConnections|Maximum total connections|100|integer|
|parameters|Additional configuration parameters as key/value pairs||object|
|serverAddress|Server address for docker registry.|https://index.docker.io/v1/|string|
|socket|Socket connection mode|true|boolean|
|certPath|Location containing the SSL certificate chain||string|
|password|Password to authenticate with||string|
|secure|Use HTTPS communication|false|boolean|
|tlsVerify|Check TLS|false|boolean|
|username|User name to authenticate with||string|
