#!/bin/bash

# customize with your own.
#options=("AAA" "BBB" "CCC" "DDD")
IFS=$'\n' read -r -d '' -a options < <( ls ./infrastructure && printf '\0' )


clear
menu() {
    echo "Avaliable options:"
    for i in ${!options[@]}; do 
        printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${options[i]}"
    done
    if [[ "$msg" ]]; then echo "$msg"; fi
}

prompt="Check an option (again to uncheck, ENTER when done): "
while menu && read -rp "$prompt" num && [[ "$num" ]]; do
    [[ "$num" != *[![:digit:]]* ]] &&
    (( num > 0 && num <= ${#options[@]} )) ||
    { msg="Invalid option: $num"; continue; }
    ((num--)); msg="${options[num]} was ${choices[num]:+un}checked"
    [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="+"
    clear
done
clear

#printf "You selected"; msg=" nothing"
for EACH in ${!options[@]}; do 
	HOSTNAME=
#    [[ "${choices[EACH]}" ]] && { printf " %s" "${options[EACH]}"; msg=""; }
    [[ "${choices[EACH]}" ]] && HOSTNAME="${options[EACH]}" && echo $HOSTNAME
done
#echo "$msg"

