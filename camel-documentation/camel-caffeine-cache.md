# Caffeine-cache

**Since Camel 2.20**

**Only producer is supported**

The Caffeine Cache component enables you to perform caching operations
using the simple cache from Caffeine.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-caffeine</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>
    
    caffeine-cache://cacheName[?options]

You can append query options to the URI in the following format:
`?option=value&option=#beanRef&...`.

# Usage

## Checking the operation result

Each time you’ll use an operation on the cache, you’ll have two
different headers to check for status:

-   `CaffeineConstants.ACTION_HAS_RESULT`

-   `CaffeineConstants.ACTION_SUCCEEDED`

# Examples

You can use your cache with the following code:

    @BindToRegistry("cache")
    Cache cache = Caffeine.newBuilder().recordStats().build();
    
    @Override
    protected RouteBuilder createRouteBuilder() throws Exception {
        return new RouteBuilder() {
            public void configure() {
                from("direct://start")
                    .to("caffeine-cache://cache?action=PUT&key=1")
                    .to("caffeine-cache://cache?key=1&action=GET")
                    .log("Test! ${body}")
                    .to("mock:result");
            }
        };
    }

In this way, you’ll work always on the same cache in the registry.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|action|To configure the default cache action. If an action is set in the message header, then the operation from the header takes precedence.||string|
|createCacheIfNotExist|Automatic create the Caffeine cache if none has been configured or exists in the registry.|true|boolean|
|evictionType|Set the eviction Type for this cache|SIZE\_BASED|object|
|expireAfterAccessTime|Specifies that each entry should be automatically removed from the cache once a fixed duration has elapsed after the entry's creation, the most recent replacement of its value, or its last read. Access time is reset by all cache read and write operations. The unit is in seconds.|300|integer|
|expireAfterWriteTime|Specifies that each entry should be automatically removed from the cache once a fixed duration has elapsed after the entry's creation, or the most recent replacement of its value. The unit is in seconds.|300|integer|
|initialCapacity|Sets the minimum total size for the internal data structures. Providing a large enough estimate at construction time avoids the need for expensive resizing operations later, but setting this value unnecessarily high wastes memory.||integer|
|key|To configure the default action key. If a key is set in the message header, then the key from the header takes precedence.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|maximumSize|Specifies the maximum number of entries the cache may contain. Note that the cache may evict an entry before this limit is exceeded or temporarily exceed the threshold while evicting. As the cache size grows close to the maximum, the cache evicts entries that are less likely to be used again. For example, the cache may evict an entry because it hasn't been used recently or very often. When size is zero, elements will be evicted immediately after being loaded into the cache. This can be useful in testing or to disable caching temporarily without a code change. As eviction is scheduled on the configured executor, tests may instead prefer to configure the cache to execute tasks directly on the same thread.||integer|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|cacheLoader|To configure a CacheLoader in case of a LoadCache use||object|
|configuration|Sets the global component configuration||object|
|removalListener|Set a specific removal Listener for the cache||object|
|statsCounter|Set a specific Stats Counter for the cache stats||object|
|statsEnabled|To enable stats on the cache|false|boolean|
|valueType|The cache value type, default java.lang.Object||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|cacheName|Cache name||string|
|action|To configure the default cache action. If an action is set in the message header, then the operation from the header takes precedence.||string|
|createCacheIfNotExist|Automatic create the Caffeine cache if none has been configured or exists in the registry.|true|boolean|
|evictionType|Set the eviction Type for this cache|SIZE\_BASED|object|
|expireAfterAccessTime|Specifies that each entry should be automatically removed from the cache once a fixed duration has elapsed after the entry's creation, the most recent replacement of its value, or its last read. Access time is reset by all cache read and write operations. The unit is in seconds.|300|integer|
|expireAfterWriteTime|Specifies that each entry should be automatically removed from the cache once a fixed duration has elapsed after the entry's creation, or the most recent replacement of its value. The unit is in seconds.|300|integer|
|initialCapacity|Sets the minimum total size for the internal data structures. Providing a large enough estimate at construction time avoids the need for expensive resizing operations later, but setting this value unnecessarily high wastes memory.||integer|
|key|To configure the default action key. If a key is set in the message header, then the key from the header takes precedence.||string|
|maximumSize|Specifies the maximum number of entries the cache may contain. Note that the cache may evict an entry before this limit is exceeded or temporarily exceed the threshold while evicting. As the cache size grows close to the maximum, the cache evicts entries that are less likely to be used again. For example, the cache may evict an entry because it hasn't been used recently or very often. When size is zero, elements will be evicted immediately after being loaded into the cache. This can be useful in testing or to disable caching temporarily without a code change. As eviction is scheduled on the configured executor, tests may instead prefer to configure the cache to execute tasks directly on the same thread.||integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|cacheLoader|To configure a CacheLoader in case of a LoadCache use||object|
|removalListener|Set a specific removal Listener for the cache||object|
|statsCounter|Set a specific Stats Counter for the cache stats||object|
|statsEnabled|To enable stats on the cache|false|boolean|
|valueType|The cache value type, default java.lang.Object||string|
