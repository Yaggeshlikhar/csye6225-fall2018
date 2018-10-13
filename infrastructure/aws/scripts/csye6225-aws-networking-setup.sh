#!/bin/bash
#***********************************************************************************
#    AWS VPC Creation Shell Script
#***********************************************************************************
#. ./config.sh
if [ $# -eq 0 ]; then
echo "PLEASE PASS <STACK_NAME> as parameter while running your script"
exit 1
fi

region="us-east-1"
ZONE1="us-east-1a"
ZONE2="us-east-1b"
ZONE3="us-east-1c"

echo "Enter CIDR block"
read vpc_cidr

VPC_ID=$(aws ec2 create-vpc \
  --cidr-block $vpc_cidr \
  --query 'Vpc.{VpcId:VpcId}' \
  --output text \
  --region $region 2>&1)
VPC_CREATE_STATUS=$?
if [ $VPC_CREATE_STATUS -eq 0 ]; 
then
  echo "VPC Create------------>OK"
else
 echo "Error:VPC not created!!"
  echo " $VPC_ID "
 exit $VPC_CREATE_STATUS
fi

echo "Enter VPC Name"
read vpc_name
aws ec2 create-tags --resources $VPC_ID \
--tags Key=Name,Value=$vpc_name 2>&1


IGW_ID=$(aws ec2 create-internet-gateway \
  --query 'InternetGateway.{InternetGatewayId:InternetGatewayId}' \
  --output text \
  --region $region 2>&1)
IGW_CREATE_STATUS=$?
if [ $IGW_CREATE_STATUS -eq 0 ]; then
  echo "create Internet Gateway------------>OK"
else
    echo "Error:Gateway not created"
    echo " $IGW_ID "
    exit $IGW_CREATE_STATUS
fi

echo "Enter IGW Name"
read IGW_name
aws ec2 create-tags --resources $IGW_ID \
--tags Key=Name,Value=$IGW_name 2>&1


IGW_ATTACH=$(aws ec2 attach-internet-gateway \
  --vpc-id $VPC_ID \
  --internet-gateway-id $IGW_ID \
  --region $region 2>&1)
IGW_ATTACH_STATUS=$?
if [ $IGW_ATTACH_STATUS -eq 0 ]; then

  echo "ATTACH IGW to VPC------------------>OK"
else
    echo "Error:Gateway not attached to VPC: $?"
    echo " $IGW_ATTACH "
    exit $IGW_ATTACH_STATUS
fi

echo "Enter Public Subnet1 CIDR"
read public_subnet1_cidr

PUBLIC_SUBNET_1=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block ${public_subnet1_cidr} \
  --availability-zone $ZONE1 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $region)

echo "Enter Public Subnet1 Name"
read public_subnet1_name
aws ec2 create-tags --resources $PUBLIC_SUBNET_1 \
--tags Key=Name,Value=$public_subnet1_name 2>&1

echo "create public subnet 1------------------>OK"

echo "Enter Public Subnet2 CIDR"
read public_subnet2_cidr

PUBLIC_SUBNET_2=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block ${public_subnet2_cidr} \
  --availability-zone $ZONE2 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $region)

echo "Enter Public Subnet2 Name"
read public_subnet2_name
aws ec2 create-tags --resources $PUBLIC_SUBNET_2 \
--tags Key=Name,Value=$public_subnet2_name 2>&1

echo "create public subnet 2------------------>OK"

echo "Enter Public Subnet3 CIDR"
read public_subnet3_cidr


PUBLIC_SUBNET_3=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block ${public_subnet3_cidr} \
  --availability-zone $ZONE3 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $region)

echo "Enter Public Subnet3 Name"
read public_subnet3_name
aws ec2 create-tags --resources $PUBLIC_SUBNET_3 \
--tags Key=Name,Value=$public_subnet3_name 2>&1

echo "create public subnet 3------------------>OK"

echo "Enter Private Subnet1 CIDR"
read private_subnet1_cidr

PRIVATE_SUBNET_1=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block ${private_subnet1_cidr} \
  --availability-zone $ZONE1 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $region)

echo "Enter Private Subnet 1 Name"
read private_subnet1_name
aws ec2 create-tags --resources $PRIVATE_SUBNET_1 \
--tags Key=Name,Value=$private_subnet1_name 2>&1

