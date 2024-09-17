# Openstack-glance

**Since Camel 2.19**

**Only producer is supported**

The Openstack Glance component allows messages to be sent to an
OpenStack image services.

# Dependencies

Maven users will need to add the following dependency to their
`pom.xml`.

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-openstack</artifactId>
        <version>${camel-version}</version>
    </dependency>

where `${camel-version`} must be replaced by the actual version of
Camel.

# URI Format

    openstack-glance://hosturl[?options]

# Usage

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 80%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Operation</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>reserve</code></p></td>
<td style="text-align: left;"><p>Reserve image.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>create</code></p></td>
<td style="text-align: left;"><p>Create a new image.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>update</code></p></td>
<td style="text-align: left;"><p>Update image.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>upload</code></p></td>
<td style="text-align: left;"><p>Upload image.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>Get the image.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>getAll</code></p></td>
<td style="text-align: left;"><p>Get all images.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>delete</code></p></td>
<td style="text-align: left;"><p>Delete the image.</p></td>
</tr>
</tbody>
</table>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|host|OpenStack host url||string|
|apiVersion|OpenStack API version|V3|string|
|config|OpenStack configuration||object|
|domain|Authentication domain|default|string|
|operation|The operation to do||string|
|password|OpenStack password||string|
|project|The project ID||string|
|username|OpenStack username||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
