# ServiceCall-eip.md

The Service Call EIP is deprecated in Camel 3.x and will be removed in a
future Camel release. There is no direct replacement. If you use
Kubernetes, then services can be called directly by name.

How can I call a remote service in a distributed system where the
service is looked up from a service registry of some sorts?

<figure>
<img src="eip/MessagingGatewayIcon.gif" alt="image" />
</figure>

Use a Service Call acting as a [Messaging
Gateway](#messaging-gateway.adoc) for distributed systems that handles
the complexity of calling the service in a reliable manner.

The pattern has the following noteworthy features:

-   *Location transparency*: Decouples Camel and the physical location
    of the services using logical names representing the services.

-   *URI templating*: Allows you to template the Camel endpoint URI as
    the physical endpoint to use when calling the service.

-   *Service discovery*: it looks up the service from a service registry
    of some sort to know the physical locations of the services.

-   *Service filter*: Allows you to filter unwanted services (for
    example, blacklisted or unhealthy services).

-   *Service chooser*: Allows you to choose the most appropriate service
    based on factors such as geographical zone, affinity, plans, canary
    deployments, and SLAs.

-   *Load balancer*: A preconfigured Service Discovery, Filter, and
    Chooser intended for a specific runtime (these three features
    combined as one).

In a nutshell, the EIP pattern sits between your Camel application and
the services running in a distributed system (cluster). The pattern
hides all the complexity of keeping track of all the physical locations
where the services are running and allows you to call the service by a
name.

# Options

# Exchange properties

# Using Service Call

The service to call is looked up in a service registry of some sorts
such as Kubernetes, Consul, Zookeeper, DNS. The EIP separates the
configuration of the service registry from the calling of the service.

When calling a service, you may refer to the name of the service in the
EIP as shown below:

    from("direct:start")
        .serviceCall("foo")
        .to("mock:result");

And in XML:

    <camelContext xmlns="http://camel.apache.org/schema/spring">
      <route>
        <from uri="direct:start"/>
        <serviceCall name="foo"/>
        <to uri="mock:result"/>
      </route>
    </camelContext>

Camel will then:

-   search for a service call configuration from the Camel context and
    registry

-   lookup a service with the name \`\`\`foo\`\`\` from an external
    service registry

-   filter the servers

-   select the server to use

-   build a Camel URI using the chosen server info

By default, the Service Call EIP uses `camel-http` so assuming that the
selected service instance runs on host \`\`\`myhost.com\`\`\` on port
\`\`\`80\`\`\`, the computed Camel URI will be:

    http:myhost.com:80

## Mapping Service Name to Endpoint URI

It is often needed to build more complex Camel URI which may include
options or paths, which is possible through different options:name:
value

The **service name** supports a limited uri like syntax, here are some
examples

<table>
<colgroup>
<col style="width: 24%" />
<col style="width: 75%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Resolution</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>foo</p></td>
<td style="text-align: left;"><pre><code>http://host:port</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>foo/path</p></td>
<td style="text-align: left;"><pre><code>http://host:port/path</code></pre></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>foo/path?foo=bar</p></td>
<td style="text-align: left;"><pre><code>http://host:port/path?foo=bar</code></pre></td>
</tr>
</tbody>
</table>

    from("direct:start")
        .serviceCall("foo/hello")
        .to("mock:result");

If you want to have more control over the uri construction, you can use
the **uri** directive:

<table>
<colgroup>
<col style="width: 24%" />
<col style="width: 40%" />
<col style="width: 35%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">URI</th>
<th style="text-align: left;">Resolution</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>foo</p></td>
<td style="text-align: left;"><pre><code>undertow:http://foo/hello</code></pre></td>
<td style="text-align: left;"><pre><code>undertow:http://host:port/hello</code></pre></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>foo</p></td>
<td style="text-align: left;"><pre><code>undertow:http://foo.host:foo.port/hello</code></pre></td>
<td style="text-align: left;"><pre><code>undertow:http://host:port/hello</code></pre></td>
</tr>
</tbody>
</table>

    from("direct:start")
        .serviceCall("foo", "undertow:http://foo/hello")
        .to("mock:result");

Advanced users can have full control over the uri construction through
expressions:

    from("direct:start")
        .serviceCall()
            .name("foo")
            .expression()
                .simple("undertow:http://${header.CamelServiceCallServiceHost}:${header.CamelServiceCallServicePort}/hello");

## Static Service Discovery

This service discovery implementation does not query any external
services to find out the list of services associated with a named
service but keep them in memory. Each service should be provided in the
following form:

    [service@]host:port

The \`\`service\`\` part is used to discriminate against the services
but if not provided it acts like a wildcard so each non named service
will be returned whatever the service name is. This is useful if you
have a single service so the service name is redundant.

This implementation is provided by \`\`camel-core\`\` artifact.

Available options:

<table>
<colgroup>
<col style="width: 30%" />
<col style="width: 10%" />
<col style="width: 59%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Java Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>servers</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>A comma separated list of servers in
the form:
[service@]host:port,[service@]host2:port,[service@]host3:port</p></td>
</tr>
</tbody>
</table>

    from("direct:start")
        .serviceCall("foo")
            .staticServiceDiscovery()
                .servers("service1@host1:80,service1@host2:80")
                .servers("service2@host1:8080,service2@host2:8080,service2@host3:8080")
                .end()
        .to("mock:result");

And in XML:

    <camelContext xmlns="http://camel.apache.org/schema/spring">
      <route>
        <from uri="direct:start"/>
        <serviceCall name="foo">
          <staticServiceDiscovery>
            <servers>service1@host1:80,service1@host2:80</servers>
            <servers>service2@host1:8080,service2@host2:8080,service2@host3:8080</servers>
          </staticServiceDiscovery>
        </serviceCall>
        <to uri="mock:result"/>
      </route>
    </camelContext>

## Consul Service Discovery

To leverage Consul for Service Discovery, maven users will need to add
the following dependency to their pom.xml

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-consul</artifactId>
        <!-- use the same version as your Camel core version -->
        <version>x.y.z</version>
    </dependency>

Available options:

<table>
<colgroup>
<col style="width: 30%" />
<col style="width: 10%" />
<col style="width: 59%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Java Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>url</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The Consul agent URL</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>datacenter</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The data center</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>aclToken</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Sets the ACL token to be used with
Consul</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>userName</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Sets the username to be used for basic
authentication</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>password</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Sets the password to be used for basic
authentication</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>connectTimeoutMillis</p></td>
<td style="text-align: left;"><p><code>Long</code></p></td>
<td style="text-align: left;"><p>Connect timeout for
OkHttpClient</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>readTimeoutMillis</p></td>
<td style="text-align: left;"><p><code>Long</code></p></td>
<td style="text-align: left;"><p>Read timeout for OkHttpClient</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>writeTimeoutMillis</p></td>
<td style="text-align: left;"><p><code>Long</code></p></td>
<td style="text-align: left;"><p>Write timeout for OkHttpClient</p></td>
</tr>
</tbody>
</table>

And example in Java

    from("direct:start")
        .serviceCall("foo")
            .consulServiceDiscovery()
                .url("http://consul-cluster:8500")
                .datacenter("neverland")
                .end()
        .to("mock:result");

## DNS Service Discovery

To leverage DNS for Service Discovery, maven users will need to add the
following dependency to their pom.xml

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-dns</artifactId>
        <!-- use the same version as your Camel core version -->
        <version>x.y.z</version>
    </dependency>

Available options:

<table>
<colgroup>
<col style="width: 30%" />
<col style="width: 10%" />
<col style="width: 59%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Java Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>proto</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The transport protocol of the desired
service, default "_tcp"</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>domain</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The user name to use for basic
authentication</p></td>
</tr>
</tbody>
</table>

Example in Java:

    from("direct:start")
        .serviceCall("foo")
            .dnsServiceDiscovery("my.domain.com")
        .to("mock:result");

And in XML:

    <camelContext xmlns="http://camel.apache.org/schema/spring">
      <route>
        <from uri="direct:start"/>
        <serviceCall name="foo">
          <dnsServiceDiscovery domain="my.domain.com"/>
        </serviceCall>
        <to uri="mock:result"/>
      </route>
    </camelContext>

## Kubernetes Service Discovery

To leverage Kubernetes for Service Discovery, maven users will need to
add the following dependency to their pom.xml

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-kubernetes</artifactId>
        <!-- use the same version as your Camel core version -->
        <version>x.y.z</version>
    </dependency>

Available options:

<table>
<colgroup>
<col style="width: 30%" />
<col style="width: 10%" />
<col style="width: 59%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Java Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>lookup</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>How to perform service lookup. Possible
values: client, dns, environment</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>apiVersion</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Kubernetes API version when using
client lookup</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>caCertData</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Sets the Certificate Authority data
when using client lookup</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>caCertFile</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Sets the Certificate Authority data
that are loaded from the file when using client lookup</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>clientCertData</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Sets the Client Certificate data when
using client lookup</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>clientCertFile</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Sets the Client Certificate data that
are loaded from the file when using client lookup</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>clientKeyAlgo</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Sets the Client Keystore algorithm,
such as RSA when using client lookup</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>clientKeyData</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Sets the Client Keystore data when
using client lookup</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>clientKeyFile</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Sets the Client Keystore data that are
loaded from the file when using client lookup</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>clientKeyPassphrase</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Sets the Client Keystore passphrase
when using client lookup</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>dnsDomain</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Sets the DNS domain to use for dns
lookup</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>namespace</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The Kubernetes namespace to use. By
default, the namespace’s name is taken from the environment variable
KUBERNETES_MASTER</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>oauthToken</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Sets the OAUTH token for authentication
(instead of username/password) when using client lookup</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>username</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Sets the username for authentication
when using client lookup</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>password</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Sets the password for authentication
when using client lookup</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>trustCerts</p></td>
<td style="text-align: left;"><p><code>Boolean</code></p></td>
<td style="text-align: left;"><p>Sets whether to turn on trust
certificate check when using client lookup</p></td>
</tr>
</tbody>
</table>

Example in Java:

    from("direct:start")
        .serviceCall("foo")
            .kubernetesServiceDiscovery()
                .lookup("dns")
                .namespace("myNamespace")
                .dnsDomain("my.domain.com")
                .end()
        .to("mock:result");

And in XML:

    <camelContext xmlns="http://camel.apache.org/schema/spring">
      <route>
        <from uri="direct:start"/>
        <serviceCall name="foo">
          <kubernetesServiceDiscovery lookup="dns" namespace="myNamespace" dnsDomain="my.domain.com"/>
        </serviceCall>
        <to uri="mock:result"/>
      </route>
    </camelContext>

## Using service filtering

The Service Call EIP supports filtering the services using built-in
filters, or a custom filter.

### Blacklist Service Filter

This service filter implementation removes the listed services from
those found by the service discovery. Each service should be provided in
the following form:

    [service@]host:port

The services are removed if they fully match

Available options:

<table>
<colgroup>
<col style="width: 30%" />
<col style="width: 10%" />
<col style="width: 59%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Java Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>servers</p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>A comma separated list of servers to
blacklist:
[service@]host:port,[service@]host2:port,[service@]host3:port</p></td>
</tr>
</tbody>
</table>

Example in Java:

    from("direct:start")
        .serviceCall("foo")
            .staticServiceDiscovery()
                .servers("service1@host1:80,service1@host2:80")
                .servers("service2@host1:8080,service2@host2:8080,service2@host3:8080")
                .end()
            .blacklistFilter()
                .servers("service2@host2:8080")
                .end()
        .to("mock:result");

And in XML:

    <camelContext xmlns="http://camel.apache.org/schema/spring">
      <route>
        <from uri="direct:start"/>
        <serviceCall name="foo">
          <staticServiceDiscovery>
            <servers>service1@host1:80,service1@host2:80</servers>
            <servers>service2@host1:8080,service2@host2:8080,service2@host3:8080</servers>
          </staticServiceDiscovery>
          <blacklistServiceFilter>
            <servers>service2@host2:8080</servers>
          </blacklistServiceFilter>
        </serviceCall>
        <to uri="mock:result"/>
      </route>
    </camelContext>

### Custom Service Filter

Service Filters choose suitable candidates from the service definitions
found in the service discovery.

The service filter has access to the current exchange, which allows you
to create service filters comparing service metadata with message
content.

Assuming you have labeled one of the services in your service discovery
to support a certain type of requests:

    serviceDiscovery.addServer(new DefaultServiceDefinition("service", "127.0.0.1", 1003,
        Collections.singletonMap("supports", "foo")));

The current exchange has a property which says that it needs a foo
service:

    exchange.setProperty("needs", "foo");

You can then use a `ServiceFilter` to select the service instances which
match the exchange:

    from("direct:start")
        .serviceCall()
            .name("service")
            .serviceFilter((exchange, services) -> services.stream()
                            .filter(serviceDefinition -> Optional.ofNullable(serviceDefinition.getMetadata()
                                    .get("supports"))
                                    .orElse("")
                                    .equals(exchange.getProperty("needs", String.class)))
                            .collect(Collectors.toList()));
            .end()
        .to("mock:result");

## Shared configurations

The Service Call EIP can be configured straight on the route definition
or through shared configurations, here an example with two
configurations registered in the `CamelContext`:

    ServiceCallConfigurationDefinition globalConf = new ServiceCallConfigurationDefinition();
    globalConf.setServiceDiscovery(
        name -> Arrays.asList(
            new DefaultServiceDefinition(name, "my.host1.com", 8080),
            new DefaultServiceDefinition(name, "my.host2.com", 443))
    );
    globalConf.setServiceChooser(
        list -> list.get(ThreadLocalRandom.current().nextInt(list.size()))
    );
    
    ServiceCallConfigurationDefinition httpsConf = new ServiceCallConfigurationDefinition();
    httpsConf.setServiceFilter(
        list -> list.stream().filter((exchange, s) -> s.getPort() == 443).collect(toList())
    );
    
    getContext().setServiceCallConfiguration(globalConf);
    getContext().addServiceCallConfiguration("https", httpsConf);

Each Service Call definition and configuration will inherit from the
`globalConf` which can be seen as default configuration, then you can
reference the `httpsConf` in your route:

    from("direct:start")
        .serviceCall()
            .name("foo")
            .serviceCallConfiguration("https")
        .end()
        .to("mock:result");

This route will leverage the service discovery and service chooser from
`globalConf` and the service filter from \`httpsConf, but you can
override any of them if needed straight on the route:

    from("direct:start")
        .serviceCall()
            .name("foo")
            .serviceCallConfiguration("https")
            .serviceChooser(list -> list.get(0))
        .end()
        .to("mock:result");
