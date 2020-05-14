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
              :disabled="dataPermissionDisabled || !ciTypesWithAccessControlledAttr[ci.ciTypeId]"
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
    </Modal>
  </Row>
</template>

<script>
import { newOuterActions } from '@/const/actions.js'
import { resetButtonDisabled } from '@/const/tableActionFun.js'
import {
  getRoleCiTypeCtrlAttributesByRoleCiTypeId,
  getEnumCodesByCategoryId,
  createRoleCiTypeCtrlAttributes,
  updateRoleCiTypeCtrlAttributes,
  deleteRoleCiTypeCtrlAttributes,
  getPermissionsByRole,
  getWecubeRoles,
  addDataPermissionAction,
  removeDataPermissionAction,
  getAllCITypesByLayerWithAttr
} from '@/api/server.js'
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
      roles: [],
      dataPermissionDisabled: false,
      permissionManageModal: false,
      ciTypePermissions: [],
      currentRoleCiTypeId: '',
      // for WeCMDBTable
      newOuterActions,
      ciTypeAttrsPermissions: [],
      ciTypeAttrsPermissionsBackUp: [],
      attrsPermissionsColumns: [],
      permissionsTableOptions: {},
      defaultColumns: [
        {
          title: this.$t('query'),
          key: 'enquiryPermission',
          inputKey: 'enquiryPermission',
          defaultDisplaySeqNo: 1,
          placeholder: this.$t('select_placeholder'),
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
        {
          title: this.$t('new'),
          key: 'creationPermission',
          inputKey: 'creationPermission',
          defaultDisplaySeqNo: 2,
          placeholder: this.$t('select_placeholder'),
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
        {
          title: this.$t('modify'),
          key: 'modificationPermission',
          inputKey: 'modificationPermission',
          defaultDisplaySeqNo: 3,
          placeholder: this.$t('select_placeholder'),
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
        {
          title: this.$t('execute'),
          key: 'executionPermission',
          inputKey: 'executionPermission',
          defaultDisplaySeqNo: 4,
          placeholder: this.$t('select_placeholder'),
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
        {
          title: this.$t('delete'),
          key: 'removalPermission',
          inputKey: 'removalPermission',
          defaultDisplaySeqNo: 5,
          placeholder: this.$t('select_placeholder'),
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
      this.$refs.table.isTableLoading(true)
      const { statusCode, data } = await getRoleCiTypeCtrlAttributesByRoleCiTypeId(this.currentRoleCiTypeId)
      if (statusCode === 'OK') {
        let enumsArray = []
        let _attrsPermissionsColumns = data.header
          .map((h, index) => {
            if (['select', 'multiSelect'].indexOf(h.inputType) >= 0) {
              enumsArray.push({ enumKey: h.propertyName, referenceId: h.referenceId, index: index })
            } else {
              enumsArray.push(null)
            }
            return {
              ...h,
              title: h.name,
              key: h.propertyName,
              inputKey: h.propertyName,
              displaySeqNo: index + 1,
              inputType: h.inputType,
              referenceId: h.referenceId,
              placeholder: h.name,
              ciType: { id: h.referenceId, name: h.name },
              component: h.inputType === 'select' ? 'WeCMDBSelect' : 'CMDBPermissionFilters',
              isMultiple: h.inputType === 'select',
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
              _.displaySeqNo = _.defaultDisplaySeqNo + data.header.length
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
              obj[i] = _[i] ? _[i].conditionValueExprs : []
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
        const enumOptionsArray = await Promise.all(
          enumsArray.map(_ => {
            if (_) {
              return getEnumCodesByCategoryId(0, _.referenceId)
            } else {
              return null
            }
          })
        )
        this.$refs.table.isTableLoading(false)
        enumOptionsArray.forEach((_, i) => {
          if (_) {
            _attrsPermissionsColumns[i].options = _.data.map(item => {
              return {
                value: item.codeId,
                label: item.value
              }
            })
          }
        })
        this.attrsPermissionsColumns = _attrsPermissionsColumns
        this.ciTypeAttrsPermissions = _ciTypeAttrsPermissions
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
                  conditionValueExprs: _[i]
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
        const foundRow = this.ciTypeAttrsPermissionsBackUp.find(p => p.roleCiTypeCtrlAttrId === _.roleCiTypeCtrlAttrId)
        for (let i in _) {
          const found = this.defaultKey.find(k => k === i)
          const foundCi = this.attrsPermissionsColumns.find(k => k.inputKey === i)
          if (!found && foundCi) {
            if (['ref', 'multiRef'].indexOf(foundCi.inputType) >= 0) {
              _[i] = foundRow[i]
                ? {
                  conditionType: 'Expression',
                  conditionId: foundRow[i].conditionId,
                  conditionValueExprs: _[i]
                }
                : null
            } else if (['select', 'multiSelect'].indexOf(foundCi.inputType) >= 0) {
              _[i] = foundRow[i]
                ? {
                  conditionType: 'Select',
                  conditionId: foundRow[i].conditionId,
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
      this.permissionEntryPointsForEdit = []
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
                _.attributes.find(attr => {
                  if (attr.isAccessControlled) {
                    _ciTypesWithAccessControlledAttr[_.ciTypeId] = _
                    return true
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
    }
  },
  created () {
    this.getAllRoles()
    this.getAllCis()
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
