# Spring-summary.md

# Spring components

See the following for usage of each component:

indexDescriptionList::\[attributes=*group=Spring*,descriptionformat=description\]

Apache Camel is designed to work nicely with the Spring Framework in a
number of ways.

-   Camel supports Spring Boot using the `camel-spring-boot` component.

-   Allows Spring to dependency inject Component instances or the
    CamelContext instance itself and auto-expose Spring beans as
    components and endpoints.

-   Camel works with Spring XML processing with the XML DSL via
    `camel-spring-xml` component

-   Camel provides powerful Bean Integration with any bean defined in a
    Spring ApplicationContext

-   Camel uses Spring Transactions as the default transaction handling
    in components like [JMS](#jms-component.adoc) and
    [JPA](#jms-component.adoc)

-   Camel integrates with various Spring helper classes; such as
    providing Type Converter support for Spring Resources, etc.

-   Allows you to reuse the Spring Testing framework to simplify your
    unit and integration testing using [Enterprise Integration
    Patterns](#eips:enterprise-integration-patterns.adoc) and Camel’s
    powerful [Mock](#mock-component.adoc) and
    [Test](#others:test-junit5.adoc) endpoints

# Using Spring to configure the CamelContext

You can configure a CamelContext inside any spring.xml using the
`CamelContextFactoryBean`. This will automatically start the
CamelContext along with any referenced Routes along any referenced
Component and Endpoint instances.

-   Adding Camel schema

-   Configure Routes in two ways:
    
    -   Using Java Code
    
    -   Using Spring XML

# Adding Camel Schema

You need to add Camel to the `schemaLocation` declaration

    http://camel.apache.org/schema/spring http://camel.apache.org/schema/spring/camel-spring.xsd

So the XML file looks like this:

    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="
              http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
              http://camel.apache.org/schema/spring http://camel.apache.org/schema/spring/camel-spring.xsd">

## Using camel: namespace

Or you can refer to camel XSD in the XML declaration:

    xmlns:camel="http://camel.apache.org/schema/spring"

1.  so the declaration is:

<!-- -->

    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:camel="http://camel.apache.org/schema/spring"
           xsi:schemaLocation="
              http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
              http://camel.apache.org/schema/spring http://camel.apache.org/schema/spring/camel-spring.xsd">

1.  and then use the camel: namespace prefix, and you can omit the
    inline namespace declaration:

<!-- -->

    <camel:camelContext>
      <camel:package>org.apache.camel.spring.example</camel:package>
    </camel:camelContext>

# Additional configuration of Spring XML

See more details at [Camel Spring XML Auto
Configuration](#manual::advanced-configuration-of-camelcontext-using-spring.adoc).

## Using Java Code

You can use Java Code to define your `RouteBuilder` implementations.
These can be defined as beans in spring and then referenced in your
camel context.

## Using \<package\>

Camel also provides a powerful feature that allows for the automatic
discovery and initialization of routes in given packages. This is
configured by adding tags to the camel context in your spring context
definition, specifying the packages to be recursively searched for
`RouteBuilder` implementations. To use this feature, requires a
`<package></package>` tag specifying a comma-separated list of packages
that should be searched e.g.

      <camelContext xmlns="http://camel.apache.org/schema/spring">
        <package>org.apache.camel.spring.config.scan.route</package>
      </camelContext>

Use caution when specifying the package name as `org.apache.camel` or a
subpackage of this. This causes Camel to search in its own packages for
your routes, which could cause problems.

**Will ignore already instantiated classes**

The `<package>` and `<packageScan>` will skip all classes that Spring
has already created etc. So if you define a route builder as a spring
bean tag, then that class will be skipped. You can include those beans
using `<routeBuilder ref="theBeanId"/>` or the `<contextScan>` feature.

## Using \<packageScan\>

The component allows selective inclusion and exclusion of discovered
route classes using Ant like path matching. In spring this is specified
by adding a `<packageScan>` tag. The tag must contain one or more
*package* elements, and optionally one or more *includes* or *excludes*
elements specifying patterns to be applied to the fully qualified names
of the discovered classes. e.g.

      <camelContext xmlns="http://camel.apache.org/schema/spring">
        <packageScan>
          <package>org.example.routes</package>
          <excludes>**.*Excluded*</excludes>
          <includes>**.*</includes>
        </packageScan>
      </camelContext>

Exclude patterns are applied before the include patterns. If no include
or exclude patterns are defined, then all the Route classes discovered
in the packages will be returned.

In the above example, camel will scan all the `org.example.routes`
package and any subpackages for `RouteBuilder` classes. Say the scan
finds two RouteBuilders, one in `org.example.routes` called `MyRoute`
and another `MyExcludedRoute` in a subpackage *excluded*. The fully
qualified names of each of the classes are extracted
(`org.example.routes.MyRoute`,
`org.example.routes.excluded.MyExcludedRoute`) and the include and
exclude patterns are applied.

The exclude pattern **\*.\*Excluded** is going to match the fqcn
`org.example.routes.excluded.MyExcludedRoute` and veto camel from
initializing it.

Under the covers, this is using *ant path* styles, which matches as
follows

    ? matches one character
    * matches zero or more characters
    ** matches zero or more segments of a fully qualified name

For example:

`**.*Excluded*` would match `org.simple.Excluded`,
`org.apache.camel.SomeExcludedRoute` or
`org.example.RouteWhichIsExcluded`

`**.??cluded*` would match `org.simple.IncludedRoute`,
`org.simple.Excluded` but not match `org.simple.PrecludedRoute`

## Using contextScan

You can allow Camel to scan the container context, e.g., the Spring
`ApplicationContext` for route builder instances. This allows you to use
the Spring `<component-scan>` feature and have Camel pickup any
`RouteBuilder` instances which were created by Spring in its scan
process.

This allows you to just annotate your routes using the Spring
`@Component` and have those routes included by Camel

    @Component
    public class MyRoute extends SpringRouteBuilder {
    
        @Override
        public void configure() throws Exception {
            from("direct:start").to("mock:result");
        }
    }

You can also use the ant style for inclusion and exclusion, as mentioned
above in the `<packageScan>` documentation.

# How do I import routes from other XML files?

When defining routes in Camel using Spring XML, you may want to define
some routes in other XML files. For example, you may have many routes,
and it may help to maintain the application if some routes are in
separate XML files. You may also want to store common and reusable
routes in other XML files, which you can import when needed.

It is possible to define routes outside `<camelContext/>` which you do
in a new `<routeContext/>` tag.

When you use `<routeContext>` then they are separated, and cannot reuse
existing `<onException>`, `<intercept>`, `<dataFormats>` and similar
cross-cutting functionalities defined in the `<camelContext>`. In other
words the `<routeContext>` is currently isolated.

For example, we could have a file named `myCoolRoutes.xml` which
contains a couple of routes as shown:

    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="
           http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
           http://camel.apache.org/schema/spring http://camel.apache.org/schema/spring/camel-spring.xsd
        ">
        <!-- this is an included XML file where we only the routeContext -->
        <routeContext id="myCoolRoutes" xmlns="http://camel.apache.org/schema/spring">
            <!-- we can have a route -->
            <route id="cool">
                <from uri="direct:start"/>
                <to uri="mock:result"/>
            </route>
            <!-- and another route, you can have as many you like -->
            <route id="bar">
                <from uri="direct:bar"/>
                <to uri="mock:bar"/>
            </route>
        </routeContext>
    </beans>

Then in your XML file which contains the CamelContext you can use Spring
to import the `myCoolRoute.xml` file. And then inside `<camelContext/>`
you can refer to the `<routeContext/>` by its id as shown below:

     <!-- import the routes from another XML file -->
     <import resource="myCoolRoutes.xml"/>
    
     <camelContext xmlns="http://camel.apache.org/schema/spring">
    
         <!-- refer to a given route to be used -->
         <routeContextRef ref="myCoolRoutes"/>
    
         <!-- we can still use routes inside camelContext -->
         <route id="inside">
             <from uri="direct:inside"/>
             <to uri="mock:inside"/>
         </route>
     </camelContext>

Also notice that you can mix and match, having routes inside
`CamelContext` and also externalized in `RouteContext`.

You can have as many `<routeContextRef/>` as you like.

**Reusable routes**

The routes defined in `<routeContext/>` can be reused by multiple
`<camelContext/>`. However, it is only the definition that is reused. At
runtime, each CamelContext will create its own instance of the route
based on the definition.

## Test time exclusion.

At test time, it is often desirable to be able to selectively exclude
matching routes from being initialized that are not applicable or useful
to the test scenario. For instance, you might have a spring context file
`routes-context.xml` and three Route builders `RouteA`, `RouteB` and
`RouteC` in the *org.example.routes* package. The packageScan definition
would discover all three of these routes and initialize them.

Say `RouteC` is not applicable to our test scenario and generates a lot
of noise during the test. It would be nice to be able to exclude this
route from this specific test. The `SpringTestSupport` class has been
modified to allow this. It provides two methods (`excludeRoute` and
`excludeRoutes`) that may be overridden to exclude a single class or an
array of classes.

    public class RouteAandRouteBOnlyTest extends SpringTestSupport {
        @Override
        protected Class<?> excludeRoute() {
            return RouteC.class;
        }
    }

To hook into the camelContext initialization by spring to exclude the
class `MyExcludedRouteBuilder`, we need to intercept the spring context
creation. When overriding createApplicationContext to create the spring
context, we call the `getRouteExcludingApplicationContext()` method to
provide a special parent spring context that takes care of the
exclusion.

    @Override
    protected AbstractXmlApplicationContext createApplicationContext() {
        return new ClassPathXmlApplicationContext(new String[] {"routes-context.xml"}, getRouteExcludingApplicationContext());
    }

`RouteC` will now be excluded from initialization. Similarly, in another
test that is testing only `RouteC`, we could exclude RouteB and RouteA
by overriding the method `excludeRoutes`.

    @Override
    protected Class<?>[] excludeRoutes() {
        return new Class[]{RouteA.class, RouteB.class};
    }

# Using Spring XML

You can use Spring XML configuration to specify your XML Configuration
for Routes such as in the following

    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="
           http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
           http://camel.apache.org/schema/spring http://camel.apache.org/schema/spring/camel-spring.xsd
        ">
    
      <camelContext id="camel-A" xmlns="http://camel.apache.org/schema/spring">
        <route>
          <from uri="seda:start"/>
          <to uri="mock:result"/>
        </route>
      </camelContext>
    
    </beans>

# Configuring Components and Endpoints

You can configure your Component or Endpoint instances in your Spring
XML as follows:

      <camelContext id="camel" xmlns="http://camel.apache.org/schema/spring">
          <jmxAgent id="agent" disabled="true"/>
      </camelContext>
    
      <bean id="activemq" class="org.apache.camel.component.jms.JmsComponent">
        <property name="connectionFactory">
          <bean class="org.apache.activemq.ActiveMQConnectionFactory">
            <property name="brokerURL" value="vm://localhost?broker.persistent=false&amp;broker.useJmx=false"/>
          </bean>
        </property>
      </bean>

Which allows you to configure a component using some name (activemq in
the above example), then you can refer to the component using
**activemq:\[queue:\|topic:\]destinationName**. This works by the
SpringCamelContext lazily fetching components from the spring context
for the scheme name you use for Endpoint URIs.

For more details, see [Configuring Endpoints and
Components](#manual:faq:how-do-i-configure-endpoints.adoc).

# CamelContextAware

If you want the `CamelContext` to be injected in your POJO just
implement the `CamelContextAware` interface; then when Spring creates
your POJO, the `CamelContext` will be injected into your POJO. Also see
the [Bean Integration](#manual::bean-integration.adoc) for further
injections.

# Integration Testing

To avoid a hung route when testing using Spring Transactions, see the
note about Spring Integration Testing under Transactional Client.

# Cron Component Support

The `camel-spring` module can be used as implementation of the Camel
Cron component.

Maven users will need to add the following additional dependency to
their `pom.xml`:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-cron</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

Users can then use the cron component inside routes of their Spring or
Spring Boot application:

    <route>
      <from uri="cron:tab?schedule=0/1+*+*+*+*+?"/>
      <to uri="log:info"/>
    </route>
