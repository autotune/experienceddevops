#!/bin/bash
yum install docker -y 
yum install git -y
service docker start
wget https://github.com/docker/compose/releases/download/v2.5.1/docker-compose-linux-x86_64 && mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

git clone https://github.com/autotune/django.git

cd django && /usr/local/bin/docker-compose run web django-admin startproject composeexample .

cp settings.py composeexample

/usr/local/bin/docker-compose up -d

printf '
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone  | sed -e "s/.$//")

PERFTEST="$(aws ec2 describe-tags --filters "Name=resource-id,Values=$(curl http://169.254.169.254/latest/meta-data/instance-id)" --region $REGION |jq -r ".Tags[]|select(.Key == \\"PerfTest\\").Value")"

if [[ $PERFTEST == "CPU" ]];
then
    printf "$(stress --cpu 8)"

else
    pkill stress
fi

' > /root/failwhale.sh

crontab -l | { cat; echo "*/1 * * * * bash /root/failwhale.sh"; } | crontab -
