# Wordpress

**Since Camel 2.21**

**Both producer and consumer are supported**

Camel component for the [WordPress
API](https://developer.wordpress.org/rest-api/reference/).

Currently only the **Posts** and **Users** operations are supported.

Most of the parameters needed when performing a read operation mirrors
from the official
[API](https://developer.wordpress.org/rest-api/reference/). When
performing searches operations, the `criteria.` suffix is needed. Take
the following `Consumer` as example:

    wordpress:post?criteria.perPage=10&criteria.orderBy=author&criteria.categories=camel,dozer,json

# Usage

## Configuring WordPress component

The `WordpressConfiguration` class can be used to set initial properties
configuration to the component instead of passing it as query parameter.
The following listing shows how to set the component to be used in your
routes.

    public void configure() {
        final WordpressConfiguration configuration = new WordpressConfiguration();
        final WordpressComponent component = new WordpressComponent();
        configuration.setApiVersion("2");
        configuration.setUrl("http://yoursite.com/wp-json/");
        component.setConfiguration(configuration);
        getContext().addComponent("wordpress", component);
    
        from("wordpress:post?id=1")
          .to("mock:result");
    }

# Examples

## Consumer Example

Consumer polls from the API from time to time domain objects from
WordPress. Following, an example using the `Post` operation:

-   `wordpress:post` retrieves posts (defaults to 10 posts)

-   `wordpress:post?id=1` search for a specific post

## Producer Example

Producer performs write operations on WordPress like adding a new user
or update a post. To be able to write, you must have an authorized user
credentials (see Authentication).

-   `wordpress:post` creates a new post from the
    `org.apache.camel.component.wordpress.api.model.Post` class in the
    message body.

-   `wordpress:post?id=1` updates a post based on data
    `org.apache.camel.component.wordpress.api.model.Post` from the
    message body.

-   `wordpress:post:delete?id=1` deletes a specific post

## Authentication

Producers that perform write operations, e.g., creating a new post,
[must have an authenticated
user](https://developer.wordpress.org/rest-api/using-the-rest-api/authentication/)
to do so. The standard authentication mechanism used by WordPress is
cookie. Unfortunately, this method is not supported outside WordPress
environment because it relies on
[nonce](https://codex.wordpress.org/WordPress_Nonces) internal function.

There are some alternatives to using the WordPress API without nonces,
but require specific plugin installations.

At this time, `camel-wordpress` only supports Basic Authentication (more
to come). To configure it, you must install the [Basic-Auth WordPress
plugin](https://github.com/WP-API/Basic-Auth) and pass the credentials
to the endpoint:

`from("direct:deletePost").to("wordpress:post:delete?id=9&user=ben&password=password123").to("mock:resultDelete");`

**It’s not recommended to use Basic Authentication in production without
TLS!!**

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|apiVersion|The Wordpress REST API version|2|string|
|configuration|Wordpress configuration||object|
|criteria|The criteria to use with complex searches.||object|
|force|Whether to bypass trash and force deletion.|false|boolean|
|id|The entity ID. Should be passed when the operation performed requires a specific entity, e.g. deleting a post||integer|
|password|Password from authorized user||string|
|searchCriteria|Search criteria||object|
|url|The Wordpress API URL from your site, e.g. http://myblog.com/wp-json/||string|
|user|Authorized user to perform writing operations||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|operation|The endpoint operation.||string|
|operationDetail|The second part of an endpoint operation. Needed only when endpoint semantic is not enough, like wordpress:post:delete||string|
|apiVersion|The Wordpress REST API version|2|string|
|criteria|The criteria to use with complex searches.||object|
|force|Whether to bypass trash and force deletion.|false|boolean|
|id|The entity ID. Should be passed when the operation performed requires a specific entity, e.g. deleting a post||integer|
|password|Password from authorized user||string|
|searchCriteria|Search criteria||object|
|url|The Wordpress API URL from your site, e.g. http://myblog.com/wp-json/||string|
|user|Authorized user to perform writing operations||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
