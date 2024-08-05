# Openstack-nova

**Since Camel 2.19**

**Only producer is supported**

The Openstack Nova component allows messages to be sent to an OpenStack
compute services.

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

    openstack-nova://hosturl[?options]

# Usage

You can use the following settings for each subsystem:

# flavors

## Operations you can perform with the Flavor producer

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
<td style="text-align: left;"><p>Create new flavor.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>Get the flavor.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>getAll</code></p></td>
<td style="text-align: left;"><p>Get all flavors.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>delete</code></p></td>
<td style="text-align: left;"><p>Delete the flavor.</p></td>
</tr>
</tbody>
</table>

If you need more precise flavor settings, you can create a new object of
the type **org.openstack4j.model.compute.Flavor** and send in the
message body.

# servers

## Operations you can perform with the Server producer

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
<td style="text-align: left;"><p>Create a new server.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>createSnapshot</code></p></td>
<td style="text-align: left;"><p>Create snapshot of the server.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>Get the server.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>getAll</code></p></td>
<td style="text-align: left;"><p>Get all servers.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>delete</code></p></td>
<td style="text-align: left;"><p>Delete the server.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>action</code></p></td>
<td style="text-align: left;"><p>Perform an action on the
server.</p></td>
</tr>
</tbody>
</table>

If you need more precise server settings, you can create a new object of
the type **org.openstack4j.model.compute.ServerCreate** and send in the
message body.

# keypairs

## Operations you can perform with the Keypair producer

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
<td style="text-align: left;"><p>Create new keypair.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>Get the keypair.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>getAll</code></p></td>
<td style="text-align: left;"><p>Get all keypairs.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>delete</code></p></td>
<td style="text-align: left;"><p>Delete the keypair.</p></td>
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
|subsystem|OpenStack Nova subsystem||string|
|username|OpenStack username||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
