# Flink

**Since Camel 2.18**

**Only producer is supported**

This documentation page covers the [Apache
Flink](https://flink.apache.org) component for the Apache Camel. The
**camel-flink** component provides a bridge between Camel components and
Flink tasks. This component provides a way to route a message from
various transports, dynamically choosing a flink task to execute, use an
incoming message as input data for the task and finally deliver the
results back to the Camel pipeline.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-flink</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI Format

Currently, the Flink Component supports only Producers. One can create
DataSet, DataStream jobs.

    flink:dataset?dataset=#myDataSet&dataSetCallback=#dataSetCallback
    flink:datastream?datastream=#myDataStream&dataStreamCallback=#dataStreamCallback

# Flink DataSet Callback

    @Bean
    public DataSetCallback<Long> dataSetCallback() {
        return new DataSetCallback<Long>() {
            public Long onDataSet(DataSet dataSet, Object... objects) {
                try {
                     dataSet.print();
                     return new Long(0);
                } catch (Exception e) {
                     return new Long(-1);
                }
            }
        };
    }

# Flink DataStream Callback

    @Bean
    public VoidDataStreamCallback dataStreamCallback() {
        return new VoidDataStreamCallback() {
            @Override
            public void doOnDataStream(DataStream dataStream, Object... objects) throws Exception {
                dataStream.flatMap(new Splitter()).print();
    
                environment.execute("data stream test");
            }
        };
    }

# Camel-Flink Producer call

    CamelContext camelContext = new SpringCamelContext(context);
    
    String pattern = "foo";
    
    try {
        ProducerTemplate template = camelContext.createProducerTemplate();
        camelContext.start();
        Long count = template.requestBody("flink:dataSet?dataSet=#myDataSet&dataSetCallback=#countLinesContaining", pattern, Long.class);
        } finally {
            camelContext.stop();
        }

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|dataSetCallback|Function performing action against a DataSet.||object|
|dataStream|DataStream to compute against.||object|
|dataStreamCallback|Function performing action against a DataStream.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|endpointType|Type of the endpoint (dataset, datastream).||object|
|collect|Indicates if results should be collected or counted.|true|boolean|
|dataSet|DataSet to compute against.||object|
|dataSetCallback|Function performing action against a DataSet.||object|
|dataStream|DataStream to compute against.||object|
|dataStreamCallback|Function performing action against a DataStream.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
