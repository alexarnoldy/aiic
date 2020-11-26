#!/bin/bash 

STACK_NAME=test2

rm -f /tmp/${STACK_NAME}-available-infrastructure-resources

## Get the KVM hosts available to this tool
ls ./infrastructure/  >  /tmp/${STACK_NAME}-available-infrastructure

## Remove nodes that are already in use by this deployment (in the case of growing a deployment)
for HOSTS in $(ls ./state/${STACK_NAME}/ | sed 's/.tfstate.*//')
do 
	grep -v ${HOSTS} /tmp/${STACK_NAME}-available-infrastructure >> /tmp/${STACK_NAME}-available-infrastructure.tmp
	mv /tmp/${STACK_NAME}-available-infrastructure.tmp /tmp/${STACK_NAME}-available-infrastructure
done

## Get the amount of free memory available on each remaining host
for KVM_HOST in $(cat /tmp/${STACK_NAME}-available-infrastructure) 
do 
	KVM_USER=$(awk '/KVM_USER/ {print$2}' ./infrastructure/${KVM_HOST})
	MEM=$(ssh ${KVM_USER}@${KVM_HOST} grep MemFree /proc/meminfo | awk '{print$2}')
	MEM_FREE=$(echo $((${MEM} / 1024 / 1024)))
	echo ""${KVM_HOST} has ${MEM_FREE} GB of free memory"" >>  /tmp/${STACK_NAME}-available-infrastructure-resources
done

sort -r -k 3,3 /tmp/${STACK_NAME}-available-infrastructure-resources > /tmp/${STACK_NAME}-available-infrastructure-resources.tmp
mv /tmp/${STACK_NAME}-available-infrastructure-resources.tmp /tmp/${STACK_NAME}-available-infrastructure-resources

