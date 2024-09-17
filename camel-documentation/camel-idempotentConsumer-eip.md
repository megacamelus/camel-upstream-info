# IdempotentConsumer-eip.md

The [Idempotent
Consumer](http://www.enterpriseintegrationpatterns.com/IdempotentReceiver.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc) is used
to filter out duplicate messages.

The Idempotent Consumer essentially acts like a [Message
Filter](#filter-eip.adoc) to filter out duplicates.

Camel will add the message id eagerly to the repository to detect
duplication also for [Exchange](#manual::exchange.adoc)*s* currently in
progress. On completion Camel will remove the message id from the
repository if the [Exchange](#manual::exchange.adoc) failed, otherwise
it stays there.

# Options

# Exchange properties

# Idempotent Consumer implementations

The idempotent consumer provides a pluggable repository which you can
implement your own `org.apache.camel.spi.IdempotentRepository`.

Camel provides the following Idempotent Consumer implementations:

-   MemoryIdempotentRepository from `camel-support` JAR

-   [CaffeineIdempotentRepository](#ROOT:caffeine-cache-component.adoc)

-   [CassandraIdempotentRepository](#ROOT:cql-component.adoc)
    [NamedCassandraIdempotentRepository](#ROOT:cql-component.adoc)

-   [EHCacheIdempotentRepository](#ROOT:ehcache-component.adoc)

-   [HazelcastIdempotentRepository](#ROOT:hazelcast-summary.adoc)

-   [InfinispanIdempotentRepository](#ROOT:infinispan-component.adoc)
    [InfinispanEmbeddedIdempotentRepository](#ROOT:infinispan-component.adoc)
    [InfinispanRemoteIdempotentRepository](#ROOT:infinispan-component.adoc)

-   [JCacheIdempotentRepository](#ROOT:jcache-component.adoc)

-   [JpaMessageIdRepository](#ROOT:jpa-component.adoc)

-   [KafkaIdempotentRepository](#ROOT:kafka-component.adoc)

-   [MongoDbIdempotentRepository](#ROOT:mongodb-component.adoc)

-   [RedisIdempotentRepository](#ROOT:spring-redis-component.adoc)
    [RedisStringIdempotentRepository](#ROOT:spring-redis-component.adoc)

-   [SpringCacheIdempotentRepository](#manual::spring.adoc)

-   [JdbcMessageIdRepository](#ROOT:sql-component.adoc)
    [JdbcOrphanLockAwareIdempotentRepository](#ROOT:sql-component.adoc)

# Example

For example, see the above implementations for more details.
