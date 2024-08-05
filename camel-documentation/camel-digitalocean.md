# Digitalocean

**Since Camel 2.19**

**Only producer is supported**

The DigitalOcean component allows you to manage Droplets and resources
within the DigitalOcean cloud with **Camel** by encapsulating
[digitalocean-api-java](https://www.digitalocean.com/community/projects/api-client-in-java).
All the functionality that you are familiar with in the DigitalOcean
control panel is also available through this Camel component.

# Prerequisites

You must have a valid DigitalOcean account and a valid OAuth token. You
can generate an OAuth token by visiting the \[Apps \& API\] section of
the DigitalOcean control panel for your account.

# URI format

The **DigitalOcean Component** uses the following URI format:

    digitalocean://endpoint?[options]

where `endpoint` is a DigitalOcean resource type.

You have to provide an **operation** value for each endpoint, with the
`operation` URI option or the `CamelDigitalOceanOperation` message
header.

All **operation** values are defined in `DigitalOceanOperations`
enumeration.

All **header** names used by the component are defined in
`DigitalOceanHeaders` enumeration.

# Message body result

All message bodies returned are using objects provided by the
**digitalocean-api-java** library.

# API Rate Limits

DigitalOcean REST API encapsulated by camel-digitalocean component is
subjected to API Rate Limiting. ou can find the per-method limits in the
[API Rate Limits
documentation](https://developers.digitalocean.com/documentation/v2/#rate-limit).

# Account endpoint

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">operation</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Headers</th>
<th style="text-align: left;">Result</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>get account info</p></td>
<td style="text-align: center;"></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Account</code></p></td>
</tr>
</tbody>
</table>

# BlockStorages endpoint

<table>
<colgroup>
<col style="width: 15%" />
<col style="width: 38%" />
<col style="width: 38%" />
<col style="width: 7%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">operation</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Headers</th>
<th style="text-align: left;">Result</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>list</code></p></td>
<td style="text-align: left;"><p>list all the Block Storage volumes
available on your account</p></td>
<td style="text-align: center;"></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.Volume&gt;</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>show information about a Block Storage
volume</p></td>
<td style="text-align: center;"><pre><code>`CamelDigitalOceanId` _Integer_</code></pre></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Volume</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>show information about a Block Storage
volume by name</p></td>
<td style="text-align: center;"><pre><code>`CamelDigitalOceanName` _String_, +
 `CamelDigitalOceanRegion` _String_</code></pre></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Volume</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>listSnapshots</code></p></td>
<td style="text-align: left;"><p>retrieve the snapshots that have been
created from a volume</p></td>
<td style="text-align: center;"><pre><code>`CamelDigitalOceanId` _Integer_</code></pre></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.Snapshot&gt;</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>create</code></p></td>
<td style="text-align: left;"><p>create a new volume</p></td>
<td style="text-align: center;"><pre><code>`CamelDigitalOceanVolumeSizeGigabytes` _Integer_, +
 `CamelDigitalOceanName` _String_, +
 `CamelDigitalOceanDescription`* _String_, +
 `CamelDigitalOceanRegion`* _String_</code></pre></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Volume</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>delete</code></p></td>
<td style="text-align: left;"><p>delete a Block Storage volume,
destroying all data and removing it from your account</p></td>
<td style="text-align: center;"><pre><code>`CamelDigitalOceanId`  _Integer_</code></pre></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Delete</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>delete</code></p></td>
<td style="text-align: left;"><p>delete a Block Storage volume by
name</p></td>
<td style="text-align: center;"><pre><code>`CamelDigitalOceanName` _String_, +
 `CamelDigitalOceanRegion` _String_</code></pre></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Delete</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>attach</code></p></td>
<td style="text-align: left;"><p>attach a Block Storage volume to a
Droplet</p></td>
<td style="text-align: center;"><pre><code>`CamelDigitalOceanId` _Integer_, +
 `CamelDigitalOceanDropletId` _Integer_, +
 `CamelDigitalOceanDropletRegion` _String_</code></pre></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>attach</code></p></td>
<td style="text-align: left;"><p>attach a Block Storage volume to a
Droplet by name</p></td>
<td style="text-align: center;"><pre><code>`CamelDigitalOceanName` _String_, +
 `CamelDigitalOceanDropletId` _Integer_, +
 `CamelDigitalOceanDropletRegion` _String_</code></pre></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>detach</code></p></td>
<td style="text-align: left;"><p>detach a Block Storage volume from a
Droplet</p></td>
<td style="text-align: center;"><pre><code>`CamelDigitalOceanId` _Integer_, +
 `CamelDigitalOceanDropletId` _Integer_, +
 `CamelDigitalOceanDropletRegion` _String_</code></pre></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>attach</code></p></td>
<td style="text-align: left;"><p>detach a Block Storage volume from a
Droplet by name</p></td>
<td style="text-align: center;"><pre><code>`CamelDigitalOceanName` _String_, +
 `CamelDigitalOceanDropletId` _Integer_, +
 `CamelDigitalOceanDropletRegion` _String_</code></pre></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>resize</code></p></td>
<td style="text-align: left;"><p>resize a Block Storage volume</p></td>
<td style="text-align: center;"><pre><code>`CamelDigitalOceanVolumeSizeGigabytes` _Integer_, +
 `CamelDigitalOceanRegion` _String_</code></pre></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>listActions</code></p></td>
<td style="text-align: left;"><p>retrieve all actions that have been
executed on a volume</p></td>
<td style="text-align: center;"><pre><code>`CamelDigitalOceanId`  _Integer_</code></pre></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.Action&gt;</code></p></td>
</tr>
</tbody>
</table>

# Droplets endpoint

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">operation</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Headers</th>
<th style="text-align: left;">Result</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>list</code></p></td>
<td style="text-align: left;"><p>list all Droplets in your
account</p></td>
<td style="text-align: center;"></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.Droplet&gt;</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>show an individual droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Droplet</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>create</code></p></td>
<td style="text-align: left;"><p>create a new Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanName</code>
<em>String</em>,<br />
<code>CamelDigitalOceanDropletImage</code> <em>String</em>,<br />
<code>CamelDigitalOceanRegion</code> <em>String</em>,<br />
<code>CamelDigitalOceanDropletSize</code> <em>String</em>,<br />
<code>CamelDigitalOceanDropletSSHKeys</code>*
<em>List&lt;String&gt;</em>,<br />
<code>CamelDigitalOceanDropletEnableBackups</code>*
<em>Boolean</em>,<br />
<code>CamelDigitalOceanDropletEnableIpv6</code>* <em>Boolean</em>,<br />
<code>CamelDigitalOceanDropletEnablePrivateNetworking</code>*
<em>Boolean</em>,<br />
<code>CamelDigitalOceanDropletUserData</code>* <em>String</em>,<br />
<code>CamelDigitalOceanDropletVolumes</code>*
<em>List&lt;String&gt;</em>,<br />
<code>CamelDigitalOceanDropletTags</code>
<em>List&lt;String&gt;</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Droplet</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>create</code></p></td>
<td style="text-align: left;"><p>create multiple Droplets</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanNames</code>
<em>List&lt;String&gt;</em>,<br />
<code>CamelDigitalOceanDropletImage</code> <em>String</em>,<br />
<code>CamelDigitalOceanRegion</code> <em>String</em>,<br />
<code>CamelDigitalOceanDropletSize</code> <em>String</em>,<br />
<code>CamelDigitalOceanDropletSSHKeys</code>*
<em>List&lt;String&gt;</em>,<br />
<code>CamelDigitalOceanDropletEnableBackups</code>*
<em>Boolean</em>,<br />
<code>CamelDigitalOceanDropletEnableIpv6</code>* <em>Boolean</em>,<br />
<code>CamelDigitalOceanDropletEnablePrivateNetworking</code>*
<em>Boolean</em>,<br />
<code>CamelDigitalOceanDropletUserData</code>* <em>String</em>,<br />
<code>CamelDigitalOceanDropletVolumes</code>*
<em>List&lt;String&gt;</em>,<br />
<code>CamelDigitalOceanDropletTags</code>
<em>List&lt;String&gt;</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Droplet</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>delete</code></p></td>
<td style="text-align: left;"><p>delete a Droplet,</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Delete</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>enableBackups</code></p></td>
<td style="text-align: left;"><p>enable backups on an existing
Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>disableBackups</code></p></td>
<td style="text-align: left;"><p>disable backups on an existing
Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>enableIpv6</code></p></td>
<td style="text-align: left;"><p>enable IPv6 networking on an existing
Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>enablePrivateNetworking</code></p></td>
<td style="text-align: left;"><p>enable private networking on an
existing Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>reboot</code></p></td>
<td style="text-align: left;"><p>reboot a Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>powerCycle</code></p></td>
<td style="text-align: left;"><p>power cycle a Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>shutdown</code></p></td>
<td style="text-align: left;"><p>shutdown a Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>powerOff</code></p></td>
<td style="text-align: left;"><p>power off a Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>powerOn</code></p></td>
<td style="text-align: left;"><p>power on a Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>restore</code></p></td>
<td style="text-align: left;"><p>shutdown a Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em>,<br />
<code>CamelDigitalOceanImageId</code> <em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>passwordReset</code></p></td>
<td style="text-align: left;"><p>reset the password for a
Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>resize</code></p></td>
<td style="text-align: left;"><p>resize a Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em>,<br />
<code>CamelDigitalOceanDropletSize</code> <em>String</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>rebuild</code></p></td>
<td style="text-align: left;"><p>rebuild a Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em>,<br />
<code>CamelDigitalOceanImageId</code> <em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>rename</code></p></td>
<td style="text-align: left;"><p>rename a Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em>,<br />
<code>CamelDigitalOceanName</code> <em>String</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>changeKernel</code></p></td>
<td style="text-align: left;"><p>change the kernel of a Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em>,<br />
<code>CamelDigitalOceanKernelId</code> <em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>takeSnapshot</code></p></td>
<td style="text-align: left;"><p>snapshot a Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em>,<br />
<code>CamelDigitalOceanName</code>* <em>String</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>tag</code></p></td>
<td style="text-align: left;"><p>tag a Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em>,<br />
<code>CamelDigitalOceanName</code> <em>String</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Response</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>untag</code></p></td>
<td style="text-align: left;"><p>untag a Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em>,<br />
<code>CamelDigitalOceanName</code> <em>String</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Response</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>listKernels</code></p></td>
<td style="text-align: left;"><p>retrieve a list of all kernels
available to a Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.Kernel&gt;</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>listSnapshots</code></p></td>
<td style="text-align: left;"><p>retrieve the snapshots that have been
created from a Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.Snapshot&gt;</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>listBackups</code></p></td>
<td style="text-align: left;"><p>retrieve any backups associated with a
Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.Backup&gt;</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>listActions</code></p></td>
<td style="text-align: left;"><p>retrieve all actions that have been
executed on a Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.Action&gt;</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>listNeighbors</code></p></td>
<td style="text-align: left;"><p>retrieve a list of droplets that are
running on the same physical server</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.Droplet&gt;</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>listAllNeighbors</code></p></td>
<td style="text-align: left;"><p>retrieve a list of any droplets that
are running on the same physical hardware</p></td>
<td style="text-align: center;"></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.Droplet&gt;</code></p></td>
</tr>
</tbody>
</table>

# Images endpoint

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">operation</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Headers</th>
<th style="text-align: left;">Result</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>list</code></p></td>
<td style="text-align: left;"><p>list images available on your
account</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanType</code>*
<em>DigitalOceanImageTypes</em></p></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.Image&gt;</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>ownList</code></p></td>
<td style="text-align: left;"><p>retrieve only the private images of a
user</p></td>
<td style="text-align: center;"></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.Image&gt;</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>listActions</code></p></td>
<td style="text-align: left;"><p>retrieve all actions that have been
executed on an Image</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.Action&gt;</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>retrieve information about an image
(public or private) by id</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Image</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>retrieve information about a public
image by slug</p></td>
<td
style="text-align: center;"><p><code>CamelDigitalOceanDropletImage</code>
<em>String</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Image</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>update</code></p></td>
<td style="text-align: left;"><p>update an image</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em>,<br />
<code>CamelDigitalOceanName</code> <em>String</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Image</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>delete</code></p></td>
<td style="text-align: left;"><p>delete an image</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Delete</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>transfer</code></p></td>
<td style="text-align: left;"><p>transfer an image to another
region</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em>,<br />
<code>CamelDigitalOceanRegion</code> <em>String</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>convert</code></p></td>
<td style="text-align: left;"><p>convert an image, for example, a backup
to a snapshot</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
</tbody>
</table>

# Snapshots endpoint

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">operation</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Headers</th>
<th style="text-align: left;">Result</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>list</code></p></td>
<td style="text-align: left;"><p>list all the snapshots available on
your account</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanType</code>*
<em>DigitalOceanSnapshotTypes</em></p></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.Snapshot&gt;</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>retrieve information about a
snapshot</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Snapshot</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>delete</code></p></td>
<td style="text-align: left;"><p>delete an snapshot</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Delete</code></p></td>
</tr>
</tbody>
</table>

# Keys endpoint

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">operation</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Headers</th>
<th style="text-align: left;">Result</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>list</code></p></td>
<td style="text-align: left;"><p>list all the keys in your
account</p></td>
<td style="text-align: center;"></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.Key&gt;</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>retrieve information about a key by
id</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Key</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>retrieve information about a key by
fingerprint</p></td>
<td
style="text-align: center;"><p><code>CamelDigitalOceanKeyFingerprint</code>
<em>String</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Key</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>update</code></p></td>
<td style="text-align: left;"><p>update a key by id</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em>,<br />
<code>CamelDigitalOceanName</code> <em>String</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Key</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>update</code></p></td>
<td style="text-align: left;"><p>update a key by fingerprint</p></td>
<td
style="text-align: center;"><p><code>CamelDigitalOceanKeyFingerprint</code>
<em>String</em>,<br />
<code>CamelDigitalOceanName</code> <em>String</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Key</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>delete</code></p></td>
<td style="text-align: left;"><p>delete a key by id</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Delete</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>delete</code></p></td>
<td style="text-align: left;"><p>delete a key by fingerprint</p></td>
<td
style="text-align: center;"><p><code>CamelDigitalOceanKeyFingerprint</code>
<em>String</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Delete</code></p></td>
</tr>
</tbody>
</table>

# Regions endpoint

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">operation</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Headers</th>
<th style="text-align: left;">Result</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>list</code></p></td>
<td style="text-align: left;"><p>list all the regions that are
available</p></td>
<td style="text-align: center;"></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.Region&gt;</code></p></td>
</tr>
</tbody>
</table>

# Sizes endpoint

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">operation</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Headers</th>
<th style="text-align: left;">Result</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>list</code></p></td>
<td style="text-align: left;"><p>list all the sizes that are
available</p></td>
<td style="text-align: center;"></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.Size&gt;</code></p></td>
</tr>
</tbody>
</table>

# Floating IPs endpoint

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">operation</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Headers</th>
<th style="text-align: left;">Result</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>list</code></p></td>
<td style="text-align: left;"><p>list all the Floating IPs available on
your account</p></td>
<td style="text-align: center;"></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.FloatingIP&gt;</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>create</code></p></td>
<td style="text-align: left;"><p>create a new Floating IP assigned to a
Droplet</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanId</code>
<em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.FloatingIP&gt;</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>create</code></p></td>
<td style="text-align: left;"><p>create a new Floating IP assigned to a
Region</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanRegion</code>
<em>String</em></p></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.FloatingIP&gt;</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>retrieve information about a Floating
IP</p></td>
<td
style="text-align: center;"><p><code>CamelDigitalOceanFloatingIPAddress</code>
<em>String</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Key</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>delete</code></p></td>
<td style="text-align: left;"><p>delete a Floating IP and remove it from
your account</p></td>
<td
style="text-align: center;"><p><code>CamelDigitalOceanFloatingIPAddress</code>
<em>String</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Delete</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>assign</code></p></td>
<td style="text-align: left;"><p>assign a Floating IP to a
Droplet</p></td>
<td
style="text-align: center;"><p><code>CamelDigitalOceanFloatingIPAddress</code>
<em>String</em>,<br />
<code>CamelDigitalOceanDropletId</code> <em>Integer</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>unassign</code></p></td>
<td style="text-align: left;"><p>un-assign a Floating IP</p></td>
<td
style="text-align: center;"><p><code>CamelDigitalOceanFloatingIPAddress</code>
<em>String</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Action</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>listActions</code></p></td>
<td style="text-align: left;"><p>retrieve all actions that have been
executed on a Floating IP</p></td>
<td
style="text-align: center;"><p><code>CamelDigitalOceanFloatingIPAddress</code>
<em>String</em></p></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.Action&gt;</code></p></td>
</tr>
</tbody>
</table>

# Tags endpoint

<table>
<colgroup>
<col style="width: 15%" />
<col style="width: 38%" />
<col style="width: 30%" />
<col style="width: 15%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">operation</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Headers</th>
<th style="text-align: left;">Result</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>list</code></p></td>
<td style="text-align: left;"><p>list all of your tags</p></td>
<td style="text-align: center;"></td>
<td
style="text-align: left;"><p><code>List&lt;com.myjeeva.digitalocean.pojo.Tag&gt;</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>create</code></p></td>
<td style="text-align: left;"><p>create a Tag</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanName</code>
<em>String</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Tag</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>get</code></p></td>
<td style="text-align: left;"><p>retrieve an individual tag</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanName</code>
<em>String</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Tag</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>delete</code></p></td>
<td style="text-align: left;"><p>delete a tag</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanName</code>
<em>String</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Delete</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>update</code></p></td>
<td style="text-align: left;"><p>update a tag</p></td>
<td style="text-align: center;"><p><code>CamelDigitalOceanName</code>
<em>String</em>,<br />
<code>CamelDigitalOceanNewName</code> <em>String</em></p></td>
<td
style="text-align: left;"><p><code>com.myjeeva.digitalocean.pojo.Tag</code></p></td>
</tr>
</tbody>
</table>

# Examples

Get your account info

    from("direct:getAccountInfo")
        .setHeader(DigitalOceanConstants.OPERATION, constant(DigitalOceanOperations.get))
        .to("digitalocean:account?oAuthToken=XXXXXX")

Create a droplet

    from("direct:createDroplet")
        .setHeader(DigitalOceanConstants.OPERATION, constant("create"))
        .setHeader(DigitalOceanHeaders.NAME, constant("myDroplet"))
        .setHeader(DigitalOceanHeaders.REGION, constant("fra1"))
        .setHeader(DigitalOceanHeaders.DROPLET_IMAGE, constant("ubuntu-14-04-x64"))
        .setHeader(DigitalOceanHeaders.DROPLET_SIZE, constant("512mb"))
        .to("digitalocean:droplet?oAuthToken=XXXXXX")

List all your droplets

    from("direct:getDroplets")
        .setHeader(DigitalOceanConstants.OPERATION, constant("list"))
        .to("digitalocean:droplets?oAuthToken=XXXXXX")

Retrieve information for the Droplet (dropletId = 34772987)

    from("direct:getDroplet")
        .setHeader(DigitalOceanConstants.OPERATION, constant("get"))
        .setHeader(DigitalOceanConstants.ID, 34772987)
        .to("digitalocean:droplet?oAuthToken=XXXXXX")

Shutdown information for the Droplet (dropletId = 34772987)

    from("direct:shutdown")
        .setHeader(DigitalOceanConstants.ID, 34772987)
        .to("digitalocean:droplet?operation=shutdown&oAuthToken=XXXXXX")

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|operation|The operation to perform to the given resource.||object|
|page|Use for pagination. Force the page number.|1|integer|
|perPage|Use for pagination. Set the number of item per request. The maximum number of results per page is 200.|25|integer|
|resource|The DigitalOcean resource type on which perform the operation.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|digitalOceanClient|To use a existing configured DigitalOceanClient as client||object|
|httpProxyHost|Set a proxy host if needed||string|
|httpProxyPassword|Set a proxy password if needed||string|
|httpProxyPort|Set a proxy port if needed||integer|
|httpProxyUser|Set a proxy host if needed||string|
|oAuthToken|DigitalOcean OAuth Token||string|
