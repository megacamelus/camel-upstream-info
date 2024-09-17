# Jq-language.md

**Since Camel 3.18**

Camel supports [JQ](https://jqlang.github.io/jq/) to allow using
[Expression](#manual::expression.adoc) or
[Predicate](#manual::predicate.adoc) on JSON messages.

# JQ Options

# Usage

## Message body types

Camel JQ leverages `camel-jackson` for type conversion. To enable
camel-jackson POJO type conversion, refer to the Camel Jackson
documentation.

## Using header as input

By default, JQ uses the message body as the input source. However, you
can also use a header as input by specifying the `headerName` option.

For example, to count the number of books from a JSON document that was
stored in a header named `books` you can do:

    from("direct:start")
        .setHeader("numberOfBooks")
            .jq(".store.books | length", int.class, "books")
        .to("mock:result");

## Camel supplied JQ Functions

JQ comes with about a hundred built-in functions, and you can see many
examples from [JQ](https://jqlang.github.io/jq/) documentation.

The camel-jq adds the following functions:

-   `header`: allow accessing the Message header in a JQ expression.

-   `property`: allow accessing the Exchange property in a JQ
    expression.

-   `constant`: allow using a constant value as-is in a JQ expression.

For example, to set the property foo with the value from the Message
header ‘MyHeader’:

    from("direct:start")
        .transform()
            .jq(".foo = header(\"MyHeader\")")
        .to("mock:result");

Or from the exchange property:

    from("direct:start")
        .transform()
            .jq(".foo = property(\"MyProperty\")")
        .to("mock:result");

And using a constant value

    from("direct:start")
        .transform()
            .jq(".foo = constant(\"Hello World\")")
        .to("mock:result");

## Transforming a JSon message

For basic JSon transformation where you have a fixed structure, you can
represent with a combination of using Camel simple and JQ language as:

    {
      "company": "${jq(.customer.name)}",
      "location": "${jq(.customer.address.country)}",
      "gold": ${jq(.customer.orders[] | length > 5)}
    }

Here we use the simple language to define the structure and use JQ as
inlined functions via the `${jq(exp)}` syntax.

This makes it possible to use simple as a template language to define a
basic structure and then JQ to grab the data from an incoming JSon
message. The output of the transformation is also JSon, but with simple
you could also make it XML or plain text based:

    <customer gold="${jq(.customer.orders[] | length > 5)}">
        <company>${jq(.customer.name)}</company>
        <location>${jq(.customer.address.country)}</location>
    </customer>

# Examples

For example, you can use JQ in a [Predicate](#manual::predicate.adoc)
with the [Content-Based Router](#eips:choice-eip.adoc) EIP.

    from("queue:books.new")
      .choice()
        .when().jq(".store.book.price < 10)")
          .to("jms:queue:book.cheap")
        .when().jq(".store.book.price < 30)")
          .to("jms:queue:book.average")
        .otherwise()
          .to("jms:queue:book.expensive");

# Dependencies

If you use Maven you could just add the following to your `pom.xml`,
substituting the version number for the latest and greatest release (see
the download page for the latest versions).

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-jq</artifactId>
      <version>x.x.x</version>
    </dependency>
