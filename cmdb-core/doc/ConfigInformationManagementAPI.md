# Configure information management API
1. Query base key information

Key|Desc
--|:--
Url|baseKeys
Old url|citype/getBaseKeyTreeJson.json
Method|GET

Response Example:
```
{
	"statusCode": "OK",
	"data": [{
		"idAdmBasekeyCat": 1,
		"catName": "CI Types",
		"descritpion": "CI Types",
		"baseCodeList": [{
			"code": "Business Layer",
			"seqNo": 1,
			"idAdmBasekey": 1,
			"codeDescription": "Business Layer"
		},
		{
			"code": "Running Layer",
			"seqNo": 2,
			"idAdmBasekey": 2,
			"codeDescription": "Running Layer"
		},
		{
			"code": "Physical Layer",
			"seqNo": 3,
			"idAdmBasekey": 3,
			"codeDescription": "Physical Layer"
		},
		{
			"code": "Planning Layer",
			"seqNo": 4,
			"idAdmBasekey": 4,
			"codeDescription": "Planning Layer"
		}]
	},
	{
		"idAdmBasekeyCat": 2,
		"catName": "System Types",
		"descritpion": "System Types",
		"baseCodeList": [{
			"code": "Infrastructure",
			"seqNo": 2,
			"idAdmBasekey": 554,
			"codeDescription": "infrastructure system"
		},
		{
			"code": "Functional",
			"seqNo": 1,
			"idAdmBasekey": 555,
			"codeDescription": "Functional system"
		}]
	}
	]
}
```
2. List ci type layer information

Key|Desc
--|:--
Url|/catalog/ciTypes
Old url|citype/getCiTypeTreeJson.do
Method|GET

Response Example:
```
{
    "statusCode": "OK",
    "data": [
        {
            "code": "Running Layer",
            "seqNo": 2,
            "codeDescription": "Running Layer",
            "ciTypes": [
                {
                    "ciTypeId": 0,
                    "ciType": 2,
                    "description": "Unit",
                    "tenementId": 1,
                    "name": "Unit",
                    "seqNo": 2,
                    "tableName": "wb_unit",
                    "tableStatus": "1",
                    "idAdmCiType": 10005,
                    "idCiType": 0
                },
                {
                    "ciTypeId": 0,
                    "ciType": 2,
                    "description": "Service",
                    "tenementId": 1,
                    "name": "Service",
                    "seqNo": 2,
                    "tableName": "wb_service",
                    "tableStatus": "1",
                    "idAdmCiType": 10006,
                    "idCiType": 0
                }
            ],
            "idAdmBasekeyCat": 1,
            "idAdmBasekey": 2
        },
        {
            "code": "Business Layer",
            "seqNo": 1,
            "codeDescription": "Business Layer",
            "ciTypes": [
                {
                    "ciTypeId": 0,
                    "ciType": 1,
                    "description": "System",
                    "tenementId": 1,
                    "name": "System",
                    "seqNo": 1,
                    "tableName": "wb_system",
                    "tableStatus": "1",
                    "idAdmCiType": 10002,
                    "idCiType": 0
                },
                {
                    "ciTypeId": 0,
                    "ciType": 1,
                    "description": "Sub System",
                    "tenementId": 1,
                    "name": "Sub System",
                    "seqNo": 1,
                    "tableName": "wb_sub_system",
                    "tableStatus": "1",
                    "idAdmCiType": 10003,
                    "idCiType": 0
                }
            ],
            "idAdmBasekeyCat": 1,
            "idAdmBasekey": 1
        },
        {
            "code": "Physical Layer",
            "seqNo": 3,
            "codeDescription": "Physical Layer",
            "ciTypes": [
                {
                    "ciTypeId": 0,
                    "ciType": 3,
                    "description": "IDC",
                    "tenementId": 1,
                    "name": "IDC",
                    "seqNo": 3,
                    "tableName": "wb_idc",
                    "tableStatus": "1",
                    "idAdmCiType": 10008,
                    "idCiType": 0
                },
                {
                    "ciTypeId": 0,
                    "ciType": 3,
                    "description": "SET Node",
                    "tenementId": 1,
                    "name": "SET Node",
                    "seqNo": 3,
                    "tableName": "wb_set_node",
                    "tableStatus": "1",
                    "ciTypeId": 10012,
                    "idCiType": 0
                },
                {
                    "ciTypeId": 0,
                    "ciType": 3,
                    "description": "DCN Node",
                    "tenementId": 1,
                    "name": "DCN Node",
                    "seqNo": 3,
                    "tableName": "wb_dcn_node",
                    "tableStatus": "1",
                    "ciTypeId": 10013,
                    "idCiType": 0
                }
            ],
            "basekeyCatId": 1,
            "basekeyId": 3
        },
        {
            "code": "Planning Layer",
            "seqNo": 4,
            "codeDescription": "Planning Layer",
            "ciTypes": [
                {
                    "ciTypeId": 0,
                    "ciType": 4,
                    "description": "Zone",
                    "tenementId": 1,
                    "name": "Zone",
                    "seqNo": 4,
                    "tableName": "wb_zone",
                    "tableStatus": "1",
                    "idAdmCiType": 10004,
                    "idCiType": 0
                },
                {
                    "ciTypeId": 0,
                    "ciType": 4,
                    "description": "DCN",
                    "tenementId": 1,
                    "name": "DCN",
                    "seqNo": 4,
                    "tableName": "wb_dcn",
                    "tableStatus": "1",
                    "idAdmCiType": 10009,
                    "idCiType": 0
                },
                {
                    "ciTypeId": 0,
                    "ciType": 4,
                    "description": "Zone Link",
                    "tenementId": 1,
                    "name": "Zone Link",
                    "seqNo": 4,
                    "tableName": "wb_zone_link",
                    "tableStatus": "1",
                    "idAdmCiType": 10010,
                    "idCiType": 0
                },
                {
                    "ciTypeId": 0,
                    "ciType": 4,
                    "description": "SET",
                    "tenementId": 1,
                    "name": "SET",
                    "seqNo": 4,
                    "tableName": "wb_set",
                    "tableStatus": "1",
                    "idAdmCiType": 10011,
                    "idCiType": 0
                }
            ],
            "idAdmBasekeyCat": 1,
            "idAdmBasekey": 4
        }
    ]
}
```
3. Get ci type and attribute

