#!/bin/bash
#
# 在终端输入 ff-zip.sh 即可打开脚本
#

# 脚本版本
VERSION='0.0.1'

function on_wait(){
	if [ "$1" != "" ];then
		sleep $1
	else
		printf "\n按下任意键继续: "
		read -n 1
	fi
}
function on_success(){
	if [ "$1" != "" ];then
		printf "> \033[32m%s！\033[0m\n" $1
	else
		printf "> \033[32m操作成功！\033[0m\n"
	fi
}
function on_fail(){
	if [ "$1" != "" ];then
		printf "\n> \033[31m%s！\033[0m\n" $1
	else
		printf "\n> \033[31m操作失败！\033[0m\n"
	fi
	printf "我们都有不顺利的时候。\n"
	on_wait
}

# 在新的脚本中，输出更新信息，并提交文件改动
function on_updated(){
	function success(){
		if [[ "$PARAM2" != "" ]]; then
			printf "\n> \033[32m%s！\033[0m\t%s\n" "更新成功" "${PARAM2} -> ${VERSION}" && on_wait 2
		fi
	}
	chmod 777 $HOME/Downloads/ff-zip.sh &&
	printf "\n> 请输入密码来更新脚本\n" &&
	if [ ! -d '/usr/local/bin']; then
	  sudo mkdir '/usr/local/bin'
	fi
	sudo mv $HOME/Downloads/ff-zip.sh '/usr/local/bin/ff-zip.sh' && success || on_fail
	PARAM1="" && PARAM2="" && PARAM3="" && PARAM4=""
}

# 更新脚本
function cmd_update(){
	# 下载脚本
	function download(){
		curl -f -o $HOME/Downloads/ff-zip.sh 'https://raw.githubusercontent.com/JonyFang/ff-zip.sh/main/ff-zip.sh' -#
	}
	# 启动脚本，并传入参数
	function install(){
		chmod 777 $HOME/Downloads/ff-zip.sh
		. $HOME/Downloads/ff-zip.sh __on_updated $VERSION
	}
	function on_update_fail(){
		printf "\n> \033[31m%s\033[0m\n" "更新失败！请尝试重新安装："
		printf "curl -s https://raw.githubusercontent.com/JonyFang/ff-zip.sh/main/ff-zip.sh | bash -s ff-zip.sh\n"
		on_wait

	}
	printf "\n> 正在更新...\n"
	download && install || on_update_fail
	PARAM1=""
	PARAM2=""
}

function cmd_init(){
	function auto_ff() {
		on_success "ff-zip 准备就绪"
	}
	printf "\n> 请坐和放宽，我正在帮你搞定一切...\n"
	auto_ff || on_fail
}

function cmd_install(){
  case $PARAM2 in
  	*) $PARAM2 ;;
  esac
  PARAM2=""
}

function start(){
	function cmd_help(){
		function wait(){
			on_wait 0.02
		}

		printf "\n脚本:\n" && wait
		printf "  \033[1m\033[32m%-s\033[0m %s \033[1m\033[32m%-s\033[0m \t %s \n" 'cd' '+' '`path`' '压缩的文件路径'

		printf "\n更多:\n" && wait
		printf "  \033[1m\033[32m%-s\033[0m %s \t %s \n" 'docs' '' '查看文档(https://raw.githubusercontent.com/JonyFang/ff-zip.sh/main/README.md)' && wait
		printf "  \033[1m\033[32m%-s\033[0m %s \t %s \n" 'gh' '(github)' 'GitHub页面(https://github.com/JonyFang/ff-zip.sh)' && wait
		printf "  \033[1m\033[32m%-s\033[0m %s \t %s%s%s \n" 'u' '(update)' '更新脚本文件(当前版本：' ${VERSION} ')' && wait

		printf "\n\n" && wait
		on_wait
	}
	while :
	do
		if [ "$PARAM1" == "" ];then
			clear
			echo '==================== FF Zip Utilities ===================='
			printf "常用:\n"
			printf "  \033[1m\033[32m%-s\033[0m %s \033[1m\033[32m%-s\033[0m \t %s \n" 'cd' '+' '`path`' '压缩的文件路径'
			printf "\n更多:\n"
			printf "  \033[1m\033[32m%-s\033[0m %s \t %s%s%s \n" 'u' '(update)' '更新脚本文件(当前版本：' ${VERSION} ')'
			printf "  \033[1m\033[32m%-s\033[0m \t\t %s \n" 'help'  '查看全部指令'
			echo '--------------------------------------------------------'
			read -p "请输入指令: " PARAM1 PARAM2
		fi
		case $PARAM1 in
    		# 安装
			'i'|'install') cmd_install ;;
			# 自动
			'init') cmd_init ;;
			# 脚本
			'cd') cd $PARAM2 && on_success && on_wait 1 || on_fail;;
			'docs') open https://raw.githubusercontent.com/JonyFang/ff-zip.sh/main/README.md ;;
			'gh'|'github') open https://github.com/JonyFang/ff-zip.sh ;;
			'u'|'update') cmd_update ;;
			'help') cmd_help ;;
			# private
			'__on_updated') on_updated ;;
			'__init') cmd_init ;;
			'q'|'Q') exit ;;
			*) ;;
	    esac
	    PARAM1="" && PARAM2=""
	done
}

PARAM1=$1
PARAM2=$2
PARAM3=$3
PARAM4=$4
start
