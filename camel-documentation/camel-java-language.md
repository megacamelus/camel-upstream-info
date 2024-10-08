# Java-language.md

**Since Camel 4.3**

The Java language (uses jOOR library to compile Java code) allows using
Java code in your Camel expression, with some limitations.

The jOOR library integrates with the Java compiler and performs runtime
compilation of Java code.

# Java Options

# Usage

## Variables

The Java language allows the following variables to be used in the
script:

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 10%" />
<col style="width: 69%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Variable</th>
<th style="text-align: left;">Java Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>context</code></p></td>
<td style="text-align: left;"><p><code>Context</code></p></td>
<td style="text-align: left;"><p>The CamelContext</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>exchange</code></p></td>
<td style="text-align: left;"><p><code>Exchange</code></p></td>
<td style="text-align: left;"><p>The Camel Exchange</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>message</code></p></td>
<td style="text-align: left;"><p><code>Message</code></p></td>
<td style="text-align: left;"><p>The Camel message</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>body</code></p></td>
<td style="text-align: left;"><p><code>Object</code></p></td>
<td style="text-align: left;"><p>The message body</p></td>
</tr>
</tbody>
</table>

## Functions

The Java language allows the following functions to be used in the
script:

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 80%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Function</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>bodyAs(type)</p></td>
<td style="text-align: left;"><p>To convert the body to the given
type.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>headerAs(name, type)</p></td>
<td style="text-align: left;"><p>To convert the header with the name to
the given type.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>headerAs(name, defaultValue,
type)</p></td>
<td style="text-align: left;"><p>To convert the header with the name to
the given type. If no header exists, then use the given default
value.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>exchangePropertyAs(name, type)</p></td>
<td style="text-align: left;"><p>To convert the exchange property with
the name to the given type.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>exchangePropertyAs(name, defaultValue,
type)</p></td>
<td style="text-align: left;"><p>To convert the exchange property with
the name to the given type. If no exchange property exists, then use the
given default value.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>optionalBodyAs(type)</p></td>
<td style="text-align: left;"><p>To convert the body to the given type,
returned wrapped in <code>java.util.Optional</code>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>optionalHeaderAs(name, type)</p></td>
<td style="text-align: left;"><p>To convert the header with the name to
the given type, returned wrapped in
<code>java.util.Optional</code>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>optionalExchangePropertyAs(name,
type)</p></td>
<td style="text-align: left;"><p>To convert the exchange property with
the name to the given type, returned wrapped in
<code>java.util.Optional</code>.</p></td>
</tr>
</tbody>
</table>

These functions are convenient for getting the message body, header or
exchange properties as a specific Java type.

Here we want to get the message body as a `com.foo.MyUser` type we can
do as follows:

    var user = bodyAs(com.foo.MyUser.class);

You can omit *.class* to make the function a little smaller:

    var user = bodyAs(com.foo.MyUser);

The type must be a fully qualified class type, but that can be
inconvenient to type all the time. In such a situation, you can
configure an import in the `camel-joor.properties` file as shown below:

    import com.foo.MyUser;

And then the function can be shortened:

    var user = bodyAs(MyUser);

## Dependency Injection

The Camel Java language allows dependency injection by referring to
beans by their id from the Camel registry. For optimization purposes,
then the beans are injected once in the constructor and the scopes are
*singleton*. This requires the injected beans to be *thread safe* as
they will be reused for all processing.

In the Java code you declare the injected beans using the syntax
`#bean:beanId`.

For example, suppose we have the following bean

    public class MyEchoBean {
    
        public String echo(String str) {
            return str + str;
        }
    
        public String greet() {
            return "Hello ";
        }
    }

And this bean is registered with the name `myEcho` in the Camel
registry.

The Java code can then inject this bean directly in the script where the
bean is in use:

    from("direct:start")
        .transform().java("'Hello ' + #bean:myEcho.echo(bodyAs(String))")
        .to("mock:result");

Now this code may seem a bit magic, but what happens is that the
`myEcho` bean is injected via a constructor, and then called directly in
the script, so it is as fast as possible.

Under the hood, Camel Java generates the following source code compiled
once:

    public class JoorScript1 implements org.apache.camel.language.joor.JoorMethod {
    
        private MyEchoBean myEcho;
    
        public JoorScript1(CamelContext context) throws Exception {
            myEcho = context.getRegistry().lookupByNameAndType("myEcho", MyEchoBean.class);
        }
    
        @Override
        public Object evaluate(CamelContext context, Exchange exchange, Message message, Object body, Optional optionalBody) throws Exception {
            return "Hello " + myEcho.echo(bodyAs(exchange, String.class));
        }
    }

You can also store a reference to the bean in a variable which would
more resemble how you would code in Java

    from("direct:start")
        .transform().java("var bean = #bean:myEcho; return 'Hello ' + bean.echo(bodyAs(String))")
        .to("mock:result");

Notice how we declare the bean as if it is a local variable via
`var bean = #bean:myEcho`. When doing this we must use a different name
as `myEcho` is the variable used by the dependency injection. Therefore,
we use *bean* as name in the script.

