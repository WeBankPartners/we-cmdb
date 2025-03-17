<template>
  <Row>
    <Col span="6" offset="0" style="margin-left: 20px; margin-top: -10px">
      <Tabs v-model="currentTabName" @on-click="onTabsClick">
        <TabPane :label="$t('db_role_permissions')" name="role"></TabPane>
        <TabPane :label="$t('db_permission_template_management')" name="template"></TabPane>
      </Tabs>
      <Card style="min-height: 85vh; margin-top: -5px">
        <p slot="title" class="permission-management-p">
          <span>{{ isRolePermissionPage ? $t('role') : $t('db_template') }}</span>
          <Tooltip 
            :content="$t('permission_management_data_creation') + $t('db_template')" 
            max-width="300" 
            placement="top-start"
          >
            <Button
              v-if="!isRolePermissionPage"
              size="small"
              type="success"
              style="margin-left: 5px"
              @click="onAddTemplateButtonClick()"
            >
              <Icon type="md-add-circle" size="16"></Icon>
            </Button>
          </Tooltip>
        </p>
        <div class="tagContainers">
          <div v-if="isRolePermissionPage">
            <div class="role-item" v-for="item in roles" :key="item.rolename">
              <Tag
                :name="item.rolename"
                :color="item.color"
                :checked="item.checked"
                checkable
                :fade="false"
                @on-change="handleRoleClick"
              >
                <span :title="item.rolename + '(' + item.description + ')'">{{ item.rolename + '(' + item.description + ')' }}</span>
              </Tag>
            </div>
          </div>
          <div v-else>
            <Table :loading="roleTemplateLoading" 
              highlight-row
              size="small" 
              :columns="roleTemplateTableColumns" 
              :data="templateListData" 
            />
          </div>
        </div>
      </Card>
    </Col>
    <Col span="17" offset="0" style="margin-left: 20px; margin-top: 37px">
      <Card style="min-height: 85vh">
        <div slot="title">
          <div v-if='isRolePermissionPage'>
            <p style="display: inline; margin-right: 20px">{{ $t('data_management') }}</p>
            <span v-if='usingTemplateNames.length'>{{ $t('db_using_templates') + ':' }}</span>
            <span v-if='usingTemplateNames.length' style="color: #5384FF; margin: 0px 10px">{{usingTemplateNames.join('、')}}</span>
            <Button 
              class='template-button' 
              type='primary' 
              size="small"
              @click="onTemplateConfigButtonClick"
            >
              {{ $t('db_configuration_template') }}
            </Button>
          </div>
          <div v-else class='template-name-edit'>
            <span>{{$t('db_template_name')}}</span>
            <Input v-model="roleTemplateName"
              :placeholder="$t('db_template_input_placeholder')"
              suffix="md-create"
              style="width: 250px"
            >
            </Input>
          </div>
        </div>
        <div v-if="ciTypePermissions.length" class="batch-operation">
          <Input v-model="filterParam" :placeholder="$t('db_ci_name_info')" style="width:200px"></Input>
          <div style="margin-right: 168px">
            <span style="margin-right: 10px">{{ $t('selectAll') }}</span>
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
          </div>
        </div>
        <div class="tagContainers-auth">
          <Spin size="large" fix v-if="spinShow"></Spin>

          <Collapse v-model="currentCollapseValue" accordion>
            <Panel
              v-for="(ci, ciIndex) in ciTypePermissions"
              :key="ci.ciTypeId"
              :name="ciIndex + ''"
              v-if="ci.ciTypeName.includes(filterParam)"
            >
              <template>
                <span :title="ci.ciTypeName">{{ ci.ciTypeName }}</span>
                <div class="ciTypes-options" @click="preventEvent">
                  <Checkbox
                    v-for="act in actionsType"
                    :disabled="dataPermissionDisabled"
                    :value="ci[act.actionCode] === 'Y'"
                    :key="act.actionCode"
                    :indeterminate="ci[act.actionCode] === 'P'"
                    @click.prevent.native="ciTypesPermissionsHandler(ciIndex, act.actionCode)"
                    >{{ act.actionName }}</Checkbox
                  >
                  <Button
                    style="margin-right: 4px"
                    :type="ci.conditionEnable ? 'primary' : 'dashed'"
                    size="small"
                    :disabled="dataPermissionDisabled || !ciTypesWithAccessControlledAttr[ci.ciTypeId]"
                    @click="openPermissionManageModal(ci.guid, ci)"
                  >
                    {{ $t('db_condition_matching') }}
                  </Button>
                  <Button :type="ci.listRowEnable ? 'primary' : 'dashed'" size="small" @click="openListManageModal(ci)">
                    {{ $t('db_specify_row') }}
                  </Button>
                </div>
              </template>
              <template slot="content">
                <div v-if="ci.attrs && ci.attrs.length > 0">
                  <div class="ci-attr-style" v-for="(one, oneIndex) in ci.attrs" :key="oneIndex">
                    <span style="margin-left: 30px" :title="one.ciAttrName">{{ one.ciAttrName }}</span>
                    <div>
                      <Checkbox
                        v-for="act in ciAttrActionsType"
                        :disabled="dataPermissionDisabled || ci[act.actionCode] === 'N'"
                        :value="one[act.actionCode] === 'Y'"
                        :key="act.actionCode"
                        :indeterminate="one[act.actionCode] === 'P'"
                        @click.prevent.native="ciAttrsPermissionsHandler(one, act.actionCode)"
                        >{{ act.actionName }}</Checkbox
                      >
                      <Button
                        style="margin-left: 222px; margin-right: 4px"
                        :type="one.conditionEnable ? 'primary' : 'dashed'"
                        size="small"
                        :disabled="dataPermissionDisabled || !ciTypesWithAccessControlledAttr[ci.ciTypeId]"
                        @click="openPermissionManageModal(one.guid, one)"
                      >
                        {{ $t('db_condition_matching') }}
                      </Button>
                      <Button
                        :type="one.listRowEnable ? 'primary' : 'dashed'"
                        size="small"
                        @click="openListManageModal(one)"
                      >
                        {{ $t('db_specify_row') }}
                      </Button>
                    </div>
                  </div>
                </div>
                <div v-else style="margin-left: 30px">
                  {{ $t('db_permission_not_configured') }}
                </div>
              </template>
            </Panel>
          </Collapse>
        </div>
        <div v-if="ciTypePermissions.length" class="batch-operation-btn">
          <Button 
            style="margin-right: 10px" 
            type="primary" 
            @click="savePermissionsInBatch">
            {{ $t('save') }}{{ $t('actions') }}
          </Button>
          <Button @click="cancelPermissionsOperation">
            {{ $t('cancel') }}{{ $t('actions') }}
          </Button>
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
    <Modal v-model="userManageModal" width="800" :title="$t('edit_user')" @on-ok="confirmUser" @on-cancel="confirmUser">
      <div style="width: 100%; overflow-x: auto">
        <div style="min-width: 760px; display: flex; justify-content: center">
          <Transfer
            :titles="transferTitles"
            :list-style="transferStyle"
            :data="allUsersForTransfer"
            :target-keys="usersKeyBySelectedRole"
            :render-format="renderUserNameForTransfer"
            @on-change="handleUserTransferChange"
            filterable
          ></Transfer>
        </div>
      </div>
    </Modal>
    <Modal v-model="permissionManageModal" 
      :title="permissionModalTitle" 
      @on-cancel="cancelEdit" 
      @on-visible-change="onPermissionModalVisibleChange"
      width="80">
      <CMDBTable
        :key='refreshKey'
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
    <!-- 列表编辑-开始 -->
    <Modal v-model="listManagementModal" 
      :title="listManagementModalTitle" 
      @on-visible-change="onListManagementModalClose"
      width="80">
      <ListManagement
        :guidOptions="guidOptions"
        :isRolePermissionPage="isRolePermissionPage"
        ref="listManagement"
      ></ListManagement>
      <div slot="footer">
        <Button @click="listManagementModal = false">{{ $t('close') }}</Button>
      </div>
    </Modal>
    <!-- 列表编辑-结束 -->
    <Modal v-model="isTemplateConfigModelShow" 
      width="1200" 
      :title="$t('role') + roleName +' - ' + $t('db_template_configuration')" 
    >
      <div class='config-modal-content'>
        <Select
          v-if="templateConfigType === 'edit'"
          v-model="selectedTemplateItem"
          filterable
          clearable
          :placeholder="$t('db_addRow_exist')"
          style="width:300px; margin-bottom: 10px"
          @on-open-change="
            flag => {
              if (flag) {
                getAllRoleTemplateList(false)
              }
            }
          "
          @on-change="addTemplateTableItem"
        >
          <template slot='prefix'>
            <Icon type="md-add-circle" color="#2d8cf0" :size="24"></Icon>
          </template>
          <template v-for="one in templateConfigOptions">
            <Option :key="one.id" :value="one.id">{{ one.name }}</Option>
          </template>
        </Select>
        <Table size="small" 
          :columns="finalSelectedTemplateTableColumns" 
          :data="selectedTemplateData"
          :span-method="templateTableSpanMethod"
          @on-select="(selection, row) => onTemplateTableSelectionChange('selectOne', row)" 
          @on-select-cancel="(selection, row) => onTemplateTableSelectionChange('cancelOne', row)"
          @on-select-all="onTemplateTableSelectionChange('allSelect')"
          @on-select-all-cancel="onTemplateTableSelectionChange('allCancel')"
        />
      </div>
      <template slot='footer'>
        <div>
          <Button @click="cancelTemplateModal">{{$t('cancel')}}</Button>
          <Button @click="confirmTemplateModal" type='primary'>{{$t('save')}}</Button>
        </div>
      </template>
    </Modal>
    <!-- 切换tab时候的二次确认弹窗 -->
    <Modal v-model="isSecondConfirmationShow" 
      :ok-text="$t('save')"
      :cancel-text="$t('discard')"
      :title="$t('db_switch_confirmation')" 
      @on-ok="onSecondConfirmationOk"
      @on-visible-change="onSecondConfirmationVisibleChange"
    >
      <span style="display: flex; justify-content: center; color: red">
        {{this.$t('db_change_role_tabs_tips')}}
      </span>
    </Modal>
  </Row>
