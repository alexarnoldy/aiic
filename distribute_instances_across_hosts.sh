## Set stack name with first command argument
#STACK_NAME=$1
STACK_NAME=test

## Create list of eligible KVM hosts, sorted by the highest amount of free memory
rm -f /tmp/${STACK_NAME}-available-infrastructure-resources
for KVM_HOST in $(ls infrastructure/) 
do  
	echo ${KVM_HOST} 
	MEM=$(ssh ${KVM_HOST} grep MemFree /proc/meminfo | awk '{print$2}')
	MEM_FREE=$(echo $((${MEM} / 1024 / 1024)))
	## Disqualifies any nodes that have less than 16 GB of free memory, assuming a new deployment might take up to 10 GB of memory, leaving only 6 GB for the host
	(( ${MEM_FREE} >= 16 )) && echo ""${KVM_HOST} has ${MEM_FREE} GB of free memory"" >>  /tmp/${STACK_NAME}-available-infrastructure-resources
done
sort -r -k 3,3 /tmp/${STACK_NAME}-available-infrastructure-resources > /tmp/${STACK_NAME}-available-infrastructure-resources.tmp
mv /tmp/${STACK_NAME}-available-infrastructure-resources.tmp /tmp/${STACK_NAME}-available-infrastructure-resources


##### Somewhere around here
##### need to create the 
##### stack directory name
##### with a subdirectory
##### for each KVM host
##### and copy a base copy
##### of the .tfvars file
##### into each subdirectory


## Create a unique base file name
export TMP_FILE="/tmp/$(date +'%s')"
rm -f ${TMP_FILE}

## Create three files, for the three instance types, that list the eligible hosts, pre-sorted based on the highest amount of free memory
for HOST in $(awk '{print$1}' /tmp/${STACK_NAME}-available-infrastructure-resources | sed 'y/@-./___/')
#for HOST in $(ls infrastructure/ | sed 'y/@-./___/')
do
echo "${HOST}_primary_instances=0" >> "${TMP_FILE}_primary_instances"
echo "${HOST}_secondary_instances=0" >> "${TMP_FILE}_secondary_instances"
echo "${HOST}_tertiary_instances=0" >> "${TMP_FILE}_tertiary_instances"
done

## Assign variables from command arguments
#PRIMARY_INSTANCES=$2
#SECONDARY_INSTANCES=$3
#TERTIARY_INSTANCES=$4
PRIMARY_INSTANCES=7
SECONDARY_INSTANCES=3
TERTIARY_INSTANCES=1

## While loop to sort the number of primary instances across the eligible KVM hosts
while [ ${PRIMARY_INSTANCES} -gt 0 ]
do

        for EACH_HOST in $(cat ${TMP_FILE}_primary_instances)
do
        echo "PRIMARY_INSTANCES=${PRIMARY_INSTANCES}"
        HOST=$(grep ${EACH_HOST} "${TMP_FILE}_primary_instances" | awk -F= '{print$1}')
        VALUE=$(grep ${EACH_HOST} "${TMP_FILE}_primary_instances" | awk -F= '{print$2}')
#       VALUE=$((${VALUE} + 1)) 
        (( ${PRIMARY_INSTANCES} >= 1 )) && VALUE=$((${VALUE} + 1)) && sed -i "/${HOST}/ s/\=.*/\=${VALUE}/" "${TMP_FILE}_primary_instances"
        PRIMARY_INSTANCES=$((${PRIMARY_INSTANCES} - 1))
done
done

## While loop to sort the number of secondary instances across the eligible KVM hosts
while [ ${SECONDARY_INSTANCES} -gt 0 ]
do

        for EACH_HOST in $(cat ${TMP_FILE}_secondary_instances)
do
        echo "SECONDARY_INSTANCES=${SECONDARY_INSTANCES}"
        HOST=$(grep ${EACH_HOST} "${TMP_FILE}_secondary_instances" | awk -F= '{print$1}')
        VALUE=$(grep ${EACH_HOST} "${TMP_FILE}_secondary_instances" | awk -F= '{print$2}')
#       VALUE=$((${VALUE} + 1)) 
        (( ${SECONDARY_INSTANCES} >= 1 )) && VALUE=$((${VALUE} + 1)) && sed -i "/${HOST}/ s/\=.*/\=${VALUE}/" "${TMP_FILE}_secondary_instances"
        SECONDARY_INSTANCES=$((${SECONDARY_INSTANCES} - 1))
done
done

## While loop to sort the number of tertiary instances across the eligible KVM hosts
while [ ${TERTIARY_INSTANCES} -gt 0 ]
do

        for EACH_HOST in $(cat ${TMP_FILE}_tertiary_instances)
do
        echo "TERTIARY_INSTANCES=${TERTIARY_INSTANCES}"
        HOST=$(grep ${EACH_HOST} "${TMP_FILE}_tertiary_instances" | awk -F= '{print$1}')
        VALUE=$(grep ${EACH_HOST} "${TMP_FILE}_tertiary_instances" | awk -F= '{print$2}')
#       VALUE=$((${VALUE} + 1)) 
        (( ${TERTIARY_INSTANCES} >= 1 )) && VALUE=$((${VALUE} + 1)) && sed -i "/${HOST}/ s/\=.*/\=${VALUE}/" "${TMP_FILE}_tertiary_instances"
        TERTIARY_INSTANCES=$((${TERTIARY_INSTANCES} - 1))
done
done

