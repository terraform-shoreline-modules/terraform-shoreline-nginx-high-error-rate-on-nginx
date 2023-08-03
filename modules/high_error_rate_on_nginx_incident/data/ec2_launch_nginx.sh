aws ec2 run-instances \

    --count $INSTANCE_COUNT \

    --instance-type $INSTANCE_TYPE \

    --launch-template LaunchTemplateId=$LAUNCH_TEMPLATE_ID \

    --user-data file://nginx_install_script.sh