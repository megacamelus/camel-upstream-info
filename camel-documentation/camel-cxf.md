# Cxf

**Since Camel 1.0**

**Both producer and consumer are supported**

The CXF component provides integration with [Apache
CXF](http://cxf.apache.org) for connecting to
[JAX-WS](http://cxf.apache.org/docs/jax-ws.html) services hosted in CXF.

When using CXF in streaming mode - check the DataFormat options below,
then also read about [stream caching](#manual::stream-caching.adoc).

Maven users must add the following dependency to their `pom.xml` for
this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-cxf-soap</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

There are two URI formats for this endpoint: **cxfEndpoint** and
**someAddress**.

    cxf:bean:cxfEndpoint[?options]

Where **cxfEndpoint** represents a bean ID that references a bean in the
Spring bean registry. With this URI format, most of the endpoint details
are specified in the bean definition.

    cxf://someAddress[?options]

Where `someAddress` specifies the CXF endpoint’s address. With this URI
format, most of the endpoint details are specified using options.

For either style above, you can append options to the URI as follows:

    cxf:bean:cxfEndpoint?wsdlURL=wsdl/hello_world.wsdl&dataFormat=PAYLOAD

The `serviceName` and `portName` are
[QNames](http://en.wikipedia.org/wiki/QName), so if you provide them be
sure to prefix them with their *{namespace}* as shown in the examples
above.

## Descriptions of the data formats

In Apache Camel, the Camel CXF component is the key to integrating
routes with Web services. You can use the Camel CXF component to create
a CXF endpoint, which can be used in either of the following ways:

-   **Consumer** — (at the start of a route) represents a Web service
    instance, which integrates with the route. The type of payload
    injected into the route depends on the value of the endpoint’s
    dataFormat option.

-   **Producer** — (at other points in the route) represents a WS client
    proxy, which converts the current exchange object into an operation
    invocation on a remote Web service. The format of the current
    exchange must match the endpoint’s dataFormat setting.

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">DataFormat</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>POJO</code></p></td>
<td style="text-align: left;"><p>POJOs (Plain old Java objects) are the
Java parameters to the method being invoked on the target server. Both
Protocol and Logical JAX-WS handlers are supported.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>PAYLOAD</code></p></td>
<td style="text-align: left;"><p><code>PAYLOAD</code> is the message
payload (the contents of the <code>soap:body</code>) after message
configuration in the CXF endpoint is applied. Only Protocol JAX-WS
handler is supported. Logical JAX-WS handler is not supported.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>RAW</code></p></td>
<td style="text-align: left;"><p><code>RAW</code> mode provides the raw
message stream received from the transport layer. It is not possible to
touch or change the stream, some of the CXF interceptors will be removed
if you are using this kind of DataFormat, so you can’t see any soap
headers after the Camel CXF consumer. JAX-WS handler is not supported.
Note that <code>RAW</code> mode is equivalent to deprecated
<code>MESSAGE</code> mode.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>CXF_MESSAGE</code></p></td>
<td style="text-align: left;"><p><code>CXF_MESSAGE</code> allows for
invoking the full capabilities of CXF interceptors by converting the
message from the transport layer into a raw SOAP message</p></td>
</tr>
</tbody>
</table>

You can determine the data format mode of an exchange by retrieving the
exchange property, `CamelCXFDataFormat`. The exchange key constant is
defined in
`org.apache.camel.component.cxf.common.message.CxfConstants.DATA_FORMAT_PROPERTY`.

# Usage

## RAW Mode

Attachments are not supported as it does not process the message at all.

## CXF\_MESSAGE Mode

MTOM is supported, and Attachments can be retrieved by Camel Message
APIs mentioned above. Note that when receiving a multipart (i.e., MTOM)
message, the default ``SOAPMessag`e to `String`` converter will
provide the complete multipart payload on the body. If you require just
the SOAP XML as a String, you can set the message body with
`message.getSOAPPart()`, and the Camel converter can do the rest of the
work for you.

## Streaming Support in PAYLOAD mode

The Camel CXF component now supports streaming of incoming messages when
using PAYLOAD mode. Previously, the incoming messages would have been
completely DOM parsed. For large messages, this is time-consuming and
uses a significant amount of memory. The incoming messages can remain as
a `javax.xml.transform.Source` while being routed and, if nothing
modifies the payload, can then be directly streamed out to the target
destination. For common "simple proxy" use cases (example:
`from("cxf:...").to("cxf:...")`), this can provide very significant
performance increases as well as significantly lowered memory
requirements.

However, there are cases where streaming may not be appropriate or
desired. Due to the streaming nature, invalid incoming XML may not be
caught until later in the processing chain. Also, certain actions may
require the message to be DOM parsed anyway (like WS-Security or message
tracing and such) in which case, the advantages of the streaming are
limited. At this point, there are two ways to control the streaming:

-   Endpoint property: you can add `allowStreaming=false` as an endpoint
    property to turn the streaming on/off.

-   Component property: the `CxfComponent` object also has an
    `allowStreaming` property that can set the default for endpoints
    created from that component.

Global system property: you can add a system property of
`org.apache.camel.component.cxf.streaming` to `false` to turn it off.
That sets the global default, but setting the endpoint property above
will override this value for that endpoint.

## Using the generic CXF Dispatch mode

The Camel CXF component supports the generic [CXF dispatch
mode](https://cxf.apache.org/docs/jax-ws-dispatch-api.html) that can
transport messages of arbitrary structures (i.e., not bound to a
specific XML schema). To use this mode, you omit specifying the
`wsdlURL` and `serviceClass` attributes of the CXF endpoint.

Java (Quarkus)  
import org.apache.camel.component.cxf.common.DataFormat;
import org.apache.camel.component.cxf.jaxws.CxfEndpoint;
import jakarta.enterprise.context.SessionScoped;
import jakarta.enterprise.inject.Produces;
import jakarta.inject.Named;

    ...
    
    @Produces
    @SessionScoped
    @Named
    CxfEndpoint dispatchEndpoint() {
        final CxfEndpoint result = new CxfEndpoint();
        result.setDataFormat(DataFormat.PAYLOAD);
        result.setAddress("/SoapAnyPort");
        return result;
    }

XML (Spring)  
\<cxf:cxfEndpoint id="dispatchEndpoint" address="http://localhost:9000/SoapContext/SoapAnyPort"\>
[cxf:properties](cxf:properties)
<entry key="dataFormat" value="PAYLOAD"/>
\</cxf:properties\>
\</cxf:cxfEndpoint\>

It is noted that the default CXF dispatch client does not send a
specific `SOAPAction` header. Therefore, when the target service
requires a specific `SOAPAction` value, it is supplied in the Camel
header using the key `SOAPAction` (case-insensitive).

CXF’s `LoggingOutInterceptor` outputs outbound message that goes on the
wire to logging system (Java Util Logging). Since the
`LoggingOutInterceptor` is in `PRE_STREAM` phase (but `PRE_STREAM` phase
is removed in `RAW` mode), you have to configure `LoggingOutInterceptor`
to be run during the `WRITE` phase. The following is an example.

Java (Quarkus)  
import java.util.List;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.component.cxf.common.DataFormat;
import org.apache.camel.component.cxf.jaxws.CxfEndpoint;
import org.apache.cxf.interceptor.LoggingOutInterceptor;
import org.apache.cxf.phase.Phase;
import jakarta.enterprise.context.SessionScoped;
import jakarta.enterprise.inject.Produces;
import jakarta.inject.Named;

    ...
    
    @Produces
    @SessionScoped
    @Named
    CxfEndpoint soapMtomEnabledServerPayloadModeEndpoint() {
        final CxfEndpoint result = new CxfEndpoint();
        result.setServiceClass(HelloService.class);
        result.setDataFormat(DataFormat.RAW);
        result.setOutFaultInterceptors(List.of(new LoggingOutInterceptor(Phase.WRITE)));;
        result.setAddress("/helloworld");
        return result;
    }

XML (Spring)  
<bean id="loggingOutInterceptor" class="org.apache.cxf.interceptor.LoggingOutInterceptor">  
<!--  it really should have been user-prestream, but CXF does have such a phase! -->  
<constructor-arg value="write"/>  
</bean>

    <cxf:cxfEndpoint id="serviceEndpoint" address="http://localhost:${CXFTestSupport.port2}/LoggingInterceptorInMessageModeTest/helloworld"
        serviceClass="org.apache.camel.component.cxf.HelloService">
        <cxf:outInterceptors>
            <ref bean="loggingOutInterceptor"/>
        </cxf:outInterceptors>
        <cxf:properties>
            <entry key="dataFormat" value="RAW"/>
        </cxf:properties>
    </cxf:cxfEndpoint>

## Description of CxfHeaderFilterStrategy options

There are *in-band* and *out-of-band* on-the-wire headers from the
perspective of a JAXWS WSDL-first developer.

The *in-band* headers are headers that are explicitly defined as part of
the WSDL binding contract for an endpoint such as SOAP headers.

The *out-of-band* headers are headers that are serialized over the wire,
but are not explicitly part of the WSDL binding contract.

Headers relaying/filtering is bi-directional.

When a route has a CXF endpoint and the developer needs to have
on-the-wire headers, such as SOAP headers, be relayed along the route to
be consumed say by another JAXWS endpoint, a `CxfHeaderFilterStrategy`
instance should be set on the CXF endpoint, then `relayHeaders` property
of the `CxfHeaderFilterStrategy` instance should be set to `true`, which
is the default value. Plus, the `CxfHeaderFilterStrategy` instance also
holds a list of `MessageHeaderFilter` interface, which decides if a
specific header will be relayed or not.

Take a look at the tests that show how you’d be able to relay/drop
headers here:

[CxfMessageHeadersRelayTest](https://github.com/apache/camel/blob/main/components/camel-cxf/camel-cxf-spring-soap/src/test/java/org/apache/camel/component/cxf/soap/headers/CxfMessageHeadersRelayTest.java)

-   The `relayHeaders=true` expresses an intent to relay the headers.
    The actual decision on whether a given header is relayed is
    delegated to a pluggable instance that implements the
    `MessageHeaderFilter` interface. A concrete implementation of
    `MessageHeaderFilter` will be consulted to decide if a header needs
    to be relayed or not. There is already an implementation of
    `SoapMessageHeaderFilter` which binds itself to well-known SOAP name
    spaces. If there is a header on the wire whose name space is unknown
    to the runtime, the header will be simply relayed.

-   `POJO` and `PAYLOAD` modes are supported. In `POJO` mode, only
    out-of-band message headers are available for filtering as the
    in-band headers have been processed and removed from the header list
    by CXF. The in-band headers are incorporated into the
    `MessageContentList` in POJO mode. The Camel CXF component does make
    any attempt to remove the in-band headers from the
    `MessageContentList`. If filtering of in-band headers is required,
    please use `PAYLOAD` mode or plug in a (pretty straightforward) CXF
    interceptor/JAXWS Handler to the CXF endpoint. Here is an example of
    configuring the `CxfHeaderFilterStrategy`.

<!-- -->

    <bean id="dropAllMessageHeadersStrategy" class="org.apache.camel.component.cxf.transport.header.CxfHeaderFilterStrategy">
    
        <!--  Set relayHeaders to false to drop all SOAP headers -->
        <property name="relayHeaders" value="false"/>
    
    </bean>

Then, your endpoint can reference the `CxfHeaderFilterStrategy`:

    <route>
        <from uri="cxf:bean:routerNoRelayEndpoint?headerFilterStrategy=#dropAllMessageHeadersStrategy"/>
        <to uri="cxf:bean:serviceNoRelayEndpoint?headerFilterStrategy=#dropAllMessageHeadersStrategy"/>
    </route>

-   You can plug in your own `MessageHeaderFilter` implementations
    overriding or adding additional ones to the list of relays. To
    override a preloaded relay instance, make sure that your
    `MessageHeaderFilter` implementation services the same name spaces
    as the one you are looking to override.

Here is an example of configuring user defined Message Header Filters:

    <bean id="customMessageFilterStrategy" class="org.apache.camel.component.cxf.transport.header.CxfHeaderFilterStrategy">
        <property name="messageHeaderFilters">
            <list>
                <!--  SoapMessageHeaderFilter is the built-in filter.  It can be removed by omitting it. -->
                <bean class="org.apache.camel.component.cxf.common.header.SoapMessageHeaderFilter"/>
    
                <!--  Add custom filter here -->
                <bean class="org.apache.camel.component.cxf.soap.headers.CustomHeaderFilter"/>
            </list>
        </property>
    </bean>

-   In addition to `relayHeaders`, the following properties can be
    configured in `CxfHeaderFilterStrategy`.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Required</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>relayHeaders</code></p></td>
<td style="text-align: left;"><p>No</p></td>
<td style="text-align: left;"><p>All message headers will be processed
by Message Header Filters <em>Type</em>: <code>boolean</code>
<em>Default</em>: <code>true</code></p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>relayAllMessageHeaders</code></p></td>
<td style="text-align: left;"><p>No</p></td>
<td style="text-align: left;"><p>All message headers will be propagated
(without processing by Message Header Filters) <em>Type</em>:
<code>boolean</code> <em>Default</em>: <code>false</code></p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>allowFilterNamespaceClash</code></p></td>
<td style="text-align: left;"><p>No</p></td>
<td style="text-align: left;"><p>If two filters overlap in activation
namespace, the property controls how it should be handled. If the value
is <code>true</code>, last one wins. If the value is <code>false</code>,
it will throw an exception <em>Type</em>: <code>boolean</code>
<em>Default</em>: <code>false</code></p></td>
</tr>
</tbody>
</table>

## How to make the Camel CXF component use log4j instead of java.util.logging

CXF’s default logger is `java.util.logging`. If you want to change it to
log4j, proceed as follows. Create a file, in the classpath, named
`META-INF/cxf/org.apache.cxf.logger`. This file should contain the fully
qualified name of the class,
`org.apache.cxf.common.logging.Log4jLogger`, with no comments, on a
single line.

## How to let Camel CXF response start with xml processing instruction

If you are using some SOAP client such as PHP, you will get this kind of
error because CXF doesn’t add the XML processing instruction
`<?xml version="1.0" encoding="utf-8"?>`:

    Error:sendSms: SoapFault exception: [Client] looks like we got no XML document in [...]

To resolve this issue, you need to tell `StaxOutInterceptor` to write
the XML start document for you, as in the
[WriteXmlDeclarationInterceptor](https://github.com/apache/camel/blob/main/components/camel-cxf/camel-cxf-soap/src/test/java/org/apache/camel/component/cxf/jaxws/WriteXmlDeclarationInterceptor.java)
below:

    public class WriteXmlDeclarationInterceptor extends AbstractPhaseInterceptor<SoapMessage> {
        public WriteXmlDeclarationInterceptor() {
            super(Phase.PRE_STREAM);
            addBefore(StaxOutInterceptor.class.getName());
        }
    
        public void handleMessage(SoapMessage message) throws Fault {
            message.put("org.apache.cxf.stax.force-start-document", Boolean.TRUE);
        }
    
    }

As an alternative, you can add a message header for it as demonstrated
in
[CxfConsumerTest](https://github.com/apache/camel/blob/main/components/camel-cxf/camel-cxf-soap/src/test/java/org/apache/camel/component/cxf/jaxws/CxfConsumerTest.java#L62):

     // set up the response context which force start document
     Map<String, Object> map = new HashMap<String, Object>();
     map.put("org.apache.cxf.stax.force-start-document", Boolean.TRUE);
     exchange.getMessage().setHeader(Client.RESPONSE_CONTEXT, map);

## Configure the CXF endpoints with Spring

You can configure the CXF endpoint with the Spring configuration file
shown below, and you can also embed the endpoint into the `camelContext`
tags. When you are invoking the service endpoint, you can set the
`operationName` and `operationNamespace` headers to explicitly state
which operation you are calling.

    <beans xmlns="http://www.springframework.org/schema/beans"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:cxf="http://camel.apache.org/schema/cxf"
            xsi:schemaLocation="
            http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
            http://camel.apache.org/schema/cxf http://camel.apache.org/schema/cxf/camel-cxf.xsd
            http://camel.apache.org/schema/spring http://camel.apache.org/schema/spring/camel-spring.xsd">
         <cxf:cxfEndpoint id="routerEndpoint" address="http://localhost:9003/CamelContext/RouterPort"
                serviceClass="org.apache.hello_world_soap_http.GreeterImpl"/>
         <cxf:cxfEndpoint id="serviceEndpoint" address="http://localhost:9000/SoapContext/SoapPort"
                wsdlURL="testutils/hello_world.wsdl"
                serviceClass="org.apache.hello_world_soap_http.Greeter"
                endpointName="s:SoapPort"
                serviceName="s:SOAPService"
            xmlns:s="http://apache.org/hello_world_soap_http" />
         <camelContext id="camel" xmlns="http://camel.apache.org/schema/spring">
           <route>
             <from uri="cxf:bean:routerEndpoint" />
             <to uri="cxf:bean:serviceEndpoint" />
           </route>
        </camelContext>
      </beans>

Be sure to include the JAX-WS `schemaLocation` attribute specified on
the root `beans` element. This allows CXF to validate the file and is
required. Also note the namespace declarations at the end of the
`<cxf:cxfEndpoint/>` tag. These declarations are required because the
combined `{namespace}localName` syntax is presently not supported for
this tag’s attribute values.

The `cxf:cxfEndpoint` element supports many additional attributes:

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Value</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>PortName</code></p></td>
<td style="text-align: left;"><p>The endpoint name this service is
implementing, it maps to the <code>wsdl:port@name</code>. In the format
of <code>ns:PORT_NAME</code> where <code>ns</code> is a namespace prefix
valid at this scope.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>serviceName</code></p></td>
<td style="text-align: left;"><p>The service name this service is
implementing, it maps to the <code>wsdl:service@name</code>. In the
format of <code>ns:SERVICE_NAME</code> where <code>ns</code> is a
namespace prefix valid at this scope.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>wsdlURL</code></p></td>
<td style="text-align: left;"><p>The location of the WSDL. Can be on the
classpath, file system, or be hosted remotely.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>bindingId</code></p></td>
<td style="text-align: left;"><p>The <code>bindingId</code> for the
service model to use.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>address</code></p></td>
<td style="text-align: left;"><p>The service publish address.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>bus</code></p></td>
<td style="text-align: left;"><p>The bus name that will be used in the
JAX-WS endpoint.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>serviceClass</code></p></td>
<td style="text-align: left;"><p>The class name of the SEI (Service
Endpoint Interface) class which could have JSR181 annotation or
not.</p></td>
</tr>
</tbody>
</table>

It also supports many child elements:

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Value</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>cxf:inInterceptors</code></p></td>
<td style="text-align: left;"><p>The incoming interceptors for this
endpoint. A list of <code>&lt;bean&gt;</code> or
<code>&lt;ref&gt;</code>.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>cxf:inFaultInterceptors</code></p></td>
<td style="text-align: left;"><p>The incoming fault interceptors for
this endpoint. A list of <code>&lt;bean&gt;</code> or
<code>&lt;ref&gt;</code>.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>cxf:outInterceptors</code></p></td>
<td style="text-align: left;"><p>The outgoing interceptors for this
endpoint. A list of <code>&lt;bean&gt;</code> or
<code>&lt;ref&gt;</code>.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>cxf:outFaultInterceptors</code></p></td>
<td style="text-align: left;"><p>The outgoing fault interceptors for
this endpoint. A list of <code>&lt;bean&gt;</code> or
<code>&lt;ref&gt;</code>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>cxf:properties</code></p></td>
<td style="text-align: left;"><p>A properties map which should be
supplied to the JAX-WS endpoint. See below.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>cxf:handlers</code></p></td>
<td style="text-align: left;"><p>A JAX-WS handler list which should be
supplied to the JAX-WS endpoint. See below.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>cxf:dataBinding</code></p></td>
<td style="text-align: left;"><p>You can specify which
<code>DataBinding</code> will be used in the endpoint. This can be
supplied using the Spring
<code>&lt;bean class="MyDataBinding"/&gt;</code> syntax.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>cxf:binding</code></p></td>
<td style="text-align: left;"><p>You can specify the
<code>BindingFactory</code> for this endpoint to use. This can be
supplied using the Spring
<code>&lt;bean class="MyBindingFactory"/&gt;</code> syntax.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>cxf:features</code></p></td>
<td style="text-align: left;"><p>The features that hold the interceptors
for this endpoint. A list of beans or refs</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>cxf:schemaLocations</code></p></td>
<td style="text-align: left;"><p>The schema locations for endpoint to
use. A list of schemaLocations</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>cxf:serviceFactory</code></p></td>
<td style="text-align: left;"><p>The service factory for this endpoint
to use. This can be supplied using the Spring
<code>&lt;bean class="MyServiceFactory"/&gt;</code> syntax</p></td>
</tr>
</tbody>
</table>

You can find more advanced examples that show how to provide
interceptors, properties and handlers on the CXF [JAX-WS Configuration
page](http://cxf.apache.org/docs/jax-ws-configuration.html).

You can use `cxf:properties` to set the Camel CXF endpoint’s dataFormat
and setDefaultBus properties from spring configuration file.

    <cxf:cxfEndpoint id="testEndpoint" address="http://localhost:9000/router"
         serviceClass="org.apache.camel.component.cxf.HelloService"
         endpointName="s:HelloPort"
         serviceName="s:HelloService"
         xmlns:s="http://www.example.com/test">
         <cxf:properties>
           <entry key="dataFormat" value="RAW"/>
           <entry key="setDefaultBus" value="true"/>
         </cxf:properties>
       </cxf:cxfEndpoint>

# Examples

## How to create a simple CXF service with POJO data format

Having simple java web service interface:

    package org.apache.camel.component.cxf.soap.server;
    
    @WebService(targetNamespace = "http://server.soap.cxf.component.camel.apache.org/", name = "EchoService")
    public interface EchoService {
    
        String echo(String text);
    }

And implementation:

    package org.apache.camel.component.cxf.soap.server;
    
    @WebService(name = "EchoService", serviceName = "EchoService", targetNamespace = "http://server.soap.cxf.component.camel.apache.org/")
    public class EchoServiceImpl implements EchoService {
    
        @Override
        public String echo(String text) {
            return text;
        }
    
    }

We can then create the simplest CXF service (note we didn’t specify the
`POJO` mode, as it is the default mode):

        from("cxf:echoServiceResponseFromImpl?serviceClass=org.apache.camel.component.cxf.soap.server.EchoServiceImpl&address=/echo-impl")// no body set here; the response comes from EchoServiceImpl
                    .log("${body}");

For more complicated implementation of the service (more "Camel way"),
we can set the body from the route instead:

        from("cxf:echoServiceResponseFromRoute?serviceClass=org.apache.camel.component.cxf.soap.server.EchoServiceImpl&address=/echo-route")
                    .setBody(exchange -> exchange.getMessage().getBody(String.class) + " from Camel route");

## How to consume a message from a Camel CXF endpoint in POJO data format

The Camel CXF endpoint consumer POJO data format is based on the [CXF
invoker](http://cxf.apache.org/docs/invokers.html), so the message
header has a property with the name of `CxfConstants.OPERATION_NAME` and
the message body is a list of the SEI method parameters.

Consider the
[PersonProcessor](https://github.com/apache/camel/blob/main/components/camel-cxf/camel-cxf-soap/src/test/java/org/apache/camel/wsdl_first/PersonProcessor.java)
example code:

    public class PersonProcessor implements Processor {
    
        private static final Logger LOG = LoggerFactory.getLogger(PersonProcessor.class);
    
        @Override
        @SuppressWarnings("unchecked")
        public void process(Exchange exchange) throws Exception {
            LOG.info("processing exchange in camel");
    
            BindingOperationInfo boi = (BindingOperationInfo) exchange.getProperty(BindingOperationInfo.class.getName());
            if (boi != null) {
                LOG.info("boi.isUnwrapped" + boi.isUnwrapped());
            }
            // Get the parameter list which element is the holder.
            MessageContentsList msgList = (MessageContentsList) exchange.getIn().getBody();
            Holder<String> personId = (Holder<String>) msgList.get(0);
            Holder<String> ssn = (Holder<String>) msgList.get(1);
            Holder<String> name = (Holder<String>) msgList.get(2);
    
            if (personId.value == null || personId.value.length() == 0) {
                LOG.info("person id 123, so throwing exception");
                // Try to throw out the soap fault message
                org.apache.camel.wsdl_first.types.UnknownPersonFault personFault
                        = new org.apache.camel.wsdl_first.types.UnknownPersonFault();
                personFault.setPersonId("");
                org.apache.camel.wsdl_first.UnknownPersonFault fault
                        = new org.apache.camel.wsdl_first.UnknownPersonFault("Get the null value of person name", personFault);
                exchange.getMessage().setBody(fault);
                return;
            }
    
            name.value = "Bonjour";
            ssn.value = "123";
            LOG.info("setting Bonjour as the response");
            // Set the response message, the first element is the return value of the operation,
            // the others are the holders of method parameters
            exchange.getMessage().setBody(new Object[] { null, personId, ssn, name });
        }
    
    }

## How to prepare the message for the Camel CXF endpoint in POJO data format

The Camel CXF endpoint producer is based on the [CXF client
API](https://github.com/apache/cxf/blob/master/core/src/main/java/org/apache/cxf/endpoint/Client.java).
First, you need to specify the operation name in the message header,
then add the method parameters to a list, and initialize the message
with this parameter list. The response message’s body is a
messageContentsList, you can get the result from that list.

If you don’t specify the operation name in the message header,
`CxfProducer` will try to use the `defaultOperationName` from
`CxfEndpoint`, if there is no `defaultOperationName` set on
`CxfEndpoint`, it will pick up the first operationName from the
Operation list.

If you want to get the object array from the message body, you can get
the body using `message.getBody(Object[].class)`, as shown in
[CxfProducerRouterTest.testInvokingSimpleServerWithParams](https://github.com/apache/camel/blob/main/components/camel-cxf/camel-cxf-soap/src/test/java/org/apache/camel/component/cxf/jaxws/CxfProducerRouterTest.java#L117):

    Exchange senderExchange = new DefaultExchange(context, ExchangePattern.InOut);
    final List<String> params = new ArrayList<>();
    // Prepare the request message for the camel-cxf procedure
    params.add(TEST_MESSAGE);
    senderExchange.getIn().setBody(params);
    senderExchange.getIn().setHeader(CxfConstants.OPERATION_NAME, ECHO_OPERATION);
    
    Exchange exchange = template.send("direct:EndpointA", senderExchange);
    
    org.apache.camel.Message out = exchange.getMessage();
    // The response message's body is a MessageContentsList which first element is the return value of the operation,
    // If there are some holder parameters, the holder parameter will be filled in the reset of List.
    // The result will be extracted from the MessageContentsList with the String class type
    MessageContentsList result = (MessageContentsList) out.getBody();
    LOG.info("Received output text: " + result.get(0));
    Map<String, Object> responseContext = CastUtils.cast((Map<?, ?>) out.getHeader(Client.RESPONSE_CONTEXT));
    assertNotNull(responseContext);
    assertEquals("UTF-8", responseContext.get(org.apache.cxf.message.Message.ENCODING),
            "We should get the response context here");
    assertEquals("echo " + TEST_MESSAGE, result.get(0), "Reply body on Camel is wrong");

## How to consume a message from a Camel CXF endpoint in PAYLOAD data format

`PAYLOAD` means that you process the payload from the SOAP envelope as a
native CxfPayload. `Message.getBody()` will return a
`org.apache.camel.component.cxf.CxfPayload` object, with getters for
SOAP message headers and the SOAP body.

See
[CxfConsumerPayloadTest](https://github.com/apache/camel/blob/main/components/camel-cxf/camel-cxf-soap/src/test/java/org/apache/camel/component/cxf/jaxws/CxfConsumerPayloadTest.java#L68):

    protected RouteBuilder createRouteBuilder() {
        return new RouteBuilder() {
            public void configure() {
                from(simpleEndpointURI + "&dataFormat=PAYLOAD").to("log:info").process(new Processor() {
                    @SuppressWarnings("unchecked")
                    public void process(final Exchange exchange) throws Exception {
                        CxfPayload<SoapHeader> requestPayload = exchange.getIn().getBody(CxfPayload.class);
                        List<Source> inElements = requestPayload.getBodySources();
                        List<Source> outElements = new ArrayList<>();
                        // You can use a customer toStringConverter to turn a CxfPayLoad message into String as you want
                        String request = exchange.getIn().getBody(String.class);
                        XmlConverter converter = new XmlConverter();
                        String documentString = ECHO_RESPONSE;
    
                        Element in = new XmlConverter().toDOMElement(inElements.get(0));
                        // Check the element namespace
                        if (!in.getNamespaceURI().equals(ELEMENT_NAMESPACE)) {
                            throw new IllegalArgumentException("Wrong element namespace");
                        }
                        if (in.getLocalName().equals("echoBoolean")) {
                            documentString = ECHO_BOOLEAN_RESPONSE;
                            checkRequest("ECHO_BOOLEAN_REQUEST", request);
                        } else {
                            documentString = ECHO_RESPONSE;
                            checkRequest("ECHO_REQUEST", request);
                        }
                        Document outDocument = converter.toDOMDocument(documentString, exchange);
                        outElements.add(new DOMSource(outDocument.getDocumentElement()));
                        // set the payload header with null
                        CxfPayload<SoapHeader> responsePayload = new CxfPayload<>(null, outElements, null);
                        exchange.getMessage().setBody(responsePayload);
                    }
                });
            }
        };
    }

## How to get and set SOAP headers in POJO mode

`POJO` means that the data format is a *"list of Java objects"* when the
Camel CXF endpoint produces or consumes Camel exchanges. Even though
Camel exposes the message body as POJOs in this mode, Camel CXF still
provides access to read and write SOAP headers. However, since CXF
interceptors remove in-band SOAP headers from the header list, after
they have been processed, only out-of-band SOAP headers are available to
Camel CXF in POJO mode.

The following example illustrates how to get/set SOAP headers. Suppose
we have a route that forwards from one Camel CXF endpoint to another.
That is, `SOAP Client -> Camel -> CXF service`. We can attach two
processors to obtain/insert SOAP headers at (1) before a request goes
out to the CXF service and (2) before the response comes back to the
SOAP Client. Processors (1) and (2) in this example are
`InsertRequestOutHeaderProcessor` and
`InsertResponseOutHeaderProcessor`. Our route looks like this:

Java  
from("cxf:bean:routerRelayEndpointWithInsertion")
.process(new InsertRequestOutHeaderProcessor())
.to("cxf:bean:serviceRelayEndpointWithInsertion")
.process(new InsertResponseOutHeaderProcessor());

XML  
<route>  
<from uri="cxf:bean:routerRelayEndpointWithInsertion"/>  
<process ref="InsertRequestOutHeaderProcessor" />  
<to uri="cxf:bean:serviceRelayEndpointWithInsertion"/>  
<process ref="InsertResponseOutHeaderProcessor" />  
</route>

SOAP headers are propagated to and from Camel Message headers. The Camel
message header name is `org.apache.cxf.headers.Header.list` which is a
constant defined in CXF (`org.apache.cxf.headers.Header.HEADER_LIST`).
The header value is a List of CXF `SoapHeader` objects
(`org.apache.cxf.binding.soap.SoapHeader`). The following snippet is the
`InsertResponseOutHeaderProcessor` (that inserts a new SOAP header in
the response message). The way to access SOAP headers in both
`InsertResponseOutHeaderProcessor` and `InsertRequestOutHeaderProcessor`
are actually the same. The only difference between the two processors is
setting the direction of the inserted SOAP header.

You can find the `InsertResponseOutHeaderProcessor` example in
[CxfMessageHeadersRelayTest](https://github.com/apache/camel/blob/main/components/camel-cxf/camel-cxf-spring-soap/src/test/java/org/apache/camel/component/cxf/soap/headers/CxfMessageHeadersRelayTest.java#L731):

    public static class InsertResponseOutHeaderProcessor implements Processor {
    
        public void process(Exchange exchange) throws Exception {
            List<SoapHeader> soapHeaders = CastUtils.cast((List<?>)exchange.getIn().getHeader(Header.HEADER_LIST));
    
            // Insert a new header
            String xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><outofbandHeader "
                + "xmlns=\"http://cxf.apache.org/outofband/Header\" hdrAttribute=\"testHdrAttribute\" "
                + "xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" soap:mustUnderstand=\"1\">"
                + "<name>New_testOobHeader</name><value>New_testOobHeaderValue</value></outofbandHeader>";
            SoapHeader newHeader = new SoapHeader(soapHeaders.get(0).getName(),
                           DOMUtils.readXml(new StringReader(xml)).getDocumentElement());
            // make sure the direction is OUT since it is a response message.
            newHeader.setDirection(Direction.DIRECTION_OUT);
            //newHeader.setMustUnderstand(false);
            soapHeaders.add(newHeader);
    
        }
    
    }

## How to get and set SOAP headers in PAYLOAD mode

We’ve already shown how to access the SOAP message as `CxfPayload`
object in PAYLOAD mode in the section
\[???\](#How to consume a message from a Camel CXF endpoint in PAYLOAD data format).

Once you obtain a `CxfPayload` object, you can invoke the
`CxfPayload.getHeaders()` method that returns a List of DOM Elements
(SOAP headers).

For example, see
[CxfPayLoadSoapHeaderTest](https://github.com/apache/camel/blob/main/components/camel-cxf/camel-cxf-soap/src/test/java/org/apache/camel/component/cxf/jaxws/CxfPayLoadSoapHeaderTest.java#L53):

    from(getRouterEndpointURI()).process(new Processor() {
        @SuppressWarnings("unchecked")
        public void process(Exchange exchange) throws Exception {
            CxfPayload<SoapHeader> payload = exchange.getIn().getBody(CxfPayload.class);
            List<Source> elements = payload.getBodySources();
            assertNotNull(elements, "We should get the elements here");
            assertEquals(1, elements.size(), "Get the wrong elements size");
    
            Element el = new XmlConverter().toDOMElement(elements.get(0));
            elements.set(0, new DOMSource(el));
            assertEquals("http://camel.apache.org/pizza/types",
                    el.getNamespaceURI(), "Get the wrong namespace URI");
    
            List<SoapHeader> headers = payload.getHeaders();
            assertNotNull(headers, "We should get the headers here");
            assertEquals(1, headers.size(), "Get the wrong headers size");
            assertEquals("http://camel.apache.org/pizza/types",
                    ((Element) (headers.get(0).getObject())).getNamespaceURI(), "Get the wrong namespace URI");
            // alternatively, you can also get the SOAP header via the camel header:
            headers = exchange.getIn().getHeader(Header.HEADER_LIST, List.class);
            assertNotNull(headers, "We should get the headers here");
            assertEquals(1, headers.size(), "Get the wrong headers size");
            assertEquals("http://camel.apache.org/pizza/types",
                    ((Element) (headers.get(0).getObject())).getNamespaceURI(), "Get the wrong namespace URI");
    
        }
    
    })
    .to(getServiceEndpointURI());

You can also use the same way as described in subchapter "How to get and
set SOAP headers in POJO mode" to set or get the SOAP headers. So, you
can use the header `org.apache.cxf.headers.Header.list` to get and set a
list of SOAP headers.This does also mean that if you have a route that
forwards from one Camel CXF endpoint to another
(`SOAP Client -> Camel -> CXF service`), now also the SOAP headers sent
by the SOAP client are forwarded to the CXF service. If you do not want
that these headers are forwarded, you have to remove them in the Camel
header `org.apache.cxf.headers.Header.list`.

## SOAP headers are not available in RAW mode

SOAP headers are not available in RAW mode as SOAP processing is
skipped.

## How to throw a SOAP Fault from Camel

If you are using a Camel CXF endpoint to consume the SOAP request, you
may need to throw the SOAP Fault from the camel context.  
Basically, you can use the `throwFault` DSL to do that; it works for
`POJO`, `PAYLOAD` and `RAW` data format.  
You can define the soap fault as shown in
[CxfCustomizedExceptionTest](https://github.com/apache/camel/blob/main/components/camel-cxf/camel-cxf-soap/src/test/java/org/apache/camel/component/cxf/jaxws/CxfCustomizedExceptionTest.java#L65):

    SOAP_FAULT = new SoapFault(EXCEPTION_MESSAGE, SoapFault.FAULT_CODE_CLIENT);
    Element detail = SOAP_FAULT.getOrCreateDetail();
    Document doc = detail.getOwnerDocument();
    Text tn = doc.createTextNode(DETAIL_TEXT);
    detail.appendChild(tn);

Then throw it as you like:

    from(routerEndpointURI).setFaultBody(constant(SOAP_FAULT));

If your CXF endpoint is working in the `RAW` data format, you could set
the SOAP Fault message in the message body and set the response code in
the message header as demonstrated by
[CxfMessageStreamExceptionTest](https://github.com/apache/camel/blob/main/components/camel-cxf/camel-cxf-soap/src/test/java/org/apache/camel/component/cxf/jaxws/CxfMessageStreamExceptionTest.java#L43):

    from(routerEndpointURI).process(new Processor() {
    
        public void process(Exchange exchange) throws Exception {
            Message out = exchange.getMessage();
            // Set the message body
            out.setBody(this.getClass().getResourceAsStream("SoapFaultMessage.xml"));
            // Set the response code here
            out.setHeader(org.apache.cxf.message.Message.RESPONSE_CODE, new Integer(500));
        }
    
    });

Same for using POJO data format. You can set the SOAPFault on the *OUT*
body.

[CXF client
API](https://github.com/apache/cxf/blob/master/core/src/main/java/org/apache/cxf/endpoint/Client.java)
provides a way to invoke the operation with request and response
context. If you are using a Camel CXF endpoint producer to invoke the
outside web service, you can set the request context and get response
context with the following code:

    CxfExchange exchange = (CxfExchange)template.send(getJaxwsEndpointUri(), new Processor() {
         public void process(final Exchange exchange) {
             final List<String> params = new ArrayList<String>();
             params.add(TEST_MESSAGE);
             // Set the request context to the inMessage
             Map<String, Object> requestContext = new HashMap<String, Object>();
             requestContext.put(BindingProvider.ENDPOINT_ADDRESS_PROPERTY, JAXWS_SERVER_ADDRESS);
             exchange.getIn().setBody(params);
             exchange.getIn().setHeader(Client.REQUEST_CONTEXT , requestContext);
             exchange.getIn().setHeader(CxfConstants.OPERATION_NAME, GREET_ME_OPERATION);
         }
    });
    org.apache.camel.Message out = exchange.getMessage();
    // The output is an object array, the first element of the array is the return value
    Object\[\] output = out.getBody(Object\[\].class);
    LOG.info("Received output text: " + output\[0\]);
    // Get the response context form outMessage
    Map<String, Object> responseContext = CastUtils.cast((Map)out.getHeader(Client.RESPONSE_CONTEXT));
    assertNotNull(responseContext);
    assertEquals("Get the wrong wsdl operation name", "{http://apache.org/hello_world_soap_http}greetMe",
        responseContext.get("javax.xml.ws.wsdl.operation").toString());

## Attachment Support

## POJO Mode

Message Transmission Optimization Mechanism (MTOM) is supported if
enabled - check the example in Payload Mode for enabling MTOM. Since
attachments are marshalled and unmarshalled into POJOs, the attachments
should be retrieved from the Apache Camel message body (as a parameter
list), and it isn’t possible to retrieve attachments by Camel Message
API

    DataHandler handler = Exchange.getIn(AttachmentMessage.class).getAttachment("id");

## Payload Mode

Message Transmission Optimization Mechanism (MTOM) is supported by this
Mode. Attachments can be retrieved by Camel Message APIs mentioned
above. SOAP with Attachment (SwA) is supported and attachments can be
retrieved. SwA is the default (same as setting the CXF endpoint property
`mtomEnabled` to `false`).

To enable MTOM, set the CXF endpoint property `mtomEnabled` to `true`.

Java (Quarkus)  
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.component.cxf.common.DataFormat;
import org.apache.camel.component.cxf.jaxws.CxfEndpoint;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.context.SessionScoped;
import jakarta.enterprise.inject.Produces;
import jakarta.inject.Named;

    @ApplicationScoped
    public class CxfSoapMtomRoutes extends RouteBuilder {
    
        @Override
        public void configure() {
            from("cxf:bean:mtomPayloadModeEndpoint")
                    .process( exchange -> { ... });
        }
    
        @Produces
        @SessionScoped
        @Named
        CxfEndpoint mtomPayloadModeEndpoint() {
            final CxfEndpoint result = new CxfEndpoint();
            result.setServiceClass(MyMtomService.class);
            result.setDataFormat(DataFormat.PAYLOAD);
            result.setMtomEnabled(true);
            result.setAddress("/mtom/hello");
            return result;
        }
    }

XML (Spring)  
\<cxf:cxfEndpoint id="mtomPayloadModeEndpoint" address="http://localhost:${CXFTestSupport.port1}/CxfMtomRouterPayloadModeTest/mtom"
wsdlURL="mtom.wsdl"
serviceName="ns:MyMtomService"
endpointName="ns:MyMtomPort"
xmlns:ns="http://apache.org/camel/cxf/mtom\_feature"\>

        <cxf:properties>
            <!--  enable mtom by setting this property to true -->
            <entry key="mtom-enabled" value="true"/>
            <!--  set the Camel CXF endpoint data fromat to PAYLOAD mode -->
            <entry key="dataFormat" value="PAYLOAD"/>
        </cxf:properties>
    </cxf:cxfEndpoint>

You can produce a Camel message with attachment to send to a CXF
endpoint in Payload mode.

    Exchange exchange = context.createProducerTemplate().send("direct:testEndpoint", new Processor() {
    
        public void process(Exchange exchange) throws Exception {
            exchange.setPattern(ExchangePattern.InOut);
            List<Source> elements = new ArrayList<Source>();
            elements.add(new DOMSource(DOMUtils.readXml(new StringReader(MtomTestHelper.REQ_MESSAGE)).getDocumentElement()));
            CxfPayload<SoapHeader> body = new CxfPayload<SoapHeader>(new ArrayList<SoapHeader>(),
                elements, null);
            exchange.getIn().setBody(body);
            exchange.getIn(AttachmentMessage.class).addAttachment(MtomTestHelper.REQ_PHOTO_CID,
                new DataHandler(new ByteArrayDataSource(MtomTestHelper.REQ_PHOTO_DATA, "application/octet-stream")));
    
            exchange.getIn(AttachmentMessage.class).addAttachment(MtomTestHelper.REQ_IMAGE_CID,
                new DataHandler(new ByteArrayDataSource(MtomTestHelper.requestJpeg, "image/jpeg")));
    
        }
    
    });
    
    // process response
    
    CxfPayload<SoapHeader> out = exchange.getMessage().getBody(CxfPayload.class);
    assertEquals(1, out.getBody().size());
    
    Map<String, String> ns = new HashMap<>();
    ns.put("ns", MtomTestHelper.SERVICE_TYPES_NS);
    ns.put("xop", MtomTestHelper.XOP_NS);
    
    XPathUtils xu = new XPathUtils(ns);
    Element oute = new XmlConverter().toDOMElement(out.getBody().get(0));
    Element ele = (Element) xu.getValue("//ns:DetailResponse/ns:photo/xop:Include", oute,
                    XPathConstants.NODE);
    String photoId = ele.getAttribute("href").substring(4); // skip "cid:"
    
    ele = (Element) xu.getValue("//ns:DetailResponse/ns:image/xop:Include", oute,
                    XPathConstants.NODE);
    String imageId = ele.getAttribute("href").substring(4); // skip "cid:"
    
    DataHandler dr = exchange.getMessage(AttachmentMessage.class).getAttachment(decodingReference(photoId));
    assertEquals("application/octet-stream", dr.getContentType());
    assertArrayEquals(MtomTestHelper.RESP_PHOTO_DATA, IOUtils.readBytesFromStream(dr.getInputStream()));
    
    dr = exchange.getMessage(AttachmentMessage.class).getAttachment(decodingReference(imageId));
    assertEquals("image/jpeg", dr.getContentType());
    
    BufferedImage image = ImageIO.read(dr.getInputStream());
    assertEquals(560, image.getWidth());
    assertEquals(300, image.getHeight());

You can also consume a Camel message received from a CXF endpoint in
Payload mode. The
[CxfMtomConsumerPayloadModeTest](https://github.com/apache/camel/blob/main/components/camel-cxf/camel-cxf-spring-soap/src/test/java/org/apache/camel/component/cxf/mtom/CxfMtomConsumerPayloadModeTest.java#L97)
illustrates how this works:

    public static class MyProcessor implements Processor {
    
        @Override
        @SuppressWarnings("unchecked")
        public void process(Exchange exchange) throws Exception {
            CxfPayload<SoapHeader> in = exchange.getIn().getBody(CxfPayload.class);
    
            // verify request
            assertEquals(1, in.getBody().size());
    
            Map<String, String> ns = new HashMap<>();
            ns.put("ns", MtomTestHelper.SERVICE_TYPES_NS);
            ns.put("xop", MtomTestHelper.XOP_NS);
    
            XPathUtils xu = new XPathUtils(ns);
            Element body = new XmlConverter().toDOMElement(in.getBody().get(0));
            Element ele = (Element) xu.getValue("//ns:Detail/ns:photo/xop:Include", body,
                    XPathConstants.NODE);
            String photoId = ele.getAttribute("href").substring(4); // skip "cid:"
            assertEquals(MtomTestHelper.REQ_PHOTO_CID, photoId);
    
            ele = (Element) xu.getValue("//ns:Detail/ns:image/xop:Include", body,
                    XPathConstants.NODE);
            String imageId = ele.getAttribute("href").substring(4); // skip "cid:"
            assertEquals(MtomTestHelper.REQ_IMAGE_CID, imageId);
    
            DataHandler dr = exchange.getIn(AttachmentMessage.class).getAttachment(photoId);
            assertEquals("application/octet-stream", dr.getContentType());
            assertArrayEquals(MtomTestHelper.REQ_PHOTO_DATA, IOUtils.readBytesFromStream(dr.getInputStream()));
    
            dr = exchange.getIn(AttachmentMessage.class).getAttachment(imageId);
            assertEquals("image/jpeg", dr.getContentType());
            assertArrayEquals(MtomTestHelper.requestJpeg, IOUtils.readBytesFromStream(dr.getInputStream()));
    
            // create response
            List<Source> elements = new ArrayList<>();
            elements.add(new DOMSource(StaxUtils.read(new StringReader(MtomTestHelper.RESP_MESSAGE)).getDocumentElement()));
            CxfPayload<SoapHeader> sbody = new CxfPayload<>(
                    new ArrayList<SoapHeader>(),
                    elements, null);
            exchange.getMessage().setBody(sbody);
            exchange.getMessage(AttachmentMessage.class).addAttachment(MtomTestHelper.RESP_PHOTO_CID,
                    new DataHandler(new ByteArrayDataSource(MtomTestHelper.RESP_PHOTO_DATA, "application/octet-stream")));
    
            exchange.getMessage(AttachmentMessage.class).addAttachment(MtomTestHelper.RESP_IMAGE_CID,
                    new DataHandler(new ByteArrayDataSource(MtomTestHelper.responseJpeg, "image/jpeg")));
    
        }
    }

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|allowStreaming|This option controls whether the CXF component, when running in PAYLOAD mode, will DOM parse the incoming messages into DOM Elements or keep the payload as a javax.xml.transform.Source object that would allow streaming in some cases.||boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|headerFilterStrategy|To use a custom org.apache.camel.spi.HeaderFilterStrategy to filter header to and from Camel message.||object|
|useGlobalSslContextParameters|Enable usage of global SSL context parameters.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|beanId|To lookup an existing configured CxfEndpoint. Must used bean: as prefix.||string|
|address|The service publish address.||string|
|dataFormat|The data type messages supported by the CXF endpoint.|POJO|object|
|wrappedStyle|The WSDL style that describes how parameters are represented in the SOAP body. If the value is false, CXF will chose the document-literal unwrapped style, If the value is true, CXF will chose the document-literal wrapped style||boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|cookieHandler|Configure a cookie handler to maintain a HTTP session||object|
|defaultOperationName|This option will set the default operationName that will be used by the CxfProducer which invokes the remote service.||string|
|defaultOperationNamespace|This option will set the default operationNamespace that will be used by the CxfProducer which invokes the remote service.||string|
|hostnameVerifier|The hostname verifier to be used. Use the # notation to reference a HostnameVerifier from the registry.||object|
|sslContextParameters|The Camel SSL setting reference. Use the # notation to reference the SSL Context.||object|
|wrapped|Which kind of operation that CXF endpoint producer will invoke|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|synchronous|Sets whether synchronous processing should be strictly used|false|boolean|
|allowStreaming|This option controls whether the CXF component, when running in PAYLOAD mode, will DOM parse the incoming messages into DOM Elements or keep the payload as a javax.xml.transform.Source object that would allow streaming in some cases.||boolean|
|bus|To use a custom configured CXF Bus.||object|
|continuationTimeout|This option is used to set the CXF continuation timeout which could be used in CxfConsumer by default when the CXF server is using Jetty or Servlet transport.|30000|duration|
|cxfBinding|To use a custom CxfBinding to control the binding between Camel Message and CXF Message.||object|
|cxfConfigurer|This option could apply the implementation of org.apache.camel.component.cxf.CxfEndpointConfigurer which supports to configure the CXF endpoint in programmatic way. User can configure the CXF server and client by implementing configure{ServerClient} method of CxfEndpointConfigurer.||object|
|defaultBus|Will set the default bus when CXF endpoint create a bus by itself|false|boolean|
|headerFilterStrategy|To use a custom HeaderFilterStrategy to filter header to and from Camel message.||object|
|mergeProtocolHeaders|Whether to merge protocol headers. If enabled then propagating headers between Camel and CXF becomes more consistent and similar. For more details see CAMEL-6393.|false|boolean|
|mtomEnabled|To enable MTOM (attachments). This requires to use POJO or PAYLOAD data format mode.|false|boolean|
|properties|To set additional CXF options using the key/value pairs from the Map. For example to turn on stacktraces in SOAP faults, properties.faultStackTraceEnabled=true||object|
|schemaValidationEnabled|Enable schema validation for request and response. Disabled by default for performance reason|false|boolean|
|skipPayloadMessagePartCheck|Sets whether SOAP message validation should be disabled.|false|boolean|
|loggingFeatureEnabled|This option enables CXF Logging Feature which writes inbound and outbound SOAP messages to log.|false|boolean|
|loggingSizeLimit|To limit the total size of number of bytes the logger will output when logging feature has been enabled and -1 for no limit.|49152|integer|
|skipFaultLogging|This option controls whether the PhaseInterceptorChain skips logging the Fault that it catches.|false|boolean|
|password|This option is used to set the basic authentication information of password for the CXF client.||string|
|username|This option is used to set the basic authentication information of username for the CXF client.||string|
|bindingId|The bindingId for the service model to use.||string|
|portName|The endpoint name this service is implementing, it maps to the wsdl:portname. In the format of ns:PORT\_NAME where ns is a namespace prefix valid at this scope.||string|
|publishedEndpointUrl|This option can override the endpointUrl that published from the WSDL which can be accessed with service address url plus wsd||string|
|serviceClass|The class name of the SEI (Service Endpoint Interface) class which could have JSR181 annotation or not.||string|
|serviceName|The service name this service is implementing, it maps to the wsdl:servicename.||string|
|wsdlURL|The location of the WSDL. Can be on the classpath, file system, or be hosted remotely.||string|