Key|Desc
--|:--
Url|/ciType/ciTypeAndAttr/{ciTypeId}
Old url|citype/getCiTypeAndAttrJson.do
Method|GET

Parameter|Desc
--|:--
ciTypeId|CI Type id

Example:
  Request: http://localhost:9080/ciType/ciTypeAndAttr/10002

  Response :
```
{
    "statusCode": "OK",
    "data": {
        "ciTypeId": 10002,
        "description": "System",
        "tenementId": 1,
        "name": "System",
        "tableName": "wb_system",
        "tableStatus": "1",
        "attributes": [
            {
                "admCiTypeAttrId": 2323,
                "description": "English Name",
                "displaySeqNo": 1,
                "displayType": "1",
                "editIsEditable": "0",
                "editIsHiden": "0",
                "editIsNull": "0",
                "editIsOnly": "1",
                "inputType": "text",
                "isDefunct": "0",
                "isSystem": "0",
                "length": 45,
                "name": "English Name",
                "propertyName": "name_en",
                "propertyType": "varchar",
                "referenceId": 0,
                "searchSeqNo": 1,
                "specialLogic": null,
                "status": 0
            },
            {
                "admCiTypeAttrId": 2324,
                "description": "Chinese Name",
                "displaySeqNo": 2,
                "displayType": "1",
                "editIsEditable": "0",
                "editIsHiden": "0",
                "editIsNull": "1",
                "editIsOnly": "0",
                "inputType": "text",
                "isDefunct": "0",
                "isSystem": "0",
                "length": 45,
                "name": "Chinese Name",
                "propertyName": "name_cn",
                "propertyType": "varchar",
                "referenceId": 0,
                "searchSeqNo": 2,
                "specialLogic": null,
                "status": 0
            },
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
            }
        ],
        "idCiType": 10002
    }
}
```

