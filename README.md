# AWS Bedrock Explore

First commit!

To add more contents in time!

# Setup

To use this project, make sure you run the installation steps first, get access to AWS, and then explore the code and run the server!

### Installation

1. Git clone this repo and then run the installation of the gems (I'm assuming you have [ruby and rails installed](https://guides.rubyonrails.org/install_ruby_on_rails.html) already)
```
git clone git@github.com:Weiyuan-Lane/aws-bedrock-explore.git
bundle add aws-sdk-bedrockruntime
```


2. Login via AWS cli (via configure or assume-role), or use AWS secret key and id environment variables (ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'], ENV['AWS_SESSION_TOKEN'], and ENV['AWS_ACCOUNT_ID']), whichever is easier for you!
```
aws configure
```
OR
```
aws sts assume-role ...
```



# Guide to setting up the same in your own Rails project.

1. Add the `aws-sdk-bedrockruntime` to your own project
```
bundle add aws-sdk-bedrockruntime
```



### notes

https://aws.amazon.com/bedrock/pricing/
https://context.ai/compare/claude-3-haiku/claude-3-5-sonnet
https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/BedrockRuntime/Client.html#converse-instance_method
https://docs.aws.amazon.com/bedrock/latest/userguide/models-supported.html#model-ids-arns

