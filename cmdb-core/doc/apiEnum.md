# CMDB api enum interface
1. Query enum information

Key|Desc
--|:--
Url|/api/v1/enums
Method|POST

Request Example:
```
{
	"isPaging": true,
	"pageable":{
		"startIndex": 0,
		"pageSize": 100
	},
	"filters":{
		"catName":"",  #枚举名称
		"code":"",   #名
		"value":"", #值
		"groupName":"", #组
		"description":""   #说明
	},
    "sorting":{
        "asc":true,
        "field":"catName"  # can be one of ("catName","code","value","groupName","description")
    }
}
```
Response Example:
```
{
    "statusCode": "OK",
    "data": {
        "pageInfo": {
            "totalRows": 39,
            "startIndex": 0,
            "pageSize": 100
        },
        "enumInfos": [
            {
                "catId": 1,                       #枚举名称Id
                "catName": "CI Types",            #枚举名称
                "codeId": 2,                      #枚举值Id
                "code": "Catalog 2",              #枚举值-名
                "value": null,                    #枚举值-值
                "groupCodeId":10,                 #组Id
                "groupCode": null,                #组Code
                "groupName": null,                #组名
                "description": "Catalog 2 33333"  #说明
            },
            {
                "catId": 29,
                "catName": "CI Layers",
                "codeId": 5,
                "code": "Business Layer",
                "value": null,
                "groupCodeId":10,
                "groupCode": null,
                "groupName": null,
                "description": "Business Layer"
            }
		]
    }
}
```

2. List all enums for given catId

Key|Desc
--|:--
Url|/api/v1/enum/{catId}/kv
Method|GET

Response body example:
```
{
    "statusCode": "OK",
    "data": [
        {
            "codeId": 560,
            "code": "SZ",
            "name": "SZ"
        },
        {
            "codeId": 561,
            "code": "SH",
            "name": "SH"
        }
    ]
}
```

3. Update enum record

Key|Desc
--|:--
Url|/api/v1/enum/cat/{codeId}/update
Method|POST

Request body example:
```
{
    "catId": 29,
    "code": "Catalog 2",
    "value": "sample val",
    "groupCodeId": 112
    "description": "Catalog 2 33333"
}
```

4. Delete enum record

Key|Desc
--|:--
Url|/api/v1/enum/cat/{codeId}/delete
Method|POST

5. Add enum record

Key|Desc
--|:--
Url|/api/v1/enum/{catId}/code/add
Method|POST

Request body example:
```
{
    "code": "Catalog 2",
    "value": "sample val",
    "groupCode": "gd",
    "groupCodeId": 112
    "groupName": "gd",
    "description": "Catalog 2 33333"
}
```

6. List all enum cats

Key|Desc
--|:--
Url|/api/v1//enum/cats
Method|GET

Response example:
```
{
    "statusCode": "OK",
    "data": [
        {
            "catId": 1,
            "catName": "CI Types"
        },
        {
            "catId": 2,
            "catName": "System Types"
        }
    ]
}
```



