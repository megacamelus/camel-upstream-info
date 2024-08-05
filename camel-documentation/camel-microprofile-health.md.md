# Microprofile-health.md

**Since Camel 3.0**

The microprofile-health component is used for bridging [Eclipse
MicroProfile
Health](https://microprofile.io/project/eclipse/microprofile-health)
checks with Camel’s own Health Check API.

This enables you to write checks using the Camel health APIs and have
them exposed via MicroProfile Health readiness and liveness checks.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-microprofile-health</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# Usage

This component provides a custom `HealthCheckRegistry` implementation
that needs to be registered on the `CamelContext`.

    HealthCheckRegistry registry = new CamelMicroProfileHealthCheckRegistry();
    camelContext.setExtension(HealthCheckRegistry.class, registry);

By default, Camel health checks are registered as both MicroProfile
Health liveness and readiness checks. To have finer control over whether
a Camel health check should be considered either a readiness or liveness
check, you can extend `AbstractHealthCheck` and override the
`isLiveness()` and `isReadiness()` methods.

For example, to have a check registered exclusively as a liveness check:

    public class MyHealthCheck extends AbstractHealthCheck {
    
        public MyHealthCheck() {
            super("my-liveness-check-id");
            getConfiguration().setEnabled(true);
        }
    
        @Override
        protected void doCall(HealthCheckResultBuilder builder, Map<String, Object> options) {
            builder.detail("some-detail-key", "some-value");
    
            if (someSuccessCondition) {
                builder.up();
            } else {
                builder.down();
            }
        }
    
        public boolean isReadiness() {
            return false;
        }
    }
