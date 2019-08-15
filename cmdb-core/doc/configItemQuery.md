# CMDB configuration item query interface

1. List ci type layer information

Key|Desc
--|:--
Url|/catalog/ciTypes
Old url|citype/getCiTypeTreeJson.do
Method|GET

2. List headers of given CI type

Key|Desc
--|:--
Url|/ciType/{ciTypeId}/header
Old url|/api/operateCi.json
Method|GET

response example:
```
{
    "statusCode": "OK",
    "data": [
            {
                "admCiTypeAttrId": 2325,
                "description": "System ID",
                "displaySeqNo": 3,
                "displayType": "1",
                "editIsEditable": "0",
                "editIsHiden": "0",
                "editIsNull": "1",
                "editIsOnly": "0",
                "inputType": "ref",
                "isDefunct": "0",
                "isSystem": "0",
                "length": 13,
                "name": "System ID",
                "propertyName": "system_id",
                "propertyType": "varchar",
                "referenceId": 10002,
                "searchSeqNo": 4,
                "specialLogic": "",
                "status": 0
            },
            {
                "ciTypeAttrId": 5,
                "description": "System Type",
                "displaySeqNo": 5,
                "displayType": 1,
                "isEditable": 0,
                "isHidden": 0,
                "isNull": 0,
                "isUnique": 0,
                "inputType": "select",
                "isDefunct": "0",
                "isSystem": "0",
                "length": 45,
                "name": "System Type",
                "propertyName": "system_type",
                "propertyType": "varchar",
                "referenceId": 2,                               
                "searchSeqNo": 5,
                "status": 0,
                "isAccessControlled": 0,
			"vals":[
				{
					"id":100,
					"code":"type 1"
				 },
				{
					"id":101,
					"code":"type 2"
				 }
			    ]
            }			
			
		}
	]
}
```


3. List all cis under given CI Type

Key|Desc
--|:--
Url|/ciType/{ciTypeId}/cis
Old url|/api/operateCi.json
Method|POST

Request example:
```
{
	"isPaging": true,
	"pageable":{
		"startIndex": 0,
		"pageSize": 100
	},
	"filters":{
        "enName":"SETIP"           #"attribute name":"filter value"
	},
    "sorting":{
        "asc":true,
        "field":"systemId"         #attribute name
    }
}
```

Response example:
```
{
    "statusCode": "OK",
    "data": {
        "pageInfo": {
            "totalRows": 39,
            "startIndex": 0,
            "pageSize": 100
        },
		"cis":[
			{
				"nameEn": "SETIP",
				"nameCn": "地外文明搜寻 计划",
				"systemId": null,
				"description": "SETIP",
				"systemType": "tool_01",
				"guid": "1000200000461",
				"updatedBy": "umadmin",
				"updatedDate": "2019-03-21 15:56:58:281",
				"createdBy": "umadmin",
				"createdDate": "2019-03-21 15:56:58:281"
			},
			{
				"nameEn": "SETIP 2",
				"nameCn": "地外文明搜寻 计划 2",
				"systemId": null,
				"description": "SETIP 2",
				"systemType": "tool_02",
				"guid": "1000200000462",
				"updatedBy": "umadmin",
				"updatedDate": "2019-03-21 15:56:58:281",
				"createdBy": "umadmin",
				"createdDate": "2019-03-21 15:56:58:281"
			}
        ]
	}
}
```
Note:
if inputType is "select", we can list enum codes with /baseKey/category/2/codes

4. List CI type id and name as kv

Key|Desc
--|:--
Url|/ciType/{ciTypeId}/kvs
Old url|/api/ciKVList.json
Method|GET

Response example:
```
{
    "statusCode": "OK",
    "data": [
        {
		"k": "1000200000461",
		"v": "SETIP"
	    }
    ]
}    
```

5. Add ci data under given CI Type

Key|Desc
--|:--
Url|/ciType/{ciTypeId}/ci/add
Old url|/api/operateCi.json
Method|POST

Request example:
```
{
    "nameEn": "Test system",
    "nameCn": "Test system",
    "systemId": "1000200000461",
    "description": "test desc",
    "systemType": "tool_01"
}
```

6. Delete ci data under given CI Type

Key|Desc
--|:--
Url|/ciType/{ciTypeId}/ci/{ciId}/delete
Old url|/api/operateCi.json
Method|POST

7. Update ci data under given CI Type

Key|Desc
--|:--
Url|/ciType/{ciTypeId}/ci/{ciId}/update
Old url|/api/operateCi.json
Method|POST

8. query ci data under given CI Type

Key|Desc
--|:--
Url|/ciType/{ciTypeId}/ci/{ciId}
Old url|/api/operateCi.json
Method|GET

9. Download ci data (excel file) for given CI Type

Key|Desc
--|:--
Url|/ciType/{ciTypeId}/download
Method|GET

10. Upload ci data for given CI type

Key|Desc
--|:--
Url|/ciType/{ciTypeId}/upload
Method|POST


