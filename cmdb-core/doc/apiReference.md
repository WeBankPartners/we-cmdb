# CMDB api reference interface
1. Query CI types which the given CI type is referenced by

Key|Desc
--|:--
Url|/api/v1/ciType/{ciTypeId}/referBy
Method|POST

Response Example:
```
{
    "statusCode": "OK",
    "data": 
    [
        {
            "ciTypeId":10003,
            "name":"Sub System",
            "refInputType": "ref",
            "refName": "Zone ID",
            "refPropertyId": 2330,
            "refPropertyName":"zone_id"
            "relationship":"refTo"                #'refTo' (reference to current CI type) or 'refBy' (be referenced by current CI type)
        },
        {

        }
    ]
}
```

2. Query CI types which the given CI type  reference to

Key|Desc
--|:--
Url|/api/v1/ciType/{ciTypeId}/referTo
Method|POST

Response Example:
```
{
    "statusCode": "OK",
    "data": 
    [
        {
            "ciTypeId":10004,
            "name":"Zone",
            "refInputType": "ref",
            "refName": "Zone ID",
            "refPropertyId": 2368,
            "refPropertyName":"zone_id"
            "relationship":"refTo"                #'refTo' (reference to current CI type) or 'refBy' (be referenced by current CI type)
        },
        {

        }
    ]
}
```

3. Query the attributes of the given CI type

Key|Desc
--|:--
Url|/api/v1/ciType/{ciTypeId}/attributes
Method|POST

Response Example:
```
{
    "statusCode": "OK",
    "data": {
                "ciTypeAttrId": 2323,
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
}
```

4. Create aggregation integration query with different query branch

Key|Desc
--|:--
Url|/api/v1/ciType/intQuery/operateAgg
Method|POST

Request example:
```

[
    {
        "queryId":20102,                  #queryId for update operation
        "operation:"update",              #"create" or "update"
        "queryName":"plugin1-creation",
        "queryDesc":"creation desc",
        "criteria":[
                {
                    "branchId":100,
                    "branchCriteria":
                        {
                            "ciTypeId": 10005,
                            "ciTypeName":"Unit",
                            "routine":[10002,2329,10003,2341],
                            "attribute": {
                                "attrId": 2347,
                                "isCondition": true,
                                "isDiaplayed": true
                            }
                        }
                },
                {
                    "branchId":100,
                    "branchCriteria":
                    [
                        {
                            "ciTypeId": 10002,
                            "ciTypeName":"System"
                            "attribute": {
                                attrId: 2453,
                                "isCondition": true,
                                "isDiaplayed": false
                            }
                        },
                        ...
                    ]
                }
            ]
    },
    {
    }
]


```

Response example:
```
{
    "statusCode": "OK",
    "data": 
        [
            {
                "queryName":"plugin1-creation",
                "queryId":1234,
                "columns":[
                    {
                        "branchId":10002,
                        "alias":"System_subsystem_name"
                    },
                    {
                        "branchId":10003,
                        "alias":"System_subsystem_name_xxx"
                    }
                ]
            },
            {
                ...
            }
        ]
}
```

5. Update/insert CI data

Key|Desc
--|:--
Url|/api/v1/ciType/intSave/
Method|POST

Request example:
```
[
	{
		operation:update,
        cis:
        [
            {
                "ciTypeId":10011,
                "guid":"200001",
                "name_en":"english name",
                "desc":"description"
            }
        ]
	},
	{
		operation:insert,
        cis:
        [
            {
                "ciTypeId":10011,
                "name_en":"english name",
                "desc":"description"
            }
        ]
	}
]
```



