# WeCMDB Data Model

There are 5 layers in WeCMDB data model: application architechure layer, application implement layer, instance layer, infrastructure implement layer, and Infrastructure architecture layer.

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

## Application implement layer

Application implement layer is composed of 5 CIs, listed as below table,

| Name       | Description                                                                                           | Layer                       |
| ---------- | ----------------------------------------------------------------------------------------------------- | --------------------------- |
| SUB_SYSTEM | Complete deployment implementation for the specific environment of SUBSYSTEM.                         | Application implement layer |
| PACKAGE    | Version management of deployment packages.                                                            | Application implement layer |
| UNIT       | Complete deployment implementation for the specific environment of UNIT, must belog to one SUB_SYSTEM | Application implement layer |
| SERVICE    | Complete deployment implementation for the specific environment of SERVICE, must belong to one UNIT   | Application implement layer |
| INVOKE     | Describe invokation relationship between UNIT and SERVICE.                                            | Application implement layer |

## Instance layer

Instance layer is composed of 5 CIs, listed as below table,

| Name             | Description                                                                                                               | Layer          |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------- | -------------- |
| NET_CARD         | Elastic network card                                                                                                      | Instance layer |
| IP_ADDR          | IP address                                                                                                                | Instance layer |
| RUNNING_INSTANCE | One group of processes running on HOST. Must belong to UNIT.                                                              | Instance layer |
| HOST             | Running host (not hardware server), must belong to one SET_NODE.                                                          | Instance layer |
| STORAGE          | Block storage, must belong to one HOST. Shared storeage (object storage, file storeage) use UNIT_DEPLOY to do management. | Instance layer |

## Infrastructure implement layer

Infrastructure implement layer is composed of 5 CIs, listed as below table,

| Name      | Description          | Layer                          |
| --------- | -------------------- | ------------------------------ |
| IDC       | Internet Data Center | Infrastructure implement layer |
| ZONE_LINK | Security zone link   | Infrastructure implement layer |
| ZONE      | Security zone        | Infrastructure implement layer |
| DCN       | Data center node     | Infrastructure implement layer |
| SET       | Resource set         | Infrastructure implement layer |

## Infrastructure architecture layer

Infrastructure architecture layer is composed of 5 CIs, listed as below table,

| Name             | Description                   | Layer                             |
| ---------------- | ----------------------------- | --------------------------------- |
| IDC_DESIGN       | IDC design planning           | Infrastructure architecture layer |
| ZONE_LINK_DESIGN | Security zone link design     | Infrastructure architecture layer |
| ZONE_DESIGN      | Security zone design planning | Infrastructure architecture layer |
| DCN_DESIGN       | DCN design planning           | Infrastructure architecture layer |
| SET_DESIGN       | Resource set design planning  | Infrastructure architecture layer |

## Appendix

Please follow below link for more information about CI models and their attributes configuration,
[CI Model](wecmdb_model_list.xlsx)
