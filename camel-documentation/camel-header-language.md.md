# Header-language.md

**Since Camel 1.5**

The Header Expression Language allows you to extract values of named
headers.

# Header Options

# Example usage

The `recipientList` EIP can utilize a header:

    <route>
      <from uri="direct:a" />
      <recipientList>
        <header>myHeader</header>
      </recipientList>
    </route>

In this case, the list of recipients are contained in the header
*myHeader*.

And the same example in Java DSL:

    from("direct:a").recipientList(header("myHeader"));

# Dependencies

The Header language is part of **camel-core**.
