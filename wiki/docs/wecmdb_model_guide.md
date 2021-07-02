# CMDB模型
CMDB模型分为5层， 分别是：应用架构层、应用部署层、资源运行层、资源规划层、规划设计层。


## 应用架构层
应用架构层包括6个CI，如下表：

| 中文名称 | 英文名称 |   描述   | 层级 |
| -----   | ------  |  -----  |  ----|
|系统设计|SYSTEM_DESIGN|可分为多层父子关系|应用架构层|
|子系统设计|SUB_SYSTEM_DESIGN|最小化整体部署单位，可提供完整业务服务。必须从属于某个SYSTEM_DESIGN|应用架构层|
|单元设计|UNIT_DESIGN|最小化部署单位，可独立提供技术服务。|应用架构层|
|服务架构设计|SERVICE_DESIGN|无法独立存在，是UNIT_DESIGN的一个从属能力。必须从属于某个UNIT。分为被调用和调用两大类。|应用架构层|
|服务调用设计|INVOKE_DESIGN|描述单元和服务之间的调用关系设计|应用架构层|
|交易时序设计|SEQUENCE_DESIGN|描述应用的完整业务调用时序|应用架构层|


## 应用部署层
应用部署层包括5个CI，如下表：

| 中文名称 | 英文名称 |   描述   | 层级 |
| -----   | ------  |  -----  |  ----|
|子系统 |SUB_SYSTEM |子系统的某个环境的一套完整部署实现 |应用部署层|
|部署包 |PACKAGE |部署包的版本管理 |应用部署层|
|单元 |UNIT |单元的某个环境的一套完整部署实现，必须从属于某个SUB_SYSTEM |应用部署层|
|服务 |SERVICE |服务的某个环境的一套完整部署实现，必须从属于某个UNIT |应用部署层|
|服务调用 |INVOKE |描述单元和服务之间的调用关系 |应用部署层|

## 资源运行层
资源运行层包括5个CI，如下表：

| 中文名称 | 英文名称 |   描述   | 层级 |
| -----   | ------  |  -----  |  ----|
|弹性网卡 |NET_CARD |弹性网卡 |资源运行层|
|IP地址 |IP_ADDR |IP地址 |资源运行层|
|运行实例 |RUNNING_INSTANCE |运行于HOST上的一组进程。必须从属于UNIT |资源运行层|
|主机 |HOST |运行的主机（非硬件服务器）,必须属于某个SET_NODE |资源运行层|
|块存储 |STORAGE |块存储, 只能从属于某一个HOST。共享存储（对象存储、文件存储）使用UNIT_DEPLOY来管理。 |资源运行层|

## 资源规划层
资源规划层包括5个CI，如下表：

| 中文名称 | 英文名称 |   描述   | 层级 |
| -----   | ------  |  -----  |  ----|
|机房 |IDC |机房 |资源规划层|
|安全区域连接 |ZONE_LINK |安全区域连接 |资源规划层|
|安全区域 |ZONE |安全区域 |资源规划层|
|数据中心节点 |DCN |数据中心节点 |资源规划层|
|资源集 |SET |资源集 |资源规划层|

## 规划设计层
规划设计层包括5个CI，如下表：

| 中文名称 | 英文名称 |   描述   | 层级 |
| -----   | ------  |  -----  |  --- |
|IDC设计规划 |IDC_DESIGN |IDC设计规划 |规划设计层|
|安全区域连接设计规划 |ZONE_LINK_DESIGN |安全区域连接设计规划 |规划设计层|
|安全区域设计规划 |ZONE_DESIGN |安全区域设计规划 |规划设计层|
|DCN设计规划 |DCN_DESIGN |DCN设计规划 |规划设计层|
|资源集设计规划 |SET_DESIGN |资源集设计规划 |规划设计层|

## 附件
更多关于CI模型及其属性配置， 请查看以下文档：
[CI Model](wecmdb_model_list.xlsx)