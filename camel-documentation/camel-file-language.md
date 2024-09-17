# File-language.md

**Since Camel 1.1**

The File Expression Language is an extension to the
[Simple](#simple-language.adoc) language, adding file related
capabilities. These capabilities are related to common use cases working
with file path and names. The goal is to allow expressions to be used
with the [File](#components::file-component.adoc) and
[FTP](#components::ftp-component.adoc) components for setting dynamic
file patterns for both consumer and producer.

The file language is merged with [Simple](#simple-language.adoc)
language, which means you can use all the file syntax directly within
the simple language.

# File Language options

# Syntax

This language is an **extension** to the [Simple](#simple-language.adoc)
language, so the [Simple](#simple-language.adoc) syntax applies also. So
the table below only lists the additional file related functions.

All the file tokens use the same expression name as the method on the
`java.io.File` object, for instance `file:absolute` refers to the
`java.io.File.getAbsolute()` method. Notice that not all expressions are
supported by the current Exchange. For instance, the
[FTP](#components::ftp-component.adoc) component supports some options,
whereas the File component supports all of them.

<table>
<colgroup>
<col style="width: 24%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 24%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Expression</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">File Consumer</th>
<th style="text-align: left;">File Producer</th>
<th style="text-align: left;">FTP Consumer</th>
<th style="text-align: left;">FTP Producer</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>file:name</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>refers to the file name (is relative to
the starting directory, see note below)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>file:name.ext</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>refers to the file extension
only</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>file:name.ext.single</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>refers to the file extension. If the
file extension has multiple dots, then this expression strips and only
returns the last part.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>file:name.noext</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>refers to the file name with no
extension (is relative to the starting directory, see note
below)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>file:name.noext.single</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>refers to the file name with no
extension (is relative to the starting directory, see note below). If
the file name has multiple dots, then this expression strips only the
last part, and keeps the others.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>file:onlyname</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>refers to the file name only with no
leading paths.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>file:onlyname.noext</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>refers to the file name only with no
extension and with no leading paths.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>file:onlyname.noext.single</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>refers to the file name only with no
extension and with no leading paths. If the file extension has multiple
dots, then this expression strips only the last part, and keeps the
others.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>file:ext</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>refers to the file extension
only</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>file:parent</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>refers to the file parent</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>file:path</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>refers to the file path</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>file:absolute</p></td>
<td style="text-align: left;"><p>Boolean</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>refers to whether the file is regarded
as absolute or relative</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>file:absolute.path</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>refers to the absolute file
path</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>file:length</p></td>
<td style="text-align: left;"><p>Long</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>refers to the file length returned as a
Long type</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>file:size</p></td>
<td style="text-align: left;"><p>Long</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>refers to the file length returned as a
Long type</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>file:modified</p></td>
<td style="text-align: left;"><p>Date</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>no</p></td>
<td style="text-align: left;"><p>Refers to the file last modified
returned as a Date type</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>date:_command:pattern_</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>yes</p></td>
<td style="text-align: left;"><p>for date formatting using the
<code>java.text.SimpleDateFormat</code> patterns. Is an
<strong>extension</strong> to the <a
href="#simple-language.adoc">Simple</a> language. Additional command is:
<strong>file</strong> (consumers only) for the last modified timestamp
of the file. Notice: all the commands from the <a
href="#simple-language.adoc">Simple</a> language can also be
used.</p></td>
</tr>
</tbody>
</table>

# File token example

## Relative paths

We have a `java.io.File` handle for the file `hello.txt` in the
following **relative** directory: `./filelanguage/test`. And we
configure our endpoint to use this starting directory `./filelanguage`.
The file tokens will return as:

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Expression</th>
<th style="text-align: left;">Returns</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>file:name</p></td>
<td style="text-align: left;"><p>test/hello.txt</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>file:name.ext</p></td>
<td style="text-align: left;"><p>txt</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>file:name.noext</p></td>
<td style="text-align: left;"><p>test/hello</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>file:onlyname</p></td>
<td style="text-align: left;"><p>hello.txt</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>file:onlyname.noext</p></td>
<td style="text-align: left;"><p>hello</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>file:ext</p></td>
<td style="text-align: left;"><p>txt</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>file:parent</p></td>
<td style="text-align: left;"><p>filelanguage/test</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>file:path</p></td>
<td style="text-align: left;"><p>filelanguage/test/hello.txt</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>file:absolute</p></td>
<td style="text-align: left;"><p>false</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>file:absolute.path</p></td>
<td
style="text-align: left;"><p>/workspace/camel/camel-core/target/filelanguage/test/hello.txt</p></td>
</tr>
</tbody>
</table>

## Absolute paths

We have a `java.io.File` handle for the file `hello.txt` in the
following **absolute** directory:
`/workspace/camel/camel-core/target/filelanguage/test`. And we configure
the out endpoint to use the absolute starting directory
`/workspace/camel/camel-core/target/filelanguage`. The file tokens will
return as:

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Expression</th>
<th style="text-align: left;">Returns</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>file:name</p></td>
<td style="text-align: left;"><p>test/hello.txt</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>file:name.ext</p></td>
<td style="text-align: left;"><p>txt</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>file:name.noext</p></td>
<td style="text-align: left;"><p>test/hello</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>file:onlyname</p></td>
<td style="text-align: left;"><p>hello.txt</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>file:onlyname.noext</p></td>
<td style="text-align: left;"><p>hello</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>file:ext</p></td>
<td style="text-align: left;"><p>txt</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>file:parent</p></td>
<td
style="text-align: left;"><p>/workspace/camel/camel-core/target/filelanguage/test</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>file:path</p></td>
<td
style="text-align: left;"><p>/workspace/camel/camel-core/target/filelanguage/test/hello.txt</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>file:absolute</p></td>
<td style="text-align: left;"><p>true</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>file:absolute.path</p></td>
<td
style="text-align: left;"><p>/workspace/camel/camel-core/target/filelanguage/test/hello.txt</p></td>
</tr>
</tbody>
</table>

# Examples

You can enter a fixed file name such as `myfile.txt`:

    fileName="myfile.txt"

Let’s assume we use the file consumer to read files and want to move the
read files to back up folder with the current date as a subfolder. This
can be done using an expression like:

    fileName="backup/${date:now:yyyyMMdd}/${file:name.noext}.bak"

relative folder names are also supported so suppose the backup folder
should be a sibling folder then you can append `..` as shown:

    fileName="../backup/${date:now:yyyyMMdd}/${file:name.noext}.bak"

As this is an extension to the [Simple](#simple-language.adoc) language,
we have access to all the goodies from this language also, so in this
use case we want to use the in.header.type as a parameter in the dynamic
expression:

    fileName="../backup/${date:now:yyyyMMdd}/type-${in.header.type}/backup-of-${file:name.noext}.bak"

If you have a custom date you want to use in the expression, then Camel
supports retrieving dates from the message header:

    fileName="orders/order-${in.header.customerId}-${date:in.header.orderDate:yyyyMMdd}.xml"

And finally, we can also use a bean expression to invoke a POJO class
that generates some String output (or convertible to String) to be used:

    fileName="uniquefile-${bean:myguidgenerator.generateid}.txt"

Of course, all this can be combined in one expression where you can use
the [File Language](#file-language.adoc), [Simple](#file-language.adoc)
and the [Bean](#components::bean-component.adoc) language in one
combined expression. This is pretty powerful for those common file path
patterns.

# Dependencies

The File language is part of **camel-core**.
