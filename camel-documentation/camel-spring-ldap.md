# Spring-ldap

**Since Camel 2.11**

**Only producer is supported**

The Spring LDAP component provides a Camel wrapper for [Spring
LDAP](http://www.springsource.org/ldap).

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-spring-ldap</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    spring-ldap:springLdapTemplate[?options]

Where **springLdapTemplate** is the name of the [Spring LDAP Template
bean](http://static.springsource.org/spring-ldap/site/apidocs/org/springframework/ldap/core/LdapTemplate.html).
In this bean, you configure the URL and the credentials for your LDAP
access.

# Usage

The component supports producer endpoint only. An attempt to create a
consumer endpoint will result in an `UnsupportedOperationException`.  
The body of the message must be a map (an instance of `java.util.Map`).
Unless a base DN is specified by in the configuration of your
ContextSource, this map must contain at least an entry with the key
**`dn`** (not needed for function\_driven operation) that specifies the
root node for the LDAP operation to be performed. Other entries of the
map are operation-specific (see below).

The body of the message remains unchanged for the `bind` and `unbind`
operations. For the `search` and `function_driven` operations, the body
is set to the result of the search, see
[http://static.springsource.org/spring-ldap/site/apidocs/org/springframework/ldap/core/LdapTemplate.html#search%28java.lang.String,%20java.lang.String,%20int,%20org.springframework.ldap.core.AttributesMapper%29](http://static.springsource.org/spring-ldap/site/apidocs/org/springframework/ldap/core/LdapTemplate.html#search%28java.lang.String,%20java.lang.String,%20int,%20org.springframework.ldap.core.AttributesMapper%29).

## Search

The message body must have an entry with the key **`filter`**. The value
must be a `String` representing a valid LDAP filter, see
[http://en.wikipedia.org/wiki/Lightweight\_Directory\_Access\_Protocol#Search\_and\_Compare](http://en.wikipedia.org/wiki/Lightweight_Directory_Access_Protocol#Search_and_Compare).

## Bind

The message body must have an entry with the key **`attributes`**. The
value must be an instance of
[javax.naming.directory.Attributes](http://docs.oracle.com/javase/6/docs/api/javax/naming/directory/Attributes.html)
This entry specifies the LDAP node to be created.

## Unbind

No further entries necessary, the node with the specified **`dn`** is
deleted.

## Authenticate

The message body must have entries with the keys **`filter`** and
**`password`**. The values must be an instance of `String` representing
a valid LDAP filter and a user password, respectively.

## Modify Attributes

The message body must have an entry with the key
**`modificationItems`**. The value must be an instance of any array of
type
[javax.naming.directory.ModificationItem](http://docs.oracle.com/javase/6/docs/api/javax/naming/directory/ModificationItem.html)

## Function-Driven

The message body must have entries with the keys **`function`** and
**`request`**. The **`function`** value must be of type
`java.util.function.BiFunction<L, Q, S>`. The `L` type parameter must be
of type `org.springframework.ldap.core.LdapOperations`. The
**`request`** value must be the same type as the `Q` type parameter in
the **`function`** and it must encapsulate the parameters expected by
the LdapTemplate method being invoked within the **`function`**. The `S`
type parameter represents the response type as returned by the
LdapTemplate method being invoked. This operation allows dynamic
invocation of LdapTemplate methods that are not covered by the
operations mentioned above.

**Key definitions**

To avoid spelling errors, the following constants are defined in
`org.apache.camel.springldap.SpringLdapProducer`:

-   `public static final String DN = "dn"`

-   `public static final String FILTER = "filter"`

-   `public static final String ATTRIBUTES = "attributes"`

-   `public static final String PASSWORD = "password";`

-   `public static final String MODIFICATION_ITEMS = "modificationItems";`

-   `public static final String FUNCTION = "function";`

-   `public static final String REQUEST = "request";`

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|templateName|Name of the Spring LDAP Template bean||string|
|operation|The LDAP operation to be performed.||object|
|scope|The scope of the search operation.|subtree|string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
