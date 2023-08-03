aws elbv2 register-targets \

    --target-group-arn $TARGET_GROUP_ARN \

    --targets Id=$NEW_INSTANCE_IDS