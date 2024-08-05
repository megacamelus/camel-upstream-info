# Jcache

**Since Camel 2.17**

**Both producer and consumer are supported**

The JCache component enables you to perform caching operations using
JSR107/JCache as cache implementation.

# URI Format

    jcache:cacheName[?options]

# JCache Policy

The JCachePolicy is an interceptor around a route that caches the
"result of the route" (the message body) after the route is completed.
If the next time the route is called with a "similar" Exchange, the
cached value is used on the Exchange instead of executing the route. The
policy uses the JSR107/JCache API of a cache implementation, so it’s
required to add one (e.g., Hazelcast, Ehcache) to the classpath.

The policy takes a *key* value from the received Exchange to get or
store values in the cache. By default, the *key* is the message body.
For example, if the route - having a JCachePolicy - receives an Exchange
with a String body *"fruit"* and the body at the end of the route is
"apple", it stores a *key/value* pair *"fruit=apple"* in the cache. If
next time another Exchange arrives with a body *"fruit"*, the value
*"apple"* is taken from the cache instead of letting the route process
the Exchange.

So by default, the message body at the beginning of the route is the
cache *key* and the body at the end is the stored *value*. It’s possible
to use something else as a *key* by setting a Camel Expression via
`.setKeyExpression()` that will be used to determine the key.

The policy needs a JCache Cache. It can be set directly by `.setCache()`
or the policy will try to get or create the Cache based on the other
parameters set.

Similar caching solution is available, for example, in Spring using the
@Cacheable annotation.

# JCachePolicy Fields

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 41%" />
<col style="width: 24%" />
<col style="width: 16%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: left;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><strong>cache</strong></p></td>
<td style="text-align: left;"><p>The Cache to use to store the cached
values. If this value is set, <code>cacheManager</code>,
<code>cacheName</code> and <code>cacheConfiguration</code> is
ignored.</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Cache</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><strong>cacheManager</strong></p></td>
<td style="text-align: left;"><p>The CacheManager to use to look up or
create the Cache. Used only if <code>cache</code> is not set.</p></td>
<td style="text-align: left;"><p>Try to find a <code>CacheManager</code>
in the <code>CamelContext</code> registry or calls the standard JCache
<code>Caching.getCachingProvider().getCacheManager()</code>.</p></td>
<td style="text-align: left;"><p>CacheManager</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><strong>cacheName</strong></p></td>
<td style="text-align: left;"><p>Name of the cache. Get the Cache from
<code>cacheManager</code> or create a new one if it doesn’t
exist.</p></td>
<td style="text-align: left;"><p>RouteId of the route.</p></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><strong>cacheConfiguration</strong></p></td>
<td style="text-align: left;"><p>JCache cache configuration to use if a
new Cache is created</p></td>
<td style="text-align: left;"><p>Default new
<code>MutableConfiguration</code> object.</p></td>
<td style="text-align: left;"><p>CacheConfiguration</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><strong>keyExpression</strong></p></td>
<td style="text-align: left;"><p>An Expression to evaluate to determine
the cache key.</p></td>
<td style="text-align: left;"><p>Exchange body</p></td>
<td style="text-align: left;"><p>Expression</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><strong>enabled</strong></p></td>
<td style="text-align: left;"><p>If the policy is not enabled, no
wrapper processor is added to the route. It has impact only during
startup, not during runtime. For example, it can be used to disable
caching from properties.</p></td>
<td style="text-align: left;"><p>true</p></td>
<td style="text-align: left;"><p>boolean</p></td>
</tr>
</tbody>
</table>

# How to determine cache to use?

# Set cache

The cache used by the policy can be set directly. This means you have to
configure the cache yourself and get a JCache Cache object, but this
gives the most flexibility. For example, it can be setup in the config
xml of the cache provider (Hazelcast, EhCache, …) and used here. Or it’s
possible to use the standard Caching API as below:

    MutableConfiguration configuration = new MutableConfiguration<>();
    configuration.setTypes(String.class, Object.class);
    configuration.setExpiryPolicyFactory(CreatedExpiryPolicy.factoryOf(new Duration(TimeUnit.MINUTES, 60)));
    CacheManager cacheManager = Caching.getCachingProvider().getCacheManager();
    Cache cache = cacheManager.createCache("orders",configuration);
    
    JCachePolicy jcachePolicy = new JCachePolicy();
    jcachePolicy.setCache(cache);
    
    from("direct:get-orders")
        .policy(jcachePolicy)
        .log("Getting order with id: ${body}")
        .bean(OrderService.class,"findOrderById(${body})");