</template>
<script>
import {
  addDataPermissionAction,
  addRole,
  addUser,
  addUsersToRole,
  assignCiTypePermissionForRoleInBatch,
  createPermCiTypeCtrlAttributes,
  createRoleCiTypeCtrlAttributes,
  deletePermCiTypeCtrlAttributes,
  deleteRoleCiTypeCtrlAttributes,
  deleteRoleTemplateItem,
  getAllCITypesByLayerWithAttr,
  getAllRoles,
  getAllUsers,
  getoperationPermissionsByRole,
  getPermCiTypeCtrlAttributesByRoleCiTypeId,
  getRoleCiTypeCtrlAttributesByRoleCiTypeId,
  getRoleTemplateItemInfo,
  getRoleTemplateList,
  getTemplateByRole,
  getTemplateInfoById,
  queryCiData,
  removeDataPermissionAction,
  saveRoleTemplate,
  saveTemplateInfo,
  saveTemplateParams,
  updatePermCiTypeCtrlAttributes,
  updateRoleCiTypeCtrlAttributes
} from '@/api/server.js'
import { newOuterActions } from '@/const/actions.js'
import { resetButtonDisabled } from '@/const/tableActionFun.js'
import { cloneDeep, find, groupBy, isEmpty, map, omit } from 'lodash'
import Vue from 'vue'
import ListManagement from './list-management'

