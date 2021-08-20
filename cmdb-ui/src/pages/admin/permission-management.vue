<template>
  <Row>
    <Col span="7" offset="1">
      <Card>
        <p slot="title" class="permission-management-p">
          <span>{{ $t('user') }}</span>
          <Button icon="ios-add" type="dashed" size="small" @click="openAddUserModal">{{ $t('add_user') }}</Button>
        </p>
        <div class="tagContainers">
          <Tag
            v-for="item in users"
            :key="item.id"
            :name="item.userId"
            :color="item.color"
            :checked="item.checked"
            checkable
            :fade="false"
            @on-change="handleUserClick"
          >
            <span :title="` ${item.displayName} ( ${item.description} ) `">{{
              ` ${item.displayName} ( ${item.description} ) `
            }}</span>
            <span v-if="users.length > 1" style="float:right;" @click="resetPassword($event, item)">
              <Icon size="20" type="ios-unlock-outline" />
            </span>
            <span v-if="users.length > 1" style="float:right;color:red" @click="deleteUser(item)">
              <Icon size="20" type="ios-trash-outline" />
            </span>
          </Tag>
        </div>
      </Card>
    </Col>
    <Col span="7" offset="1" style="margin-left: 20px">
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
              <span v-if="item.rolename !== 'SUPER_ADMIN'" style="float:right;color:red" @click="deleteRole(item)">
                <Icon size="20" type="ios-trash-outline" />
              </span>
            </Tag>
            <Button icon="md-person" type="dashed" size="small" @click="openUserManageModal(item.rolename)">{{
              $t('user')
            }}</Button>
          </div>
        </div>
      </Card>
    </Col>
    <Col span="7" offset="1" style="margin-left: 20px">
      <Card>
        <p slot="title">{{ $t('menus_management') }}</p>
        <div class="tagContainers">
          <Spin size="large" fix v-if="spinShow"></Spin>
          <Tree :data="menus" show-checkbox @on-check-change="handleMenuTreeCheck"></Tree>
        </div>
      </Card>
    </Col>
    <Modal v-model="addRoleModalVisible" :title="$t('add_role')" @on-ok="addRole" @on-cancel="cancel">
      <Input v-model="addedRoleValue" :placeholder="$t('username_input_placeholder')" />
    </Modal>
    <Modal v-model="addUserModalVisible" :title="$t('add_user')" @on-ok="addUser" @on-cancel="cancel">
      <Form class="validation-form" ref="addedUserForm" :model="addedUser" label-position="left" :label-width="100">
        <FormItem :label="$t('username')" prop="userId">
          <Input v-model="addedUser.userId" />
        </FormItem>
        <FormItem :label="$t('fullname')" prop="displayName">
          <Input v-model="addedUser.displayName" />
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
    <Modal
      v-model="showPassword"
      :title="$t('copy_password')"
      @on-ok="showPassword = false"
      @on-cancel="showPassword = false"
    >
      <span>{{ newResetPassword }}</span>
    </Modal>
  </Row>
</template>
<script>
import {
  getAllUsers,
  getAllRoles,
  resetPassword,
  getAllMenus,
  deleteUser,
  deleteRole,
  getRolesByUser,
  getUsersByRole,
  addRole,
  addUser,
  getPermissionsByRole,
  addUsersToRole,
  addMenusToRole,
  addDataPermissionAction,
  removeDataPermissionAction,
  getAllCITypesByLayerWithAttr,
  assignCiTypePermissionForRoleInBatch
} from '@/api/server.js'

import { MENUS } from '@/const/menus.js'

