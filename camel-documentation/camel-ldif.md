# Ldif

**Since Camel 2.20**

**Only producer is supported**

The LDIF component allows you to do updates on an LDAP server from an
LDIF body content.

This component uses a basic URL syntax to access the server. It uses the
Apache DS LDAP library to process the LDIF. After processing the LDIF,
the response body will be a list of statuses for success/failure of each
entry.

The Apache LDAP API is very sensitive to LDIF syntax errors. If in
doubt, refer to the unit tests to see an example of each change type.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-ldif</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    ldif:ldapServerBean[?options]

The *ldapServerBean* portion of the URI refers to a
[LdapConnection](https://directory.apache.org/api/gen-docs/latest/apidocs/org/apache/directory/ldap/client/api/LdapConnection.html).
This should be constructed from a factory at the point of use to avoid
connection timeouts. The LDIF component only supports producer
endpoints, which means that an `ldif` URI cannot appear in the `from` at
the start of a route.

For SSL configuration, refer to the `camel-ldap` component where there
is an example of setting up a custom SocketFactory instance.

# Usage

## Body types:

The body can be a URL to an LDIF file or an inline LDIF file. To signify
the difference in body types, an inline LDIF must start with:

    version: 1

If not, the component will try to parse the body as a URL.

## Result

The result is returned in the Out body as a
`ArrayList<java.lang.String>` object. This contains either `_success_`
or an Exception message for each LDIF entry.

## LdapConnection

The URI, `ldif:ldapConnectionName`, references a bean with the ID,
`ldapConnectionName`. The ldapConnection can be configured using a
`LdapConnectionConfig` bean. Note that the scope must have a scope of
`prototype` to avoid the connection being shared or picking up a stale
connection.

The `LdapConnection` bean may be defined as follows in Spring XML:

    <bean id="ldapConnectionOptions" class="org.apache.directory.ldap.client.api.LdapConnectionConfig">
      <property name="ldapHost" value="${ldap.host}"/>
      <property name="ldapPort" value="${ldap.port}"/>
      <property name="name" value="${ldap.username}"/>
      <property name="credentials" value="${ldap.password}"/>
      <property name="useSsl" value="false"/>
      <property name="useTls" value="false"/>
    </bean>
    
    <bean id="ldapConnectionFactory" class="org.apache.directory.ldap.client.api.DefaultLdapConnectionFactory">
      <constructor-arg index="0" ref="ldapConnectionOptions"/>
    </bean>
    
    <bean id="ldapConnection" factory-bean="ldapConnectionFactory" factory-method="newLdapConnection" scope="prototype"/>

# Examples

Following on from the Spring configuration above, the code sample below
sends an LDAP request to filter search a group for a member. The Common
Name is then extracted from the response.

    ProducerTemplate<Exchange> template = exchange.getContext().createProducerTemplate();
    
    List<?> results = (Collection<?>) template.sendBody("ldif:ldapConnection, "LDiff goes here");
    
    if (results.size() > 0) {
      // Check for no errors
    
      for (String result : results) {
        if ("success".equalTo(result)) {
          // LDIF entry success
        } else {
          // LDIF entry failure
        }
      }
    }

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|ldapConnectionName|The name of the LdapConnection bean to pull from the registry. Note that this must be of scope prototype to avoid it being shared among threads or using a connection that has timed out.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
