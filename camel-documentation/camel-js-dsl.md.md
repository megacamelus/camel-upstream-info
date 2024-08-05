# Js-dsl.md

**Since Camel 3.9**

This DSL is deprecated and experimental support level and is not
recommended being used for production.

The `js-dsl` is used for runtime compiling JavaScript routes in an
existing running Camel integration. This was invented for Camel K and
later ported to Apache Camel.

This means that Camel will load the `.js` source during startup and via
the JavaScript compiler transform this into Camel routes.

# Example

The following `hello.js` source file:

**hello.js**

    function proc(e) {
        e.getIn().setBody('Hello Camel K!')
    }
    
    from('timer:tick')
        .process(proc)
        .to('log:info')

Can then be loaded and run with Camel CLI or Camel K.

**Running with Camel K**

    kamel run hello.js

**Running with Camel CLI**

    camel run hello.js

# See Also

See [DSL](#manual:ROOT:dsl.adoc)
