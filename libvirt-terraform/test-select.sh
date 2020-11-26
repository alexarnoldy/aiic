#!/bin/bash

echo "select a host"
select HOST in $(ls infrastructure)
do
	echo ${HOST}
	break
done
