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

# Using a specific Web Search Engine

The Camel LangChain4j web search component provides an abstraction for
interacting with various types of Web Search Engines supported by
[LangChain4j](https://github.com/langchain4j/langchain4j).

To integrate with a specific Web Search Engine, users should follow
these steps:

## Example of integrating with Tavily

Add the dependency for LangChain4j Tavily Web Search Engine support :

    <dependency>
          <groupId>dev.langchain4j</groupId>
          <artifactId>langchain4j-web-search-engine-tavily</artifactId>
        <version>x.x.x</version>
    </dependency>

Init the Tavily Web Search Engine, and add it to the Camel Registry:
Initialize the Tavily Web Search Engine, and bind it to the Camel
Registry:

    @BindToRegistry("web-search-engine")
    WebSearchEngine tavilyWebSearchEngine = TavilyWebSearchEngine.builder()
        .apiKey(tavilyApiKey)
        .includeRawContent(true)
        .build();

The web search engine will be autowired automatically if its bound name
is `web-search-engine`. Otherwise, it should be added as a configured
parameter to the Camel route.

Example of route:

     from("direct:web-search")
          .to("langchain4j-web-search:test?webSearchEngine=#web-search-engine-test")

To switch to another Web Search Engine and its corresponding dependency,
replace the `langchain4j-web-search-engine-tavily` dependency with the
appropriate dependency for the desired web search engine. Update the
initialization parameters accordingly in the code snippet provided
above.

# Customizing Web Search Results

By default, the `maxResults` property is set to 1. You can adjust this
value to retrieve a list of results.

## Retrieving single result or list of strings

When `maxResults` is set to 1, you can by default retrieve by default
the content as a single string. Example:

    String response = template.requestBody("langchain4j-web-search:test", "Who won the European Cup in 2024?", String.class);

When `maxResults` is greater than 1, you can retrieve a list of strings.
Example:

    List<String> responses = template.requestBody("langchain4j-web-search:test?maxResults=3", "Who won the European Cup in 2024?", List.class);

## Retrieve different types of Results

You can get different type of Results.

When `resultType` = SNIPPET, you will get a single or list (depending of
`maxResults` value) of Strings containing the snippets.

When `resultType` = LANGCHAIN4J\_WEB\_SEARCH\_ORGANIC\_RESULT, you will
get a single or list (depending of `maxResults` value) of Objects of
type `WebSearchOrganicResult` containing all the response created under
the hood by Langchain4j Web Search.

# Advanced usage of WebSearchRequest

When defining a WebSearchRequest, the Camel LangChain4j web search
component will default to this request, instead of creating one from the
body and config parameters.

When using a WebSearchRequest, the body and the parameters of the search
will be ignored. Use this parameter with caution.

A WebSearchRequest should be bound to the registry.

Example of binding the request to the registry.

    @BindToRegistry("web-search-request")
    WebSearchRequest request = WebSearchRequest.builder()
        .searchTerms("Who won the European Cup in 2024?")
        .maxResults(2)
        .build();

The request will be autowired automatically if its bound name is
`web-search-request`. Otherwise, it should be added as a configured
parameter to the Camel route.

Example of route:

     from("direct:web-search")
          .to("langchain4j-web-search:test?webSearchRequest=#searchRequestTest");

## Component ConfigurationsThere are no configurations for this component

## Endpoint ConfigurationsThere are no configurations for this component
