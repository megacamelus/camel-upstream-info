# Openstack-keystone

**Since Camel 2.19**

**Only producer is supported**

The Openstack Keystone component allows messages to be sent to an
OpenStack identity services.

The openstack-keystone component supports only Identity API v3

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

    openstack-keystone://hosturl[?options]

# Usage

You can use the following settings for each subsystem:

# domains

## Operations you can perform with the Domain producer

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
<td style="text-align: left;"><p>Create a new domain.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>Get the domain.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>getAll</code></p></td>
<td style="text-align: left;"><p>Get all domains.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>update</code></p></td>
<td style="text-align: left;"><p>Update the domain.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>delete</code></p></td>
<td style="text-align: left;"><p>Delete the domain.</p></td>
</tr>
</tbody>
</table>

If you need more precise domain settings, you can create a new object of
the type **org.openstack4j.model.identity.v3.Domain** and send in the
message body.

# groups

## Operations you can perform with the Group producer

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
<td style="text-align: left;"><p>Create a new group.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>Get the group.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>getAll</code></p></td>
<td style="text-align: left;"><p>Get all groups.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>update</code></p></td>
<td style="text-align: left;"><p>Update the group.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>delete</code></p></td>
<td style="text-align: left;"><p>Delete the group.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>addUserToGroup</code></p></td>
<td style="text-align: left;"><p>Add the user to the group.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>checkUserGroup</code></p></td>
<td style="text-align: left;"><p>Check whether is the user in the
group.</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>removeUserFromGroup</code></p></td>
<td style="text-align: left;"><p>Remove the user from the
group.</p></td>
</tr>
</tbody>
</table>

If you need more precise group settings, you can create a new object of
the type **org.openstack4j.model.identity.v3.Group** and send in the
message body.

# projects

## Operations you can perform with the Project producer

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
<td style="text-align: left;"><p>Create a new project.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>Get the project.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>getAll</code></p></td>
<td style="text-align: left;"><p>Get all projects.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>update</code></p></td>
<td style="text-align: left;"><p>Update the project.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>delete</code></p></td>
<td style="text-align: left;"><p>Delete the project.</p></td>
</tr>
</tbody>
</table>

If you need more precise project settings, you can create a new object
of the type **org.openstack4j.model.identity.v3.Project** and send in
the message body.

# regions

## Operations you can perform with the Region producer

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
<td style="text-align: left;"><p>Create new region.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>Get the region.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>getAll</code></p></td>
<td style="text-align: left;"><p>Get all regions.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>update</code></p></td>
<td style="text-align: left;"><p>Update the region.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>delete</code></p></td>
<td style="text-align: left;"><p>Delete the region.</p></td>
</tr>
</tbody>
</table>

If you need more precise region settings, you can create a new object of
the type **org.openstack4j.model.identity.v3.Region** and send in the
message body.

# users

## Operations you can perform with the User producer

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
<td style="text-align: left;"><p>Create new user.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>Get the user.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>getAll</code></p></td>
<td style="text-align: left;"><p>Get all users.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>update</code></p></td>
<td style="text-align: left;"><p>Update the user.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>delete</code></p></td>
<td style="text-align: left;"><p>Delete the user.</p></td>
</tr>
</tbody>
</table>

If you need more precise user settings, you can create a new object of
the type **org.openstack4j.model.identity.v3.User** and send in the
message body.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|host|OpenStack host url||string|
|config|OpenStack configuration||object|
|domain|Authentication domain|default|string|
|operation|The operation to do||string|
|password|OpenStack password||string|
|project|The project ID||string|
|subsystem|OpenStack Keystone subsystem||string|
|username|OpenStack username||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
