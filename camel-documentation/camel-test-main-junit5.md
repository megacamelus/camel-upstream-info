# Test-main-junit5.md

**Since Camel 3.16**

The `camel-test-main-junit5` module is used for unit testing Camel
launched in Standalone mode with Camel Main.

This module proposes two approaches to configure and launch Camel like a
Camel Main application for testing purpose.

-   **Legacy**: This approach consists of extending the base class
    `org.apache.camel.test.main.junit5.CamelMainTestSupport` and
    overriding the appropriate methods to enable or disable a feature.

-   **Annotation**: This approach consists of annotating the test
    classes with `org.apache.camel.test.main.junit5.CamelMainTest` with
    the appropriate attributes to enable or disable a feature.

In the next section, for each use case both approaches are proposed with
the labels **legacy** and **annotation** to differentiate them.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-test-main-junit5</artifactId>
        <scope>test</scope>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# Specify a main class

Most of the time, a Camel Main application has a main class from which
all the Camel related classes are found.

In practice, this is done simply by providing the main class of the
application in the constructor of Camel Main like for example
`new Main(SomeApplication.class)` where `SomeApplication.class` is the
main class of the application.

## Legacy

The same behavior can be simulated with `CamelMainTestSupport` by
overriding the method `getMainClass()` to provide the main class of the
application to test.

## Annotation

The same behavior can be simulated with `CamelMainTest` by setting the
attribute `mainClass` to provide the main class of the application to
test.

## Examples

In the next examples, the main class of the application to test is the
class `SomeMainClass`.

Legacy  
class SomeTest extends CamelMainTestSupport {

        @Override
        protected Class<?> getMainClass() {
            return SomeMainClass.class;
        }
    
        // Rest of the test class
    }

Annotation  
@CamelMainTest(mainClass = SomeMainClass.class)
class SomeTest {

        // Rest of the test class
    }

# Configure Camel as a Camel Main application

A Camel Main application has access to many specific configuration
properties that are not available from the base class
`CamelTestSupport`.

## Legacy

The base class `CamelMainTestSupport` provides the method
`configure(MainConfigurationProperties configuration)` that can be
overridden to configure Camel for the test like a Camel Main
application.

## Annotation

The annotation `Configure` allows to mark a method with an arbitrary
name and a parameter of type `MainConfigurationProperties` to be called
to configure Camel for the test like a Camel Main application. Several
methods in the test class and/or its parent classes can be annotated.

## Examples

In the next examples, the test class `SomeTest` adds a configuration
class and specifies the XML routes to include.

Legacy  
import org.apache.camel.main.MainConfigurationProperties;

    class SomeTest extends CamelMainTestSupport {
    
        @Override
        protected void configure(MainConfigurationProperties configuration) {
            // Add a configuration class
            configuration.addConfiguration(SomeConfiguration.class);
            // Add all the XML routes
            configuration.withRoutesIncludePattern("routes/*.xml");
        }
    
        // Rest of the test class
    }

Annotation  
import org.apache.camel.main.MainConfigurationProperties;
import org.apache.camel.test.main.junit5.Configure;

    @CamelMainTest
    class SomeTest {
    
        @Configure
        protected void configure(MainConfigurationProperties configuration) {
            // Add a configuration class
            configuration.addConfiguration(SomeConfiguration.class);
            // Add all the XML routes
            configuration.withRoutesIncludePattern("routes/*.xml");
        }
    
        // Rest of the test class
    }

# Configure a custom property placeholder location

By default, the property placeholder used is `application.properties`
from the default package. There are several ways to configure the
property placeholder locations, you can either provide the file name of
the property placeholder or a list of locations.

## A list of property placeholder locations

## Legacy

The method `getPropertyPlaceholderLocations()` can be overridden to
provide a comma separated list of locations.

## Annotation

The attribute `propertyPlaceholderLocations` can be set to provide a
list of locations.

The order in the list matters, especially in case of a property defined
at several locations, the value of the property found in the first
location where it is defined, is used.

