 #WeCMDB User Guide

## 主菜单介绍
![主页面](images/cmdb_main.png)
CMDB的功能分为三大菜单：系统管理、配置管理、信息查询。下面详细介绍每个菜单下的每个功能。

##系统管理
系统管理包括权限管理、日志查询。
###权限管理
权限管理包含角色管理、角色用户管理、数据权限、菜单管理四大功能模块。
![权限管理主页面](images/permission_main.png)

1. 角色管理

&ensp;&ensp;&ensp;&ensp;提供对角色的增删改查功能。
进入角色管理子页面后，默认显示所有角色列表。
![角色管理主页面](images/permission_role.png)
点击页面左上角的加号， 可以增加角色。
![角色管理增加角色](images/permission_role_add.png)
在角色列表中最右侧“操作”列点击“编辑”，“删除”，可进行相应的操作。
![角色管理编辑角色](images/permission_role_edit.png)

2. 角色用户管理

&ensp;&ensp;&ensp;&ensp;进入此功能后， 默认查询出所有角色清单。
![角色用户管理主页面](images/permission_role_user.png)
每个角色可以点击“用户管理”对该角色下的用户进行添加和清除。
![角色用户管理编辑页面](images/permission_role_user_mgmt.png)

3. 数据权限

&ensp;&ensp;&ensp;&ensp;进入此功能后， 默认查询出所有角色清单。
![数据权限主页面](images/permission_data_access.png)
每个角色可以点击“权限编辑”对该角色下的的CI数据权限进行配置，数据权限包括增删改查执。
![数据权限编辑页面](images/permission_data_access_mgmt.png)

4. 菜单管理

&ensp;&ensp;&ensp;&ensp;进入此功能后， 默认查询出所有角色清单。
![菜单管理主页面](images/permission_menu.png)
每个角色可以点击“菜单编辑”对该角色拥有哪些菜单权限进行配置。
![菜单管理编辑页面](images/permission_menu_mgmt.png)

###日志查询
1. 日志查询作为审计和追溯用途， 提供对系统中所有操作的日志检索，支持查询维度：操作用户、操作时间， 操作功能，操作CI， 操作内容， 操作结果等。
![日志查询](images/log_search.png)


##配置管理
配置管理包括基础配置管理、配置信息管理、综合查询管理。

###基础配置管理
点击下拉菜单进入功能页面：
![基础配置管理主页面](images/basic_config_main.png)

基础配置管理又称为枚举管理， 分为三大类：系统枚举、公共枚举、私有枚举。

1. 系统枚举

&ensp;&ensp;&ensp;&ensp;左侧菜单中选择“sys”，二级菜单中选择某一个枚举。
![系统枚举选择页面](images/basic_config_sys.png)
选择后， 右侧页面显示该枚举的所有值
![系统枚举值列表页面](images/basic_config_sys_list.png)
&ensp;&ensp;&ensp;&ensp;在右侧页面中， 可以新增系统枚举，编辑枚举属性，以及对该枚举的值进行管理（增、删、改、查、排序）
![系统枚举功能操作页面](images/basic_config_sys_mgmt.png)
点击新增枚举按钮，弹出新增枚举页面
![系统枚举新增枚举页面](images/basic_config_sys_enum_add.png)
点击属性编辑按钮， 弹出枚举属性修改页面
![系统枚举属性编辑页面](images/basic_config_sys_enum_edit.png)
点击新增枚举值按钮，弹出新增枚举值页面
![系统枚举值新增页面](images/basic_config_sys_code_add.png)
在枚举值列表中，可以点击不同的操作按钮“上移”、“下移”、“编辑”、“删除”，进行对应的功能操作
![系统枚举值编辑页面](images/basic_config_sys_code_edit.png)

2. 公共枚举

&ensp;&ensp;&ensp;&ensp;左侧菜单中选择“common”，二级菜单中选择某一个枚举。
![公共枚举选择页面](images/basic_config_common.png)
选择后， 右侧页面显示该枚举的所有值
![公共枚举值列表页面](images/basic_config_common_list.png)
&ensp;&ensp;&ensp;&ensp;在右侧页面中， 可以新增公共枚举，编辑枚举属性，以及对该枚举的值进行管理（增、删、改、查、排序）
![公共枚举功能操作页面](images/basic_config_common_mgmt.png)
点击新增枚举按钮，弹出新增枚举页面
![公共枚举新增枚举页面](images/basic_config_common_enum_add.png)
点击属性编辑按钮， 弹出枚举属性修改页面
![公共枚举属性编辑页面](images/basic_config_common_enum_edit.png)
点击新增枚举值按钮，弹出新增枚举值页面
![公共枚举值新增页面](images/basic_config_common_code_add.png)
在枚举值列表中，可以点击不同的操作按钮“上移”、“下移”、“编辑”、“删除”，进行对应的功能操作
![公共枚举值编辑页面](images/basic_config_common_code_edit.png)

3. 私有枚举

