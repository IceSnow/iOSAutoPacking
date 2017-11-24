#!/bin/sh
# 开始

#计时
SECONDS=0

displayUsedTime()
{
	#输出总用时
	echo "===Finished. Total time: ${SECONDS}s==="
}


# Para
# 工程名
project=$1
# scheme
scheme=$2
# target
#target="ELN"

# 导出路径
exportDir=$3
# 导出ipa的配置文件路径
exportOptionsPlist=$4

# Action
# clean
xcodebuild clean -project ${project} -scheme ${scheme} -configuration Release
# build
#xcodebuild build -project ${project} -target ${target} -configuration Release -sdk iphoneos


# 导出实际目录
exportRealDir="${exportDir}${scheme} $(date "+%Y-%m-%d %H-%M-%S")/"
# 创建目录
#mkdir -p "${exportRealDir}"

# archive
# archivePath
archivePath="${exportRealDir}${scheme} $(date "+%Y-%m-%d %H-%M-%S").xcarchive"
xcodebuild archive -scheme ${scheme} -configuration Release -archivePath "${archivePath}"

# 判断编译状态
if [ ! -f "${archivePath}" ]; then
	echo "编译成功"
else
	echo "编译失败"

	# 显示消耗时间
	displayUsedTime
	exit 1
fi

# exportArchive
# 导出文件夹路径
exportPath="${exportRealDir}/${scheme} $(date "+%Y-%m-%d %H-%M-%S")"
xcodebuild -exportArchive -archivePath "${archivePath}" -exportPath "${exportPath}" -exportOptionsPlist "${exportOptionsPlist}"

# 判断ipa导出状态
if [ -d "${exportPath}" ]; then
	echo "导出ipa成功"
else
	echo "导出ipa失败"
	
	# 显示消耗时间
	displayUsedTime
	exit 1
fi

# 打开目录
open "${exportRealDir}"

# 显示消耗时间
displayUsedTime


