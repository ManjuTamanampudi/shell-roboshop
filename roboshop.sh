#!/bin/bash

SG_ID="sg-0759ad8dc1a8ac235"
AMI_ID="ami-0220d79f3f480ecf5"
R='\-e[31m'
G='\-e[32m'
Y='\-e[33m'
N='\-e[0m'
echo "exicuting"
for INSTANCE in $@
do
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --count 1 \
    --instance-type t3.micro \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value='$INSTANCE'}]" \
    --query 'Instances[*].InstanceId' \
    --output text
)

IP_ADDRESSES=$(
    aws ec2 describe-instances \
    --instance-ids i-0123456789abcdef0 \
    --query "Reservations[*].Instances[*].[PrivateIpAddress, PublicIpAddress]" \
    --output text
)
echo "IP_ADDRESSES :  $IP_ADDRESSES "
if [ $INSTANCE = "frontend" ]; then
echo -e "Public ip :  $IP_ADDRESSES.Reservations[*].Instances[*].[PublicIpAddress] "
else
echo -e "Public ip :  $IP_ADDRESSES.Reservations[*].Instances[*].[PrivateIpAddress] "
fi
done