echo "create private subnet 1------------------>OK"

echo "Enter Private Subnet 2 CIDR"
read private_subnet2_cidr

PRIVATE_SUBNET_2=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block ${private_subnet2_cidr} \
  --availability-zone $ZONE2 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $region)

echo "Enter Private Subnet 2 Name"
read private_subnet2_name
aws ec2 create-tags --resources $PRIVATE_SUBNET_2 \
--tags Key=Name,Value=$private_subnet2_name 2>&1

echo "create private subnet 2------------------>OK"

echo "Enter Private Subnet 3 CIDR"
read private_subnet3_cidr

PRIVATE_SUBNET_3=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block ${private_subnet3_cidr} \
  --availability-zone $ZONE3 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $region)

echo "Enter Private Subnet 3 Name"
read private_subnet3_name
aws ec2 create-tags --resources $PRIVATE_SUBNET_3 \
--tags Key=Name,Value=$private_subnet3_name 2>&1

echo "create private subnet 3------------------>OK"


PUBLIC_ROUTE_TABLE_ID=$(aws ec2 create-route-table \
  --vpc-id $VPC_ID \
  --query 'RouteTable.{RouteTableId:RouteTableId}' \
  --output text \
  --region $region 2>&1)
  ROUTE_TABLE_CREATE_STATUS=$?
if [ $ROUTE_TABLE_CREATE_STATUS -eq 0 ]; then
  echo "create route table------------------>OK"
else
    echo "Error:Route table not created!!"
    echo "$PUBLIC_ROUTE_TABLE_ID "
    exit $ROUTE_TABLE_CREATE_STATUS
fi


PRIVATE_ROUTE_TABLE_ID=$(aws ec2 create-route-table \
  --vpc-id $VPC_ID \
  --query 'RouteTable.{RouteTableId:RouteTableId}' \
  --output text \
  --region $region 2>&1)
  ROUTE_TABLE_CREATE_STATUS=$?
if [ $ROUTE_TABLE_CREATE_STATUS -eq 0 ]; then
  echo "create private route table------------------>OK"
else
    echo "Error:Route table not created!!"
    echo "$PRIVATE_ROUTE_TABLE_ID "
    exit $ROUTE_TABLE_CREATE_STATUS
fi


RESULT=$(aws ec2 create-route \
  --route-table-id $PUBLIC_ROUTE_TABLE_ID \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id $IGW_ID \
  --region $region 2>&1)
RESULT_STATUS=$?
if [ $RESULT_STATUS -eq 0 ]; then
  echo "CREATE ROUTE TO IGW------------------>OK"
else
    echo "Error:Route to Internet gateway not created!!"
    echo " $RESULT "
    exit $RESULT_STATUS
fi

echo "BEGIN SUBNET TO ROUTE TABLE ASSOCIATION,Please wait.........."
Public_Associate_1=$(aws ec2 associate-route-table \
  --subnet-id $PUBLIC_SUBNET_1 \
  --route-table-id $PUBLIC_ROUTE_TABLE_ID \
  --region $region)

Public_Associate_2=$(aws ec2 associate-route-table  \
  --subnet-id $PUBLIC_SUBNET_2 \
  --route-table-id $PUBLIC_ROUTE_TABLE_ID \
  --region $region)

Public_Associate_3=$(aws ec2 associate-route-table  \
  --subnet-id $PUBLIC_SUBNET_3 \
  --route-table-id $PUBLIC_ROUTE_TABLE_ID \
  --region $region)

Private_Associate_1=$(aws ec2 associate-route-table \
  --subnet-id $PRIVATE_SUBNET_1 \
  --route-table-id $PRIVATE_ROUTE_TABLE_ID \
  --region $region)

Private_Associate_2=$(aws ec2 associate-route-table  \
  --subnet-id $PRIVATE_SUBNET_2 \
  --route-table-id $PRIVATE_ROUTE_TABLE_ID \
  --region $region)

Private_Associate_3=$(aws ec2 associate-route-table  \
  --subnet-id $PRIVATE_SUBNET_3 \
  --route-table-id $PRIVATE_ROUTE_TABLE_ID \
  --region $region)


echo "BEGIN SUBNET TO ROUTE TABLE ASSOCIATION------------------>OK"
echo "Complete!!"

