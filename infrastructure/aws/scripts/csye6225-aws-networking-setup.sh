#!/bin/bash
#***********************************************************************************
#    AWS VPC Creation Shell Script
#***********************************************************************************
. ./config.sh
if [ $# -eq 0 ]; then
echo "PLEASE PASS <STACK_NAME> as parameter while running your script"
exit 1
fi


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



PUBLIC_SUBNET_1=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block ${subnet_cidr[0]} \
  --availability-zone $ZONE1 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $region)

echo "create subnet 1------------------>OK"


PUBLIC_SUBNET_2=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block ${subnet_cidr[1]} \
  --availability-zone $ZONE2 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $region)

echo "create subnet 2------------------>OK"


PUBLIC_SUBNET_3=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block ${subnet_cidr[2]} \
  --availability-zone $ZONE3 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $region)

echo "create subnet 3------------------>OK"


PRIVATE_SUBNET_1=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block ${subnet_cidr[3]} \
  --availability-zone $ZONE1 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $region)

echo "create private subnet 1------------------>OK"


PRIVATE_SUBNET_2=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block ${subnet_cidr[4]} \
  --availability-zone $ZONE2 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $region)

echo "create private subnet 2------------------>OK"



PRIVATE_SUBNET_3=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block ${subnet_cidr[5]} \
  --availability-zone $ZONE3 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $region)

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
echo "Complent!!"

