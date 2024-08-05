# Mongodb-gridfs

**Since Camel 2.18**

**Both producer and consumer are supported**

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-mongodb-gridfs</artifactId>
        <version>x.y.z</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    mongodb-gridfs:connectionBean?database=databaseName&bucket=bucketName[&moreOptions...]

# Configuration of a database in Spring XML

The following Spring XML creates a bean defining the connection to a
MongoDB instance.

    <beans xmlns="http://www.springframework.org/schema/beans"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
        <bean id="mongoBean" class="com.mongodb.Mongo">
            <constructor-arg name="host" value="${mongodb.host}" />
            <constructor-arg name="port" value="${mongodb.port}" />
        </bean>
    </beans>

# Sample route

The following route defined in Spring XML executes the operation
[**findOne**](#mongodb-gridfs-component.adoc) on a collection.

**Get a file from GridFS**

    <route>
      <from uri="direct:start" />
      <!-- using bean 'mongoBean' defined above -->
      <to uri="mongodb-gridfs:mongoBean?database=${mongodb.database}&amp;operation=findOne" />
      <to uri="direct:result" />
    </route>

# GridFS operations - producer endpoint

## count

Returns the total number of files in the collection, returning an
Integer as the OUT message body.

    // from("direct:count").to("mongodb-gridfs?database=tickets&operation=count");
    Integer result = template.requestBodyAndHeader("direct:count", "irrelevantBody");
    assertTrue("Result is not of type Long", result instanceof Integer);

You can provide a filename header to provide a count of files matching
that filename.

    Map<String, Object> headers = new HashMap<String, Object>();
    headers.put(Exchange.FILE_NAME, "filename.txt");
    Integer count = template.requestBodyAndHeaders("direct:count", query, headers);

## listAll

Returns a Reader that lists all the filenames and their IDs in a tab
separated stream.

    // from("direct:listAll").to("mongodb-gridfs?database=tickets&operation=listAll");
    Reader result = template.requestBodyAndHeader("direct:listAll", "irrelevantBody");
    
    filename1.txt   1252314321
    filename2.txt   2897651254

## findOne

Finds a file in the GridFS system and sets the body to an InputStream of
the content. Also provides the metadata has headers. It uses
`Exchange.FILE_NAME` from the incoming headers to determine the file to
find.

    // from("direct:findOne").to("mongodb-gridfs?database=tickets&operation=findOne");
    Map<String, Object> headers = new HashMap<String, Object>();
    headers.put(Exchange.FILE_NAME, "filename.txt");
    InputStream result = template.requestBodyAndHeaders("direct:findOne", "irrelevantBody", headers);

## create

Create a new file in the GridFs database. It uses the
`Exchange.FILE_NAME` from the incoming headers for the name and the body
contents (as an InputStream) as the content.

    // from("direct:create").to("mongodb-gridfs?database=tickets&operation=create");
    Map<String, Object> headers = new HashMap<String, Object>();
    headers.put(Exchange.FILE_NAME, "filename.txt");
    InputStream stream = ... the data for the file ...
    template.requestBodyAndHeaders("direct:create", stream, headers);

## remove

Removes a file from the GridFS database.

    // from("direct:remove").to("mongodb-gridfs?database=tickets&operation=remove");
    Map<String, Object> headers = new HashMap<String, Object>();
    headers.put(Exchange.FILE_NAME, "filename.txt");
    template.requestBodyAndHeaders("direct:remove", "", headers);

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|connectionBean|Name of com.mongodb.client.MongoClient to use.||string|
|bucket|Sets the name of the GridFS bucket within the database. Default is fs.|fs|string|
|database|Sets the name of the MongoDB database to target||string|
|readPreference|Sets a MongoDB ReadPreference on the Mongo connection. Read preferences set directly on the connection will be overridden by this setting. The com.mongodb.ReadPreference#valueOf(String) utility method is used to resolve the passed readPreference value. Some examples for the possible values are nearest, primary or secondary etc.||object|
|writeConcern|Set the WriteConcern for write operations on MongoDB using the standard ones. Resolved from the fields of the WriteConcern class by calling the WriteConcern#valueOf(String) method.||object|
|delay|Sets the delay between polls within the Consumer. Default is 500ms|500|duration|
|fileAttributeName|If the QueryType uses a FileAttribute, this sets the name of the attribute that is used. Default is camel-processed.|camel-processed|string|
|initialDelay|Sets the initialDelay before the consumer will start polling. Default is 1000ms|1000|duration|
|persistentTSCollection|If the QueryType uses a persistent timestamp, this sets the name of the collection within the DB to store the timestamp.|camel-timestamps|string|
|persistentTSObject|If the QueryType uses a persistent timestamp, this is the ID of the object in the collection to store the timestamp.|camel-timestamp|string|
|query|Additional query parameters (in JSON) that are used to configure the query used for finding files in the GridFsConsumer||string|
|queryStrategy|Sets the QueryStrategy that is used for polling for new files. Default is Timestamp|TimeStamp|object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|operation|Sets the operation this endpoint will execute against GridFs.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
