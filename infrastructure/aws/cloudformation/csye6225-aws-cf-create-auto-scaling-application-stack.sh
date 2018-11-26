echo "please input the stack you want to create:"
read stack_name
if [ -n "$stack_name" ]
then
aws_domain_name=$(aws route53 list-hosted-zones --query 'HostedZones[0].Name' --output text)
echo $aws_domain_name

SSLArn=$(aws acm list-certificates --query "CertificateSummaryList[?DomainName=='${aws_domain_name:0:-1}'].CertificateArn" --output text)
echo $SSLArn
subnet1=$(aws ec2 describe-subnets --filter "Name=tag:Name,Values=Public Subnet 1" --query Subnets[0].SubnetId --output text)
codedeployRole=$(aws iam get-role --role-name CodeDeployServiceRole --query Role.Arn --output text)
aws_response=$(aws cloudformation create-stack --stack-name $stack_name --template-body file://csye6225-cf-auto-scaling-application.json --parameters ParameterKey=tableName,ParameterValue="csye6225" ParameterKey=dbName,ParameterValue="csye6225" ParameterKey=dbInstanceIdentifier,ParameterValue="csye6225-spring2018" ParameterKey=dbUsername,ParameterValue="csye6225master" ParameterKey=dbPassword,ParameterValue="csye6225password" ParameterKey=CodeDeployServiceRole,ParameterValue=$codedeployRole ParameterKey=domainName,ParameterValue=${aws_domain_name:0:-1} ParameterKey=SSLArn,ParameterValue=$SSLArn ParameterKey=subnet1,ParameterValue=$subnet1 ParameterKey=Profile,ParameterValue=$(aws iam list-instance-profiles --query InstanceProfiles[].{InstanceProfileName:InstanceProfileName} --output text))

echo "Waiting for stack to be created ..."
aws cloudformation wait stack-create-complete --stack-name $stack_name 

echo "Stack Id = $aws_response created successfully!"
    
echo "Script completed successfully!"

echo $aws_response

else 
 echo "please input stack name!"
fi
