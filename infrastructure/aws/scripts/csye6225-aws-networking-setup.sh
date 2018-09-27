#!/bin/sh
. ./config.sh

echo "before you run this file,you must manual edit the config file,be sure you have done that please y to continue or n to end:"
read flag
if [[ $flag == "y" ]] 
then
	vpcId=$(aws ec2 create-vpc --cidr-block ${vpccidr} | jq -r ".Vpc.VpcId")
	
	subnet1Id=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block ${subnet_cidr[0]} --availability-zone ${subnet_zone[0]} | jq -r ".Subnet.SubnetId")
	subnet2Id=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block ${subnet_cidr[1]} --availability-zone ${subnet_zone[1]} | jq -r ".Subnet.SubnetId")
	subnet3Id=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block ${subnet_cidr[2]} --availability-zone ${subnet_zone[2]} | jq -r ".Subnet.SubnetId")
	
	internetGatewayId=$(aws ec2 create-internet-gateway | jq -r ".InternetGateway.InternetGatewayId")
	aws ec2 attach-internet-gateway --internet-gateway-id $internetGatewayId --vpc-id $vpcId
	routeTableId=$(aws ec2 create-route-table --vpc-id $vpcId | jq -r ".RouteTable.RouteTableId")
	association1Id=$(aws ec2 associate-route-table --route-table-id $routeTableId --subnet-id $subnet1Id | jq -r ".AssociationId")
    association2Id=$(aws ec2 associate-route-table --route-table-id $routeTableId --subnet-id $subnet2Id | jq -r ".AssociationId")
    association3Id=$(aws ec2 associate-route-table --route-table-id $routeTableId --subnet-id $subnet3Id | jq -r ".AssociationId")
    return=$(aws ec2 create-route --route-table-id $routeTableId --destination-cidr-block 0.0.0.0/0 --gateway-id $internetGatewayId | jq -r ".Return")
else
echo "Bye Bye see you next time!!"	
	#statements
fi
