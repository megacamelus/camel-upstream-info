# Langchain4j-tokenizer

**Since Camel 4.8**

The LangChain4j tokenizer component provides support to tokenize (chunk)
larger blocks of texts into text segments that can be used when
interacting with LLMs. Tokenization is particularly helpful when used
with [vector databases](https://en.wikipedia.org/wiki/Vector_database)
to provide better and more contextual search results for
[retrieval-augmented generation
(RAG)](https://en.wikipedia.org/wiki/Retrieval-augmented_generation).

This component uses the [LangChain4j document
splitter](https://docs.langchain4j.dev/tutorials/rag/#document-splitter)
to handle chunking.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-langchain4j-tokenizer</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# Usage

## Chunking DSL

The tokenization process is done in route, using a DSL that handles the
parameters of the tokenization:

Java  
from("direct:start")
.tokenize(tokenizer()
.byParagraph()
.maxTokens(1024)
.maxOverlap(10)
.using(LangChain4jTokenizerDefinition.TokenizerType.OPEN\_AI)
.end())
.split().body()
.to("mock:result");

The tokenization creates a composite message (i.e.: an array of
Strings). This composite message, then can be split using the [Split
EIP](#eips:split-eip.adoc) so that each text segment is separately to an
endpoint. Alternatively, the contents of the composite message may be
passed through a processor so that invalid data is filtered.

## Supported Splitters

The following type of splitters is supported:

-   By paragraph: using the DSL `tokenizer().byParagraph()`

-   By sentence: using the DSL `tokenizer().bySentence()`

-   By word: using the DSL `tokenizer().byWord()`

-   By line: using the DSL `tokenizer().byLine()`

-   By character: using the DSL `tokenizer().byCharacter()`

## Supported Tokenizers

The following tokenizers are supported:

-   OpenAI: using `LangChain4jTokenizerDefinition.TokenizerType.OPEN_AI`

-   Azure: using `LangChain4jTokenizerDefinition.TokenizerType.AZURE`

-   Qwen: using `LangChain4jTokenizerDefinition.TokenizerType.QWEN`

The application must provide the specific implementation of the
tokenizer from LangChain4j. At this moment, they are:

Open AI  
<dependency>  
<groupId>dev.langchain4j</groupId>  
<artifactId>langchain4j-open-ai</artifactId>  
<version>${langchain4j-version}</version>  
</dependency>

Azure  
<dependency>  
<groupId>dev.langchain4j</groupId>  
<artifactId>langchain4j-azure-open-ai</artifactId>  
<version>${langchain4j-version}</version>  
</dependency>

Qwen  
<dependency>  
<groupId>dev.langchain4j</groupId>  
<artifactId>langchain4j-dashscope</artifactId>  
<version>${langchain4j-version}</version>  
</dependency>

## Component ConfigurationsThere are no configurations for this component

## Endpoint ConfigurationsThere are no configurations for this component
