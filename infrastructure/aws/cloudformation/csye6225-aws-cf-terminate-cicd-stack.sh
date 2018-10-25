echo "please input the stack you want to delete:"
read l
if [ -n "$l" ]
then
    aws cloudformation delete-stack --stack-name $l
else "please input stack name"
fi


