# Camel-csimple-maven-plugin.md

The Camel Compile Simple Maven Plugin supports the following goals

-   camel-csimple:generate - To generate source code for csimple
    language

# camel:generate

To source code generate csimple languages discovered from the source
code in the project

    mvn camel-csimple:generate

You should

    <plugin>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-csimple-maven-plugin</artifactId>
      <executions>
        <execution>
          <phase>process-classes</phase>
          <goals>
            <goal>generate</goal>
          </goals>
        </execution>
      </executions>
    </plugin>

The phase determines when the plugin runs. In the sample above the phase
is `process-classes` which runs after the compilation of the main source
code.

## Options

The maven plugin **generate** goal supports the following options which
can be configured from the command line (use `-D` syntax), or defined in
the `pom.xml` file in the `<configuration>` tag.

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: left;"><p>Parameter</p></td>
<td style="text-align: left;"><p>Default Value</p></td>
<td style="text-align: left;"><p>Description</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>outputDir</p></td>
<td style="text-align: left;"><p>src/generated/java</p></td>
<td style="text-align: left;"><p>The output directory for generated
source files</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>outputResourceDir</p></td>
<td style="text-align: left;"><p>src/generated/resources</p></td>
<td style="text-align: left;"><p>The output directory for generated
resources files</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>includeJava</p></td>
<td style="text-align: left;"><p>true</p></td>
<td style="text-align: left;"><p>Whether to include Java files</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>includeXml</p></td>
<td style="text-align: left;"><p>true</p></td>
<td style="text-align: left;"><p>Whether to include XML files</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>includeTest</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Whether to include test source
code</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>includes</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>To filter the names of java and xml
files to only include files matching any of the given list of patterns
(wildcard and regular expression). Multiple values can be separated by
comma.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>excludes</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>To filter the names of java and xml
files to exclude files matching any of the given list of patterns
(wildcard and regular expression). Multiple values can be separated by
comma.</p></td>
</tr>
</tbody>
</table>
