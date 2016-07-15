# XcodeShell

## Documents

[English Document](#English)

[中文文档](#Chinese)

## <span id="English">Introduce</span>

This repository include scripts that Xcode automaticly package and upload ipa to App Store.

These scripts is based on `xcodebuild`, `xcodebuild` is a script Apple build Xcode projects and workspaces. You can archive the application, export ipa file and then upload the binary file to App Store. Run the command `man xcodebuild` to see more description.

## Installation

1. Copy all files into the root path of your Xcode project or workspace
2. Type in your `Certificates` and `Profiles` in 51 - 58 lines of `ipa-build.sh`
3. Type in your Apple Develope Account username and password in 27 - 28 lines of `ipa-upload.sh`
4. Run scripts

## Usage

### Archive and Export

#### build Xcode project

	./ipa-build.sh -c [-D | -T | -P]

#### build Xcode workspace

	./ipa-build.sh -w [-D | -T | -P]

#### Options

	ipa-build.sh
	
 	-D : Build with development certificate for debugging
 	-T : Build with Ad-hoc certificate for testing
 	-P : Build with production certificate for AppStore
 	-w : Build xcode workspace
 	-c : Build xcode project
 	-n : Cleans the build directory before compling
 	
#### Export options
 
Xcode7 use some plist files to configure archive exporting, such as complieBitcode, avaliable options like app-store, ad-hoc, development. Run the command `xcodebuild --help` to see more.

To simplify scripts, I created three option plists that configured the simplified configuration which meet the most basic requirements.

* `DevExportOptions.plist` : configures archive exporting for development
* `AdHocExportOptions.plist` : configures archive exporting for Ad-Hoc
* `AppStoreExportOptions.plist` : configures archive exporting for App Store

#### Output

* Two directories
	* `archive` : The folder of files archived
	* `export`  : The folder of ipa files exported
* Two files
	* `ipa-build.log` : The log file. If archive failed or export failed, you can see the log
	* `build_cmd.sh`  : The `xcodebuild` command script

### Upload

`ipa-upload.sh` must run after `ipa-build.sh`, it will descending sort all folders and files by project scheme, version number and generating time of ipa in the `export` directory, and then select the ipa file of the last folder to upload. So please watch out the output in the terminal, make sure it is uploading the correct file.

#### run script
	
	./ipa-upload.sh
	
#### Validate before upload

run the script and then terminal will ask you whether validate before upload, type in `YES` just OK.

## <span id="Chinese">介绍</span>

这个代码仓库包含了Xcode自动化打包和上传ipa到App Store的一些脚本。
	
这些脚本是基于`xcodebuild`编写的，`xcodebuild`是苹果的Xcode项目工程和工作空间的构建脚本。你可以使用它来打包App，导出ipa文件和上传二进制文件到App Store。运行命令`man xcodebuild`查看更多帮助。

## 安装

1. 复制所有文件到你Xcode项目工程或工作空间的跟路径
2. 在`ipa-build.sh`的第51-58行输入证书和配置文件
3. 在`ipa-upload.sh`的第27-28行输入苹果开发者账号的用户名和密码
4. 运行脚本

## 用法

### 归档和导出

#### 构建Xcode项目

	./ipa-build.sh -c [-D | -T | -P]

#### 构建Xcode工作空间

	./ipa-build.sh -w [-D | -T | -P]

#### 选项

	ipa-build.sh
	
 	-D : 用调试证书构建，用于调试
 	-T : 用Ad-hoc证书构建，用于内测
 	-P : 用产品证书构建，用于App Store
 	-w : 构建Xcode工作空间
 	-c : 构建Xcode项目
 	-n : 构建前清空编译文件
 	
#### 导出选项

Xcode7 使用一些plist文件来配置导出的文件，比如支持Bitcode，app-store,ad-hoc,development等可用选项。运行命令`xcodebuild --help`查看更多。

为了简化监本，我创建了3个导出选项的文件，用来配置最基本的简化配置。

* `DevExportOptions.plist` : 配置导出的文件用于调试
* `AdHocExportOptions.plist` : 配置导出的文件用于Ad-Hoc
* `AppStoreExportOptions.plist` : 配置导出的文件用于App Store

#### 输出

* 两个目录
	* `archive` : 归档的文件夹
	* `export`  : 存放导出的ipa的文件夹
* 两个文件
	* `ipa-build.log` : 日志文件。 如果归档失败或导出失败，可以查看日志。
	* `build_cmd.sh`  : `xcodebuild`命令脚本

### 上传

`ipa-upload.sh`必须在运行完`ipa-build.sh`之后才可以运行，它会把`export`目录下的所有文件降序排序，然后选择排在最后的文件夹中的ipa文件进行上传。所以请仔细留意终端中的输出信息，确保正在上传的文件是正确的。

#### 运行脚本
	
	./ipa-upload.sh
	
#### 上传之前校验

运行脚本之后，终端会询问你是否要在上传之前进行校验，输入YES即可。
