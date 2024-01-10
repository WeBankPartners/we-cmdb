## 提供给 WeCube 用的 API 概览及实例：
#### 接口鉴权
所有接口调用都需要在http请求的header里带上Authorization字段，值是wecube界面登录请求获取的accessToken    
例如：Authorization: Bearer xxxxxx    

#### POST: /wecmdb/entities/{ciType}/query
查询CI数据，其中URL中的{ciType}是要查询的CI类型
##### 输入参数：
参数名称|类型|必选|描述
:--|:--|:--|:--
criteria|[EntityQueryObj](#EntityQueryObj)|否|主要查询条件
additionalFilters|[\[\]EntityQueryObj](#EntityQueryObj)|否|额外查询条件

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
status|string|请求状态
message|string|返回信息
data|[]Map\[string\]object|返回数据，map数组

##### 示例：
请求 /wecmdb/entities/test_a/query  
正常输入：
```
{
	"criteria": {
		"attrName": "code",
		"op": "eq",
		"condition": "a01"
	}
}
```
正常输出：
```
{
	"status": "OK",
	"message": "success",
	"data": [{
		"code": "a01",
		"confirm_time": "",
		"create_time": "2021-07-02 08:56:19",
		"create_user": "umadmin",
		"displayName": "",
		"guid": "test_a_60ded4b35dbf9291",
		"id": "test_a_60ded4b35dbf9291",
		"key_name": "",
		"nextOperations": ["Delete", "Update", "Rollback", "Confirm"],
		"state": "added_0",
		"update_time": "2021-07-02 08:56:19",
		"update_user": "umadmin"
	}]
}
```

#### POST: /wecmdb/entities/{ciType}/create
新增CI数据，其中URL中的{ciType}是要查询的CI类型
##### 输入参数：
输入参数为一个map数组 []map\[string\]obj ，其中map的key是CI属性，value是CI属性对应类型的值

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
status|string|请求状态
message|string|返回信息
data|[]Map\[string\]object|返回数据，map数组

##### 示例：
正常输入：
```
[{
	"code": "a03"
}]
```
正常输出：
```
{
	"status": "OK",
	"message": "success",
	"data": [{
		"code": "a03",
		"create_time": "2021-07-02 09:03:17",
		"create_user": "wecube",
		"displayName": "",
		"guid": "test_a_60ded65550b3fcc0",
		"id": "test_a_60ded65550b3fcc0",
		"key_name": "",
		"state": "added_0",
		"update_time": "2021-07-02 09:03:17",
		"update_user": "wecube"
	}]
}
```

#### POST: /wecmdb/entities/{ciType}/update
修改CI数据，其中URL中的{ciType}是要查询的CI类型
##### 输入参数：
输入参数为一个map数组 []map\[string\]obj ，其中map的key是CI属性，value是CI属性对应类型的值， 修改与删除方法必须包含id或guid属性  

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
status|string|请求状态
message|string|返回信息

##### 示例：
正常输入：
```
[{
	"id": "test_a_60ded65550b3fcc0",
	"code": "a04"
}]
```
正常输出：
```
{
	"status": "OK",
	"message": "success"
}
```

#### POST: /wecmdb/entities/{ciType}/delete
删除CI数据，其中URL中的{ciType}是要查询的CI类型
##### 输入参数：
输入参数为一个map数组 []map\[string\]obj ，其中map的key是CI的id或guid属性，value是CI属性对应类型的值 

##### 输出参数：
参数名称|类型|描述
:--|:--|:--    
status|string|请求状态
message|string|返回信息

##### 示例：
正常输入：
```
[{
	"id": "test_a_60ded65550b3fcc0"
}]
```
正常输出：
```
{
	"status": "OK",
	"message": "success"
}
```


## 数据结构：
### 1. 公共数据结构
#### <span id="EntityQueryObj">EntityQueryObj</span>
名称|类型|必选|描述
:--|:--|:--|:--
attrName|string|是|属性名
op|string|是|条件
condition|object|是|条件值
