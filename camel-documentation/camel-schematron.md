# Schematron

**Since Camel 2.15**

**Only producer is supported**

[Schematron](http://www.schematron.com/index.html) is an XML-based
language for validating XML instance documents. It is used to make
assertions about data in an XML document, and it is also used to express
operational and business rules. Schematron is an [ISO
Standard](http://standards.iso.org/ittf/PubliclyAvailableStandards/index.html).
The schematron component uses the leading
[implementation](http://www.schematron.com/implementation.html) of ISO
schematron. It is an XSLT based implementation. The schematron rules are
run through [four XSLT
pipelines](http://www.schematron.com/implementation.html), which
generates a final XSLT which will be used as the basis for running the
assertion against the XML document. The component is written in a way
that Schematron rules are loaded at the start of the endpoint (only
once) this is to minimize the overhead of instantiating a Java Templates
object representing the rules.

# URI format

    schematron://path?[options]

# Headers

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 69%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">In/Out</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p>CamelSchematronValidationStatus</p></td>
<td style="text-align: left;"><p>The schematron validation status:
SUCCESS / FAILED</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>IN</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p>CamelSchematronValidationReport</p></td>
<td style="text-align: left;"><p>The schematrion report body in XML
format. See an example below</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>IN</p></td>
</tr>
</tbody>
</table>

# URI and path syntax

The following example shows how to invoke the schematron processor in
Java DSL. The schematron rules file is sourced from the class path:

    from("direct:start").to("schematron://sch/schematron.sch").to("mock:result")

The following example shows how to invoke the schematron processor in
XML DSL. The schematrion rules file is sourced from the file system:

    <route>
       <from uri="direct:start" />
       <to uri="schematron:///usr/local/sch/schematron.sch" />
       <log message="Schematron validation status: ${in.header.CamelSchematronValidationStatus}" />
       <choice>
          <when>
             <simple>${in.header.CamelSchematronValidationStatus} == 'SUCCESS'</simple>
             <to uri="mock:success" />
          </when>
          <otherwise>
             <log message="Failed schematron validation" />
             <setBody>
                <header>CamelSchematronValidationReport</header>
             </setBody>
             <to uri="mock:failure" />
          </otherwise>
       </choice>
    </route>

**Where to store schematron rules?**

Schematron rules can change with business requirement, as such it is
recommended to store these rules somewhere in a file system. When the
schematron component endpoint is started, the rules are compiled into
XSLT as a Java Templates Object. This is done only once to minimize the
overhead of instantiating Java Templates object, which can be an
expensive operation for a large set of rules and given that the process
goes through four pipelines of [XSLT
transformations](http://www.schematron.com/implementation.html). So if
you happen to store the rules in the file system, in the event of an
update, all you need is to restart the route or the component. No harm
in storing these rules in the class path though, but you will have to
build and deploy the component to pick up the changes.

# Schematron rules and report samples

Here is an example of schematron rules

    <?xml version="1.0" encoding="UTF-8"?>
    <schema xmlns="http://purl.oclc.org/dsdl/schematron">
       <title>Check Sections 12/07</title>
       <pattern id="section-check">
          <rule context="section">
             <assert test="title">This section has no title</assert>
             <assert test="para">This section has no paragraphs</assert>
          </rule>
       </pattern>
    </schema>

Here is an example of schematron report:

    <?xml version="1.0" encoding="UTF-8"?>
    <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
     xmlns:iso="http://purl.oclc.org/dsdl/schematron"
     xmlns:saxon="http://saxon.sf.net/"
     xmlns:schold="http://www.ascc.net/xml/schematron"
     xmlns:xhtml="http://www.w3.org/1999/xhtml"
     xmlns:xs="http://www.w3.org/2001/XMLSchema"
     xmlns:xsd="http://www.w3.org/2001/XMLSchema" schemaVersion="" title="">
    
       <svrl:active-pattern document="" />
       <svrl:fired-rule context="chapter" />
       <svrl:failed-assert test="title" location="/doc[1]/chapter[1]">
          <svrl:text>A chapter should have a title</svrl:text>
       </svrl:failed-assert>
       <svrl:fired-rule context="chapter" />
       <svrl:failed-assert test="title" location="/doc[1]/chapter[2]">
          <svrl:text>A chapter should have a title</svrl:text>
       </svrl:failed-assert>
       <svrl:fired-rule context="chapter" />
    </svrl:schematron-output>

**Useful Links and resources**

-   [Introduction to
    Schematron](http://www.mulberrytech.com/papers/schematron-Philly.pdf)
    by Mulleberry technologies. An excellent document in PDF to get you
    started on Schematron.

-   [Schematron official site](http://www.schematron.com). This contains
    links to other resources

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|path|The path to the schematron rules file. Can either be in class path or location in the file system.||string|
|abort|Flag to abort the route and throw a schematron validation exception.|false|boolean|
|rules|To use the given schematron rules instead of loading from the path||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|uriResolver|Set the URIResolver to be used for resolving schematron includes in the rules file.||object|
