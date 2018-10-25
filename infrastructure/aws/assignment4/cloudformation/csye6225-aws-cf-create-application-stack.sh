echo "please input the stack you want to create:"
read l
if [ -n "$l" ]

vpc=$(aws ec2 describe-vpcs --query 'Vpcs[0].VpcId')
privateSubnetId1=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc" --query 'Subnets[0].SubnetId')
privateSubnetId2=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc" --query 'Subnets[1].SubnetId')
privateSubnetId3=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc" --query 'Subnets[2].SubnetId')
echo $vpc
echo $privateSubnetId1
echo $privateSubnetId2
echo $privateSubnetId3
then

aws cloudformation create-stack --stack-name $l --template-body file://csye6225-cf-application.json --parameters ParameterKey=privateSubnetId1,ParameterValue=$privateSubnetId1 ParameterKey=privateSubnetId2,ParameterValue=$privateSubnetId2 ParameterKey=privateSubnetId3,ParameterValue=$privateSubnetId3 ParameterKey=bucketname,ParameterValue="csye6225-fall2018-likhary.me.csye6225.com"

else 
 echo "please input stack name!"
fi
