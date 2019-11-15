## WeCMDB Glossary

### System Glossary

#### CMDB (Configuration Management DataBase)
A database that stores information about your IT configuration, including both CIs and their relationships.

#### CIT (Configuration Item Type)
A model that is designed for user to enter information about configuration items such as hosts, apps, etc. into the database.

#### CITA (Configuration Item Type Attribute)
An attribute of a CIT, which present a characteristic of a configuration item type, it equates to a column on a database table or an attribute on an object in real world.

#### CI (Configuration Item)
A physical, logical, or conceptual entity that is part of your IT environment and has configurable attributes. Examples include IDC (Internet Data Center), DCN(Data Center Note), hosts, etc. hardware, but also include computer systems, services, etc software and the relationships between each other.

#### CITRT (Configuraiton Item Type Relation Type)
A type of relationship between CITs, such as a reference from one CIT 'host' to another CIT 'IP', it present as a host has an attribute 'intranet ip' which reference to 'IP', two relation types we have in WeCMDB - 'ref' and 'multiRef'

#### IDT (Input Data Type)
A data type that is used to allow user enter the valid data required by the system, such as 'text', 'number','date', etc.

#### Integrated Query
A query is integrated multiple CIT together for querying the data cross different CIT, such as an user want to find out all the instances running on a given host, a integrated query can be created cross CIA 'host' and 'running_instance', then given the IP address of the host to query out all the instances on it.

#### ENUM Type
A type of an ENUM catagory, there are 3 kinds of ENUM types:  
System ENUM Type: it is predefined system level ENUM type, which setup with the system together, it cannot be customized adding,modifying or deleting.

Common ENUM Type: it can be customized adding/modifying after the system started, but cannot be deleted as it is common which can be used for other CI

Private ENUM Type: it is created during the CI is created, which is used for this CI only, that is so call private, it can be customized adding, modifying or deleting anytime as needs.

#### ENUM Catagory
A catagory of a set of ENUM key/value, which is used for classification purpose. e.g. ci_state_design, it is a catagory of state machine of design.

#### ENUM key/value
A key/value pair which is used for presenting a static data. e.g. created/Created, it is a state key/value of catagory - ci_state_design.

### Best Practice Model Glossary
TO DO ...
