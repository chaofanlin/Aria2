#!/system/bin/sh
export PATH="/system/bin"

#当前路径
DIR=$(pwd)

DOWNLOAN_PATH="/sdcard/Download/.aira2"
SESSION="$DIR/data/aria2.session"
DHT="$DIR/data/dht.dat"
DHT6="$DIR/data/dht6.dat"
TRACKERSLIST="$DIR/data/trackerslist"

aria2_path="/data/adb/aria2c"
aria2_log="$DIR/data/aria2.log"
aria2_conf="$DIR/aria2.conf"

RED=$(printf	'\033[31m')
GREEN=$(printf	'\033[32m')
YELLOW=$(printf '\033[33m')
BLUE=$(printf	'\033[34m')
LIGHT=$(printf	'\033[1;96m')
RESET=$(printf	'\033[0m')

red() {
	echo -e "${RED}$1${RESET}"
}
green() {
	echo -e "${GREEN}$1${RESET}"
}
yellow() {
	echo -e "${YELLOW}$1${RESET}"
}
blue() {
	echo -e "${BLUE}$1${RESET}"
}
light() {
	echo -e "${LIGHT}$1${RESET}"
}

check_pid() {
	PID=$(pgrep "aria2c" | grep -v grep | grep -v "aria2.sh" | grep -v "service" | awk '{print $1}')
}

#检查文件
check_files() {
	[[ ! -e ${aria2_conf} ]] && red "[!] 配置文件 aria2.conf 缺失，请重新检查！" && return 0
	[[ ! -e ${aria2_log} ]] && red "[!] 日志文件 aria2.log 缺失，请重新检查！" && return 0
	[[ ! -e ${DHT} ]] && red "[!] 配置文件 dht.dat 缺失，请重新检查！" && return 0
	[[ ! -e ${DHT6} ]] && red "[!] 配置文件 dht6.dat 缺失，请重新检查！" && return 0
	[[ ! -e ${SESSION} ]] && red "[!] 配置文件 aria2.session 缺失，请重新检查！" && return 0
}

check_installed_status() {
	[[ -e ${aria2_path} ]] && local VERSION=$(${aria2_path} -v | egrep '^aria2 version' |  awk '{print $3}') && green "[√] Aria2 已安装，当前 Aria2 版本为: ${VERSION}" && return 0
	[[ ! -e ${aria2_path} ]] && red "[!] Aria2 未安装!" && Install_aria2 && return 0
}

check_download_path() {
    [[ -d ${DOWNLOAN_PATH} ]] &&  yellow "[*] 当前下载目录为： ${DOWNLOAN_PATH}" && return 0
    red "[!] 下载目录不存在，正在进行创建..."
    mkdir -p ${DOWNLOAN_PATH} 
    green "[√] 下载目录创建成功！"
    yellow "[*] 当前下载目录为： ${DOWNLOAN_PATH}" 
}

set_conf() {
	check_files
	#DOWNLOAN_DIR=$(sed -n '/^dir=/s/^dir=//p' ${aria2_conf})
    sed -i "s@^\(dir=\).*@\1${DOWNLOAN_PATH}@" "${aria2_conf}"
	sed -i "s@^\(input-file=\).*@\1${SESSION}@" "${aria2_conf}"
	sed -i "s@^\(save-session=\).*@\1${SESSION}@" "${aria2_conf}"
	sed -i "s@^\(log=\).*@\1${aria2_log}@" "${aria2_conf}"
	update_tracker
	green "[√] Aria2 配置文件设置成功！"
}

update_tracker() {
	tracker=$(<${TRACKERSLIST})
	sed -i "s@^\(bt-tracker=\).*@\1${tracker}@" "${aria2_conf}"
}

#安装aria2c
Install_aria2() {
	yellow "[*] 开始安装 Aria2 ..."
	[[ ! -e ${DIR}/aria2c ]] && red "[!] 当前目录下缺失 aria2c 文件，请重新检查！" && return 0
	cp "${DIR}/aria2c" "${aria2_path}" && chmod -R 0775 "${aria2_path}"
	green "[√] Aria2 安装成功!"
}