export default {
  data () {
    return {
      allCiTypes: [],
      ciTypesWithAccessControlledAttr: {},
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
      batchOperations: [
        {
          name: this.$t('permission_management_data_creation'),
          allSelect: false,
          emptySelect: false,
          key: 'insert'
        },
        {
          name: this.$t('permission_management_data_removal'),
          allSelect: false,
          emptySelect: false,
          key: 'delete'
        },
        {
          name: this.$t('permission_management_data_modification'),
          allSelect: false,
          emptySelect: false,
          key: 'update'
        },
        {
          name: this.$t('permission_management_data_enquiry'),
          allSelect: false,
          emptySelect: false,
          key: 'query'
        },
        {
          name: this.$t('permission_management_data_execution'),
          allSelect: false,
          emptySelect: false,
          key: 'execute'
        }
      ],
      cacheOriginCiTypePermission: [], // 便于撤销还原
      ciTypePermissions: [],
      allMenusOriginResponse: [],
      transferStyle: { width: '300px' },
      currentRoleCiTypeId: '',
      // for WeCMDBTable
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
        editable: 'yes',
        isAuto: false
      },
      addedUser: {},
      spinShow: false,
      showPassword: false,
      newResetPassword: ''
    }
  },
  computed: {},
  watch: {
    ciTypePermissions: {
      handler (newValue) {
        // this.batchOperations.forEach(_ => {
        //   _.allSelect = newValue.every(ciPermisstion => {
        //     return ciPermisstion[_.key] === 'Y'
        //   })
        //   const emptySelect = newValue.every(ciPermisstion => {
        //     return ciPermisstion[_.key] === 'N'
        //   })
        //   _.emptySelect = !_.allSelect && !emptySelect
        // })
      },
      immediate: true,
      deep: true
    }
  },
  methods: {
    async resetPassword (event, user) {
      event.stopPropagation()
      this.$Modal.confirm({
        title: this.$t('reset_password'),
        'z-index': 1000000,
        onOk: async () => {
          const params = {
            username: user.userId
          }
          const { statusCode, data } = await resetPassword(params)
          if (statusCode === 'OK') {
            this.newResetPassword = data
            this.showPassword = true
          }
        },
        onCancel: () => {}
      })
    },
    async deleteUser (item) {
      this.$Modal.confirm({
        title: this.$t('delete_confirm'),
        'z-index': 1000000,
        onOk: async () => {
          let { statusCode, message } = await deleteUser(item.id)
          if (statusCode === 'OK') {
            this.$Notice.success({
              title: 'success',
              desc: message
            })
            this.getAllUsers()
          }
        },
        onCancel: () => {}
      })
      document.querySelector('.ivu-modal-mask').click()
    },
    async deleteRole (item) {
      this.$Modal.confirm({
        title: this.$t('delete_confirm'),
        'z-index': 1000000,
        onOk: async () => {
          let { statusCode, message } = await deleteRole(item.id)
          if (statusCode === 'OK') {
            this.$Notice.success({
              title: 'success',
              desc: message
            })
            this.getAllRoles()
          }
        },
        onCancel: () => {}
      })
      document.querySelector('.ivu-modal-mask').click()
    },
    renderUserNameForTransfer (item) {
      return item.label
    },
    openPermissionManageModal (roleCiTypeId) {
      this.currentRoleCiTypeId = roleCiTypeId
      this.permissionManageModal = true
      this.getAttrPermissions()
    },
    formatConditionValue (value) {
      return value.map(_ => {
        let arr = _.split(/[.~]/)
        return _.replace(arr[0], arr[0] + ':[guid]')
      })
    },
    ciTypesPermissionsHandler (ciIndex, code) {
      this.ciTypePermissions[ciIndex][code] = this.ciTypePermissions[ciIndex][code] === 'Y' ? 'N' : 'Y'
    },
    batchPermission (val, operationType) {
      const value = val ? 'Y' : 'N'
      this.ciTypePermissions.forEach(_ => {
        _[operationType] = value
      })
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
    async savePermissionsInBatch () {
      const ciTypePermissions = this.ciTypePermissions.map(permission => {
        return {
          ciTypeId: permission.ciTypeId,
          ciTypeName: permission.ciTypeName,
          insert: permission.insert,
          query: permission.query,
          execute: permission.execute,
          update: permission.update,
          delete: permission.delete
        }
      })
      let { statusCode, message } = await assignCiTypePermissionForRoleInBatch(ciTypePermissions, this.currentRoleName)
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: 'success',
          desc: message
        })
        this.getPermissions(true, true, this.currentRoleName)
      }
    },
    cancelPermissionsOperation () {
      this.ciTypePermissions = JSON.parse(JSON.stringify(this.cacheOriginCiTypePermission))
    },
    async handleUserTransferChange (newTargetKeys, direction, moveKeys) {
      const params = [
        {
          roleName: this.selectedRole,
          userList: newTargetKeys
        }
      ]
      let { statusCode, message } = await addUsersToRole(params)
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: 'success',
          desc: message
        })
        this.usersKeyBySelectedRole = newTargetKeys
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
      if (this.addedUser.userId === '') {
        this.$Notice.warning({
          title: 'Warning',
          desc: this.$t('role_name_is_required')
        })
        return
      }
      let { statusCode, data, message } = await addUser(this.addedUser)
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: 'success',
          desc: message
        })
        this.$Modal.info({
          title: this.$t('copy_password'),
          content: data
        })
        this.addedUser = {}
        this.getAllUsers()
      }
    },
    async getPermissions (queryAfterEditing, checked, roleOrUser, byUser = false) {
      if (checked) {
        let permissions = await getPermissionsByRole(roleOrUser)
        this.spinShow = false
        if (queryAfterEditing) {
          this.permissionEntryPointsForEdit = []
          this.menusPermissionSelected(this.menusForEdit, permissions.data)
        } else {
          this.permissionEntryPoints = []
          this.menusPermissionSelected(this.menus, permissions.data)
        }
      } else {
        if (queryAfterEditing) {
          this.menusPermissionSelected(this.menusForEdit)
        } else {
          this.menusPermissionSelected(this.menus)
        }
      }
    },
    async handleUserClick (checked, name) {
      this.spinShow = true
      this.currentRoleName = null
      this.dataPermissionDisabled = true
      this.users.forEach(_ => {
        _.checked = false
        if (name === _.userId) {
          _.checked = checked
        }
      })
      let { statusCode, data } = await getRolesByUser(name)
      let roles = []
      if (statusCode === 'OK') {
        this.roles.forEach(_ => {
          _.checked = false
          const found = data.find(item => item.roleName === _.id)
          if (found) {
            roles.push(found.roleName)
            _.checked = checked
          }
          this.menus = this.menusResponseHandeler(this.allMenusOriginResponse)
        })
        this.getPermissions(false, checked, roles.join(','), true)
      }
    },
    async getAllUsers () {
      let { statusCode, data } = await getAllUsers()
      if (statusCode === 'OK') {
        this.users = data.map(_ => {
          return {
            id: _.userId,
            userId: _.userId,
            displayName: _.displayName,
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
          const subMenu = menusPermissions.find(n => m.id === n.id)
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
      if (statusCode === 'OK') {
        this.users.forEach(_ => {
          _.checked = false
          const found = data.find(item => item.userId === _.userId)
          if (found) {
            _.checked = checked
          }
        })
      }
      this.getPermissions(false, checked, rolename)
    },
    async handleMenuTreeCheck (allChecked) {
      let menuCodes = new Set()
      allChecked.forEach(item => {
        const children = item.children
        if (children) {
          children.forEach(child => {
            menuCodes.add(child.id)
          })
        } else {
          menuCodes.add(item.id)
        }
      })
      const params = {
        roleName: this.currentRoleName,
        menuList: Array.from(menuCodes)
      }
      const { statusCode, message } = await addMenusToRole(params)
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
            id: _.roleName,
            rolename: _.roleName,
            description: _.description,
            checked: false,
            color: 'success'
          }
        })
      }
    },
    menusResponseHandeler (data, disabled = true) {
      let menus = []
      data.forEach(_ => {
        if (!_.parent) {
          let menuObj = MENUS.find(m => m.code === _.id)
          if (menuObj) {
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
        }
      })
      data.forEach(_ => {
        if (_.parent) {
          let menuObj = MENUS.find(m => m.code === _.id)
          menus.forEach(h => {
            if (_.parent === h.id) {
              h.children.push({
                ..._,
                title: menuObj ? (this.$lang === 'zh-CN' ? menuObj.cnName : menuObj.enName) : _.displayName,
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
                  if (attr.permissionUsage !== 'no') {
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
          userId: _.userId,
          label: ` ${_.displayName} ( ${_.description} ) `
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
  }
}
</script>

<style lang="scss" scoped>
.tagContainers-auth {
  overflow: auto;
  height: calc(100vh - 310px);
}
.tagContainers {
  overflow: auto;
  height: calc(100vh - 220px);
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
.batch-operation {
  padding-bottom: 0 5px 8px 5px;
  margin-bottom: 18px;
  border-bottom: 1px solid #2d8cf0;
}
.batch-operation-btn {
  text-align: right;
  padding-top: 8px;
  margin-top: 8px;
  border-top: 1px solid #2d8cf0;
}
</style>
