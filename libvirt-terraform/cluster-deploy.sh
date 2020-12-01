#!/bin/bash

## Script to deploy CaaSP clusters via Terraform across a set group of KVM hosts

###
#Variables
###
TF_DIR=${PWD}
STATE_DIR=${PWD}/state
QEMU_USER=admin
QEMU_HOST_PREFIX=infra
DOMAIN=susecon.local
ACTION="apply -auto-approve"
###

###
# START Functions
###

### NTS: 
### Need to change the state directory to be deployment oriented rather than host oriented.
### Have a directory in the state dir for each deployment.
### That dir will contain the state file for each KVM host used in that deployment plus
###   a file for the authorized_keys, the network prefix, and other custom components.
### The deployment will use -var's that cat the contents of those files, i.e. -var authorized_keys=$(cat state/${PREFIX}/authorized_keys)

function func_create_company-project_name_and_directory {
	while :
	do
	read -p  "Provide a name for this deployment of CaaS Platform clusters: " COMPANY_PROJECT_NAME
	ls ${STATE_DIR}/ | grep -q ${COMPANY_PROJECT_NAME} &&  read -n1 -p "${COMPANY_PROJECT_NAME} has already been deployed. Would you like to grow it? " GROW || break
	[ ${GROW} == y ] && break  
	done
#	sed -e '/company-project_name/ s/^#//' -e "s/^company-project_name.*$/company-project_name = "${COMPANY_PROJECT_NAME}"/" terraform.tfvars
	mkdir -p ${STATE_DIR}/${COMPANY_PROJECT_NAME}
}

function func_gather_stack_to_destroy {
	## To be run as a part of cluster_destroy.sh
	IFS=$'\n' read -r -d '' -a ALL_STACKS < <( ls ${STATE_DIR} && printf '\0' )
	clear
	for EACH in ${!ALL_STACKS[@]}; do printf ${EACH}") "; echo "${ALL_STACKS[EACH]}"; done
	echo  "Which CaaS Platform deployment would you like to destroy?: " 
	echo ""
	echo "Acceptable input formats are a single number (i.e. 0),"
	read -p "space separated list (i.e. 1 3), or a range (i.e. 0..3): " SELECTED_STACKS
	case ${SELECTED_STACKS} in
       		*..*)

               		for EACH in $(eval echo "{$SELECTED_STACKS}")
               		do
                       		COMPANY_PROJECT_NAME="${ALL_STACKS[EACH]}"
	       		done
               	;;
		*)
               		for EACH in $(echo ${SELECTED_STACKS})
               		do
                       		COMPANY_PROJECT_NAME="${ALL_STACKS[EACH]}"
	               done
       	        ;;
	esac
}

#function func_remove_stack_directory {
#	rmdir ${STATE_DIR}/${COMPANY_PROJECT_NAME} 2>/dev/null
#}

function func_select_kvm_hosts_deploy {
	rm -f /tmp/${COMPANY_PROJECT_NAME}-available-infrastructure-resources
	## Get the KVM hosts available for this invocation
	ls ./infrastructure/  >  /tmp/${COMPANY_PROJECT_NAME}-available-infrastructure
	## Remove nodes that are already in use by this deployment (in the case of growing a deployment)
	for HOSTS in $(ls ./state/${COMPANY_PROJECT_NAME}/ | sed 's/.tfstate.*//' | uniq)
	do 
		grep -v ${HOSTS} /tmp/${COMPANY_PROJECT_NAME}-available-infrastructure >> /tmp/${COMPANY_PROJECT_NAME}-available-infrastructure.tmp
		mv /tmp/${COMPANY_PROJECT_NAME}-available-infrastructure.tmp /tmp/${COMPANY_PROJECT_NAME}-available-infrastructure
	done
	## Get the amount of free memory available on each remaining host
	for KVM_HOST in $(cat /tmp/${COMPANY_PROJECT_NAME}-available-infrastructure) 
	do 
		KVM_USER=$(awk '/KVM_USER/ {print$2}' ./infrastructure/${KVM_HOST})
		MEM=$(ssh ${KVM_USER}@${KVM_HOST} grep MemFree /proc/meminfo | awk '{print$2}')
		MEM_FREE=$(echo $((${MEM} / 1024 / 1024)))
		echo ""${KVM_HOST} has ${MEM_FREE} GB of free memory"" >>  /tmp/${COMPANY_PROJECT_NAME}-available-infrastructure-resources
	done
	sort -r -k 3,3 /tmp/${COMPANY_PROJECT_NAME}-available-infrastructure-resources > /tmp/${COMPANY_PROJECT_NAME}-available-infrastructure-resources.tmp
	mv /tmp/${COMPANY_PROJECT_NAME}-available-infrastructure-resources.tmp /tmp/${COMPANY_PROJECT_NAME}-available-infrastructure-resources
	## List and select from the available hosts
	IFS=$'\n' read -r -d '' -a ALL_KVM_HOSTS < <( cat /tmp/${COMPANY_PROJECT_NAME}-available-infrastructure-resources && printf '\0' )
	#IFS=$'\n' read -r -d '' -a ALL_KVM_HOSTS < <( ls ./infrastructure && printf '\0' )
	clear
	echo "Select one or more of the following KVM hosts to target for CaaS Platform cluster deployment:"
	for EACH in ${!ALL_KVM_HOSTS[@]}; do printf ${EACH}") "; echo "${ALL_KVM_HOSTS[EACH]}"; done
	echo ""
	echo "Acceptable input formats are a single number (i.e. 0),"
	read -p "space separated list (i.e. 1 3), or a range (i.e. 0..3): " SELECTED_KVM_HOSTS
}

