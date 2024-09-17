# Cli-connector.md

**Since Camel 3.19**

The camel-cli-connector allows the Camel CLI to be able to manage
running Camel integrations.

Currently, only a local connector is provided, which means that the
Camel CLI can only be managing local running Camel integrations.

These integrations can be using different runtimes such as Camel Main,
Camel Spring Boot or Camel Quarkus etc.

# Auto-detection from classpath

To use this implementation all you need to do is to add the
`camel-cli-connector` dependency to the classpath, and Camel should
auto-detect this on startup and log as follows:

    Local CLI Connector started
