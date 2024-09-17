# Hashicorp-vault

**Since Camel 3.18**

**Only producer is supported**

The hashicorp-vault component that integrates [Hashicorp
Vault](https://www.vaultproject.io/).

# URI Format

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-hashicorp-vault</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# Examples

## Using Hashicorp Vault Property Function

To use this function, you’ll need to provide credentials for Hashicorp
vault as environment variables:

    export $CAMEL_VAULT_HASHICORP_TOKEN=token
    export $CAMEL_VAULT_HASHICORP_HOST=host
    export $CAMEL_VAULT_HASHICORP_PORT=port
    export $CAMEL_VAULT_HASHICORP_SCHEME=http/https

You can also configure the credentials in the `application.properties`
file such as:

    camel.vault.hashicorp.token = token
    camel.vault.hashicorp.host = host
    camel.vault.hashicorp.port = port
    camel.vault.hashicorp.scheme = scheme

`camel.vault.hashicorp` configuration only applies to the Hashicorp
Vault properties function (E.g when resolving properties). When using
the `operation` option to create, get, list secrets etc., you should
provide the `host`, `port`, `scheme` (if required) \& `token` options.

At this point, you’ll be able to reference a property in the following
way:

    <camelContext>
        <route>
            <from uri="direct:start"/>
            <to uri="{{hashicorp:secret:route}}"/>
        </route>
    </camelContext>

Where route will be the name of the secret stored in the Hashicorp Vault
instance, in the *secret* engine.

You could specify a default value in case the secret is not present on
Hashicorp Vault instance:

    <camelContext>
        <route>
            <from uri="direct:start"/>
            <to uri="{{hashicorp:secret:route:default}}"/>
        </route>
    </camelContext>

In this case, if the secret doesn’t exist in the *secret* engine, the
property will fall back to "default" as value.

Also, you are able to get a particular field of the secret, if you have,
for example, a secret named database of this form:

    {
      "username": "admin",
      "password": "password123",
      "engine": "postgres",
      "host": "127.0.0.1",
      "port": "3128",
      "dbname": "db"
    }

You’re able to do get single secret value in your route, in the *secret*
engine, like for example:

    <camelContext>
        <route>
            <from uri="direct:start"/>
            <log message="Username is {{hashicorp:secret:database#username}}"/>
        </route>
    </camelContext>

Or re-use the property as part of an endpoint.

You could specify a default value in case the particular field of secret
is not present on Hashicorp Vault instance, in the *secret* engine:

    <camelContext>
        <route>
            <from uri="direct:start"/>
            <log message="Username is {{hashicorp:secret:database#username:admin}}"/>
        </route>
    </camelContext>

In this case, if the secret doesn’t exist or the secret exists (in the
*secret* engine) but the username field is not part of the secret, the
property will fall back to "admin" as value.

There is also the syntax to get a particular version of the secret for
both the approach, with field/default value specified or only with
secret:

    <camelContext>
        <route>
            <from uri="direct:start"/>
            <to uri="{{hashicorp:secret:route@2}}"/>
        </route>
    </camelContext>

This approach will return the RAW route secret with version *2*, in the
*secret* engine.

    <camelContext>
        <route>
            <from uri="direct:start"/>
            <to uri="{{hashicorp:route:default@2}}"/>
        </route>
    </camelContext>

This approach will return the route secret value with version *2* or
default value in case the secret doesn’t exist or the version doesn’t
exist (in the *secret* engine).

    <camelContext>
        <route>
            <from uri="direct:start"/>
            <log message="Username is {{hashicorp:secret:database#username:admin@2}}"/>
        </route>
    </camelContext>

This approach will return the username field of the database secret with
version *2* or admin in case the secret doesn’t exist or the version
doesn’t exist (in the *secret* engine).

The only requirement is adding the camel-hashicorp-vault jar to your
Camel application.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|secretsEngine|Vault Name to be used||string|
|host|Hashicorp Vault instance host to be used||string|
|operation|Operation to be performed||object|
|port|Hashicorp Vault instance port to be used|8200|string|
|scheme|Hashicorp Vault instance scheme to be used|https|string|
|secretPath|Hashicorp Vault instance secret Path to be used||string|
|vaultTemplate|Instance of Vault template||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|token|Token to be used||string|
