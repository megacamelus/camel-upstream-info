# Ssh

**Since Camel 2.10**

**Both producer and consumer are supported**

The SSH component enables access to SSH servers such that you can send
an SSH command and process the response.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-ssh</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    ssh:[username[:password]@]host[:port][?options]

# Usage as a Producer endpoint

When the SSH Component is used as a Producer (`.to("ssh://...")`), it
will send the message body as the command to execute on the remote SSH
server.

Here is an example of this within the XML DSL. Note that the command has
an XML encoded newline (`+&#10;+`).

    <route id="camel-example-ssh-producer">
      <from uri="direct:exampleSshProducer"/>
      <setBody>
        <constant>features:list&#10;</constant>
      </setBody>
      <to uri="ssh://karaf:karaf@localhost:8101"/>
      <log message="${body}"/>
    </route>

# Authentication

The SSH Component can authenticate against the remote SSH server using
one of two mechanisms: Public Key certificate or username/password.
Configuring how the SSH Component does authentication is based on how
and which options are set.

1.  First, it will look to see if the `certResource` option has been
    set, and if so, use it to locate the referenced Public Key
    certificate and use that for authentication.

2.  If `certResource` is not set, it will look to see if a
    `keyPairProvider` has been set, and if so, it will use that for
    certificate-based authentication.

3.  If neither `certResource` nor `keyPairProvider` are set, it will use
    the `username` and `password` options for authentication. Even
    though the `username` and `password` are provided in the endpoint
    configuration and headers set with `SshConstants.USERNAME_HEADER`
    (`CamelSshUsername`) and `SshConstants.PASSWORD_HEADER`
    (`CamelSshPassword`), the endpoint configuration is surpassed and
    credentials set in the headers are used.

The following route fragment shows an SSH polling consumer using a
certificate from the classpath.

In the XML DSL,

    <route>
      <from uri="ssh://scott@localhost:8101?certResource=classpath:test_rsa&amp;useFixedDelay=true&amp;delay=5000&amp;pollCommand=features:list%0A"/>
      <log message="${body}"/>
    </route>

In the Java DSL,

    from("ssh://scott@localhost:8101?certResource=classpath:test_rsa&useFixedDelay=true&delay=5000&pollCommand=features:list%0A")
        .log("${body}");

An example of using Public Key authentication is provided in
`examples/camel-example-ssh-security`.

# Certificate Dependencies

You will need to add some additional runtime dependencies if you use
certificate-based authentication. You may need to use later versions
depending on what version of Camel you are using.

The component uses `sshd-core` library which is based on either
`bouncycastle` or `eddsa` security providers. `camel-ssh` is picking
explicitly `bouncycastle` as security provider.

    <dependency>
      <groupId>org.apache.sshd</groupId>
      <artifactId>sshd-core</artifactId>
      <version>2.8.0</version>
    </dependency>
    <dependency>
      <groupId>org.bouncycastle</groupId>
      <artifactId>bcpg-jdk18on</artifactId>
      <version>1.71</version>
    </dependency>
    <dependency>
      <groupId>org.bouncycastle</groupId>
      <artifactId>bcpkix-jdk18on</artifactId>
      <version>1.71</version>
    </dependency>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|failOnUnknownHost|Specifies whether a connection to an unknown host should fail or not. This value is only checked when the property knownHosts is set.|false|boolean|
