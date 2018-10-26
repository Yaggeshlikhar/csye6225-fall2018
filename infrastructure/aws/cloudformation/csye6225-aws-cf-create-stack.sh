echo "please input the stack you want to create:"
read stack_name
if [ -n "$stack_name" ]
then
aws cloudformation create-stack --stack-name $stack_name --template-body file://csye6225-cf-networking.json --parameters ParameterKey=Name,ParameterValue=$stack_name
else 
 echo "please input stack name!"
fi
