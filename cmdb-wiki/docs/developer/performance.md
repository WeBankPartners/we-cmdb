# CMDB 性能测试

数据库: 腾讯云 TDSQL (2G 内存)

CMDB 运行环境: CPU (2 核 2.5G) 内存 (4G)

## 单一 CI 数据查询

测试 API url: /cmdb/api/v2/ci/14/retrieve

|数据量|响应时间(秒)|
|-----|--------|
|1k|0.15|
|5k|0.6|
|1w|1.1|
|5w|6|

## 综合查询

测试 API url: /cmdb/api/v2/intQuery/adhoc/execute

测试数据 (CI 记录数)

|数据量|system_design|subsys_design|subsys|unit|running_instance|host|ip_addr|
| ----- | --------- | ----------- | ---- | --- | ------------- | ---|-------|
|1k|10|50|250|250|1000|1000|1000|
|5k|100|500|500|5000|5000|5000|5000|
|1w|100|1000|1000|10000|10000|10000|10000|
|5w|10|100|1000|3000|50000|50000|50000|

| 数据量 | 查询条件                                                                     | 响应时间 (秒) |
| ------ | ---------------------------------------------------------------------------- | ------------- |
| 1k     | system_design-subsys_design                                                  | 0.04          |
|        | system_design - subsys_design - subsys                                       | 0.05          |
|        | system_design - subsys_design - subsys - unit                                | 0.1           |
|        | system_design - subsys_design - subsys - unit - running_instance             | 0.11          |
|        | system_design - subsys_design - subsys - unit - running_instance - host      | 0.14          |
|        | system_design - subsys_design - subsys - unit - running_instance - host - ip | 0.15          |
| 5k     | system_design-subsys_design                                                  | 0.05          |
|        | system_design - subsys_design - subsys                                       | 0.07          |
|        | system_design - subsys_design - subsys - unit                                | 0.2           |
|        | system_design - subsys_design - subsys - unit - running_instance             | 0.3           |
|        | system_design - subsys_design - subsys - unit - running_instance - host      | 0.3           |
|        | system_design - subsys_design - subsys - unit - running_instance - host - ip | 0.4           |
| 1w     | system_design-subsys_design                                                  | 0.05          |
|        | system_design - subsys_design - subsys                                       | 0.1           |
|        | system_design - subsys_design - subsys - unit                                | 0.4           |
|        | system_design - subsys_design - subsys - unit - running_instance             | 0.8           |
|        | system_design - subsys_design - subsys - unit - running_instance - host      | 0.8           |
|        | system_design - subsys_design - subsys - unit - running_instance - host - ip | 0.9           |
| 5w     | system_design-subsys_design                                                  | 0.05          |
|        | system_design - subsys_design - subsys                                       | 0.1           |
|        | system_design - subsys_design - subsys - unit                                | 0.6           |
|        | system_design - subsys_design - subsys - unit - running_instance             | 4.6           |
|        | system_design - subsys_design - subsys - unit - running_instance - host      | 4.7           |
|        | system_design - subsys_design - subsys - unit - running_instance - host - ip | 5.2           |