|knownHostsResource|Sets the resource path for a known\_hosts file||string|
|timeout|Sets the timeout in milliseconds to wait in establishing the remote SSH server connection. Defaults to 30000 milliseconds.|30000|integer|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|pollCommand|Sets the command string to send to the remote SSH server during every poll cycle. Only works with camel-ssh component being used as a consumer, i.e. from(ssh://...) You may need to end your command with a newline, and that must be URL encoded %0A||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|channelType|Sets the channel type to pass to the Channel as part of command execution. Defaults to exec.|exec|string|
|clientBuilder|Instance of ClientBuilder used by the producer or consumer to create a new SshClient||object|
|compressions|Whether to use compression, and if so which.||string|
|configuration|Component configuration||object|
|shellPrompt|Sets the shellPrompt to be dropped when response is read after command execution||string|
|sleepForShellPrompt|Sets the sleep period in milliseconds to wait reading response from shell prompt. Defaults to 100 milliseconds.|100|integer|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|certResource|Sets the resource path of the certificate to use for Authentication. Will use ResourceHelperKeyPairProvider to resolve file based certificate, and depends on keyType setting.||string|
|certResourcePassword|Sets the password to use in loading certResource, if certResource is an encrypted key.||string|
|ciphers|Comma-separated list of allowed/supported ciphers in their order of preference.||string|
|kex|Comma-separated list of allowed/supported key exchange algorithms in their order of preference.||string|
|keyPairProvider|Sets the KeyPairProvider reference to use when connecting using Certificates to the remote SSH Server.||object|
|keyType|Sets the key type to pass to the KeyPairProvider as part of authentication. KeyPairProvider.loadKey(...) will be passed this value. From Camel 3.0.0 / 2.25.0, by default Camel will select the first available KeyPair that is loaded. Prior to this, a KeyType of 'ssh-rsa' was enforced by default.||string|
|macs|Comma-separated list of allowed/supported message authentication code algorithms in their order of preference. The MAC algorithm is used for data integrity protection.||string|
|password|Sets the password to use in connecting to remote SSH server. Requires keyPairProvider to be set to null.||string|
|signatures|Comma-separated list of allowed/supported signature algorithms in their order of preference.||string|
|username|Sets the username to use in logging into the remote SSH server.||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|host|Sets the hostname of the remote SSH server.||string|
|port|Sets the port number for the remote SSH server.|22|integer|
|failOnUnknownHost|Specifies whether a connection to an unknown host should fail or not. This value is only checked when the property knownHosts is set.|false|boolean|
|knownHostsResource|Sets the resource path for a known\_hosts file||string|
|timeout|Sets the timeout in milliseconds to wait in establishing the remote SSH server connection. Defaults to 30000 milliseconds.|30000|integer|
|pollCommand|Sets the command string to send to the remote SSH server during every poll cycle. Only works with camel-ssh component being used as a consumer, i.e. from(ssh://...) You may need to end your command with a newline, and that must be URL encoded %0A||string|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|channelType|Sets the channel type to pass to the Channel as part of command execution. Defaults to exec.|exec|string|
|clientBuilder|Instance of ClientBuilder used by the producer or consumer to create a new SshClient||object|
|compressions|Whether to use compression, and if so which.||string|
|shellPrompt|Sets the shellPrompt to be dropped when response is read after command execution||string|
|sleepForShellPrompt|Sets the sleep period in milliseconds to wait reading response from shell prompt. Defaults to 100 milliseconds.|100|integer|
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
|certResource|Sets the resource path of the certificate to use for Authentication. Will use ResourceHelperKeyPairProvider to resolve file based certificate, and depends on keyType setting.||string|
|certResourcePassword|Sets the password to use in loading certResource, if certResource is an encrypted key.||string|
|ciphers|Comma-separated list of allowed/supported ciphers in their order of preference.||string|
|kex|Comma-separated list of allowed/supported key exchange algorithms in their order of preference.||string|
|keyPairProvider|Sets the KeyPairProvider reference to use when connecting using Certificates to the remote SSH Server.||object|
|keyType|Sets the key type to pass to the KeyPairProvider as part of authentication. KeyPairProvider.loadKey(...) will be passed this value. From Camel 3.0.0 / 2.25.0, by default Camel will select the first available KeyPair that is loaded. Prior to this, a KeyType of 'ssh-rsa' was enforced by default.||string|
|macs|Comma-separated list of allowed/supported message authentication code algorithms in their order of preference. The MAC algorithm is used for data integrity protection.||string|
|password|Sets the password to use in connecting to remote SSH server. Requires keyPairProvider to be set to null.||string|
|signatures|Comma-separated list of allowed/supported signature algorithms in their order of preference.||string|
|username|Sets the username to use in logging into the remote SSH server.||string|
