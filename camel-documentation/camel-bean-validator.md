# Bean-validator

**Since Camel 2.3**

**Only producer is supported**

The Validator component performs bean validation of the message body
using the Java Bean Validation API ([JSR
303](http://jcp.org/en/jsr/detail?id=303)). Camel uses the reference
implementation, which is [Hibernate
Validator](https://docs.jboss.org/hibernate/validator/6.2/reference/en-US/html_single/).

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-bean-validator</artifactId>
        <version>x.y.z</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    bean-validator:label[?options]

Where **label** is an arbitrary text value describing the endpoint. You
can append query options to the URI in the following format:
`?option=value&option=value&...`

# OSGi deployment

To use Hibernate Validator in the OSGi environment use dedicated
`ValidationProviderResolver` implementation, just as
`org.apache.camel.component.bean.validator.HibernateValidationProviderResolver`.
The snippet below demonstrates this approach. You can also use
`HibernateValidationProviderResolver`.

## Using HibernateValidationProviderResolver

Java  
from("direct:test").
to("bean-validator://ValidationProviderResolverTest?validationProviderResolver=#myValidationProviderResolver");

XML  
<bean id="myValidationProviderResolver" class="org.apache.camel.component.bean.validator.HibernateValidationProviderResolver"/>

If no custom `ValidationProviderResolver` is defined and the validator
component has been deployed into the OSGi environment, the
`HibernateValidationProviderResolver` will be automatically used.

# Example

Assumed we have a java bean with the following annotations

**Car.java**

    public class Car {
    
        @NotNull
        private String manufacturer;
    
        @NotNull
        @Size(min = 5, max = 14, groups = OptionalChecks.class)
        private String licensePlate;
    
        // getter and setter
    }

and an interface definition for our custom validation group

**OptionalChecks.java**

    public interface OptionalChecks {
    }

with the following Camel route, only the **@NotNull** constraints on the
attributes `manufacturer` and `licensePlate` will be validated (Camel
uses the default group `jakarta.validation.groups.Default`).

    from("direct:start")
    .to("bean-validator://x")
    .to("mock:end")

If you want to check the constraints from the group `OptionalChecks`,
you have to define the route like this

    from("direct:start")
    .to("bean-validator://x?group=OptionalChecks")
    .to("mock:end")

If you want to check the constraints from both groups, you have to
define a new interface first:

**AllChecks.java**

    @GroupSequence({Default.class, OptionalChecks.class})
    public interface AllChecks {
    }

And then your route definition should look like this:

    from("direct:start")
    .to("bean-validator://x?group=AllChecks")
    .to("mock:end")

And if you have to provide your own message interpolator, traversable
resolver and constraint validator factory, you have to write a route
like this:

Java  
<bean id="myMessageInterpolator" class="my.ConstraintValidatorFactory" />  
<bean id="myTraversableResolver" class="my.TraversableResolver" />  
<bean id="myConstraintValidatorFactory" class="my.ConstraintValidatorFactory" />

XML  
from("direct:start")
.to("bean-validator://x?group=AllChecks\&messageInterpolator=#myMessageInterpolator
\&traversableResolver=#myTraversableResolver\&constraintValidatorFactory=#myConstraintValidatorFactory")
.to("mock:end")

It’s also possible to describe your constraints as XML and not as Java
annotations. In this case, you have to provide the files
`META-INF/validation.xml` and `constraints-car.xml` which could look
like this:

validation.xml  
<validation-config
xmlns="https://jakarta.ee/xml/ns/validation/configuration"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="https://jakarta.ee/xml/ns/validation/configuration https://jakarta.ee/xml/ns/validation/validation-configuration-3.0.xsd"
version="3.0">

        <default-provider>org.hibernate.validator.HibernateValidator</default-provider>
        <message-interpolator>org.hibernate.validator.engine.ResourceBundleMessageInterpolator</message-interpolator>
        <traversable-resolver>org.hibernate.validator.engine.resolver.DefaultTraversableResolver</traversable-resolver>
        <constraint-validator-factory>org.hibernate.validator.engine.ConstraintValidatorFactoryImpl</constraint-validator-factory>
        <constraint-mapping>/constraints-car.xml</constraint-mapping>
    
    </validation-config>

constraints-car.xml  
<constraint-mappings
xmlns="https://jakarta.ee/xml/ns/validation/mapping"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="https://jakarta.ee/xml/ns/validation/mapping
https://jakarta.ee/xml/ns/validation/validation-mapping-3.0.xsd"
version="3.0">

        <default-package>org.apache.camel.component.bean.validator</default-package>
    
        <bean class="CarWithoutAnnotations" ignore-annotations="true">
            <field name="manufacturer">
                <constraint annotation="jakarta.validation.constraints.NotNull" />
            </field>
    
            <field name="licensePlate">
                <constraint annotation="jakarta.validation.constraints.NotNull" />
    
                <constraint annotation="jakarta.validation.constraints.Size">
                    <groups>
                        <value>org.apache.camel.component.bean.validator.OptionalChecks</value>
                    </groups>
                    <element name="min">5</element>
                    <element name="max">14</element>
                </constraint>
            </field>
        </bean>
    </constraint-mappings>

Here is the XML syntax for the example route definition where
**OrderedChecks** can be
[https://github.com/apache/camel/blob/main/components/camel-bean-validator/src/test/java/org/apache/camel/component/bean/validator/OrderedChecks.java](https://github.com/apache/camel/blob/main/components/camel-bean-validator/src/test/java/org/apache/camel/component/bean/validator/OrderedChecks.java)

Note that the body should include an instance of a class to validate.

    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="
        http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
        http://camel.apache.org/schema/spring http://camel.apache.org/schema/spring/camel-spring.xsd">
    
        <camelContext id="camel" xmlns="http://camel.apache.org/schema/spring">
            <route>
                <from uri="direct:start"/>
                <to uri="bean-validator://x?group=org.apache.camel.component.bean.validator.OrderedChecks"/>
            </route>
        </camelContext>
    </beans>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|ignoreXmlConfiguration|Whether to ignore data from the META-INF/validation.xml file.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|constraintValidatorFactory|To use a custom ConstraintValidatorFactory||object|
|messageInterpolator|To use a custom MessageInterpolator||object|
|traversableResolver|To use a custom TraversableResolver||object|
|validationProviderResolver|To use a a custom ValidationProviderResolver||object|
|validatorFactory|To use a custom ValidatorFactory||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|label|Where label is an arbitrary text value describing the endpoint||string|
|group|To use a custom validation group|jakarta.validation.groups.Default|string|
|ignoreXmlConfiguration|Whether to ignore data from the META-INF/validation.xml file.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|constraintValidatorFactory|To use a custom ConstraintValidatorFactory||object|
|messageInterpolator|To use a custom MessageInterpolator||object|
|traversableResolver|To use a custom TraversableResolver||object|
|validationProviderResolver|To use a a custom ValidationProviderResolver||object|
|validatorFactory|To use a custom ValidatorFactory||object|
