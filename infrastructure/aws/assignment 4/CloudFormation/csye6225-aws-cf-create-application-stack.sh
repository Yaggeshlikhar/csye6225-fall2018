echo "please input the stack you want to create:"
read l
if [ -n "$l" ]
then
vpc=$(aws ec2 describe-vpcs --query 'Vpcs[0].VpcId')
publicsubnetId1=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc" --query 'Subnets[0].SubnetId')
publicsubnetId2=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc" --query 'Subnets[3].SubnetId')
publicsubnetId3=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc" --query 'Subnets[5].SubnetId')
priavtesubnetId1=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc" --query 'Subnets[2].SubnetId')
privatesubnetId2=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc" --query 'Subnets[4].SubnetId')
privatesubnetId3=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc" --query 'Subnets[6].SubnetId')

aws cloudformation create-stack --stack-name $l --template-body file://table-withbucket-csye6225-cf-application.json --parameters 
ParameterKey=Vpcid,ParameterValue=$vpc 
echo $vpc
ParameterKey=publicsubnetId1,ParameterValue=$publicsubnetId1
echo $publicsubnetId1
ParameterKey=publicsubnetId2,ParameterValue=$publicsubnetId2
echo $publicsubnetId2
ParameterKey=publicsubnetId3,ParameterValue=$publicsubnetId3
ParameterKey=privatesubnetId1,ParameterValue=$privatesubnetId1
echo $privatesubnetId2
ParameterKey=privatesubnetId1,ParameterValue=$privatesubnetId2
ParameterKey=privatesubnetId1,ParameterValue=$privatesubnetId3

else 
 echo "please input stack name!"
fi
