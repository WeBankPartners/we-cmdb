<template>
  <Row>
    <Col span="4">
      <Card>
        <p slot="title" class="permission-management-p">
          <span>{{ $t('user') }}</span>
          <Button icon="ios-add" type="dashed" size="small" @click="openAddUserModal">{{ $t('add_user') }}</Button>
        </p>
        <div class="tagContainers">
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
        </div>
      </Card>
    </Col>
    <Col span="5" offset="0" style="margin-left: 20px">
      <Card>
        <p slot="title" class="permission-management-p">
          <span>{{ $t('role') }}</span>
          <Button icon="ios-add" type="dashed" size="small" @click="openAddRoleModal">{{ $t('add_role') }}</Button>
        </p>
        <div class="tagContainers">
          <div class="role-item" v-for="item in roles" :key="item.rolename">
            <Tag
              :name="item.rolename"
              :color="item.color"
              :checked="item.checked"
              checkable
              :fade="false"
              @on-change="handleRoleClick"
            >
              <span :title="item.description">{{ item.description }}</span>
            </Tag>
            <Button icon="ios-build" type="dashed" size="small" @click="openUserManageModal(item.rolename)">{{
              $t('user')
            }}</Button>
          </div>
        </div>
      </Card>
    </Col>
    <Col span="4" offset="0" style="margin-left: 20px">
      <Card>
        <p slot="title">{{ $t('menus_management') }}</p>
        <div class="tagContainers">
          <Spin size="large" fix v-if="spinShow"></Spin>
          <Tree :data="menus" show-checkbox @on-check-change="handleMenuTreeCheck"></Tree>
        </div>
      </Card>
    </Col>
    <Col span="9" offset="0" style="margin-left: 20px">
      <Card>
        <p slot="title">{{ $t('data_management') }}</p>
        <div class="tagContainers">
          <Spin size="large" fix v-if="spinShow"></Spin>
          <div class="data-permissions" v-for="ci in ciTypePermissions" :key="ci.ciTypeId">
            <span class="ciTypes" :title="ci.ciTypeName">{{ ci.ciTypeName }}</span>
            <div class="ciTypes-options">
              <Checkbox
                v-for="act in actionsType"
                :disabled="dataPermissionDisabled"
                :indeterminate="ci[act.actionCode] === 'P'"
                :value="ci[act.actionCode] === 'Y'"
                :key="act.actionCode"
                @click.prevent.native="ciTypesPermissionsHandler(ci, act.actionCode, act.type)"
                >{{ act.actionName }}</Checkbox
              >
              <Button
                icon="ios-build"
                type="dashed"
                size="small"
                :disabled="dataPermissionDisabled || !ciTypesWithAccessControlledAttr[ci.ciTypeId]"
                @click="openPermissionManageModal(ci.roleCiTypeId)"
              >
                {{ $t('details') }}
              </Button>
            </div>
          </div>
        </div>
      </Card>
    </Col>
    <Modal v-model="addRoleModalVisible" :title="$t('add_role')" @on-ok="addRole" @on-cancel="cancel">
      <Input v-model="addedRoleValue" :placeholder="$t('username_input_placeholder')" />
    </Modal>
    <Modal v-model="addUserModalVisible" :title="$t('add_user')" @on-ok="addUser" @on-cancel="cancel">
      <Form class="validation-form" ref="addedUserForm" :model="addedUser" label-position="left" :label-width="100">
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
    <Modal v-model="userManageModal" width="700" :title="$t('edit_user')" @on-ok="confirmUser" @on-cancel="confirmUser">
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
    <Modal v-model="permissionManageModal" :title="$t('edit_data_authority')" @on-cancel="cancelEdit" width="80">
      <CMDBTable
        :tableData="ciTypeAttrsPermissions"
        :filtersHidden="true"
        :tableOuterActions="newOuterActions"
        :tableInnerActions="null"
        :tableColumns="attrsPermissionsColumns"
        :ascOptions="permissionsTableOptions"
        :showCheckbox="true"
        @actionFun="actionFun"
        @getSelectedRows="onSelectedRowsChange"
        @confirmAddHandler="confirmAddHandler"
        @confirmEditHandler="confirmEditHandler"
        tableHeight="650"
        ref="table"
      ></CMDBTable>
      <div slot="footer">
        <Button @click="cancelEdit">{{ $t('close') }}</Button>
      </div>
    </Modal>
  </Row>
