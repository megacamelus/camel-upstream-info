# Git

**Since Camel 2.16**

**Both producer and consumer are supported**

The Git component allows you to work with a generic Git repository.

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-git</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

**URI Format**

    git://localRepositoryPath[?options]

# URI Options

The producer allows doing operations on a specific repository. The
consumer allows consuming commits, tags, and branches in a specific
repository.

# Examples

## Producer Example

Below is an example route of a producer that adds a file test.java to a
local repository, commits it with a specific message on the `main`
branch and then pushes it to remote repository.

    from("direct:start")
        .setHeader(GitConstants.GIT_FILE_NAME, constant("test.java"))
        .to("git:///tmp/testRepo?operation=add")
        .setHeader(GitConstants.GIT_COMMIT_MESSAGE, constant("first commit"))
        .to("git:///tmp/testRepo?operation=commit")
        .to("git:///tmp/testRepo?operation=push&remotePath=https://foo.com/test/test.git&username=xxx&password=xxx")
        .to("git:///tmp/testRepo?operation=createTag&tagName=myTag")
        .to("git:///tmp/testRepo?operation=pushTag&tagName=myTag&remoteName=origin");

## Consumer Example

Below is an example route of a consumer that consumes commit:

    from("git:///tmp/testRepo?type=commit")
        .to(....)

## Custom config file

By default, camel-git will load \`\`.gitconfig\`\` file from user home
folder. You can override this by providing your own \`\`.gitconfig\`\`
file.

    from("git:///tmp/testRepo?type=commit&gitConfigFile=file:/tmp/configfile")
        .to(....); // will load from os dirs
    
    from("git:///tmp/testRepo?type=commit&gitConfigFile=classpath:configfile")
        .to(....); // will load from resources dir
    
    from("git:///tmp/testRepo?type=commit&gitConfigFile=http://somedomain.xyz/gitconfigfile")
        .to(....); // will load from http. You could also use https

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
|localPath|Local repository path||string|
|branchName|The branch name to work on||string|
|type|The consumer type||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|allowEmpty|The flag to manage empty git commits|true|boolean|
|operation|The operation to do on the repository||string|
|password|Remote repository password||string|
|remoteName|The remote repository name to use in particular operation like pull||string|
|remotePath|The remote repository path||string|
|tagName|The tag name to work on||string|
|targetBranchName|Name of target branch in merge operation. If not supplied will try to use init.defaultBranch git configs. If not configured will use default value|master|string|
|username|Remote repository username||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|gitConfigFile|A String with path to a .gitconfig file||string|
