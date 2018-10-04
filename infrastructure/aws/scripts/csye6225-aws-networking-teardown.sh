#!/bin/bash
#***********************************************************************************
#    AWS VPC Deletion Shell Script
#***********************************************************************************


region="us-east-1"

if [ $# -eq 0 ]; then
 echo " PLEASE PASS <STACK_NAME> as parameter while running this script "
 exit 1
fi

echo "Prepare for deleting,please wait........"

vpc="$1-csye6225-vpc-1"
vpcname=$(aws ec2 describe-vpcs \
 --query "Vpcs[?Tags[?Key=='Name']|[?Value=='$vpc']].Tags[0].Value" \
 --output text)

vpc_id=$(aws ec2 describe-vpcs \
 --query 'Vpcs[*].{VpcId:VpcId}' \
 --filters Name=is-default,Values=false \
 --output text \
  --region $region)

IGW_Id=$(aws ec2 describe-internet-gateways \
  --query 'InternetGateways[*].{InternetGatewayId:InternetGatewayId}' \
  --filters "Name=attachment.vpc-id,Values=$vpc_id" \
  --output text)

route_tbl_id=$(aws ec2 describe-route-tables \
 --filters "Name=vpc-id,Values=$vpc_id" "Name=association.main, Values=false" \
 --query 'RouteTables[*].{RouteTableId:RouteTableId}' \
 --output text)

route_tbl_ids=( $route_tbl_id )
route_tbl_id1=${route_tbl_ids[0]}
route_tbl_id2=${route_tbl_ids[1]}


aws ec2 describe-route-tables \
 --query 'RouteTables[*].Associations[].{RouteTableAssociationId:RouteTableAssociationId}' \
 --route-table-id $route_tbl_id1 \
 --output text|while read var_associate; do aws ec2 disassociate-route-table --association-id $var_associate; done

aws ec2 describe-route-tables \
 --query 'RouteTables[*].Associations[].{RouteTableAssociationId:RouteTableAssociationId}' \
 --route-table-id $route_tbl_id2 \
 --output text|while read var_associate2; do aws ec2 disassociate-route-table --association-id $var_associate2; done

echo "Start to delete!!"
while
sub=$(aws ec2 describe-subnets \
 --filters Name=vpc-id,Values=$vpc_id \
 --query 'Subnets[*].SubnetId' \
 --output text)
[[ ! -z $sub ]]
do
        var1=$(echo $sub | cut -f1 -d" ")
       # echo $var1 is deleted 
        aws ec2 delete-subnet --subnet-id $var1
done
echo "Subnets delete--------------------->OK"

aws ec2 detach-internet-gateway \
 --internet-gateway-id $IGW_Id \
 --vpc-id $vpc_id

aws ec2 delete-internet-gateway \
 --internet-gateway-id $IGW_Id
echo "IGW delete------------------------>OK"


main_route_tbl_id=$(aws ec2 describe-route-tables \
 --query "RouteTables[?VpcId=='$vpc_id']|[?Associations[?Main!=true]].RouteTableId" \
 --output text)


for i in $route_tbl_id
do
# echo "Start------ $main_route_tbl_id"
 if [[ $i != $main_route_tbl_id ]]; then
  aws ec2 delete-route-table --route-table-id $i
 fi
# echo "stop----- $main_route_tbl_id"
done
echo "Route-Table delete------------------------>OK"


aws ec2 delete-vpc --vpc-id $vpc_id
echo "Complete!!"
