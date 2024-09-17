# Aws-bedrock

**Since Camel 4.5**

**Only producer is supported**

The AWS2 Bedrock component supports invoking a supported LLM model from
[AWS Bedrock](https://aws.amazon.com/bedrock/) service.

Prerequisites

You must have a valid Amazon Web Services developer account, and be
signed up to use Amazon Bedrock. More information is available at
[Amazon Bedrock](https://aws.amazon.com/bedrock/).

# URI Format

    aws-bedrock://label[?options]

You can append query options to the URI in the following format:

`?options=value&option2=value&...`

Required Bedrock component options

You have to provide the bedrockRuntimeClient in the Registry or your
accessKey and secretKey to access the [Amazon
Bedrock](https://aws.amazon.com/bedrock/) service.

# Usage

## Static credentials, Default Credential Provider and Profile Credentials Provider

You have the possibility of avoiding the usage of explicit static
credentials by specifying the useDefaultCredentialsProvider option and
set it to true.

The order of evaluation for Default Credentials Provider is the
following:

-   Java system properties - `aws.accessKeyId` and `aws.secretKey`.

-   Environment variables - `AWS_ACCESS_KEY_ID` and
    `AWS_SECRET_ACCESS_KEY`.

-   Web Identity Token from AWS STS.

-   The shared credentials and config files.

-   Amazon ECS container credentials - loaded from the Amazon ECS if the
    environment variable `AWS_CONTAINER_CREDENTIALS_RELATIVE_URI` is
    set.

-   Amazon EC2 Instance profile credentials.

You have also the possibility of using Profile Credentials Provider, by
specifying the useProfileCredentialsProvider option to true and
profileCredentialsName to the profile name.

Only one of static, default and profile credentials could be used at the
same time.

For more information about this you can look at [AWS credentials
documentation](https://docs.aws.amazon.com/sdk-for-java/latest/developer-guide/credentials.html)

## Supported AWS Bedrock Models

-   Titan Text Express V1 with id `amazon.titan-text-express-v1` Express
    is a large language model for text generation. It is useful for a
    wide range of advanced, general language tasks such as open-ended
    text generation and conversational chat, as well as support within
    Retrieval Augmented Generation (RAG).

Json schema for request

    {
      "$schema": "http://json-schema.org/draft-04/schema#",
      "type": "object",
      "properties": {
        "inputText": {
          "type": "string"
        },
        "textGenerationConfig": {
          "type": "object",
          "properties": {
            "maxTokenCount": {
              "type": "integer"
            },
            "stopSequences": {
              "type": "array",
              "items": [
                {
                  "type": "string"
                }
              ]
            },
            "temperature": {
              "type": "integer"
            },
            "topP": {
              "type": "integer"
            }
          },
          "required": [
            "maxTokenCount",
            "stopSequences",
            "temperature",
            "topP"
          ]
        }
      },
      "required": [
        "inputText",
        "textGenerationConfig"
      ]
    }

-   Titan Text Lite V1 with id `amazon.titan-text-lite-v1` Lite is a
    light weight efficient model, ideal for fine-tuning of
    English-language tasks.

Json schema for request

    {
      "$schema": "http://json-schema.org/draft-04/schema#",
      "type": "object",
      "properties": {
        "inputText": {
          "type": "string"
        },
        "textGenerationConfig": {
          "type": "object",
          "properties": {
            "maxTokenCount": {
              "type": "integer"
            },
            "stopSequences": {
              "type": "array",
              "items": [
                {
                  "type": "string"
                }
              ]
            },
            "temperature": {
              "type": "integer"
            },
            "topP": {
              "type": "integer"
            }
          },
          "required": [
            "maxTokenCount",
            "stopSequences",
            "temperature",
            "topP"
          ]
        }
      },
      "required": [
        "inputText",
        "textGenerationConfig"
      ]
    }

-   Titan Image Generator G1 with id `amazon.titan-image-generator-v1`
    It generates images from text, and allows users to upload and edit
    an existing image. Users can edit an image with a text prompt
    (without a mask) or parts of an image with an image mask. You can
    extend the boundaries of an image with outpainting, and fill in an
    image with inpainting.

Json schema for request

    {
      "$schema": "http://json-schema.org/draft-04/schema#",
      "type": "object",
      "properties": {
        "textToImageParams": {
          "type": "object",
          "properties": {
            "text": {
              "type": "string"
            },
            "negativeText": {
              "type": "string"
            }
          },
          "required": [
            "text",
            "negativeText"
          ]
        },
        "taskType": {
          "type": "string"
        },
        "imageGenerationConfig": {
          "type": "object",
          "properties": {
            "cfgScale": {
              "type": "integer"
            },
            "seed": {
              "type": "integer"
            },
            "quality": {
              "type": "string"
            },
            "width": {
              "type": "integer"
            },
            "height": {
              "type": "integer"
            },
            "numberOfImages": {
              "type": "integer"
            }
          },
          "required": [
            "cfgScale",
            "seed",
            "quality",
            "width",
            "height",
            "numberOfImages"
          ]
        }
      },
      "required": [
        "textToImageParams",
        "taskType",
        "imageGenerationConfig"
      ]
    }

-   Titan Embeddings G1 with id `amazon.titan-embed-text-v1` The Amazon
    Titan Embeddings G1 - Text – Text v1.2 can intake up to 8k tokens
    and outputs a vector of 1,536 dimensions. The model also works in
    25+ different language

Json schema for request

    {
      "$schema": "http://json-schema.org/draft-04/schema#",
      "type": "object",
      "properties": {
        "inputText": {
          "type": "string"
        }
      },
      "required": [
        "inputText"
      ]
    }

-   Jurassic2-Ultra with id `ai21.j2-ultra-v1` Jurassic-2 Ultra is
    AI21’s most powerful model for complex tasks that require advanced
    text generation and comprehension.

Json schema for request

    {
      "$schema": "http://json-schema.org/draft-04/schema#",
      "type": "object",
      "properties": {
        "prompt": {
          "type": "string"
        },
        "maxTokens": {
          "type": "integer"
        },
        "temperature": {
          "type": "integer"
        },
        "topP": {
          "type": "integer"
        },
        "stopSequences": {
          "type": "array",
          "items": [
            {
              "type": "string"
            }
          ]
        },
        "presencePenalty": {
          "type": "object",
          "properties": {
            "scale": {
              "type": "integer"
            }
          },
          "required": [
            "scale"
          ]
        },
        "frequencyPenalty": {
          "type": "object",
          "properties": {
            "scale": {
              "type": "integer"
            }
          },
          "required": [
            "scale"
          ]
        }
      },
      "required": [
        "prompt",
        "maxTokens",
        "temperature",
        "topP",
        "stopSequences",
        "presencePenalty",
        "frequencyPenalty"
      ]
    }

-   Jurassic2-Mid with id `ai21.j2-mid-v1` Jurassic-2 Mid is less
    powerful than Ultra, yet carefully designed to strike the right
    balance between exceptional quality and affordability.

Json schema for request

    {
      "$schema": "http://json-schema.org/draft-04/schema#",
      "type": "object",
      "properties": {
        "prompt": {
          "type": "string"
        },
        "maxTokens": {
          "type": "integer"
        },
        "temperature": {
          "type": "integer"
        },
        "topP": {
          "type": "integer"
        },
        "stopSequences": {
          "type": "array",
          "items": [
            {
              "type": "string"
            }
          ]
        },
        "presencePenalty": {
          "type": "object",
          "properties": {
            "scale": {
              "type": "integer"
            }
          },
          "required": [
            "scale"
          ]
        },
        "frequencyPenalty": {
          "type": "object",
          "properties": {
            "scale": {
              "type": "integer"
            }
          },
          "required": [
            "scale"
          ]
        }
      },
      "required": [
        "prompt",
        "maxTokens",
        "temperature",
        "topP",
        "stopSequences",
        "presencePenalty",
        "frequencyPenalty"
      ]
    }

-   Claude Instant V1.2 with id `anthropic.claude-instant-v1` A fast,
    affordable yet still very capable model, which can handle a range of
    tasks including casual dialogue, text analysis, summarization, and
    document question-answering.

Json schema for request

    {
      "$schema": "http://json-schema.org/draft-04/schema#",
      "type": "object",
      "properties": {
        "prompt": {
          "type": "string"
        },
        "max_tokens_to_sample": {
          "type": "integer"
        },
        "stop_sequences": {
          "type": "array",
          "items": [
            {
              "type": "string"
            }
          ]
        },
        "temperature": {
          "type": "number"
        },
        "top_p": {
          "type": "integer"
        },
        "top_k": {
          "type": "integer"
        },
        "anthropic_version": {
          "type": "string"
        }
      },
      "required": [
        "prompt",
        "max_tokens_to_sample",
        "stop_sequences",
        "temperature",
        "top_p",
        "top_k",
        "anthropic_version"
      ]
    }

-   Claude 2 with id `anthropic.claude-v2` Anthropic’s highly capable
    model across a wide range of tasks from sophisticated dialogue and
    creative content generation to detailed instruction following.

Json schema for request

    {
      "$schema": "http://json-schema.org/draft-04/schema#",
      "type": "object",
      "properties": {
        "prompt": {
          "type": "string"
        },
        "max_tokens_to_sample": {
          "type": "integer"
        },
        "stop_sequences": {
          "type": "array",
          "items": [
            {
              "type": "string"
            }
          ]
        },
        "temperature": {
          "type": "number"
        },
        "top_p": {
          "type": "integer"
        },
        "top_k": {
          "type": "integer"
        },
        "anthropic_version": {
          "type": "string"
        }
      },
      "required": [
        "prompt",
        "max_tokens_to_sample",
        "stop_sequences",
        "temperature",
        "top_p",
        "top_k",
        "anthropic_version"
      ]
    }

-   Claude 2.1 with id `anthropic.claude-v2:1` An update to Claude 2
    that features double the context window, plus improvements across
    reliability, hallucination rates, and evidence-based accuracy in
    long document and RAG contexts.

Json schema for request

    {
      "$schema": "http://json-schema.org/draft-04/schema#",
      "type": "object",
      "properties": {
        "prompt": {
          "type": "string"
        },
        "max_tokens_to_sample": {
          "type": "integer"
        },
        "stop_sequences": {
          "type": "array",
          "items": [
            {
              "type": "string"
            }
          ]
        },
        "temperature": {
          "type": "number"
        },
        "top_p": {
          "type": "integer"
        },
        "top_k": {
          "type": "integer"
        },
        "anthropic_version": {
          "type": "string"
        }
      },
      "required": [
        "prompt",
        "max_tokens_to_sample",
        "stop_sequences",
        "temperature",
        "top_p",
        "top_k",
        "anthropic_version"
      ]
    }

-   Claude 3 Sonnet with id `anthropic.claude-3-sonnet-20240229-v1:0`
    Claude 3 Sonnet by Anthropic strikes the ideal balance between
    intelligence and speed—particularly for enterprise workloads.

Json schema for request

    {
      "$schema": "http://json-schema.org/draft-04/schema#",
      "type": "object",
      "properties": {
        "messages": {
          "type": "array",
          "items": [
            {
              "type": "object",
              "properties": {
                "role": {
                  "type": "string"
                },
                "content": {
                  "type": "array",
                  "items": [
                    {
                      "type": "object",
                      "properties": {
                        "type": {
                          "type": "string"
                        },
                        "text": {
                          "type": "string"
                        }
                      },
                      "required": [
                        "type",
                        "text"
                      ]
                    }
                  ]
                }
              },
              "required": [
                "role",
                "content"
              ]
            }
          ]
        },
        "max_tokens": {
          "type": "integer"
        },
        "anthropic_version": {
          "type": "string"
        }
      },
      "required": [
        "messages",
        "max_tokens",
        "anthropic_version"
      ]
    }

-   Claude 3 Haiku with id `anthropic.claude-3-haiku-20240307-v1:0`
    Claude 3 Haiku is Anthropic’s fastest, most compact model for
    near-instant responsiveness. It answers simple queries and requests
    with speed.

Json schema for request

    {
      "$schema": "http://json-schema.org/draft-04/schema#",
      "type": "object",
      "properties": {
        "messages": {
          "type": "array",
          "items": [
            {
              "type": "object",
              "properties": {
                "role": {
                  "type": "string"
                },
                "content": {
                  "type": "array",
                  "items": [
                    {
                      "type": "object",
                      "properties": {
                        "type": {
                          "type": "string"
                        },
                        "text": {
                          "type": "string"
                        }
                      },
                      "required": [
                        "type",
                        "text"
                      ]
                    }
                  ]
                }
              },
              "required": [
                "role",
                "content"
              ]
            }
          ]
        },
        "max_tokens": {
          "type": "integer"
        },
        "anthropic_version": {
          "type": "string"
        }
      },
      "required": [
        "messages",
        "max_tokens",
        "anthropic_version"
      ]
    }

## Bedrock Producer operations

Camel-AWS Bedrock component provides the following operation on the
producer side:

-   invokeTextModel

-   invokeImageModel

-   invokeEmbeddingsModel

# Examples

## Producer Examples

-   invokeTextModel: this operation will invoke a model from Bedrock.
    This is an example for both Titan Express and Titan Lite.

<!-- -->

    from("direct:invoke")
        .to("aws-bedrock://test?bedrockRuntimeClient=#amazonBedrockRuntimeClient&operation=invokeTextModel&modelId="
                                + BedrockModels.TITAN_TEXT_EXPRESS_V1.model))

and you can then send to the direct endpoint something like

            final Exchange result = template.send("direct:invoke", exchange -> {
                ObjectMapper mapper = new ObjectMapper();
                ObjectNode rootNode = mapper.createObjectNode();
                rootNode.put("inputText",
                        "User: Generate synthetic data for daily product sales in various categories - include row number, product name, category, date of sale and price. Produce output in JSON format. Count records and ensure there are no more than 5.");
    
                ArrayNode stopSequences = mapper.createArrayNode();
                stopSequences.add("User:");
                ObjectNode childNode = mapper.createObjectNode();
                childNode.put("maxTokenCount", 1024);
                childNode.put("stopSequences", stopSequences);
                childNode.put("temperature", 0).put("topP", 1);
    
                rootNode.put("textGenerationConfig", childNode);
                exchange.getMessage().setBody(mapper.writer().writeValueAsString(rootNode));
                exchange.getMessage().setHeader(BedrockConstants.MODEL_CONTENT_TYPE, "application/json");
                exchange.getMessage().setHeader(BedrockConstants.MODEL_ACCEPT_CONTENT_TYPE, "application/json");
            });

where template is a ProducerTemplate.

-   invokeImageModel: this operation will invoke a model from Bedrock.
    This is an example for both Titan Express and Titan Lite.

<!-- -->

    from("direct:invoke")
        .to("aws-bedrock://test?bedrockRuntimeClient=#amazonBedrockRuntimeClient&operation=invokeImageModel&modelId="
                                + BedrockModels.TITAN_IMAGE_GENERATOR_V1.model))
                            .split(body())
                            .unmarshal().base64()
                            .setHeader("CamelFileName", simple("image-${random(128)}.png")).to("file:target/generated_images")

and you can then send to the direct endpoint something like

            final Exchange result = template.send("direct:send_titan_image", exchange -> {
                ObjectMapper mapper = new ObjectMapper();
                ObjectNode rootNode = mapper.createObjectNode();
                ObjectNode textParameter = mapper.createObjectNode();
                textParameter.putIfAbsent("text",
                        new TextNode("A Sci-fi camel running in the desert"));
                rootNode.putIfAbsent("textToImageParams", textParameter);
                rootNode.putIfAbsent("taskType", new TextNode("TEXT_IMAGE"));
                ObjectNode childNode = mapper.createObjectNode();
                childNode.putIfAbsent("numberOfImages", new IntNode(3));
                childNode.putIfAbsent("quality", new TextNode("standard"));
                childNode.putIfAbsent("cfgScale", new IntNode(8));
                childNode.putIfAbsent("height", new IntNode(512));
                childNode.putIfAbsent("width", new IntNode(512));
                childNode.putIfAbsent("seed", new IntNode(0));
    
                rootNode.putIfAbsent("imageGenerationConfig", childNode);
    
                exchange.getMessage().setBody(mapper.writer().writeValueAsString(rootNode));
                exchange.getMessage().setHeader(BedrockConstants.MODEL_CONTENT_TYPE, "application/json");
                exchange.getMessage().setHeader(BedrockConstants.MODEL_ACCEPT_CONTENT_TYPE, "application/json");
            });

where template is a ProducerTemplate.

-   invokeEmbeddingsModel: this operation will invoke an Embeddings
    model from Bedrock. This is an example for Titan Embeddings G1.

<!-- -->

    from("direct:send_titan_embeddings")
        .to("aws-bedrock:label?useDefaultCredentialsProvider=true&region=us-east-1&operation=invokeEmbeddingsModel&modelId="
        + BedrockModels.TITAN_EMBEDDINGS_G1.model)
        .to(result);

and you can then send to the direct endpoint something like

            final Exchange result = template.send("direct:send_titan_embeddings", exchange -> {
                ObjectMapper mapper = new ObjectMapper();
                ObjectNode rootNode = mapper.createObjectNode();
                rootNode.putIfAbsent("inputText",
                        new TextNode("A Sci-fi camel running in the desert"));
    
                exchange.getMessage().setBody(mapper.writer().writeValueAsString(rootNode));
                exchange.getMessage().setHeader(BedrockConstants.MODEL_CONTENT_TYPE, "application/json");
                exchange.getMessage().setHeader(BedrockConstants.MODEL_ACCEPT_CONTENT_TYPE, "*/*");
            });

where template is a ProducerTemplate.

# Dependencies

Maven users will need to add the following dependency to their pom.xml.

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-aws-bedrock</artifactId>
        <version>${camel-version}</version>
    </dependency>

where `${camel-version}` must be replaced by the actual version of
Camel.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configuration|Component configuration||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|modelId|Define the model Id we are going to use||string|
|operation|The operation to perform||object|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|pojoRequest|If we want to use a POJO request as body or not|false|boolean|
|profileCredentialsName|If using a profile credentials provider, this parameter will set the profile name|false|string|
|region|The region in which Bedrock client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|useDefaultCredentialsProvider|Set whether the Bedrock client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the Bedrock client should expect to load credentials through a profile credentials provider.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|bedrockRuntimeClient|To use an existing configured AWS Bedrock Runtime client||object|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|proxyHost|To define a proxy host when instantiating the Bedrock client||string|
|proxyPort|To define a proxy port when instantiating the Bedrock client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the Bedrock client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume an IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useSessionCredentials|Set whether the Bedrock client should expect to use Session Credentials. This is useful in a situation in which the user needs to assume an IAM role for doing operations in Bedrock.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|label|Logical name||string|
|modelId|Define the model Id we are going to use||string|
|operation|The operation to perform||object|
|overrideEndpoint|Set the need for overriding the endpoint. This option needs to be used in combination with the uriEndpointOverride option|false|boolean|
|pojoRequest|If we want to use a POJO request as body or not|false|boolean|
|profileCredentialsName|If using a profile credentials provider, this parameter will set the profile name|false|string|
|region|The region in which Bedrock client needs to work. When using this parameter, the configuration will expect the lowercase name of the region (for example, ap-east-1) You'll need to use the name Region.EU\_WEST\_1.id()||string|
|uriEndpointOverride|Set the overriding uri endpoint. This option needs to be used in combination with overrideEndpoint option||string|
|useDefaultCredentialsProvider|Set whether the Bedrock client should expect to load credentials through a default credentials provider or to expect static credentials to be passed in.|false|boolean|
|useProfileCredentialsProvider|Set whether the Bedrock client should expect to load credentials through a profile credentials provider.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|bedrockRuntimeClient|To use an existing configured AWS Bedrock Runtime client||object|
|proxyHost|To define a proxy host when instantiating the Bedrock client||string|
|proxyPort|To define a proxy port when instantiating the Bedrock client||integer|
|proxyProtocol|To define a proxy protocol when instantiating the Bedrock client|HTTPS|object|
|accessKey|Amazon AWS Access Key||string|
|secretKey|Amazon AWS Secret Key||string|
|sessionToken|Amazon AWS Session Token used when the user needs to assume an IAM role||string|
|trustAllCertificates|If we want to trust all certificates in case of overriding the endpoint|false|boolean|
|useSessionCredentials|Set whether the Bedrock client should expect to use Session Credentials. This is useful in a situation in which the user needs to assume an IAM role for doing operations in Bedrock.|false|boolean|
