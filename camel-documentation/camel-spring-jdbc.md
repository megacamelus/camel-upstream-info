# Spring-jdbc

**Since Camel 3.10**

**Only producer is supported**

The Spring JDBC component is an extension of the JDBC component with one
additional feature to integrate with Spring Transaction Manager.

For general use of this component, see the [JDBC
Component](#jdbc-component.adoc).

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-spring-jdbc</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|dataSource|To use the DataSource instance instead of looking up the data source by name from the registry.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|connectionStrategy|To use a custom strategy for working with connections. Do not use a custom strategy when using the spring-jdbc component because a special Spring ConnectionStrategy is used by default to support Spring Transactions.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|dataSourceName|Name of DataSource to lookup in the Registry. If the name is dataSource or default, then Camel will attempt to lookup a default DataSource from the registry, meaning if there is a only one instance of DataSource found, then this DataSource will be used.||string|
|allowNamedParameters|Whether to allow using named parameters in the queries.|true|boolean|
|outputClass|Specify the full package and class name to use as conversion when outputType=SelectOne or SelectList.||string|
|outputType|Determines the output the producer should use.|SelectList|object|
|parameters|Optional parameters to the java.sql.Statement. For example to set maxRows, fetchSize etc.||object|
|readSize|The default maximum number of rows that can be read by a polling query. The default value is 0.||integer|
|resetAutoCommit|Camel will set the autoCommit on the JDBC connection to be false, commit the change after executed the statement and reset the autoCommit flag of the connection at the end, if the resetAutoCommit is true. If the JDBC connection doesn't support to reset the autoCommit flag, you can set the resetAutoCommit flag to be false, and Camel will not try to reset the autoCommit flag. When used with XA transactions you most likely need to set it to false so that the transaction manager is in charge of committing this tx.|true|boolean|
|transacted|Whether transactions are in use.|false|boolean|
|useGetBytesForBlob|To read BLOB columns as bytes instead of string data. This may be needed for certain databases such as Oracle where you must read BLOB columns as bytes.|false|boolean|
|useHeadersAsParameters|Set this option to true to use the prepareStatementStrategy with named parameters. This allows to define queries with named placeholders, and use headers with the dynamic values for the query placeholders.|false|boolean|
|useJDBC4ColumnNameAndLabelSemantics|Sets whether to use JDBC 4 or JDBC 3.0 or older semantic when retrieving column name. JDBC 4.0 uses columnLabel to get the column name where as JDBC 3.0 uses both columnName or columnLabel. Unfortunately JDBC drivers behave differently so you can use this option to work out issues around your JDBC driver if you get problem using this component This option is default true.|true|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|beanRowMapper|To use a custom org.apache.camel.component.jdbc.BeanRowMapper when using outputClass. The default implementation will lower case the row names and skip underscores, and dashes. For example CUST\_ID is mapped as custId.||object|
|connectionStrategy|To use a custom strategy for working with connections. Do not use a custom strategy when using the spring-jdbc component because a special Spring ConnectionStrategy is used by default to support Spring Transactions.||object|
|prepareStatementStrategy|Allows the plugin to use a custom org.apache.camel.component.jdbc.JdbcPrepareStatementStrategy to control preparation of the query and prepared statement.||object|