## Auto imports

The Java language will automatically import from:

    import java.util.*;
    import java.util.concurrent.*;
    import java.util.stream.*;
    import org.apache.camel.*;
    import org.apache.camel.util.*;

## Configuration file

You can configure the jOOR language in the `camel-joor.properties` file
which by default is loaded from the root classpath. You can specify a
different location with the `configResource` option on the Java
language.

For example, you can add additional imports in the
`camel-joor.properties` file by adding:

    import com.foo.MyUser;
    import com.bar.*;
    import static com.foo.MyHelper.*;

You can also add aliases (`key=value`) where an alias will be used as a
shorthand replacement in the code.

    echo()=bodyAs(String) + bodyAs(String)

Which allows using `echo()` in the jOOR language script such as:

    from("direct:hello")
        .transform(java("'Hello ' + echo()"))
        .log("You said ${body}");

The `echo()` alias will be replaced with its value resulting in a script
as:

    .transform(java("'Hello ' + bodyAs(String) + bodyAs(String)"))

You can configure a custom configuration location for the
`camel-joor.properties` file or reference to a bean in the registry:

    JavaLanguage joor = (JavaLanguage) context.resolveLanguage("java");
    java.setConfigResource("ref:MyJoorConfig");

And then register a bean in the registry with id `MyJoorConfig` that is
a String value with the content.

    String config = "....";
    camelContext.getRegistry().put("MyJoorConfig", config);

# Example

For example, to transform the message using jOOR language to the upper
case

    from("seda:orders")
      .transform().java("message.getBody(String.class).toUpperCase()")
      .to("seda:upper");

And in XML DSL:

    <route>
       <from uri="seda:orders"/>
       <transform>
         <java>message.getBody(String.class).toUpperCase()</joor>
       </transform>
       <to uri="seda:upper"/>
    </route>

## Multi statements

It is possible to include multiple statements. The code below shows an
example where the `user` header is retrieved in a first statement. And
then, in a second statement we return a value whether the user is `null`
or not.

    from("seda:orders")
      .transform().java("var user = message.getHeader(\"user\"); return user != null ? \"User: \" + user : \"No user exists\";")
      .to("seda:user");

Notice how we have to quote strings in strings, and that is annoying, so
instead we can use single quotes:

    from("seda:orders")
      .transform().java("var user = message.getHeader('user'); return user != null ? 'User: ' + user : 'No user exists';")
      .to("seda:user");

## Hot re-load

You can turn off pre-compilation for the Java language and then Camel
will recompile the script for each message. You can externalize the code
into a resource file, which will be reloaded on each message as shown:

    JavaLanguage java = (JavaLanguage) context.resolveLanguage("java");
    java.setPreCompile(false);
    
    from("jms:incoming")
        .transform().java("resource:file:src/main/resources/orders.java")
        .to("jms:orders");

Here the Java code is externalized into the file
`src/main/resources/orders.java` which allows you to edit this source
file while running the Camel application and try the changes with
hot-reloading.

In XML DSL it’s easier because you can turn off pre-compilation in the
`<java>` XML element:

    <route>
        <from uri="jms:incoming"/>
        <transform>
          <java preCompile="false">resource:file:src/main/resources/orders.java</java>
        </transform>
        <to uri="jms:orders"/>
    </route>

## Lambda-based AggregationStrategy

The Java language has special support for defining an
`org.apache.camel.AggregationStrategy` as a lambda expression. This is
useful when using EIP patterns that use aggregation such as the
Aggregator, Splitter, Recipient List, Enrich, and others.

To use this, then the Java language script must be in the following
syntax:

    (e1, e2) -> { }

Where `e1` and `e2` are the *old* Exchange and *new* Exchange from the
`aggregate` method in the `AggregationStrategy`. The returned value is
used as the aggregated message body, or use `null` to skip this.

The lambda syntax is representing a Java util
`BiFunction<Exchange, Exchange, Object>` type.

For example, to aggregate message bodies together, we can do this as
shown:

    (e1, e2) -> {
      String b1 = e1.getMessage().getBody(String.class);
      String b2 = e2.getMessage().getBody(String.class);
      return b1 + ',' + b2;
    }

## Limitations

The Java Camel language is only supported as a block of Java code that
gets compiled into a Java class with a single method. The code that you
can write is therefore limited to a number of Java statements.

The supported runtime is intended for Java standalone, Spring Boot,
Camel Quarkus and other microservices runtimes. It is not supported on
any kind of Java Application Server runtime.

Java does not support runtime compilation with Spring Boot using *fat
jar* packaging ([https://github.com/jOOQ/jOOR/issues/69](https://github.com/jOOQ/jOOR/issues/69)), it works with
exploded classpath.

# Dependencies

To use scripting languages in your camel routes, you need to add a
dependency on **camel-joor**.

If you use Maven you could add the following to your `pom.xml`,
substituting the version number for the latest and greatest release.

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-joor</artifactId>
      <version>x.x.x</version>
    </dependency>
