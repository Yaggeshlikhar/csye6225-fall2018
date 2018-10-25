echo "please input the stack you want to create:"
read l
if [ -n "$l" ]
then
aws_domain_name=$(aws route53 list-hosted-zones --query 'HostedZones[0].Name' --output text)

accid=$(aws sts get-caller-identity --output text --query 'Account')

aws cloudformation create-stack --stack-name $l --template-body file://csye6225-cf-cicd.json --capabilities CAPABILITY_NAMED_IAM --parameters ParameterKey=domainName,ParameterValue=${aws_domain_name:0:-1} ParameterKey=AccId,ParameterValue=$accid
else 
 echo "please input stack name!"
fi