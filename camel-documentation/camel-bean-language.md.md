# Bean-language.md

**Since Camel 1.3**

The Bean language is used for calling a method on an existing Java bean.

Camel adapts to the method being called via [Bean
Binding](#manual::bean-binding.adoc). The binding process will, for
example, automatically convert the message payload to the parameter of
type of the first parameter in the method. The binding process has a lot
more features, so it is recommended to read the [Bean
Binding](#manual::bean-binding.adoc) documentation for mor details.

# Bean Method options

# Examples

In the given route below, we call a Java Bean Method with `method`,
where "myBean" is the id of the bean to use (lookup from
[Registry](#manual::registry.adoc)), and "isGoldCustomer" is the name of
the method to call.

Java  
from("activemq:topic:OrdersTopic")
.filter().method("myBean", "isGoldCustomer")
.to("activemq:BigSpendersQueue");

It is also possible to omit the method name. In this case, then Camel
would choose the best suitable method to use. This process is complex,
so it is good practice to specify the method name.

XML  
<route>  
<from uri="activemq:topic:OrdersTopic"/>  
<filter>  
<method ref="myBean" method="isGoldCustomer"/>  
<to uri="activemq:BigSpendersQueue"/>  
</filter>  
</route>

The bean could be implemented as follows:

    public class MyBean {
      public boolean isGoldCustomer(Exchange exchange) {
         // ...
      }
    }

How this method uses `Exchange` in the method signature. You would often
not do that, and use non-Camel types. For example, by using `String`
then Camel will automatically convert the message body to this type when
calling the method:

    public boolean isGoldCustomer(String body) {...}

## Using Annotations for bean integration

You can also use the [Bean Integration](#manual::bean-integration.adoc)
annotations, such as `@Header`, `@Body`, `@Variable` etc

    public boolean isGoldCustomer(@Header(name = "foo") Integer fooHeader) {...}

So you can bind parameters of the method to the `Exchange`, the
[Message](#eips:message.adoc) or individual headers, properties, the
body or other expressions.

## Non-Registry Beans

The Bean Method Language also supports invoking beans that are not
registered in the [Registry](#manual::registry.adoc).

Camel can instantiate the bean of a given type and invoke the method or
invoke the method on an already existing instance.

    from("activemq:topic:OrdersTopic")
      .filter().method(MyBean.class, "isGoldCustomer")
      .to("activemq:BigSpendersQueue");

The first parameter can also be an existing instance of a Bean such as:

    private MyBean my = ...;
    
    from("activemq:topic:OrdersTopic")
      .filter().method(my, "isGoldCustomer")
      .to("activemq:BigSpendersQueue");
