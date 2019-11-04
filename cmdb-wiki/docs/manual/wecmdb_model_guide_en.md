# WeCMDB Data Model

There are 5 layers in WeCMDB data model: application architechure layer, application deployment layer, resource running layer, resource planning layer, and planning design layer.

## Application architecture layer

Application architecture layer is composed of 6 CIs, listed in below table,

| CI name           | Description                                                                                                                                       | Layer                          |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| SYSTEM_DESIGN     | Can be used to create multi-tiered, hierarchical relationships.                                                                                   | Application architecture layer |
| SUB_SYSTEM_DESIGN | Minimized monolithic deployment unit, can provide complete business service. Must belong to a SYSTEM_DESIGN.                                      | Application architecture layer |
| UNIT_DESIGN       | Minimized deployment unit, can provide deployment service.                                                                                        | Application architecture layer |
| SERVICE_DESIGN    | Extend ability of UNIT_DESIGN, and can not exist independently. Must belong to one UNIT. Can be classified to 2 categories: caller and be called. | Application architecture layer |
| INVOKE_DESIGN     | Describe invocation relationship between unit and service                                                                                         | Application architecture layer |
| SEQUENCE_DESIGN   | Describe application complemete business invokation sequence.                                                                                     | Application architecture layer |

## Application deployment layer

Application deployment layer is composed of 5 CIs, listed as below table:

| Name       | Description                                                                                           | Layer                        |
| ---------- | ----------------------------------------------------------------------------------------------------- | ---------------------------- |
| SUB_SYSTEM | Complete deployment implementation for the specific environment of SUBSYSTEM.                         | Application deployment layer |
| PACKAGE    | Version management of deployment packages.                                                            | Application deployment layer |
| UNIT       | Complete deployment implementation for the specific environment of UNIT, must belog to one SUB_SYSTEM | Application deployment layer |
| SERVICE    | Complete deployment implementation for the specific environment of SERVICE, must belong to one UNIT   | Application deployment layer |
| INVOKE     | Describe invokation relationship between UNIT and SERVICE.                                            | Application deployment layer |

## Resource running layer

Resource running layer is composed of 5 CIs, listed as below table,

| Name             | Description                                                                                                               | Layer                  |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| NET_CARD         | Elastic network card                                                                                                      | Resource running layer |
| IP_ADDR          | IP address                                                                                                                | Resource running layer |
| RUNNING_INSTANCE | One group of processes running on HOST. Must belong to UNIT.                                                              | Resource running layer |
| HOST             | Running host (not hardware server), must belong to one SET_NODE.                                                          | Resource running layer |
| STORAGE          | Block storage, must belong to one HOST. Shared storeage (object storage, file storeage) use UNIT_DEPLOY to do management. | Resource running layer |

## Resource planning layer

Resource planning layer is composed of 5 CIs, listed as below table,

| Name      | Description          | Layer                   |
| --------- | -------------------- | ----------------------- |
| IDC       | Internet Data Center | Resource planning layer |
| ZONE_LINK | Safe zone link       | Resource planning layer |
| ZONE      | Safe zone            | Resource planning layer |
| DCN       | Data center node     | Resource planning layer |
| SET       | Resource set         | Resource planning layer |

Planning design layer is composed of 5 CIs, listed as below table,

| Name             | Description                  | Layer                 |
| ---------------- | ---------------------------- | --------------------- |
| IDC_DESIGN       | IDC design planning          | Planning design layer |
| ZONE_LINK_DESIGN | Safe zone link design        | Planning design layer |
| ZONE_DESIGN      | Safe zone design planning    | Planning design layer |
| DCN_DESIGN       | DCN design planning          | Planning design layer |
| SET_DESIGN       | Resource set design planning | Planning design layer |

## Appendix

Please follow below link for more information about CI models and their attributes configuration,
[CI Model](wecmdb_model_list.xlsx)