</template>
<script>
import { resetButtonDisabled } from '@/const/tableActionFun.js'
import { newOuterActions } from '@/const/actions.js'
import {
  getAllUsers,
  getAllRoles,
  getAllMenus,
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
  createRoleCiTypeCtrlAttributes,
  updateRoleCiTypeCtrlAttributes,
  deleteRoleCiTypeCtrlAttributes,
  getAllCITypesByLayerWithAttr
} from '@/api/server.js'

import { MENUS } from '@/const/menus.js'

export default {
  data () {
    return {
      allCiTypes: [],
      ciTypesWithAccessControlledAttr: {},
      defaultKey: [
        'creationPermission',
        'enquiryPermission',
        'executionPermission',
        'grantPermission',
        'modificationPermission',
        'removalPermission',
        'roleCiTypeId',
        'roleCiTypeCtrlAttrId',
        'callbackId'
      ],
      actionsType: [
        {
          actionCode: 'creationPermission',
          type: 'CREATION',
          actionName: this.$t('permission_management_data_creation')
        },
        {
          actionCode: 'removalPermission',
          type: 'REMOVAL',
          actionName: this.$t('permission_management_data_removal')
        },
        {
          actionCode: 'modificationPermission',
          type: 'MODIFICATION',
          actionName: this.$t('permission_management_data_modification')
        },
        {
          actionCode: 'enquiryPermission',
          type: 'ENQUIRY',
          actionName: this.$t('permission_management_data_enquiry')
        },
        {
          actionCode: 'executionPermission',
          type: 'EXECUTION',
          actionName: this.$t('permission_management_data_execution')
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
      addedRoleValue: '',
      userManageModal: false,
      permissionManageModal: false,
      usersKeyBySelectedRole: [],
      allUsersForTransfer: [],
      selectedRole: null,
      transferTitles: [
        this.$t('permission_management_unselected_user'),
        this.$t('permission_management_selected_user')
      ],
      // currentRoleId: 0,
      currentRoleName: null,
      ciTypePermissions: [],
      allMenusOriginResponse: [],
      transferStyle: { width: '300px' },
      currentRoleCiTypeId: '',
      // for WeCMDBTable
      newOuterActions,
      ciTypeAttrsPermissions: [],
      ciTypeAttrsPermissionsBackUp: [],
      attrsPermissionsColumns: [],
      permissionsTableOptions: {},
      defaultOptionAttrs: {
        component: 'WeCMDBRadioRroup',
        defaultValue: 'Y',
        options: [
          {
            text: this.$t('yes'),
            label: 'Y'
          },
          {
            text: this.$t('no'),
            label: 'N'
          }
        ],
        isEditable: true,
        isAuto: false
      },
      addedUser: {},
      spinShow: false
    }
  },
  computed: {
    defaultColumns () {
      return [
        {
          title: this.$t('query'),
          key: 'enquiryPermission',
          inputKey: 'enquiryPermission',
          defaultDisplaySeqNo: 1,
          ...this.defaultOptionAttrs
        },
        {
          title: this.$t('new'),
          key: 'creationPermission',
          inputKey: 'creationPermission',
          defaultDisplaySeqNo: 2,
          ...this.defaultOptionAttrs
        },
        {
          title: this.$t('modify'),
          key: 'modificationPermission',
          inputKey: 'modificationPermission',
          defaultDisplaySeqNo: 3,
          ...this.defaultOptionAttrs
        },
        {
          title: this.$t('execute'),
          key: 'executionPermission',
          inputKey: 'executionPermission',
          defaultDisplaySeqNo: 4,
          ...this.defaultOptionAttrs
        },
        {
          title: this.$t('delete'),
          key: 'removalPermission',
          inputKey: 'removalPermission',
          defaultDisplaySeqNo: 5,
          ...this.defaultOptionAttrs
        }
      ]
    }
  },
  methods: {
    renderUserNameForTransfer (item) {
      return item.label
    },
    openPermissionManageModal (roleCiTypeId) {
      this.currentRoleCiTypeId = roleCiTypeId
      this.permissionManageModal = true
      this.getAttrPermissions()
    },
    async getAttrPermissions () {
      this.attrsPermissionsColumns = []
      this.ciTypeAttrsPermissions = []
      this.$refs.table.isTableLoading(true)
      let { statusCode, data } = await getRoleCiTypeCtrlAttributesByRoleCiTypeId(this.currentRoleCiTypeId)
      this.$refs.table.isTableLoading(false)
      if (statusCode === 'OK') {
        const headerLength = data.header.length
        let _attrsPermissionsColumns = data.header
          .map((h, index) => {
            return {
              ...h,
              title: h.name,
              key: h.propertyName,
              inputKey: h.propertyName,
              displaySeqNo: index + 1,
              inputType: h.inputType === 'select' ? 'multiSelect' : h.inputType,
              referenceId: h.referenceId,
              placeholder: h.name,
              ciType: { id: h.referenceId, name: h.name },
              component: h.inputType === 'select' ? 'WeCMDBSelect' : 'CMDBPermissionFilters',
              isMultiple: true,
              options: [],
              filterRule: null,
              isEditable: true,
              // PermissionFilters需要的参数
              allCiTypes: this.allCiTypes,
              isFilterAttr: true,
              displayAttrType: ['ref', 'multiRef'],
              rootCis: [h.propertyName]
            }
          })
          .concat(
            this.defaultColumns.map(_ => {
              _.displaySeqNo = _.defaultDisplaySeqNo + headerLength
              return _
            })
          )
        this.ciTypeAttrsPermissionsBackUp = data.body
        let _ciTypeAttrsPermissions = data.body.map(_ => {
          let obj = {}
          for (let i in _) {
            const found = data.header.find(p => p.propertyName === i)
            const isRef = found && ['ref', 'multiRef'].indexOf(found.inputType) >= 0
            const isSelect = found && ['select', 'multiSelect'].indexOf(found.inputType) >= 0
            if (isRef) {
              obj[i] = _[i] ? _[i].conditionValueExprs.map(item => item.replace(':[guid]', '')) : []
            } else if (isSelect) {
              obj[i] = _[i] ? _[i].conditionValueSelects : []
            } else {
              obj[i] = {
                codeId: _[i],
                value: _[i] === 'Y' ? this.$t('yes') : this.$t('no')
              }
            }
          }
          return obj
        })
        this.attrsPermissionsColumns = _attrsPermissionsColumns
        this.ciTypeAttrsPermissions = _ciTypeAttrsPermissions
      }
    },

    async exportHandler () {
      const data = this.ciTypeAttrsPermissions.map(_ => {
        let result = {}
        for (let i in _) {
          if (Array.isArray(_[i])) {
            result[i] = _[i]
              .map(item => {
                if (typeof item === 'object') {
                  return item.value
                } else if (typeof item === 'string') {
                  return item.replace(/,/g, ';')
                }
              })
              .join(' | ')
          } else {
            result[i] = _[i].value
          }
        }
        return result
      })
      this.$refs.table.export({
        filename: 'Permission Data',
        data: data
      })
    },
    actionFun (type, data) {
      switch (type) {
        case 'export':
          this.exportHandler()
          break
        case 'add':
          this.addHandler()
          break
        case 'edit':
          this.editHandler()
          break
        case 'copy':
          this.copyHandler()
          break
        case 'delete':
          this.deleteHandler(data)
          break
        default:
          break
      }
    },
    copyHandler (rows = [], cols) {
      this.$refs.table.showCopyModal()
    },
    formatConditionValue (value) {
      return value.map(_ => {
        let arr = _.split(/[.~]/)
        return _.replace(arr[0], arr[0] + ':[guid]')
      })
    },
    async confirmAddHandler (data) {
      let addAry = JSON.parse(JSON.stringify(data))
      addAry.forEach(_ => {
        _.callbackId = _['weTableRowId']
        delete _.isNewAddedRow
        delete _.isRowEditable
        delete _.weTableForm
        delete _.weTableRowId
        for (let i in _) {
          const foundCi = this.attrsPermissionsColumns.find(k => k.inputKey === i)
          const found = this.defaultKey.find(k => k === i)
          if (!found && foundCi) {
            if (['ref', 'multiRef'].indexOf(foundCi.inputType) >= 0) {
              _[i] = _[i].length
                ? {
                  conditionType: 'Expression',
                  conditionValueExprs: this.formatConditionValue(_[i])
                }
                : null
            } else if (['select', 'multiSelect'].indexOf(foundCi.inputType) >= 0) {
              _[i] = _[i].length
                ? {
                  conditionType: 'Select',
                  conditionValueSelects: _[i]
                }
                : null
            }
          }
        }
      })
      const { statusCode, message } = await createRoleCiTypeCtrlAttributes(this.currentRoleCiTypeId, addAry)
      this.$refs.table.closeEditModal(false)
      this.$refs.table.resetModalLoading()
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('add_permission_success'),
          desc: message
        })
        this.getAttrPermissions()
        this.getPermissions(false, true, this.currentRoleName)
        this.setBtnsStatus()
      }
    },
    async confirmEditHandler (data) {
      let editAry = JSON.parse(JSON.stringify(data))
      editAry.forEach(_ => {
        _.callbackId = _['weTableRowId']
        delete _.isNewAddedRow
        delete _.isRowEditable
        delete _.weTableForm
        delete _.weTableRowId
        for (let i in _) {
          const found = this.defaultKey.find(k => k === i)
          const foundCi = this.attrsPermissionsColumns.find(k => k.inputKey === i)
          if (!found && foundCi) {
            if (['ref', 'multiRef'].indexOf(foundCi.inputType) >= 0) {
              _[i] =
                Array.isArray(_[i]) && _[i].length
                  ? {
                    conditionType: 'Expression',
                    conditionValueExprs: this.formatConditionValue(_[i])
                  }
                  : null
            } else if (['select', 'multiSelect'].indexOf(foundCi.inputType) >= 0) {
              _[i] =
                Array.isArray(_[i]) && _[i].length
                  ? {
                    conditionType: 'Select',
                    conditionValueSelects: _[i]
                  }
                  : null
            }
          }
        }
      })
      const { statusCode, message } = await updateRoleCiTypeCtrlAttributes(this.currentRoleCiTypeId, editAry)
      this.$refs.table.closeEditModal(false)
      this.$refs.table.resetModalLoading()
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('update_permission_success'),
          desc: message
        })
        this.getAttrPermissions()
        this.getPermissions(false, true, this.currentRoleName)
        this.setBtnsStatus()
      }
    },
    setBtnsStatus () {
      this.newOuterActions.forEach(_ => {
        _.props.disabled = resetButtonDisabled(_)
      })
    },
    deleteHandler (deleteData) {
      this.$Modal.confirm({
        title: this.$t('delete_confirm'),
        'z-index': 1000000,
        onOk: async () => {
          const payload = deleteData.map(_ => _.roleCiTypeCtrlAttrId)
          const { statusCode, message } = await deleteRoleCiTypeCtrlAttributes(this.currentRoleCiTypeId, payload)
          if (statusCode === 'OK') {
            this.$Notice.success({
              title: this.$t('delete_permission_success'),
              desc: message
            })
            this.newOuterActions.forEach(_ => {
              _.props.disabled = _.actionType === 'save' || _.actionType === 'edit' || _.actionType === 'delete'
            })
            this.getAttrPermissions()
          }
        },
        onCancel: () => {}
      })
      document.querySelector('.ivu-modal-mask').click()
    },
    addHandler () {
      let emptyRowData = {}
      this.attrsPermissionsColumns.forEach(_ => {
        if (['ref', 'multiRef', 'select', 'multiSelect'].indexOf(_.inputType) >= 0) {
          emptyRowData[_.inputKey] = []
        } else {
          emptyRowData[_.inputKey] = ''
        }
      })
      emptyRowData['isRowEditable'] = true
      emptyRowData['isNewAddedRow'] = true
      emptyRowData['weTableRowId'] = new Date().getTime()
      this.$refs.table.pushNewAddedRowToSelections(emptyRowData)
      this.$refs.table.showAddModal()
    },
    editHandler () {
      this.$refs.table.showEditModal()
    },
    onSelectedRowsChange (rows, checkoutBoxdisable) {
      if (rows.length > 0) {
        this.newOuterActions.forEach(_ => {
          _.props.disabled = _.actionType === 'add'
        })
      } else {
        this.newOuterActions.forEach(_ => {
          _.props.disabled = resetButtonDisabled(_)
        })
      }
    },
    cancelEdit () {
      this.permissionManageModal = false
      this.permissionEntryPointsForEdit = []
    },
    ciTypesPermissionsHandler (ci, code, type) {
      this.setPermissionAction(!(ci[code] === 'Y'), type, ci.ciTypeId)
    },
    async handleUserTransferChange (newTargetKeys, direction, moveKeys) {
      if (direction === 'right') {
        let { statusCode, message } = await addUsersToRole(moveKeys, this.selectedRole)
        if (statusCode === 'OK') {
          this.$Notice.success({
            title: 'success',
            desc: message
          })
          this.usersKeyBySelectedRole = newTargetKeys
        }
      } else {
        let { statusCode, message } = await romoveUsersFromRole(moveKeys, this.selectedRole)
        if (statusCode === 'OK') {
          this.$Notice.success({
            title: 'success',
            desc: message
          })
          this.usersKeyBySelectedRole = newTargetKeys
        }
      }
    },
    async addRole () {
      if (this.addedRoleValue === '') {
        this.$Notice.warning({
          title: 'Warning',
          desc: this.$t('role_name_is_required')
        })
        return
      }
      let { statusCode, message } = await addRole({
        roleName: this.addedRoleValue,
        description: this.addedRoleValue
      })
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: 'success',
          desc: message
        })
        this.getAllRoles()
      }
    },
    async addUser () {
      if (this.addedUser.username === '') {
        this.$Notice.warning({
          title: 'Warning',
          desc: this.$t('role_name_is_required')
        })
        return
      }
      let { statusCode, data, message } = await addUser([this.addedUser])
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: 'success',
          desc: message
        })
        this.$Modal.info({
          title: this.$t('copy_password'),
          content: data[0].password
        })
        this.addedUser = {}
        this.getAllUsers()
      }
    },
    async getPermissions (queryAfterEditing, checked, roleOrUser, byUser = false) {
      if (checked) {
        let permissions = byUser ? await getPermissionsByUser(roleOrUser) : await getPermissionsByRole(roleOrUser)
        this.spinShow = false
        this.ciTypePermissions = permissions.data.ciTypePermissions
        if (queryAfterEditing) {
          this.permissionEntryPointsForEdit = []
          this.menusPermissionSelected(this.menusForEdit, permissions.data.menuPermissions)
        } else {
          this.permissionEntryPoints = []
          this.menusPermissionSelected(this.menus, permissions.data.menuPermissions)
          this.ciTypePermissions = permissions.data.ciTypePermissions
        }
      } else {
        if (queryAfterEditing) {
          this.menusPermissionSelected(this.menusForEdit)
        } else {
          this.menusPermissionSelected(this.menus)
          this.ciTypePermissions = []
        }
      }
    },
    async handleUserClick (checked, name) {
      this.spinShow = true
      this.currentRoleName = null
      this.dataPermissionDisabled = true
      this.users.forEach(_ => {
        _.checked = false
        if (name === _.username) {
          _.checked = checked
        }
      })
      let { statusCode, data } = await getRolesByUser(name)
      this.getPermissions(false, checked, name, true)
      if (statusCode === 'OK') {
        this.roles.forEach(_ => {
          _.checked = false
          const found = data.find(item => item.roleId === _.id)
          if (found) {
            _.checked = checked
          }
          this.menus = this.menusResponseHandeler(this.allMenusOriginResponse)
        })
      }
    },
    async getAllUsers () {
      let { statusCode, data } = await getAllUsers()
      if (statusCode === 'OK') {
        this.users = data.map(_ => {
          return {
            id: _.userId,
            username: _.username,
            fullName: _.fullName,
            description: _.description,
            checked: false,
            color: '#5cadff'
          }
        })
      }
    },
    openAddRoleModal () {
      this.addRoleModalVisible = true
    },
    openAddUserModal () {
      this.addUserModalVisible = true
    },

    menusPermissionSelected (allMenus, menusPermissions = []) {
      allMenus.forEach(_ => {
        _.children.forEach(m => {
          const subMenu = menusPermissions.find(n => m.code === n)
          m.checked = !!subMenu
        })
        _.indeterminate = false
        _.checked = false
      })
    },

    async handleRoleClick (checked, rolename) {
      this.spinShow = true
      // this.currentRoleId = id;
      this.currentRoleName = rolename
      this.dataPermissionDisabled = false
      this.menus = this.menusResponseHandeler(this.allMenusOriginResponse, false)
      this.roles.forEach(_ => {
        _.checked = false
        if (rolename === _.rolename) {
          _.checked = checked
        }
      })
      let { statusCode, data } = await getUsersByRole(rolename)
      this.getPermissions(false, checked, rolename)
      if (statusCode === 'OK') {
        this.users.forEach(_ => {
          _.checked = false
          const found = data.find(item => item.username === _.username)
          if (found) {
            _.checked = checked
          }
        })
      }
    },
    async handleMenuTreeCheck (allChecked, currentChecked) {
      let menuCodes = []
      if (!currentChecked.parentId) {
        menuCodes = currentChecked.children.map(_ => _.code)
      } else {
        menuCodes.push(currentChecked.code)
      }
      const { statusCode, message } = currentChecked.checked
        ? await addMenusToRole(menuCodes, this.currentRoleName)
        : await removeMenusFromRole(menuCodes, this.currentRoleName)
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: 'success',
          desc: message
        })
      }
      this.getPermissions(true, true, this.currentRoleName)
    },
    async getAllRoles () {
      let { statusCode, data } = await getAllRoles()
      if (statusCode === 'OK') {
        this.roles = data.map(_ => {
          return {
            id: _.roleId,
            rolename: _.roleName,
            description: _.description,
            roleType: _.roleType,
            checked: false,
            color: 'success'
          }
        })
      }
    },
    menusResponseHandeler (data, disabled = true) {
      let menus = []
      data.forEach(_ => {
        if (!_.parentId) {
          let menuObj = MENUS.find(m => m.code === _.code)
          menus.push({
            ..._,
            title: this.$lang === 'zh-CN' ? menuObj.cnName : menuObj.enName,
            id: _.id,
            expand: true,
            checked: false,
            children: [],
            disabled
          })
        }
      })
      data.forEach(_ => {
        if (_.parentId) {
          let menuObj = MENUS.find(m => m.code === _.code)
          menus.forEach(h => {
            if (_.parentId === h.id) {
              h.children.push({
                ..._,
                title: this.$lang === 'zh-CN' ? menuObj.cnName : menuObj.enName,
                id: _.id,
                expand: true,
                checked: false,
                disabled
              })
            }
          })
        }
      })
      return menus
    },
    async getAllMenus () {
      let { statusCode, data } = await getAllMenus()
      if (statusCode === 'OK') {
        this.allMenusOriginResponse = data
        this.menus = this.menusResponseHandeler(data)
        this.menusForEdit = this.menusResponseHandeler(data, false)
      }
    },
    async getAllCis () {
      const res = await getAllCITypesByLayerWithAttr(['notCreated', 'created', 'decommissioned', 'dirty'])
      if (res.statusCode === 'OK') {
        let _allCiTypes = []
        let _ciTypesWithAccessControlledAttr = {}
        res.data.forEach(layer => {
          layer.ciTypes &&
            layer.ciTypes.forEach(_ => {
              _allCiTypes.push(_)
              if (Array.isArray(_.attributes)) {
                _.attributes.forEach(attr => {
                  if (attr.isAccessControlled) {
                    _ciTypesWithAccessControlledAttr[_.ciTypeId] = _
                  }
                })
              }
            })
        })
        this.allCiTypes = _allCiTypes
        this.ciTypesWithAccessControlledAttr = _ciTypesWithAccessControlledAttr
      }
    },
    permissionResponseHandeler (res) {
      this.getPermissions(true, true, this.currentRoleName)
    },
    async setPermissionAction (checked, name, id) {
      if (!this.currentRoleName) return
      if (checked) {
        const addRes = await addDataPermissionAction(this.currentRoleName, id, name)
        this.permissionResponseHandeler(addRes)
      } else {
        const delRes = await removeDataPermissionAction(this.currentRoleName, id, name)
        this.permissionResponseHandeler(delRes)
      }
    },
    getArrDifference (arr1, arr2) {
      return arr1.concat(arr2).filter(function (v, i, arr) {
        return arr.indexOf(v) === arr.lastIndexOf(v)
      })
    },
    async openUserManageModal (rolename) {
      this.usersKeyBySelectedRole = []
      this.allUsersForTransfer = []
      this.selectedRole = rolename
      let { statusCode, data } = await getUsersByRole(rolename)
      if (statusCode === 'OK') {
        this.usersKeyBySelectedRole = data.map(_ => _.userId)
      }
      this.allUsersForTransfer = this.users.map(_ => {
        return {
          key: _.id,
          username: _.username,
          label: ` ${_.username} ( ${_.description} ) `
        }
      })
      this.userManageModal = true
    },
    cancel () {},
    confirmUser () {
      if (this.currentRoleName) {
        this.handleRoleClick(true, this.currentRoleName)
      }
    }
  },
  created () {
    this.getAllUsers()
    this.getAllRoles()
    this.getAllMenus()
    this.getAllCis()
  },
  watch: {}
}
</script>

<style lang="scss" scoped>
.tagContainers {
  overflow: auto;
  height: calc(100vh - 205px);
}
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
  display: flex;
  justify-content: space-between;

  & > span {
    flex: 1;
    margin-right: 10px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  &:hover {
    background-color: rgb(227, 231, 235);
  }
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
.permission-management-p {
  align-items: center;
  display: flex;
  height: 24px;
  span {
    margin-right: 5px;
  }
}
</style>
