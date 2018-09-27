. ./config.sh
echo "Please input your stack name"
read l
if [ -n "$l" ]
then
	length=$(aws ec2 describe-tags --filters "Name=key,Values=Name" "Name=value,Values=$l" | jq '.Tags|length')
	if [[ $length == 0 ]]
		then
			vpcId=$(aws ec2 create-vpc --cidr-block $vpccidr | jq -r '.Vpcs.VpcId')
            echo $vpcId
			subnet1Id=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block ${subnet_cidr[0]} --availability-zone ${subnet_zone[0]} | jq -r ".Subnet.SubnetId")
			
            #subnet2Id=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block ${subnet_cidr[1]} --availability-zone ${subnet_zone[1]} | jq -r ".Subnet.SubnetId")
			#subnet3Id=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block ${subnet_cidr[2]} --availability-zone ${subnet_zone[2]} | jq -r ".Subnet.SubnetId")
			#subnet4Id=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block ${subnet_cidr[3]} --availability-zone ${subnet_zone[0]} | jq -r ".Subnet.SubnetId")
			#subnet5Id=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block ${subnet_cidr[4]} --availability-zone ${subnet_zone[1]} | jq -r ".Subnet.SubnetId")
			#subnet6Id=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block ${subnet_cidr[5]} --availability-zone ${subnet_zone[2]} | jq -r ".Subnet.SubnetId")

            #internetGatewayId=$(aws ec2 create-internet-gateway | jq -r ".internetGateway.internetGatewayId")

            #aws ec2 attach-internet-gateway --internet-gateway-id $internetGatewayId --vpc-id $vpcId

            #routeTableId=$(aws ec2 create-route-table --vpc-id $vpcId | jq -r ".RouteTable.RouteTableId")

            #association1Id=$(aws ec2 associate-route-table --route-table-id $routeTableId --subnet-id $subnet1Id | jq -r ".AssociationId")
            #association2Id=$(aws ec2 associate-route-table --route-table-id $routeTableId --subnet-id $subnet2Id | jq -r ".AssociationId")
            #association3Id=$(aws ec2 associate-route-table --route-table-id $routeTableId --subnet-id $subnet3Id | jq -r ".AssociationId")
            
            #return=$(aws ec2 create-route --route-table-id $routeTableId --destination-cidr-block 0.0.0.0/0 --gateway-id $internetGatewayId | jq -r ".Return")

            #aws ec2 create-tags --resources $vpcId $subnet1Id $subnet2Id $subnet3Id $subnet4Id $subnet5Id $subnet6Id $internetGatewayId $routeTableId --tags Key==Name, Values=$1

        else 
        	echo "exist stack name"
        fi
     else
        echo "Please input stack name"   
        fi