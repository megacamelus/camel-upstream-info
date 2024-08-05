# Kotlin-dsl.md

**Since Camel 3.9**

This DSL is experimental support level and is not recommended being used
for production

The `java-kotlin-dsl` is used for runtime compiling Kotlin routes in an
existing running Camel integration. This was invented for Camel K and
later ported to Apache Camel.

This means that Camel will load the `.kts` source during startup and let
Kotlin compile this to Java byte code.

# Example

The following `hello.kts` source file:

**hello.kts**

    from("timer:tick")
        .process { e -> e.getIn().body = "Hello Camel K!" }
        .to("log:info")

Can then be loaded and run with Camel CLI or Camel K.

**Running with Camel K**

    kamel run hello.kts

**Running with Camel CLI**

    camel run hello.kts

# Rest Example

REST endpoints can be configured using the top level *rest* block:

**my-rest.kts**

    rest {
        configuration {
            host = "localhost"
            port = "8080"
        }
    
        path("/hello") {
            get("/get") {
                produces("application/json")
                to("direct:get")
            }
        }
    
        path("/bye") {
            post("/post") {
                produces("application/json")
                to("direct:post")
            }
        }
    }
    
    from("direct:get")
        .process { e -> e.getIn().body = "{ 'message': 'Hello GET' }" }
    
    from("direct:post")
        .process { e -> e.getIn().body = "{ 'message': 'Hello POST' }" }

Can then be loaded and run with Camel CLI or Camel K.

**Running with Camel K**

    kamel run my-rest.kts

**Running with Camel CLI**

    camel run my-rest.kts

# See Also

See [DSL](#manual:ROOT:dsl.adoc)