## Examples

In the next examples, the property placeholder locations configured are
`extra-application.properties` and `application.properties` both
available in the default package.

Legacy  
class SomeTest extends CamelMainTestSupport {

        @Override
        protected String getPropertyPlaceholderLocations() {
            return "classpath:extra-application.properties,classpath:application.properties";
        }
    
        // Rest of the test class
    }

Annotation  
@CamelMainTest(propertyPlaceholderLocations = { "classpath:extra-application.properties", "classpath:application.properties" })
class SomeTest {

        // Rest of the test class
    }

## The file name of the property placeholder

For the sake of simplicity, in case you need only one property
placeholder location.

## Legacy

The method `getPropertyPlaceholderFileName()` can be overridden to
provide the file name of the property placeholder.

## Annotation

The attribute `propertyPlaceholderFileName` can be set to provide the
file name of the property placeholder.

It can then infer the locations of the property placeholder as it
assumes that it is located either in the same package as the test class
or directly in the default package.

## Examples

In the next examples, since the test class is `com.somecompany.SomeTest`
and the file name of the property placeholder is
`custom-application.properties` , the actual possible locations of the
property placeholder are
`classpath:com/somecompany/custom-application.properties;optional=true,classpath:custom-application.properties;optional=true`
which means that for each property to find, it tries to get it first
from the properties file of the same package if it exists and if it
cannot be found, it tries to get it from the properties file with the
same name but in the default package if it exists.

Since the properties files are declared as optional, no exception is
raised if they are both absent.

Legacy  
package com.somecompany;

    class SomeTest extends CamelMainTestSupport {
    
        @Override
        protected String getPropertyPlaceholderFileName() {
            return "custom-application.properties";
        }
    
        // Rest of the test class
    }

Annotation  
package com.somecompany;

    @CamelMainTest(propertyPlaceholderFileName = "custom-application.properties")
    class SomeTest {
    
        // Rest of the test class
    }

# Replace an existing bean

In Camel Main, you have the opportunity to bind custom beans dynamically
using the specific annotation `@BindToRegistry` which is very helpful
but for testing purpose, you may need to replace the bean by a mock, or
test implementation.

## Legacy

To bind additional beans, you can still override the well known method
`bindToRegistry(Registry registry)` but this method cannot be used to
replace a bean created and bound automatically by Camel as it is called
too early in the initialization process of Camel. To work around this
problem, you can instead bind your beans by overriding the new method
`bindToRegistryAfterInjections(Registry registry)` which is called after
existing injections and automatic binding have been done.

## Annotation

The annotation `ReplaceInRegistry` allows to mark a method or a field to
replace an existing bean in the registry.

-   In the case of a field, the name and its type are used to identify
    the bean to replace, and the value of the field is the new value of
    the bean. The field can be in the test class or in a parent class.

-   In the case of a method, the name and its return type are used to
    identify the bean to replace, and the return value of the method is
    the new value of the bean. The method can be in the test class or in
    a parent class.

## Examples

In the next examples, an instance of a custom bean of type
`CustomGreetings` is used to replace the bean of type `Greetings`
automatically bound by Camel with the name `myGreetings`.

Legacy  
class SomeTest extends CamelMainTestSupport {

        @PropertyInject("name")
        String name;
    
        @Override
        protected void bindToRegistryAfterInjections(Registry registry) throws Exception {
            registry.bind("myGreetings", Greetings.class, new CustomGreetings(name));
        }
    
        // Rest of the test class
    }

Annotation (field)  
**Using a field**

    import org.apache.camel.test.main.junit5.ReplaceInRegistry;
    
    @CamelMainTest
    class SomeTest {
    
        @ReplaceInRegistry
        Greetings myGreetings = new CustomGreetings("Willy"); // 
    
        // Rest of the test class
    }

-   We cannot rely on the value of property that is injected thanks to
    `@PropertyInject` like in the previous code snippet because the
    injection occurs after the instantiation of the test class, so it
    would be `null`.

