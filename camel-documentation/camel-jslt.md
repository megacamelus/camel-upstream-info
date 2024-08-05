# Jslt

**Since Camel 3.1**

**Only producer is supported**

The JSLT component allows you to process JSON messages using an
[JSLT](https://github.com/schibsted/jslt) expression. This can be ideal
when doing JSON to JSON transformation or querying data.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-jslt</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    jslt:specName[?options]

Where **specName** is the classpath-local URI of the specification to
invoke; or the complete URL of the remote specification (e.g.:
`\file://folder/myfile.vm`).

# Passing values to JSLT

Camel can supply exchange information as variables when applying a JSLT
expression on the body. The available variables from the **Exchange**
are:

<table>
<colgroup>
<col style="width: 28%" />
<col style="width: 71%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">name</th>
<th style="text-align: left;">value</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>headers</p></td>
<td style="text-align: left;"><p>The headers of the In message as a json
object</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>variables</p></td>
<td style="text-align: left;"><p>The variables</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>exchange.properties</p></td>
<td style="text-align: left;"><p>The <strong>Exchange</strong>
properties as a json object. <code>exchange</code> is the name of the
variable and <code>properties</code> is the path to the exchange
properties. Available if <code>allowContextMapAll</code> option is
true.</p></td>
</tr>
</tbody>
</table>

All the values that cannot be converted to json with Jackson are denied
and will not be available in the jslt expression.

For example, the header named `type` and the exchange property
`instance` can be accessed like

    {
      "type": $headers.type,
      "instance": $exchange.properties.instance
    }

# Samples

For example, you could use something like:

    from("activemq:My.Queue").
      to("jslt:com/acme/MyResponse.json");

And a file-based resource:

    from("activemq:My.Queue").
      to("jslt:file://myfolder/MyResponse.json?contentCache=true").
      to("activemq:Another.Queue");

You can also specify which JSLT expression the component should use
dynamically via a header, so, for example:

    from("direct:in").
      setHeader("CamelJsltResourceUri").constant("path/to/my/spec.json").
      to("jslt:dummy?allowTemplateFromHeader=true");

Or send whole jslt expression via header: (suitable for querying)

    from("direct:in").
      setHeader("CamelJsltString").constant(".published").
      to("jslt:dummy?allowTemplateFromHeader=true");

Passing exchange properties to the jslt expression can be done like this

    from("direct:in").
      to("jslt:com/acme/MyResponse.json?allowContextMapAll=true");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|allowTemplateFromHeader|Whether to allow to use resource template from header or not (default false). Enabling this allows to specify dynamic templates via message header. However this can be seen as a potential security vulnerability if the header is coming from a malicious user, so use this with care.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|functions|JSLT can be extended by plugging in functions written in Java.||array|
|objectFilter|JSLT can be extended by plugging in a custom jslt object filter||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|resourceUri|Path to the resource. You can prefix with: classpath, file, http, ref, or bean. classpath, file and http loads the resource using these protocols (classpath is default). ref will lookup the resource in the registry. bean will call a method on a bean to be used as the resource. For bean you can specify the method name after dot, eg bean:myBean.myMethod.||string|
|allowContextMapAll|Sets whether the context map should allow access to all details. By default only the message body and headers can be accessed. This option can be enabled for full access to the current Exchange and CamelContext. Doing so impose a potential security risk as this opens access to the full power of CamelContext API.|false|boolean|
|allowTemplateFromHeader|Whether to allow to use resource template from header or not (default false). Enabling this allows to specify dynamic templates via message header. However this can be seen as a potential security vulnerability if the header is coming from a malicious user, so use this with care.|false|boolean|
|contentCache|Sets whether to use resource content cache or not|false|boolean|
|mapBigDecimalAsFloats|If true, the mapper will use the USE\_BIG\_DECIMAL\_FOR\_FLOATS in serialization features|false|boolean|
|objectMapper|Setting a custom JSON Object Mapper to be used||object|
|prettyPrint|If true, JSON in output message is pretty printed.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
