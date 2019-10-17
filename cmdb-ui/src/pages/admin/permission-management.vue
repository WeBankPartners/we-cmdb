<template>
  <Row>
    <Col span="4">
      <Card>
        <p slot="title">
          {{ $t("user") }}
          <Button
            icon="ios-add"
            type="dashed"
            size="small"
            @click="openAddUserModal"
            >{{ $t("add_user") }}</Button
          >
        </p>
        <Tag
          v-for="item in users"
          :key="item.id"
          :name="item.username"
          :color="item.color"
          :checked="item.checked"
          checkable
          :fade="false"
          @on-change="handleUserClick"
        >
          <span :title="` ${item.username} ( ${item.description} ) `">{{
            ` ${item.username} ( ${item.description} ) `
          }}</span>
        </Tag>
      </Card>
    </Col>
    <Col span="5" offset="0" style="margin-left: 20px">
      <Card>
        <p slot="title">
          {{ $t("role") }}
          <Button
            icon="ios-add"
            type="dashed"
            size="small"
            @click="openAddRoleModal"
            >{{ $t("add_role") }}</Button
          >
        </p>
        <div class="role-item" v-for="item in roles" :key="item.id">
          <Tag
            :name="item.id"
            :color="item.color"
            :checked="item.checked"
            checkable
            :fade="false"
            @on-change="handleRoleClick"
          >
            <span :title="item.description">{{ item.description }}</span>
          </Tag>
          <Button
            icon="ios-build"
            type="dashed"
            size="small"
            @click="openUserManageModal(item.id)"
            >{{ $t("user") }}</Button
          >
        </div>
      </Card>
    </Col>
    <Col span="4" offset="0" style="margin-left: 20px">
      <Card>
        <p slot="title">{{ $t("menus_management") }}</p>
        <Tree
          :data="menus"
          show-checkbox
          @on-check-change="handleMenuTreeCheck"
        ></Tree>
      </Card>
    </Col>
    <Col span="9" offset="0" style="margin-left: 20px">
      <Card>
        <p slot="title">{{ $t("data_management") }}</p>
        <div
          class="data-permissions"
          v-for="ci in ciTypePermissions"
          :key="ci.ciTypeId"
        >
          <span
            class="ciTypes"
            :title="ci.ciTypeName"
            style="max-width: 100px;white-space: nowrap; overflow: hidden; text-overflow: ellipsis"
            >{{ ci.ciTypeName }}</span
          >
          <div class="ciTypes-options">
            <Checkbox
              v-for="act in actionsType"
              :disabled="dataPermissionDisabled"
              :indeterminate="ci[act.actionCode] === 'P'"
              :value="ci[act.actionCode] === 'Y'"
              :key="act.actionCode"
              @click.prevent.native="
                ciTypesPermissionsHandler(ci, act.actionCode, act.type)
              "
              >{{ act.actionName }}</Checkbox
            >
          </div>
        </div>
      </Card>
    </Col>
    <Modal
      v-model="addRoleModalVisible"
      :title="$t('add_role')"
      @on-ok="addRole"
      @on-cancel="cancel"
    >
      <Input
        v-model="addedRoleValue"
        :placeholder="$t('username_input_placeholder')"
      />
    </Modal>
    <Modal
      v-model="addUserModalVisible"
      :title="$t('add_user')"
      @on-ok="addUser"
      @on-cancel="cancel"
    >
      <Form
        class="validation-form"
        ref="addedUserForm"
        :model="addedUser"
        label-position="left"
        :label-width="100"
      >
        <FormItem :label="$t('username')" prop="username">
          <Input v-model="addedUser.username" />
        </FormItem>
        <FormItem :label="$t('fullname')" prop="fullName">
          <Input v-model="addedUser.fullName" />
        </FormItem>
        <FormItem :label="$t('description')" prop="description">
          <Input v-model="addedUser.description" />
        </FormItem>
      </Form>
    </Modal>
    <Modal
      v-model="userManageModal"
      width="700"
      :title="$t('edit_user')"
      @on-ok="confirmUser"
      @on-cancel="confirmUser"
    >
      <Transfer
        :titles="transferTitles"
        :list-style="transferStyle"
        :data="allUsersForTransfer"
        :target-keys="usersKeyBySelectedRole"
        :render-format="renderUserNameForTransfer"
        @on-change="handleUserTransferChange"
        filterable
      ></Transfer>
    </Modal>
    <Modal
      v-model="permissionManageModal"
      :title="$t('edit_data_authority')"
      @on-ok="cancelEdit"
      @on-cancel="cancelEdit"
      width="80"
    >
      <WeTable
        :tableData="ciTypeAttrsPermissions"
        :filtersHidden="true"
        :tableOuterActions="outerActions"
        :tableInnerActions="innerActions"
        :tableColumns="attrsPermissionsColumns"
        :ascOptions="permissionsTableOptions"
        :showCheckbox="true"
        @actionFun="actionFun"
        @getSelectedRows="onSelectedRowsChange"
        tableHeight="650"
        ref="table"
      ></WeTable>
    </Modal>
  </Row>
