# Jdbc

**Since Camel 1.2**

**Only producer is supported**

The JDBC component enables you to access databases through JDBC, where
SQL queries (SELECT) and operations (INSERT, UPDATE, etc.) are sent in
the message body. This component uses the standard JDBC API, unlike the
[SQL Component](#sql-component.adoc), which uses spring-jdbc.

When you use Spring and need to support Spring Transactions, use the
[Spring JDBC Component](#spring-jdbc-component.adoc) instead of this
one.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-jdbc</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

This component can only be used to define producer endpoints, which
means that you cannot use the JDBC component in a `from()` statement.

# URI format

    jdbc:dataSourceName[?options]

# Usage

## Result

By default, the result is returned in the OUT body as an
`ArrayList<HashMap<String, Object>>`. The `List` object contains the
list of rows and the `Map` objects contain each row with the `String`
key as the column name. You can use the option `outputType` to control
the result.

**Note:** This component fetches `ResultSetMetaData` to be able to
return the column name as the key in the `Map`.

## Generated keys

If you insert data using SQL INSERT, then the RDBMS may support auto
generated keys. You can instruct the [JDBC](#jdbc-component.adoc)
producer to return the generated keys in headers.  
To do that set the header `CamelRetrieveGeneratedKeys=true`. Then the
generated keys will be provided as headers with the keys listed in the
table above.

Using generated keys does not work together with named parameters.

## Using named parameters

In the given route below, we want to get all the projects from the
`projects` table. Notice the SQL query has two named parameters, `:?lic`
and `:?min`. Camel will then look up these parameters from the message
headers. Notice in the example above we set two headers with constant
value for the named parameters:

      from("direct:projects")
         .setHeader("lic", constant("ASF"))
         .setHeader("min", constant(123))
         .setBody("select * from projects where license = :?lic and id > :?min order by id")
         .to("jdbc:myDataSource?useHeadersAsParameters=true")

You can also store the header values in a `java.util.Map` and store the
map on the headers with the key `CamelJdbcParameters`.

# Examples

In the following example, we set up the DataSource that camel-jdbc
requires. First we register our datasource in the Camel registry as
`testdb`:

    EmbeddedDatabase db = new EmbeddedDatabaseBuilder()
          .setType(EmbeddedDatabaseType.DERBY).addScript("sql/init.sql").build();
    
    CamelContext context = ...
    context.getRegistry().bind("testdb", db);

Then we configure a route that routes to the JDBC component, so the SQL
will be executed. Note how we refer to the `testdb` datasource that was
bound in the previous step:

    from("direct:hello")
        .to("jdbc:testdb");

We create an endpoint, add the SQL query to the body of the IN message,
and then send the exchange. The result of the query is returned in the
*OUT* body:

    Endpoint endpoint = context.getEndpoint("direct:hello");
    Exchange exchange = endpoint.createExchange();
    // then we set the SQL on the in body
    exchange.getMessage().setBody("select * from customer order by ID");
    // now we send the exchange to the endpoint, and receive the response from Camel
    Exchange out = template.send(endpoint, exchange);

If you want to work on the rows one by one instead of the entire
ResultSet at once, you need to use the Splitter EIP such as:

    from("direct:hello")
    // here we split the data from the testdb into new messages one by one,
    // so the mock endpoint will receive a message per row in the table
    // the StreamList option allows streaming the result of the query without creating a List of rows
    // and notice we also enable streaming mode on the splitter
    .to("jdbc:testdb?outputType=StreamList")
      .split(body()).streaming()
      .to("mock:result");

## Polling the database every minute

If we want to poll a database using the JDBC component, we need to
combine it with a polling scheduler such as the
[Timer](#timer-component.adoc) or [Quartz](#quartz-component.adoc) etc.
In the following example, we retrieve data from the database every 60
seconds:

    from("timer://foo?period=60000")
      .setBody(constant("select * from customer"))
      .to("jdbc:testdb")
      .to("activemq:queue:customers");

## Move Data Between Data Sources

A common use case is to query for data, process it and move it to
another data source (ETL operations). In the following example, we
retrieve new customer records from the source table every hour,
filter/transform them and move them to a destination table:

    from("timer://MoveNewCustomersEveryHour?period=3600000")
        .setBody(constant("select * from customer where create_time > (sysdate-1/24)"))
        .to("jdbc:testdb")
        .split(body())
            .process(new MyCustomerProcessor()) //filter/transform results as needed
            .setBody(simple("insert into processed_customer values('${body[ID]}','${body[NAME]}')"))
            .to("jdbc:testdb");

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
