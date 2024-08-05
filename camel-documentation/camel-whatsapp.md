# Whatsapp

**Since Camel 3.19**

**Only producer is supported**

The WhatsApp component provides access to the [WhatsApp Cloud
API](https://developers.facebook.com/docs/whatsapp/cloud-api). It allows
a Camel-based application to send messages using a cloud-hosted version
of the WhatsApp Business Platform.

Before using this component, you have to set up Developer Assets and
Platform Access, following the instructions at the [Register WhatsApp
Business Cloud API
account](https://developers.facebook.com/docs/whatsapp/cloud-api/get-started#set-up-developer-assets).
Once the account is set up, you can navigate to [Meta for Developers
Apps](https://developers.facebook.com/apps/?show_reminder=true), to
access to the WhatsApp dashboard. There you can get the **authorization
token**, **phone number id**, and you can add **recipient phone
numbers**, these parameters are mandatory to use the component.=

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-whatsapp</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    whatsapp:type[?options]

# Usage

The WhatsApp component supports only producer endpoints.

# Producer Example

The following is a basic example of how to send a message to a WhatsApp
chat through the Business Cloud API.

in Java DSL

    from("direct:start")
            .process(exchange -> {
                     TextMessageRequest request = new TextMessageRequest();
                     request.setTo(insertYourRecipientPhoneNumberHere);
                     request.setText(new TextMessage());
                     request.getText().setBody("This is an auto-generated message from Camel \uD83D\uDC2B");
    
                     exchange.getIn().setBody(request);
            })
            .to("whatsapp:123456789:insertYourPhoneNumberIdHere?authorizationToken=123456789:insertYourAuthorizationTokenHere");

For more information you can refer to [Cloud API
Reference](https://developers.facebook.com/docs/whatsapp/cloud-api/reference),
Supported API are:
[Messages](https://developers.facebook.com/docs/whatsapp/cloud-api/reference/messages)
and
[Media](https://developers.facebook.com/docs/whatsapp/cloud-api/reference/media)

# Webhook Mode

The Whatsapp component supports usage in the **webhook mode** using the
**camel-webhook** component.

To enable webhook mode, users need first to add a REST implementation to
their application. Maven users, for example, can add **netty-http** to
their `pom.xml` file:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-netty-http</artifactId>
    </dependency>

Once done, you need to prepend the webhook URI to the whatsapp URI you
want to use.

In Java DSL:

    fromF("webhook:whatsapp:%s?authorizationToken=%s&webhookVerifyToken=%s", "<phoneNumberId>", "<AuthorizationToken>", "<webhookVerifyToken>").log("${body}")

You can follow the [set up webhooks
guide](https://developers.facebook.com/docs/whatsapp/cloud-api/guides/set-up-webhooks)
to enable and configure the webhook. The webhook component will expose
an endpoint that can be used into the whatsapp administration console.

Refer to the [camel-webhook component](#webhook-component.adoc)
documentation for instructions on how to set it.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|phoneNumberId|Phone Number ID taken from WhatsApp Meta for Developers Dashboard||string|
|apiVersion|WhatsApp Cloud API version|v13.0|string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|baseUri|Can be used to set an alternative base URI, e.g. when you want to test the component against a mock WhatsApp API|https://graph.facebook.com|string|
|client|Java 11 HttpClient implementation||object|
|webhookVerifyToken|Webhook verify token||string|
|authorizationToken|Authorization Token taken from WhatsApp Meta for Developers Dashboard||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|phoneNumberId|The phone number ID taken from whatsapp-business dashboard.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|apiVersion|Facebook graph api version.||string|
|baseUri|Can be used to set an alternative base URI, e.g. when you want to test the component against a mock WhatsApp API||string|
|httpClient|HttpClient implementation||object|
|webhookPath|Webhook path|webhook|string|
|webhookVerifyToken|Webhook verify token||string|
|whatsappService|WhatsApp service implementation||object|
|authorizationToken|The authorization access token taken from whatsapp-business dashboard.||string|
