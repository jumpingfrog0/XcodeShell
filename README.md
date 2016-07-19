# XcodeShell

## Documents

[English Document](#English)

[中文文档](#Chinese)

<a name="English"></a>
##<span id="English"> Introduc</span>e

This repository include scripts that Xcode automaticly package, upload ipa to `AppStore` and publish application on `fir.im`.

`ipa-build.sh` and `ipa-upload.sh` scripts are based on `xcodebuild`, `xcodebuild` is a script Apple build Xcode projects and workspaces. You can archive the application, export ipa file and then upload the binary file to App Store. Run the command `man xcodebuild` to see more description.

`fir-publish.sh` script is based on `fir-cli` tool, see more [fir-cli](https://github.com/FIRHQ/fir-cli)

## Installation

1. Copy all files into the root path of your Xcode project or workspace
2. Type in some configuration in the scirpts, such as your `Certificates` and `Profiles`, your Apple Develope Account username and password, the API Token of `fir.im`, see detail in anyone script.
3. Run scripts

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
* Three files
	* `ipa-build.log` : The log file. If archive failed or export failed, you can see the log
	* `build_cmd.sh`  : The `xcodebuild` archive command script
	* `export_cmd.sh` : `xcodebuild` export ipa command script

### Upload

`ipa-upload.sh` must run after `ipa-build.sh`, it will descending sort all folders and files by project scheme, version number and generating time of ipa in the `export` directory, and then select the ipa file of the last folder to upload. So please watch out the output in the terminal, make sure it is uploading the correct file.

#### run script
	
	./ipa-upload.sh
	
#### Validate before upload

run the script and then terminal will ask you whether validate before upload, type in `YES` just OK.

### Publish on Fir.im

Get API Token from [http://fir.im/apps/apitoken]("http://fir.im/apps/apitoken"), type in the token in line 21, and then run script.

	./fir-publish.sh

<a name="Chinese"></a>
## <span id="Chinese">介绍</span>

这个代码仓库包含了Xcode自动化打包、上传ipa到`AppStore`、发布应用到`Fir.im`的一些脚本。
	
`ipa-build.sh`和`ipa-upload.sh`这两个脚本是基于`xcodebuild`编写的，`xcodebuild`是苹果的Xcode项目工程和工作空间的构建脚本。你可以使用它来打包App，导出ipa文件和上传二进制文件到App Store。运行命令`man xcodebuild`查看更多帮助。

`fir-publish.sh`脚本是基于`fir-cli`工具编写的，详见 [fir-cli](https://github.com/FIRHQ/fir-cli)。

## 安装

1. 复制所有文件到你Xcode项目工程或工作空间的跟路径
2. 在脚本中输入一些配置信息，比如证书和配置文件、苹果开发者账号的用户名和密码、`Fir.im`的API Token，在每个脚本中查看更详细的信息。
3. 运行脚本

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
* 三个文件
	* `ipa-build.log` : 日志文件。 如果归档失败或导出失败，可以查看日志。
	* `build_cmd.sh`  : `xcodebuild` archive命令脚本
	* `export_cmd.sh` : `xcodebuild` 导出ipa命令脚本

### 上传

`ipa-upload.sh`必须在运行完`ipa-build.sh`之后才可以运行，它会把`export`目录下的所有文件降序排序，然后选择排在最后的文件夹中的ipa文件进行上传。所以请仔细留意终端中的输出信息，确保正在上传的文件是正确的。

#### 运行脚本
	
	./ipa-upload.sh
	
#### 上传之前校验

运行脚本之后，终端会询问你是否要在上传之前进行校验，输入YES即可。

### 发布到Fir.im

从 [http://fir.im/apps/apitoken]("http://fir.im/apps/apitoken") 获取API Token, 在第21行输入token, 然后运行脚本。

	./fir-publish.sh
