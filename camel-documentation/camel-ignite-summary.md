# Ignite-summary.md

**Since Camel 2.17**

[Apache Ignite](https://ignite.apache.org/) In-Memory Data Fabric is a
high performance, integrated and distributed in-memory platform for
computing and transacting on large-scale data sets in real-time, orders
of magnitude faster than possible with traditional disk-based or flash
technologies. It is designed to deliver uncompromised performance for a
wide set of in-memory computing use cases from high-performance
computing, to the industry’s most advanced data grid, highly available
service grid, and streaming. See all
[features](https://ignite.apache.org/features.html).

<figure>
<img src="apache-ignite.png" alt="apache-ignite.png" />
</figure>

# Ignite components

See the following for usage of each component:

indexDescriptionList::\[attributes=*group=Ignite*,descriptionformat=description\]

# Installation

To use this component, add the following dependency to your `pom.xml`:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-ignite</artifactId>
        <version>${camel.version}</version> <!-- use the same version as your Camel core version -->
    </dependency>

# Initializing the Ignite component

Each instance of the Ignite component is associated with an underlying
`org.apache.ignite.Ignite` instance. You can interact with two Ignite
clusters by initializing two instances of the Ignite component and
binding them to different `IgniteConfigurations`. There are three ways
to initialize the Ignite component:

-   By passing in an existing `org.apache.ignite.Ignite` instance.
    Here’s an example using Spring config:

<!-- -->

    <bean name="ignite" class="org.apache.camel.component.ignite.IgniteComponent">
       <property name="ignite" ref="ignite" />
    </bean>

-   By passing in an IgniteConfiguration, either constructed
    programmatically or through inversion of control (e.g., Spring,
    etc). Here’s an example using Spring config:

<!-- -->

    <bean name="ignite" class="org.apache.camel.component.ignite.IgniteComponent">
       <property name="igniteConfiguration">
          <bean class="org.apache.ignite.configuration.IgniteConfiguration">
             [...]
          </bean>
       </property>
    </bean>

-   By passing in a URL, InputStream or String URL to a Spring-based
    configuration file. In all three cases, you inject them in the same
    property called configurationResource. Here’s an example using
    Spring config:

<!-- -->

    <bean name="ignite" class="org.apache.camel.component.ignite.IgniteComponent">
       <property name="configurationResource" value="file:[...]/ignite-config.xml" />
    </bean>

Additionally, if using Camel programmatically, there are several
convenience static methods in IgniteComponent that return a component
out of these configuration options:

-   `IgniteComponent#fromIgnite(Ignite)`

-   `IgniteComponent#fromConfiguration(IgniteConfiguration)`

-   `IgniteComponent#fromInputStream(InputStream)`

-   `IgniteComponent#fromUrl(URL)`

-   `IgniteComponent#fromLocation(String)`

You may use those methods to quickly create an IgniteComponent with your
chosen configuration technique.

# General options

All endpoints share the following options:

<table>
<colgroup>
<col style="width: 11%" />
<col style="width: 11%" />
<col style="width: 11%" />
<col style="width: 44%" />
<col style="width: 11%" />
<col style="width: 11%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Option</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Default value</th>
<th style="text-align: left;">Description</th>
<th style="text-align: left;">propagateIncomingBodyIfNoReturnValue</th>
<th style="text-align: left;">boolean</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>true</p></td>
<td style="text-align: left;"><p>If the underlying Ignite operation
returns void (no return type), this flag determines whether the producer
will copy the <em>IN</em> body into the <em>OUT</em> body.</p></td>
<td style="text-align: left;"><p>treatCollectionsAsCacheObjects</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Some Ignite operations can deal with
multiple elements at once, if passed a Collection. Enabling this option
will treat Collections as a single object, invoking the operation
variant for cardinality 1.</p></td>
</tr>
</tbody>
</table>
