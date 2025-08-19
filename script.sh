#!/bin/bash
threshold1=80
threshold2=60

echo "***************** memory usage: *****************"
free -m

echo "***************** disk usage: *****************"
df -h

# Disk usage check
df -h --output=pcent,target | tail -n +2 | while read line;
do
    usage=$(echo $line | awk '{print $1}' | tr -d '%')
    mountpoint=$(echo $line | awk '{print $2}')

    if [ "$usage" -gt "$threshold1" ]
    then
        echo "**************** disk usage is high, restart instance! ALERT ******************"
    else
        echo "****************** disk usage is good ***********************"
    fi
done

# Memory usage check
usage1=$(free -m | awk 'NR==2{printf "%.0f", $3*100/$2}')

if [ "$usage1" -gt "$threshold2" ]
then
    echo "************ memory usage is high, restart the instance! ALERT ************"
else
    echo "************ memory usage is perfectly fine ***************"
fi

echo "************** current user: *****************"
whoami

echo "****************** current date and time: ************"
date

# Install Apache2
echo "************** installing apache2 *************"
apt install apache2 -y
if [ $? -eq 0 ]
then
    echo "************** apache2 is installed **************"
    echo "*********** status: ***************"
    systemctl status apache2
else
    echo "*************** not installed, some problem occurred ***********"
fi

# Install Python3 + pip
echo "************** installing python3, pip *************"
sudo apt install -y python3 python3-pip
if [ $? -eq 0 ]
then
    echo "************** python3 + pip installed successfully ***********"
    echo "********** version **************"
    python3 --version
    pip3 --version
else
    echo "************ python3 + pip not installed, problem occurred ******"
fi

# Install Ansible
sudo apt install ansible -y
if [ $? -eq 0 ]
then
    echo "************** ansible installed successfully *************"
else
    echo "*************** unable to install ansible *************"
fi

# Install AWS CLI
snap install aws-cli --classic
if [ $? -eq 0 ]
then
    echo "************ aws cli installed **********"
    echo "*************** configure: ************"
    aws configure
    echo "********** IAM credentials entered successfully **************"
else
    echo "************** unable to install aws-cli *************"
fi
