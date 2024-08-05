# Language

**Since Camel 2.5**

**Only producer is supported**

The Language component allows you to send `Exchange` to an endpoint
which executes a script by any of the supported Languages in Camel.

By having a component to execute language scripts, it allows more
dynamic routing capabilities. For example, by using the Routing Slip or
[Dynamic Router](#eips:dynamicRouter-eip.adoc) EIPs you can send
messages to `language` endpoints where the script is dynamically defined
as well.

You only have to include additional Camel components if the language of
choice mandates it, such as using
[Groovy](#languages:groovy-language.adoc) or
[JavaScript](#languages:groovy-language.adoc) languages.

# URI format

    language://languageName[:script][?options]

You can refer to an external resource for the script using the same
notation as supported by the other [Language](#language-component.adoc)s
in Camel

    language://languageName:resource:scheme:location][?options]

# Examples

For example, you can use the [Simple](#languages:simple-language.adoc)
language as [Message Translator](#eips:message-translator.adoc) EIP:

    from("direct:hello")
        .to("language:simple:Hello ${body}")

In case you want to convert the message body type, you can do this as
well. However, it is better to use [Convert Body
To](#eips:convertBodyTo-eip.adoc):

    from("direct:toString")
        .to("language:simple:${bodyAs(String.class)}")

You can also use the [Groovy](#languages:groovy-language.adoc) language,
such as this example where the input message will be multiplied with 2:

    from("direct:double")
        .to("language:groovy:${body} * 2}")

You can also provide the script as a header as shown below. Here we use
[XPath](#languages:xpath-language.adoc) language to extract the text
from the `<foo>` tag.

    Object out = producer.requestBodyAndHeader("language:xpath", "<foo>Hello World</foo>", Exchange.LANGUAGE_SCRIPT, "/foo/text()");
    assertEquals("Hello World", out);

# Loading scripts from resources

You can specify a resource uri for a script to load in either the
endpoint uri, or in the `Exchange.LANGUAGE_SCRIPT` header. The uri must
start with one of the following schemes: `file:`, `classpath:`, or
`http:`

    from("direct:start")
            // load the script from the classpath
            .to("language:simple:resource:classpath:org/apache/camel/component/language/mysimplescript.txt")
            .to("mock:result");

By default, the script is loaded once and cached. However, you can
disable the `contentCache` option and have the script loaded on each
evaluation. For example, if the file `myscript.txt` is changed on disk,
then the updated script is used:

    from("direct:start")
            // the script will be loaded on each message, as we disabled cache
            .to("language:simple:myscript.txt?contentCache=false")
            .to("mock:result");

You can also refer to the script as a resource similar to how all the
other [Language](#language-component.adoc)s in Camel functions, by
prefixing with `resource:` as shown below:

    from("direct:start")
        .to("language:constant:resource:classpath:org/apache/camel/component/language/hello.txt")
        .to("mock:result");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|languageName|Sets the name of the language to use||string|
|resourceUri|Path to the resource, or a reference to lookup a bean in the Registry to use as the resource||string|
|allowContextMapAll|Sets whether the context map should allow access to all details. By default only the message body and headers can be accessed. This option can be enabled for full access to the current Exchange and CamelContext. Doing so impose a potential security risk as this opens access to the full power of CamelContext API.|false|boolean|
|binary|Whether the script is binary content or text content. By default the script is read as text content (eg java.lang.String)|false|boolean|
|cacheScript|Whether to cache the compiled script and reuse Notice reusing the script can cause side effects from processing one Camel org.apache.camel.Exchange to the next org.apache.camel.Exchange.|false|boolean|
|contentCache|Sets whether to use resource content cache or not|true|boolean|
|resultType|Sets the class of the result type (type from output)||string|
|script|Sets the script to execute||string|
|transform|Whether or not the result of the script should be used as message body. This options is default true.|true|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
