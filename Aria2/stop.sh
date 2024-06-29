#!/system/bin/sh
export PATH="/system/bin"

#当前路径
DIR=$(pwd)

CHECK_CORE_FILE() {
	CORE_FILE="$(pwd)/main.sh"
    if [[ -e "${CORE_FILE}" ]]; then
		. "${CORE_FILE}"
	else echo "**** 核心文件 main.sh 缺失！ ****" && exit 1
	fi
}

Stop_aria2() {
	yellow "[*] 开始检查 Aria2 程序..."
	check_installed_status
	check_pid
	[[ -z ${PID} ]] && red "[!] Aria2 未启动，请检查日志！" && return 0
	kill -9 "${PID}"
	green "[√] Aria2 已关闭！"
}

CHECK_CORE_FILE "$@"
Stop_aria2