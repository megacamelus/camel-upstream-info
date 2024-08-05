# Js-language.md

**Since Camel 3.20**

Camel allows [JavaScript](https://www.graalvm.org/javascript/) to be
used as an [Expression](#manual::expression.adoc) or
[Predicate](#manual::predicate.adoc) in Camel routes.

For example, you can use JavaScript in a
[Predicate](#manual::predicate.adoc) with the [Content-Based
Router](#eips:choice-eip.adoc) EIP.

# JavaScript Options

# Variables

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Variable</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><strong>this</strong></p></td>
<td style="text-align: left;"><p>Exchange</p></td>
<td style="text-align: left;"><p>the Exchange is the root
object</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>context</p></td>
<td style="text-align: left;"><p>CamelContext</p></td>
<td style="text-align: left;"><p>the CamelContext</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>exchange</p></td>
<td style="text-align: left;"><p>Exchange</p></td>
<td style="text-align: left;"><p>the Exchange</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>exchangeId</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>the exchange id</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>message</p></td>
<td style="text-align: left;"><p>Message</p></td>
<td style="text-align: left;"><p>the message</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>body</p></td>
<td style="text-align: left;"><p>Message</p></td>
<td style="text-align: left;"><p>the message body</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>headers</p></td>
<td style="text-align: left;"><p>Map</p></td>
<td style="text-align: left;"><p>the message headers</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>properties</p></td>
<td style="text-align: left;"><p>Map</p></td>
<td style="text-align: left;"><p>the exchange properties</p></td>
</tr>
</tbody>
</table>

# Dependencies

To use JavaScript in your Camel routes, you need to add the dependency
on **camel-javascript**, which implements the JavaScript language
(JavaScript with GraalVM).

If you use Maven, you could add the following to your pom.xml,
substituting the version number for the latest \& greatest release.

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-javascript</artifactId>
      <version>x.x.x</version>
    </dependency>