function func_select_kvm_hosts_destroy {
	ls ${STATE_DIR}/${COMPANY_PROJECT_NAME}
	IFS=$'\n' read -r -d '' -a ALL_KVM_HOSTS < <( ls ${STATE_DIR}/${COMPANY_PROJECT_NAME}  | sed 's/.tfstate.*//' | uniq && printf '\0' )
	clear
	echo "Select one or more of the following KVM hosts to target for CaaS Platform cluster deployment:"
	for EACH in ${!ALL_KVM_HOSTS[@]}; do printf ${EACH}") "; echo "${ALL_KVM_HOSTS[EACH]}"; done
	echo ""
	echo "Acceptable input formats are a single number (i.e. 0),"
	read -p "space separated list (i.e. 1 3), or a range (i.e. 0..3): " SELECTED_KVM_HOSTS
}

#function func_set_host.lock.file {
#	# Won't be needed after establishing a unique directory per deployment
#        until grep free host.lock.file; do (echo "waiting for host lock"; sleep 5); done
#	echo ${KVM_HOST} > host.lock.file
#}
#
#function func_release_host.lock.file {
#	# Won't be needed after establishing a unique directory per deployment
#	echo free > host.lock.file
#}

function func_update_ssh_keys_on_jumphost {
	sleep 3
	rm -f ./files/id_rsa* 
	ssh-keygen -q -t rsa -N '' -f files/id_rsa
	./files/file-gzip-encoder-load-in-cloud-init.sh ./files/id_rsa ./cloud-init/jumphost-cloud-init.tpl
	./files/file-gzip-encoder-load-in-cloud-init.sh ./files/id_rsa.pub ./cloud-init/jumphost-cloud-init.tpl
	sed -i -e "/^authorized_keys/{n;d}" terraform.tfvars
	sed -i -e "/^authorized_keys/a \"$(awk '/PUB_KEY/ {$1=""; print $0}' infrastructure/${KVM_HOST} | sed 's/^ //')\",\ \"$(cat files/id_rsa.pub)\"" terraform.tfvars
	rm -f ./files/id_rsa* 
}

function func_exec_tf_action {
	cd ${TF_DIR}; terraform ${ACTION} -state=${STATE_DIR}/${COMPANY_PROJECT_NAME}/${KVM_HOST}.tfstate -var libvirt_user=${KVM_USER} -var libvirt_hostname=${KVM_HOST} -var company-project_name=${COMPANY_PROJECT_NAME}
}

function func_clear_ssh_keys {
	sleep 5
	echo "null-and-void" > files/id_rsa
	echo "null-and-void" > files/id_rsa.pub
	./files/file-gzip-encoder-load-in-cloud-init.sh ./files/id_rsa ./cloud-init/jumphost-cloud-init.tpl
	./files/file-gzip-encoder-load-in-cloud-init.sh ./files/id_rsa.pub ./cloud-init/jumphost-cloud-init.tpl
}

###
# END Functions
###

DEPLOYorDESTROY="$(basename $0)"

[ $DEPLOYorDESTROY = cluster-destroy.sh ] && ACTION="destroy -auto-approve"
[ $DEPLOYorDESTROY = cluster-deploy.sh ] && { func_create_company-project_name_and_directory && func_select_kvm_hosts_deploy; }
[ $DEPLOYorDESTROY = cluster-destroy.sh ] && { func_gather_stack_to_destroy && func_select_kvm_hosts_destroy; }



case ${SELECTED_KVM_HOSTS} in
       *..*)
	       for EACH in $(eval echo "{$SELECTED_KVM_HOSTS}")
	       do 
		       KVM_HOST=$(echo ${ALL_KVM_HOSTS[EACH]} | awk '{print$1}')
		       KVM_USER=$(awk '/KVM_USER/ {print$2}' infrastructure/${KVM_HOST}) 
		       [ $DEPLOYorDESTROY = cluster-deploy.sh ] && func_update_ssh_keys_on_jumphost
		       func_exec_tf_action
		       [ $DEPLOYorDESTROY = cluster-destroy.sh ] && rm ${STATE_DIR}/${COMPANY_PROJECT_NAME}/${KVM_HOST}*
               done
               ;;

       *)
               for EACH in $(echo ${SELECTED_KVM_HOSTS})
               do
		       KVM_HOST=$(echo ${ALL_KVM_HOSTS[EACH]} | awk '{print$1}')
		       KVM_USER=$(awk '/KVM_USER/ {print$2}' infrastructure/${KVM_HOST}) 
		       [ $DEPLOYorDESTROY = cluster-deploy.sh ] && func_update_ssh_keys_on_jumphost
		       func_exec_tf_action
		       [ $DEPLOYorDESTROY = cluster-destroy.sh ] && rm ${STATE_DIR}/${COMPANY_PROJECT_NAME}/${KVM_HOST}*
               done
               ;;
esac

[ $DEPLOYorDESTROY = cluster-deploy.sh ] && func_clear_ssh_keys
[ $DEPLOYorDESTROY = cluster-destroy.sh ] && rmdir ${STATE_DIR}/${COMPANY_PROJECT_NAME} 2>/dev/null

