# Openstack-cinder

**Since Camel 2.19**

**Only producer is supported**

The Openstack Cinder component allows messages to be sent to an
OpenStack block storage services.

# Dependencies

Maven users will need to add the following dependency to their pom.xml.

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-openstack</artifactId>
        <version>${camel-version}</version>
    </dependency>

where `${camel-version`} must be replaced by the actual version of
Camel.

# URI Format

    openstack-cinder://hosturl[?options]

# Usage

You can use the following settings for each subsystem:

# volumes

## Operations you can perform with the Volume producer

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 80%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>create</code></p></td>
<td style="text-align: left;"><p>Create new volume.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>Get the volume.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>getAll</code></p></td>
<td style="text-align: left;"><p>Get all volumes.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>getAllTypes</code></p></td>
<td style="text-align: left;"><p>Get volume types.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>update</code></p></td>
<td style="text-align: left;"><p>Update the volume.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>delete</code></p></td>
<td style="text-align: left;"><p>Delete the volume.</p></td>
</tr>
</tbody>
</table>

If you need more precise volume settings, you can create a new object of
the type **org.openstack4j.model.storage.block.Volume** and send in the
message body.

# snapshots

## Operations you can perform with the Snapshot producer

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 80%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>create</code></p></td>
<td style="text-align: left;"><p>Create a new snapshot.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>Get the snapshot.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>getAll</code></p></td>
<td style="text-align: left;"><p>Get all snapshots.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>update</code></p></td>
<td style="text-align: left;"><p>Get update the snapshot.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>delete</code></p></td>
<td style="text-align: left;"><p>Delete the snapshot.</p></td>
</tr>
</tbody>
</table>

If you need more precise server settings, you can create a new object of
the type **org.openstack4j.model.storage.block.VolumeSnapshot** and send
in the message body.

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
|subsystem|OpenStack Cinder subsystem||string|
|username|OpenStack username||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
