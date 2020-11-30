export TMP_FILE="/tmp/$(date +'%s')"
rm -f ${TMP_FILE}
for HOST in $(ls infrastructure/ | sed 'y/@-./___/')
do
echo "${HOST}_primary_instances=0" >> "${TMP_FILE}_primary_instances"
echo "${HOST}_secondary_instances=0" >> "${TMP_FILE}_secondary_instances"
echo "${HOST}_tertiary_instances=0" >> "${TMP_FILE}_tertiary_instances"
done

PRIMARY_INSTANCES=7
SECONDARY_INSTANCES=3
TERTIARY_INSTANCES=1

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

