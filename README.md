
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High error rate on NGINX incident
---

The "High error rate on NGINX" incident type refers to a situation where the error rate on the NGINX server is above 1% for the last 5 minutes. This can result in degraded performance or downtime of the affected service, impacting user experience and potentially leading to lost revenue. The incident requires immediate attention and resolution to minimize the impact on users and prevent further damage.

### Parameters
```shell
# Environment Variables

export NGINX_PID="PLACEHOLDER"

export NETWORK_INTERFACE="PLACEHOLDER"

export TARGET_GROUP_ARN="PLACEHOLDER"

export LAUNCH_TEMPLATE_ID="PLACEHOLDER"

export INSTANCE_TYPE="PLACEHOLDER"

export NUMBER_OF_INSTANCES="PLACEHOLDER"
```

## Debug

### Check the status of the NGINX service
```shell
systemctl status nginx
```

### Check the error log for NGINX
```shell
tail -n 100 /var/log/nginx/error.log
```

### Check the access log for NGINX
```shell
tail -n 100 /var/log/nginx/access.log
```

### Check the NGINX configuration file for syntax errors
```shell
nginx -t
```

### Check the NGINX configuration file for errors in the upstream server configuration
```shell
grep -r "upstream" /etc/nginx/
```

### Check the system load average
```shell
uptime
```

### Check the CPU usage of the NGINX process
```shell
ps -p ${NGINX_PID} -o %cpu
```

### Check the memory usage of the NGINX process
```shell
ps -p ${NGINX_PID} -o %mem
```

### Check the network traffic on the NGINX server
```shell
iftop -i ${NETWORK_INTERFACE}
```

### Check the NGINX configuration for the maximum number of connections allowed
```shell
grep -r "worker_connections" /etc/nginx/
```

## Repair

### Define variables
```shell
INSTANCE_COUNT=${NUMBER_OF_INSTANCES}

INSTANCE_TYPE=${INSTANCE_TYPE}

LAUNCH_TEMPLATE_ID=${LAUNCH_TEMPLATE_ID}

TARGET_GROUP_ARN=${TARGET_GROUP_ARN}
```

### Add more instances to serve increased load
```shell
aws ec2 run-instances \

    --count $INSTANCE_COUNT \

    --instance-type $INSTANCE_TYPE \

    --launch-template LaunchTemplateId=$LAUNCH_TEMPLATE_ID \

    --user-data file://nginx_install_script.sh
```

### Wait for the new instances to start running
```shell
aws ec2 wait instance-running
```

### Get the IDs of the new instances
```shell
NEW_INSTANCE_IDS=$(aws ec2 describe-instances \

    --filters "Name=instance-state-name,Values=running" \

    --query "Reservations[].Instances[].InstanceId")
```

### Register the new instances with the target group
```shell
aws elbv2 register-targets \

    --target-group-arn $TARGET_GROUP_ARN \

    --targets Id=$NEW_INSTANCE_IDS
```