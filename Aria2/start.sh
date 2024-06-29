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
Start_aria2() {
	yellow "[*] 开始检查 Aria2 程序..."
	check_installed_status
	yellow "[*] 开始设置 Aria2 配置文件..."
	set_conf
	yellow "[*] 开始检查下载目录..."
	check_download_path
	
	check_pid
	[[ -n ${PID} ]] && kill -9 "${PID}"
	green "[√] 所有步骤执行完毕，Aria2 开始启动..."
	${aria2_path} --conf-path="${aria2_conf}" -D
	check_pid
	[[ -z ${PID} ]] && red "[!] Aria2 启动失败，请检查日志！" && return 1
	green "[√] Aria2 已启动！"
}

CHECK_CORE_FILE "$@"
Start_aria2