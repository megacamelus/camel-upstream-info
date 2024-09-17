# Properties

**Since Camel 2.3**

The Properties component is used for property placeholders in your Camel
application, such as endpoint URIs. It is **not** a regular Camel
component with producer and consumer for routing messages. However, for
historical reasons it was named `PropertiesComponent` and this name is
commonly known so we keep using it.

See the [Property
Placeholder](#manual:ROOT:using-propertyplaceholder.adoc) documentation
for general information on using property placeholders in Camel.

The Properties component requires to load the properties (key=value
pairs) from an external source such as `.properties` files. The
component is pluggable, and you can configure to use other sources or
write a custom implementation (for example to load from a database).

# Defining location of properties files

The properties component needs to know the location(s) where to resolve
the properties. You can define one-to-many locations. You can separate
multiple locations by comma, such as:

    pc.setLocation("com/mycompany/myprop.properties,com/mycompany/other.properties");

You can mark a location to be optional, which means that Camel will
ignore the location if not present:

    pc.setLocations(
        "com/mycompany/override.properties;optional=true"
        "com/mycompany/defaults.properties");

## Using system and environment variables in locations

The location now supports using placeholders for JVM system properties
and OS environments variables.

For example:

    location=file:{{sys:app.home}}/etc/foo.properties

In the location above we defined a location using the file scheme using
the JVM system property with key `app.home`.

To use an OS environment variable, instead you would have to prefix with
`env:`. You can also prefix with `env.`, however, this style is not
recommended because all the other functions use colon.

    location=file:{{env:APP_HOME}}/etc/foo.properties

Where `APP_HOME` is an OS environment.

Some OS’es (such as Linux) do not support dashes in environment variable
names, so here we are using `APP_HOME`. But if you specify `APP-HOME`
then Camel 3 will automatic lookup the value as `APP_HOME` (with
underscore) as fallback.

You can have multiple placeholders in the same location, such as:

    location=file:{{env:APP_HOME}}/etc/{{prop.name}}.properties

## Defining location of properties files in Spring XML

Spring XML offers two variations to configure. You can define a spring
bean as a `PropertiesComponent` which resembles the way done in Java. Or
you can use the `<propertyPlaceholder>` tag.

    <bean id="properties" class="org.apache.camel.component.properties.PropertiesComponent">
        <property name="location" value="classpath:com/mycompany/myprop.properties"/>
    </bean>

Using the `<propertyPlaceholder>` allows to configure this within the
`<camelContext>` tag.

    <camelContext>
       <propertyPlaceholder id="properties" location="com/mycompany/myprop.properties"/>
    </camelContext>

For fine-grained configuration of the location, then this can be done as
follows:

    <camelContext>
      <propertyPlaceholder id="myPropertyPlaceholder">
        <propertiesLocation
          resolver = "classpath"
          path     = "com/my/company/something/my-properties-1.properties"
          optional = "false"/>
        <propertiesLocation
          resolver = "classpath"
          path     = "com/my/company/something/my-properties-2.properties"
          optional = "false"/>
    </camelContext>

# Options

The component supports the following options, which are listed below.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.component.properties.auto-discover-properties-sources</strong></p></td>
<td style="text-align: left;"><p>Whether to automatically discovery
instances of PropertiesSource from registry and service
factory.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.component.properties.default-fallback-enabled</strong></p></td>
<td style="text-align: left;"><p>If false, the component does not
attempt to find a default for the key by looking after the colon
separator.</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.component.properties.encoding</strong></p></td>
<td style="text-align: left;"><p>Encoding to use when loading properties
file from the file system or classpath. If no encoding has been set,
then the properties files is loaded using ISO-8859-1 encoding (latin-1)
as documented by java.util.Properties#load(java.io.InputStream)</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.component.properties.environment-variable-mode</strong></p></td>
<td style="text-align: left;"><p>Sets the OS environment variables mode
(0 = never, 1 = fallback, 2 = override). The default mode (override) is
to use OS environment variables if present, and override any existing
properties. OS environment variable mode is checked before JVM system
property mode</p></td>
<td style="text-align: center;"><p>2</p></td>
<td style="text-align: left;"><p>Integer</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.component.properties.ignore-missing-location</strong></p></td>
<td style="text-align: left;"><p>Whether to silently ignore if a
location cannot be located, such as a properties file not
found.</p></td>
<td style="text-align: center;"><p>false</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.component.properties.initial-properties</strong></p></td>
<td style="text-align: left;"><p>Sets initial properties which will be
used before any locations are resolved. The option is a
java.util.Properties type.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.component.properties.location</strong></p></td>
<td style="text-align: left;"><p>A list of locations to load properties.
You can use comma to separate multiple locations. This option will
override any default locations and only use the locations from this
option.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.component.properties.nested-placeholder</strong></p></td>
<td style="text-align: left;"><p>Whether to support nested property
placeholders. A nested placeholder, means that a placeholder, has also a
placeholder, that should be resolved (recursively).</p></td>
<td style="text-align: center;"><p>true</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.component.properties.override-properties</strong></p></td>
<td style="text-align: left;"><p>Sets a special list of override
properties that take precedence and will use first, if a property exist.
The option is a java.util.Properties type.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>camel.component.properties.properties-parser</strong></p></td>
<td style="text-align: left;"><p>To use a custom PropertiesParser. The
option is a org.apache.camel.component.properties.PropertiesParser
type.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>camel.component.properties.system-properties-mode</strong></p></td>
<td style="text-align: left;"><p>Sets the JVM system property mode (0 =
never, 1 = fallback, 2 = override). The default mode (override) is to
use system properties if present, and override any existing properties.
OS environment variable mode is checked before JVM system property
mode</p></td>
<td style="text-align: center;"><p>2</p></td>
<td style="text-align: left;"><p>Integer</p></td>
</tr>
</tbody>
</table>

## Component ConfigurationsThere are no configurations for this component

## Endpoint ConfigurationsThere are no configurations for this component
