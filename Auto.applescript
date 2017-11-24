#resolvePaths("/Users/liu/Library/Developer/Xcode/DerivedData/APPPackage-chadldtrsypesgcobdyfbwtlcphw/Build/Products/Debug/APPPackage.app/Contents/Resources/autoBuild.sh", "/Users/liu/Desktop/Project/xxxx/UnpackFiles/CompileSetting.plist")

on resolvePaths(sh_path, plist_path)
	
	# 检查配置文件
	if FileExists(plist_path) is false then
		display notification "配置文件不存在" subtitle ""
		display alert "配置文件不存在"
		return
	end if
	
	
	# 解析配置文件(plist)
	tell application "System Events"
		activate
		
		try
			set plist to property list file plist_path
			
			# 工程目录
			set projectRootDir to value of property list item "projectRootDir" of plist
			# 工程名
			set project to value of property list item "project" of plist
			# scheme
			set schemeName to value of property list item "schemeName" of plist
			# 导出路径
			set exportDir to value of property list item "exportDir" of plist
			# 导出ipa的配置文件(.plist)目录
			set exportOptionsPlistPath to value of property list item "exportOptionsPlistPath" of plist
		on error errorMsg
			display notification "配置文件异常" subtitle ""
			display alert "配置文件读取失败:\n            " & errorMsg
			return
		end try
		
	end tell
	
	
	## shell 文件准备
	# 获取build shell文件名
	set shFileName to GetFileName(sh_path)
	
	# 获取build shell工程文件路径
	set projectShPath to projectRootDir & "/" & shFileName
	
	# 检查build shell工程文件
	# 全局是否复制文件字段
	global isCopy
	set isCopy to false # 默认
	if FileExists(projectShPath) then
		
		# 检查MD5
		set proSHFileMD5 to GetFileMD5(projectShPath)
		set sourSHFileMD5 to GetFileMD5(sh_path)
		if proSHFileMD5 is not sourSHFileMD5 then
			set isCopy to true
		end if
	else
		set isCopy to true
	end if
	
	# 复制／替换文件
	if isCopy then
		CopyFile(sh_path, projectRootDir)
	end if
	
	
	
	# 获取sh文件权限
	set ls_rs to do shell script ("ls -l '" & projectShPath & "'")
	# 全局权限状态字段
	global chmod_num
	# 检查权限结果
	if ls_rs contains "rwxrwxrwx" then
		set chmod_num to "777"
	else
		set chmod_num to ""
	end if
	
	# 提示信息
	set tip_message to ("开始打包" & project & "工程的 `" & schemeName & "`scheme")
	display notification tip_message subtitle "准备打包"
	
	# 开始打包
	StartPackingIPA(work_dir, chmod_num, sh_file_name, project, schemeName, exportDir, exportOptionsPlistPath)
	
end resolvePaths


# 检查文件是否存在
on FileExists(filePath)
	
	tell application "Finder"
		set fileEx to exists disk item (my POSIX file filePath as string)
	end tell
	return fileEx
end FileExists

# 复制文件
on CopyFile(sourcePath, desPath)
	delay 5
	set sourcePathPOSIX to POSIX file sourcePath
	set desPathPOSIX to POSIX file desPath
	tell application "Finder"
		#		delay 0.5
		duplicate file sourcePathPOSIX to folder desPathPOSIX replacing yes
	end tell
end CopyFile

# 获取文件MD5
on GetFileMD5(filePath)
	set md5String to do shell script ("md5 -q \"" & filePath & "\"")
	return md5String
end GetFileMD5

# 获取文件名
on GetFileName(filePath)
	set fileName to do shell script "echo $(basename '" & filePath & "')"
	return fileName
end GetFileName

# 开始打包
on StartPackingIPA(work_dir, sh_chmod_num, sh_file_name, project, schemeName, exportDir, exportOptionsPlistDir)
	# 运行终端
	tell application "Terminal"
		#  Shell - cd
		set currentTab to do script "cd " & quoted form of work_dir
		#  Shell - 检查是否有文件执行权限
		if chmod_num is not "777" then
			do script ("chmod 777 " & sh_file_name) in currentTab
		end if
		# Shell - 执行脚本
		do script ("./'" & sh_file_name & "' " & project & " " & schemeName & " " & exportDir & " " & exportOptionsPlistDir) in currentTab
	end tell
end StartPackingIPA

