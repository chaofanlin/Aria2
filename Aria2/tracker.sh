#!/system/bin/sh
export PATH="/system/bin"

#当前路径
DIR=$(pwd)

URL="https://raw.kkgithub.com/chaofanlin/trackerslist/main/trackerslist"
DL_TRACKERSLIST="$DIR/trackerslist"

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

Get_tracker() {
	Stop_aria2
	set_conf
	check_download_path
	yellow "[*] 清除旧 trackerslist 文件..."
	rm -f ${DL_TRACKERSLIST}
	#rm -f ${TRACKERSLIST}
	yellow "[*] 启动 Aria2 进行下载..."
	${aria2_path} --conf-path="${aria2_conf}" >/dev/null 2>&1 &
	${aria2_path} -c "${URL}" --check-certificate=false
	green "[√] 下载完成！"
	mv -f ${DL_TRACKERSLIST} ${TRACKERSLIST}
	check_pid
	kill -9 "${PID}"
	yellow "[*] 重设 CONF 配置文件..."
	set_conf
	green "[√] CONF 配置文件设置完成，请重新启动 Aria2！"
}

CHECK_CORE_FILE "$@"
Get_tracker