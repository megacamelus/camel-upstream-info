# Sql-stored

**Since Camel 2.17**

**Only producer is supported**

The SQL Stored component allows you to work with databases using JDBC
Stored Procedure queries. This component is an extension to the [SQL
Component](#sql-component.adoc) but specialized for calling stored
procedures.

This component uses `spring-jdbc` behind the scenes for the actual SQL
handling.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-sql</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

The SQL component uses the following endpoint URI notation:

    sql-stored:template[?options]

Where template is the stored procedure template, where you declare the
name of the stored procedure and the IN, INOUT, and OUT arguments.

You can also refer to the template in an external file on the file
system or classpath such as:

    sql-stored:classpath:sql/myprocedure.sql[?options]

Where `sql/myprocedure.sql` is a plain text file in the classpath with
the template, as show:

    SUBNUMBERS(
      INTEGER ${headers.num1},
      INTEGER ${headers.num2},
      INOUT INTEGER ${headers.num3} out1,
      OUT INTEGER out2
    )

# Usage

## Declaring the stored procedure template

The template is declared using a syntax that would be similar to a Java
method signature. The name of the stored procedure, and then the
arguments enclosed in parentheses. An example explains this well:

    <to uri="sql-stored:STOREDSAMPLE(INTEGER ${headers.num1},INTEGER ${headers.num2},INOUT INTEGER ${headers.num3} result1,OUT INTEGER result2)"/>

The arguments are declared by a type and then a mapping to the Camel
message using simple expression. So, in this example, the first two
parameters are `IN` values of `INTEGER` type, mapped to the message
headers. The third parameter is `INOUT`, meaning it accepts an `INTEGER`
and then returns a different `INTEGER` result. The last parameter is the
`OUT` value, also an `INTEGER` type.

In SQL terms, the stored procedure could be declared as:

    CREATE PROCEDURE STOREDSAMPLE(VALUE1 INTEGER, VALUE2 INTEGER, INOUT RESULT1 INTEGER, OUT RESULT2 INTEGER)

### IN Parameters

IN parameters take four parts separated by a space: parameter name, SQL
type (with scale), type name, and value source.

Parameter name is optional and will be auto generated if not provided.
It must be given between quotes(').

SQL type is required and can be an integer (positive or negative) or
reference to integer field in some class. If SQL type contains a dot,
then the component tries to resolve that class and read the given field.
For example, SQL type `com.Foo.INTEGER` is read from the field `INTEGER`
of class `com.Foo`. If the type doesn’t contain comma then class to
resolve the integer value will be `java.sql.Types`. Type can be
postfixed by scale for example `DECIMAL(10)` would mean
`java.sql.Types.DECIMAL` with scale 10.

Type name is optional and must be given between quotes(').

Value source is required. Value source populates the parameter value
from the Exchange. It can be either a Simple expression or header
location i.e. `:#<header name>`. For example, the Simple expression
`${header.val}` would mean that parameter value will be read from the
header `val`. Header location expression `:#val` would have identical
effect.

    <to uri="sql-stored:MYFUNC('param1' org.example.Types.INTEGER(10) ${header.srcValue})"/>

URI means that the stored procedure will be called with parameter name
`param1`, it’s SQL type is read from field `INTEGER` of class
`org.example.Types` and scale will be set to 10. The input value for the
parameter is passed from the header `srcValue`.

    <to uri="sql-stored:MYFUNC('param1' 100 'mytypename' ${header.srcValue})"/>

URI is identical to previous on except SQL-type is 100 and type name is
*mytypename*.

Actual call will be done using
org.springframework.jdbc.core.SqlParameter.

### OUT Parameters

OUT parameters work similarly IN parameters and contain three parts: SQL
type(with scale), type name, and output parameter name.

SQL type works the same as IN parameters.

Type name is optional and also works the same as IN parameters.

Output parameter name is used for the OUT parameter name, as well as the
header name where the result will be stored.

    <to uri="sql-stored:MYFUNC(OUT org.example.Types.DECIMAL(10) outheader1)"/>

URI means that the OUT parameter’s name is `outheader1` and result will
be but into header `outheader1`.

    <to uri="sql-stored:MYFUNC(OUT org.example.Types.NUMERIC(10) 'mytype' outheader1)"/>

This is identical to previous one but type name will be `mytype`.

Actual call will be done using
`org.springframework.jdbc.core.SqlOutParameter`.

### INOUT Parameters

INOUT parameters are a combination of all of the above. They receive a
value from the exchange, as well as store a result as a message header.
The only caveat is that the IN parameter’s "name" is skipped. Instead,
the OUT parameter’s *name* defines both the SQL parameter name, and the
result header name.

    <to uri="sql-stored:MYFUNC(INOUT DECIMAL(10) ${headers.inheader} outheader)"/>

Actual call will be done using
org.springframework.jdbc.core.SqlInOutParameter.

### Query Timeout

You can configure query timeout (via `template.queryTimeout`) on
statements used for query processing as shown:

    <to uri="sql-stored:MYFUNC(INOUT DECIMAL(10) ${headers.inheader} outheader)?template.queryTimeout=5000"/>

This will be overridden by the remaining transaction timeout when
executing within a transaction that has a timeout specified at the
transaction level.

## Camel SQL Starter

A starter module is available to spring-boot users. When using the
starter, the `DataSource` can be directly configured using spring-boot
properties.

    # Example for a mysql datasource
    spring.datasource.url=jdbc:mysql://localhost/test
    spring.datasource.username=dbuser
    spring.datasource.password=dbpass
    spring.datasource.driver-class-name=com.mysql.jdbc.Driver

To use this feature, add the following dependencies to your spring boot
pom.xml file:

    <dependency>
        <groupId>org.apache.camel.springboot</groupId>
        <artifactId>camel-sql-starter</artifactId>
        <version>${camel.version}</version> <!-- use the same version as your Camel core version -->
    </dependency>
    
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-jdbc</artifactId>
        <version>${spring-boot-version}</version>
    </dependency>

You should also include the specific database driver, if needed.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|dataSource|Sets the DataSource to use to communicate with the database.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|serviceLocationEnabled|Whether to detect the network address location of the JMS broker on startup. This information is gathered via reflection on the ConnectionFactory, and is vendor specific. This option can be used to turn this off.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|template|Sets the stored procedure template to perform. You can externalize the template by using file: or classpath: as prefix and specify the location of the file.||string|
|batch|Enables or disables batch mode|false|boolean|
|dataSource|Sets the DataSource to use to communicate with the database.||object|
|function|Whether this call is for a function.|false|boolean|
|noop|If set, will ignore the results of the stored procedure template and use the existing IN message as the OUT message for the continuation of processing|false|boolean|
|outputHeader|Store the template result in a header instead of the message body. By default, outputHeader == null and the template result is stored in the message body, any existing content in the message body is discarded. If outputHeader is set, the value is used as the name of the header to store the template result and the original message body is preserved.||string|
|useMessageBodyForTemplate|Whether to use the message body as the stored procedure template and then headers for parameters. If this option is enabled then the template in the uri is not used.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|templateOptions|Configures the Spring JdbcTemplate with the key/values from the Map||object|
