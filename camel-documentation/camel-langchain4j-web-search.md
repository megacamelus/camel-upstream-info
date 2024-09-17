# Langchain4j-web-search

**Since Camel 4.8**

**Only producer is supported**

The LangChain4j Web Search component provides support for web searching
using the [LangChain4j](https://docs.langchain4j.dev/) Web Search
Engines.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-langchain4j-web-search</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    langchain4j-web-search:searchId[?options]

Where **searchId** can be any string to uniquely identify the endpoint

# Usage

## Using a specific Web Search Engine

The Camel LangChain4j web search component provides an abstraction for
interacting with various types of Web Search Engines supported by
[LangChain4j](https://github.com/langchain4j/langchain4j).

To integrate with a specific Web Search Engine, users should follow the
steps described below, which explain how to integrate with
[Tavily](https://tavily.com/).

Add the dependency for LangChain4j Tavily Web Search Engine support :

    <dependency>
          <groupId>dev.langchain4j</groupId>
          <artifactId>langchain4j-web-search-engine-tavily</artifactId>
        <version>x.x.x</version>
    </dependency>

Initialize the Web Search Engine instance, and bind it to the Camel
Registry:

**Example:**

    @BindToRegistry("web-search-engine")
    WebSearchEngine tavilyWebSearchEngine = TavilyWebSearchEngine.builder()
        .apiKey(tavilyApiKey)
        .includeRawContent(true)
        .build();

The web search engine will be autowired automatically if its bound name
is `web-search-engine`. Otherwise, it should be added as a configured
parameter to the Camel route.

**Example:**

     from("direct:web-search")
          .to("langchain4j-web-search:test?webSearchEngine=#web-search-engine-test")

To switch to another Web Search Engine and its corresponding dependency,
replace the `langchain4j-web-search-engine-tavily` dependency with the
appropriate dependency for the desired web search engine. Update the
initialization parameters accordingly in the code snippet provided
above.

## Customizing Web Search Results

By default, the `maxResults` property is set to 1. You can adjust this
value to retrieve a list of results.

### Retrieving a single result or a list of strings

When `maxResults` is set to 1, you can by default retrieve by default
the content as a single string.

**Example:**

    String response = template.requestBody("langchain4j-web-search:test", "Who won the European Cup in 2024?", String.class);

When `maxResults` is greater than 1, you can retrieve a list of strings.

**Example:**

    List<String> responses = template.requestBody("langchain4j-web-search:test?maxResults=3", "Who won the European Cup in 2024?", List.class);

## Retrieving different types of Results

You can get different types of Results.

When `resultType` = SNIPPET, you will get a single or list (depending on
`maxResults` value) of Strings containing the snippets.

When `resultType` = LANGCHAIN4J\_WEB\_SEARCH\_ORGANIC\_RESULT, you will
get a single or list (depending on `maxResults` value) of Objects of
type `WebSearchOrganicResult` containing all the response created under
the hood by Langchain4j Web Search.

## Advanced usage of WebSearchRequest

When defining a WebSearchRequest, the Camel LangChain4j web search
component will default to this request, instead of creating one from the
body and config parameters.

When using a WebSearchRequest, the body and the parameters of the search
will be ignored. Use this parameter with caution.

A WebSearchRequest should be bound to the registry.

**Example of binding the request to the registry.**

    @BindToRegistry("web-search-request")
    WebSearchRequest request = WebSearchRequest.builder()
        .searchTerms("Who won the European Cup in 2024?")
        .maxResults(2)
        .build();

The request will be autowired automatically if its bound name is
`web-search-request`. Otherwise, it should be added as a configured
parameter to the Camel route.

**Example of route:**

     from("direct:web-search")
          .to("langchain4j-web-search:test?webSearchRequest=#searchRequestTest");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|searchId|The id||string|
|additionalParams|The additionalParams is the additional parameters for the search request are a map of key-value pairs that represent additional parameters for the search request.||object|
|geoLocation|The geoLocation is the desired geolocation for search results. Each search engine may have a different set of supported geolocations.||string|
|language|The language is the desired language for search results. The expected values may vary depending on the search engine.||string|
|maxResults|The maxResults is the expected number of results to be found if the search request were made. Each search engine may have a different limit for the maximum number of results that can be returned.|1|integer|
|resultType|The resultType is the result type of the request. Valid values are LANGCHAIN4J\_WEB\_SEARCH\_ORGANIC\_RESULT, CONTENT, or SNIPPET. CONTENT is the default value; it will return a list of String . You can also specify to return either the Langchain4j Web Search Organic Result object (using LANGCHAIN4J\_WEB\_SEARCH\_ORGANIC\_RESULT) or snippet (using SNIPPET) for each result. If maxResults is equal to 1, the response will be a single object instead of a list.|CONTENT|object|
|safeSearch|The safeSearch is the safe search flag, indicating whether to enable or disable safe search.||boolean|
|startIndex|The startIndex is the start index for search results, which may vary depending on the search engine.||integer|
|startPage|The startPage is the start page number for search results||integer|
|webSearchEngine|The WebSearchEngine engine to use. This is mandatory. Use one of the implementations from Langchain4j web search engines.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|webSearchRequest|The webSearchRequest is the custom WebSearchRequest - advanced||object|