# Set cacheManager

If the `cache` is not set, the policy will try to look up or create the
cache automatically. If the `cacheManager` is set on the policy, it will
try to get cache with the set `cacheName` (routeId by default) from the
CacheManager. If the cache does not exist, it will create a new one
using the `cacheConfiguration` (new MutableConfiguration by default).

    //In a Spring environment, for example, the CacheManager may already exist as a bean
    @Autowire
    CacheManager cacheManager;
    ...
    
    //Cache "items" is used or created if not exists
    JCachePolicy jcachePolicy = new JCachePolicy();
    jcachePolicy.setCacheManager(cacheManager);
    jcachePolicy.setCacheName("items")

# Find cacheManager

If `cacheManager` (and the `cache`) is not set, the policy will try to
find a JCache CacheManager object:

-   Lookup a CacheManager in Camel registry. That falls back on JNDI or
    Spring context based on the environment

-   Use the standard api
    `Caching.getCachingProvider().getCacheManager()`

<!-- -->

    //A Cache "getorders" will be used (or created) from the found CacheManager
    from("direct:get-orders").routeId("getorders")
        .policy(new JCachePolicy())
        .log("Getting order with id: ${body}")
        .bean(OrderService.class,"findOrderById(${body})");

# Partially wrapped route

In the examples above, the whole route was executed or skipped. A policy
can be used to wrap only a segment of the route instead of all
processors.

    from("direct:get-orders")
        .log("Order requested: ${body}")
        .policy(new JCachePolicy())
            .log("Getting order with id: ${body}")
            .bean(OrderService.class,"findOrderById(${body})")
        .end()
        .log("Order found: ${body}");

The `.log()` at the beginning and at the end of the route is always
called, but the section inside `.policy()` and `.end()` is executed
based on the cache.

# KeyExpression

