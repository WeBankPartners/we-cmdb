<template>
  <Row>
    <Col span="8">
      <Card>
        <p slot="title" class="margin-left:20px;">
          {{ $t('role') }}
        </p>
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
        </div>
      </Card>
    </Col>
    <Col span="15" offset="1">
      <Card>
        <p slot="title">{{ $t('data_management') }}</p>
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
            >
              {{ act.actionName }}
            </Checkbox>
            <Button
              icon="ios-build"
              type="dashed"
              size="small"
              :disabled="dataPermissionDisabled"
              @click="openPermissionManageModal(ci.roleCiTypeId)"
            >
              {{ $t('details') }}
            </Button>
          </div>
        </div>
      </Card>
    </Col>
    <Modal
      v-model="permissionManageModal"
      :title="$t('edit_data_authority')"
      @on-ok="cancelEdit"
      @on-cancel="cancelEdit"
      width="80"
    >
      <WeCMDBTable
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
      ></WeCMDBTable>
    </Modal>
  </Row>
</template>

<script>
import { outerActions, innerActions, components } from '@/const/actions.js'
import {
  getRoleCiTypeCtrlAttributesByRoleCiTypeId,
  getEnumCodesByCategoryId,
  createRoleCiTypeCtrlAttributes,
  updateRoleCiTypeCtrlAttributes,
  deleteRoleCiTypeCtrlAttributes,
  getPermissionsByRole,
  getWecubeRoles,
  addDataPermissionAction,
  removeDataPermissionAction
} from '@/api/server.js'
export default {
  data () {
    return {
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
      roles: [],
      dataPermissionDisabled: false,
      permissionManageModal: false,
      ciTypePermissions: [],
      currentRoleCiTypeId: '',
      // for WeCMDBTable
      outerActions,
      innerActions,
      ciTypeAttrsPermissions: [],
      ciTypeAttrsPermissionsBackUp: [],
      attrsPermissionsColumns: [],
      permissionsTableOptions: {},
      defaultColumns: [
        {
          title: this.$t('query'),
          key: 'enquiryPermission',
          inputKey: 'enquiryPermission',
          displaySeqNo: 1,
          placeholder: this.$t('select_placeholder'),
          component: 'WeCMDBSelect',
          options: [
            {
              label: this.$t('yes'),
              value: 'Y'
            },
            {
              label: this.$t('no'),
              value: 'N'
            }
          ]
        },
        {
          title: this.$t('new'),
          key: 'creationPermission',
          inputKey: 'creationPermission',
          displaySeqNo: 2,
          placeholder: this.$t('select_placeholder'),
          component: 'WeCMDBSelect',
          options: [
            {
              label: this.$t('yes'),
              value: 'Y'
            },
            {
              label: this.$t('no'),
              value: 'N'
            }
          ]
        },
        {
          title: this.$t('modify'),
          key: 'modificationPermission',
          inputKey: 'modificationPermission',
          displaySeqNo: 3,
          placeholder: this.$t('select_placeholder'),
          component: 'WeCMDBSelect',
          options: [
            {
              label: this.$t('yes'),
              value: 'Y'
            },
            {
              label: this.$t('no'),
              value: 'N'
            }
          ]
        },
        {
          title: this.$t('execute'),
          key: 'executionPermission',
          inputKey: 'executionPermission',
          displaySeqNo: 4,
          placeholder: this.$t('select_placeholder'),
          component: 'WeCMDBSelect',
          options: [
            {
              label: this.$t('yes'),
              value: 'Y'
            },
            {
              label: this.$t('no'),
              value: 'N'
            }
          ]
        },
        {
          title: this.$t('delete'),
          key: 'removalPermission',
          inputKey: 'removalPermission',
          displaySeqNo: 5,
          placeholder: this.$t('select_placeholder'),
          component: 'WeCMDBSelect',
          options: [
            {
              label: this.$t('yes'),
              value: 'Y'
            },
            {
              label: this.$t('no'),
              value: 'N'
            }
          ]
        }
      ]
    }
  },
  methods: {
    openPermissionManageModal (roleCiTypeId) {
      this.currentRoleCiTypeId = roleCiTypeId
      this.permissionManageModal = true
      this.getAttrPermissions()
    },
    async getAttrPermissions () {
      const { statusCode, data } = await getRoleCiTypeCtrlAttributesByRoleCiTypeId(this.currentRoleCiTypeId)
      if (statusCode === 'OK') {
        this.ciTypeAttrsPermissionsBackUp = data.body
        this.ciTypeAttrsPermissions = data.body.map(_ => {
          let obj = {}
          for (let i in _) {
            const found = data.header.find(p => p.propertyName === i)
            const isRef = found && found.inputType === 'ref'
            if (typeof _[i] === 'object' && _[i] !== null) {
              obj[i] = {
                codeId:
                  _[i].conditionValue && isRef ? _[i].conditionValue : _[i].conditionValue.split(',').map(n => n * 1),
                value:
                  (_[i].conditionValueObject &&
                    _[i].conditionValueObject
                      .map(s => (isRef ? s.data.key_name : s.value))
                      .toString()
                      .replace(',', ';')) ||
                  []
              }
            } else {
              obj[i] = {
                codeId: _[i],
                value: _[i] === 'Y' ? this.$t('yes') : this.$t('no')
              }
            }
          }
          return obj
        })
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
              type: 'text',
              ...components[h.inputType],
              isMultiple: h.inputType === 'select'
            }
          })
          .concat(this.defaultColumns)
        this.attrsPermissionsColumns.forEach(async i => {
          if (i.inputType === 'select') {
            const enumOptions = await getEnumCodesByCategoryId(0, i.referenceId)
            let opts = []
            if (enumOptions.statusCode === 'OK') {
              opts = enumOptions.data.map(_ => {
                return {
                  value: _.codeId,
                  label: _.value
                }
              })
              this.$set(i, 'options', opts)
            }
          }
        })
      }
    },
    async exportHandler () {
      const data = this.ciTypeAttrsPermissions.map(_ => {
        for (let i in _) {
          _[i] = _[i].value
        }
        return _
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
        case 'save':
          this.saveHandler(data)
          break
        case 'delete':
          this.deleteHandler(data)
          break
        case 'cancel':
          this.cancelHandler()
          break
        case 'innerCancel':
          this.$refs.table.rowCancelHandler(data.weTableRowId)
          break
        default:
          break
      }
    },
    async saveHandler (data) {
      let setBtnsStatus = () => {
        this.outerActions.forEach(_ => {
          _.props.disabled = !(_.actionType === 'add' || _.actionType === 'export')
        })
        this.$refs.table.setAllRowsUneditable()
        this.$nextTick(() => {
          /* to get iview original data to set _ischecked flag */
          let objData = this.$refs.table.$refs.table.$refs.tbody.objData
          for (let obj in objData) {
            objData[obj]._isChecked = false
            objData[obj]._isDisabled = false
          }
        })
      }
      let d = JSON.parse(JSON.stringify(data))
      let addAry = d.filter(_ => _.isNewAddedRow)
      let editAry = d.filter(_ => !_.isNewAddedRow)
      const defaultKey = [
        'creationPermission',
        'enquiryPermission',
        'executionPermission',
        'grantPermission',
        'modificationPermission',
        'removalPermission',
        'roleCiTypeId',
        'roleCiTypeCtrlAttrId',
        'callbackId'
      ]
      if (addAry.length > 0) {
        this.outerActions.forEach(_ => {
          if (_.actionType === 'save') {
            _.props.loading = true
          }
        })
        addAry.forEach(_ => {
          _.callbackId = _['weTableRowId']
          delete _.isNewAddedRow
          delete _.isRowEditable
          delete _.weTableForm
          delete _.weTableRowId
          for (let i in _) {
            const found = defaultKey.find(k => k === i)
            if (!found) {
              _[i] = { conditionValue: _[i].toString() }
            }
          }
        })
        const { statusCode, message } = await createRoleCiTypeCtrlAttributes(this.currentRoleCiTypeId, addAry)
        this.outerActions.forEach(_ => {
          if (_.actionType === 'save') {
            _.props.loading = false
          }
        })
        if (statusCode === 'OK') {
          this.$Notice.success({
            title: this.$t('add_permission_success'),
            desc: message
          })

          this.getAttrPermissions()
          this.getPermissions(false, true, this.currentRoleName)
          setBtnsStatus()
        }
      }
      if (editAry.length > 0) {
        this.outerActions.forEach(_ => {
          if (_.actionType === 'save') {
            _.props.loading = true
          }
        })
        editAry.forEach(_ => {
          _.callbackId = _['weTableRowId']
          delete _.isNewAddedRow
          delete _.isRowEditable
          delete _.weTableForm
          delete _.weTableRowId
          const foundRow = this.ciTypeAttrsPermissionsBackUp.find(
            p => p.roleCiTypeCtrlAttrId === _.roleCiTypeCtrlAttrId
          )
          for (let i in _) {
            const found = defaultKey.find(k => k === i)
            if (!found) {
              _[i] = {
                conditionValue: _[i].toString(),
                conditionId: foundRow[i].conditionId
              }
            }
          }
        })
        const { statusCode, message } = await updateRoleCiTypeCtrlAttributes(this.currentRoleCiTypeId, editAry)
        this.outerActions.forEach(_ => {
          if (_.actionType === 'save') {
            _.props.loading = false
          }
        })
        if (statusCode === 'OK') {
          this.$Notice.success({
            title: this.$t('update_permission_success'),
            desc: message
          })
          this.getAttrPermissions()
          this.getPermissions(false, true, this.currentRoleName)
          setBtnsStatus()
        }
      }
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
            this.outerActions.forEach(_ => {
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
        if (_.inputType === 'multiSelect' || _.inputType === 'multiRef') {
          emptyRowData[_.inputKey] = []
        } else {
          emptyRowData[_.inputKey] = ''
        }
      })
      emptyRowData['isRowEditable'] = true
      emptyRowData['isNewAddedRow'] = true
      emptyRowData['weTableRowId'] = new Date().getTime()
      this.ciTypeAttrsPermissions.unshift(emptyRowData)
      this.$nextTick(() => {
        this.$refs.table.pushNewAddedRowToSelections()
        this.$refs.table.setCheckoutStatus(true)
      })
      this.outerActions.forEach(_ => {
        _.props.disabled = _.actionType === 'add'
      })
    },
    editHandler () {
      this.$refs.table.swapRowEditable(true)
      this.outerActions.forEach(_ => {
        if (_.actionType === 'save') {
          _.props.disabled = false
        }
      })
      this.$nextTick(() => {
        this.$refs.table.setCheckoutStatus(true)
      })
    },
    cancelHandler () {
      this.$refs.table.setAllRowsUneditable()
      this.$refs.table.setCheckoutStatus()
      this.outerActions &&
        this.outerActions.forEach(_ => {
          _.props.disabled = !(_.actionType === 'add' || _.actionType === 'export' || _.actionType === 'cancel')
        })
    },
    onSelectedRowsChange (rows, checkoutBoxdisable) {
      if (rows.length > 0) {
        this.outerActions.forEach(_ => {
          _.props.disabled = _.actionType === 'add'
        })
      } else {
        this.outerActions.forEach(_ => {
          _.props.disabled = !(_.actionType === 'add' || _.actionType === 'export' || _.actionType === 'cancel')
        })
      }
      this.seletedRows = rows
    },
    cancelEdit () {
      this.permissionEntryPointsForEdit = []
      this.cancelHandler()
    },
    ciTypesPermissionsHandler (ci, code, type) {
      this.setPermissionAction(!(ci[code] === 'Y'), type, ci.ciTypeId)
    },
    async getPermissions (queryAfterEditing, checked, roleOrUser, byUser = false) {
      if (checked) {
        let permissions = await getPermissionsByRole(roleOrUser)
        this.ciTypePermissions = permissions.data.ciTypePermissions
        if (queryAfterEditing) {
          this.permissionEntryPointsForEdit = []
        } else {
          this.permissionEntryPoints = []
          this.ciTypePermissions = permissions.data.ciTypePermissions
        }
      } else {
        if (!queryAfterEditing) {
          this.ciTypePermissions = []
        }
      }
    },
    async handleRoleClick (checked, rolename) {
      // this.currentRoleId = id;
      this.currentRoleName = rolename
      this.dataPermissionDisabled = false
      this.roles.forEach(_ => {
        _.checked = false
        if (rolename === _.rolename) {
          _.checked = checked
        }
      })
      this.getPermissions(false, checked, rolename)
    },
    async getAllRoles () {
      let { status, data } = await getWecubeRoles()
      if (status === 'OK') {
        this.roles = data.map(_ => {
          return {
            id: _.id,
            rolename: _.name,
            description: _.displayName,
            checked: false,
            color: 'success'
          }
        })
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
    }
  },
  created () {
    this.getAllRoles()
  }
}
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
  display: flex;
  justify-content: space-between;

  & > span {
    flex: 1;
    margin-right: 10px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
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
