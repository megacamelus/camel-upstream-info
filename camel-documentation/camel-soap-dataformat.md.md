# Soap-dataformat.md

**Since Camel 2.3**

SOAP is a Data Format which uses JAXB2 and JAX-WS annotations to marshal
and unmarshal SOAP payloads. It provides the basic features of Apache
CXF without the need for the CXF Stack.

**Namespace prefix mapping**

See [JAXB](#jaxb-dataformat.adoc) for details how you can control
namespace prefix mappings when marshalling using SOAP data format.

# SOAP Options

# ElementNameStrategy

An element name strategy is used for two purposes. The first is to find
an XML element name for a given object and soap action when marshaling
the object into a SOAP message. The second is to find an Exception class
for a given soap fault name.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Strategy</th>
<th style="text-align: left;">Usage</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>QNameStrategy</p></td>
<td style="text-align: left;"><p>Uses a fixed qName that is configured
on instantiation. Exception lookup is not supported</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>TypeNameStrategy</p></td>
<td style="text-align: left;"><p>Uses the name and namespace from the
<code>@XMLType</code> annotation of the given type. If no namespace is
set, then package-info is used. Exception lookup is not
supported</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>ServiceInterfaceStrategy</p></td>
<td style="text-align: left;"><p>Uses information from a webservice
interface to determine the type name and to find the exception class for
a SOAP fault</p></td>
</tr>
</tbody>
</table>

If you have generated the web service stub code with cxf-codegen or a
similar tool, then you probably will want to use the
`ServiceInterfaceStrategy`. In the case you have no annotated service
interface you should use `QNameStrategy` or `TypeNameStrategy`.

# Using the Java DSL

The following example uses a named `DataFormat` of *soap* which is
configured with the package `com.example.customerservice` to initialize
the
[JAXBContext](http://java.sun.com/javase/6/docs/api/javax/xml/bind/JAXBContext.html).
The second parameter is the `ElementNameStrategy`. The route is able to
marshal normal objects as well as exceptions.

The below just sends a SOAP Envelope to a queue. A web service provider
would actually need to be listening to the queue for a SOAP call to
actually occur, in which case it would be a one way SOAP request. If you
need to request a reply, then you should look at the next example.

    SoapDataFormat soap = new SoapDataFormat("com.example.customerservice", new ServiceInterfaceStrategy(CustomerService.class));
    from("direct:start")
      .marshal(soap)
      .to("jms:myQueue");

**See also**

As the SOAP dataformat inherits from the [JAXB](#jaxb-dataformat.adoc)
dataformat, most settings apply here as well

## Using SOAP 1.2

**Since Camel 2.11**

    SoapDataFormat soap = new SoapDataFormat("com.example.customerservice", new ServiceInterfaceStrategy(CustomerService.class));
    soap.setVersion("1.2");
    from("direct:start")
      .marshal(soap)
      .to("jms:myQueue");

When using XML DSL, there is a version attribute you can set on the
\<soap\> element.

        <!-- Defining a ServiceInterfaceStrategy for retrieving the element name when marshalling -->
        <bean id="myNameStrategy" class="org.apache.camel.dataformat.soap.name.ServiceInterfaceStrategy">
            <constructor-arg value="com.example.customerservice.CustomerService"/>
        <constructor-arg value="true"/>
        </bean>

And in the Camel route

    <route>
      <from uri="direct:start"/>
      <marshal>
        <soap contentPath="com.example.customerservice" version="1.2" elementNameStrategyRef="myNameStrategy"/>
      </marshal>
      <to uri="jms:myQueue"/>
    </route>

# Multi-part Messages

**Since Camel 2.8.1**

Multipart SOAP messages are supported by the `ServiceInterfaceStrategy`.
The `ServiceInterfaceStrategy` must be initialized with a service
interface definition that is annotated in accordance with JAX-WS 2.2 and
meets the requirements of the Document Bare style. The target method
must meet the following criteria, as per the JAX-WS specification: 1. it
must have at most one `in` or `in/out` non-header parameter, 2. if it
has a return type other than `void` it must have no `in/out` or `out`
non-header parameters, 3. if it has a return type of `void` it must have
at most one `in/out` or `out` non-header parameter.

The `ServiceInterfaceStrategy` should be initialized with a boolean
parameter that indicates whether the mapping strategy applies to the
request parameters or response parameters.

    ServiceInterfaceStrategy strat =  new ServiceInterfaceStrategy(com.example.customerservice.multipart.MultiPartCustomerService.class, true);
    SoapDataFormat soapDataFormat = new SoapDataFormat("com.example.customerservice.multipart", strat);

## Holder Object mapping

JAX-WS specifies the use of a type-parameterized `javax.xml.ws.Holder`
object for `In/Out` and `Out` parameters. You may use an instance of the
parameterized-type directly. The camel-soap DataFormat marshals Holder
values in accordance with the JAXB mapping for the class of the
\`\`Holder\`\`'s value. No mapping is provided for `Holder` objects in
an unmarshalled response.

# Examples

## Webservice client

The following route supports marshalling the request and unmarshalling a
response or fault.

    String WS_URI = "cxf://http://myserver/customerservice?serviceClass=com.example.customerservice&dataFormat=RAW";
    SoapDataFormat soapDF = new SoapDataFormat("com.example.customerservice", new ServiceInterfaceStrategy(CustomerService.class));
    from("direct:customerServiceClient")
      .onException(Exception.class)
        .handled(true)
        .unmarshal(soapDF)
      .end()
      .marshal(soapDF)
      .to(WS_URI)
      .unmarshal(soapDF);

The below snippet creates a proxy for the service interface and makes a
SOAP call to the above route.

    import org.apache.camel.Endpoint;
    import org.apache.camel.component.bean.ProxyHelper;
    ...
    
    Endpoint startEndpoint = context.getEndpoint("direct:customerServiceClient");
    ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
    // CustomerService below is the service endpoint interface, *not* the javax.xml.ws.Service subclass
    CustomerService proxy = ProxyHelper.createProxy(startEndpoint, classLoader, CustomerService.class);
    GetCustomersByNameResponse response = proxy.getCustomersByName(new GetCustomersByName());

## Webservice Server

Using the following route sets up a webservice server that consumes from
the jms queue `customerServiceQueue` and processes requests using the
class `CustomerServiceImpl`. The `customerServiceImpl` should implement
the interface `CustomerService`. Instead of directly instantiating the
server class it could be defined in a spring context as a regular bean.

    SoapDataFormat soapDF = new SoapDataFormat("com.example.customerservice", new ServiceInterfaceStrategy(CustomerService.class));
    CustomerService serverBean = new CustomerServiceImpl();
    from("jms://queue:customerServiceQueue")
      .onException(Exception.class)
        .handled(true)
        .marshal(soapDF)
      .end()
      .unmarshal(soapDF)
      .bean(serverBean)
      .marshal(soapDF);

# Dependencies

To use the SOAP dataformat in your Camel routes, you need to add the
following dependency to your `pom.xml`.

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-soap</artifactId>
      <version>x.y.z</version>
    </dependency>
