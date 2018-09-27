echo "please input the vpcid"
read vpcId
if [ -n "$vpcID" ] 
then
echo "Are you sure to do this steps? Press (N/y)"
read flag;
if [[ $flag==y ]]
then
   
   aws ec2 delete-vpc --vpc-id $vpcId

else
   echo "Bey Bey!!!!"
	#statements
fi	

	#statements
fi



