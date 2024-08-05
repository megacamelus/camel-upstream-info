# Dns

**Since Camel 2.7**

**Only producer is supported**

This is an additional component for Camel to run DNS queries, using
DNSJava. The component is a thin layer on top of
[DNSJava](http://www.xbill.org/dnsjava/). The component offers the
following operations:

-   `ip`: to resolve a domain by its ip

-   `lookup`: to lookup information about the domain

-   `dig`: to run DNS queries

**Requires SUN JVM**

The DNSJava library requires running on the SUN JVM. If you use Apache
ServiceMix or Apache Karaf, you’ll need to adjust the
`etc/jre.properties` file, to add `sun.net.spi.nameservice` to the list
of Java platform packages exported. The server will need restarting
before this change takes effect.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-dns</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

The URI scheme for a DNS component is as follows

    dns://operation[?options]

# Examples

## IP lookup

    <route id="IPCheck">
        <from uri="direct:start"/>
        <to uri="dns:ip"/>
    </route>

This looks up a domain’s IP. For example, *www.example.com* resolves to
192\.0.32.10.

The IP address to lookup must be provided in the header with key
`"dns.domain"`.

## DNS lookup

    <route id="IPCheck">
        <from uri="direct:start"/>
        <to uri="dns:lookup"/>
    </route>

This returns a set of DNS records associated with a domain.  
The name to lookup must be provided in the header with key `"dns.name"`.

## DNS Dig

Dig is a Unix command-line utility to run DNS queries.

    <route id="IPCheck">
        <from uri="direct:start"/>
        <to uri="dns:dig"/>
    </route>

The query must be provided in the header with key `"dns.query"`.

# Dns Activation Policy

The `DnsActivationPolicy` can be used to dynamically start and stop
routes based on dns state.

If you have instances of the same component running in different
regions, you can configure a route in each region to activate only if
dns is pointing to its region.

For example, you may have an instance in NYC and an instance in SFO. You
would configure a service CNAME service.example.com to point to
nyc-service.example.com to bring NYC instance up and SFO instance down.
When you change the CNAME service.example.com to point to
sfo-service.example.com — nyc instance would stop its routes and sfo
will bring its routes up. This allows you to switch regions without
restarting actual components.

     <bean id="dnsActivationPolicy" class="org.apache.camel.component.dns.policy.DnsActivationPolicy">
         <property name="hostname" value="service.example.com" />
         <property name="resolvesTo" value="nyc-service.example.com" />
         <property name="ttl" value="60000" />
         <property name="stopRoutesOnException" value="false" />
     </bean>
    
     <route id="routeId" autoStartup="false" routePolicyRef="dnsActivationPolicy">
     </route>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|dnsType|The type of the lookup.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
