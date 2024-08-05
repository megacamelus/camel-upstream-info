# Platform-http-jolokia.md

**Since Camel 4.5**

The Platform HTTP Jolokia component is used for Camel standalone to
expose Jolokia over HTTP using the embedded HTTP server.

Jolokia can be enabled as follows in `application.properties`:

    camel.server.enabled = true
    camel.server.jolokiaEnabled = true
