echo "Please enter the stack you want to create"
read stackName
Valid=$(aws cloudformation  validate-template --template-body file://csye6225-aws-cf-serverless.json)
if [ $? -ne "0" ]
then
  echo $Valid

  echo "$Stack CloudFormation Template NOT VALID."
  exit 1
else
  echo "CloudFormation Template is VALID.Proceeding.."
fi

aws_domain_name=$(aws route53 list-hosted-zones --query 'HostedZones[0].Name' --output text)
Role=$(aws iam get-role --role-name LambdaRole --query Role.{Arn:Arn} --output text)

echo "Role= $Role" $'\n'

create=$(aws cloudformation create-stack --stack-name $stackName --template-body file://csye6225-aws-cf-serverless.json --capabilities CAPABILITY_NAMED_IAM \
  --parameters  ParameterKey=S3Key,ParameterValue=lambdafunction.zip  ParameterKey=LambdaRole,ParameterValue=$Role)



if [ $? -ne "0" ]
then 
 echo "EC2 and RDS instance Creation request Failed"
 exit 1
else
 echo "EC2 and RDS instance Creation was Successful"
fi

Complete=$(aws cloudformation wait stack-create-complete --stack-name $stackName)


if [[ -z "$Complete" ]]
then
  echo "$stackName stack is created successfully."

else
  echo "$Complete"
  echo "Creation of $stackName stack failed. Try again."
  exit 1
fi
