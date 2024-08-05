# Graphql

**Since Camel 3.0**

**Only producer is supported**

The GraphQL component is a GraphQL client that communicates over HTTP
and supports queries and mutations, but not subscriptions. It uses the
[Apache
HttpClient](https://hc.apache.org/httpcomponents-client-4.5.x/index.html)
library.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-graphql</artifactId>
        <version>x.x.x</version>
      <!-- use the same version as your Camel core version -->
    </dependency>

# Message Body

If the `variables` and `variablesHeader` parameters are not set and the
IN body is a JsonObject instance, Camel will use it for the operation’s
variables. If the `query` and `queryFile` parameters are not set and the
IN body is a String, Camel will use it as the query. Camel will store
the GraphQL response from the external server on the OUT message body.
All headers from the IN message will be copied to the OUT message, so
headers are preserved during routing. Additionally, Camel will add the
HTTP response headers as well to the OUT message headers.

# Examples

## Queries

Simple queries can be defined directly in the URI:

    from("direct:start")
        .to("graphql://http://example.com/graphql?query={books{id name}}")

The body can also be used for the query:

    from("direct:start")
        .setBody(constant("{books{id name}}"))
        .to("graphql://http://example.com/graphql")

The query can come from a header also:

    from("direct:start")
        .setHeader("myQuery", constant("{books{id name}}"))
        .to("graphql://http://example.com/graphql?queryHeader=myQuery")

More complex queries can be stored in a file and referenced in the URI:

booksQuery.graphql file:

    query Books {
      books {
        id
        name
      }
    }
    
    from("direct:start")
        .to("graphql://http://example.com/graphql?queryFile=booksQuery.graphql")

When the query file defines multiple operations, it’s required to
specify which one should be executed:

    from("direct:start")
        .to("graphql://http://example.com/graphql?queryFile=multipleQueries.graphql&operationName=Books")

Queries with variables need to reference a JsonObject instance from the
registry:

bookByIdQuery.graphql file:

    query BookById($id: Int!) {
      bookById(id: $id) {
        id
        name
        author
      }
    }
    
    @BindToRegistry("bookByIdQueryVariables")
    public JsonObject bookByIdQueryVariables() {
        JsonObject variables = new JsonObject();
        variables.put("id", "book-1");
        return variables;
    }
    
    from("direct:start")
        .to("graphql://http://example.com/graphql?queryFile=bookByIdQuery.graphql&variables=#bookByIdQueryVariables")

A query that accesses variables via the variablesHeader parameter:

    from("direct:start")
        .setHeader("myVariables", () -> {
            JsonObject variables = new JsonObject();
            variables.put("id", "book-1");
            return variables;
        })
        .to("graphql://http://example.com/graphql?queryFile=bookByIdQuery.graphql&variablesHeader=myVariables")

## Mutations

Mutations are like queries with variables. They specify a query and a
reference to a variables' bean:

addBookMutation.graphql file:

    mutation AddBook($bookInput: BookInput) {
      addBook(bookInput: $bookInput) {
        id
        name
        author {
          name
        }
      }
    }
    
    @BindToRegistry("addBookMutationVariables")
    public JsonObject addBookMutationVariables() {
        JsonObject bookInput = new JsonObject();
        bookInput.put("name", "Typee");
        bookInput.put("authorId", "author-2");
        JsonObject variables = new JsonObject();
        variables.put("bookInput", bookInput);
        return variables;
    }
    
    from("direct:start")
        .to("graphql://http://example.com/graphql?queryFile=addBookMutation.graphql&variables=#addBookMutationVariables")

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|httpUri|The GraphQL server URI.||string|
|operationName|The query or mutation name.||string|
|proxyHost|The proxy host in the format hostname:port.||string|
|query|The query text.||string|
|queryFile|The query file name located in the classpath.||string|
|queryHeader|The name of a header containing the GraphQL query.||string|
|variables|The JsonObject instance containing the operation variables.||object|
|variablesHeader|The name of a header containing a JsonObject instance containing the operation variables.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|accessToken|The access token sent in the Authorization header.||string|
|jwtAuthorizationType|The JWT Authorization type. Default is Bearer.|Bearer|string|
|password|The password for Basic authentication.||string|
|username|The username for Basic authentication.||string|
