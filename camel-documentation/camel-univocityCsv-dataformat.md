# UnivocityCsv-dataformat.md

**Since Camel 2.15**

This [Data Format](#manual::data-format.adoc) uses
[uniVocity-parsers](https://www.univocity.com/pages/univocity_parsers_tutorial.html)
for reading and writing three kinds of tabular data text files:

-   CSV (Comma Separated Values), where the values are separated by a
    symbol (usually a comma)

-   fixed-width, where the values have known sizes

-   TSV (Tabular Separated Values), where the fields are separated by a
    tabulation

Thus, there are three data formats based on uniVocity-parsers.

If you use Maven, you can add the following to your `pom.xml`,
substituting the version number for the latest and greatest release.

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-univocity-parsers</artifactId>
        <version>x.x.x</version>
    </dependency>

# Options

Most configuration options of the uniVocity-parsers are available in the
data formats. If you want more information about a particular option,
please refer to their [documentation
page](https://www.univocity.com/pages/univocity_parsers_tutorial#settings).

The three data formats share common options and have dedicated ones,
this section presents them all.

# Options

# Marshalling usages

The marshalling accepts either:

-   A list of maps (`List<Map<String, ?>>`), one for each line

-   A single map (`Map<String, ?>`), for a single line

Any other body will throw an exception.

## Usage example: marshalling a Map into CSV format

    <route>
        <from uri="direct:input"/>
        <marshal>
            <univocity-csv/>
        </marshal>
        <to uri="mock:result"/>
    </route>

## Usage example: marshalling a Map into fixed-width format

    <route>
        <from uri="direct:input"/>
        <marshal>
            <univocity-fixed padding="_">
                <univocity-header length="5"/>
                <univocity-header length="5"/>
                <univocity-header length="5"/>
            </univocity-fixed>
        </marshal>
        <to uri="mock:result"/>
    </route>

## Usage example: marshalling a Map into TSV format

    <route>
        <from uri="direct:input"/>
        <marshal>
            <univocity-tsv/>
        </marshal>
        <to uri="mock:result"/>
    </route>

# Unmarshalling usages

The unmarshalling uses an `InputStream` in order to read the data.

Each row produces either:

-   a list with all the values in it (`asMap` option with `false`);

-   A map with all the values indexed by the headers (`asMap` option
    with `true`).

All the rows can either:

-   be collected at once into a list (`lazyLoad` option with `false`);

-   be read on the fly using an iterator (`lazyLoad` option with
    `true`).

## Usage example: unmarshalling a CSV format into maps with automatic headers

    <route>
        <from uri="direct:input"/>
        <unmarshal>
            <univocity-csv headerExtractionEnabled="true" asMap="true"/>
        </unmarshal>
        <to uri="mock:result"/>
    </route>

## Usage example: unmarshalling a fixed-width format into lists

    <route>
        <from uri="direct:input"/>
        <unmarshal>
            <univocity-fixed>
                <univocity-header length="5"/>
                <univocity-header length="5"/>
                <univocity-header length="5"/>
            </univocity-fixed>
        </unmarshal>
        <to uri="mock:result"/>
    </route>
