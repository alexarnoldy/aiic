#!/bin/bash

## file-gzip-encoder-load-in-cloud-init.sh takes two arguments: the file to be gzip'd and encoded (including its path) and the cloud-init file, in which the encoded output will be inserted (also including its path)
## Note that in the write-files section of the target cloud-init file, the "content" line must be directly below the "path" line and the "encoding" line must be gz+b64

[ -z "$1" ] && echo "Usage: file-gzip-encoder-load-in-cloud-init.sh <path and file to be encoded> <path and target cloud-init file>" && exit

FILENAME=$1
BASENAME=$(basename $1)
CLOUD_INIT_FILE=$2
#CLOUD_INIT_DIR=../cloud-init/
OLD_FILE_MD5SUM=$(md5sum ${FILENAME}.gz.b64 | awk '{print$1}')

gzip -c ${FILENAME} > ${FILENAME}.gz
bash -c "cat ${FILENAME}.gz | base64 | awk '{print}' ORS='' && echo"  >  ${FILENAME}.gz.b64


## Good for troubleshooting this script when making changes
#echo "---> Old md5sum=${OLD_FILE_MD5SUM}"
#echo "---> New md5sum=$(md5sum ${FILENAME}.gz.b64 | awk '{print$1}')"


# Delete the existing "content" line. Requires that the "    content: " line is directly below the "    -path: " line
sed -i -e "/${BASENAME}/{n;d}" ${CLOUD_INIT_FILE}
# Insert the new, b64 encoded file under the ${FILENAME} location in the cloud-init file
sed -i -e "/${BASENAME}/a \ \ \ \ content: $(cat ${FILENAME}.gz.b64)" ${CLOUD_INIT_FILE}
