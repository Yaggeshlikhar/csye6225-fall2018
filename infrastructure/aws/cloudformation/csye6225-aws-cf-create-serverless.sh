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


Role=$(aws iam get-role --role-name LambdaRole --query Role.{Arn:Arn} --output text)
echo "Role= $Role" $'\n'

create=$(aws cloudformation create-stack --stack-name $stackName --template-body file://csye6225-aws-cf-serverless.json --capabilities CAPABILITY_NAMED_IAM \
  --parameters ParameterKey=DeployBucket,ParameterValue=code-deploy$hostedZoneName.csye6225.com ParameterKey=TravisUser,ParameterValue=$TravisUser \
  ParameterKey=S3Bucket,ParameterValue=lambda.bucket$hostedZoneName.csye6225.com ParameterKey=S3Key,ParameterValue=lambdafunction.zip ParameterKey=Mail,ParameterValue=$Mail)



if [ $? -ne "0" ]
then 
 echo "EC2 and RDS instance Creation request Failed"
 exit 1
else
 echo "EC2 and RDS instance Creation was Successful"
fi

Complete=$(aws cloudformation wait stack-create-complete --stack-name $Stack)


if [[ -z "$Complete" ]]
then
  echo "$Stack stack is created successfully."

else
  echo "$Complete"
  echo "Creation of $Stack stack failed. Try again."
  
  exit 1
fi
