# Kotlin-api.md

**Since Camel 4.4**

This API is experimental support level and is not recommended being used
for production

Kotlin API provides alternative approach to define routes.

# Defining a route

To define route using Kotlin API you need to retrieve `CamelContext` and
pass it to function `camel`:

    import org.apache.camel.kotlin.camel
    
    val ctx: CamelContext = ...
    
    camel(ctx) { ... }

Then you can define route in `route` block:

    camel(ctx) {
        route { 
            from { 
                component("direct")
                url("input")
            }
            steps { 
                to {
                    component("mock")
                    url("output")
                }
            }
        }
    }

-   Definition of route

-   Definition of consuming endpoint

-   Definition of processing steps

You can find a number of handful methods in `route` block, for example,
setting route id:

    camel(ctx) {
        route {
            id("my-route")
        }
    }

# Defining endpoints

Here and further `camel(ctx)` block will be omitted to make code less
annoying.

## Raw endpoints

Raw endpoint constructs from three components: `component`, `url` and a
number of `property`-es. They all connected with each other and form
resulting uri by the following rule:

    "$component:$url?${property1.key}=${property1.value}&..."

So to define consumer from `netty-http` you can write the following:

    route {
        from {
            component("netty-http")
            url("http://localhost:8080")
            property("keepAlive", "false")
            property("reuseAddress", "false")
        }
    }

Also you can omit `component` and write only `url` by the following
schema:

    route {
        from {
            url("netty-http:http://localhost:8080")
            property("keepAlive", "false")
            property("reuseAddress", "false")
        }
    }

Moreover, you can omit `property` at all and write full uri in `url`
function:

    route {
        from {
            url("netty-http:http://localhost:8080?keepAlive=false&reuseAddress=false")
        }
    }

This three definitions are equivalent.

`property` method accepts only `String` value type. This is because it
builds raw uri, not `Endpoint`. That means that if you need to define
property of complex type, you must define bean in registry. Also that
behaviour may be very useful in the following situations:

-   usage of property placeholders

-   `toD` and `enrich` EIPs accepts simple language in uri, so it will
    be handful to use simple in property values

## Endpoint DSL

Defining string-based uris may not be very handy. So there is Endpoint
DSL for building uris. For each Camel component exists an extension
function with the name of that component. An example:

    import org.apache.camel.kotlin.components.`netty-http`
    import org.apache.camel.kotlin.components.mock
    
    route {
        from {
            `netty-http` {
                protocol("http")
                host("localhost")
                port(8080)
    
                keepAlive(false)
                reuseAddress(false)
            }
        }
        steps {
            to { mock { name("output") } }
        }
    }

Rules remain the same: all non-primitive types must be defined as beans
in registry and referenced in properties by `#name`.

# Defining EIPs

In that section we will take a look at several important EIPs to
demonstrate logic of their definition.

## Marshal, Unmarshal and DataFormat DSL

Marshal and Unmarshal EIPs come with DataFormat DSL. This DSL is the
only way to define both EIPs. Example:

    import org.apache.camel.kotlin.dataformats.csv
    
    route {
        from { direct { name("input") } }
        steps {
            unmarshal {
                csv {
                    delimiter(";")
                }
            }
        }
    }

## LoadBalance and nested DSLs

Some of EIPs provide additional complex configuration for their fields.
For example, Load Balance EIP: there we can define various variants of
which algorithm to use. So all that options are wrapped into their own
DSL. Example:

    route {
        from { direct { name("input") } }
        steps {
            loadBalance {
                failover {
                    maximumFailoverAttempts(1)
                }
            }
        }
    }

## Filter, Multicast, Pipeline and outputs

Some of EIPs defines their own subroutes, for example, Filter and
Multicast. In that cases use `outputs` property of EIP’s block. Filter
example:

    route {
        from { direct { name("input") } }
        steps {
            filter(constant("true")) {
                outputs {
                    log("only calls in filter block")
                }
            }
            log("calls after filter block executed")
        }
    }

Multicast example:

    route {
        from { direct { name("input") } }
        steps {
            multicast {
                outputs {
                    to { direct { name("first") } }
                    to { direct { name("second") } }
                }
            }
        }
    }

That behaviour differs for Pipeline EIP, which has not any properties
and so all nested steps defines in `pipeline` block:

    route {
        from { direct { name("input") } }
        steps {
            pipeline {
                log("first pipeline")
            }
            pipeline {
                log("second pipeline")
            }
        }
    }

# Defining beans

## Direct object binding

You can just provide instance of any type for Camel context:

    val map = mapOf<String, String>()
    
    camel(ctx) {
        bean("myMap", map)
    }

Or use supplier-function:

    camel(ctx) {
        bean("myMap") {
            mapOf<String, String>()
        }
    }

Or construct bean using builder:

    camel(ctx) {
        bean<MyClass>("myBean") {
            myField = "value"
        }
    }

## Runtime object binding

Use other way is to use declarative approach of defining beans, without
referencing beans at compile-time:

    class Example {
        lateinit var map: MutableMap<String, String>
    }
    
    camel(ctx) {
        bean("map", mutableMapOf(Pair("key", "value")))
        bean {
            name("test")
            type("org.apache.camel.kotlin.Example")
            property("map", "#map")
        }
    }

When you cross-reference beans like in example (bean `test` reference
`map`) be sure you declare beans in the dependency order: first
dependencies, last dependents.

# Using languages, expressions and predicates

There are a number of functions that provides Camel languages like
`constant` or `simple` and a number of helper functions for building
predicates/expressions like `body` or `header`. All of them are in the
package `org.apache.camel.kotlin.languages`.

There are two useful extension functions:

-   `Expression.toPredicate(): Predicate` converts any expression to
    predicate type

-   `Expression.which(): ValueBuilder` converts any expression to
    `ValueBuiler`, makes possible to write expressions like:
    
        body().which().isInstanceOf(String::class)

# Fallback to Java API

For `camel` block there is `routeBuilder` field which can help to define
any Camel entity using Java API. For each other block there is `def`
field present. It can be used if some functionality is missing. Example:

    route {
        from { direct { name("input") } }
        steps {
            def.pipeline().log("Java API").end()
        }
    }
