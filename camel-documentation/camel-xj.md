# Xj

**Since Camel 3.0**

**Only producer is supported**

The XJ component allows you to convert XML and JSON documents directly
forth and back without the need of intermediate java objects. You can
even specify an XSLT stylesheet to convert directly to the target JSON /
XML (domain) model.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-xj</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    xj:templateName?transformDirection=XML2JSON|JSON2XML[&options]

**More documentation**

The XJ component extends the XSLT component, and therefore it supports
all options provided by the XSLT component as well. At least look at the
XSLT component documentation how to configure the xsl template.

The **transformDirection** option is mandatory and must be either
XML2JSON or JSON2XML.

The **templateName** parameter allows using *identify transforma* by
specifying the name `identity`.

# Using XJ endpoints

## Converting JSON to XML

The following route does an "identity" transform of the message because
no xslt stylesheet is given. In the context of xml to xml
transformations, "Identity" transform means that the output document is
just a copy of the input document. In the case of XJ, it means it
transforms the json document to an equivalent xml representation.

    from("direct:start").
      to("xj:identity?transformDirection=JSON2XML");

Sample:

The input:

    {
      "firstname": "camel",
      "lastname": "apache",
      "personalnumber": 42,
      "active": true,
      "ranking": 3.1415926,
      "roles": [
        "a",
        {
          "x": null
        }
      ],
      "state": {
        "needsWater": true
      }
    }

Will output:

    <?xml version="1.0" encoding="UTF-8"?>
    <object xmlns:xj="http://camel.apache.org/component/xj" xj:type="object">
        <object xj:name="firstname" xj:type="string">camel</object>
        <object xj:name="lastname" xj:type="string">apache</object>
        <object xj:name="personalnumber" xj:type="int">42</object>
        <object xj:name="active" xj:type="boolean">true</object>
        <object xj:name="ranking" xj:type="float">3.1415926</object>
        <object xj:name="roles" xj:type="array">
            <object xj:type="string">a</object>
            <object xj:type="object">
                <object xj:name="x" xj:type="null">null</object>
            </object>
        </object>
        <object xj:name="state" xj:type="object">
            <object xj:name="needsWater" xj:type="boolean">true</object>
        </object>
    </object>

As can be seen in the output above, XJ writes some metadata in the
resulting xml that can be used in further processing:

-   XJ metadata nodes are always in the
    `http://camel.apache.org/component/xj` namespace.

-   JSON key names are placed in the xj:name attribute.

-   The parsed JSON type can be found in the xj:type attribute. The
    above example already contains all possible types.

-   Generated XML elements are always named "object".

Now we can apply a stylesheet, e.g.:

    <?xml version="1.0" encoding="UTF-8" ?>
    <xsl:stylesheet version="1.0"
                    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                    xmlns:xj="http://camel.apache.org/component/xj"
                    exclude-result-prefixes="xj">
    
        <xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="yes"/>
    
        <xsl:template match="/">
            <person>
                <xsl:apply-templates select="//object"/>
            </person>
        </xsl:template>
    
        <xsl:template match="object[@xj:type != 'object' and @xj:type != 'array' and string-length(@xj:name) > 0]">
            <xsl:variable name="name" select="@xj:name"/>
            <xsl:element name="{$name}">
                <xsl:value-of select="text()"/>
            </xsl:element>
        </xsl:template>
    
        <xsl:template match="@*|node()"/>
    </xsl:stylesheet>

To the above sample by specifying the template on the endpoint:

    from("direct:start").
      to("xj:com/example/json2xml.xsl?transformDirection=JSON2XML");

And get the following output:

    <?xml version="1.0" encoding="UTF-8"?>
    <person>
        <firstname>camel</firstname>
        <lastname>apache</lastname>
        <personalnumber>42</personalnumber>
        <active>true</active>
        <ranking>3.1415926</ranking>
        <x>null</x>
        <needsWater>true</needsWater>
    </person>

## Converting XML to JSON

Based on the explanations above, an *identity* transform will be
performed when no stylesheet is given:

    from("direct:start").
      to("xj:identity?transformDirection=XML2JSON");

Given the sample input

    <?xml version="1.0" encoding="UTF-8"?>
    <person>
        <firstname>camel</firstname>
        <lastname>apache</lastname>
        <personalnumber>42</personalnumber>
        <active>true</active>
        <ranking>3.1415926</ranking>
        <roles>
            <entry>a</entry>
            <entry>
                <x>null</x>
            </entry>
        </roles>
        <state>
            <needsWater>true</needsWater>
        </state>
    </person>

will result in

    {
      "firstname": "camel",
      "lastname": "apache",
      "personalnumber": "42",
      "active": "true",
      "ranking": "3.1415926",
      "roles": [
        "a",
        {
          "x": "null"
        }
      ],
      "state": {
        "needsWater": "true"
      }
    }

You may have noted that the input xml and output json are very similar
to the examples above when converting from json to xml, although nothing
special is done here. We only transformed an arbitrary XML document to
json. XJ uses the following rules by default:

-   The XML root element can be named somehow, it will always end in a
    json root object declaration `{}`

-   The json key name is the name of the xml element

-   If there is a name clash as in `<roles>` above where two `<entry>`
    elements exist a json array will be generated.

-   XML elements with text-only-child-nodes will result in the usual
    key/string-value pair. Mixed content elements result in a
    key/child-object pair as seen in `<state>` above.

