# Rss-dataformat.md

**Since Camel 2.1**

The RSS component ships with an RSS dataformat that can be used to
convert between String (as XML) and ROME RSS model objects.

-   marshal = from ROME `SyndFeed` to XML `String`

-   unmarshal = from XML `String` to ROME `SyndFeed`

A route using this would look something like this:

The purpose of this feature is to make it possible to use Camel’s lovely
built-in expressions for manipulating RSS messages. As shown below, an
XPath expression can be used to filter the RSS message:

**Query parameters**

If the URL for the RSS feed uses query parameters, this component will
understand them as well, for example if the feed uses `alt=rss`, then
you can for example do
`from("rss:http://someserver.com/feeds/posts/default?alt=rss&splitEntries=false&delay=1000").to("bean:rss");`

# Options

# Example

The RSS component ships with an RSS dataformat that can be used to
convert between String (as XML) and ROME RSS model objects.

-   marshal = from ROME `SyndFeed` to XML `String`

-   unmarshal = from XML `String` to ROME `SyndFeed`

A route using the RSS dataformat will look like this:

    from("rss:file:src/test/data/rss20.xml?splitEntries=false&delay=1000")
      .marshal().rss()
      .to("mock:marshal");

The purpose of this feature is to make it possible to use Camel’s
built-in expressions for manipulating RSS messages. As shown below, an
XPath expression can be used to filter the RSS message. In the following
example, on ly entries with Camel in the title will get through the
filter.

    from("rss:file:src/test/data/rss20.xml?splitEntries=true&delay=100")
      .marshal().rss()
      .filter().xpath("//item/title[contains(.,'Camel')]")
        .to("mock:result");
