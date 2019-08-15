# Base configuration management API
1. List all base keys

Key|Desc
--|:--
Url|/baseKey/categories
Old url|citype/getBaseKeyTreeJson.json
Method|GET

2. List all CI layers

Key|Desc
--|:--
Url|/baseKey/ciLayers
Old url|
Method|GET

3. List all catalogs

Key|Desc
--|:--
Url|/baseKey/catalogs
Old url|
Method|GET

4. List all zoomLevels

Key|Desc
--|:--
Url|/baseKey/zoomLevels
Old url|
Method|GET

5. List category type hierarchy and overview 

Key|Desc
--|:--
Url|/baseKey/catType/overview
Old url|
Method|GET

Response example:
```
{
    "statusCode": "OK",
    "data": [
        {
            "baseKeyCatTypeId": 1,
            "catTypeName": "Commons",
            "description": "Commons",
            "baseKeyCategories": [
                {
                    "admBasekeyCatId": 1,
                    "catName": "CI Types",
                    "descritpion": "CI Types",
                    "baseCodeList": [
                        {
                            "code": "Catalog 1",
                            "seqNo": 1,
                            "basekeyId": 1,
                            "codeDescription": "Catalog 1"
                        },
                        {
                            "code": "Catalog 2",
                            "seqNo": 2,
                            "basekeyId": 2,
                            "codeDescription": "Catalog 2"
                        },
                        {
                            "code": "Catalog 3",
                            "seqNo": 3,
                            "basekeyId": 3,
                            "codeDescription": "Catalog 3"
                        },
                        {
                            "code": "Catalog 4",
                            "seqNo": 4,
                            "basekeyId": 4,
                            "codeDescription": "Catalog 4"
                        }
                    ]
                },

            ]
        }
   ]
}
```

6. List all category types

Key|Desc
--|:--
Url|/baseKey/catTypes
Old url|
Method|GET

response example:
```
{
    "statusCode": "OK",
    "data": [
        {
            "baseKeyCatTypeId": 1,
            "catTypeName": "Commons",
            "description": "Commons"
        },
        {
            "baseKeyCatTypeId": 2,
            "catTypeName": "System",
            "description": "System"
        },
        {
            "baseKeyCatTypeId": 3,
            "catTypeName": "Sub System",
            "description": "Sub System"
        },
        {
            "baseKeyCatTypeId": 4,
            "catTypeName": "Unit",
            "description": "Unit"
        }
    ]
}
```

7. Add category type

Key|Desc
--|:--
Url|/baseKey/catType/add
Old url|
Method|POST

request example:
```
{
	"catTypeName":"Test Cate Type 1",
	"description":"Test Cate Type Desc 1"
}
```

8. Check category type name

Key|Desc
--|:--
Url|/baseKey/catType/checkName
Old url|
Method|POST

Request Example:
```
{
	"catTypeName":"Test Cate Type 11"
}
```

Response Example:
```
{
    "statusCode": "OK",
    "data": true
}
```


9. add category

Key|Desc
--|:--
Url|/baseKey/catType/{catTypeId}/category/add
Old url|
Method|POST

Request Example:
```
{
    "catName": "Test Types3",
    "descritpion": "Test Types3",
    "groupTypeId": 101
}
```

10. update category

Key|Desc
--|:--
Url|/baseKey/catType/category/{catId}/update
Old url|
Method|POST

Request Example:
```
{
    "catName": "Test Types3",
    "descritpion": "Test Types3"
}
```

11. delete category

Key|Desc
--|:--
Url|/baseKey/catType/category/{catId}/delete
Old url|
Method|POST


12. add category code

Key|Desc
--|:--
Url|/baseKey/category/{catId}/code/add
Old url|
Method|POST

request example:
```
{
  "code":"test code 4",
  "value": "test value",
  "codeDescription":"test desc 4",
  "groupCodeId":201
}
```

13. delete category code

Key|Desc
--|:--
Url|/baseKey/category/code/{codeId}/delete
Old url|
Method|POST

14. update category code

Key|Desc
--|:--
Url|/baseKey/category/code/{codeId}/update
Old url|
Method|POST

Request example:
```
{
  "code":"test code 3",
  "codeDescription":"test desc 3..."
}
```

15. move up category code

Key|Desc
--|:--
Url|/baseKey/category/code/{codeId}/up
Old url|
Method|POST


16. move down category code

Key|Desc
--|:--
Url|/baseKey/category/code/{codeId}/down
Old url|
Method|POST

17. list all categories

Key|Desc
--|:--
Url|/baseKey/catType/categories
Old url|
Method|GET

18. list all codes for given catId

Key|Desc
--|:--
Url|/baseKey/category/{catId}/codes
Old url|
Method|GET


