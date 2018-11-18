echo "please input the stack you want to delete:"
read l
if [ -n "$l" ]
then

pre=code-deploy\.
aws_domain_name=$(aws route53 list-hosted-zones --query 'HostedZones[0].Name' --output text)
bucketname=$pre${aws_domain_name:0:-1}

echo $bucketname

 aws s3 rb s3://$bucketname --force
 aws cloudformation delete-stack --stack-name $l
else "please input stack name"

fi