By default, the policy uses the received Exchange body as the *key*, so
the default expression is like `simple("${body\}")`. We can set a
different Camel Expression as `keyExpression` which will be evaluated to
determine the key. For example, if we try to find an `order` by an
`orderId` which is in the message headers, set `header("orderId")` (or
`simple("${header.orderId\}")` as `keyExpression`.

The expression is evaluated only once at the beginning of the route to
determine the *key*. If nothing was found in cache, this *key* is used
to store the *value* in cache at the end of the route.

    MutableConfiguration configuration = new MutableConfiguration<>();
    configuration.setTypes(String.class, Order.class);
    configuration.setExpiryPolicyFactory(CreatedExpiryPolicy.factoryOf(new Duration(TimeUnit.MINUTES, 10)));
    
    JCachePolicy jcachePolicy = new JCachePolicy();
    jcachePolicy.setCacheConfiguration(configuration);
    jcachePolicy.setCacheName("orders")
    jcachePolicy.setKeyExpression(simple("${header.orderId}))
    
    //The cache key is taken from "orderId" header.
    from("direct:get-orders")
        .policy(jcachePolicy)
        .log("Getting order with id: ${header.orderId}")
        .bean(OrderService.class,"findOrderById(${header.orderId})");

# BypassExpression

The `JCachePolicy` can be configured with an `Expression` that can per
`Exchange` determine whether to look up the value from the cache or
bypass. If the expression is evaluated to `false` then the route is
executed as normal, and the returned value is inserted into the cache
for future lookup.

# Camel XML DSL examples

# Use JCachePolicy in an XML route

In Camel XML DSL, we need a named reference to the JCachePolicy instance
(registered in CamelContext or simply in Spring). We have to wrap the
route between `<policy>...</policy>` tags after `<from>`.

    <camelContext xmlns="http://camel.apache.org/schema/spring">
        <route>
            <from uri="direct:get-order"/>
            <policy ref="jCachePolicy" >
                <setBody>
                    <method ref="orderService" method="findOrderById(${body})"/>
                </setBody>
            </policy>
        </route>
    </camelContext>

See this example when only a part of the route is wrapped:

    <camelContext xmlns="http://camel.apache.org/schema/spring">
        <route>
            <from uri="direct:get-order"/>
            <log message="Start - This is always called. body:${body}"/>
            <policy ref="jCachePolicy" >
                <log message="Executing route, not found in cache. body:${body}"/>
                <setBody>
                    <method ref="orderService" method="findOrderById(${body})"/>
                </setBody>
            </policy>
            <log message="End - This is always called. body:${body}"/>
        </route>
    </camelContext>

# Define CachePolicy in Spring

It’s more convenient to create a JCachePolicy in Java, especially within
a RouteBuilder using the Camel DSL expressions, but see this example to
define it in a Spring XML:

    <bean id="jCachePolicy" class="org.apache.camel.component.jcache.policy.JCachePolicy">
        <property name="cacheName" value="spring"/>
        <property name="keyExpression">
            <bean class="org.apache.camel.model.language.SimpleExpression">
                <property name="expression" value="${header.mykey}"/>
            </bean>
        </property>
    </bean>

# Create Cache from XML

It’s not strictly speaking related to Camel XML DSL, but JCache
providers usually have a way to configure the cache in an XML file. For
example with Hazelcast, you can add a `hazelcast.xml` to classpath to
configure the cache "spring" used in the example above.

    <hazelcast xmlns="http://www.hazelcast.com/schema/config"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xsi:schemaLocation="http://www.hazelcast.com/schema/config http://www.hazelcast.com/schema/config/hazelcast-config-4.0.xsd">
    
        <cache name="spring">
            <key-type class-name="java.lang.String"/>
            <value-type class-name="java.lang.String"/>
            <expiry-policy-factory>
                <timed-expiry-policy-factory expiry-policy-type="CREATED" duration-amount="60" time-unit="MINUTES"/>
            </expiry-policy-factory>
        </cache>
    
    </hazelcast>

# Special scenarios and error handling

If the Cache used by the policy is closed (can be done dynamically), the
whole caching functionality is skipped, the route will be executed every
time.

If the determined *key* is *null*, nothing is looked up or stored in
cache.

In case of an exception during the route, the error handled is called as
always. If the exception gets `handled()`, the policy stores the
Exchange body. Otherwise, nothing is added to the cache. If an exception
happens during evaluating the keyExpression, the routing fails, the
error handler is called as normally.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|cacheConfiguration|A Configuration for the Cache||object|
|cacheConfigurationProperties|Properties to configure jcache||object|
|cacheConfigurationPropertiesRef|References to an existing Properties or Map to lookup in the registry to use for configuring jcache.||string|
|cachingProvider|The fully qualified class name of the javax.cache.spi.CachingProvider||string|
|configurationUri|An implementation specific URI for the CacheManager||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|cacheName|The name of the cache||string|
|cacheConfigurationProperties|The Properties for the javax.cache.spi.CachingProvider to create the CacheManager||object|
|cachingProvider|The fully qualified class name of the javax.cache.spi.CachingProvider||string|
|configurationUri|An implementation specific URI for the CacheManager||string|
|managementEnabled|Whether management gathering is enabled|false|boolean|
|readThrough|If read-through caching should be used|false|boolean|
|statisticsEnabled|Whether statistics gathering is enabled|false|boolean|
|storeByValue|If cache should use store-by-value or store-by-reference semantics|true|boolean|
|writeThrough|If write-through caching should be used|false|boolean|
|filteredEvents|Events a consumer should filter (multiple events can be separated by comma). If using filteredEvents option, then eventFilters one will be ignored||string|
|oldValueRequired|if the old value is required for events|false|boolean|
|synchronous|if the event listener should block the thread causing the event|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|eventFilters|The CacheEntryEventFilter. If using eventFilters option, then filteredEvents one will be ignored||array|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|action|To configure using a cache operation by default. If an operation in the message header, then the operation from the header takes precedence.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|cacheConfiguration|A Configuration for the Cache||object|
|cacheLoaderFactory|The CacheLoader factory||object|
|cacheWriterFactory|The CacheWriter factory||object|
|createCacheIfNotExists|Configure if a cache need to be created if it does exist or can't be pre-configured.|true|boolean|
|expiryPolicyFactory|The ExpiryPolicy factory||object|
|lookupProviders|Configure if a camel-cache should try to find implementations of jcache api in runtimes like OSGi.|false|boolean|