Now we can apply again a stylesheet, e.g.:

    <?xml version="1.0" encoding="UTF-8" ?>
    <xsl:stylesheet version="1.0"
                    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                    xmlns:xj="http://camel.apache.org/component/xj"
                    exclude-result-prefixes="xj">
    
        <xsl:output omit-xml-declaration="no" encoding="UTF-8" method="xml" indent="yes"/>
    
        <xsl:template match="/">
            <xsl:apply-templates/>
        </xsl:template>
    
        <xsl:template match="personalnumber">
            <xsl:element name="{local-name()}">
                <xsl:attribute name="xj:type">
                    <xsl:value-of select="'int'"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:template>
    
        <xsl:template match="active|needsWater">
            <xsl:element name="{local-name()}">
                <xsl:attribute name="xj:type">
                    <xsl:value-of select="'boolean'"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:template>
    
        <xsl:template match="ranking">
            <xsl:element name="{local-name()}">
                <xsl:attribute name="xj:type">
                    <xsl:value-of select="'float'"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:template>
    
        <xsl:template match="roles">
            <xsl:element name="{local-name()}">
                <xsl:attribute name="xj:type">
                    <xsl:value-of select="'array'"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:template>
    
        <xsl:template match="*[normalize-space(text()) = 'null']">
            <xsl:element name="{local-name()}">
                <xsl:attribute name="xj:type">
                    <xsl:value-of select="'null'"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:template>
    
        <xsl:template match="@*|node()">
            <xsl:copy>
                <xsl:apply-templates select="@*|node()"/>
            </xsl:copy>
        </xsl:template>
    </xsl:stylesheet>

to the sample above by specifying the template on the endpoint:

    from("direct:start").
      to("xj:com/example/xml2json.xsl?transformDirection=XML2JSON");

and get the following output:

    {
      "firstname": "camel",
      "lastname": "apache",
      "personalnumber": 42,
      "active": true,
      "ranking": 3.1415926,
      "roles": [
        "a",
        {
          "x": null
        }
      ],
      "state": {
        "needsWater": true
      }
    }

Note, this transformation resulted in exactly the same json document as
we used as input to the *json2xml* conversion. What did the stylesheet
do? We just gave some hints to XJ on how to write the json document. The
following XML document is that what is passed to XJ after xsl
transformation:

    <?xml version="1.0" encoding="UTF-8"?>
    <person>
        <firstname>camel</firstname>
        <lastname>apache</lastname>
        <personalnumber xmlns:xj="http://camel.apache.org/component/xj" xj:type="int">42</personalnumber>
        <active xmlns:xj="http://camel.apache.org/component/xj" xj:type="boolean">true</active>
        <ranking xmlns:xj="http://camel.apache.org/component/xj" xj:type="float">3.1415926</ranking>
        <roles xmlns:xj="http://camel.apache.org/component/xj" xj:type="array">
            <entry>a</entry>
            <entry>
                <x xj:type="null">null</x>
            </entry>
        </roles>
        <state>
            <needsWater xmlns:xj="http://camel.apache.org/component/xj" xj:type="boolean">true</needsWater>
        </state>
    </person>

In the stylesheet we just provided the minimal required type hints to
get the same result. The supported type hints are exactly the same as XJ
writes to a XML document when converting from json to xml.

In the end, that means that we can feed back in the result document from
the json to xml transformation sample above:

    <?xml version="1.0" encoding="UTF-8"?>
    <object xmlns:xj="http://camel.apache.org/component/xj" xj:type="object">
        <object xj:name="firstname" xj:type="string">camel</object>
        <object xj:name="lastname" xj:type="string">apache</object>
        <object xj:name="personalnumber" xj:type="int">42</object>
        <object xj:name="active" xj:type="boolean">true</object>
        <object xj:name="ranking" xj:type="float">3.1415926</object>
        <object xj:name="roles" xj:type="array">
            <object xj:type="string">a</object>
            <object xj:type="object">
                <object xj:name="x" xj:type="null">null</object>
            </object>
        </object>
        <object xj:name="state" xj:type="object">
            <object xj:name="needsWater" xj:type="boolean">true</object>
        </object>
    </object>

and get the same output again:

    {
      "firstname": "camel",
      "lastname": "apache",
      "personalnumber": 42,
      "active": true,
      "ranking": 3.1415926,
      "roles": [
        "a",
        {
          "x": null
        }
      ],
      "state": {
        "needsWater": true
      }
    }

As seen in the example above:

-   xj:type lets you specify exactly the desired output type

-   xj:name lets you overrule the json key name.

This is required when you want to generate key names that contain chars
that aren’t allowed in XML element names.

## Available type hints

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 66%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">@xj:type=</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>object</p></td>
<td style="text-align: left;"><p>Generate a json object</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>array</p></td>
<td style="text-align: left;"><p>Generate a json array</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>string</p></td>
<td style="text-align: left;"><p>Generate a json string</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>int</p></td>
<td style="text-align: left;"><p>Generate a json number without
fractional part</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>float</p></td>
<td style="text-align: left;"><p>Generate a json number with fractional
part</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"><p>Generate a json boolean</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>null</p></td>
<td style="text-align: left;"><p>Generate an empty value using the word
null</p></td>
</tr>
</tbody>
</table>

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
|transformDirection|Transform direction. Either XML2JSON or JSON2XML||object|
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
