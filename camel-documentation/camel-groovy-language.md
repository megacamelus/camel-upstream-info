# Groovy-language.md

**Since Camel 1.3**

Camel has support for using [Groovy](http://www.groovy-lang.org/).

For example, you can use Groovy in a
[Predicate](#manual::predicate.adoc) with the [Message
Filter](#eips:filter-eip.adoc) EIP.

    groovy("someGroovyExpression")

# Groovy Options

# Usage

## Groovy Context

Camel will provide exchange information in the Groovy context (just a
`Map`). The `Exchange` is transferred as:

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">key</th>
<th style="text-align: left;">value</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>body</code></p></td>
<td style="text-align: left;"><p>The message body.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>header</code></p></td>
<td style="text-align: left;"><p>The headers of the message.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>headers</code></p></td>
<td style="text-align: left;"><p>The headers of the message.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>variable</code></p></td>
<td style="text-align: left;"><p>The exchange variables</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>variables</code></p></td>
<td style="text-align: left;"><p>The exchange variables</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>exchangeProperty</code></p></td>
<td style="text-align: left;"><p>The exchange properties.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>exchangeProperties</code></p></td>
<td style="text-align: left;"><p>The exchange properties.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>exchange</code></p></td>
<td style="text-align: left;"><p>The <code>Exchange</code>
itself.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>camelContext</code></p></td>
<td style="text-align: left;"><p>The Camel Context.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>exception</code></p></td>
<td style="text-align: left;"><p>If the exchange failed then this is the
caused exception.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>request</code></p></td>
<td style="text-align: left;"><p>The message.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>response</code></p></td>
<td style="text-align: left;"><p><strong>Deprecated</strong> The Out
message (only for InOut message exchange pattern).</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>log</code></p></td>
<td style="text-align: left;"><p>Can be used for logging purposes such
as <code>log.info('Using body: {}', body)</code>.</p></td>
</tr>
</tbody>
</table>

## How to get the result from multiple statements script

As the Groovy script engine evaluate method just return a `Null` if it
runs a multiple statements script. Camel now looks up the value of
script result by using the key of `result` from the value set. If you
have multiple statements scripts, you need to make sure you set the
value of result variable as the script return value.

    bar = "baz"
    // some other statements ...
    // camel take the result value as the script evaluation result
    result = body * 2 + 1

## Customizing Groovy Shell

For very special use-cases you may need to use a custom `GroovyShell`
instance in your Groovy expressions. To provide the custom
`GroovyShell`, add an implementation of the
`org.apache.camel.language.groovy.GroovyShellFactory` SPI interface to
the Camel registry.

    public class CustomGroovyShellFactory implements GroovyShellFactory {
    
      public GroovyShell createGroovyShell(Exchange exchange) {
        ImportCustomizer importCustomizer = new ImportCustomizer();
        importCustomizer.addStaticStars("com.example.Utils");
        CompilerConfiguration configuration = new CompilerConfiguration();
        configuration.addCompilationCustomizers(importCustomizer);
        return new GroovyShell(configuration);
      }
    
    }

Camel will then use your custom GroovyShell instance (containing your
custom static imports), instead of the default one.

## Loading script from external resource

You can externalize the script and have Camel load it from a resource
such as `"classpath:"`, `"file:"`, or `"http:"`. This is done using the
following syntax: `"resource:scheme:location"`, e.g., to refer to a file
on the classpath you can do:

    .setHeader("myHeader").groovy("resource:classpath:mygroovy.groovy")

## Dependencies

To use scripting languages in your camel routes, you need to add a
dependency on **camel-groovy**.

If you use Maven you could just add the following to your `pom.xml`,
substituting the version number for the latest and greatest release (see
the download page for the latest versions).

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-groovy</artifactId>
      <version>x.x.x</version>
    </dependency>

# Examples

In the example below, we use a groovy script as predicate in the message
filter, to determine if any line items are over $100:

Java  
from("queue:foo")
.filter(groovy("body.lineItems.any { i -\> i.value \> 100 }"))
.to("queue:bar")

XML DSL  
<route>  
<from uri="queue:foo"/>  
<filter>  
<groovy>body.lineItems.any { i -\> i.value \> 100 }</groovy>  
<to uri="queue:bar"/>  
</filter>  
</route>
