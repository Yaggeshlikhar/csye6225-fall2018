echo "please input the stack you want to create:"
read l
if [ -n "$l" ]
then
vpc=$(aws ec2 describe-vpcs --query 'Vpcs[0].VpcId')
subnetId=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc" --query 'Subnets[5].SubnetId')
echo $vpc
echo $subnetId
aws cloudformation create-stack --stack-name $l --template-body file://csye6225-cf-application.json --parameters ParameterKey=Vpcid,ParameterValue=$vpc ParameterKey=subnetId,ParameterValue=$subnetId

else 
 echo "please input stack name!"
fi
