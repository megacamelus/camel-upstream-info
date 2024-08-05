# Test-spring-junit5.md

**Since Camel 3.0**

The `camel-test-spring-junit5` module is used for testing Camel with
Spring; both the classic Spring XML files or Spring Boot.

# Testing Spring Boot

The recommended approach is to annotate the test class with
`org.apache.camel.test.spring.junit5.CamelSpringBootTest`. This replaces
the Junit4 `@RunWith` annotation using `SpringRunner.class` or
`CamelSpringBootRunner.class`. To enable autoconfiguration of the Camel
context and other Spring boot auto-configurable components, use the
annotation
`org.springframework.boot.autoconfigure.EnableAutoConfiguration`. The
Spring test context may be specified in one of three ways:

-   a nested class annotated with
    `org.springframework.context.annotation.Configuration`. This may
    define one or more Beans such as a `RouteBuilder`.

-   a `SpringBootTest` annotation with a classes parameter to specify
    the configuration class or classes. The `@SpringBootTest` annotation
    may also specify custom properties as shown in the example below.

-   a class annotated with `SpringBootConfiguration` accessible in the
    package of the test class or a parent package.

<!-- -->

    package com.foo;
    
    @CamelSpringBootTest
    @EnableAutoConfiguration
    @SpringBootTest(
        properties = { "camel.springboot.name=customName" }
    )
    class CamelSpringBootSimpleTest {
    
        @Autowired
        ProducerTemplate producerTemplate;
    
        @EndpointInject("mock:test")
        MockEndpoint mockEndpoint;
    
        //Spring context fixtures
        @Configuration
        static class TestConfig {
    
            @Bean
            RoutesBuilder route() {
                return new RouteBuilder() {
                    @Override
                    public void configure() throws Exception {
                        from("direct:test").to("mock:test");
                    }
                };
            }
        }
    
        @Test
        public void shouldAutowireProducerTemplate() {
            assertNotNull(producerTemplate);
        }
    
        @Test
        public void shouldSetCustomName() {
            assertEquals("customName", producerTemplate.getCamelContext().getName());
        }
    
        @Test
        public void shouldInjectEndpoint() throws InterruptedException {
            mockEndpoint.setExpectedMessageCount(1);
            producerTemplate.sendBody("direct:test", "msg");
            mockEndpoint.assertIsSatisfied();
        }
    }

# Testing classic Spring XML

There are multiple approaches to test Camel Spring 5.x based routes with
JUnit 5. An approach is to extend
`org.apache.camel.test.spring.junit5.CamelSpringTestSupport`, for
instance:

    public class SimpleMockTest extends CamelSpringTestSupport {
    
        @EndpointInject("mock:result")
        protected MockEndpoint resultEndpoint;
    
        @Produce("direct:start")
        protected ProducerTemplate template;
    
        @Override
        protected AbstractApplicationContext createApplicationContext() {
            // loads a Spring XML file
            return new ClassPathXmlApplicationContext("org/apache/camel/test/patterns/SimpleMockTest.xml");
        }
    
        @Test
        public void testMock() throws Exception {
            String expectedBody = "Hello World";
            resultEndpoint.expectedBodiesReceived(expectedBody);
            template.sendBodyAndHeader(expectedBody, "foo", "bar");
            resultEndpoint.assertIsSatisfied();
        }
    }

The example above is loading a classic Spring XML file (has `<beans>` as
root tag).

