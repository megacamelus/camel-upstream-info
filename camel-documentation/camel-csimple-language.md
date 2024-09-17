# Csimple-language.md

**Since Camel 3.7**

The CSimple language is **compiled** [Simple](#simple-language.adoc)
language.

# Different between CSimple and Simple

The simple language is a dynamic expression language which is runtime
parsed into a set of Camel Expressions or Predicates.

The csimple language is parsed into regular Java source code and
compiled together with all the other source code, or compiled once
during bootstrap via the `camel-csimple-joor` module.

The simple language is generally very lightweight and fast, however for
some use-cases with dynamic method calls via OGNL paths, then the simple
language does runtime introspection and reflection calls. This has an
overhead on performance, and was one of the reasons why csimple was
created.

The csimple language requires to be typesafe and method calls via OGNL
paths requires to know the type during parsing. This means for csimple
languages expressions you would need to provide the class type in the
script, whereas simple introspects this at runtime.

In other words the simple language is using *duck typing* (if it looks
like a duck, and quacks like a duck, then it is a duck) and csimple is
using Java type (typesafety). If there is a type error then simple will
report this at runtime, and with csimple there will be a Java
compilation error.

## Additional CSimple functions

The csimple language includes some additional functions to support
common use-cases working with `Collection`, `Map` or array types. The
following functions *bodyAsIndex*, *headerAsIndex*, and
*exchangePropertyAsIndex* is used for these use-cases as they are typed.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Function</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>bodyAsIndex(<em>type</em>,
<em>index</em>)</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>To be used for collecting the body from
an existing <code>Collection</code>, <code>Map</code> or array (lookup
by the index) and then converting the body to the given type determined
by its classname. The converted body can be null.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>mandatoryBodyAsIndex(<em>type</em>,
<em>index</em>)</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>To be used for collecting the body from
an existing <code>Collection</code>, <code>Map</code> or array (lookup
by the index) and then converting the body to the given type determined
by its classname. Expects the body to be not null.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>headerAsIndex(<em>key</em>,
<em>type</em>, <em>index</em>)</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>To be used for collecting a header from
an existing <code>Collection</code>, <code>Map</code> or array (lookup
by the index) and then converting the header value to the given type
determined by its classname. The converted header can be null.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>exchangePropertyAsIndex(<em>key</em>,
<em>type</em>, <em>index</em>)</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>To be used for collecting an exchange
property from an existing <code>Collection</code>, <code>Map</code> or
array (lookup by the index) and then converting the exchange property to
the given type determined by its classname. The converted exchange
property can be null.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>variableAsIndex(<em>key</em>,
<em>type</em>, <em>index</em>)</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>To be used for collecting a variable
from an existing <code>Collection</code>, <code>Map</code> or array
(lookup by the index) and then converting the variable to the given type
determined by its classname. The converted variable can be
null.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>messageAs(<em>type</em>)</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Converts the message to the given type
determined by its classname. The converted message can be null.</p></td>
</tr>
</tbody>
</table>

For example given the following simple expression:

Hello ${body\[0\].name}

This script has no type information, and the simple language will
resolve this at runtime, by introspecting the message body and if it’s a
collection based then lookup the first element, and then invoke a method
named `getName` via reflection.

In csimple (compiled) we want to pre compile this and therefore the end
user must provide type information with the *bodyAsIndex* function:

Hello ${bodyAsIndex(com.foo.MyUser, 0).name}

# Compilation

The csimple language is parsed into regular Java source code and
compiled together with all the other source code, or it can be compiled
once during bootstrap via the `camel-csimple-joor` module.

There are two ways to compile csimple

-   using the `camel-csimple-maven-plugin` generating source code at
    built time.

-   using `camel-csimple-joor` which does runtime in-memory compilation
    during bootstrap of Camel.

## Using camel-csimple-maven-plugin

The `camel-csimple-maven-plugin` Maven plugin is used for discovering
all the csimple scripts from the source code, and then automatic
generate source code in the `src/generated/java` folder, which then gets
compiled together with all the other sources.

The maven plugin will do source code scanning of `.java` and `.xml`
files (Java and XML DSL). The scanner limits to detect certain code
patterns, and it may miss discovering some csimple scripts if they are
being used in unusual/rare ways.

The runtime compilation using `camel-csimple-joor` does not have this
limitation.

The benefit is all the csimple scripts will be compiled using the
regular Java compiler and therefore everything is included out of the
box as `.class` files in the application JAR file, and no additional
dependencies is required at runtime.

To use `camel-csimple-maven-plugin` you need to add it to your `pom.xml`
file as shown:

    <plugins>
        <!-- generate source code for csimple languages -->
        <plugin>
            <groupId>org.apache.camel</groupId>
            <artifactId>camel-csimple-maven-plugin</artifactId>
            <version>${camel.version}</version>
            <executions>
                <execution>
                    <id>generate</id>
                    <goals>
                        <goal>generate</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
        <!-- include source code generated to maven sources paths -->
        <plugin>
            <groupId>org.codehaus.mojo</groupId>
            <artifactId>build-helper-maven-plugin</artifactId>
            <version>3.1.0</version>
            <executions>
                <execution>
                    <phase>generate-sources</phase>
                    <goals>
                        <goal>add-source</goal>
                        <goal>add-resource</goal>
                    </goals>
                    <configuration>
                        <sources>
                            <source>src/generated/java</source>
                        </sources>
                        <resources>
                            <resource>
                                <directory>src/generated/resources</directory>
                            </resource>
                        </resources>
                    </configuration>
                </execution>
            </executions>
        </plugin>
    </plugins>

And then you must also add the `build-helper-maven-plugin` Maven plugin
to include `src/generated` to the list of source folders for the Java
compiler, to ensure the generated source code is compiled and included
in the application JAR file.

See the `camel-example-csimple` example at [Camel
Examples](https://github.com/apache/camel-examples) which uses the maven
plugin.

## Using camel-csimple-joor

The jOOR library integrates with the Java compiler and performs runtime
compilation of Java code.

The supported runtime when using `camel-simple-joor` is intended for
Java standalone, Spring Boot, Camel Quarkus and other microservices
runtimes. It is not supported on any kind of Java Application Server
runtime.

jOOR does not support runtime compilation with Spring Boot using *fat
jar* packaging ([https://github.com/jOOQ/jOOR/issues/69](https://github.com/jOOQ/jOOR/issues/69)), it works with
exploded classpath.

To use `camel-simple-joor` you simply just add it as dependency to the
classpath:

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-csimple-joor</artifactId>
      <version>x.x.x</version>
    </dependency>

There is no need for adding Maven plugins to the `pom.xml` file.

See the `camel-example-csimple-joor` example at [Camel
Examples](https://github.com/apache/camel-examples) which uses the jOOR
compiler.

# CSimple Language options

# Limitations

Currently, the csimple language does **not** support:

-   nested functions (aka functions inside functions)

-   the *null safe* operator (`?`).

For example the following scripts cannot compile:

        Hello ${bean:greeter(${body}, ${header.counter})}
    
        ${bodyAs(MyUser)?.address?.zip} > 10000

# Auto imports

The csimple language will automatically import from:

    import java.util.*;
    import java.util.concurrent.*;
    import java.util.stream.*;
    import org.apache.camel.*;
    import org.apache.camel.util.*;

# Configuration file

You can configure the csimple language in the `camel-csimple.properties`
file which is loaded from the root classpath.

For example you can add additional imports in the
`camel-csimple.properties` file by adding:

    import com.foo.MyUser;
    import com.bar.*;
    import static com.foo.MyHelper.*;

You can also add aliases (key=value) where an alias will be used as a
shorthand replacement in the code.

    echo()=${bodyAs(String)} ${bodyAs(String)}

Which allows to use *echo()* in the csimple language script such as:

    from("direct:hello")
        .transform(csimple("Hello echo()"))
        .log("You said ${body}");

The *echo()* alias will be replaced with its value resulting in a script
as:

        .transform(csimple("Hello ${bodyAs(String)} ${bodyAs(String)}"))

# See Also

See the [Simple](#simple-language.adoc) language as csimple has the same
set of functions as simple language.
