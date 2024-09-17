# Xslt-saxon

**Since Camel 3.0**

**Only producer is supported**

The XSLT Saxon component allows you to process a message using an
[XSLT](http://www.w3.org/TR/xslt) template using Saxon. This can be
ideal when using Templating to generate responses for requests.

# URI format

    xslt-saxon:templateName[?options]

The URI format contains **templateName**, which can be one of the
following:

-   the classpath-local URI of the template to invoke

-   the complete URL of the remote template.

You can append query options to the URI in the following format:

**?option=value\&option=value\&…**

<table>
<caption>Example URIs</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">URI</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>xslt-saxon:com/acme/mytransform.xsl</code></p></td>
<td style="text-align: left;"><p>Refers to the file
<code>com/acme/mytransform.xsl</code> on the classpath</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>xslt-saxon:file:///foo/bar.xsl</code></p></td>
<td style="text-align: left;"><p>Refers to the file
<code>/foo/bar.xsl</code></p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>xslt-saxon:http://acme.com/cheese/foo.xsl</code></p></td>
<td style="text-align: left;"><p>Refers to the remote http
resource</p></td>
</tr>
</tbody>
</table>

Example URIs

# Usage

## Using XSLT endpoints

The following format is an example of using an XSLT template to
formulate a response for a message for InOut message exchanges (where
there is a `JMSReplyTo` header)

    from("activemq:My.Queue").
      to("xslt-saxon:com/acme/mytransform.xsl");

If you want to use InOnly and consume the message and send it to another
destination, you could use the following route:

    from("activemq:My.Queue").
      to("xslt-saxon:com/acme/mytransform.xsl").
      to("activemq:Another.Queue");

## Getting Usable Parameters into the XSLT

By default, all headers are added as parameters which are then available
in the XSLT.  
To make the parameters usable, you will need to declare them.

    <setHeader name="myParam"><constant>42</constant></setHeader>
    <to uri="xslt-saxon:MyTransform.xsl"/>

The parameter also needs to be declared in the top level of the XSLT for
it to be available:

    <xsl: ...... >
    
       <xsl:param name="myParam"/>
    
        <xsl:template ...>

## Spring XML versions

To use the above examples in Spring XML, you would use something like
the following code:

      <camelContext xmlns="http://activemq.apache.org/camel/schema/spring">
        <route>
          <from uri="activemq:My.Queue"/>
          <to uri="xslt-saxon:org/apache/camel/spring/processor/example.xsl"/>
          <to uri="activemq:Another.Queue"/>
        </route>
      </camelContext>

## Using `xsl:include`

Camel provides its own implementation of `URIResolver`. This allows
Camel to load included files from the classpath.

For example, the included file in the following code will be located
relative to the starting endpoint.

    <xsl:include href="staff_template.xsl"/>

This means that Camel will locate the file in the **classpath** as
**org/apache/camel/component/xslt/staff\_template.xsl**

You can use `classpath:` or `file:` to instruct Camel to look either in
the classpath or file system. If you omit the prefix, then Camel uses
the prefix from the endpoint configuration. If no prefix is specified in
the endpoint configuration, the default is `classpath:`.

You can also refer backwards in the included paths. In the following
example, the XSL file will be resolved under
`org/apache/camel/component`.

        <xsl:include href="../staff_other_template.xsl"/>

## Using `xsl:include` and default prefix

Camel will use the prefix from the endpoint configuration as the default
prefix.

You can explicitly specify `file:` or `classpath:` loading. The two
loading types can be mixed in an XSLT script, if necessary.

## Using Saxon extension functions

Since Saxon 9.2, writing extension functions has been supplemented by a
new mechanism, referred to as [extension
functions](https://www.saxonica.com/html/documentation12/extensibility/extension-functions.html)
you can now easily use camel as shown in the below example:

    SimpleRegistry registry = new SimpleRegistry();
    registry.put("function1", new MyExtensionFunction1());
    registry.put("function2", new MyExtensionFunction2());
    
    CamelContext context = new DefaultCamelContext(registry);
    context.addRoutes(new RouteBuilder() {
        @Override
        public void configure() throws Exception {
            from("direct:start")
                .to("xslt-saxon:org/apache/camel/component/xslt/extensions/extensions.xslt?saxonExtensionFunctions=#function1,#function2");
        }
    });

With Spring XML:

    <bean id="function1" class="org.apache.camel.component.xslt.extensions.MyExtensionFunction1"/>
    <bean id="function2" class="org.apache.camel.component.xslt.extensions.MyExtensionFunction2"/>
    
    <camelContext xmlns="http://camel.apache.org/schema/spring">
      <route>
        <from uri="direct:extensions"/>
        <to uri="xslt-saxon:org/apache/camel/component/xslt/extensions/extensions.xslt?saxonExtensionFunctions=#function1,#function2"/>
      </route>
    </camelContext>

## Dynamic stylesheets

To provide a dynamic stylesheet at runtime, you can either:

-   Define a dynamic URI. See [How to use a dynamic URI in
    `to()`](#manual:faq:how-to-use-a-dynamic-uri-in-to.adoc) for more
    information.

-   Use header with the stylesheet.

When using a header for dynamic stylesheet, then you can either refer to
the stylesheet as a `file` or `classpath` with the header
`CamelXsltResourceUri`, such as:

    from("direct:transform")
        .setHeader("CamelXsltResourceUri", simple("file:styles/${header.region}.xsl"))
        .to("xslt-saxon:template.xsl?allowTemplateFromHeader=true");

Here we set the `CamelXsltResourceUri` header to refer to a stylesheet
to be loaded from the file system, with a dynamic name that is computed
from another header (`region`).

Notice how the `allowTemplateFromHeader` must be set to `true` on the
XSLT endpoint to support dynamic templates.

You can also use the header `CamelXsltStylesheet` which instead should
contain the content of the stylesheet to use, instead of referring to a
file as the example from above.

You can set `contentCache=false` and refer to a non-existing template,
such as
`"xslt-saxon:dummy.xsl?contentCache=false&allowTemplateFromHeader=true"`
as this will tell Camel to not load `dummy.xsl` on startup but to load
the stylesheet on demand. And because you provide the stylesheet via
headers, then it is fully dynamic.

## Accessing warnings, errors and fatalErrors from XSLT ErrorListener

Any warning/error or fatalError is stored on the current Exchange as a
property with the keys `Exchange.XSLT_ERROR`,
`Exchange.XSLT_FATAL_ERROR`, or `Exchange.XSLT_WARNING` which allows end
users to get hold of any errors happening during transformation.

For example, in the stylesheet below, we want to determinate whether a
staff has an empty dob field. And to include a custom error message
using `xsl:message`.

    <xsl:template match="/">
      <html>
        <body>
          <xsl:for-each select="staff/programmer">
            <p>Name: <xsl:value-of select="name"/><br />
              <xsl:if test="dob=''">
                <xsl:message terminate="yes">Error: DOB is an empty string!</xsl:message>
              </xsl:if>
            </p>
          </xsl:for-each>
        </body>
      </html>
    </xsl:template>

The exception is stored on the Exchange as a warning with the key
`Exchange.XSLT_WARNING.`

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|allowTemplateFromHeader|Whether to allow to use resource template from header or not (default false). Enabling this allows to specify dynamic templates via message header. However this can be seen as a potential security vulnerability if the header is coming from a malicious user, so use this with care.|false|boolean|
|contentCache|Cache for the resource content (the stylesheet file) when it is loaded. If set to false Camel will reload the stylesheet file on each message processing. This is good for development. A cached stylesheet can be forced to reload at runtime via JMX using the clearCachedStylesheet operation.|true|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|saxonConfiguration|To use a custom Saxon configuration||object|
|saxonConfigurationProperties|To set custom Saxon configuration properties||object|
|saxonExtensionFunctions|Allows you to use a custom net.sf.saxon.lib.ExtensionFunctionDefinition. You would need to add camel-saxon to the classpath. The function is looked up in the registry, where you can use commas to separate multiple values to lookup.||string|
|secureProcessing|Feature for XML secure processing (see javax.xml.XMLConstants). This is enabled by default. However, when using Saxon Professional you may need to turn this off to allow Saxon to be able to use Java extension functions.|true|boolean|
|transformerFactoryClass|To use a custom XSLT transformer factory, specified as a FQN class name||string|
|transformerFactoryConfigurationStrategy|A configuration strategy to apply on freshly created instances of TransformerFactory.||object|
|uriResolver|To use a custom UriResolver. Should not be used together with the option 'uriResolverFactory'.||object|
|uriResolverFactory|To use a custom UriResolver which depends on a dynamic endpoint resource URI. Should not be used together with the option 'uriResolver'.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|resourceUri|Path to the template. The following is supported by the default URIResolver. You can prefix with: classpath, file, http, ref, or bean. classpath, file and http loads the resource using these protocols (classpath is default). ref will lookup the resource in the registry. bean will call a method on a bean to be used as the resource. For bean you can specify the method name after dot, eg bean:myBean.myMethod||string|
|allowStAX|Whether to allow using StAX as the javax.xml.transform.Source. You can enable this if the XSLT library supports StAX such as the Saxon library (camel-saxon). The Xalan library (default in JVM) does not support StAXSource.|true|boolean|
|allowTemplateFromHeader|Whether to allow to use resource template from header or not (default false). Enabling this allows to specify dynamic templates via message header. However this can be seen as a potential security vulnerability if the header is coming from a malicious user, so use this with care.|false|boolean|
|contentCache|Cache for the resource content (the stylesheet file) when it is loaded on startup. If set to false Camel will reload the stylesheet file on each message processing. This is good for development. A cached stylesheet can be forced to reload at runtime via JMX using the clearCachedStylesheet operation.|true|boolean|
|deleteOutputFile|If you have output=file then this option dictates whether or not the output file should be deleted when the Exchange is done processing. For example suppose the output file is a temporary file, then it can be a good idea to delete it after use.|false|boolean|
|failOnNullBody|Whether or not to throw an exception if the input body is null.|true|boolean|
|output|Option to specify which output type to use. Possible values are: string, bytes, DOM, file. The first three options are all in memory based, where as file is streamed directly to a java.io.File. For file you must specify the filename in the IN header with the key XsltConstants.XSLT\_FILE\_NAME which is also CamelXsltFileName. Also any paths leading to the filename must be created beforehand, otherwise an exception is thrown at runtime.|string|object|
|transformerCacheSize|The number of javax.xml.transform.Transformer object that are cached for reuse to avoid calls to Template.newTransformer().|0|integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|entityResolver|To use a custom org.xml.sax.EntityResolver with javax.xml.transform.sax.SAXSource.||object|
|errorListener|Allows to configure to use a custom javax.xml.transform.ErrorListener. Beware when doing this then the default error listener which captures any errors or fatal errors and store information on the Exchange as properties is not in use. So only use this option for special use-cases.||object|
|resultHandlerFactory|Allows you to use a custom org.apache.camel.builder.xml.ResultHandlerFactory which is capable of using custom org.apache.camel.builder.xml.ResultHandler types.||object|
|saxonConfiguration|To use a custom Saxon configuration||object|
|saxonExtensionFunctions|Allows you to use a custom net.sf.saxon.lib.ExtensionFunctionDefinition. You would need to add camel-saxon to the classpath. The function is looked up in the registry, where you can comma to separate multiple values to lookup.||string|
|secureProcessing|Feature for XML secure processing (see javax.xml.XMLConstants). This is enabled by default. However, when using Saxon Professional you may need to turn this off to allow Saxon to be able to use Java extension functions.|true|boolean|
|transformerFactory|To use a custom XSLT transformer factory||object|
|transformerFactoryClass|To use a custom XSLT transformer factory, specified as a FQN class name||string|
|transformerFactoryConfigurationStrategy|A configuration strategy to apply on freshly created instances of TransformerFactory.||object|
|uriResolver|To use a custom javax.xml.transform.URIResolver||object|
|xsltMessageLogger|A consumer to messages generated during XSLT transformations.||object|