Annotation (method)  
**Using a method**

    import org.apache.camel.test.main.junit5.ReplaceInRegistry;
    
    @CamelMainTest
    class SomeTest {
    
        @PropertyInject("name")
        String name;
    
        @ReplaceInRegistry
        Greetings myGreetings() {
            return new CustomGreetings(name);
        }
    
        // Rest of the test class
    }

# Override existing properties

Some properties are inherited from properties file like the
`application.properties` and need to be overridden within the context of
the test.

## Legacy

The method `useOverridePropertiesWithPropertiesComponent()` can be
overridden to provide an instance of type `java.util.Properties` that
contains the properties to override.

## Annotation

The attribute `properties` can be set to provide an array of `String`
representing the key/value pairs of properties to override in the
following format
`"property-key-1=property-value-1", "property-key-2=property-value-1", ...`.

## Examples

In the next examples, the value of the property whose name is `host` is
replaced with `localhost`.

Legacy  
import static org.apache.camel.util.PropertiesHelper.asProperties;

    class SomeTest extends CamelMainTestSupport {
    
        @Override
        protected Properties useOverridePropertiesWithPropertiesComponent() {
            return asProperties("host", "localhost");
        }
    
        // Rest of the test class
    }

Annotation  
@CamelMainTest(properties = { "host=localhost" })
class SomeTest {

        // Rest of the test class
    }

# Replace from endpoints

To be able to test easily the behavior of a route without being affected
by the type of `_from_` endpoint used in the route, it can be very
helpful to replace the `_from_` endpoint with an endpoint more test
friendly.

## Legacy

The method `replaceRouteFromWith()` can be called to provide the id of
the route to modify and the URI of the new `_from_` endpoint.

## Annotation

The attribute `replaceRouteFromWith` can be set to provide an array of
`String` representing a list of route IDs to modify and the URI of the
new `_from_` endpoint in the following format
`"route-id-1=new-uri-1", "route-id-2=new-uri-2", ...`.

## Examples

In the next examples, the route whose id is `main-route` is advised to
replace its current from endpoint with a `direct:main` endpoint.

Legacy  
class SomeTest extends CamelMainTestSupport {

        @Override
        @BeforeEach
        public void setUp() throws Exception {
            replaceRouteFromWith("main-route", "direct:main");
            super.setUp();
        }
    
        // Rest of the test class
    }

Annotation  
@CamelMainTest(replaceRouteFromWith = { "main-route=direct:main" })
class SomeTest {

        // Rest of the test class
    }

# Configure additional camel configuration classes

In practice, additional camel configuration classes can be provided for
the sake of simplicity directly from the constructor of the Camel Main
like for example
`new Main(SomeApplication.class, SomeCamelConfiguration.class)` where
`SomeApplication.class` is the main class of the application and
`SomeCamelConfiguration.class` is an additional camel configuration
class.

## Legacy

There is no specific method for that, but it can be done by overriding
the method `configure(MainConfigurationProperties configuration)` like
described in a previous section.

## Annotation

The attribute `configurationClasses` can be set to provide an array of
additional camel configuration classes.

## Examples

In the next examples, the camel configuration class
`SomeCamelConfiguration` is added to the global configuration.

Legacy  
class SomeTest extends CamelMainTestSupport {

        @Override
        protected void configure(MainConfigurationProperties configuration) {
            // Add the configuration class
            configuration.addConfiguration(SomeCamelConfiguration.class);
        }
    
        // Rest of the test class
    }

Annotation  
@CamelMainTest(configurationClasses = SomeCamelConfiguration.class)
class SomeTest {

        // Rest of the test class
    }

# Advice a route

It is possible to modify a route within the context of a test by using
advices generally represented by specific route builders of type
`AdviceWithRouteBuilder` as it proposes out-of-box utility methods
allowing to advice a route easily.

## Legacy

