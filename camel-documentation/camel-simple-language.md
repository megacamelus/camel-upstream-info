# Simple-language.md

**Since Camel 1.1**

The Simple Expression Language was a really simple language when it was
created, but has since grown more powerful. It is primarily intended for
being a very small and simple language for evaluating `Expression` or
`Predicate` without requiring any new dependencies or knowledge of other
scripting languages such as Groovy.

The simple language is designed with intent to cover almost all the
common use cases when little need for scripting in your Camel routes.

However, for much more complex use cases, then a more powerful language
is recommended such as:

-   [Groovy](#groovy-language.adoc)

-   [MVEL](#mvel-language.adoc)

-   [OGNL](#ognl-language.adoc)

The simple language requires `camel-bean` JAR as classpath dependency if
the simple language uses OGNL expressions, such as calling a method
named `myMethod` on the message body: `${body.myMethod()}`. At runtime
the simple language will then us its built-in OGNL support which
requires the `camel-bean` component.

The simple language uses `${body}` placeholders for complex expressions
or functions.

See also the [CSimple](#csimple-language.adoc) language which is
**compiled**.

**Alternative syntax**

You can also use the alternative syntax which uses `$simple{ }` as
placeholders. This can be used in situations to avoid clashes when
using, for example, Spring property placeholder together with Camel.

# Simple Language options

# Variables

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Variable</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>camelId</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>the CamelContext name</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p>camelContext.<strong>OGNL</strong></p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>the CamelContext invoked using a Camel
OGNL expression.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>exchange</p></td>
<td style="text-align: left;"><p>Exchange</p></td>
<td style="text-align: left;"><p>the Exchange</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>exchange.<strong>OGNL</strong></p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>the Exchange invoked using a Camel OGNL
expression.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>exchangeId</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>the exchange id</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>id</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>the message id</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>messageTimestamp</p></td>
<td style="text-align: left;"><p>long</p></td>
<td style="text-align: left;"><p>the message timestamp (millis since
epoc) that this message originates from. Some systems like JMS, Kafka,
AWS have a timestamp on the event/message that Camel received. This
method returns the timestamp if a timestamp exists. The message
timestamp and exchange created are different. An exchange always has a
created timestamp which is the local timestamp when Camel created the
exchange. The message timestamp is only available in some Camel
components when the consumer is able to extract the timestamp from the
source event. If the message has no timestamp, then 0 is
returned.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>body</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>the body</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>body.<strong>OGNL</strong></p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>the body invoked using a Camel OGNL
expression.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>bodyAs(<em>type</em>)</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Converts the body to the given type
determined by its classname. The converted body can be null.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p>bodyAs(<em>type</em>).<strong>OGNL</strong></p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>Converts the body to the given type
determined by its classname and then invoke methods using a Camel OGNL
expression. The converted body can be null.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>bodyOneLine</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Converts the body to a String and
removes all line-breaks, so the string is in one line.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>prettyBody</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Converts the body to a String, and
attempts to pretty print if JSon or XML; otherwise the body is returned
as the String value.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>originalBody</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>The original incoming body (only
available if allowUseOriginalMessage=true).</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>mandatoryBodyAs(<em>type</em>)</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Converts the body to the given type
determined by its classname, and expects the body to be not
null.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p>mandatoryBodyAs(<em>type</em>).<strong>OGNL</strong></p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>Converts the body to the given type
determined by its classname and then invoke methods using a Camel OGNL
expression.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>header.foo</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>refer to the foo header</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>header[foo]</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>refer to the foo header</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>headers.foo</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>refer to the foo header</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>headers:foo</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>refer to the foo header</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>headers[foo]</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>refer to the foo header</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>header.foo[bar]</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>regard foo header as a map and perform
lookup on the map with bar as the key</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p>header.foo.<strong>OGNL</strong></p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>refer to the foo header and invoke its
value using a Camel OGNL expression.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p>headerAs(<em>key</em>,<em>type</em>)</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>converts the header to the given type
determined by its classname</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>headers</p></td>
<td style="text-align: left;"><p>Map</p></td>
<td style="text-align: left;"><p>refer to the headers</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>variable.foo</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>refer to the foo variable</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>variable[foo]</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>refer to the foo variable</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p>variable.foo.<strong>OGNL</strong></p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>refer to the foo variable and invoke
its value using a Camel OGNL expression.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p>variableAs(<em>key</em>,<em>type</em>)</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>converts the variable to the given type
determined by its classname</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>variables</p></td>
<td style="text-align: left;"><p>Map</p></td>
<td style="text-align: left;"><p>refer to the variables</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>exchangeProperty.foo</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>refer to the foo property on the
exchange</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>exchangeProperty[foo]</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>refer to the foo property on the
exchange</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p>exchangeProperty.foo.<strong>OGNL</strong></p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>refer to the foo property on the
exchange and invoke its value using a Camel OGNL expression.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>messageAs(<em>type</em>)</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>Converts the message to the given type
determined by its classname. The converted message can be null.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p>messageAs(<em>type</em>).<strong>OGNL</strong></p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>Converts the message to the given type
determined by its classname and then invoke methods using a Camel OGNL
expression. The converted message can be null.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>sys.foo</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>refer to the JVM system
property</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>sysenv.foo</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>refer to the system environment
variable</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>env.foo</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>refer to the system environment
variable</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>exception</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>refer to the exception object on the
exchange, is <strong>null</strong> if no exception set on exchange. Will
fall back and grab caught exceptions
(<code>Exchange.EXCEPTION_CAUGHT</code>) if the Exchange has
any.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p>exception.<strong>OGNL</strong></p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>refer to the exchange exception invoked
using a Camel OGNL expression object</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>exception.message</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>refer to the
<code>exception.message</code> on the exchange, is <strong>null</strong>
if no exception set on exchange. Will fall back and grab caught
exceptions (<code>Exchange.EXCEPTION_CAUGHT</code>) if the Exchange has
any.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>exception.stacktrace</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>refer to the exception.stracktrace on
the exchange, is <strong>null</strong> if no exception set on exchange.
Will fall back and grab caught exceptions
(<code>Exchange.EXCEPTION_CAUGHT</code>) if the Exchange has
any.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>date:_command_</p></td>
<td style="text-align: left;"><p>Date</p></td>
<td style="text-align: left;"><p>evaluates to a Date object. Supported
commands are: <code>now</code> for current timestamp,
<code>exchangeCreated</code> for the timestamp when the current exchange
was created, <code>header.xxx</code> to use the Long/Date object in the
header with the key xxx. <code>variable.xxx</code> to use the Long/Date
in the variable with the key xxx. <code>exchangeProperty.xxx</code> to
use the Long/Date object in the exchange property with the key xxx.
<code>file</code> for the last modified timestamp of the file (available
with a File consumer). Command accepts offsets such as:
<code>now-24h</code> or <code>header.xxx+1h</code> or even
<code>now+1h30m-100</code>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>date:_command:pattern_</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Date formatting using
<code>java.text.SimpleDateFormat</code> patterns.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p>date-with-timezone:_command:timezone:pattern_</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Date formatting using
<code>java.text.SimpleDateFormat</code> timezones and patterns.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>bean:_bean expression_</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>Invoking a bean expression using the <a
href="#components::bean-component.adoc">Bean</a> language. Specifying a
method name, you must use dot as the separator. We also support the
?method=methodname syntax that is used by the <a
href="#components::bean-component.adoc">Bean</a> component. Camel will
by default lookup a bean by the given name. However, if you need to
refer to a bean class (such as calling a static method), then you can
prefix with the type, such as
<code>bean:type:fqnClassName</code>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>properties:key:default</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Lookup a property with the given key.
If the key does not exist nor has a value, then an optional default
value can be specified.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>propertiesExist:key</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"><p>Checks whether a property placeholder
with the given key exists or not. The result can be negated by prefixing
the key with <code>!</code>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>fromRouteId</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Returns the original route id where
this exchange was created.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>routeId</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Returns the route id of the current
route the Exchange is being routed.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>routeGroup</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Returns the route group of the current
route the Exchange is being routed. Not all routes have a group
assigned, so this may be null.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>stepId</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Returns the id of the current step the
Exchange is being routed.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>threadId</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Returns the id of the current thread.
Can be used for logging.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>threadName</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Returns the name of the current thread.
Can be used for logging.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>hostname</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Returns the local hostname (may be
empty if not possible to resolve).</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>ref:xxx</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>To look up a bean from the Registry
with the given id.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>type:name.field</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>To refer to a type or field by its FQN
name. To refer to a field, you can append .FIELD_NAME. For example, you
can refer to the constant field from Exchange as:
<code>org.apache.camel.Exchange.FILE_NAME</code></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>empty(type)</p></td>
<td style="text-align: left;"><p>depends on parameter</p></td>
<td style="text-align: left;"><p>Creates a new empty object of the type
given as parameter. The type-parameter-Strings are
case-insensitive.<br />
</p>
<p><code>string</code> → empty String<br />
<code>list</code> → empty ArrayList<br />
<code>map</code> → empty HashMap<br />
</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>null</p></td>
<td style="text-align: left;"><p>null</p></td>
<td style="text-align: left;"><p>represents a
<strong>null</strong></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>random(value)</p></td>
<td style="text-align: left;"><p>Integer</p></td>
<td style="text-align: left;"><p>returns a random Integer between 0
(included) and <em>value</em> (excluded)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>random(min,max)</p></td>
<td style="text-align: left;"><p>Integer</p></td>
<td style="text-align: left;"><p>returns a random Integer between
<em>min</em> (included) and <em>max</em> (excluded)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>replace(from,to)</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>replace all the string values in the
message body. To make it easier to replace single and double quotes,
then you can use XML escaped values <code>\&amp;quot;</code> as double
quote, <code>\&amp;apos;</code> as single quote, and
<code>\&amp;empty;</code> as empty value.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>replace(from,to,exp)</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>replace all the string values in the
given expression. To make it easier to replace single and double quotes,
then you can use XML escaped values <code>\&amp;quot;</code> as double
quote, <code>\&amp;apos;</code> as single quote, and
<code>\&amp;empty;</code> as empty value.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>substring(num1)</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>returns a substring of the message
body. If the number is positive, then the returned string is clipped
from the beginning. If the number is negative, then the returned string
is clipped from the ending.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>substring(num1,num2)</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>returns a substring of the message
body. If the number is positive, then the returned string is clipped
from the beginning. If the number is negative, then the returned string
is clipped from the ending.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>substring(num1,num2,exp)</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>returns a substring of the given
expression. If the number is positive, then the returned string is
clipped from the beginning. If the number is negative, then the returned
string is clipped from the ending.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>collate(group)</p></td>
<td style="text-align: left;"><p>List</p></td>
<td style="text-align: left;"><p>The collate function iterates the
message body and groups the data into sub lists of specified size. This
can be used with the Splitter EIP to split a message body and
group/batch the split sub message into a group of N sub lists. This
method works similar to the collate method in Groovy.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>skip(number)</p></td>
<td style="text-align: left;"><p>Iterator</p></td>
<td style="text-align: left;"><p>The skip function iterates the message
body and skips the first number of items. This can be used with the
Splitter EIP to split a message body and skip the first N number of
items.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>join(separator,prefix,exp)</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>The join function iterates the message
body (by default) and joins the data into a string. The separator is by
default a comma. The prefix is optional.</p>
<p>The join uses the message body as source by default. It is possible
to refer to another source (simple language) such as a header via the
exp parameter. For example
<code>join('&amp;','id=','${header.ids}')</code>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>messageHistory</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>The message history of the current
exchange - how it has been routed. This is similar to the route
stack-trace message history the error handler logs in case of an
unhandled exception.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>messageHistory(false)</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>As messageHistory but without the
exchange details (only includes the route stack-trace). This can be used
if you do not want to log sensitive data from the message
itself.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>uuid(type)</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Returns a UUID using the Camel
<code>UuidGenerator</code>. You can choose between <code>default</code>,
<code>classic</code>, <code>short</code> and <code>simple</code> as the
type. If no type is given, the default is used. It is also possible to
use a custom <code>UuidGenerator</code> and bind the bean to the <a
href="#manual::registry.adoc">Registry</a> with an id. For example
<code>${uuid(myGenerator)}</code> where the ID is
<em>myGenerator</em>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>hash(exp,algorithm)</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Returns a hashed value (string in hex
decimal) using JDK MessageDigest. The algorithm can be SHA-256 (default)
or SHA3-256.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>jsonpath(exp)</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>When working with JSon data, then this
allows using the JsonPath language, for example, to extract data from
the message body (in JSon format). This requires having camel-jsonpath
JAR on the classpath.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>jsonpath(input,exp)</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>When working with JSon data, then this
allows using the JsonPath language, for example, to extract data from
the message body (in JSon format). This requires having camel-jsonpath
JAR on the classpath. For <em>input</em>, you can choose
<code>header:key</code>, <code>exchangeProperty:key</code> or
<code>variable:key</code> to use as input for the JSon payload instead
of the message body.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>jq(exp)</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>When working with JSon data, then this
allows using the JQ language, for example, to extract data from the
message body (in JSon format). This requires having camel-jq JAR on the
classpath.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>jq(input,exp)</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>When working with JSon data, then this
allows using the JQ language, for example, to extract data from the
message body (in JSon format). This requires having camel-jq JAR on the
classpath. For <em>input</em>, you can choose <code>header:key</code>,
<code>exchangeProperty:key</code> or <code>variable:key</code> to use as
input for the JSon payload instead of the message body.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>xpath(exp)</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>When working with XML data, then this
allows using the XPath language, for example, to extract data from the
message body (in XML format). This requires having camel-xpath JAR on
the classpath.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>xpath(input,exp)</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>When working with XML data, then this
allows using the XPath language, for example, to extract data from the
message body (in XML format). This requires having camel-xpath JAR on
the classpath. For <em>input</em> you can choose
<code>header:key</code>, <code>exchangeProperty:key</code> or
<code>variable:key</code> to use as input for the JSon payload instead
of the message body.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>pretty(exp)</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Converts the inlined expression to a
String, and attempts to pretty print if JSon or XML, otherwise the
expression is returned as the String value.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>iif(predicate, trueExp,
falseExp)</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>Evaluates the <code>predicate</code>
expression and returns the value of <code>trueExp</code> if the
predicate is true, otherwise the value of <code>falseExp</code> is
returned. This function is similar to the ternary operator in
Java.</p></td>
</tr>
</tbody>
</table>

# OGNL expression support

When using **OGNL** then `camel-bean` JAR is required to be on the
classpath.

Camel’s OGNL support is for invoking methods only. You cannot access
fields. Camel support accessing the length field of Java arrays.

The [Simple](#simple-language.adoc) and [Bean](#simple-language.adoc)
languages now support a Camel OGNL notation for invoking beans in a
chain like fashion. Suppose the Message IN body contains a POJO which
has a `getAddress()` method.

Then you can use Camel OGNL notation to access the address object:

    simple("${body.address}")
    simple("${body.address.street}")
    simple("${body.address.zip}")

Camel understands the shorthand names for getters, but you can invoke
any method or use the real name such as:

    simple("${body.address}")
    simple("${body.getAddress.getStreet}")
    simple("${body.address.getZip}")
    simple("${body.doSomething}")

You can also use the null safe operator (`?.`) to avoid NPE if, for
example, the body does NOT have an address

    simple("${body?.address?.street}")

It is also possible to index in `Map` or `List` types, so you can do:

    simple("${body[foo].name}")

To assume the body is `Map` based and look up the value with `foo` as
key, and invoke the `getName` method on that value.

If the key has space, then you **must** enclose the key with quotes, for
example, *foo bar*:

    simple("${body['foo bar'].name}")

You can access the `Map` or `List` objects directly using their key name
(with or without dots) :

    simple("${body[foo]}")
    simple("${body[this.is.foo]}")

Suppose there was no value with the key `foo` then you can use the null
safe operator to avoid the NPE as shown:

    simple("${body[foo]?.name}")

You can also access `List` types, for example, to get lines from the
address you can do:

    simple("${body.address.lines[0]}")
    simple("${body.address.lines[1]}")
    simple("${body.address.lines[2]}")

There is a special `last` keyword which can be used to get the last
value from a list.

    simple("${body.address.lines[last]}")

And to get the 2nd last you can subtract a number, so we can use
`last-1` to indicate this:

    simple("${body.address.lines[last-1]}")

And the third last is, of course:

    simple("${body.address.lines[last-2]}")

And you can call the size method on the list with

    simple("${body.address.lines.size}")

Camel supports the length field for Java arrays as well, e.g.:

    String[] lines = new String[]{"foo", "bar", "cat"};
    exchange.getIn().setBody(lines);
    
    simple("There are ${body.length} lines")

And yes, you can combine this with the operator support as shown below:

    simple("${body.address.zip} > 1000")

# Operator support

The parser is limited to only support a single operator.

To enable it, the left value must be enclosed in `${ }`. The syntax is:

    ${leftValue} OP rightValue

Where the `rightValue` can be a String literal enclosed in `' '`,
`null`, a constant value or another expression enclosed in `${ }`.

There **must** be spaces around the operator.

Camel will automatically type convert the rightValue type to the
leftValue type, so it is able to e.g., convert a string into a numeric,
so you can use `>` comparison for numeric values.

The following operators are supported:

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Operator</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>==</p></td>
<td style="text-align: left;"><p>equals</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>=~</p></td>
<td style="text-align: left;"><p>equals ignore case (will ignore case
when comparing String values)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>&gt;</p></td>
<td style="text-align: left;"><p>greater than</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>&gt;=</p></td>
<td style="text-align: left;"><p>greater than or equals</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>&lt;</p></td>
<td style="text-align: left;"><p>less than</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>⇐</code></p></td>
<td style="text-align: left;"><p>less than or equals</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>!=</p></td>
<td style="text-align: left;"><p>not equals</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>!=~</p></td>
<td style="text-align: left;"><p>not equals ignore case (will ignore
case when comparing String values)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>contains</p></td>
<td style="text-align: left;"><p>For testing if contains in a
string-based value</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>!contains</p></td>
<td style="text-align: left;"><p>For testing if it does not contain in a
string-based value</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>~~</p></td>
<td style="text-align: left;"><p>For testing if contains by ignoring
case sensitivity in a string-based value</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>!~~</p></td>
<td style="text-align: left;"><p>For testing if it does not contain by
ignoring case sensitivity in a string-based value</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>regex</p></td>
<td style="text-align: left;"><p>For matching against a given regular
expression pattern defined as a String value</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>!regex</p></td>
<td style="text-align: left;"><p>For not matching against a given
regular expression pattern defined as a String value</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>in</p></td>
<td style="text-align: left;"><p>For matching if in a set of values,
each element must be separated by comma. If you want to include an empty
value, then it must be defined using double comma, e.g.
<code>',, bronze,silver,gold'</code>, which is a set of four values with
an empty value and then the three medals.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>!in</p></td>
<td style="text-align: left;"><p>For matching if not in a set of values,
each element must be separated by comma. If you want to include an empty
value, then it must be defined using double comma, e.g.
<code>',,bronze,silver,gold'</code>, which is a set of four values with
an empty value and then the three medals.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>is</p></td>
<td style="text-align: left;"><p>For matching if the left-hand side type
is an instance of the value.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>!is</p></td>
<td style="text-align: left;"><p>For matching if the left-hand side type
is not an instance of the value.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>range</p></td>
<td style="text-align: left;"><p>For matching if the left-hand side is
within a range of values defined as numbers:
<code>from..to</code>..</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>!range</p></td>
<td style="text-align: left;"><p>For matching if the left-hand side is
not within a range of values defined as numbers: <code>from..to</code>.
.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>startsWith</p></td>
<td style="text-align: left;"><p>For testing if the left-hand side
string starts with the right-hand string.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>starts with</p></td>
<td style="text-align: left;"><p>Same as the startsWith
operator.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>endsWith</p></td>
<td style="text-align: left;"><p>For testing if the left-hand side
string ends with the right-hand string.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>ends with</p></td>
<td style="text-align: left;"><p>Same as the endsWith operator.</p></td>
</tr>
</tbody>
</table>

And the following unary operators can be used:

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Operator</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>++</p></td>
<td style="text-align: left;"><p>To increment a number by one. The
left-hand side must be a function, otherwise parsed as literal.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>— </p></td>
<td style="text-align: left;"><p>To decrement a number by one. The
left-hand side must be a function, otherwise parsed as literal.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>\n</p></td>
<td style="text-align: left;"><p>To use newline character.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>\t</p></td>
<td style="text-align: left;"><p>To use tab character.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>\r</p></td>
<td style="text-align: left;"><p>To use carriage return
character.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>}</p></td>
<td style="text-align: left;"><p>To use the <code>}</code> character as
text. This may be needed when building a JSon structure with the simple
language.</p></td>
</tr>
</tbody>
</table>

And the following logical operators can be used to group expressions:

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Operator</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>&amp;&amp;</p></td>
<td style="text-align: left;"><p>The logical and operator is used to
group two expressions.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>||</p></td>
<td style="text-align: left;"><p>The logical or operator is used to
group two expressions.</p></td>
</tr>
</tbody>
</table>

The syntax for AND is:

    ${leftValue} OP rightValue && ${leftValue} OP rightValue

And the syntax for OR is:

    ${leftValue} OP rightValue || ${leftValue} OP rightValue

Some examples:

    // exact equals match
    simple("${header.foo} == 'foo'")
    
    // ignore case when comparing, so if the header has value FOO, this will match
    simple("${header.foo} =~ 'foo'")
    
    // here Camel will type convert '100' into the type of header.bar and if it is an Integer '100' will also be converter to an Integer
    simple("${header.bar} == '100'")
    
    simple("${header.bar} == 100")
    
    // 100 will be converter to the type of header.bar, so we can do > comparison
    simple("${header.bar} > 100")
    
    // if the value of header.bar was 100, value returned will be 101. header.bar itself will not be changed.
    simple("${header.bar}++")

## Comparing with different types

When you compare with different types such as String and int, then you
have to take a bit of care. Camel will use the type from the left-hand
side as first priority. And fallback to the right-hand side type if both
values couldn’t be compared based on that type.  
This means you can flip the values to enforce a specific type. Suppose
the bar value above is a String. Then you can flip the equation:

    simple("100 < ${header.bar}")

which then ensures the int type is used as first priority.

This may change in the future if the Camel team improves the binary
comparison operations to prefer numeric types to String-based. It’s most
often the String type which causes problems when comparing with numbers.

    // testing for null
    simple("${header.baz} == null")
    
    // testing for not null
    simple("${header.baz} != null")

And a bit more advanced example where the right value is another
expression

    simple("${header.date} == ${date:now:yyyyMMdd}")
    
    simple("${header.type} == ${bean:orderService?method=getOrderType}")

And an example with `contains`, testing if the title contains the word
Camel

    simple("${header.title} contains 'Camel'")

And an example with regex, testing if the number header is a 4-digit
value:

    simple("${header.number} regex '\\d{4}'")

And finally an example if the header equals any of the values in the
list. Each element must be separated by comma, and no space around.  
This also works for numbers etc., as Camel will convert each element
into the type of the left-hand side.

    simple("${header.type} in 'gold,silver'")

And for all the last 3, we also support the negate test using not:

    simple("${header.type} !in 'gold,silver'")

And you can test if the type is a certain instance, e.g., for instance a
String

    simple("${header.type} is 'java.lang.String'")

We have added a shorthand for all `java.lang` types, so you can write it
as:

    simple("${header.type} is 'String'")

Ranges are also supported. The range interval requires numbers and both
from and end are inclusive. For instance, to test whether a value is
between 100 and 199:

    simple("${header.number} range 100..199")

Notice we use `..` in the range without spaces. It is based on the same
syntax as Groovy.

    simple("${header.number} range '100..199'")

As the XML DSL does not have all the power as the Java DSL with all its
various builder methods, you have to resort to using some other
languages for testing with simple operators. Now you can do this with
the simple language. In the sample below, we want to test it if the
header is a widget order:

    <from uri="seda:orders">
       <filter>
           <simple>${header.type} == 'widget'</simple>
           <to uri="bean:orderService?method=handleWidget"/>
       </filter>
    </from>

## Using and / or

If you have two expressions you can combine them with the `&&` or `||`
operator.

For instance:

    simple("${header.title} contains 'Camel' && ${header.type'} == 'gold'")

And of course the `||` is also supported. The sample would be:

    simple("${header.title} contains 'Camel' || ${header.type'} == 'gold'")

# Examples

In the XML DSL sample below, we filter based on a header value:

    <from uri="seda:orders">
       <filter>
           <simple>${header.foo}</simple>
           <to uri="mock:fooOrders"/>
       </filter>
    </from>

The Simple language can be used for the predicate test above in the
Message Filter pattern, where we test if the in message has a `foo`
header (a header with the key `foo` exists). If the expression evaluates
to `*true*`, then the message is routed to the `mock:fooOrders`
endpoint, otherwise the message is dropped.

The same example in Java DSL:

    from("seda:orders")
        .filter().simple("${header.foo}")
            .to("seda:fooOrders");

You can also use the simple language for simple text concatenations such
as:

    from("direct:hello")
        .transform().simple("Hello ${header.user} how are you?")
        .to("mock:reply");

Notice that we must use `${ }` placeholders in the expression now to
allow Camel to parse it correctly.

And this sample uses the date command to output current date.

    from("direct:hello")
        .transform().simple("The today is ${date:now:yyyyMMdd} and it is a great day.")
        .to("mock:reply");

And in the sample below, we invoke the bean language to invoke a method
on a bean to be included in the returned string:

    from("direct:order")
        .transform().simple("OrderId: ${bean:orderIdGenerator}")
        .to("mock:reply");

Where `orderIdGenerator` is the id of the bean registered in the
Registry. If using Spring, then it is the Spring bean id.

If we want to declare which method to invoke on the order id generator
bean we must prepend `.method name` such as below where we invoke the
`generateId` method.

    from("direct:order")
        .transform().simple("OrderId: ${bean:orderIdGenerator.generateId}")
        .to("mock:reply");

We can use the `?method=methodname` option that we are familiar with the
[Bean](#components::bean-component.adoc) component itself:

    from("direct:order")
        .transform().simple("OrderId: ${bean:orderIdGenerator?method=generateId}")
        .to("mock:reply");

You can also convert the body to a given type, for example, to ensure
that it is a String you can do:

    <transform>
      <simple>Hello ${bodyAs(String)} how are you?</simple>
    </transform>

There are a few types which have a shorthand notation, so we can use
`String` instead of `java.lang.String`. These are:
`byte[], String, Integer, Long`. All other types must use their FQN
name, e.g. `org.w3c.dom.Document`.

It is also possible to look up a value from a header `Map`:

    <transform>
      <simple>The gold value is ${header.type[gold]}</simple>
    </transform>

In the code above we look up the header with name `type` and regard it
as a `java.util.Map` and we then look up with the key `gold` and return
the value. If the header is not convertible to Map, an exception is
thrown. If the header with name `type` does not exist `null` is
returned.

You can nest functions, such as shown below:

    <setHeader name="myHeader">
      <simple>${properties:${header.someKey}}</simple>
    </setHeader>

## Substring

You can use the `substring` function to more easily clip the message
body. For example if the message body contains the following 10 letters
`ABCDEFGHIJ` then:

    <setBody>
      <simple>${substring(3)}</simple>
    </setBody>

Then the message body after the substring will be `DEFGHIJ`. If you want
to clip from the end instead, then use negative values such as
`substring(-3)`.

You can also clip from both ends at the same time such as
`substring(1,-1)` that will clip the first and last character in the
String.

If the number is higher than the length of the message body, then an
empty string is returned, for example `substring(99)`.

Instead of the message body then a simple expression can be nested as
input, for example, using a variable, as shown below:

    <setBody>
      <simple>${substring(1,-1,${variable.foo})}</simple>
    </setBody>

## Replacing double and single quotes

You can use the `replace` function to more easily replace all single or
double quotes in the message body, using the XML escape syntax. This
avoids to fiddle with enclosing a double quote or single quotes with
outer quotes, that can get confusing to be correct as you may need to
escape the quotes as well. So instead you can use the XML escape syntax
where double quote is `\&quot;` and single quote is `\&apos;` (yeah that
is the name).

For example, to replace all double quotes with single quotes:

    from("direct:order")
      .transform().simple("${replace(&quot; , &apos;)}")
      .to("mock:reply");

And to replace all single quotes with double quotes:

    <setBody>
      <simple>${replace(&apos; , &quot;)}</simple>
    </setBody>

Or to remove all double quotes:

    <setBody>
      <simple>${replace(&quot; , &empty;)}</simple>
    </setBody>

# Setting the result type

You can now provide a result type to the [Simple](#simple-language.adoc)
expression, which means the result of the evaluation will be converted
to the desired type. This is most usable to define types such as
booleans, integers, etc.

For example, to set a header as a boolean type, you can do:

    .setHeader("cool", simple("true", Boolean.class))

And in XML DSL

    <setHeader name="cool">
      <!-- use resultType to indicate that the type should be a java.lang.Boolean -->
      <simple resultType="java.lang.Boolean">true</simple>
    </setHeader>

# Using new lines or tabs in XML DSLs

It is easier to specify new lines or tabs in XML DSLs as you can escape
the value now

    <transform>
      <simple>The following text\nis on a new line</simple>
    </transform>

# Leading and trailing whitespace handling

The trim attribute of the expression can be used to control whether the
leading and trailing whitespace characters are removed or preserved. The
default value is true, which removes the whitespace characters.

    <setBody>
      <simple trim="false">You get some trailing whitespace characters.     </simple>
    </setBody>

# Loading script from external resource

You can externalize the script and have Camel load it from a resource
such as `"classpath:"`, `"file:"`, or `"http:"`. This is done using the
following syntax: `"resource:scheme:location"`, e.g., to refer to a file
on the classpath you can do:

    .setHeader("myHeader").simple("resource:classpath:mysimple.txt")
