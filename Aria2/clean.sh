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

clean() {
	red "[!] 将会删除 torrent/aria2 文件，请注意风险！"
	yellow "[*] 等待5秒后，将开始脚本！"
	sleep 5
	rm -f ${DOWNLOAN_PATH}/*.torrent
	green "[√] .torrent 文件已全部删除！"
	rm -f ${DOWNLOAN_PATH}/*.aria2
	green "[√] .aria2 文件已全部删除！"
	find ${DOWNLOAN_PATH} -type d -empty -exec rmdir {} +	
	green "[√] 空文件夹已全部删除！"
	echo > "${aria2_log}"
	green "[√] LOG 日志文件已清空！"
}

CHECK_CORE_FILE
clean