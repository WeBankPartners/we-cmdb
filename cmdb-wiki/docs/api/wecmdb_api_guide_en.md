# WeCMDB API V2  
This document describe all APIs definition of WeCMDB, which help our users to integrate WeCMDB with their application easily.

## API Manage Resources:  
**ENUM**
- ENUM TYPE - [EnumCatType](#EnumCatType)  
- ENUM CATALOG - [EnumCat](#EnumCat)  
- ENUM KEY/VALUE - [EnumCode](#EnumCode) 

**Configuration**  
- CI Type - [CiType](#CiType) 
- CI Type Attr - [CiTypeAttr](#CiTypeAttr) 
- CI - [Ci](#Ci) 

**Permission**  
- User - [User](#User)
- Role - [Role](#Role)
- User Role - [Role_User](#Role_User)
- CI Type Role - [Role_CiType](#Role_CiType)
- CI Type Attr Role - [Role_CiTypeAttr](#Role_CiTypeAttr)
- CI Type Attr Role Effective Condition - [Role_CiTypeAttr_Conditon](#Role_CiTypeAttr_Conditon)

**Others**  
- Integrated Enquiry - [IntQuery](#IntQuery)  
- Image - [Image](#Image)  
- Constant - [Constant](#Constants)  

## API Normal Operation (CRUD):
- Create， create one or more resources
- Retrieve，retrieve one or more resources by filtering/sorting condition
- Update， update one or more resources  
- Delete， delete one or more resources  

## API Special Operation:  
- Create CI Type/Attr physically - [Apply](#Apply)
- Change CI Status - [CI_State_Operate](#CI_State_Operate)

## API Overview  
### <span id="EnumCatType">ENUM Type - EnumCatType</span>
#### [POST] /api/v2/enum/catTypes/create
Create ENUM Type
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:-- 
Array|Array of [EnumCatTypeDto](#EnumCatTypeDto)|Yes|ENUM Type entity information to be created without given ID which will be generated afterward.

##### Output Parameters：
Param Name|Type|Description
:--|:--|:--    
statusCode|string|OK: Success， ERROR: Failed，ERR_INVALID_ARGUMENT: Invalid Argument Error，ERR_BATCH_CHANGE: Batch change failed
data|Array of [EnumCatTypeDto](#EnumCatTypeDto)|ENUM Type entity information to be changed, must include ID field to indicate which resource to be chagned.

##### Example：
Valid Input：
```
[
  {
    "callbackId":"123456",
    "catTypeName": "system_design",
    "ciTypeId": 1,
    "description": "Private ENUM Type of CI - system_design",
    "type": 3
  }
]
```
Oupput：
```
{
  "statusCode": "OK",
  "data": [
    {
      "callbackId": "123456",
      "catTypeName": "system_design",
      "ciTypeId": 1,
      "description": "Private ENUM Type of CI - system_design",
      "type": 3,
      "catTypeId": 47
    }
  ]
}
```
Invalid Input：
```
[
  {
    "callbackId":"123456",
    "catTypeName": "system_design",
    "ciTypeId": 1,
    "description": "Private ENUM Type of CI - system_design",
    "type": 3
  }
]
```
Ouput:
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
Retrieve ENUM Type
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
request|[QueryRequest](#QueryRequest)|No|Request Object of Parameters

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|[PageInfo](#PageInfo)|Paging information
contents|Array of [catTypeDto](#catTypeDto)|ENUM Type entity information

##### Example：
Valid Input：
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
Output:
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
Invalid Input:
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

Output:
```
{
  "statusCode": "ERR_INVALID_ARGUMENT",
  "statusMessage": "Can not find out field [invalidFilterName] for domain ."
}
```
#### /api/v2/enum/catTypes/update
Update ENUM Type
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
Array|Array of [EnumCatTypeDto](#EnumCatTypeDto)|No|ENUM Type entity information，must include ID field

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
statusCode|string|OK: Success， ERROR: Failed，ERR_INVALID_ARGUMENT: Invalid Argument Error，ERR_BATCH_CHANGE: Batch change failed
data|Array of [EnumCatTypeDto](#EnumCatTypeDto)|ENUM Type entity information

##### Example：
Valid Input：
```
[
  {
    "callbackId":"123456",
    "catTypeId": 47,
    "catTypeName": "system_design",
    "ciTypeId": 1,
    "description": "Private ENUM Type of CI - system_design",
    "type": 3
  }
]
```
Output:
```
{
  "statusCode": "OK",
  "data": [
    {
      "callbackId": "123456",
      "catTypeName": "system_design",
      "ciTypeId": 1,
      "description": "Private ENUM Type of CI - system_design",
      "type": 3,
      "catTypeId": 47,
      "cats":[]
    }
  ]
}
```
Invalid Input:
```
[
  {
    "callbackId":"123456",
    "catTypeName": "system_design",
    "ciTypeId": 1,
    "description": "Private ENUM Type of CI - system_design",
    "type": 3
  }
]
```
Output:
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
Delete ENUM Type
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
Array|Array of integer|Yes|ID list of resoruce, which combined with comma ','

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|string|showing as "Success"
statusMessage|string|Return this field with details only when exception happen

##### Example：
Valid Input：
```
[
  47
]
```
Output:
```
{
  "statusCode": "OK",
  "data": "Success"
}
```
Invalid Input:
```
[
  9999
]
```
Output:
```
{
  "statusCode": "ERROR",
  "statusMessage": "Unable to find com.webank.cmdb.domain.AdmBasekeyCatType with id 9999"
}
```

### <span id="EnumCat">ENUM Catalog - EnumCat</span>
#### [POST] /api/v2/enum/cats/create
Create ENUM Catalog
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:-- 
Array|Array of [EnumCatDto](#EnumCatDto)|Yes|ENUM Catalog entity information without ID field

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
statusCode|string|OK: Success， ERROR: Failed，ERR_INVALID_ARGUMENT: Invalid Argument Error，ERR_BATCH_CHANGE: Batch change failed
data|Array of [EnumCatDto](#EnumCatDto)|ENUM Catalog entity information must include ID field

#### /api/v2/enum/cats/retrieve
Retrieve ENUM Catalog
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
request|[QueryRequest](#QueryRequest)|No|Request Object of Parameters

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|[PageInfo](#PageInfo)|Paging information
contents|Array of [EnumCatDto](#EnumCatDto)|ENUM Catalog entity information

#### /api/v2/enum/cats/update
Update ENUM Catalog
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
Array|Array of [EnumCatDto](#EnumCatDto)|No|ENUM Catalog entity information, must include ID field

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
statusCode|string|OK: Success， ERROR: Failed，ERR_INVALID_ARGUMENT: Invalid Argument Error，ERR_BATCH_CHANGE: Batch change failed
data|Array of [EnumCatDto](#EnumCatDto)|ENUM Catalog entity information

#### /api/v2/enum/cats/delete
Delete ENUM Catalog
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
Array|Array of integer|Yes|ID list of resoruce, which combined with comma ','

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|string|showing as "Success"
statusMessage|string|Return this field with details only when exception happen

### <span id="EnumCode">ENUM Key/Value - EnumCode</span>
#### [POST] /api/v2/enum/codes/create
Create ENUM Key/Value
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:-- 
Array|Array of [EnumCodeDto](#EnumCodeDto)|Yes|ENUM Key/Value entity information without ID field

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
statusCode|string|OK: Success， ERROR: Failed，ERR_INVALID_ARGUMENT: Invalid Argument Error，ERR_BATCH_CHANGE: Batch change failed
data|Array of [EnumCodeDto](#EnumCodeDto)|ENUM Key/Value entity information must include ID field

#### /api/v2/enum/codes/retrieve
Retrieve ENUM Key/Value
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
request|[QueryRequest](#QueryRequest)|No|Request Object of Parameters

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|[PageInfo](#PageInfo)|Paging information
contents|Array of [EnumCodeDto](#EnumCodeDto)|ENUM Key/Value entity information

#### /api/v2/enum/codes/update
Update ENUM Key/Value
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
Array|Array of [EnumCodeDto](#EnumCodeDto)|No|ENUM Key/Value entity information, must include ID field

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
statusCode|string|OK: Success， ERROR: Failed，ERR_INVALID_ARGUMENT: Invalid Argument Error，ERR_BATCH_CHANGE: Batch change failed
data|Array of [EnumCodeDto](#EnumCodeDto)|ENUM Key/Value entity information

#### /api/v2/enum/codes/delete
Delete ENUM Key/Value
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
Array|Array of integer|Yes|ID list of resoruce, which combined with comma ','

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|string|showing as "Success"
statusMessage|string|Return this field with details only when exception happen

### <span id="CiType">CI Type - CiType</span>
#### [POST] /api/v2/ciTypes/create
Create CI Type
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:-- 
Array|Array of [CiTypeDto](#CiTypeDto)|Yes|CI Type entity information without ID field

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--  
statusCode|string|OK: Success， ERROR: Failed，ERR_INVALID_ARGUMENT: Invalid Argument Error，ERR_BATCH_CHANGE: Batch change failed  
data|Array of [CiTypeDto](#CiTypeDto)|CI Type entity information must include ID field

#### [POST] /api/v2/ciTypes/retrieve
Retrieve CI Type
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
request|[QueryRequest](#QueryRequest)|No|Request Object of Parameters

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|[PageInfo](#PageInfo)|Paging information
contents|Array of [CiTypeDto](#CiTypeDto)|CI Type entity information

#### [POST] /api/v2/ciTypes/update
Update CI Type
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
Array|Array of [CiTypeDto](#CiTypeDto)|No|CI Type entity information, must include ID field

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
statusCode|string|OK: Success， ERROR: Failed，ERR_INVALID_ARGUMENT: Invalid Argument Error，ERR_BATCH_CHANGE: Batch change failed
data|Array of [CiTypeDto](#CiTypeDto)|CI Type entity information

#### [POST] /api/v2/ciTypes/delete
Delete CI Type
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
Array|Array of integer|Yes|ID list of resoruce, which combined with comma ','

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|string|showing as "Success"
statusMessage|string|Return this field with details only when exception happen

### <span id="CiTypeAttr">CI Type Attr - CiTypeAttr</span>
#### [POST] /api/v2/ciTypeAttrs/create
Create CI Type Attr
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:-- 
Array|Array of [CiTypeAttrDto](#CiTypeAttrDto)|Yes|CI Type Attr entity information without ID field

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
statusCode|string|OK: Success， ERROR: Failed，ERR_INVALID_ARGUMENT: Invalid Argument Error，ERR_BATCH_CHANGE: Batch change failed
data|Array of [CiTypeAttrDto](#CiTypeAttrDto)|CI Type Attr entity information must include ID field

#### [POST] /api/v2/ciTypeAttrs/retrieve
Retrieve CI Type Attr
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
request|[QueryRequest](#QueryRequest)|No|Request Object of Parameters

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|[PageInfo](#PageInfo)|Paging information
contents|Array of [CiTypeAttrDto](#CiTypeAttrDto)|CI Type Attr entity information

#### [POST] /api/v2/ciTypeAttrs/update
Update CI Type Attr
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
Array|Array of [CiTypeAttrDto](#CiTypeAttrDto)|No|CI Type Attr entity information, must include ID field

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
statusCode|string|OK: Success， ERROR: Failed，ERR_INVALID_ARGUMENT: Invalid Argument Error，ERR_BATCH_CHANGE: Batch change failed
data|Array of [CiTypeAttrDto](#CiTypeAttrDto)|CI Type Attr entity information

#### [POST] /api/v2/ciTypeAttrs/delete
Delete CI Type Attr
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
Array|Array of integer|Yes|ID list of resoruce, which combined with comma ','

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|string|showing as "Success"
statusMessage|string|Return this field with details only when exception happen

### <span id="Ci">CI</span>
#### [POST] /api/v2/ci/{ciTypeId}/create
Create CI
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:-- 
ciTypeId|integer|Yes|Specify the CI Type Id in URL for create the CI
Array|Array of Map<key,value>|Yes|CI entity information without ID field

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
statusCode|string|OK: Success， ERROR: Failed，ERR_INVALID_ARGUMENT: Invalid Argument Error，ERR_BATCH_CHANGE: Batch change failed
data|Array of Map<key,value>|CI entity information must include ID field

#### [POST] /api/v2/ci/{ciTypeId}/retrieve
Retrieve CI
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
ciTypeId|integer|Yes|Specify the CI Type Id in URL for retrieving the CI
request|[QueryRequest](#QueryRequest)|No|Request Object of Parameters

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|[PageInfo](#PageInfo)|Paging information
contents|Array of Map<key,value>)|CI entity information

#### [POST] /api/v2/ci/{ciTypeId}/update
Update CI
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
ciTypeId|integer|Yes|Specify the CI Type Id in URL for updating the CI
Array|Array of Map<key,value>|No|CI entity information, must include ID field

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
statusCode|string|OK: Success， ERROR: Failed，ERR_INVALID_ARGUMENT: Invalid Argument Error，ERR_BATCH_CHANGE: Batch change failed
data|Array of Map<key,value>|CI entity information

#### [POST] /api/v2/ci/{ciTypeId}/delete
Delete CI
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
ciTypeId|integer|Yes|Specify the CI Type Id in URL for deleting the CI
Array|Array of integer|Yes|ID list of resoruce, which combined with comma ','

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|string|showing as "Success"
statusMessage|string|Return this field with details only when exception happen

### <span id="User">User</span>

#### [GET] /api/v2/users/retrieve
Retrieve Users
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
request|[QueryRequest](#QueryRequest)|No|Request Object of Parameters

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|[PageInfo](#PageInfo)|Paging information
contents|Array of [UserDto](#UserDto)|User entity information

#### [POST] /api/v2/users/create
Create Users
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
userDtos|Array of [UserDto](#UserDto)|No|User entity information

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
userDtos|Array of [UserDto](#UserDto)|User entity information

### <span id="Role">Role</span>
#### [POST] /api/v2/roles/retrieve
Retrieve Roles
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
request|[QueryRequest](#QueryRequest)|Request Object of Parameters

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|[PageInfo](#PageInfo)|Paging information
contents|Array of [RoleDto](#RoleDto)|Role information

#### [POST] /api/v2/roles/create
Crrate Roles
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
roleDtos|Array of [RoleDto](#RoleDto)|Role information

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
contents|Array of [RoleDto](#RoleDto)|Role information

#### [POST] /api/v2/roles/delete
Delete Roles
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
requestIds|Array of Integer|IDs of Roles to be deleted

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|string|showing as "Success"
statusMessage|string|Return this field with details only when exception happen

#### [POST] /api/v2/roles/update
Update Roles
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
roleDtos|Array of Map<key,value>|Role information

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
contents|Array of [RoleDto](#RoleDto)|Role information

### <span id="Role_User">Role_Users</span>

#### [POST] /api/v2/role-users/retrieve
Retrieve Role-Users
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
request|[QueryRequest](#QueryRequest)|Request Object of Parameters

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|[PageInfo](#PageInfo)|Paging information
contents|Array of [RoleUserDto](#RoleUserDto)|Role information

#### [POST] /api/v2/role-users/create
Create Role-Users for assigning user to specific role
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
roleUsers|Array of [RoleUserDto](#RoleUserDto)|Role information

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
Array|Array of [RoleUserDto](#RoleUserDto)|Role information

#### [POST] /api/v2/role-users/delete
Delete Role-Users
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
requestIds|Array of Integer|Role-Users ID list to be deleted

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|string|showing as "Success"
statusMessage|string|Return this field with details only when exception happen

### <span id="Role_CiType">Role_CiType</span>

#### [POST] /api/v2/role-citypes/retrieve
Retrieve CI Types permissions of role
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
request|[QueryRequest](#QueryRequest)|Request Object of Parameters

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|[PageInfo](#PageInfo)|Paging information
contents|Array of [RoleCiTypeDto](#RoleCiTypeDto)|CI Types permissions of role

#### [POST] /api/v2/role-citypes/create
Create CI Types permissions for specific role.
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
roleCiTypes|Array of [RoleCiTypeDto](#RoleCiTypeDto)|CI Types permissions of role

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
Array|Array of [RoleCiTypeDto](#RoleCiTypeDto)|CI Types permissions of role

#### [POST] /api/v2/role-citypes/update
Update CI Types permissions of role
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
request|Array of Map<key,value>|CI Types permissions of role

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
Array|Array of [RoleCiTypeDto](#RoleCiTypeDto)|CI Types permissions of role

#### [POST] /api/v2/role-citypes/delete
Delete CI Types permissions of role
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
requestIds|Array of Integer|ID list of CI Types permissions

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|string|showing as "Success"
statusMessage|string|Return this field with details only when exception happen

### <span id="Role_CiTypeAttr">CI属性授权 - Role_CiTypeAttr</span>
#### [POST] /api/v2/role-citype-ctrl-attrs/retrieve
Retrieve CI Type Attrs permissions of role
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
request|[QueryRequest](#QueryRequest)|Request Object of Parameters

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|[PageInfo](#PageInfo)|Paging information
contents|Array of [RoleCiTypeCtrlAttrDto](#RoleCiTypeCtrlAttrDto)|角色CI Type Attr permission information

#### [POST] /api/v2/role-citype-ctrl-attrs/create
Create CI Type Attrs permissions of role
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
roleCiTypeCtrlAttrs|Array of [RoleCiTypeCtrlAttrDto](#RoleCiTypeCtrlAttrDto)|CI Type Attr permission information

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
Array|Array of [RoleCiTypeCtrlAttrDto](#RoleCiTypeCtrlAttrDto)|CI Type Attr permission information

#### [POST] /api/v2/role-citype-ctrl-attrs/update
Update CI Type Attrs permissions of role
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
request|Array of Map<key,value>|CI Type Attr permission information

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
Array|Array of [RoleCiTypeDto](#RoleCiTypeDto)|CI Type Attr permission information

#### [POST] /api/v2/role-citype-ctrl-attrs/delete
Delete CI Type Attrs permissions of role
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
requestIds|Array of Integer|CI Type Attr ID

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|string|showing as "Success"
statusMessage|string|Return this field with details only when exception happen

### <span id="Role_CiTypeAttr_Conditon">Role_CiTypeAttr_Conditon</span>
#### [POST] /api/v2/role-citype-ctrl-attrs-conditions/retrieve
Retrieve CI Type Attr permission effective conditions of role
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
request|[QueryRequest](#QueryRequest)|Request Object of Parameters

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|[PageInfo](#PageInfo)|Paging information
contents|Array of [RoleCiTypeCtrlAttrConditionDto](#RoleCiTypeCtrlAttrConditionDto)|CI Type Attr permission effective conditions of role

#### [POST] /api/v2/role-citype-ctrl-attrs-conditions/create
Create CI Type Attr permission effective conditions of role
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
roleCiTypeCtrlAttrConditions|Array of [RoleCiTypeCtrlAttrConditionDto](#RoleCiTypeCtrlAttrConditionDto)|CI Type Attr permission effective conditions of role

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
Array|Array of [RoleCiTypeCtrlAttrConditionDto](#RoleCiTypeCtrlAttrConditionDto)|CI Type Attr permission effective conditions of role

#### [POST] /api/v2/role-citype-ctrl-attrs-conditions/update
修改CI Type Attr permission effective conditions of role
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
request|Array of Map<key,value>|CI Type Attr permission effective conditions of role

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
Array|Array of [RoleCiTypeCtrlAttrConditionDto](#RoleCiTypeCtrlAttrConditionDto)|CI Type Attr permission information

#### [POST] /api/v2/role-citype-ctrl-attrs-conditions/delete
Delete CI Type Attr permission effective conditions of role
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
requestIds|Array of Integer|ID list of CI Type Attr permission effective conditions

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|string|showing as "Success"
statusMessage|string|Return this field with details only when exception happen

### <span id="IntQuery">Integrated Enquiry</span>

#### [GET]/api/v2/intQuery/{queryId}
Integrated enquiry by query ID 
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
queryId|Integer|ID for getting integrated enquiry

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
response|[IntegrationQueryDto](#IntegrationQueryDto)|Response of integrated enquiry 

#### [POST] /api/v2/intQuery/ciType/{ciTypeId}/{queryName}/save
Save integrated enquiry for specific CI Type
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
ciTypeId|Integer|CIid
queryName|String|Name of integrated enquiry
intQueryDto|[IntegrationQueryDto](#IntegrationQueryDto)|Integrated enquiry information

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
int|int|ID of the created integrated enquiry


#### [POST] /api/v2/intQuery/{queryId}/update
Update integrated enquiry
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
queryId|int|ID of the integrated enquiry to be updated.
intQueryDto|[IntegrationQueryDto](#IntegrationQueryDto)|Integrated enquiry information to be updated. 

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|string|showing as "Success"
statusMessage|string|Return this field with details only when exception happen


#### [POST] /api/v2/intQuery/ciType/{ciTypeId}/{queryId}/delete
Delete Integrated enquiry
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
queryId|int|ID of the integrated enquiry to be deleted
ciTypeId|Integer|CIid

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|string|showing as "Success"
statusMessage|string|Return this field with details only when exception happen



#### [POST]/api/v2/intQuery/{queryId}/execute
Execute integrated enquiry 
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
queryId|Integer|ID of the integrated enquiry to be executed

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|string|showing as "Success"
statusMessage|string|Return this field with details only when exception happen
Param Name|Type|Description
:--|:--|:--    
data|[PageInfo](#PageInfo)|Paging information
contents|Array of Map<key,value>|Results after integrated enquiry

### <span id="Image">Icon Image</span>
#### [GET] /api/v2/image/{imageId}
Retrieve image by ID
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
imageId|int|ID of image
response|HttpServletResponse|Response of image
##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|string|showing as "Success"
statusMessage|string|Return this field with details only when exception happen

#### [POST] /api/v2/image/upload
Upload image
##### Input Parameters：
Param Name|Type|Description
:--|:--|:--    
file|MultipartFile|Image file
##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
data|string|showing as "Success"
statusMessage|string|Return this field with details only when exception happen

### <span id="Constants">Constants</span>
#### [POST] /api/v2/constants/ciStatus/retrieve
Retrieve CI Status
##### Input Parameters：None

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
statusCode|String|OK: Success, ERROR: Failed
Array|Array of String|CI Status as constant list
##### Example：
Valid Output：
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
Retrieve reference types
##### Input Parameters：None

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
statusCode|String|OK: Success, ERROR: Failed
Array|Array of String|Reference types as constant list
##### Example：
Valid Output：
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
Retrieve input types
##### Input Parameters：None

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
statusCode|String|OK: Success, ERROR: Failed
Array|Array of String|Input types as constant list
##### Example：
Valid Output：
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
Retrieve effective status
##### Input Parameters：无

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
statusCode|String|OK: Success, ERROR: Failed
data|Array of String|Effective status as constant list
##### Example：
Valid Output：
```
{
  "statusCode": "OK",
  -"data": [
    "active",
    "inactive"
  ]
}
```

### <span id="Apply">CI Type/Attr Status Operation - Apply</span>
#### [POST] /api/v2/ciTypes/applyAll
Create all CI Types and their corresponding Attrs with 'notCreated' status physically
##### Input Parameters：None
##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
statusCode|string|OK: Success， ERROR: Failed，ERR_INVALID_ARGUMENT: Invalid Argument Error，ERR_BATCH_CHANGE: Batch change failed
statusMessage|string|Return this field with details only when exception happen

#### [POST] /api/v2/ciTypes/apply
Create specific CI Types and their corresponding Attrs with 'notCreated' status physically
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
Array|Array of integer|Yes|CI Type ID list，see [CiTypeDto](#CiTypeDto).ciTypeId
##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
statusCode|string|OK: Success， ERROR: Failed，ERR_INVALID_ARGUMENT: Invalid Argument Error，ERR_BATCH_CHANGE: Batch change failed
statusMessage|string|Return this field with details only when exception happen

#### [POST] /api/v2/ciTypeAttrs/apply
Create all specific ID of CI Type Attrs with 'notCreated' status physically
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
Array|Array of integer|Yes|CI Type Attr ID list，see [CiTypeAttrDto](#CiTypeAttrDto).ciTypeAttrId
##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
statusCode|string|OK: Success， ERROR: Failed，ERR_INVALID_ARGUMENT: Invalid Argument Error，ERR_BATCH_CHANGE: Batch change failed
statusMessage|string|Return this field with details only when exception happen

### <span id="CI_State_Operate">CI status operation - CI_State_Operate</span>
#### [POST] /api/v2/ci/state/operate
CI Status operation according to the state machine of the CI
##### Input Parameters：
Param Name|Type|Required|Description
:--|:--|:--|:--
Array|Array of integer|Yes|CI TypeID list，see [CiTypeDto](#CiTypeDto).ciTypeId
operation|string|Yes|insert，delete， update，discard，confirm， startup， stop<br> Note：operation may different for state machine

##### Output Parameters:
Param Name|Type|Description
:--|:--|:--    
statusCode|string|OK: Success， ERROR: Failed，ERR_INVALID_ARGUMENT: Invalid Argument Error，ERR_BATCH_CHANGE: Batch change failed
data|Array of Map<key,value>|CI entity information

## Data Model：
### 1. Common Data Model
#### <span id="QueryRequest">QueryRequest</span>
Name|Type|Required|Description
:--|:--|:--|:--
dialect/data|object|No|Dialect data/Additional data
dialect/showCiHistory|boolean|No|Indicate if return history data， default：false
filterRs|string|No|Default：and <br>Relationship -- and， or
filters|Array of Filter|No|Filters
groupsBys|Array of string|No|Group By 
Pageable|[Pageable](#Pageable)|No|Paging information
paging|boolean|No|Indicate if paging is needed
refResources|Array of string|No|Cross resource names
resultsColumns|Array of string|No|Required return attrs
sorting/asc|boolean|No|Indicate if sorting the results，default：true
sorting/field|string|No|Attr name for sorting

#### Filter
Name|Type|Required|Description
:--|:--|:--|:--
name|string|Yes|CI Type Attr name
operator|string|Yes|Operators，current support：in/contains/eq/gt/lt/ne/notNull/null
value|object|No|Depend on the operator，e.g. if operator is eq, value will be object(int or string)， if operator is contains, value will be a list of object

#### PageInfo
Name|Type|Required|Description
:--|:--|:--|:--
pageSize|integer|No|Rows of a page
startIndex|integer|No|Start page index
totalRows|integer|No|Total rows

#### <span id="Pageable">Pageable</span>
Name|Type|Required|Description
:--|:--|:--|:--
pageSize|integer|No|Rows of a page
startIndex|integer|No|Start page index

### 2. Entity Data Model
#### <span id="EnumCatTypeDto">EnumCatTypeDto</span>
Name|Type|Required|Description
:--|:--|:--|:--
callbackId|string|No|Unique ID of per row request data which used for caller to extract the result according
errorMessage|string|No|Return this field with details only when exception happen
catTypeId|integer|Yes|Entity ID, is generated after created, must be provided when updating and deleting  
catTypeName|string|Yes|ENUM Type name
ciTypeId|integer|No|CI Type ID which the ENUM Type only used privately for it
type|integer|No|ENUM Type's types - 1:system 2:common 3:private
description|string|No|Description of ENUM Type

#### <span id="EnumCatDto">EnumCat - ENUM Catalog</span>
Name|Type|Required|Description
:--|:--|:--|:--
callbackId|string|No|Unique ID of per row data which used for caller to extract the result according
errorMessage|string|No|Return this field with details only when exception happen
catId|integer|Yes|Entity ID, is generated after created, must be provided when updating and deleting  
catName|string|Yes|ENUM Catalog name
catTypeId|integer|Yes|ENUM Type ID, see [EnumCatTypeDto](#EnumCatTypeDto)
groupTypeId|integer|No|ENUM Catalog group ID, it a parent ID of specific Catalog
description|string|No|Description of ENUM Catalog

#### <span id="EnumCodeDto">EnumCodeDto - ENUM Key/Value</span>
Name|Type|Required|Description
:--|:--|:--|:--
callbackId|string|No|Unique ID of per row data which used for caller to extract the result according
errorMessage|string|No|Return this field with details only when exception happen
codeId|integer|Yes|Entity ID, is generated after created, must be provided when updating and deleting  
catId|integer|Yes|ENUM Catalog ID, see [EnumCatDto](#EnumCatDto)   
code|string|Yes|ENUM key
value|string|Yes|ENUM value
groupCodeId|integer|No|ENUM group ID
codeDescription|string|No|Description of ENUM
seqNo|integer|No|Maintained by system
status|string|No|Default：active, ENUM status - active， inactive

#### <span id="CiTypeDto">CiTypeDto - CI Type</span>
Name|Type|Required|Description
:--|:--|:--|:--
callbackId|string|No|Unique ID of per row data which used for caller to extract the result according
errorMessage|string|No|Return this field with details only when exception happen
ciTypeId|integer|Yes|Entity ID, is generated after created, must be provided when updating and deleting  
name|string|Yes|Name of CI Type
tableName|string|Yes|Name of database table name
status|string|No|Default：notCreated, CI status - notCreated，created， dirty， decommissioned
catalogId|integer|No|Catalog ID
seqNo|integer|No|Maintained by system
layerId|integer|No|Y axis seq NO.
zoomLevelId|integer|No|Z axis seq NO.
imageFileId|integer|No|Image ID
description|string|No|Description of CI Type

#### <span id="CiTypeAttrDto">CiTypeAttrDto - CI Type Attr</span>
Name|Type|Required|Description
:--|:--|:--|:--
callbackId|string|No|Unique ID of per row data which used for caller to extract the result according
errorMessage|string|No|Return this field with details only when exception happen
ciTypeAttrId|integer|Yes|Entity ID, is generated after created, must be provided when updating and deleting
ciTypeId|integer|Yes|CI Type ID，see [CiTypeDto](#CiTypeDto)  
name|string|Yes|Attr name
inputType|string|Yes|Allow input data type - text, date, textArea, select, multiSelect, ref, multiRef, number, orchestration_multi_ref, orchestration_ref
propertyName|string|Yes|Database column name of Attr, only support letters，number and underscore '_' combination, and must start with lowercase
propertyType|string|Yes|DB column data type of the Attr
length|string|No|DB column Length of the Attr
referenceId|integer|No|ID of the reference CI or ENUM, see [CiTypeDto](#CiTypeDto)  or  ENUM Catalog ID, see [EnumCatDto](#EnumCatDto)
referenceName|string|No|Name of the reference CI or ENUM
referenceType|integer|No|Type of the reference, which come from ENUM Catalog ID
filterRule|string|No|Rule for filtering the values of 'ref/multiRef' or 'select/MultiSelect'
searchSeqno|integer|No|
displaySeqNo|integer|No|
autoFillRule|string|No|Rule for auto fill the value by system instead of user
status|string|No|Default：notCreated, CI Status - notCreated，created，dirty，decommissioned
isDisplayed|boolean|No|
isEditable|boolean|No|
isHidden|boolean|No|
isNullable|boolean|No|
isRefreshable|boolean|No|
isSystem|boolean|No|Indicate if it is system Attr, if yes, not allow to be changed/deleted
isUnique|boolean|No|Indicate if unique is need
isAccessControlled|boolean|No|Indicate if access control is need
isAuto|boolean|No|Indicate if auto fill is need
description|string|No|Description of CI Type Attr

#### <span id="UserDto">UserDto</span>
Name|Type|Required|Description
:--|:--|:--|:--
userId|integer|No|Entity ID, is generated after created, must be provided when updating and deleting  
username|String|Yes|Username
password|String|No|password, it is raw password passed by user to system
fullName|String|No|Full name
description|String|No|Description of user

#### <span id="RoleDto">RoleDto</span>
Name|Type|Required|Description
:--|:--|:--|:--
roleId|integer|No|Entity ID, is generated after created, must be provided when updating and deleting  
roleName|String|Yes|Role name
roleType|String|No|Role type
isSystem|String|No|Indicate if system role, if yes, then not allow to delete
description|String|No|Description of role

#### <span id="RoleUserDto">RoleUserDto</span>
Name|Type|Required|Description
:--|:--|:--|:--
roleUserId|integer|No|Entity ID, is generated after created, must be provided when updating and deleting  
roleId|integer|Yes|ID of role
userId|integer|No|ID of user
isSystem|String|No|Indicate if system role user, if yes, then not allow to delete

#### <span id="RoleCiTypeDto">RoleCiTypeDto</span>
Name|Type|Required|Description
:--|:--|:--|:--
roleCiTypeId|integer|No|Entity ID, is generated after created, must be provided when updating and deleting  
ciTypeId|integer|Yes|CIid
roleId|integer|No|Role ID
ciTypeName|String|No|Role name
creationPermission|String|No|Indicate if have permissions of creation
removalPermission|String|No|Indicate if have permissions of deleting
modificationPermission|String|No|Indicate if have permissions of modification
enquiryPermission|String|No|Indicate if have permissions of retrieving
executionPermission|String|No|Indicate if have permissions of executing
grantPermission|String|No|Indicate if have permissions of granting


#### <span id="RoleCiTypeCtrlAttrDto">RoleCiTypeCtrlAttrDto</span>
Name|Type|Required|Description
:--|:--|:--|:--
roleCiTypeCtrlAttrId|integer|No|Entity ID, is generated after created, must be provided when updating and deleting  
roleCiTypeId|integer|Yes|Role ID list of CI Types permissions
creationPermission|String|No|Indicate if have permissions of creation
removalPermission|String|No|Indicate if have permissions of deleting
modificationPermission|String|No|Indicate if have permissions of modification
enquiryPermission|String|No|Indicate if have permissions of retrieving
executionPermission|String|No|Indicate if have permissions of executing
grantPermission|String|No|Indicate if have permissions of granting


#### <span id="RoleCiTypeCtrlAttrConditionDto">RoleCiTypeCtrlAttrConditionDto</span>
Name|Type|Required|Description
:--|:--|:--|:--
conditionId|integer|No|Entity ID, is generated after created, must be provided when updating and deleting  
roleCiTypeCtrlAttrId|integer|Yes|CI Type Attr ID of specific role
ciTypeAttrId|integer|No|CI Type Attr ID
ciTypeAttrName|String|No|CI Type Attr name
conditionValue|String|No|Condition value
conditionValueType|String|No|Type of condition value
conditionValueObject|Object|No|Condition value object


#### <span id="IntegrationQueryDto">IntegrationQueryDto</span>
Name|Type|Required|Description
:--|:--|:--|:--
name|String|No|Name of the integrated enquiry
ciTypeId|integer|Yes|CI Type ID
attrs|Array of Integer|No|CI Type Attr ID
attrAliases|String|No|Aliase of CI Type Attr
attrKeyNames|String|No|CI Type Attr name
conditionValueType|String|No|Type of the condition value
parentRs|[Relationship](#Relationship)|No|Parent Ci Type information
children|[IntegrationQueryDto](#IntegrationQueryDto)|No|Children integrated enquiry information


#### <span id="Relationship">Relationship</span>
Name|Type|Required|Description
:--|:--|:--|:--
attrId|Integer|No|CI Type Attr ID
isReferedFromParent|Boolean|No|Indicate if the attr is from parent CI Type


