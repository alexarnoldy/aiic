#!/bin/bash

IFS=$'\n' read -r -d '' -a ALL_KVM_HOSTS < <( ls ./infrastructure && printf '\0' )

clear

echo "Select one or more of the following KVM hosts:"

for EACH in ${!ALL_KVM_HOSTS[@]}; do printf ${EACH}") "; echo "${ALL_KVM_HOSTS[EACH]}"; done

echo "Enter the host numbers for deployment in formats of:"
echo "a single number (i.e. 1),"
echo "a space separated list (i.e. 1 3),"
read -p "or a range (i.e. 2..4): " SELECTED_KVM_HOSTS

case ${SELECTED_KVM_HOSTS} in
       *..*)
               eval '
	       for EACH in {'"$SELECTED_KVM_HOSTS"'}; do
		#	echo ${EACH}
		       echo "${ALL_KVM_HOSTS[EACH]}"
		       #printf "${ALL_KVM_HOSTS[SELECTED_KVM_HOSTS]}"
               done
               '
               ;;
       *)
               for EACH in $(echo ${SELECTED_KVM_HOSTS})
               do
		#	echo ${EACH}
		       echo "${ALL_KVM_HOSTS[EACH]}"
			#printf "${ALL_KVM_HOSTS[SELECTED_KVM_HOSTS]}"
               done
               ;;
esac