4. List all CI layers

Key|Desc
--|:--
Url|/baseKey/CILayers
Old url|citype/getCiTypeAndAttrJson.do
Method|GET


Example:
  Request: http://localhost:9080/baseKey/CILayer/list

  Response :
```
{
    "statusCode": "OK",
    "data": [
        {
            "code": "Business Layer",
            "seqNo": 5,
            "codeDescription": "Business Layer",
            "idAdmBasekey": 5
        },
        {
            "code": "Running Layer",
            "seqNo": 6,
            "codeDescription": "Running Layer",
            "idAdmBasekey": 6
        },
        {
            "code": "Physical Layer",
            "seqNo": 7,
            "codeDescription": "Physical Layer",
            "idAdmBasekey": 7
        },
        {
            "code": "Planning Layer",
            "seqNo": 8,
            "codeDescription": "Planning Layer",
            "idAdmBasekey": 8
        }
    ]
}
```

5. List all catalogs

Key|Desc
--|:--
Url|/baseKey/catalogs
Old url|citype/getCiTypeAndAttrJson.do
Method|GET

Example:
  Request: http://localhost:9080/baseKey/Catalogs

  Response :
```
{
    "statusCode": "OK",
    "data": [
        {
            "code": "Business Layer",
            "seqNo": 1,
            "codeDescription": "Business Layer",
            "idAdmBasekey": 1
        },
        {
            "code": "Running Layer",
            "seqNo": 2,
            "codeDescription": "Running Layer",
            "idAdmBasekey": 2
        },
        {
            "code": "Physical Layer",
            "seqNo": 3,
            "codeDescription": "Physical Layer",
            "idAdmBasekey": 3
        },
        {
            "code": "Planning Layer",
            "seqNo": 4,
            "codeDescription": "Planning Layer",
            "idAdmBasekey": 4
        }
    ]
}
````

6. List all CI types

Key|Desc
--|:--
Url|/baseKey/zoomLevels
Old url|citype/getCiTypeAndAttrJson.do
Method|GET

Example:
  Request: http://localhost:9080/baseKey/zoomLevel/list

  Response :
```
{
    "statusCode": "OK",
    "data": [
        {
            "code": "1",
            "seqNo": 9,
            "codeDescription": "1",
            "idAdmBasekey": 9
        },
        {
            "code": "2",
            "seqNo": 10,
            "codeDescription": "2",
            "idAdmBasekey": 10
        },
        {
            "code": "3",
            "seqNo": 11,
            "codeDescription": "3",
            "idAdmBasekey": 11
        },
        {
            "code": "4",
            "seqNo": 12,
            "codeDescription": "4",
            "idAdmBasekey": 12
        }
    ]
}
```
7. Add CI type

Key|Desc
--|:--
Url|/ciType/add
Old url|citype/addCiType.do
Method|POST


Example:
  Request url: http://localhost:9080/ciType/add
  ```
  Request body:
  {
	"ciTypeId":10031,
    "catalogId": 1,
    "description": "Test CI 211",
    "tenementId": 1,
    "layerId": 5,
    "name": "System",
    "seqNo": 1,
    "tableName": "wb_test_ci_2",
    "tableStatus": "1",
    "zoomLevelId": 556,
    "imageFileId": 32
}
 ```
  Response (sucessfully):
  ```
{"statusCode":"OK"}
```
  
  Response (error with invalid argument):
  ```
  {
    "statusCode": "ERR_INVALID_ARGUMENT",
    "data": "The specific table is existed. (tableName:wb_test_ci_2)"
  }
  ```

8. update CI type

Key|Desc
--|:--
Url|/ciType/{ciTypeId}/update
Old url|citype/updateCiType.do
Method|POST


Example:
  Request url: http://localhost:9080/ciType/10031/update
  Request body:
  ```
{
	"ciTypeId":10031,
    "catalogId": 1,
    "description": "Test CI 211",
    "tenementId": 1,
    "layerId": 5,
    "name": "System",
    "seqNo": 1,
    "tableName": "wb_test_ci_2",
    "tableStatus": "1",
    "zoomLevelId": 556,
    "imageFileId": 32
}
   ```
  Response (sucessfully):
  ```
  {"statusCode":"OK"}
  ```
  
  Response (error with invalid argument):
  ```
    {
        "statusCode": "ERR_INVALID_ARGUMENT",
        "data": "Can not find out CiType with given argument. (ciTypeId:20031)"
    }
   ```

9. Add CI type attribute

Key|Desc
--|:--
Url|/ciType/{ciTypeId}/attr/add
Old url|citype/addCiTypeAttr.do
Method|POST


Example:
  Request url: http://localhost:9080/ciType/10025/attr/add
  Request body:
  ```
{
    "description": "English Name",
    "displaySeqNo": 1,
    "displayType": "1",
    "editIsEditable": "0",
    "editIsHiden": "0",
    "editIsNull": "0",
    "editIsOnly": "1",
    "inputType": "text",
    "isDefunct": "0",
    "isSystem": "0",
    "length": 45,
    "name": "English Name",
    "propertyName": "name_en",
    "propertyType": "varchar",
    "referenceId": 0,
    "searchSeqNo": 1,
    "specialLogic": null,
    "status": 0
}
```
  Response (sucessfully):
  ```
  {"statusCode":"OK"}
