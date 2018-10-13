echo "please input the stack you want to create:"
read l
if [ -n "$l" ]
privateSubnetReg=MyVPC-private-*
vpc=$(aws ec2 describe-vpcs --query 'Vpcs[1].VpcId')
privateSubnetId1=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc Name="  --query 'Subnets[1].SubnetId' )
privateSubnetId2=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc"  --query 'Subnets[3].SubnetId')
echo $privateSubnetId1
then

aws cloudformation create-stack --stack-name $l --template-body file://csye6225-cf-application.json --parameters ParameterKey=privateSubnetId1,ParameterValue=$privateSubnetId1 ParameterKey=privateSubnetId2,ParameterValue=$privateSubnetId2

else 
 echo "please input stack name!"
fi
