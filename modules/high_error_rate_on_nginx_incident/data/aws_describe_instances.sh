NEW_INSTANCE_IDS=$(aws ec2 describe-instances \

    --filters "Name=instance-state-name,Values=running" \

    --query "Reservations[].Instances[].InstanceId")