```

10. update CI type attribute

Key|Desc
--|:--
Url|/ciType/{ciTypeId}/attr/{ciTypeAttrId}/update
Old url|citype/updateCiTypeAttr.do
Method|POST


Example:
  Request url: http://localhost:9080/ciType/10025/attr/2430/update
  Request body:
  ```
{
    "description": "English Name 2",
    "displaySeqNo": 1,
    "displayType": "1",
    "editIsEditable": "0",
    "editIsHiden": "0",
    "editIsNull": "0",
    "editIsOnly": "1",
    "inputType": "text",
    "isDefunct": "0",
    "isSystem": "0",
    "length": 45,
    "name": "English Name 2",
    "propertyName": "name_en",
    "propertyType": "varchar",
    "referenceId": 0,
    "searchSeqNo": 1,
    "specialLogic": null,
    "status": 0
}
```
  Response (sucessfully):
  ```
  {"statusCode":"OK"}
```

11. delete CI type attribute

Key|Desc
--|:--
Url|/ciType/{ciTypeId}/attr/{ciTypeAttrId}/delete
Old url|citype/deleteCiTypeAttr.do
Method|POST


Example:
  Request url: http://localhost:9080/ciType/10025/attr/2430/delete
  Response (sucessfully):
  ```
  {"statusCode":"OK"}
```
12. Move up ci type

Key|Desc
--|:--
Url|/ciType/{ciTypeId}/up
Old url|cmdb/citype/upOrDownCiType.do?opera=up
Method|POST

13. Move down ci type

Key|Desc
--|:--
Url|/ciType/{ciTypeId}/down
Old url|cmdb/citype/upOrDownCiType.do?opera=down
Method|POST

14. List all attribute unique groups

Key|Desc
--|:--
Url|/ciType/{ciTypeId}/attrUniqueGroups
Old url|
Method|GET

15. Add attribute unique groups

Key|Desc
--|:--
Url|/ciType/{ciTypeId}/attrUniqueGroup/add
Old url|
Method|POST

Example:
  Request:
  ```
{
    "ciTypeId": 10004,
    "name": "Test union key 4",
    "ciTypeAttrs": [
        {
            "admCiTypeAttrId": 2336
        },
        {
            "admCiTypeAttrId": 2337
        }
    ]
}  
  ```
16. delete attribute unique group

Key|Desc
--|:--
Url|/ciType/attrUniqueGroup/{attrGroupId}/delete
Old url|
Method|POST


17. Upload image file

Key|Desc
--|:--
Url|/image/upload
Old url|/uploadImg.do
Method|POST (FORM)
File key|img

Response example:
```
{
    "statusCode": "OK",
    "data": {
        "id": 4
    }
}
```

18. Get image file

Key|Desc
--|:--
Url|/image/{imgId}
Old url|/getImg.do
Method|GET


