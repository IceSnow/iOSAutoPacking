# iOSAutoPacking
iOS 自动打包工具集合

# 使用方法

  1. 取消注释[Auto.applescript]中第一行代码，
  2. `/Users/.../autoBuild.sh`改成你自己放置`autoBuild.sh`的路径，
  3. `/Users/.../CompileSetting.plist`改成你自己放置`CompileSetting.plist`文件的路径

## 文件解说
* 启动编译配置 `CompileSetting.plist` 

  1. `projectRootDir`字段填写待编译工程根目录，ex: /Users/liu/Documents/xxxx/branches/xxxx

  2. `project`字段填写工程名，ex：xxxx.xcodeproj

  3. `schemeName`字段填写的还是代编译的scheme的名字，ex：xxxx

  4. `exportOptionsPlistPath`字段填写导出IPA配置文件路径，ex: /Users/liu/Desktop/Project/xxxx/UnpackFiles/ExportOptions/xxxx.plist

  5. `exportDir`字段填写编译文件和IPA导出目录，ex: /Users/liu/Desktop/Project/xxxx/Ipa/

* 导出IPA配置 `xxxx.plist` 

  1. `provisioningProfiles` 对象是描述配置对象，key为`bundle identifier`, value为描述文件配置名，可在工程文件内查看
  
* 快捷启动脚本`Auto.applescript`[正在维护中]

* 编译工程脚本 `autoBuild.sh` 

# 注意事项

> 本编译脚本未支持`CocoaPods`结构工程