&ensp;&ensp;&ensp;&ensp;左侧菜单中选择除“sys”和“common”外的其他CI类型。
![私有枚举选择页面](images/basic_config_private.png)
选择后， 右侧页面显示该枚举的所有值
![私有枚举值列表页面](images/basic_config_private_list.png)
&ensp;&ensp;&ensp;&ensp;在右侧页面中， 可以新增私有枚举，编辑枚举属性，以及对该枚举的值进行管理（增、删、改、查、排序）
![私有枚举功能操作页面](images/basic_config_private_mgmt.png)
点击新增枚举按钮，弹出新增枚举页面
![私有枚举新增枚举页面](images/basic_config_private_enum_add.png)
点击属性编辑按钮， 弹出枚举属性修改页面
![私有枚举属性编辑页面](images/basic_config_private_enum_edit.png)
点击新增枚举值按钮，弹出新增枚举值页面
![私有枚举值新增页面](images/basic_config_private_code_add.png)
在枚举值列表中，可以点击不同的操作按钮“上移”、“下移”、“编辑”、“删除”，进行对应的功能操作
![私有枚举值编辑页面](images/basic_config_private_code_edit.png)

###配置信息管理
点击下拉菜单进入功能页面：
![配置信息管理主页面](images/config_mgmt_main.png)
1. 根据左侧的CMDB模型层级选择对应层级下的CI Type。
![配置信息管理CI选择](images/config_mgmt_search.png)
2. 选择选择CI Type后，右侧显示CI Type 属性列表。
![配置信息管理列表显示页面](images/config_mgmt_list.png)
主要功能按钮如下图：
![配置信息管理功能按钮页面](images/config_mgmt_mgmt.png)
CI Type管理：添加CI Type、编辑CI Type、删除CI Type、应用CI Type、作废CI Type、 回滚CI Type。
CI Type属性管理：添加CI Type属性、下载CI Type属性、生成联合唯一键、查看联合唯一键。
CI Type属性操作：编辑、删除、应用、回滚、作废。
3. 对CI Type进行操作。

新增CI Type:
![配置信息管理新增CI Type页面](images/config_mgmt_citype_add.png)
编辑CI Type:
![配置信息管理编辑CI Type页面](images/config_mgmt_citype_edit.png)
4. 对CI的属性进行编辑、删除、应用、作废、回滚操作。

新增CI Type 属性
![配置信息管理CI Type属性新增页面](images/config_mgmt_citype_attr_add.png)
编辑CI Type 属性
![配置信息管理CI Type属性编辑页面](images/config_mgmt_citype_attr_edit.png)


###综合查询管理
点击下拉菜单进入功能主页面
![综合查询管理主页面](images/common_interface_main.png)
1. 根据左侧的CMDB模型层级选择对应层级下的CI Type。
![综合查询管理CI Type选择页面](images/common_interface_search_citype.png)
在右侧输入框中选择综合查询名称
![综合查询管理名称选择页面](images/common_interface_search_name.png)
显示综合查询详情
![综合查询管理查询结果页面](images/common_interface_search_result.png)
![综合查询管理查询结果页面](images/common_interface_search_result_attr.png)

2. 可对该CI Type配置新的综合查询或者对原有的综合查询进行修改。

单击右侧页面中的CI对象， 显示“引用”和“属性”。
![综合查询管理编辑页面](images/common_interface_edit_choose.png)
可以在弹出框中选择“引用”或“被引用”的CI Type.
![综合查询管理引用选择页面](images/common_interface_edit_ref.png)
依次类推，可以关联所需要的所有CI。

单击右侧页面中已经关联的CI Type对象， 点击“属性”,可以在弹出的复选列表中选择需要查询或展示的CI属性。
![综合查询管理属性选择页面](images/common_interface_edit_attr.png)
5. 在页面最下方， 显示每个CI Type对象被选择的属性列表。
![综合查询管理查询结果页面](images/common_interface_search_result_attr.png)
6. 点击右上方按钮“增加综合查询接口名称”和“保持综合查询接口”。
![综合查询管理查询结果页面](images/common_interface_mgmt.png)


##信息查询
信息查询包括配置查询、综合查询。
###配置查询
1. 根据左侧的CMDB模型层级选择对应层级下的CI Type。
![配置查询CI Type选择页面](images/query_config_search.png)
2. 选择选择CI Type后，右侧显示CI Type的查询条件以及数据。
![配置查询列表显示页面](images/query_config_list.png)
3. 可按不同的查询条件查询数据， 并对数据进行操作。
![配置查询功能操作页面](images/query_config_mgmt.png)
列表上方的功能按钮依次是：新增、下载、显示隐藏列、上传数据、清空、搜索。在每行数据行最后一列，有对于的操作列，可对该行的CI Type属性进行特定的操作。

新增CIType属性
![配置查询属性新增页面](images/query_config_attr_add.png)

###综合查询
1. 根据左侧的CMDB模型层级选择对应层级下的CI Type。
![综合查询CIType选择页面](images/common_interface_runner_search.png)
在右侧输入框中输入综合查询名称或者从下拉列表中选择。
![综合查询列表选择页面](images/common_interface_runner_search_name.png)
2. 选择选择CI后，在右侧“综合查询名称”下拉选项中选择综合查询，点击查询， 页面下方列表中显示该综合查询的详细数据。
![综合查询结果显示页面](images/common_interface_runner_search_result.png)