</template>
<script>
import {
  outerActions,
  innerActions,
  pagination,
  components
} from "@/const/actions.js";
import {
  getAllUsers,
  getAllRoles,
  getAllMenus,
  getAllPermissionEntryPoints,
  getRolesByUser,
  getUsersByRole,
  addRole,
  addUser,
  getPermissionsByRole,
  addUsersToRole,
  romoveUsersFromRole,
  getPermissionsByUser,
  addMenusToRole,
  removeMenusFromRole,
  addDataPermissionAction,
  removeDataPermissionAction,
  getRoleCiTypeCtrlAttributesByRoleCiTypeId,
  getEnumCodesByCategoryId,
  createRoleCiTypeCtrlAttributes,
  updateRoleCiTypeCtrlAttributes,
  deleteRoleCiTypeCtrlAttributes
} from "@/api/server.js";

import { MENUS } from "@/const/menus.js";
import { formatDataPermissionTree } from "../util/admin.js";
import { setTimeout } from "timers";
export default {
  data() {
    return {
      actionsType: [
        {
          actionCode: "creationPermission",
          type: "CREATION",
          actionName: this.$t("permission_management_data_creation")
        },
        {
          actionCode: "removalPermission",
          type: "REMOVAL",
          actionName: this.$t("permission_management_data_removal")
        },
        {
          actionCode: "modificationPermission",
          type: "MODIFICATION",
          actionName: this.$t("permission_management_data_modification")
        },
        {
          actionCode: "enquiryPermission",
          type: "ENQUIRY",
          actionName: this.$t("permission_management_data_enquiry")
        },
        {
          actionCode: "executionPermission",
          type: "EXECUTION",
          actionName: this.$t("permission_management_data_execution")
        }
      ],
      users: [],
      roles: [],
      menus: [],
      dataPermissionDisabled: false,
      menusForEdit: [],
      permissionEntryPoints: [],
      permissionEntryPointsForEdit: [],
      permissionEntryPointsBackup: [],
      addRoleModalVisible: false,
      addUserModalVisible: false,
      addedRoleValue: "",
      userManageModal: false,
      permissionManageModal: false,
      usersKeyBySelectedRole: [],
      allUsersForTransfer: [],
      selectedRole: 0,
      transferTitles: [
        this.$t("permission_management_unselected_user"),
        this.$t("permission_management_selected_user")
      ],
      currentRoleId: 0,
      ciTypePermissions: [],
      allMenusOriginResponse: [],
      transferStyle: { width: "300px" },
      currentRoleCiTypeId: "",
      //for WeTable
      outerActions,
      innerActions,
      ciTypeAttrsPermissions: [],
      ciTypeAttrsPermissionsBackUp: [],
      attrsPermissionsColumns: [],
      permissionsTableOptions: {},
      defaultColumns: [
        {
          title: this.$t("query"),
          key: "enquiryPermission",
          inputKey: "enquiryPermission",
          displaySeqNo: 1,
          placeholder: this.$t("select_placeholder"),
          component: "WeSelect",
          options: [
            {
              label: this.$t("yes"),
              value: "Y"
            },
            {
              label: this.$t("no"),
              value: "N"
            }
          ]
        },
        {
          title: this.$t("new"),
          key: "creationPermission",
          inputKey: "creationPermission",
          displaySeqNo: 2,
          placeholder: this.$t("select_placeholder"),
          component: "WeSelect",
          options: [
            {
              label: this.$t("yes"),
              value: "Y"
            },
            {
              label: this.$t("no"),
              value: "N"
            }
          ]
        },
        {
          title: this.$t("modify"),
          key: "modificationPermission",
          inputKey: "modificationPermission",
          displaySeqNo: 3,
          placeholder: this.$t("select_placeholder"),
          component: "WeSelect",
          options: [
            {
              label: this.$t("yes"),
              value: "Y"
            },
            {
              label: this.$t("no"),
              value: "N"
            }
          ]
        },
        {
          title: this.$t("execute"),
          key: "executionPermission",
          inputKey: "executionPermission",
          displaySeqNo: 4,
          placeholder: this.$t("select_placeholder"),
          component: "WeSelect",
          options: [
            {
              label: this.$t("yes"),
              value: "Y"
            },
            {
              label: this.$t("no"),
              value: "N"
            }
          ]
        },
        {
          title: this.$t("delete"),
          key: "removalPermission",
          inputKey: "removalPermission",
          displaySeqNo: 5,
          placeholder: this.$t("select_placeholder"),
          component: "WeSelect",
          options: [
            {
              label: this.$t("yes"),
              value: "Y"
            },
            {
              label: this.$t("no"),
              value: "N"
            }
          ]
        }
      ],
      seletedRows: [],
      addedUser: {}
    };
  },
  methods: {
    renderUserNameForTransfer(item) {
      return item.label;
    },
    openPermissionManageModal(roleCiTypeId) {
      this.currentRoleCiTypeId = roleCiTypeId;
      this.permissionManageModal = true;
      this.getAttrPermissions();
    },
    async getAttrPermissions() {
      let {
        status,
        data,
        message
      } = await getRoleCiTypeCtrlAttributesByRoleCiTypeId(
        this.currentRoleCiTypeId
      );
      if (status === "OK") {
        this.ciTypeAttrsPermissionsBackUp = data.body;
        this.ciTypeAttrsPermissions = data.body.map(_ => {
          let obj = {};
          for (let i in _) {
            const found = data.header.find(p => p.propertyName === i);
            const isRef = found && found.inputType === "ref";
            if (typeof _[i] === "object" && _[i] !== null) {
              obj[i] = {
                codeId:
                  _[i].conditionValue && isRef
                    ? _[i].conditionValue
                    : _[i].conditionValue.split(",").map(n => n * 1),
                value:
                  (_[i].conditionValueObject &&
                    _[i].conditionValueObject
                      .map(s => (isRef ? s.data.key_name : s.value))
                      .toString()
                      .replace(",", ";")) ||
                  []
              };
            } else {
              obj[i] = {
                codeId: _[i],
                value: _[i] === "Y" ? this.$t("yes") : this.$t("no")
              };
            }
          }
          return obj;
        });
        this.attrsPermissionsColumns = data.header
          .map((h, index) => {
            return {
              ...h,
              title: h.name,
              key: h.propertyName,
              inputKey: h.propertyName,
              displaySeqNo: index + 6,
              inputType: h.inputType,
              referenceId: h.referenceId,
              placeholder: h.name,
              ciType: { id: h.referenceId, name: h.name },
              type: "text",
              ...components[h.inputType],
              isMultiple: h.inputType === "select"
            };
          })
          .concat(this.defaultColumns);
        this.attrsPermissionsColumns.forEach(async i => {
          if (i.inputType === "select") {
            const enumOptions = await getEnumCodesByCategoryId(
              0,
              i.referenceId
            );
            let opts = [];
            if (enumOptions.status === "OK") {
              opts = enumOptions.data.map(_ => {
                return {
                  value: _.codeId,
                  label: _.value
                };
              });
              this.$set(i, "options", opts);
            }
          }
        });
      }
    },

    async exportHandler() {
      const data = this.ciTypeAttrsPermissions.map(_ => {
        for (let i in _) {
          _[i] = _[i].value;
        }
        return _;
      });
      this.$refs.table.export({
        filename: "Permission Data",
        data: data
      });
    },
    actionFun(type, data) {
      switch (type) {
        case "export":
          this.exportHandler();
          break;
        case "add":
          this.addHandler();
          break;
        case "edit":
          this.editHandler();
          break;
        case "save":
          this.saveHandler(data);
          break;
        case "delete":
          this.deleteHandler(data);
          break;
        case "cancel":
          this.cancelHandler();
          break;
        case "innerCancel":
          this.$refs.table.rowCancelHandler(data.weTableRowId);
          break;
        default:
          break;
      }
    },
    async saveHandler(data) {
      let setBtnsStatus = () => {
        this.outerActions.forEach(_ => {
          _.props.disabled = !(
            _.actionType === "add" || _.actionType === "export"
          );
        });
        this.$refs.table.setAllRowsUneditable();
        this.$nextTick(() => {
          /* to get iview original data to set _ischecked flag */
          let objData = this.$refs.table.$refs.table.$refs.tbody.objData;
          for (let obj in objData) {
            objData[obj]._isChecked = false;
            objData[obj]._isDisabled = false;
          }
        });
      };
      let d = JSON.parse(JSON.stringify(data));
      let addAry = d.filter(_ => _.isNewAddedRow);
      let editAry = d.filter(_ => !_.isNewAddedRow);
      const defaultKey = [
        "creationPermission",
        "enquiryPermission",
        "executionPermission",
        "grantPermission",
        "modificationPermission",
        "removalPermission",
        "roleCiTypeId",
        "roleCiTypeCtrlAttrId",
        "callbackId"
      ];
      if (addAry.length > 0) {
        addAry.forEach(_ => {
          _.callbackId = _["weTableRowId"];
          delete _.isNewAddedRow;
          delete _.isRowEditable;
          delete _.weTableForm;
          delete _.weTableRowId;
          for (let i in _) {
            const found = defaultKey.find(k => k === i);
            if (!found) {
              _[i] = { conditionValue: _[i].toString() };
            }
          }
        });
        const { status, message, data } = await createRoleCiTypeCtrlAttributes(
          this.currentRoleCiTypeId,
          addAry
        );
        if (status === "OK") {
          this.$Notice.success({
            title: this.$t("add_permission_success"),
            desc: message
          });

          this.getAttrPermissions();
          this.getPermissions(false, true, this.currentRoleId);
          setBtnsStatus();
        }
      }
      if (editAry.length > 0) {
        editAry.forEach(_ => {
          _.callbackId = _["weTableRowId"];
          delete _.isNewAddedRow;
          delete _.isRowEditable;
          delete _.weTableForm;
          delete _.weTableRowId;
          const foundRow = this.ciTypeAttrsPermissionsBackUp.find(
            p => p.roleCiTypeCtrlAttrId === _.roleCiTypeCtrlAttrId
          );
          for (let i in _) {
            const found = defaultKey.find(k => k === i);
            if (!found) {
              _[i] = {
                conditionValue: _[i].toString(),
                conditionId: foundRow[i].conditionId
              };
            }
          }
        });
        const { status, message, data } = await updateRoleCiTypeCtrlAttributes(
          this.currentRoleCiTypeId,
          editAry
        );
        if (status === "OK") {
          this.$Notice.success({
            title: this.$t("update_permission_success"),
            desc: message
          });
          this.getAttrPermissions();
          this.getPermissions(false, true, this.currentRoleId);
        }
      }
    },
    deleteHandler(deleteData) {
      this.$Modal.confirm({
        title: this.$t("delete_confirm"),
        "z-index": 1000000,
        onOk: async () => {
          const payload = deleteData.map(_ => _.roleCiTypeCtrlAttrId);
          const {
            status,
            message,
            data
          } = await deleteRoleCiTypeCtrlAttributes(
            this.currentRoleCiTypeId,
            payload
          );
          if (status === "OK") {
            this.$Notice.success({
              title: this.$t("delete_permission_success"),
              desc: message
            });
            this.outerActions.forEach(_ => {
              _.props.disabled =
                _.actionType === "save" ||
                _.actionType === "edit" ||
                _.actionType === "delete";
            });
            this.getAttrPermissions();
          }
        },
        onCancel: () => {}
      });
      document.querySelector(".ivu-modal-mask").click();
    },
    addHandler() {
      let emptyRowData = {};
      this.attrsPermissionsColumns.forEach(_ => {
        if (_.inputType === "multiSelect" || _.inputType === "multiRef") {
          emptyRowData[_.inputKey] = [];
        } else {
          emptyRowData[_.inputKey] = "";
        }
      });
      emptyRowData["isRowEditable"] = true;
      emptyRowData["isNewAddedRow"] = true;
      emptyRowData["weTableRowId"] = new Date().getTime();
      this.ciTypeAttrsPermissions.unshift(emptyRowData);
      this.$nextTick(() => {
        this.$refs.table.pushNewAddedRowToSelections();
        this.$refs.table.setCheckoutStatus(true);
      });
      this.outerActions.forEach(_ => {
        _.props.disabled = _.actionType === "add";
      });
    },
    editHandler() {
      this.$refs.table.swapRowEditable(true);
      this.outerActions.forEach(_ => {
        if (_.actionType === "save") {
          _.props.disabled = false;
        }
      });
      this.$nextTick(() => {
        this.$refs.table.setCheckoutStatus(true);
      });
    },
    cancelHandler() {
      this.$refs.table.setAllRowsUneditable();
      this.$refs.table.setCheckoutStatus();
      this.outerActions &&
        this.outerActions.forEach(_ => {
          _.props.disabled = !(
            _.actionType === "add" ||
            _.actionType === "export" ||
            _.actionType === "cancel"
          );
        });
    },
    onSelectedRowsChange(rows, checkoutBoxdisable) {
      if (rows.length > 0) {
        this.outerActions.forEach(_ => {
          _.props.disabled = _.actionType === "add";
        });
      } else {
        this.outerActions.forEach(_ => {
          _.props.disabled = !(
            _.actionType === "add" ||
            _.actionType === "export" ||
            _.actionType === "cancel"
          );
        });
      }
      this.seletedRows = rows;
    },
    cancelEdit() {
      this.permissionEntryPointsForEdit = [];
      this.cancelHandler();
    },
    ciTypesPermissionsHandler(ci, code, type) {
      this.setPermissionAction(!(ci[code] === "Y"), type, ci.ciTypeId);
    },
    async handleUserTransferChange(newTargetKeys, direction, moveKeys) {
      if (direction === "right") {
        let { status, data, message } = await addUsersToRole(
          moveKeys,
          this.selectedRole
        );
        if (status === "OK") {
          this.$Notice.success({
            title: "success",
            desc: message
          });
          this.usersKeyBySelectedRole = newTargetKeys;
        }
      } else {
        let { status, data, message } = await romoveUsersFromRole(
          moveKeys,
          this.selectedRole
        );
        if (status === "OK") {
          this.$Notice.success({
            title: "success",
            desc: message
          });
          this.usersKeyBySelectedRole = newTargetKeys;
        }
      }
    },
    async addRole() {
      if (this.addedRoleValue === "") {
        this.$Notice.warning({
          title: "Warning",
          desc: this.$t("username_is_required")
        });
        return;
      }
      let { status, data, message } = await addRole({
        roleName: this.addedRoleValue,
        description: this.addedRoleValue
      });
      if (status === "OK") {
        this.$Notice.success({
          title: "success",
          desc: message
        });
        this.getAllRoles();
      }
    },
    async addUser() {
      if (this.addedUser.username === "") {
        this.$Notice.warning({
          title: "Warning",
          desc: this.$t("username_is_required")
        });
        return;
      }
      let { status, data, message } = await addUser([this.addedUser]);
      if (status === "OK") {
        this.$Notice.success({
          title: "success",
          desc: message
        });
        this.$Modal.info({
          title: this.$t("copy_password"),
          content: data[0].password
        });
        this.addedUser = {};
        this.getAllUsers();
      }
    },
    async getPermissions(
      queryAfterEditing,
      checked,
      roleOrUser,
      byUser = false
    ) {
      if (checked) {
        let permissions = byUser
          ? await getPermissionsByUser(roleOrUser)
          : await getPermissionsByRole(roleOrUser);
        this.ciTypePermissions = permissions.data.ciTypePermissions;
        if (queryAfterEditing) {
          this.permissionEntryPointsForEdit = [];
          this.menusPermissionSelected(
            this.menusForEdit,
            permissions.data.menuPermissions
          );
        } else {
          this.permissionEntryPoints = [];
          this.menusPermissionSelected(
            this.menus,
            permissions.data.menuPermissions
          );
          this.ciTypePermissions = permissions.data.ciTypePermissions;
        }
      } else {
        if (queryAfterEditing) {
          this.menusPermissionSelected(this.menusForEdit);
        } else {
          this.menusPermissionSelected(this.menus);
          this.ciTypePermissions = [];
        }
      }
    },
    async handleUserClick(checked, name) {
      this.currentRoleId = 0;
      this.dataPermissionDisabled = true;
      this.users.forEach(_ => {
        _.checked = false;
        if (name === _.username) {
          _.checked = checked;
        }
      });
      let { status, data, message } = await getRolesByUser(name);
      this.getPermissions(false, checked, name, true);
      if (status === "OK") {
        this.roles.forEach(_ => {
          _.checked = false;
          const found = data.find(item => item.roleId === _.id);
          if (found) {
            _.checked = checked;
          }
          this.menus = this.menusResponseHandeler(this.allMenusOriginResponse);
        });
      }
    },
    async getAllUsers() {
      let { status, data, message } = await getAllUsers();
      if (status === "OK") {
        this.users = data.map(_ => {
          return {
            id: _.userId,
            username: _.username,
            fullName: _.fullName,
            description: _.description,
            checked: false,
            color: "#5cadff"
          };
        });
      }
    },
    openAddRoleModal() {
      this.addRoleModalVisible = true;
    },
    openAddUserModal() {
      this.addUserModalVisible = true;
    },

    menusPermissionSelected(allMenus, menusPermissions = []) {
      allMenus.forEach(_ => {
        _.children.forEach(m => {
          const subMenu = menusPermissions.find(n => m.code === n);
          m.checked = subMenu ? true : false;
        });
        _.indeterminate = false;
        _.checked = false;
      });
    },

    async handleRoleClick(checked, id) {
      this.currentRoleId = id;
      this.dataPermissionDisabled = false;
      this.menus = this.menusResponseHandeler(
        this.allMenusOriginResponse,
        false
      );
      this.roles.forEach(_ => {
        _.checked = false;
        if (id === _.id) {
          _.checked = checked;
        }
      });
      let { status, data, message } = await getUsersByRole(id);
      this.getPermissions(false, checked, id);
      if (status === "OK") {
        this.users.forEach(_ => {
          _.checked = false;
          const found = data.find(item => item.username === _.username);
          if (found) {
            _.checked = checked;
          }
        });
      }
    },
    async handleMenuTreeCheck(allChecked, currentChecked) {
      let menuCodes = [];
      if (!currentChecked.parentId) {
        menuCodes = currentChecked.children.map(_ => _.code);
      } else {
        menuCodes.push(currentChecked.code);
      }
      const { status, message, data } = currentChecked.checked
        ? await addMenusToRole(menuCodes, this.currentRoleId)
        : await removeMenusFromRole(menuCodes, this.currentRoleId);
      if (status === "OK") {
        this.$Notice.success({
          title: "success",
          desc: message
        });
      }
      this.getPermissions(true, true, this.currentRoleId);
    },
    async getAllRoles() {
      let { status, data, message } = await getAllRoles();
      if (status === "OK") {
        this.roles = data.map(_ => {
          return {
            id: _.roleId,
            rolename: _.roleName,
            description: _.description,
            roleType: _.roleType,
            checked: false,
            color: "success"
          };
        });
      }
    },
    menusResponseHandeler(data, disabled = true) {
      let menus = [];
      data.forEach(_ => {
        if (!_.parentId) {
          let menuObj = MENUS.find(m => m.code === _.code);
          menus.push({
            ..._,
            title: this.$lang === "zh-CN" ? menuObj.cnName : menuObj.enName,
            id: _.id,
            expand: true,
            checked: false,
            children: [],
            disabled
          });
        }
      });
      data.forEach(_ => {
        if (_.parentId) {
          let menuObj = MENUS.find(m => m.code === _.code);
          menus.forEach(h => {
            if (_.parentId === h.id) {
              h.children.push({
                ..._,
                title: this.$lang === "zh-CN" ? menuObj.cnName : menuObj.enName,
                id: _.id,
                expand: true,
                checked: false,
                disabled
              });
            }
          });
        }
      });
      return menus;
    },
    async getAllMenus() {
      let { status, data, message } = await getAllMenus();
      if (status === "OK") {
        this.allMenusOriginResponse = data;
        this.menus = this.menusResponseHandeler(data);
        this.menusForEdit = this.menusResponseHandeler(data, false);
      }
    },
    permissionResponseHandeler(res) {
      this.getPermissions(true, true, this.currentRoleId);
    },
    async setPermissionAction(checked, name, id) {
      if (this.currentRoleId === 0) return;
      if (checked) {
        const addRes = await addDataPermissionAction(
          this.currentRoleId,
          id,
          name
        );
        this.permissionResponseHandeler(addRes);
      } else {
        const delRes = await removeDataPermissionAction(
          this.currentRoleId,
          id,
          name
        );
        this.permissionResponseHandeler(delRes);
      }
    },
    getArrDifference(arr1, arr2) {
      return arr1.concat(arr2).filter(function(v, i, arr) {
        return arr.indexOf(v) === arr.lastIndexOf(v);
      });
    },
    async openUserManageModal(id) {
      this.usersKeyBySelectedRole = [];
      this.allUsersForTransfer = [];
      this.selectedRole = id;
      let { status, data, message } = await getUsersByRole(id);
      if (status === "OK") {
        this.usersKeyBySelectedRole = data.map(_ => _.userId);
      }
      this.allUsersForTransfer = this.users.map(_ => {
        return {
          key: _.id,
          username: _.username,
          label: ` ${_.username} ( ${_.description} ) `
        };
      });
      this.userManageModal = true;
    },
    cancel() {},
    confirmUser() {
      if (this.currentRoleId !== 0) {
        this.handleRoleClick(true, this.currentRoleId);
      }
    }
  },
  created() {
    this.getAllUsers();
    this.getAllRoles();
    this.getAllMenus();
  },
  watch: {}
};
</script>

<style lang="scss" scoped>
.ivu-tag {
  display: block;
  border: #515a61 1px dashed !important;
  .ivu-tag-text {
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    display: block;
  }
}

.role-item {
  .ivu-tag {
    display: inline-block;
    width: 65%;
  }
}
.data-permissions {
  width: 100%;
  height: 30px;
  border: 1px dashed gray;
  padding-left: 5px;
  padding-right: 5px;
  border-radius: 5px;
  margin-bottom: 5px;
}
.ciTypes-options {
  float: right;
  line-height: 30px;
}
.ciTypes {
  float: left;
  line-height: 30px;
}
.ciTypes-options {
  .ivu-checkbox-indeterminate .ivu-checkbox-inner {
    background-color: #4ee643;
  }
  .ivu-checkbox-disabled.ivu-checkbox-checked .ivu-checkbox-inner {
    background-color: #2d8cf0;
  }
}
</style>
