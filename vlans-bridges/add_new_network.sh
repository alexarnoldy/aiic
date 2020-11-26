#!/bin/bash

#### Shell script to create a new vlan and bridge via ansible-playbooks

## Functions

function func_add_network {
read -n 1 -p "Ready to create new network on the targeted infrastructure hosts? (y/n) " CONTINUE

case $CONTINUE in
	y)
		echo ""
		echo "Continuing..."
		sleep 2
		;;
	*)
		echo "Exiting."
		exit
		;;
esac


## To create a specific network, echo that number and double-redirect into ./.free_nets before running this script
cp -np ./.free_nets .bak/.free_nets.`date +"%d.%b.%Y.%H.%M"`
cp -np ./.configured_nets .bak/.configured_nets.`date +"%d.%b.%Y.%H.%M"`
export NEW_BRIDGE=$(tail -1 ./.free_nets)

## Need to communicate that ${NEW_BRIDGE} is the network that has been created for this iteration

## Move the new bridge from .free_nets to .configured_nets
bash -c "echo ${NEW_BRIDGE} >> ./.configured_nets &&\
sed -i "/${NEW_BRIDGE}/d" ./.free_nets"
}

function func_remove_network {
	IFS=$'\n' read -r -d '' -a ALL_NETS < <(cat ./.configured_nets && printf '\0')
	for EACH in ${!ALL_NETS[@]}; do printf ${EACH}") "; echo "${ALL_NETS[EACH]}"; done
	echo "Which networks would you like to remove?: "
	echo ""
        echo "Acceptable input formats are a single number (i.e. 0),"
        read -p "space separated list (i.e. 1 3), or a range (i.e. 0..3): " SELECTED_NETS
        case ${SELECTED_NETS} in
                *..*)

                        for EACH in $(eval echo "{$SELECTED_NETS}")
                        do
				bash -c "echo ${ALL_NETS[EACH]} >> ./.free_nets &&\
					sed -i "/${ALL_NETS[EACH]}/d" ./.configured_nets"
                        done
                ;;
                *)
                        for EACH in $(echo ${SELECTED_NETS})
                        do
				bash -c "echo ${ALL_NETS[EACH]} >> ./.free_nets &&\
					sed -i "/${ALL_NETS[EACH]}/d" ./.configured_nets"
                       done
                ;;
        esac
}


ADDorRemove="$(basename $0)"

[ ${ADDorRemove} = add_new_network.sh ] && func_add_network
[ ${ADDorRemove} = remove_networks.sh ] && func_remove_network

## Iterate over the infrastructure hosts to create any bridges that are listed in ./.configured_nets but not configured on each host
for NODE in $(ls ../infrastructure) 
do

## Iterate over the existing networks on this node to verify they are listed in ./.configured_nets and remove them if they are not
RESTART_NETWORK=0
REMOVE_STALE_BRIDGES=()
for EXISTING_BRIDGES in $(ssh ${NODE} sudo ls /etc/sysconfig/network/ifcfg-br* | egrep -v "br200|br210" | awk -F-br '{print$2}')
do
	test -z $(grep ${EXISTING_BRIDGES} ./.configured_nets) && REMOVE_STALE_BRIDGES+=(${EXISTING_BRIDGES}) && RESTART_NETWORK=1
done

echo Bridges to be removed on ${NODE} are: ${REMOVE_STALE_BRIDGES[@]}

for BRIDGE_NUM in "${REMOVE_STALE_BRIDGES[@]}"
do
#	ssh ${NODE} echo ${BRIDGE_NUM}
	ssh ${NODE} sudo mv /etc/sysconfig/network/ifcfg-br${BRIDGE_NUM} ~/stale_bridges/
	ssh ${NODE} sudo mv /etc/sysconfig/network/ifcfg-vlan${BRIDGE_NUM} ~/stale_bridges/
done


## Iterate over the ./.configured_nets file to create networks that should exist
CREATE_NEW_BRIDGES=()
for CONFIGURED_BRIDGES in $(cat ./.configured_nets)
do      
	test -z  $(ssh ${NODE} sudo ls /etc/sysconfig/network/ifcfg-br* | grep ${CONFIGURED_BRIDGES} | awk -F-br '{print$2}') && CREATE_NEW_BRIDGES+=(${CONFIGURED_BRIDGES}) && RESTART_NETWORK=1

done
echo Bridges to be configured on ${NODE} are: ${CREATE_NEW_BRIDGES[@]}

	## Iterate over ${CREATE_NEW_BRIDGES[@]} to perform the bridge and vlan creation
	for BRIDGE_NUM in "${CREATE_NEW_BRIDGES[@]}"
	do
		sed "s/XYZ/${BRIDGE_NUM}/" ifcfg-brXYZ > ifcfg-br${BRIDGE_NUM}
		sed "s/XYZ/${BRIDGE_NUM}/" ifcfg-vlanXYZ > ifcfg-vlan${BRIDGE_NUM}
		scp ifcfg-*${BRIDGE_NUM} ${NODE}:~ && ssh ${NODE} sudo mv ifcfg-*${BRIDGE_NUM} /etc/sysconfig/network/ && rm ifcfg-*${BRIDGE_NUM}
	done
	echo restart_network=${RESTART_NETWORK}
	[ ${RESTART_NETWORK} == 1 ] && ssh ${NODE} nohup sudo systemctl restart network.service

	## Deploy vyos router and jumphost
done




