# CMDB API V2  
提供统一接口定义，为使用者提供清晰明了的使用方法

## API 操作资源 （Resources）:  
**枚举**
- 枚举类别 - [EnumCatType](#EnumCatType)  
- 枚举目录 - [EnumCat](#EnumCat)  
- 枚举名/值 - [EnumCode](#EnumCode) 

**配置**  
- 配置项类型 - [CiType](#CiType) 
- 配置项类型属性 - [CiTypeAttr](#CiTypeAttr) 
- 配置项 - [Ci](#Ci) 

**权限**  
- 用户 - [User](#User)
- 角色 - [Role](#Role)
- 用户授权 - [Role_User](#Role_User)
- 配置项授权 - [Role_CiType](#Role_CiType)
- 配置项属性授权 - [Role_CiTypeAttr](#Role_CiTypeAttr)
- 配置项属性权限生效条件 - [Role_CiTypeAttr_Conditon](#Role_CiTypeAttr_Conditon)

**其他**  
- 综合查询 - [IntQuery](#IntQuery)  
- 图标 - [Image](#Image)  
- 常量 - [Constants](#Constants)  

## API 常规操作 (CRUD):
- 新增 (Create)， 新增一个或多个资源  
- 查询 (Retrieve)，查询一个或多个资源，可自定义过滤及排序条件
- 更新 (Update)， 更新一个或多个资源  
- 删除 (Delete)， 删除一个或多个资源  

## API 特殊操作:  
- 配置项类型及属性的状态变化操作 - [Apply](#Apply)
- 配置项状态变化操作 - [CI_State_Operate](#CI_State_Operate)

## API 概览及实例：  
### <span id="EnumCatType">枚举类别 - EnumCatType</span>
#### [POST] /api/v2/enum/catTypes/create
新增枚举类别
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:-- 
Array|Array of [EnumCatTypeDto](#EnumCatTypeDto)|是|枚举类别实体列表,不包含资源唯一ID

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
statusCode|string|状态码 - OK: 成功， ERROR: 失败，ERR_INVALID_ARGUMENT: 无效参数错误，ERR_INVALID_CHANGE: 批量处理错误
data|Array of [EnumCatTypeDto](#EnumCatTypeDto)|枚举类别实体列表,包含资源唯一ID

##### 示例：
正常输入：
```
[
  {
    "callbackId":"123456",
    "catTypeName": "system_design",
    "ciTypeId": 1,
    "description": "系统设计私有枚举类别",
    "type": 3
  }
]
```
正常输出：
```
{
  "statusCode": "OK",
  "data": [
    {
      "callbackId": "123456",
      "catTypeName": "system_design",
      "ciTypeId": 1,
      "description": "系统设计私有枚举类别",
      "type": 3,
      "catTypeId": 47
    }
  ]
}
```
无效输入：
```
[
  {
    "callbackId":"123456",
    "catTypeName": "system_design",
    "ciTypeId": 1,
    "description": "系统设计私有枚举类别",
    "type": 3
  }
]
```
异常输出：
```
{
  "statusCode": "ERR_BATCH_CHANGE",
  "statusMessage": "Fail to create [1] records, detail error in the data block",
  "data": [
    {
      "callbackId": "123456",
      "errorMessage": "Fail to create record with callbackId = [123456], error = [Duplicate cat type name [system_design] found, not allow to add/update.]"
    }
  ]
}
```

#### /api/v2/enum/catTypes/retrieve
查询枚举类别
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
request|[QueryRequest](#QueryRequest)|否|请求参数对象

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
data|[PageInfo](#PageInfo)|分页信息
contents|Array of [catTypeDto](#catTypeDto)|枚举类别实体列表

##### 示例：
正常输入：
```
{
  "filterRs": "and",
  "filters": [
    {
      "name": "catTypeName",
      "operator": "eq",
      "value": "sys"
    }
  ]
}
```
正常输出：
```
{
  "statusCode": "OK",
  "data": {
    "pageInfo": {
      "startIndex": 0,
      "pageSize": 10000,
      "totalRows": 1
    },
    "contents": [
      {
        "catTypeId": 1,
        "catTypeName": "sys",
        "type": 1,
        "cats": []
      }
    ]
  }
}
```
无效输入：
```
{
  "filterRs": "and",
  "filters": [
    {
      "name": "invalidFilterName",
      "operator": "eq",
      "value": "sys"
    }
  ]
}
```

异常输出：
```
{
  "statusCode": "ERR_INVALID_ARGUMENT",
  "statusMessage": "Can not find out field [invalidFilterName] for domain ."
}
```
#### /api/v2/enum/catTypes/update
更新枚举类别
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
Array|Array of [EnumCatTypeDto](#EnumCatTypeDto)|否|枚举类别实体列表，必须包含资源唯一ID

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
statusCode|string|状态码 - OK: 成功， ERROR: 失败，ERR_INVALID_ARGUMENT: 无效参数错误，ERR_INVALID_CHANGE: 批量处理错误
data|Array of [EnumCatTypeDto](#EnumCatTypeDto)|枚举类别实体列表

##### 示例：
正常输入：
```
[
  {
    "callbackId":"123456",
    "catTypeId": 47,
    "catTypeName": "system_design",
    "ciTypeId": 1,
    "description": "系统设计私有枚举类别",
    "type": 3
  }
]
```
正常输出：
```
{
  "statusCode": "OK",
  "data": [
    {
      "callbackId": "123456",
      "catTypeName": "system_design",
      "ciTypeId": 1,
      "description": "系统设计私有枚举类别",
      "type": 3,
      "catTypeId": 47,
      "cats":[]
    }
  ]
}
```
无效输入：
```
[
  {
    "callbackId":"123456",
    "catTypeName": "system_design",
    "ciTypeId": 1,
    "description": "系统设计私有枚举类别",
    "type": 3
  }
]
```
异常输出：
```
{
  "statusCode": "ERR_BATCH_CHANGE",
  "statusMessage": "Fail to update [1] records, detail error in the data block",
  "data": [
    {
      "callbackId": "123456",
      "errorMessage": "Fail to update record with callbackId = [123456], error = [Field 'catTypeId' is required.]"
    }
  ]
}
```
#### /api/v2/enum/catTypes/delete
删除枚举类别
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
Array|Array of integer|是|资源唯一ID列表

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
data|string|成功信息"Success"
statusMessage|string|异常信息，无异常则不返回该属性

##### 示例：
正常输入：
```
[
  47
]
```
正常输出：
```
{
  "statusCode": "OK",
  "data": "Success"
}
```
无效输入：
```
[
  9999
]
```
异常输出：
```
{
  "statusCode": "ERROR",
  "statusMessage": "Unable to find com.webank.cmdb.domain.AdmBasekeyCatType with id 9999"
}
```

### <span id="EnumCat">枚举目录 - EnumCat</span>
#### [POST] /api/v2/enum/cats/create
新增枚举目录
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:-- 
Array|Array of [EnumCatDto](#EnumCatDto)|是|枚举目录实体列表,不包含资源唯一ID

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
statusCode|string|状态码 - OK: 成功， ERROR: 失败，ERR_INVALID_ARGUMENT: 无效参数错误，ERR_INVALID_CHANGE: 批量处理错误
data|Array of [EnumCatDto](#EnumCatDto)|枚举目录实体列表,包含资源唯一ID

#### /api/v2/enum/cats/retrieve
查询枚举目录
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
request|[QueryRequest](#QueryRequest)|否|请求参数对象

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
data|[PageInfo](#PageInfo)|分页信息
contents|Array of [EnumCatDto](#EnumCatDto)|枚举目录实体列表

#### /api/v2/enum/cats/update
更新枚举目录
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
Array|Array of [EnumCatDto](#EnumCatDto)|否|枚举目录实体列表，必须包含资源唯一ID

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
statusCode|string|状态码 - OK: 成功， ERROR: 失败，ERR_INVALID_ARGUMENT: 无效参数错误，ERR_INVALID_CHANGE: 批量处理错误
data|Array of [EnumCatDto](#EnumCatDto)|枚举目录实体列表

#### /api/v2/enum/cats/delete
删除枚举目录
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
Array|Array of integer|是|资源唯一ID列表

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
data|string|成功信息"Success"
statusMessage|string|异常信息，无异常则不返回该属性

### <span id="EnumCode">枚举名称/值 - EnumCode</span>
#### [POST] /api/v2/enum/codes/create
新增枚举名称/值
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:-- 
Array|Array of [EnumCodeDto](#EnumCodeDto)|是|枚举名称/值实体列表,不包含资源唯一ID

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
statusCode|string|状态码 - OK: 成功， ERROR: 失败，ERR_INVALID_ARGUMENT: 无效参数错误，ERR_INVALID_CHANGE: 批量处理错误
data|Array of [EnumCodeDto](#EnumCodeDto)|枚举名称/值实体列表,包含资源唯一ID

#### /api/v2/enum/codes/retrieve
查询枚举名称/值
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
request|[QueryRequest](#QueryRequest)|否|请求参数对象

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
data|[PageInfo](#PageInfo)|分页信息
contents|Array of [EnumCodeDto](#EnumCodeDto)|枚举名称/值实体列表

#### /api/v2/enum/codes/update
更新枚举名称/值
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
Array|Array of [EnumCodeDto](#EnumCodeDto)|否|枚举名称/值实体列表，必须包含资源唯一ID

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
statusCode|string|状态码 - OK: 成功， ERROR: 失败，ERR_INVALID_ARGUMENT: 无效参数错误，ERR_INVALID_CHANGE: 批量处理错误
data|Array of [EnumCodeDto](#EnumCodeDto)|枚举名称/值实体列表

#### /api/v2/enum/codes/delete
删除枚举名称/值
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
Array|Array of integer|是|资源唯一ID列表

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
data|string|成功信息"Success"
statusMessage|string|异常信息，无异常则不返回该属性

### <span id="CiType">配置项类型 - CiType</span>
#### [POST] /api/v2/ciTypes/create
新增配置项类型
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:-- 
Array|Array of [CiTypeDto](#CiTypeDto)|是|配置项类型实体列表,不包含资源唯一ID

##### 输出参数：
参数名称|类型|描述
:--|:--|:--  
statusCode|string|状态码 - OK: 成功， ERROR: 失败，ERR_INVALID_ARGUMENT: 无效参数错误，ERR_INVALID_CHANGE: 批量处理错误  
data|Array of [CiTypeDto](#CiTypeDto)|配置项类型实体列表,包含资源唯一ID

#### [POST] /api/v2/ciTypes/retrieve
查询配置项类型
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
request|[QueryRequest](#QueryRequest)|否|请求参数对象

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
data|[PageInfo](#PageInfo)|分页信息
contents|Array of [CiTypeDto](#CiTypeDto)|配置项类型实体列表

#### [POST] /api/v2/ciTypes/update
更新配置项类型
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
Array|Array of [CiTypeDto](#CiTypeDto)|否|配置项类型实体列表，必须包含资源唯一ID

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
statusCode|string|状态码 - OK: 成功， ERROR: 失败，ERR_INVALID_ARGUMENT: 无效参数错误，ERR_INVALID_CHANGE: 批量处理错误
data|Array of [CiTypeDto](#CiTypeDto)|配置项类型实体列表

#### [POST] /api/v2/ciTypes/delete
删除配置项类型
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
Array|Array of integer|是|资源唯一ID列表

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
data|string|成功信息"Success"
statusMessage|string|异常信息，无异常则不返回该属性

### <span id="CiTypeAttr">配置项类型属性 - CiTypeAttr</span>
#### [POST] /api/v2/ciTypeAttrs/create
新增配置项类型属性
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:-- 
Array|Array of [CiTypeAttrDto](#CiTypeAttrDto)|是|配置项类型属性实体列表,不包含资源唯一ID

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
statusCode|string|状态码 - OK: 成功， ERROR: 失败，ERR_INVALID_ARGUMENT: 无效参数错误，ERR_INVALID_CHANGE: 批量处理错误
data|Array of [CiTypeAttrDto](#CiTypeAttrDto)|配置项类型属性实体列表,包含资源唯一ID

#### [POST] /api/v2/ciTypeAttrs/retrieve
查询配置项类型属性
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
request|[QueryRequest](#QueryRequest)|否|请求参数对象

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
data|[PageInfo](#PageInfo)|分页信息
contents|Array of [CiTypeAttrDto](#CiTypeAttrDto)|配置项类型属性实体列表

#### [POST] /api/v2/ciTypeAttrs/update
更新配置项类型属性
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
Array|Array of [CiTypeAttrDto](#CiTypeAttrDto)|否|配置项类型属性实体列表，必须包含资源唯一ID

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
statusCode|string|状态码 - OK: 成功， ERROR: 失败，ERR_INVALID_ARGUMENT: 无效参数错误，ERR_INVALID_CHANGE: 批量处理错误
data|Array of [CiTypeAttrDto](#CiTypeAttrDto)|配置项类型属性实体列表

#### [POST] /api/v2/ciTypeAttrs/delete
删除配置项类型属性
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
Array|Array of integer|是|资源唯一ID列表

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
data|string|成功信息"Success"
statusMessage|string|异常信息，无异常则不返回该属性

### <span id="Ci">配置项 - CI</span>
#### [POST] /api/v2/ci/{ciTypeId}/create
新增配置项
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:-- 
ciTypeId|integer|是|URL path里的ciTypeId为配置项类型ID, 即为该配置项类型新增一个或多个配置项
Array|Array of Map<key,value>|是|配置项实体列表,不包含资源唯一ID.

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
statusCode|string|状态码 - OK: 成功， ERROR: 失败，ERR_INVALID_ARGUMENT: 无效参数错误，ERR_INVALID_CHANGE: 批量处理错误
data|Array of Map<key,value>|配置项实体列表,包含资源唯一ID

#### [POST] /api/v2/ci/{ciTypeId}/retrieve
查询配置项
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
ciTypeId|integer|是|URL path里的ciTypeId为配置项类型ID, 即为该配置项类型新增一个或多个配置项
request|[QueryRequest](#QueryRequest)|否|请求参数对象

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
data|[PageInfo](#PageInfo)|分页信息
contents|Array of Map<key,value>)|配置项实体列表

#### [POST] /api/v2/ci/{ciTypeId}/update
更新配置项
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
ciTypeId|integer|是|URL path里的ciTypeId为配置项类型ID, 即为该配置项类型新增一个或多个配置项
Array|Array of Map<key,value>|否|配置项实体列表，必须包含资源唯一ID

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
statusCode|string|状态码 - OK: 成功， ERROR: 失败，ERR_INVALID_ARGUMENT: 无效参数错误，ERR_INVALID_CHANGE: 批量处理错误
data|Array of Map<key,value>|配置项实体列表

#### [POST] /api/v2/ci/{ciTypeId}/delete
删除配置项
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
ciTypeId|integer|是|URL path里的ciTypeId为配置项类型ID, 即为该配置项类型新增一个或多个配置项
Array|Array of integer|是|资源唯一ID列表

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
data|string|成功信息"Success"
statusMessage|string|异常信息，无异常则不返回该属性

### <span id="User">用户 - User</span>

#### [GET] /api/v2/users/retrieve
根据条件查询用户
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
request|[QueryRequest](#QueryRequest)|否|请求参数对象

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
data|[PageInfo](#PageInfo)|分页信息
contents|Array of [UserDto](#UserDto)|配置项类型属性实体列表

#### [POST] /api/v2/users/create
新增用户
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
userDtos|Array of [UserDto](#UserDto)|否|用户信息

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
userDtos|Array of [UserDto](#UserDto)用户信息

### <span id="Role">角色 - Role</span>
#### [POST] /api/v2/roles/retrieve
查询所有权限
##### 输入参数：
:--|:--|:--   
request|[QueryRequest](#QueryRequest)|请求参数对象

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
data|[PageInfo](#PageInfo)|分页信息
contents|Array of [RoleDto](#RoleDto)|角色信息

#### [POST] /api/v2/roles/create
新建角色
##### 输入参数：
参数名称|类型|描述
:--|:--|:--    
roleDtos|Array of [RoleDto](#RoleDto)|角色信息

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
contents|Array of [RoleDto](#RoleDto)|角色信息

#### [POST] /api/v2/roles/delete
根据角色id删除角色
##### 输入参数：
参数名称|类型|描述
:--|:--|:--    
requestIds|Array of Integer|角色id

##### 输出参数：无

#### [POST] /api/v2/roles/update
修改角色信息
##### 输入参数：
参数名称|类型|描述
:--|:--|:--    
roleDtos|Array of Map<key,value>|角色信息

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
contents|Array of [RoleDto](#RoleDto)|角色信息

### <span id="Role_User">用户授权 - Role_User</span>

#### [POST] /api/v2/role-users/retrieve
查询用户角色
##### 输入参数：
:--|:--|:--   
request|[QueryRequest](#QueryRequest)|请求参数对象

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
data|[PageInfo](#PageInfo)|分页信息
contents|Array of [RoleUserDto](#RoleUserDto)|角色信息

#### [POST] /api/v2/role-users/create
将角色授予用户
##### 输入参数：
参数名称|类型|描述
:--|:--|:--    
roleUsers|Array of [RoleUserDto](#RoleUserDto)|角色信息

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
Array|Array of [RoleUserDto](#RoleUserDto)|角色信息

#### [POST] /api/v2/role-users/delete
删除角色
##### 输入参数：
参数名称|类型|描述
:--|:--|:--    
requestIds|Array of Integer|用户角色id

##### 输出参数：无

### <span id="Role_CiType">配置项授权 - Role_CiType</span>

#### [POST] /api/v2/role-citypes/retrieve
查询角色的配置项权限信息
##### 输入参数：
:--|:--|:--   
request|[QueryRequest](#QueryRequest)|请求参数对象

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
data|[PageInfo](#PageInfo)|分页信息
contents|Array of [RoleCiTypeDto](#RoleCiTypeDto)|角色配置项权限信息

#### [POST] /api/v2/role-citypes/create
给角色授予配置项权限
##### 输入参数：
参数名称|类型|描述
:--|:--|:--    
roleCiTypes|Array of [RoleCiTypeDto](#RoleCiTypeDto)|角色配置项权限信息

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
Array|Array of [RoleCiTypeDto](#RoleCiTypeDto)|角色配置项权限信息

#### [POST] /api/v2/role-citypes/update
修改角色的授予配置项权限
##### 输入参数：
参数名称|类型|描述
:--|:--|:--    
request|Array of Map<key,value>|角色配置项权限信息

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
Array|Array of [RoleCiTypeDto](#RoleCiTypeDto)|角色配置项权限信息

#### [POST] /api/v2/role-citypes/delete
删除角色的配置项权限
##### 输入参数：
参数名称|类型|描述
:--|:--|:--    
requestIds|Array of Integer|配置项权限id

##### 输出参数：无

### <span id="Role_CiTypeAttr">配置项属性授权 - Role_CiTypeAttr</span>
#### [POST] /api/v2/role-citype-ctrl-attrs/retrieve
查询配置项属性权限信息
##### 输入参数：
:--|:--|:--   
request|[QueryRequest](#QueryRequest)|请求参数对象

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
data|[PageInfo](#PageInfo)|分页信息
contents|Array of [RoleCiTypeCtrlAttrDto](#RoleCiTypeCtrlAttrDto)|角色配置项属性权限信息

#### [POST] /api/v2/role-citype-ctrl-attrs/create
新增配置项属性权限
##### 输入参数：
参数名称|类型|描述
:--|:--|:--    
roleCiTypeCtrlAttrs|Array of [RoleCiTypeCtrlAttrDto](#RoleCiTypeCtrlAttrDto)|配置项属性权限信息

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
Array|Array of [RoleCiTypeCtrlAttrDto](#RoleCiTypeCtrlAttrDto)|配置项属性权限信息

#### [POST] /api/v2/role-citype-ctrl-attrs/update
修改配置项属性权限
##### 输入参数：
参数名称|类型|描述
:--|:--|:--    
request|Array of Map<key,value>|配置项属性权限信息

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
Array|Array of [RoleCiTypeDto](#RoleCiTypeDto)|配置项属性权限信息

#### [POST] /api/v2/role-citype-ctrl-attrs/delete
删除角色的配置项权限
##### 输入参数：
参数名称|类型|描述
:--|:--|:--    
requestIds|Array of Integer|配置项属性id

##### 输出参数：无

### <span id="Role_CiTypeAttr_Conditon">配置项属性权限生效条件 - Role_CiTypeAttr_Conditon</span>
#### [POST] /api/v2/role-citype-ctrl-attrs-conditions/retrieve
查询配置项属性权限生效条件信息
##### 输入参数：
:--|:--|:--   
request|[QueryRequest](#QueryRequest)|请求参数对象

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
data|[PageInfo](#PageInfo)|分页信息
contents|Array of [RoleCiTypeCtrlAttrConditionDto](#RoleCiTypeCtrlAttrConditionDto)|配置项属性权限生效条件信息

#### [POST] /api/v2/role-citype-ctrl-attrs-conditions/create
新增配置项属性权限生效条件
##### 输入参数：
参数名称|类型|描述
:--|:--|:--    
roleCiTypeCtrlAttrConditions|Array of [RoleCiTypeCtrlAttrConditionDto](#RoleCiTypeCtrlAttrConditionDto)|配置项属性权限生效条件

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
Array|Array of [RoleCiTypeCtrlAttrConditionDto](#RoleCiTypeCtrlAttrConditionDto)|配置项属性权限生效条件信息

#### [POST] /api/v2/role-citype-ctrl-attrs-conditions/update
修改配置项属性权限生效条件
##### 输入参数：
参数名称|类型|描述
:--|:--|:--    
request|Array of Map<key,value>|配置项属性权限生效条件信息

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
Array|Array of [roleCiTypeCtrlAttrConditions](#roleCiTypeCtrlAttrConditions)|配置项属性权限信息

#### [POST] /api/v2/role-citype-ctrl-attrs-conditions/delete
删除配置项属性权限生效条件
##### 输入参数：
参数名称|类型|描述
:--|:--|:--    
requestIds|Array of Integer|配置项属性生效条件id

##### 输出参数：无

### <span id="IntQuery">综合查询 - IntQuery</span>

#### [GET]/api/v2/intQuery/{queryId}
根据查询id查询综合查询
##### 输入参数：
参数名称|类型|描述
:--|:--|:--    
queryId|Integer|综合查询id

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
response|IntegrationQueryDto(#IntegrationQueryDto)|综合查询

#### [POST] /api/v2/intQuery/ciType/{ciTypeId}/{queryName}/save
保存综合查询
##### 输入参数：
参数名称|类型|描述
:--|:--|:--    
ciTypeId|Integer|配置项id
queryName|String|综合查询名称
intQueryDto|IntegrationQueryDto|综合查询

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
int|int|新增综合查询结果


#### [POST] /api/v2/intQuery/{queryId}/update
修改综合查询
##### 输入参数：
参数名称|类型|描述
:--|:--|:--    
queryId|int|综合查询id
intQueryDto|IntegrationQueryDto|综合查询

##### 输出参数：无


#### [POST] /api/v2/intQuery/ciType/{ciTypeId}/{queryId}/delete
删除综合查询
##### 输入参数：
参数名称|类型|描述
:--|:--|:--    
queryId|int|综合查询id
ciTypeId|Integer|配置项id

##### 输出参数：无



#### [POST]/api/v2/intQuery/{queryId}/execute
执行综合查询
##### 输入参数：
参数名称|类型|描述
:--|:--|:--    
queryId|Integer|综合查询id

##### 输出参数：无
参数名称|类型|描述
:--|:--|:--    
data|[PageInfo](#PageInfo)|分页信息
contents|Array of Map<key,value>|综合查询的查询结果

### <span id="Image">图标 - Image</span>
#### [GET] /api/v2/image/{imageId}
根据图标id查询图标
##### 输入参数：
参数名称|类型|描述
:--|:--|:--    
imageId|int|图标id
response|HttpServletResponse|输出流
##### 输出参数：无

#### [POST] /api/v2/image/upload
上传图标
##### 输入参数：
参数名称|类型|描述
:--|:--|:--    
file|MultipartFile|图标文件
##### 输出参数：无

### <span id="Constants">常量 - Constants</span>
#### [POST] /api/v2/constants/ciStatus/retrieve
查询配置项状态常量
##### 输入参数：无

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
statusCode|String|查询结果
Array|Array of String|配置项状态常量
##### 示例：
正常返回：
```
{
  "statusCode": "OK",
  -"data": [
    "notCreated",
    "created",
    "dirty",
    "decommissioned"
  ]
}
```

#### [POST] /api/v2/constants/referenceTypes/retrieve
查询引用类型常量
##### 输入参数：无

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
statusCode|String|查询结果
Array|Array of String|引用类型常量
##### 示例：
正常返回：
```
{
  "statusCode": "OK",
  -"data": [
    "association",
    "composition",
    "aggregation",
    "dependence"
  ]
}
```

#### [POST] /api/v2/constants/inputTypes/retrieve
查询输入类型常量
##### 输入参数：无

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
statusCode|String|查询结果
Array|Array of String|输入类型常量
##### 示例：
正常返回：
```
{
  "statusCode": "OK",
  -"data":[
      "text",
      "date",
      "textArea",
      "select",
      "multiSelect",
      "ref",
      "multiRef",
      "number",
      "orchestration_multi_ref",
      "orchestration_ref"
    ]
}
```

#### [POST] /api/v2/constants/effectiveStatus/retrieve
获取有效状态常量
##### 输入参数：无

##### 输出参数：
参数名称|类型|描述
:--|:--|:--   
statusCode|String|查询结果
data|Array of String|有效状态常量
##### 示例：
正常返回：
```
{
  "statusCode": "OK",
  -"data": [
    "active",
    "inactive"
  ]
}
```

### <span id="Apply">配置项类型及属性的状态变化操作 - Apply</span>
#### [POST] /api/v2/ciTypes/applyAll
创建所有待创建(状态为：notCreated)的配置项类型及其属性所对应的物理表及属性列
##### 输入参数：无
##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
statusCode|string|状态码 - OK: 成功， ERROR: 失败，ERR_INVALID_ARGUMENT: 无效参数错误，ERR_INVALID_CHANGE: 批量处理错误
statusMessage|string|异常信息，无异常则不返回该属性

#### [POST] /api/v2/ciTypes/apply
创建指定的配置项类型及其属性所对应的物理表及属性列
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
Array|Array of integer|是|配置项类型ID列表，见[CiTypeDto](#CiTypeDto).ciTypeId
##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
statusCode|string|状态码 - OK: 成功， ERROR: 失败，ERR_INVALID_ARGUMENT: 无效参数错误，ERR_INVALID_CHANGE: 批量处理错误
statusMessage|string|异常信息，无异常则不返回该属性

#### [POST] /api/v2/ciTypeAttrs/apply
创建指定的配置项类型属性所对应的物理表的属性列
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
Array|Array of integer|是|配置项类型属性ID列表，见[CiTypeAttrDto](#CiTypeAttrDto).ciTypeAttrId
##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
statusCode|string|状态码 - OK: 成功， ERROR: 失败，ERR_INVALID_ARGUMENT: 无效参数错误，ERR_INVALID_CHANGE: 批量处理错误
statusMessage|string|异常信息，无异常则不返回该属性

### <span id="CI_State_Operate">配置项状态变化操作 - CI_State_Operate</span>
#### [POST] /api/v2/ci/state/operate
配置项状态变化操作，根据配置项类型所对应的状态机允许的状态进行变化操作
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
Array|Array of integer|是|配置项类型ID列表，见[CiTypeDto](#CiTypeDto).ciTypeId
operation|string|是|操作名称 - insert: 插入， delete: 删除， update: 更新，discard: 废弃， confirm: 确认， startup: 启动， stop: 停止<br> 注：状态机不同，所对应的操作集合会不同

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
statusCode|string|状态码 - OK: 成功， ERROR: 失败，ERR_INVALID_ARGUMENT: 无效参数错误，ERR_INVALID_CHANGE: 批量处理错误
data|Array of Map<key,value>|配置项实体列表

## 数据结构：
### 1. 公共数据结构
#### <span id="QueryRequest">QueryRequest</span>
名称|类型|必选|描述
:--|:--|:--|:--
dialect/data|object|否|方言数据，也称为额外数据
dialect/showCiHistory|boolean|否|是否请求历史数据， 默认：false
filterRs|string|否|默认：and <br>过滤器的关系 -- and: 与关系， or: 或关系
filters|Array of Filter|否|过滤器
groupsBys|Array of string|否|分组查询
Pageable|[Pageable](#Pageable)|否|每页信息
paging|boolean|否|请求结果是否要分页
refResources|Array of string|否|跨资源名称列表，为跨资源查询之用
resultsColumns|Array of string|否|请求结果属性列表
sorting/asc|boolean|否|是否升序排列，默认：true
sorting/field|string|否|排序属性名

#### Filter
名称|类型|必选|描述
:--|:--|:--|:--
name|string|是|资源属性名
operator|string|是|过滤操作符，目前支持：in/contains/eq/gt/lt/ne/notNull/null
value|object|否|根据操作符变化，如operator为eq, value即要求是对象， 如operator为contains, value即要求为列表

#### PageInfo
名称|类型|必选|描述
:--|:--|:--|:--
pageSize|integer|否|每页显示记录行数
startIndex|integer|否|开始页码索引
totalRows|integer|否|总共记录数

#### <span id="Pageable">Pageable</span>
名称|类型|必选|描述
:--|:--|:--|:--
pageSize|integer|否|每页显示记录行数
startIndex|integer|否|开始页码索引

### 2. 实体数据结构
#### <span id="EnumCatTypeDto">EnumCatTypeDto - 枚举类别</span>
名称|类型|必选|描述
:--|:--|:--|:--
callbackId|string|否|入参唯一索引ID， 作为出参提取对应数据的依据
errorMessage|string|否|出参异常信息，无异常则不返回该属性
catTypeId|integer|是|实体ID, 新增时由系统产生,更新和删除时必选  
catTypeName|string|是|枚举类别名称
ciTypeId|integer|否|所属配置项ID, 即该配置项的私有枚举类别
type|integer|否|枚举类别的类型 - 1:系统枚举 2:公共枚举 3:私有枚举
description|string|否|枚举类别的描述

#### <span id="EnumCatDto">EnumCat - 枚举目录</span>
名称|类型|必选|描述
:--|:--|:--|:--
callbackId|string|否|入参唯一索引ID， 作为出参提取对应数据的依据
errorMessage|string|否|出参异常信息，无异常则不返回该属性
catId|integer|是|实体ID, 新增时由系统产生,更新和删除时必选  
catName|string|是|枚举目录名称
catTypeId|integer|是|所属枚举类别ID, 见[EnumCatTypeDto](#EnumCatTypeDto)
groupTypeId|integer|否|枚举目录组，也称父枚举目录ID
description|string|否|枚举目录的描述

#### <span id="EnumCodeDto">EnumCodeDto - 枚举名称/值</span>
名称|类型|必选|描述
:--|:--|:--|:--
callbackId|string|否|入参唯一索引ID， 作为出参提取对应数据的依据
errorMessage|string|否|出参异常信息，无异常则不返回该属性
codeId|integer|是|实体ID, 新增时由系统产生,更新和删除时必选  
catId|integer|是|所属枚举目录ID, 见[EnumCatDto](#EnumCatDto)   
code|string|是|枚举名称
value|string|是|枚举值
groupCodeId|integer|否|枚举组，也称父枚举ID
codeDescription|string|否|枚举的描述
seqNo|integer|否|系统产生并维护
status|string|否|默认：active, 枚举状态 - active: 可用， inactive: 不可用

#### <span id="CiTypeDto">CiTypeDto - 配置项类型</span>
名称|类型|必选|描述
:--|:--|:--|:--
callbackId|string|否|入参唯一索引ID， 作为出参提取对应数据的依据
errorMessage|string|否|出参异常信息，无异常则不返回该属性
ciTypeId|integer|是|实体ID, 新增时由系统产生,更新和删除时必选  
name|string|是|名称
tableName|string|是|对应的数据库表名
status|string|否|默认：notCreated, 配置项状态 - notCreated: 待创建，created: 已创建， dirty: 已创建后更改， decommissioned: 丢弃
catalogId|integer|否|目录ID
seqNo|integer|否|系统产生及维护, 同一层上的排序序列号
layerId|integer|否|Y轴的层级序列号
zoomLevelId|integer|否|Z轴的层级序列号
imageFileId|integer|否|显示图片ID
description|string|否|描述

#### <span id="CiTypeAttrDto">CiTypeAttrDto - 配置项类型属性</span>
名称|类型|必选|描述
:--|:--|:--|:--
callbackId|string|否|入参唯一索引ID， 作为出参提取对应数据的依据
errorMessage|string|否|出参异常信息，无异常则不返回该属性
ciTypeAttrId|integer|是|实体ID, 新增时由系统产生,更新和删除时必选
ciTypeId|integer|是|属性所属配置项类型ID，见[CiTypeDto](#CiTypeDto)  
name|string|是|属性名称
inputType|string|是|属性可接受输入数据类型 - text, date, textArea, select, multiSelect, ref, multiRef, number, orchestration_multi_ref, orchestration_ref
propertyName|string|是|属性对应的数据库表列名称, 只支持大小写字母，数据和下划线，而且以必须小写开头
propertyType|string|是|属性对应的数据库表列数据类型
length|string|否|属性对应的数据库表列数据允许的长度
referenceId|integer|否|属性所引用的配置项类型ID, 见[CiTypeDto](#CiTypeDto) 或 枚举目录ID, 见[EnumCatDto](#EnumCatDto)
referenceName|string|否|引用关系命名
referenceType|integer|否|引用关系的类型，即对应的枚举目录ID
filterRule|string|否|过滤规则，即当该属性为引用或枚举的时候，使用该设定的规则过滤所引用的数据
searchSeqno|integer|否|搜索排序序列号
displaySeqNo|integer|否|展示排序
autoFillRule|string|否|自动填充规则
status|string|否|默认：notCreated, 配置项状态 - notCreated: 待创建，created: 已创建， dirty: 已创建后更改， decommissioned: 丢弃
isDisplayed|boolean|否|是否展示
isEditable|boolean|否|是否可编辑
isHidden|boolean|否|是否隐藏
isNullable|boolean|否|是否允许保存空值
isRefreshable|boolean|否|是否允许刷新
isSystem|boolean|否|是否系统属性
isUnique|boolean|否|是否唯一，即该属性值不允许保存重复值
isAccessControlled|boolean|否|是否启用权限控制
isAuto|boolean|否|是否自动填充该属性值，即根据autoFillRule属性所设定的规则进行填充
description|string|否|配置项类型属性的描述

#### <span id="UserDto">UserDto - 用户</span>
名称|类型|必选|描述
:--|:--|:--|:--
userId|integer|否|实体ID, 新增时由系统产生,更新和删除时必选  
username|String|是|用户名
password|String|否|密码
fullName|String|否|名称
description|String|否|描述

#### <span id="RoleDto">RoleDto - 角色</span>
名称|类型|必选|描述
:--|:--|:--|:--
roleId|integer|否|实体ID, 新增时由系统产生,更新和删除时必选  
roleName|String|是|角色名
roleType|String|否|角色类型
isSystem|String|否|是否系统角色
description|String|否|描述

#### <span id="RoleUserDto">RoleUserDto - 用户角色</span>
名称|类型|必选|描述
:--|:--|:--|:--
roleUserId|integer|否|实体ID, 新增时由系统产生,更新和删除时必选  
roleId|integer|是|角色名
userId|integer|否|角色类型
isSystem|String|否|是否系统属性

#### <span id="RoleCiTypeDto">RoleCiTypeDto - 角色配置项权限</span>
名称|类型|必选|描述
:--|:--|:--|:--
roleCiTypeId|integer|否|实体ID, 新增时由系统产生,更新和删除时必选  
ciTypeId|integer|是|配置项id
roleId|integer|否|角色id
ciTypeName|String|否|角色名称
creationPermission|String|否|是否具有创建的权限
removalPermission|String|否|是否具有删除的权限
modificationPermission|String|否|是否具有修改的权限
enquiryPermission|String|否|是否具有查询的权限
executionPermission|String|否|是否具有执行的权限
grantPermission|String|否|是否具有授权的权限


#### <span id="RoleCiTypeCtrlAttrDto">RoleCiTypeCtrlAttrDto - 角色配置项属性权限</span>
名称|类型|必选|描述
:--|:--|:--|:--
roleCiTypeCtrlAttrId|integer|否|实体ID, 新增时由系统产生,更新和删除时必选  
roleCiTypeId|integer|是|角色配置项权限id
creationPermission|String|否|是否具有创建的权限
removalPermission|String|否|是否具有删除的权限
modificationPermission|String|否|是否具有修改的权限
enquiryPermission|String|否|是否具有查询的权限
executionPermission|String|否|是否具有执行的权限
grantPermission|String|否|是否具有授权的权限


#### <span id="RoleCiTypeCtrlAttrConditionDto">RoleCiTypeCtrlAttrConditionDto - 角色配置项属性权限生效条件</span>
名称|类型|必选|描述
:--|:--|:--|:--
conditionId|integer|否|实体ID, 新增时由系统产生,更新和删除时必选  
roleCiTypeCtrlAttrId|integer|是|角色配置项属性权限id
ciTypeAttrId|integer|否|配置项属性id
ciTypeAttrName|String|否|配置项属性名称
conditionValue|String|否|条件
conditionValueType|String|否|条件类型
conditionValueObject|Object|否|条件对象


#### <span id="IntegrationQueryDto">IntegrationQueryDto - 综合查询</span>
名称|类型|必选|描述
:--|:--|:--|:--
name|String|否|综合查询名称
ciTypeId|integer|是|配置项id
attrs|Array of Integer|否|配置项属性id
attrAliases|String|否|配置项属性别名
attrKeyNames|String|否|配置项属性名称
conditionValueType|String|否|条件类型
parentRs|Relationship(#Relationship)|否|父节点信息
children|IntegrationQueryDto(#IntegrationQueryDto)|否|子节点


#### <span id="Relationship">Relationship - 综合查询父节点信息</span>
名称|类型|必选|描述
:--|:--|:--|:--
attrId|Integer|否|配置项属性id
isReferedFromParent|Boolean|否|是否存在父节点


