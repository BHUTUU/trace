##!/usr/bin/env bash #uncomment in linux environment!
#<<<========Inbuilt Varialbles and values========>>>
CWD=$(pwd)
OS=$(uname -o)
#if [ "${OS,,}" == *'android'* ]; then
#    if [ "$CWD" == *'com.termux'* ]; then
#        export PREFIX='/data/data/com.termux/files/usr'
#        INS() {
#            apt install $1 -y
#        }
#    else
#        printf "\033[32m[\033[31m!\033[32m] \033[34mYou are using unknown softarware! you may edit this script to run it on your software!\033[00m\n"
#        exit 1
#    fi
#elif [ "${OS,,}" == *'linux'* ]; then
#    export PREFIX='/usr'
#    INS() {
#        sudo apt install $1 -y
#    }
#else
#    printf "\033[32m[\033[31m!\033[32m] \033[34mYou are using unknown softarware! you may edit this script to run it on your software!\033[00m\n"
#    exit 1
#fi
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
pkgs=(git wget curl php)
for p in "${pkgs}"; do
    if ! hash ${p} >/dev/null 2>&1; then
        printf "${S4}Package${S1}: ${S2}${p} not found! ${S1}::${S2} Installing.....${R0}\n"
        INS "${p}" >/dev/null 2>&1
    fi
done
#<<<=========Program=========>>>
#lets tests for login page lol this program is in process not completed!! so dont use now
cd assets
hostit #using my liveserver for testing
