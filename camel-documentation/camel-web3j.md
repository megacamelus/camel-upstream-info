# Web3j

**Since Camel 2.22**

**Both producer and consumer are supported**

The Ethereum blockchain component uses the
[web3j](https://github.com/web3j/web3j) client API and allows you to
interact with Ethereum compatible nodes such as:

-   [Geth](https://github.com/ethereum/go-ethereum/wiki/geth)

-   [Parity](https://github.com/paritytech/parity)

-   [Quorum](https://github.com/jpmorganchase/quorum/wiki)

-   [Infura](https://infura.io)

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-web3j</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI Format

    web3j://<local/remote host:port or local IPC path>[?options]

All URI options can also be set as exchange headers.

# Examples

Listen for new mined blocks and send the block hash to a jms queue:

    from("web3j://http://127.0.0.1:7545?operation=ETH_BLOCK_HASH_OBSERVABLE")
        .to("jms:queue:blocks");

Use the block hash code to retrieve the block and full transaction
details:

    from("jms:queue:blocks")
        .setHeader(BLOCK_HASH, body())
        .to("web3j://http://127.0.0.1:7545?operation=ETH_GET_BLOCK_BY_HASH&fullTransactionObjects=true");

Read the balance of an address at a specific block number:

    from("direct:start")
        .to("web3j://http://127.0.0.1:7545?operation=ETH_GET_BALANCE&address=0xc8CDceCE5d006dAB638029EBCf6Dd666efF5A952&atBlock=10");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|addresses|Contract address or a list of addresses.||array|
|configuration|Default configuration||object|
|fromAddress|The address the transaction is send from||string|
|fromBlock|The block number, or the string latest for the last mined block or pending, earliest for not yet mined transactions.|latest|string|
|fullTransactionObjects|If true it returns the full transaction objects, if false only the hashes of the transactions.|false|boolean|
|gasLimit|The maximum gas allowed in this block.||object|
|privateFor|A transaction privateFor nodes with public keys in a Quorum network||array|
|quorumAPI|If true, this will support Quorum API.|false|boolean|
|toAddress|The address the transaction is directed to.||string|
|toBlock|The block number, or the string latest for the last mined block or pending, earliest for not yet mined transactions.|latest|string|
|topics|Topics are order-dependent. Each topic can also be a list of topics. Specify multiple topics separated by comma.||string|
|web3j|The preconfigured Web3j object.||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|address|Contract address.||string|
|atBlock|The block number, or the string latest for the last mined block or pending, earliest for not yet mined transactions.|latest|string|
|blockHash|Hash of the block where this transaction was in.||string|
|clientId|A random hexadecimal(32 bytes) ID identifying the client.||string|
|data|The compiled code of a contract OR the hash of the invoked method signature and encoded parameters.||string|
|databaseName|The local database name.||string|
|filterId|The filter id to use.||object|
|gasPrice|Gas price used for each paid gas.||object|
|hashrate|A hexadecimal string representation (32 bytes) of the hash rate.||string|
|headerPowHash|The header's pow-hash (256 bits) used for submitting a proof-of-work solution.||string|
|index|The transactions/uncle index position in the block.||object|
|keyName|The key name in the database.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|mixDigest|The mix digest (256 bits) used for submitting a proof-of-work solution.||string|
|nonce|The nonce found (64 bits) used for submitting a proof-of-work solution.||string|
|operation|Operation to use.|transaction|string|
|position|The transaction index position withing a block.||object|
|priority|The priority of a whisper message.||object|
|sha3HashOfDataToSign|Message to sign by calculating an Ethereum specific signature.||string|
|signedTransactionData|The signed transaction data for a new message call transaction or a contract creation for signed transactions.||string|
|sourceCode|The source code to compile.||string|
|transactionHash|The information about a transaction requested by transaction hash.||string|
|ttl|The time to live in seconds of a whisper message.||object|
|value|The value sent within a transaction.||object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|nodeAddress|Sets the node address used to communicate||string|
|addresses|Contract address or a list of addresses.||array|
|fromAddress|The address the transaction is send from||string|
|fromBlock|The block number, or the string latest for the last mined block or pending, earliest for not yet mined transactions.|latest|string|
|fullTransactionObjects|If true it returns the full transaction objects, if false only the hashes of the transactions.|false|boolean|
|gasLimit|The maximum gas allowed in this block.||object|
|privateFor|A transaction privateFor nodes with public keys in a Quorum network||array|
|quorumAPI|If true, this will support Quorum API.|false|boolean|
|toAddress|The address the transaction is directed to.||string|
|toBlock|The block number, or the string latest for the last mined block or pending, earliest for not yet mined transactions.|latest|string|
|topics|Topics are order-dependent. Each topic can also be a list of topics. Specify multiple topics separated by comma.||string|
|web3j|The preconfigured Web3j object.||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|address|Contract address.||string|
|atBlock|The block number, or the string latest for the last mined block or pending, earliest for not yet mined transactions.|latest|string|
|blockHash|Hash of the block where this transaction was in.||string|
|clientId|A random hexadecimal(32 bytes) ID identifying the client.||string|
|data|The compiled code of a contract OR the hash of the invoked method signature and encoded parameters.||string|
|databaseName|The local database name.||string|
|filterId|The filter id to use.||object|
|gasPrice|Gas price used for each paid gas.||object|
|hashrate|A hexadecimal string representation (32 bytes) of the hash rate.||string|
|headerPowHash|The header's pow-hash (256 bits) used for submitting a proof-of-work solution.||string|
|index|The transactions/uncle index position in the block.||object|
|keyName|The key name in the database.||string|
|mixDigest|The mix digest (256 bits) used for submitting a proof-of-work solution.||string|
|nonce|The nonce found (64 bits) used for submitting a proof-of-work solution.||string|
|operation|Operation to use.|transaction|string|
|position|The transaction index position withing a block.||object|
|priority|The priority of a whisper message.||object|
|sha3HashOfDataToSign|Message to sign by calculating an Ethereum specific signature.||string|
|signedTransactionData|The signed transaction data for a new message call transaction or a contract creation for signed transactions.||string|
|sourceCode|The source code to compile.||string|
|transactionHash|The information about a transaction requested by transaction hash.||string|
|ttl|The time to live in seconds of a whisper message.||object|
|value|The value sent within a transaction.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