export default {
  components: {
    ListManagement
  },
  data () {
    return {
      filterParam: '',
      listManagementModal: false,
      listRoleCiTypeId: '',
      guidOptions: [],
      listColumns: [
        {
          title: 'guid',
          key: 'listName',
          inputKey: 'list',
          uiFormOrder: 1,
          displaySeqNo: 1,
          options: [],
          // optionKey: 'catOpts',
          propertyName: 'list',
          isMultiple: true,
          component: 'WeCMDBSelect',
          editable: 'yes',
          autofillable: 'no',
          resetOnEdit: 'no',
          isAuto: false,
          displayByDefault: 'yes'
        },
        {
          title: this.$t('query'),
          key: 'query',
          inputKey: 'query',
          uiFormOrder: 2,
          displaySeqNo: 2,
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
          autofillable: 'no',
          resetOnEdit: 'no',
          isAuto: false,
          displayByDefault: 'yes'
        },
        {
          title: this.$t('new'),
          key: 'insert',
          inputKey: 'insert',
          uiFormOrder: 3,
          displaySeqNo: 3,
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
          autofillable: 'no',
          resetOnEdit: 'no',
          isAuto: false,
          displayByDefault: 'yes'
        },
        {
          title: this.$t('modify'),
          key: 'update',
          inputKey: 'update',
          uiFormOrder: 4,
          displaySeqNo: 4,
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
          autofillable: 'no',
          resetOnEdit: 'no',
          isAuto: false,
          displayByDefault: 'yes'
        },
        {
          title: this.$t('execute'),
          key: 'execute',
          inputKey: 'execute',
          uiFormOrder: 5,
          displaySeqNo: 5,
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
          autofillable: 'no',
          resetOnEdit: 'no',
          isAuto: false,
          displayByDefault: 'yes'
        },
        {
          title: this.$t('delete'),
          key: 'delete',
          inputKey: 'delete',
          uiFormOrder: 6,
          displaySeqNo: 6,
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
          autofillable: 'no',
          resetOnEdit: 'no',
          isAuto: false,
          displayByDefault: 'yes'
        },
        {
          title: this.$t('permission_management_data_confirm'),
          key: 'confirm',
          inputKey: 'confirm',
          uiFormOrder: 7,
          displaySeqNo: 7,
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
          autofillable: 'no',
          resetOnEdit: 'no',
          isAuto: false,
          displayByDefault: 'yes'
        }
      ],
      attrListColumns: [
        {
          title: 'guid',
          key: 'listName',
          inputKey: 'list',
          uiFormOrder: 1,
          displaySeqNo: 1,
          options: [],
          // optionKey: 'catOpts',
          propertyName: 'list',
          isMultiple: true,
          component: 'WeCMDBSelect',
          editable: 'yes',
          autofillable: 'no',
          resetOnEdit: 'no',
          isAuto: false,
          displayByDefault: 'yes'
        },
        {
          title: this.$t('query'),
          key: 'query',
          inputKey: 'query',
          uiFormOrder: 2,
          displaySeqNo: 2,
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
          autofillable: 'no',
          resetOnEdit: 'no',
          isAuto: false,
          displayByDefault: 'yes'
        },
        {
          title: this.$t('modify'),
          key: 'update',
          inputKey: 'update',
          uiFormOrder: 4,
          displaySeqNo: 4,
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
          autofillable: 'no',
          resetOnEdit: 'no',
          isAuto: false,
          displayByDefault: 'yes'
        }
      ],
      allCiTypes: [],
      ciTypesWithAccessControlledAttr: {},
      defaultKey: [
        'insert',
        'query',
        'execute',
        'grantPermission',
        'update',
        'delete',
        'roleCiTypeId',
        'roleCiTypeCtrlAttrId'
      ],
      actionsType: [
        {
          actionCode: 'query',
          type: 'ENQUIRY',
          actionName: this.$t('permission_management_data_enquiry')
        },
        {
          actionCode: 'update',
          type: 'MODIFICATION',
          actionName: this.$t('permission_management_data_modification')
        },
        {
          actionCode: 'insert',
          type: 'CREATION',
          actionName: this.$t('permission_management_data_creation')
        },
        {
          actionCode: 'delete',
          type: 'REMOVAL',
          actionName: this.$t('permission_management_data_removal')
        },
        {
          actionCode: 'execute',
          type: 'EXECUTION',
          actionName: this.$t('permission_management_data_execution')
        },
        {
          actionCode: 'confirm',
          type: 'CONFIRM',
          actionName: this.$t('permission_management_data_confirm')
        }
      ],
      ciAttrActionsType: [
        {
          actionCode: 'query',
          type: 'ENQUIRY',
          actionName: this.$t('permission_management_data_enquiry')
        },
        {
          actionCode: 'update',
          type: 'MODIFICATION',
          actionName: this.$t('permission_management_data_modification')
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
      permissionModalTitle: '',
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
          name: this.$t('permission_management_data_enquiry'),
          allSelect: false,
          emptySelect: false,
          key: 'query'
        },
        {
          name: this.$t('permission_management_data_modification'),
          allSelect: false,
          emptySelect: false,
          key: 'update'
        },
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
          name: this.$t('permission_management_data_execution'),
          allSelect: false,
          emptySelect: false,
          key: 'execute'
        },
        {
          name: this.$t('permission_management_data_confirm'),
          allSelect: false,
          emptySelect: false,
          key: 'confirm'
        }
      ],
      cacheOriginCiTypePermission: [], // 便于撤销还原
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
        editable: 'yes',
        isAuto: false
      },
      addedUser: {},
      spinShow: false,
      currentCollapseValue: null,
      listManagementModalTitle: '',
      isCiType: true,
      currentTabName: 'role', // 枚举，为role | template
      historyCurrentTabName: 'role',
      roleTemplateTableColumns: [
        {
          title: this.$t('db_template_name'),
          key: 'name',
          render: (h, params) => <div>{params.row.name || '-'}</div>
        },
        {
          title: this.$t('db_creator'),
          key: 'createUser',
          width: 100,
          render: (h, params) => <div>{params.row.createUser || '-'}</div>
        },
        {
          title: this.$t('actions'),
          key: 'action',
          fixed: 'right',
          render: (h, params) => (
            <div style='display: flex'>
              <Poptip
                confirm
                transfer
                ok-text={this.$t('save')}
                cancel-text={this.$t('discard')}
                title={this.$t('db_role_template_tips')}
                placement="left-end"
                on-on-ok={async () => {
                  const info = {
                    id: this.roleTemplateId,
                    name: this.roleTemplateName,
                    configs: cloneDeep(this.ciTypePermissions),
                  }
                  await saveTemplateInfo(info)
                  this.editTemplateItem(params.row.id)
                }}
                on-on-cancel={() => {
                  this.editTemplateItem(params.row.id)
                }}>
                <Tooltip max-width={400} placement="top" transfer content={this.$t('edit')}>
                  <Button size="small" 
                    style='margin-right: 4px' 
                    type='primary'>
                    <Icon type="md-create" size="16" />
                  </Button>
                </Tooltip>
              </Poptip>
              <Poptip
                confirm
                transfer
                title={this.$t('db_delConfirm_tip')}
                placement="left-end"
                on-on-ok={() => {
                  this.deleteTemplateItem(params.row.id)
                }}>
                <Button size="small" type="error">
                  <Icon type="md-trash" size="16" />
                </Button>
              </Poptip>
            </div>
          )
        }
      ],
      selectedTemplateTableColumns: [
        {
            type: 'selection',
            width: 70,
            align: 'center',
            key: 'selection'
        },
        {
          title: this.$t('db_template_name'),
          width: 100,
          key: 'permissionTplName',
          render: (h, params) => <div>{params.row.permissionTplName || '-'}</div>
        },
        {
          title: this.$t('db_ci_name'),
          width: 150,
          key: 'ciTypeDisplayName',
          render: (h, params) => <div>{params.row.ciTypeDisplayName || '-'}</div>
        },
        {
          title: this.$t('ci_attribute_name'),
          width: 150,
          key: 'filterAttrName',
          render: (h, params) => <div>{params.row.filterAttrName || '-'}</div>
        },
        {
          title: this.$t('db_parameter_expression'),
          width: 200,
          key: 'filterExpression',
          render: (h, params) => <div>{params.row.filterExpression || '-'}</div>
        },
        {
          title: this.$t('db_parameter_name'),
          key: 'filterParamName',
          render: (h, params) => (
            <div>
            {
              this.templateConfigType === 'edit' ? (
                <span>{params.row.filterParamName || '-'}</span>
              ) : (
                <div style="display: flex; align-items: center">
                  <span style="color:red; font-weight: 600; margin-right: 2px">*</span>
                  <Input
                    value={params.row.filterParamName}
                    on-on-change={v => {
                      Vue.set(this.selectedTemplateData[params.index], 'filterParamName', v.target.value)
                    }}
                    placeholder={this.$t('input_placeholder')}
                    clearable
                  />
                </div>
              )
            }
            </div>
          ) 
        },
        {
          title: this.$t('db_parameter_value'),
          key: 'filterParamValue',
          render: (h, params) => (
            <div>
            {
              this.templateConfigType === 'preview' ? (
                <span>{params.row.filterParamValue || '-'}</span>
              ) : (
                params.row.ciType ?
                <Input
                  value={params.row.filterParamValue}
                  on-on-change={v => {
                    Vue.set(this.selectedTemplateData[params.index], 'filterParamValue', v.target.value)
                  }}
                  placeholder={this.$t('input_placeholder')}
                  clearable
                /> : <span>-</span>
              )
            }
            </div>
          )
        }
      ],
      templateListData: [],
      usingTemplateNames: [],
      usingTemplateDetail: [],
      isTemplateConfigModelShow: false,
      templateConfigType: 'edit', // 该字段为枚举，edit 表示对角色增加权限； preview表示保存的时候验证权限
      selectedTemplateItem: '',
      selectedTemplateData: [],
      roleTemplateName: '',
      roleTemplateId: '',
      roleName: '',
      templateConfigOptions: [],
      roleTemplateLoading: false,
      refreshKey: '',
      isSecondConfirmationShow: false
    }
  },
  computed: {
    defaultColumns () {
      return [
        {
          title: this.$t('new'),
          key: 'insert',
          inputKey: 'insert',
          uiFormOrder: 2,
          ...this.defaultOptionAttrs,
          displayByDefault: 'yes',
          displayName: this.$t('new'),
          ciTypeAttrId: 'insert'
        },
        {
          title: this.$t('delete'),
          key: 'delete',
          inputKey: 'delete',
          uiFormOrder: 3,
          ...this.defaultOptionAttrs,
          displayByDefault: 'yes',
          displayName: this.$t('delete'),
          ciTypeAttrId: 'delete'
        },
        {
          title: this.$t('modify'),
          key: 'update',
          inputKey: 'update',
          uiFormOrder: 4,
          ...this.defaultOptionAttrs,
          displayByDefault: 'yes',
          displayName: this.$t('modify'),
          ciTypeAttrId: 'update'
        },
        {
          title: this.$t('query'),
          key: 'query',
          inputKey: 'query',
          uiFormOrder: 5,
          ...this.defaultOptionAttrs,
          displayByDefault: 'yes',
          displayName: this.$t('query'),
          ciTypeAttrId: 'query'
        },
        {
          title: this.$t('execute'),
          key: 'execute',
          inputKey: 'execute',
          uiFormOrder: 6,
          ...this.defaultOptionAttrs,
          displayByDefault: 'yes',
          displayName: this.$t('execute'),
          ciTypeAttrId: 'execute'
        },
        {
          title: this.$t('permission_management_data_confirm'),
          key: 'confirm',
          inputKey: 'confirm',
          uiFormOrder: 7,
          ...this.defaultOptionAttrs,
          displayByDefault: 'yes',
          displayName: this.$t('permission_management_data_confirm'),
          ciTypeAttrId: 'confirm'
        }
      ]
    },
    // 该字段为true则在角色权限页面，为false则在 权限模板管理 页面
    isRolePermissionPage () {
      return this.currentTabName === 'role' 
    },
    finalSelectedTemplateTableColumns() {
      const columns = cloneDeep(this.selectedTemplateTableColumns)
      if (this.templateConfigType === 'edit') {
        return columns
      }
      return columns.slice(1)
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
    async openListManageModal (ci) {
      this.listManagementModalTitle =
        `${(ci.ciTypeName || ci.ciAttrName) + '-' + this.$t('db_specifying_row_permissions')}` || this.$t('list')
      this.listRoleCiTypeId = ci.guid
      const columns = ci.ciTypeName ? this.listColumns : this.attrListColumns
      const params = {
        id: ci.ciTypeId,
        queryObject: {
          dialect: { queryMode: 'new' },
          filters: [],
          paging: false,
          resultColumns: ['guid', 'key_name', 'description']
        }
      }
      let res = await queryCiData(params)
      if (res.statusCode === 'OK') {
        columns[0].options = res.data.contents.map(_ => {
          return {
            value: _.guid,
            label: _.key_name
          }
        })
      }
      this.$refs.listManagement.getListTableData(ci.guid, ci.ciTypeId, columns, this.isRolePermissionPage)
      this.listManagementModal = true
    },
    renderUserNameForTransfer (item) {
      return item.label
    },
    openPermissionManageModal (roleCiTypeId, ciDetail) {
      this.permissionModalTitle =
        `${(ciDetail.ciTypeName || ciDetail.ciAttrName) + '-' + this.$t('db_condition_matching_permissions')}` ||
        this.$t('edit_data_authority')
      this.currentRoleCiTypeId = roleCiTypeId
      this.permissionManageModal = true
      this.isCiType = ciDetail.ciTypeName ? true : false
      this.refreshKey = +new Date() + ''
      this.getAttrPermissions()
    },
    async getAttrPermissions () {
      this.attrsPermissionsColumns = []
      this.ciTypeAttrsPermissions = []
      this.$refs.table.isTableLoading(true)
      let { statusCode, data } = this.isRolePermissionPage 
        ? await getRoleCiTypeCtrlAttributesByRoleCiTypeId(this.currentRoleCiTypeId)
        : await getPermCiTypeCtrlAttributesByRoleCiTypeId(this.currentRoleCiTypeId)
      this.$refs.table.isTableLoading(false)
      const defaultColumnsInfo = this.isCiType ? this.defaultColumns : this.defaultColumns.slice(2, 4)
      if (statusCode === 'OK') {
        const headerLength = data.header.length
        let _attrsPermissionsColumns = data.header
          .map((h, index) => {
            let tableName = ''
            const isRef = h.inputType === 'ref' || h.inputType === 'multiRef'
            if (isRef) {
              tableName = this.allCiTypes.find(_ => _.ciTypeId === h.referenceId).ciTypeId
            }
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
              options: h.options || [],
              autoFillRule: null,
              editable: 'yes',
              // PermissionFilters需要的参数
              allCiTypes: this.allCiTypes,
              isFilterAttr: true,
              displayAttrType: ['ref', 'multiRef'],
              rootCis: [isRef ? tableName : h.propertyName],
              rootCiTypeId: h.referenceId,
              uiFormOrder: 1,
              displayName: h.name
            }
          })
          .concat(
            defaultColumnsInfo.map(_ => {
              _.displaySeqNo = _.uiFormOrder + headerLength
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
              obj[i] = _[i]
                ? _[i].conditionValueExprs.map(item => item.replace(':[guid]', ''))
                : JSON.stringify([found.referenceId])
            } else if (isSelect) {
              obj[i] = _[i] ? this.getSelectVal(_[i].selectValues, found) : []
            } else {
              obj[i] = {
                codeId: _[i],
                value: _[i] === 'Y' ? 'Y' : 'N'
                // value: _[i] === 'Y' ? this.$t('yes') : this.$t('no')
              }
            }
          }
          return obj
        })
        this.attrsPermissionsColumns = _attrsPermissionsColumns
        this.ciTypeAttrsPermissions = _ciTypeAttrsPermissions
      }
    },

    getSelectVal (vals, found) {
      let res = []
      found.options.forEach(o => {
        if (vals.includes(o.value)) {
          res.push({
            codeId: o.value,
            value: o.label
          })
        }
      })
      return res
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
      switch (type.actionType) {
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
      if (Array.isArray(value)) {
        value = value.toString()
      }
      for (let i = 0; i < 5; i++) {
        value = value.replace(',,', ',')
      }
      if (value.indexOf(',') === 0) {
        value = value.substring(1)
      }
      const lastIndexOf = value.lastIndexOf(',')
      if (lastIndexOf === value.length - 1) {
        value = value.substring(0, lastIndexOf)
      }
      let arr = value.split(/[.~]/)
      if (arr[0] === '') {
        return value
      }
      return value.replace(arr[0], arr[0] + ':[guid]')
      // return value.map(_ => {
      //   let arr = _.split(/[.~]/)
      //   return _.replace(arr[0], arr[0] + ':[guid]')
      // })
    },
    async confirmAddHandler (data) {
      let addAry = JSON.parse(JSON.stringify(data))
      addAry.forEach(_ => {
        delete _.isNewAddedRow
        delete _.isRowEditable
        delete _.weTableForm
        delete _.weTableRowId
        for (let i in _) {
          const foundCi = this.attrsPermissionsColumns.find(k => k.inputKey === i)
          const found = this.defaultKey.find(k => k === i)
          if (!found && foundCi) {
            if (['ref', 'multiRef'].indexOf(foundCi.inputType) >= 0) {
              if (_[i]) {
                _[i] = {
                  expression: this.formatConditionValue(_[i])
                }
              } else {
                _[i] = {
                  expression: ''
                }
              }
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
      const { statusCode, message } = this.isRolePermissionPage 
        ? await createRoleCiTypeCtrlAttributes(this.currentRoleCiTypeId, addAry)
        : await createPermCiTypeCtrlAttributes(this.currentRoleCiTypeId, addAry)
      this.$refs.table.closeEditModal(false)
      this.$refs.table.resetModalLoading()
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('add_permission_success'),
          desc: message
        })
        this.getAttrPermissions()
        this.isRolePermissionPage ? this.getPermissions(false, true, this.currentRoleName) : this.editTemplateItem(this.roleTemplateId)
        this.setBtnsStatus()
      }
    },
    async confirmEditHandler (data) {
      let editAry = JSON.parse(JSON.stringify(data))
      editAry.forEach(_ => {
        delete _.isNewAddedRow
        delete _.isRowEditable
        delete _.weTableForm
        delete _.weTableRowId
        for (let i in _) {
          const found = this.defaultKey.find(k => k === i)
          const foundCi = this.attrsPermissionsColumns.find(k => k.inputKey === i)
          if (!found && foundCi) {
            if (['ref', 'multiRef'].indexOf(foundCi.inputType) >= 0) {
              if (_[i]) {
                _[i] = {
                  expression: this.formatConditionValue(_[i])
                }
              } else {
                _[i] = {
                  expression: ''
                }
              }
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
      const { statusCode, message } = this.isRolePermissionPage
        ? await updateRoleCiTypeCtrlAttributes(this.currentRoleCiTypeId, editAry)
        : await updatePermCiTypeCtrlAttributes(this.currentRoleCiTypeId, editAry)
      this.$refs.table.closeEditModal(false)
      this.$refs.table.resetModalLoading()
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('update_permission_success'),
          desc: message
        })
        this.getAttrPermissions()
        this.isRolePermissionPage ? this.getPermissions(false, true, this.currentRoleName) : this.editTemplateItem(this.roleTemplateId)
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
          const payload = deleteData.map(_ => _.roleConditionGuid)
          const permIds = deleteData.map(_ => _.guid)
          const { statusCode, message } = this.isRolePermissionPage 
          ? await deleteRoleCiTypeCtrlAttributes(this.currentRoleCiTypeId, payload.join(','))
          : await deletePermCiTypeCtrlAttributes(this.currentRoleCiTypeId, permIds.join(','))
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
          if (_.component === 'CMDBPermissionFilters') {
            emptyRowData[_.inputKey] = JSON.stringify([_.rootCiTypeId])
          } else {
            emptyRowData[_.inputKey] = JSON.stringify([])
          }
        } else {
          emptyRowData[_.inputKey] = 'N'
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
      const permissionItem = this.ciTypePermissions[ciIndex]
      permissionItem[code] = permissionItem[code] === 'Y' ? 'N' : 'Y'
      if (!isEmpty(permissionItem.attrs)) {
        permissionItem.attrs.forEach(item => {
          if (item[code] !== 'P') {
            item[code] = permissionItem[code]
          }
        })
      }
    },
    ciAttrsPermissionsHandler (one, code) {
      one[code] = one[code] === 'Y' ? 'N' : 'Y'
    },
    batchPermission (val, operationType) {
      const value = val ? 'Y' : 'N'
      this.ciTypePermissions.forEach(one => {
        one[operationType] = value
        if (!isEmpty(one.attrs)) {
          one.attrs.forEach(item => {
            if (item[operationType] !== 'P') {
              item[operationType] = value
            }
          })
        }
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
      let res
      if (this.isRolePermissionPage) {
        res = await assignCiTypePermissionForRoleInBatch(
          cloneDeep(this.ciTypePermissions),
          this.currentRoleName
        )
      } else {
        const {statusCode, data} = await getTemplateInfoById(this.roleTemplateId)
        if (statusCode === 'OK') {
          if (isEmpty(data.params)) {
            const params = {
              id: this.roleTemplateId,
              name: this.roleTemplateName,
              configs: cloneDeep(this.ciTypePermissions),
            }
            res = await saveTemplateInfo(params)
          } else {
            const params = {
              id: this.roleTemplateId,
              name: this.roleTemplateName,
              configs: cloneDeep(this.ciTypePermissions),
            }
            await saveTemplateInfo(params)
            this.isTemplateConfigModelShow = true
            this.templateConfigType = 'preview'
            this.selectedTemplateData = []
            this.selectedTemplateItem = ''
            this.processRoleTemplateTableData([data])
          } 
        }
      }
      if (res && res.statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('success')
        })
        this.isRolePermissionPage ? this.getPermissions(true, true, this.currentRoleName) : this.getAllRoleTemplateList(true, this.roleTemplateId)
      }
    },
    cancelPermissionsOperation () {
      this.ciTypePermissions = JSON.parse(JSON.stringify(this.cacheOriginCiTypePermission))
      this.$emit('hideModal')
    },
    async handleUserTransferChange (newTargetKeys, direction, moveKeys) {
      const params = [
        {
          roleName: this.selectedRole,
          userList: moveKeys
        }
      ]
      if (direction === 'right') {
        let { statusCode, message } = await addUsersToRole(params)
        if (statusCode === 'OK') {
          this.$Notice.success({
            title: this.$t('success'),
            desc: message
          })
          this.usersKeyBySelectedRole = newTargetKeys
        }
      } else {
        let { statusCode, message } = await addUsersToRole(params)
        if (statusCode === 'OK') {
          this.$Notice.success({
            title: this.$t('success'),
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
          title: this.$t('success'),
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
          title: this.$t('success'),
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
        let permissions = await getoperationPermissionsByRole(roleOrUser)
        this.spinShow = false
        this.ciTypePermissions = permissions.data.ciTypePermissionObj
        if (queryAfterEditing) {
          this.permissionEntryPointsForEdit = []
          this.menusPermissionSelected(this.menusForEdit, permissions.data.menuPermissions)
        } else {
          this.permissionEntryPoints = []
          this.menusPermissionSelected(this.menus, permissions.data.menuPermissions)
          this.ciTypePermissions = permissions.data.ciTypePermissionObj
        }
      } else {
        if (queryAfterEditing) {
          this.menusPermissionSelected(this.menusForEdit)
        } else {
          this.menusPermissionSelected(this.menus)
          this.ciTypePermissions = []
        }
      }
      this.cacheOriginCiTypePermission = JSON.parse(JSON.stringify(this.ciTypePermissions))
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
    // 点击左侧角色，触发该事件
    async handleRoleClick (checked, rolename) {
      this.spinShow = true
      this.currentCollapseValue = null
      // this.currentRoleId = id;
      this.currentRoleName = rolename
      this.dataPermissionDisabled = false
      this.roles.forEach(_ => {
        _.checked = false
        if (rolename === _.rolename) {
          _.checked = checked
        }
      })
      this.getRoleTemplate(rolename)
      this.getPermissions(false, checked, rolename)
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
        if (this.roles.length) {
          this.handleRoleClick(true, this.roles[0].rolename)
        }
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
    cancel () {},
    confirmUser () {
      if (this.currentRoleName) {
        this.handleRoleClick(true, this.currentRoleName)
      }
    },
    initData () {
      this.currentTabName = 'role'
      this.ciTypePermissions = []
      this.getAllUsers()
      this.getAllRoles()
      this.getAllCis()
    },
    preventEvent (event) {
      event.stopPropagation()
    },
    async addTemplateTableItem(id) {
      if (!id) return
      const {statusCode, data} = await getTemplateInfoById(id)
      if (statusCode === 'OK') {
        this.processRoleTemplateTableData([data])
      }
    },
    async deleteTemplateItem(id) {
      const {statusCode} = await deleteRoleTemplateItem(id)
      if (statusCode === 'OK') {
        this.$Message.success(this.$t('db_operation_successful'))
        this.getAllRoleTemplateList()
      }
    },
    async editTemplateItem(id) {
      this.spinShow = true
      const {statusCode, data} = await getRoleTemplateItemInfo(id)
      if (statusCode === 'OK') {
        this.roleTemplateName = data.name
        this.roleTemplateId = data.id
        this.ciTypePermissions = data.configs
        this.spinShow = false
      }
    },
    async onAddTemplateButtonClick() {
      const name = this.$t('db_permission_template') + +new Date()
      const params = {
        id: '',
        name,
        configs: []
      }
      const {statusCode} = await saveTemplateInfo(params)
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('permission_management_data_creation') + this.$t('db_template') + this.$t('success')
        })
        this.getAllRoleTemplateList()
      }
    },
    // 获取所有的权限列表
    async getAllRoleTemplateList(needEdit = true, id = '') {
      this.roleTemplateLoading = true
      const {data, statusCode} = await getRoleTemplateList()
      if (statusCode === 'OK') {
        this.templateListData = data
        this.roleTemplateLoading = false
        if (!isEmpty(this.templateListData) && needEdit) {
          const getId = id || this.templateListData[0].id
          const item = find(this.templateListData, {id: getId})
          if (item) {
            item._highlight = true
          }
          this.editTemplateItem(getId)
        } else {
          this.templateConfigOptions = this.templateListData.filter(one => !(this.selectedTemplateData.map(item => item.permissionTplName)).includes(one.name))
        }
      }
    },
    // 基于用户角色，来获取该角色的使用模板详情
    async getRoleTemplate(rolename) {
      this.roleName = rolename
      const {statusCode, data} = await getTemplateByRole(rolename, true)
      if (statusCode === 'OK') {
        this.usingTemplateNames = data.map(item => item.permissionTplName)
        this.usingTemplateDetail = data
      }
    },
    // 点击【数据权限】中的【配置模板】button，触发该事件
    onTemplateConfigButtonClick() {
      this.isTemplateConfigModelShow = true
      this.templateConfigType = 'edit'
      this.selectedTemplateData = []
      this.selectedTemplateItem = ''
      this.processRoleTemplateTableData(this.usingTemplateDetail)
    },
    processRoleTemplateTableData(rawData) {
      if (!isEmpty(rawData)) {
        rawData.forEach(item => {
          if (!isEmpty(item.params)) {
            item.params.forEach(one => {
              this.selectedTemplateData.push({
                ...one,
                permissionTplName: item.permissionTplName,
                permissionTplId: item.permissionTplId,
                _checked: true
              })
            })
          } else {
            this.selectedTemplateData.push({
              permissionTplName: item.permissionTplName,
              permissionTplId: item.permissionTplId,
              _checked: true
            })
          }
        })
      }
    },
    // 对模板table中的相同名称的行进行合并
    templateTableSpanMethod({ row, column, rowIndex, columnIndex }) {
      if (['permissionTplName', 'selection'].includes(column.key)) {
        if (rowIndex === 0 || this.selectedTemplateData[rowIndex].permissionTplName !== this.selectedTemplateData[rowIndex - 1].permissionTplName) {
          let count = 1;
          for (let i = rowIndex + 1; i < this.selectedTemplateData.length; i++) {
            if (this.selectedTemplateData[i].permissionTplName === this.selectedTemplateData[rowIndex].permissionTplName) {
              count++;
            } else {
              break;
            }
          }
          return {
            rowspan: count,
            colspan: 1
          };
        } else {
          return {
            rowspan: 0,
            colspan: 0
          };
        }
      }
      return {
        rowspan: 1,
        colspan: 1
      };
    },
    async confirmTemplateModal() {
      if (isEmpty(this.selectedTemplateData)) return
      const allData = cloneDeep(cloneDeep(this.selectedTemplateData)).filter(item => item._checked)
      const groupedData = groupBy(map(allData, item => omit(item, ['_checked'])), 'permissionTplId')
      const params = []
      for(let key in groupedData) {
        params.push({
          permissionTplId: key,
          params: groupedData[key]
        })
      }
      let res
      if (this.isRolePermissionPage) {
        res = await saveRoleTemplate(this.roleName, params)
      } else {
        const allParams = params[0].params
        if (!isEmpty(allParams)) {
          for (let i=0; i<allParams.length; i++) {
            const item = allParams[i]
            if (isEmpty(item.filterParamName)) {
              this.$Message.error(this.$t('db_parameter_name') + this.$t('is_required'))
              return 
            }
          }
        }
        res = await saveTemplateParams(...params)
      }
      if (res.statusCode === 'OK') {
        this.isTemplateConfigModelShow = false
        this.$Message.success(this.$t('db_operation_successful'))
        if (this.isRolePermissionPage) {
          this.getRoleTemplate(this.roleName)
        } else {
          this.getAllRoleTemplateList(true, this.roleTemplateId)
        }
      }
    },
    cancelTemplateModal() {
      this.isTemplateConfigModelShow = false
    },
    onTemplateTableSelectionChange(type, row) {
      if (['selectOne', 'cancelOne'].includes(type)) {
        const id = row.permissionTplId
        this.selectedTemplateData = map(this.selectedTemplateData, item => {
          if (item.permissionTplId === id) {
            return {...item, _checked: type === 'selectOne'}
          }
          return item
        })
      } else {
        this.selectedTemplateData = map(this.selectedTemplateData, item => {
          return {...item, _checked: type === 'allSelect'}
        })
      }
    },
    onListManagementModalClose(flag) {
      if (!flag) {
        this.isRolePermissionPage ? this.getPermissions(false, true, this.currentRoleName) : this.editTemplateItem(this.roleTemplateId)
      }
    },
    onTabsClick(name) {
      if (name !== this.historyCurrentTabName) {
        this.isSecondConfirmationShow = true
      }
    },
    onSecondConfirmationVisibleChange(flag) {
      setTimeout(() => {
        if (!flag) {
          this.historyCurrentTabName = this.currentTabName
          if (this.currentTabName === 'template') {
            this.getAllRoleTemplateList()
          } else {
            this.initData()
          }
        }
      }, 500)
    },
    async onSecondConfirmationOk() {
      let res
      if (this.historyCurrentTabName === 'template') {
        const info = {
          id: this.roleTemplateId,
          name: this.roleTemplateName,
          configs: cloneDeep(this.ciTypePermissions),
        }
        res = await saveTemplateInfo(info)
      } else {
        res = await assignCiTypePermissionForRoleInBatch(
          cloneDeep(this.ciTypePermissions),
          this.currentRoleName
        )
      }
      if (res.statusCode === 'OK') {
        this.$Message.success($t('db_saved_successfully'))
      }
    },
    onPermissionModalVisibleChange(flag) {
      if (!flag) {
        this.isRolePermissionPage ? this.getPermissions(false, true, this.currentRoleName) : this.editTemplateItem(this.roleTemplateId)
        this.cancelEdit()
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.tagContainers-auth {
  overflow: auto;
  height: calc(100vh - 320px);
}
.tagContainers {
  overflow: auto;
  height: calc(100vh - 230px);
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
  cursor: pointer;
  .ivu-tag {
    display: inline-block;
    width: 90%;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  };
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
  margin-right: 15px;
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
    background-color: #5384FF;
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
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-bottom: 5px;
  margin-bottom: 5px;
  border-bottom: 1px solid #5384FF;
}
.batch-operation-btn {
  text-align: right;
  padding-top: 5px;
  margin-top: 8px;
  border-top: 1px solid #5384FF;
}
.ci-attr-style {
  display: flex;
  justify-content: space-between;
  padding: 2px 0;
}
.template-button {
  margin-left: 10px
}
.template-name-edit {
  display: flex;
  align-items: center;
}
.template-name-edit > span {
  margin-right: 10px;
}
</style>

<style lang="scss">
.tagContainers-auth {
  .ivu-collapse-header {
    display: block !important;
  }
}
.role-item {
  .ivu-tag {
    font-size: 14px;
  }
}
</style>
