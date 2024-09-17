# Tokenize-language.md

**Since Camel 2.0**

The tokenizer language is a built-in language in `camel-core`, which is
most often used with the [Split](#eips:split-eip.adoc) EIP to split a
message using a token-based strategy.

The tokenizer language is intended to tokenize text documents using a
specified delimiter pattern. It can also be used to tokenize XML
documents with some limited capability. For a truly XML-aware
tokenization, the use of the [XML Tokenize](#xtokenize-language.adoc)
language is recommended as it offers a faster, more efficient
tokenization specifically for XML documents.

# Tokenize Options

# Example

The following example shows how to take a request from the direct:a
endpoint then split it into pieces using an
[Expression](#manual::expression.adoc), then forward each piece to
direct:b:

    <route>
      <from uri="direct:a"/>
      <split>
        <tokenize token="\n"/>
        <to uri="direct:b"/>
      </split>
    </route>

And in Java DSL:

    from("direct:a")
        .split(body().tokenize("\n"))
            .to("direct:b");

# See Also

For more examples see [Split](#eips:split-eip.adoc) EIP.
