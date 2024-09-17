# File-watch

**Since Camel 3.0**

**Only consumer is supported**

This component can be used to watch file modification events in the
folder. It is based on the project
[directory-watcher](https://github.com/gmethvin/directory-watcher).

# URI Options

# Examples

## Recursive watch all events (file creation, file deletion, file modification):

    from("file-watch://some-directory")
        .log("File event: ${header.CamelFileEventType} occurred on file ${header.CamelFileName} at ${header.CamelFileLastModified}");

## Recursive watch for creation and deletion of txt files:

    from("file-watch://some-directory?events=DELETE,CREATE&antInclude=**/*.txt")
        .log("File event: ${header.CamelFileEventType} occurred on file ${header.CamelFileName} at ${header.CamelFileLastModified}");

## Create a snapshot of file when modified:

    from("file-watch://some-directory?events=MODIFY&recursive=false")
        .setHeader(Exchange.FILE_NAME, simple("${header.CamelFileName}.${header.CamelFileLastModified}"))
        .to("file:some-directory/snapshots");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|useFileHashing|Enables or disables file hashing to detect duplicate events. If you disable this, you can get some events multiple times on some platforms and JDKs. Check java.nio.file.WatchService limitations for your target platform.|true|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|concurrentConsumers|The number of concurrent consumers. Increase this value, if your route is slow to prevent buffering in queue.|1|integer|
|fileHasher|Reference to io.methvin.watcher.hashing.FileHasher. This prevents emitting duplicate events on some platforms. For working with large files and if you dont need detect multiple modifications per second per file, use #lastModifiedTimeFileHasher. You can also provide custom implementation in registry.|#murmur3FFileHasher|object|
|pollThreads|The number of threads polling WatchService. Increase this value, if you see OVERFLOW messages in log.|1|integer|
|queueSize|Maximum size of queue between WatchService and consumer. Unbounded by default.|2147483647|integer|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|path|Path of directory to consume events from.||string|
|antInclude|ANT style pattern to match files. The file is matched against path relative to endpoint path. Pattern must be also relative (not starting with slash)|\*\*|string|
|autoCreate|Auto create directory if does not exist.|true|boolean|
|events|Comma separated list of events to watch. Possible values: CREATE,MODIFY,DELETE|CREATE,MODIFY,DELETE|string|
|recursive|Watch recursive in current and child directories (including newly created directories).|true|boolean|
|useFileHashing|Enables or disables file hashing to detect duplicate events. If you disable this, you can get some events multiple times on some platforms and JDKs. Check java.nio.file.WatchService limitations for your target platform.|true|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|concurrentConsumers|The number of concurrent consumers. Increase this value, if your route is slow to prevent buffering in queue.|1|integer|
|fileHasher|Reference to io.methvin.watcher.hashing.FileHasher. This prevents emitting duplicate events on some platforms. For working with large files and if you dont need detect multiple modifications per second per file, use #lastModifiedTimeFileHasher. You can also provide custom implementation in registry.|#murmur3FFileHasher|object|
|pollThreads|The number of threads polling WatchService. Increase this value, if you see OVERFLOW messages in log.|1|integer|
|queueSize|Maximum size of queue between WatchService and consumer. Unbounded by default.|2147483647|integer|
