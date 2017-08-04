#!/bin/sh

##########
##config##
##########

disclamer=none #show possibilities with cowsay -l (none for disable)
disclamer_message="Restricted area, authorized personnel only!"
entity_name="zmotd"

##########
##########

clear
figlet $entity_name
printf "Host: $(hostname)\n"

printf "Distribution: $(cat /etc/redhat-release)\n"

printf "Kernel: $(uname -r)\n"
printf "\n"

llog=(`last -i $USER | grep -v 'still logged' | head -1`)

printf "Last login: %s %s %s at %s from %s" ${llog[3]} ${llog[4]} ${llog[5]} ${llog[6]} ${llog[2]}
printf "\n"
printf "\n"

load=(`cat /proc/loadavg`)

printf "Load average: %s %s %s\n" ${load[0]} ${load[1]} ${load[2]}
mem=(`free -h | grep Mem`)
printf "Memory usage : %s of %s\n" ${mem[2]} ${mem[1]}
up=`uptime -p | cut -c 3-`
printf "Uptime: $up\n"

printf "\n"

fw= `firewall-cmd --state -q`
if [ $? -eq 0 ]
then
    printf "Firewall state: running\n"
else
    printf "Firewall state: \033[31mnot running\e[0m\n"
fi

se=`getenforce`
printf "SELinux status: $se\n"

printf "\n"

df -h | tail -n +2 | while read u
do
usage=($u)
   	cur=${usage[4]:0:-1}
   	if [[ $cur -gt 80 ]]
   	then
   		printf "\033[31m"
   	fi
   	printf "Usage on %s: %s of %s\n" ${usage[5]} ${usage[4]} ${usage[1]}
   	printf "\e[0m"
done

if [ $disclamer != "none" ]
then
printf "\n"
    cowsay -f /usr/share/cowsay/${disclamer}.cow $disclamer_message
    printf "\n"
fi

printf "\n"