A route needs to be advised directly in the test method using one of the
utility method `AdviceWith.adviceWith` and the Camel context has to be
started explicitly once the route has been advised to take it into
account.

## Annotation

The attribute `advices` can be set to provide an array of annotations of
type `AdviceRouteMapping` representing a mapping between a route to
advice and the corresponding route builders to call to advice the route.
As the route builders are instantiated using the default constructor,
make sure that the default constructor exists.

## Examples

In the next examples, the route whose id is `main-route` is advised to
replace its current from endpoint with a `direct:main` endpoint.

Legacy  
class SomeTest extends CamelMainTestSupport {

        @Override
        public boolean isUseAdviceWith() { // 
            return true;
        }
    
        @Test
        void someTest() throws Exception {
            // Advice the route to replace the from endpoint
            AdviceWith.adviceWith(context, "main-route", ad -> ad.replaceFromWith("direct:main")); // 
    
            // must start Camel after we are done using advice-with
            context.start(); // 
    
            // Rest of the test method
        }
    
        // Rest of the test class
    }

-   Override the method `isUseAdviceWith` to return `true` indicating
    that the Camel context should not be started before calling the test
    method as there is at least one route to advise.

-   Call a utility method `AdviceWith.adviceWith` to advice a route

-   Start the Camel context as it was not yet started

Annotation  
@CamelMainTest(advices = @AdviceRouteMapping(route = "main-route", advice = SomeTest.SomeRouteBuilder.class))
class SomeTest {

        static class SomeRouteBuilder extends AdviceWithRouteBuilder {
    
            @Override
            public void configure() throws Exception {
                replaceFromWith("direct:main");
            }
        }
    
        // Rest of the test class
    }

# Mock and skip an endpoint

For testing purpose, it can be helpful to mock only or to mock and skip
all the endpoints matching with a given pattern.

## Legacy

The method `isMockEndpoints()` can be overridden to provide the pattern
that should match with the endpoints to mock. The method
`isMockEndpointsAndSkip()` can be overridden to provide the pattern that
should match with the endpoints to mock and skip.

## Annotation

The attribute `mockEndpoints` can be set to provide the pattern that
should match with the endpoints to mock. The attribute
`mockEndpointsAndSkip` can be set to provide the pattern that should
match with the endpoints to mock and skip.

## Examples

In the next examples, the endpoints whose URI starts with `direct:` are
mocked.

Legacy  
class SomeTest extends CamelMainTestSupport {

        @Override
        public String isMockEndpoints() {
            return "direct:*";
        }
    
        // Rest of the test class
    }

Annotation  
@CamelMainTest(mockEndpoints = "direct:\*")
class SomeTest {

        // Rest of the test class
    }

# Dump route coverage

It is possible to dump the route coverage of a given test. This feature
needs JMX to be enabled which is done automatically when the feature
itself is enabled, it also means that the `camel-management` has to be
part of the dependencies of the project to be able to use it. The
feature can be enabled globally by setting the system property
`CamelTestRouteCoverage` to `true`.

The result is generated in
`target/camel-route-coverage/_class-name_-_test-name_.xml`.

## Legacy

The method `isDumpRouteCoverage()` can be overridden to return `true`
indicating that the feature is enabled.

## Annotation

The attribute `dumpRouteCoverage` can be set to `true` indicating that
the feature is enabled.

# Override the shutdown timeout

The default shutdown timeout of Camel is not really adapted for a test
as it can be very long. This feature allows overriding it to 10 seconds
by default, but it can also be set to a custom value knowing that it is
expressed in seconds.

## Legacy

The method `getShutdownTimeout()` can be overridden to return the
expected shutdown timeout.

## Annotation

The attribute `shutdownTimeout` can be set to the expected shutdown
timeout.

# Debug mode

For debugging purpose, it is possible to be called before and after
invoking a processor allowing you to log specific messages or add
breakpoints in your favorite IDE.

## Legacy

