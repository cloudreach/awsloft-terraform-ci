
#!/bin/bash -e
STACKNAME="aws-loft-de"

echo "Enter the GitHub OAuth Token:"
read GITHUB_OAUTH_TOKEN


aws cloudformation describe-stacks --stack-name $STACKNAME --query Stacks[0].StackId  > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "UPDATE $STACKNAME"
    aws cloudformation update-stack --stack-name $STACKNAME --template-body file://cfn.yaml --parameters  ParameterKey=GitHubOAuthToken,ParameterValue=$GITHUB_OAUTH_TOKEN  --capabilities CAPABILITY_IAM
else
    echo "CREATE $STACKNAME"
    aws cloudformation create-stack --stack-name $STACKNAME --template-body file://cfn.yaml --parameters  ParameterKey=GitHubOAuthToken,ParameterValue=$GITHUB_OAUTH_TOKEN  --capabilities CAPABILITY_IAM
fi
