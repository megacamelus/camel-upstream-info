# Lucene

**Since Camel 2.2**

**Only producer is supported**

The Lucene component is based on the Apache Lucene project. Apache
Lucene is a powerful high-performance, full-featured text search engine
library written entirely in Java. For more details about Lucene, please
see the following links

-   [http://lucene.apache.org/java/docs/](http://lucene.apache.org/java/docs/)

-   [http://lucene.apache.org/java/docs/features.html](http://lucene.apache.org/java/docs/features.html)

The lucene component in camel facilitates integration and utilization of
Lucene endpoints in enterprise integration patterns and scenarios. The
lucene component does the following

-   builds a searchable index of documents when payloads are sent to the
    Lucene Endpoint

-   facilitates performing of indexed searches in Camel

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-lucene</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    lucene:searcherName:insert[?options]
    lucene:searcherName:query[?options]

# Usage

## Lucene Producers

This component supports 2 producer endpoints.

**insert**: the insert producer builds a searchable index by analyzing
the body in incoming exchanges and associating it with a token
("content"). **query**: the query producer performs searches on a
pre-created index. The query uses the searchable index to perform score
\& relevance based searches. Queries are sent via the incoming exchange
contains a header property name called *QUERY*. The value of the header
property *QUERY* is a Lucene Query. For more details on how to create
Lucene Queries, check out [Query Parser Classic
syntax](https://lucene.apache.org/core/8_4_1/queryparser/org/apache/lucene/queryparser/classic/package-summary.html#package.description)

## Lucene Processor

There is a processor called LuceneQueryProcessor available to perform
queries against lucene without the need to create a producer.

# Examples

Lucene usage samples.

## Example 1: Creating a Lucene index

    RouteBuilder builder = new RouteBuilder() {
        public void configure() {
           from("direct:start").
               to("lucene:whitespaceQuotesIndex:insert?
                   analyzer=#whitespaceAnalyzer&indexDir=#whitespace&srcDir=#load_dir").
               to("mock:result");
        }
    };

## Example 2: Loading properties into the JNDI registry in the Camel Context

    CamelContext context = new DefaultCamelContext(createRegistry());
    Registry registry = context.getRegistry();
    registry.bind("whitespace", new File("./whitespaceIndexDir"));
    registry.bind("load_dir", new File("src/test/resources/sources"));
    registry.bind("whitespaceAnalyzer", new WhitespaceAnalyzer());

## Example 2: Performing searches using a Query Producer

    RouteBuilder builder = new RouteBuilder() {
        public void configure() {
           from("direct:start").
              setHeader(LuceneConstants.HEADER_QUERY, constant("Seinfeld")).
              to("lucene:searchIndex:query?
                 analyzer=#whitespaceAnalyzer&indexDir=#whitespace&maxHits=20").
              to("direct:next");
    
           from("direct:next").process(new Processor() {
              public void process(Exchange exchange) throws Exception {
                 Hits hits = exchange.getIn().getBody(Hits.class);
                 printResults(hits);
              }
    
              private void printResults(Hits hits) {
                  LOG.debug("Number of hits: " + hits.getNumberOfHits());
                  for (int i = 0; i < hits.getNumberOfHits(); i++) {
                     LOG.debug("Hit " + i + " Index Location:" + hits.getHit().get(i).getHitLocation());
                     LOG.debug("Hit " + i + " Score:" + hits.getHit().get(i).getScore());
                     LOG.debug("Hit " + i + " Data:" + hits.getHit().get(i).getData());
                  }
               }
           }).to("mock:searchResult");
       }
    };

## Example 3: Performing searches using a Query Processor

    RouteBuilder builder = new RouteBuilder() {
        public void configure() {
            try {
                from("direct:start").
                    setHeader(LuceneConstants.HEADER_QUERY, constant("Rodney Dangerfield")).
                    process(new LuceneQueryProcessor("target/stdindexDir", analyzer, null, 20)).
                    to("direct:next");
            } catch (Exception e) {
                e.printStackTrace();
            }
    
            from("direct:next").process(new Processor() {
                public void process(Exchange exchange) throws Exception {
                    Hits hits = exchange.getIn().getBody(Hits.class);
                    printResults(hits);
                }
    
                private void printResults(Hits hits) {
                    LOG.debug("Number of hits: " + hits.getNumberOfHits());
                    for (int i = 0; i < hits.getNumberOfHits(); i++) {
                        LOG.debug("Hit " + i + " Index Location:" + hits.getHit().get(i).getHitLocation());
                        LOG.debug("Hit " + i + " Score:" + hits.getHit().get(i).getScore());
                        LOG.debug("Hit " + i + " Data:" + hits.getHit().get(i).getData());
                    }
                }
           }).to("mock:searchResult");
       }
    };

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|analyzer|An Analyzer builds TokenStreams, which analyze text. It thus represents a policy for extracting index terms from text. The value for analyzer can be any class that extends the abstract class org.apache.lucene.analysis.Analyzer. Lucene also offers a rich set of analyzers out of the box||object|
|indexDir|A file system directory in which index files are created upon analysis of the document by the specified analyzer||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|maxHits|An integer value that limits the result set of the search operation||integer|
|srcDir|An optional directory containing files to be used to be analyzed and added to the index at producer startup.||string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|config|To use a shared lucene configuration||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|host|The URL to the lucene server||string|
|operation|Operation to do such as insert or query.||object|
|analyzer|An Analyzer builds TokenStreams, which analyze text. It thus represents a policy for extracting index terms from text. The value for analyzer can be any class that extends the abstract class org.apache.lucene.analysis.Analyzer. Lucene also offers a rich set of analyzers out of the box||object|
|indexDir|A file system directory in which index files are created upon analysis of the document by the specified analyzer||string|
|maxHits|An integer value that limits the result set of the search operation||integer|
|srcDir|An optional directory containing files to be used to be analyzed and added to the index at producer startup.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
