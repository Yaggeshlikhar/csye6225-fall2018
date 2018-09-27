echo "please input the stack you want to create:"
read l
if [ -n "$l" ]
then
aws cloudformation create-stack --stack-name $l --template-body file://csye6225-cf-networking.json
else 
	echo "please input stack name!"
fi