This approach provides feature parity with
`org.apache.camel.test.junit5.CamelTestSupport` from
[camel-test-junit5](#components:others:test-junit5.adoc) but does not
support Spring annotations on the test class such as `@Autowired`,
`@DirtiesContext`, and `@ContextConfiguration`.

Instead of instantiating the `CamelContext` and routes programmatically,
this class relies on a Spring context to wire the needed components
together. If your test extends this class, you must provide the Spring
context by implementing the following method:

    protected abstract AbstractApplicationContext createApplicationContext();

## Using the `@CamelSpringTest` annotation

A better and recommended approach involves the usage of the
`org.apache.camel.test.spring.junit5.CamelSpringTest` annotation, as
shown:

    package com.foo;
    
    @CamelSpringTest
    @ContextConfiguration
    @DirtiesContext(classMode = ClassMode.AFTER_EACH_TEST_METHOD)
    public class CamelSpringPlainTest {
    
        @Autowired
        protected CamelContext camelContext;
    
        @EndpointInject("mock:a")
        protected MockEndpoint mockA;
    
        @EndpointInject("mock:b")
        protected MockEndpoint mockB;
    
        @Produce("direct:start")
        protected ProducerTemplate start;
    
        @Test
        public void testPositive() throws Exception {
            assertEquals(ServiceStatus.Started, camelContext.getStatus());
    
            mockA.expectedBodiesReceived("David");
            mockB.expectedBodiesReceived("Hello David");
    
            start.sendBody("David");
    
            MockEndpoint.assertIsSatisfied(camelContext);
        }
    }

The above test will by default load a Spring XML file using the naming
pattern *className*-context.xml, which means the example above loads the
file `com/foo/CamelSpringPlainTest-context.xml`.

This XML file is Spring XML file as shown:

    <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns="http://www.springframework.org/schema/beans"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="
                    http://camel.apache.org/schema/spring http://camel.apache.org/schema/spring/camel-spring.xsd
                    http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd ">
    
            <camelContext id="camelContext" xmlns="http://camel.apache.org/schema/spring">
                    <route>
                            <from uri="direct:start"/>
                            <to uri="mock:a"/>
                            <transform>
                                    <simple>Hello ${body}</simple>
                            </transform>
                            <to uri="mock:b"/>
                    </route>
            </camelContext>
    </beans>

This approach supports both Camel and Spring annotations, such as
`@Autowired`, `@DirtiesContext`, and `@ContextConfiguration`. However,
it does NOT have feature parity with
`org.apache.camel.test.junit5.CamelTestSupport`.

# Camel test annotations

The following annotations can be used with `camel-spring-junit5` unit
testing.

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 80%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Annotation</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>@CamelSpringBootTest</code></p></td>
<td style="text-align: left;"><p>Used for testing Camel with Spring
Boot</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>@CamelSpringTest</code></p></td>
<td style="text-align: left;"><p>Used for testing Camel with classic
Spring XML (not Spring Boot)</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>@DisableJmx</code></p></td>
<td style="text-align: left;"><p>Used for disabling JMX</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>@EnableRouteCoverage</code></p></td>
<td style="text-align: left;"><p>Enables dumping route coverage
statistics. The route coverage status is written as xml files in the
<code>target/camel-route-coverage</code> directory after the test has
finished. See more information at <a
href="#manual::camel-report-maven-plugin.adoc">Camel Maven Report
Plugin</a>.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>@ExcludeRoutes</code></p></td>
<td style="text-align: left;"><p>Indicates if certain route builder
classes should be excluded from package scan discovery</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>@MockEndpoints</code></p></td>
<td style="text-align: left;"><p>Auto-mocking of endpoints whose URIs
match the provided filter. For more information, see <a
href="#manual::advice-with.adoc">Advice With</a>.</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>@MockEndpointsAndSkip</code></p></td>
<td style="text-align: left;"><p>Auto-mocking of endpoints whose URIs
match the provided filter with the added provision that the endpoints
are also skipped. For more information, see <a
href="#manual::advice-with.adoc">Advice With</a>.</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>@ProvidesBreakpoint</code></p></td>
<td style="text-align: left;"><p>Indicates that the annotated method
returns a <code>Breakpoint</code> for use in the test. Useful for
intercepting traffic to all endpoints or simply for setting a break
point in an IDE for debugging. The method must be
<code>public static</code>, take no arguments, and return
<code>Breakpoint</code>.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>@ShutdownTimeout</code></p></td>
<td style="text-align: left;"><p>Timeout to use for <a
href="#manual::graceful-shutdown.adoc">shutdown</a>. The default is 10
seconds.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>@UseAdviceWith</code></p></td>
<td style="text-align: left;"><p>To enable testing with <a
href="#manual::advice-with.adoc">Advice With</a>.</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>@UseOverridePropertiesWithPropertiesComponent</code></p></td>
<td style="text-align: left;"><p>To use custom <code>Properties</code>
with the <a href="#ROOT:properties-component.adoc">Properties</a>
component. The annotated method must be <code>public</code> and return
<code>Properties</code>.</p></td>
</tr>
</tbody>
</table>

# Migrating Camel Spring Tests from JUnit 4 to JUnit 5

Find below some hints to help in migrating Camel Spring tests from JUnit
4 to JUnit 5.

Projects using `camel-test-spring` would need to use
`camel-test-spring-junit5`. For instance, maven users would update their
pom.xml file as below:

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-test-spring-junit5</artifactId>
      <scope>test</scope>
    </dependency>

It’s possible to run JUnit 4 \& JUnit 5 based Camel Spring tests side by
side including the following dependencies `camel-test-spring`,
`camel-test-spring-junit5` and `junit-vintage-engine`. This
configuration allows migrating Camel tests one by one.

## Migration steps

-   Migration steps from
    [camel-test-junit5](#components:others:test-junit5.adoc) should have
    been applied first

-   Imports of `org.apache.camel.test.spring.\*` should be replaced with
    `org.apache.camel.test.spring.junit5.*`

-   Usage of `@RunWith(CamelSpringRunner.class)` should be replaced with
    `@CamelSpringTest`

-   Usage of `@BootstrapWith(CamelTestContextBootstrapper.class)` should
    be replaced with `@CamelSpringTest`

-   Usage of `@RunWith(CamelSpringBootRunner.class)` should be replaced
    with `@CamelSpringBootTest`
