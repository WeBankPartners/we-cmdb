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
        <div v-if="ciTypePermissions.length" class="batch-operation">
          <div style="float:left">{{ $t('selectAll') }}</div>
          <div class="" style="text-align:right;">
            <template v-for="(operation, opretionIndex) in batchOperations">
              <Checkbox
                :key="opretionIndex"
                :value="operation.allSelect"
                :indeterminate="operation.emptySelect"
                @on-change="
                  val => {
                    batchPermission(val, operation.key)
                  }
                "
                >{{ operation.name }}</Checkbox
              >
            </template>
            <Button
              icon="md-person"
              type="dashed"
              size="small"
              style="margin-right:21px;margin-left:6px;visibility: hidden;"
              >{{ $t('details') }}</Button
            >
          </div>
        </div>
        <div class="tagContainers">
          <div class="data-permissions" v-for="(ci, ciIndex) in ciTypePermissions" :key="ci.ciTypeId">
            <span class="ciTypes" :title="ci.ciTypeName">{{ ci.ciTypeName }}</span>
            <div class="ciTypes-options">
              <Checkbox
                v-for="act in actionsType"
                :disabled="dataPermissionDisabled"
                :indeterminate="ci[act.actionCode] === 'P'"
                :value="ci[act.actionCode] === 'Y'"
                :key="act.actionCode"
                @click.prevent.native="ciTypesPermissionsHandler(ciIndex, act.actionCode)"
              >
                {{ act.actionName }}
              </Checkbox>
              <Button
                icon="md-person"
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
        <div v-if="ciTypePermissions.length" class="batch-operation-btn">
          <Button type="primary" @click="savePermissionsInBatch">{{ $t('save') }}</Button>
          <Button @click="canclePermissionsOperation">{{ $t('cancel') }}</Button>
        </div>
      </Card>
    </Col>
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
import { newOuterActions } from '@/const/actions.js'
import { resetButtonDisabled } from '@/const/tableActionFun.js'
import {
  getRoleCiTypeCtrlAttributesByRoleCiTypeId,
  createRoleCiTypeCtrlAttributes,
  updateRoleCiTypeCtrlAttributes,
  deleteRoleCiTypeCtrlAttributes,
  getPermissionsByRole,
  getWecubeRoles,
  // addDataPermissionAction,
  // removeDataPermissionAction,
  getAllCITypesByLayerWithAttr,
  assignCiTypePermissionForRoleInBatch
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
      batchOperations: [
        {
          name: this.$t('permission_management_data_creation'),
          allSelect: false,
          emptySelect: false,
          key: 'creationPermission'
        },
        {
          name: this.$t('permission_management_data_removal'),
          allSelect: false,
          emptySelect: false,
          key: 'removalPermission'
        },
        {
          name: this.$t('permission_management_data_modification'),
          allSelect: false,
          emptySelect: false,
          key: 'modificationPermission'
        },
        {
          name: this.$t('permission_management_data_enquiry'),
          allSelect: false,
          emptySelect: false,
          key: 'enquiryPermission'
        },
        {
          name: this.$t('permission_management_data_execution'),
          allSelect: false,
          emptySelect: false,
          key: 'executionPermission'
        }
      ],
      cacheOriginCiTypePermission: [] // 便于撤销还原
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
  watch: {
    ciTypePermissions: {
      handler (newValue) {
        this.batchOperations.forEach(_ => {
          _.allSelect = newValue.every(ciPermisstion => {
            return ciPermisstion[_.key] === 'Y'
          })
          const emptySelect = newValue.every(ciPermisstion => {
            return ciPermisstion[_.key] === 'N'
          })
          _.emptySelect = !_.allSelect && !emptySelect
        })
      },
      immediate: true,
      deep: true
    }
  },
  methods: {
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
    ciTypesPermissionsHandler (ciIndex, code) {
      this.ciTypePermissions[ciIndex][code] = this.ciTypePermissions[ciIndex][code] === 'Y' ? 'N' : 'Y'
    },
    batchPermission (val, operationType) {
      const value = val ? 'Y' : 'N'
      this.ciTypePermissions.forEach(_ => {
        _[operationType] = value
      })
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
      this.cacheOriginCiTypePermission = JSON.parse(JSON.stringify(this.ciTypePermissions))
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
    async savePermissionsInBatch () {
      const ciTypePermissions = this.ciTypePermissions.map(permission => {
        const {
          ciTypeId,
          ciTypeName,
          creationPermission,
          enquiryPermission,
          executionPermission,
          modificationPermission,
          removalPermission
        } = permission
        return {
          ciTypeId: ciTypeId,
          ciTypeName,
          creationPermission,
          enquiryPermission,
          executionPermission,
          modificationPermission,
          removalPermission
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
    canclePermissionsOperation () {
      this.ciTypePermissions = JSON.parse(JSON.stringify(this.cacheOriginCiTypePermission))
    }
    // permissionResponseHandeler (res) {
    //   this.getPermissions(true, true, this.currentRoleName)
    // },
    // async setPermissionAction (checked, name, id) {
    //   if (!this.currentRoleName) return
    //   if (checked) {
    //     const addRes = await addDataPermissionAction(this.currentRoleName, id, name)
    //     this.permissionResponseHandeler(addRes)
    //   } else {
    //     const delRes = await removeDataPermissionAction(this.currentRoleName, id, name)
    //     this.permissionResponseHandeler(delRes)
    //   }
    // }
  },
  created () {
    this.getAllRoles()
    this.getAllCis()
  }
}
</script>

<style lang="scss" scoped>
.tagContainers {
  overflow: auto;
  height: calc(100vh - 280px);
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
