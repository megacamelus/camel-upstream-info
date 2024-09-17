# Ehcache

**Since Camel 2.18**

**Both producer and consumer are supported**

The Ehcache component enables you to perform caching operations using
Ehcache 3 as the Cache Implementation.

The Cache consumer is an event based consumer and can be used to listen
and respond to specific cache activities.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-ehcache</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    ehcache://cacheName[?options]

# Examples

## Ehcache based idempotent repository example:

    CacheManager manager = CacheManagerBuilder.newCacheManager(new XmlConfiguration("ehcache.xml"));
    EhcacheIdempotentRepository repo = new EhcacheIdempotentRepository(manager, "idempotent-cache");
    
    from("direct:in")
        .idempotentConsumer(header("messageId"), idempotentRepo)
        .to("mock:out");

## Ehcache based aggregation repository example:

    public class EhcacheAggregationRepositoryRoutesTest extends CamelTestSupport {
        private static final String ENDPOINT_MOCK = "mock:result";
        private static final String ENDPOINT_DIRECT = "direct:one";
        private static final int[] VALUES = generateRandomArrayOfInt(10, 0, 30);
        private static final int SUM = IntStream.of(VALUES).reduce(0, (a, b) -> a + b);
        private static final String CORRELATOR = "CORRELATOR";
    
        @EndpointInject(ENDPOINT_MOCK)
        private MockEndpoint mock;
    
        @Produce(uri = ENDPOINT_DIRECT)
        private ProducerTemplate producer;
    
        @Test
        public void checkAggregationFromOneRoute() throws Exception {
            mock.expectedMessageCount(VALUES.length);
            mock.expectedBodiesReceived(SUM);
    
            IntStream.of(VALUES).forEach(
                i -> producer.sendBodyAndHeader(i, CORRELATOR, CORRELATOR)
            );
    
            mock.assertIsSatisfied();
        }
    
        private Exchange aggregate(Exchange oldExchange, Exchange newExchange) {
            if (oldExchange == null) {
                return newExchange;
            } else {
                Integer n = newExchange.getIn().getBody(Integer.class);
                Integer o = oldExchange.getIn().getBody(Integer.class);
                Integer v = (o == null ? 0 : o) + (n == null ? 0 : n);
    
                oldExchange.getIn().setBody(v, Integer.class);
    
                return oldExchange;
            }
        }
    
        @Override
        protected RoutesBuilder createRouteBuilder() throws Exception {
            return new RouteBuilder() {
                @Override
                public void configure() throws Exception {
                    from(ENDPOINT_DIRECT)
                        .routeId("AggregatingRouteOne")
                        .aggregate(header(CORRELATOR))
                        .aggregationRepository(createAggregateRepository())
                        .aggregationStrategy(EhcacheAggregationRepositoryRoutesTest.this::aggregate)
                        .completionSize(VALUES.length)
                            .to("log:org.apache.camel.component.ehcache.processor.aggregate.level=INFO&showAll=true&mulltiline=true")
                            .to(ENDPOINT_MOCK);
                }
            };
        }
    
        protected EhcacheAggregationRepository createAggregateRepository() throws Exception {
            CacheManager cacheManager = CacheManagerBuilder.newCacheManager(new XmlConfiguration("ehcache.xml"));
            cacheManager.init();
    
            EhcacheAggregationRepository repository = new EhcacheAggregationRepository();
            repository.setCacheManager(cacheManager);
            repository.setCacheName("aggregate");
    
            return repository;
        }
    }

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|cacheManager|The cache manager||object|
|cacheManagerConfiguration|The cache manager configuration||object|
|configurationUri|URI pointing to the Ehcache XML configuration file's location||string|
|createCacheIfNotExist|Configure if a cache need to be created if it does exist or can't be pre-configured.|true|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|eventFiring|Set the delivery mode (synchronous, asynchronous)|ASYNCHRONOUS|object|
|eventOrdering|Set the delivery mode (ordered, unordered)|ORDERED|object|
|eventTypes|Set the type of events to listen for (EVICTED,EXPIRED,REMOVED,CREATED,UPDATED). You can specify multiple entries separated by comma.||string|
|action|To configure the default cache action. If an action is set in the message header, then the operation from the header takes precedence.||string|
|key|To configure the default action key. If a key is set in the message header, then the key from the header takes precedence.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|configuration|The default cache configuration to be used to create caches.||object|
|configurations|A map of cache configuration to be used to create caches.||object|
|keyType|The cache key type, default java.lang.Object||string|
|valueType|The cache value type, default java.lang.Object||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|cacheName|the cache name||string|
|cacheManager|The cache manager||object|
|cacheManagerConfiguration|The cache manager configuration||object|
|configurationUri|URI pointing to the Ehcache XML configuration file's location||string|
|createCacheIfNotExist|Configure if a cache need to be created if it does exist or can't be pre-configured.|true|boolean|
|eventFiring|Set the delivery mode (synchronous, asynchronous)|ASYNCHRONOUS|object|
|eventOrdering|Set the delivery mode (ordered, unordered)|ORDERED|object|
|eventTypes|Set the type of events to listen for (EVICTED,EXPIRED,REMOVED,CREATED,UPDATED). You can specify multiple entries separated by comma.||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|action|To configure the default cache action. If an action is set in the message header, then the operation from the header takes precedence.||string|
|key|To configure the default action key. If a key is set in the message header, then the key from the header takes precedence.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|configuration|The default cache configuration to be used to create caches.||object|
|configurations|A map of cache configuration to be used to create caches.||object|
|keyType|The cache key type, default java.lang.Object||string|
|valueType|The cache value type, default java.lang.Object||string|
