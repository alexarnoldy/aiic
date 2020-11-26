#!/bin/bash

FILENAME=deploy_caasp.sh
CLOUD_INIT_FILE=jumphost-cloud-init.tpl
CLOUD_INIT_DIR=../cloud-init/
OLD_FILE_MD5SUM=$(md5sum ${FILENAME}.gz.b64 | awk '{print$1}')
#echo -n "    content: " > ${FILENAME}-content.txt
gzip -c ${FILENAME} > ${FILENAME}.gz
./encoder.sh ${FILENAME}.gz
#cat ${FILENAME}-content.txt ${FILENAME}.gz.b64 > ${FILENAME}.gz.b64.tmp
#mv ${FILENAME}.gz.b64.tmp ${FILENAME}.gz.b64
echo "---> Old md5sum=${OLD_FILE_MD5SUM}"
echo "---> New md5sum=$(md5sum ${FILENAME}.gz.b64 | awk '{print$1}')"
#cat ${FILENAME}.gz.b64

# Insert the new, b64 encoded file under the ${FILENAME} location in the cloud-init file
# Requires that the "    content: " line is directly below the "    -path: " line
sed -i -e "/${FILENAME}/{n;d}" ${CLOUD_INIT_DIR}${CLOUD_INIT_FILE}
sed -i -e "/${FILENAME}/a \ \ \ \ content: $(cat ${FILENAME}.gz.b64)" ${CLOUD_INIT_DIR}${CLOUD_INIT_FILE}