The method `isUseDebugger()` can be overridden to return `true`
indicating that the feature is enabled. The methods `debugBefore` and
`debugAfter` can then be overridden to execute some specific code for
debugging purpose.

## Annotation

The test class needs to implement the interface
`org.apache.camel.test.main.junit5.DebuggerCallback` to enable the
feature. The methods `debugBefore` and `debugAfter` can then be
implemented to execute some specific code for debugging purpose.

# Enable JMX

JMX is disabled by default when launching the tests, however, if needed,
it is still possible to enable it.

## Legacy

The method `useJmx()` can be overridden to return `true`. It returns
`false` by default.

## Annotation

The attribute `useJmx` can be set to `true`. It is set to `false` by
default.

## Examples

In the next examples, JMX has been enabled for the test.

Legacy  
class SomeTest extends CamelMainTestSupport {

        @Override
        protected boolean useJmx() {
            return true;
        }
    
        // Rest of the test class
    }

Annotation  
@CamelMainTest(useJmx = true)
class SomeTest {

        // Rest of the test class
    }

# Nested tests

The annotation-based approach supports natively [Nested
tests](https://junit.org/junit5/docs/current/user-guide/#writing-tests-nested).
It is even possible to annotate `@Nested` test class with
`@CamelMainTest` to change the configuration inherited from the outer
class. However, please note that not all attributes can be set at nested
test class level. Indeed, for the sake of simplicity, the attributes
`dumpRouteCoverage` and `shutdownTimeout` can only be set at outer class
level.

According to the total number of values accepted by an attribute, if a
`@Nested` test class set this attribute, the behavior can change:

-   In case of **multivalued** attributes like `properties`,
    `replaceRouteFromWith`, `configurationClasses` and `advices`, the
    values set on the `@Nested` test class are added to the values of
    the outer classes, and the resulting values are ordered from
    outermost to innermost.

-   In case of **mono-valued** attributes like `mainClass`,
    `propertyPlaceholderFileName`, `mockEndpoints` and
    `mockEndpointsAndSkip`, the value set on the innermost class is
    used.

The only exception is the attribute `propertyPlaceholderLocations` that
behaves like a mono-valued attribute. Because it is tightly coupled with
`propertyPlaceholderFileName`, so it must have the same behavior for the
sake of consistency.

To have a better understanding of the behavior for each type of
attribute, please check the following examples:

## Multivalued

In the next example, the property `some-property` is set to `foo` for
all the tests in `SomeTest` including the tests in `SomeNestedTest`.
Additionally, the property `some-other-property` is set to `bar` but
only for all the tests in `SomeNestedTest`.

    @CamelMainTest(properties = { "some-property=foo" })
    class SomeTest {
    
        @Nested
        @CamelMainTest(properties = { "some-other-property=bar" })
        class SomeNestedTest {
    
            // Rest of the nested test class
        }
    
        // Rest of the test class
    }

## Mono-valued

In the next example, `SomeMainClass` is used as the main class for all
the tests directly inside `SomeTest`, but also the tests in the
`@Nested` test class `SomeOtherNestedTest` as it is not redefined.
`SomeOtherMainClass` is used as the main class for all the tests
directly inside `SomeNestedTest`, but also the tests in the `@Nested`
test class `SomeDeeplyNestedTest` as it is not redefined.

    @CamelMainTest(mainClass = SomeMainClass.class)
    class SomeTest {
    
        @CamelMainTest(mainClass = SomeOtherMainClass.class)
        @Nested
        class SomeNestedTest {
    
            @Nested
            class SomeDeeplyNestedTest {
    
               // Rest of the nested test class
            }
    
           // Rest of the nested test class
        }
    
        @Nested
        class SomeOtherNestedTest {
    
           // Rest of the nested test class
        }
    
        // Rest of the test class
    }

The annotations `@Configure` and `@ReplaceInRegistry` can also be used
on methods or fields inside `@Nested` test classes knowing that the
annotations of outer classes are processed before the annotations of
inner classes.
