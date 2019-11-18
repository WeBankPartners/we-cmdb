# WeCMDB User Guide

# Function menu

- [Main menu introduction](#menu_introduction)
- [System](#system)
  - [CMDB model management](#cmdb_model_management)
  - [System permission management](#permission_management)
  - [Log enquiry](#log_enquiry)
  - [Basic data management](#base_data_management)
- [Data management](#data_management)
  - [CI data management](#ci_data_management)
  - [CI integrated enquiry management](#ci_integrated_enquiry_management)
  - [Enum management](#enum_management)
- [Data enquiry](#data_enquiry)
  - [CI data enquiry](#ci_data_enquiry)
  - [CI data integrated enquiry](#ci_integrated_enquiry)
  - [Enum data enquiry](#enum_management)
- [View management](#view_management)

  - [IDC planning design](#idc_planning_design)
  - [IDC resource planning](#idc_resource_planning)
  - [Application architecture design](#app_arch_design)
  - [Application deployment design](#app_deploy_design)

## <span id="menu_introduction"></span>Main menu introduction

![Main page](images/cmdb_main.png)
Function of WeCMDB can fall into four categories: system, data management, data enquiry, view enquiry. Below list the functionality of each menu in detail.

## <span id="system"></span>System

System management is composed of CMDB data model management, log enquery, basic data management and System permission management.

### <span id="cmdb_model_management"></span>CMDB model management

CMDB data model management page illustrate the relationships between CIs, and provide functionality to add ,edit and remove each CI or its attributes.

[Click here](wecmdb_model_guide.md) to learn CMDB data model in detail.

1. Click the plus sign at top left corner, a new layer can be added.
   ![Add new layer](images/cmdb_model_layer_add.png)
1. CIs can be filtered and be displayed in the data model diagram according to the selected status in the top status drop-down list box.
1. ![Status drop-down list box](images/cmdb_model_status_select.png)
1. Click any layer node, all CIs of the clicked layer will be displayed. You also can add/edit/remove CIs, edit name of layer, move up/down or remove layers.
1. Click
   ![Click layer node](images/cmdb_model_layer_edit.png)
1. Click any CI node, all attributes of the clicked CI will be displayed on the right side, you also can add/edit/remove CI attributes, edit the name of CI, move up/down the CI attributse.
   ![Click CI node](images/cmdb_model_ci_edit.png)
1. By hovering the mouse over a CI node, all relationship of the CI will be highlighted. Rolling the mouse wheel up can zoom in the diagram, instead, rolling wheel down can zoom out the diagram.

   ![Highlight CI's relationships](images/cmdb_model_high_light.png)

### <span id="permission_management"></span>System permission management

System permission management show the relationships among user,role, menu permission and data permission.
![Permission management main page](images/permission_main.png)

1. User management

- Clicking _user name_(e.g. admin) can show all roles the user belongs to, and display the menus and data permissions which those roles have.
  ![User permission](images/permission_role_user.png)
- Clicking the _Add user_ button which is above user list can add new user.
  ![Add role](images/permission_role_user_add.png)

2. Role management

- Clicking a _role name_(e.g. super admin) can display all users belong to the role, and show all menus and data permissions which the role have.
  ![Role permission](images/permission_role.png)
- Clicking _add role_ button above role list can add new role.
  ![Add role](images/permission_role_add.png)
- Clicking _user_ button following role name can add or remove users for the role.
  ![Edit users belong to the role](images/permission_role_user_mgmt.png)

3. Menu permission and data permission management

- Clicking _role name_ (e.g. super admin) can display all menus and data permission belong to the role, clicking check boxes can add/remove according menu/data permission.
  ![Menu and data permission](images/permission_data_access.png)

### <span id="log_enquiry"></span>Log enquiry

1. Log enquiry provide function of audit and trace, also it can be used to search any operation log of the system, supported search conditions: username, time, function, CI, content, result, etc.

   ![Log enquiry](images/log_search.png)

### <span id="base_data_management"></span>Basic data management

1. Basic data management page provide CRUD functionality for system enum data.
   ![Basic data management](images/base_data_management.png)
   ![Basic data management](images/base_data_management_add.png)
   ![Basic data management](images/base_data_management_edit.png)

## <span id="data_management"></span>Data management

Data management is composed of CI data management, CI integrated enquiry management, enum data management

### <span id="ci_data_management"></span>CI data management

1. After open CI data management page, CMDB data model diagram is displayed, the diagram just displays CIs which status are created and dirty. By hovering the mouse over a CI node, all relationship of the CI will be highlighted.

   ![CI data management page - model diagram](images/ci_data_management_graph.png)

1. After click a CI and the data management page is opened, [Basic data management](#base_data_management) page can be referenced to operate.
   ![CI data management page - table](images/ci_data_management_table.png)

### <span id="ci_integrated_enquiry_management"></span>CI Integrated enquiry management

1. After select a integrated enquiry, all CIs belong to the selected integrated enquiry and their relationships will be displayed.
   ![CI integrated inquiry management](images/ci_integrated_query_management.png)
1. After click a CI node in the diagram, 3 tabs (_Attribute_, _Reference_,_Being referenced_ ) will be displayed. The attributes which has been checked will be displayed at the bottom of the page, the referencing and being referenced CI will be displayed as node in the diagram.
   ![CI integrated inquiry management dialog](images/ci_integrated_query_management_dialog.png)

### <span id="enum_management"></span>Enum data management

1. Enum data management page provide CRUD functionality for public and private enum, [Basic data management](#base_data_management) page can be referenced for operation.
   ![Enum data management](images/enum_management.png)

## <span id="data_enquiry"></span>Data enquiry

Data enquiry is composed of CI data enquiry, CI data integrated enquiry, enum data enquiry

### <span id="ci_data_enquiry"></span>CI data enquiry

1. After open CI data enquiry page, CMDB data model diagram is displayed, the diagram just displays CIs which status are created and dirty. By hovering the mouse over a CI node, all relationship of the CI will be highlighted.
   ![CI data enquiry page-data model diagram](images/ci_data_enquiry_graph.png)
1. Click CI and open data enquiry page, CI data can be queried.
   ![CI data enquiry page-data model diagram](images/ci_data_enquiry_table.png)

### <span id="ci_integrated_enquiry"></span>CI data integrated enquiry

1. Select root CI, and select integrated enquiry name to process integrated enquiry.
   ![CI data integrated enquiry](images/ci_integrated_query.png)
1. Clicking _Display message_ can display the _url_,_payload_, and _result_.
   ![CI data integrated enquiry-message](images/ci_integrated_query_message.png)
1. Clicking _raw data_ behide a message can display detail information of the message.
   ![CI data integrated enquiry-raw data](images/ci_integrated_query_data.png)

### <span id="enum_enquiry"></span>Enum data enquiry

1. Enum data enquiry page provide query functionality for public and private enum data.
   ![Enum data enquiry](images/enum_enquiry.png)

## <span id="view_management"></span>View management

### <span id="idc_planning_design"></span>IDC planning design

1. Select IDC, display the IDC planning design diagram, scrolling mouse wheel can zoom in or zoom out the design diagram.
   ![IDC planning design diagram](images/idc_planning_design_diagram.png)

1. Select any other tab beside "IDC planning design diagram" tab, next planning design item can be processed for the selected IDC.
   ![IDC planning design items](images/idc_planning_design_items.png)

### <span id="idc_resource_planning"></span>IDC resource planning

1. Select IDC, display the IDC's resource planning diagram, scrolling mouse wheel can zoom in or zoom out the planning diagram.
   ![IDC resource planning diagram](images/idc_resource_planning_diagram.png)

1. Select any other tab beside "IDC resource planning diagram" tab, plan can be made for the selected resource of the IDC.
   ![IDC resource planning items](images/idc_resource_planning_items.png)

### <span id="app_arch_design"></span>App architecture design

1. Select system design, display the application architecture diagram of the system, scrolling mouse wheel can zoom in or zoom out diagram.
   ![App architecture design diagram](images/app_arch_design_diagram.png)
1. Select the "Invocation sequence design" on the right side of diagram, click Ok, list the sequence invocation steps, press left or right arrow, the according invocation of applications will be display.
   ![App architecture design sequence](images/app_arch_design_invoke_seq.png)
1. Select "Physical deployment diagram" tab beside "App architecture design diagram", the according physical deployment information can be explored
   ![Physical deployment diagram](images/app_phisical_deploy_diagram.png)

1. Select any tab on the right side of "physical deployment diagram", the according configure item can be processed (e.g. Invocation sequence design)
   ![Invocation sequence design](images/invoke_seq_design.png)

### <span id="app_deploy_design"></span>Application deployment design

1. Select system design, the according app deployment diagram will be displayed, scrolling mouse wheel can zoom in or zoom out the diagram.
   ![App deployment design diagram](images/app_deploy_design_diagram.png)

1. Select "App deployment design tree diagram" tab beside "App deploy design diagram", the app deployment design tree diagram will be displayed, scrolling mouse wheel can zoom in or zoom out the diagram.
   ![App deployment design tree diagram](images/app_deploy_design_tree.png)

1. Select "Physical deployment diagram" table beside "App deployment design tree diagram", the app deployment diagram can be displayed, scrolling mouse wheel can zoom in or zoom out the diagram.
   ![Physical deployment diagram](images/app_deploy_design_physical.png)

1. Select any table beside "Physical deployment diagram", the according configure item can be processed.
   ![App deployment design items](images/app_deploy_design_items.png)
