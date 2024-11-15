<template>
  <div>
    <Row>
      <Col span="10">
        <span style="margin-right: 10px">{{ $t('report') }}</span>
        <Select
          v-model="currentReportId"
          ref="reportSelect"
          filterable
          clearable
          @on-clear="clearSelectedReport"
          @on-change="getReportStruct('')"
          style="width: 75%;"
        >
          <Option v-for="item in reportList" :value="item.id" :key="item.id" :label="item.name">
            {{ item.name }}
          </Option>
        </Select>
      </Col>
      <Col span="14">
        <Button style="margin-left: 65%" type="success" @click="openAddReport">{{ $t('db_add_new_report') }}</Button>
        <Button style="margin: 0 15px" type="primary" @click="editReport" :disabled="!currentReportId">{{
          $t('configuration')
        }}</Button>
        <Poptip confirm transfer :title="$t('db_delConfirm_tip')" placement="left-end" @on-ok="deleteReport">
          <Button type="error" :disabled="!currentReportId">{{ $t('delete') }}</Button>
        </Poptip>
      </Col>
    </Row>
    <div v-if="ciGraphData" class="graph-content">
      <div style="display: flex">
        <div style="width: 50%">
          <div class="graph-title">
            <standard-title :title="$t('db_report_display')"></standard-title>
            <div class="report-create-info" style="margin-left: 5px; margin-top: 5px">
              <span>{{ $t('db_creator') + ': ' + allStructData.createUser }}</span>
              <span>{{ $t('db_creation_time') + ': ' + allStructData.createTime }}</span>
              <span>{{ $t('db_editor') + ': ' + allStructData.updateUser }}</span>
              <span>{{ $t('db_update_time') + ': ' + allStructData.updateTime }}</span>
            </div>
          </div>
        </div>
        <div class="title-right">
          <div class="split-line"></div>
          <div class="graph-title">
            <standard-title :title="$t('db_ci_configuration')"></standard-title>
          </div>
        </div>
      </div>
      <CiGraph
        :recordClickNodeId="recordClickNodeId"
        :editorBoxInRight="true"
        :ciGraphData="ciGraphData"
        :attributeObject="attributeObject"
        :currentReportId="currentReportId"
        @onRefresh="getReportStruct"
      />
    </div>
    <Modal
      v-model="newReport.showAddNewReportModal"
      width="720"
      :title="newReport.isAdd ? $t('creat_report') : $t('edit_report')"
      :mask-closable="false"
      @on-visible-change="onModalVisibleChange"
    >
      <div :style="{ maxHeight: MODALHEIGHT + 'px', overflow: 'auto' }">
        <Form class="report-form" :model="newReport.params" ref="reportForm" :rules="ruleValidate" :label-width="120">
          <FormItem :label="$t('report_id')" prop="id">
            <Input v-model="newReport.params.id" :disabled="!newReport.isAdd"></Input>
          </FormItem>
          <FormItem :label="$t('report_name')" prop="name">
            <Input v-model="newReport.params.name"></Input>
          </FormItem>
          <FormItem label="CI" prop="ciType">
            <Select v-model="newReport.params.ciType" filterable clearable :disabled="!newReport.isAdd">
              <template v-for="item in newReport.allCiTypes">
                <Option :value="item.ciTypeId" :key="item.ciTypeId">{{ item.name }}</Option>
              </template>
            </Select>
          </FormItem>
          <FormItem :label="$t('data_name')" prop="dataName">
            <Input v-model="newReport.params.dataName"></Input>
          </FormItem>
          <FormItem :label="$t('data_title_name')" prop="dataTitleName">
            <Input v-model="newReport.params.dataTitleName"></Input>
          </FormItem>
        </Form>
        <div>
          <div class="role-transfer-title"><span style="color: red">*</span> {{ $t('mgmt_role') }}</div>
          <Transfer
            :titles="transferTitles"
            :list-style="transferStyle"
            :data="allRoles"
            :target-keys="MGMT"
            @on-change="handleMgmtRoleTransferChange"
            filterable
          ></Transfer>
        </div>
        <div style="margin-top: 30px">
          <div class="role-transfer-title"><span style="color: red">*</span> {{ $t('use_role') }}</div>
          <Transfer
            :titles="transferTitles"
            :list-style="transferStyle"
            :data="allRolesBackUp"
            :target-keys="USE"
            @on-change="handleUseRoleTransferChange"
            filterable
          ></Transfer>
        </div>
      </div>
      <div slot="footer">
        <Button @click="cancelNewReport">{{ $t('cancel') }}</Button>
        <Button type="primary" @click="addNewReport">{{ $t('save') }}</Button>
      </div>
    </Modal>
  </div>
</template>

<script>
import { isEmpty } from 'lodash'
import CiGraph from '../components/ci-graph.js'
import standardTitle from '../components/standard-title.vue'
import {
  getAllCITypes,
  addReport,
  getReportListByPermission,
  getReportStruct,
  deleteReport,
  getRolesByCurrentUser,
  editReport,
  getReportDetail,
  getAllRoles,
  getCiTypeNameMap
} from '@/api/server'
export default {
  data () {
    return {
      currentReportId: '',
      reportList: [],
      newReport: {
        showAddNewReportModal: false,
        isAdd: true,
        params: {
          id: '',
          name: '',
          ciType: '',
          dataName: '',
          dataTitleName: ''
        },
        allCiTypes: []
      },
      allRoles: [],
      MGMT: [],
      allRolesBackUp: [],
      USE: [],
      transferTitles: [this.$t('unselected_role'), this.$t('selected_role')],
      transferStyle: { width: '300px' },

      ciGraphData: null,
      attributeObject: {},
      MODALHEIGHT: 500,
      allStructData: null,
      oriDataMap: {},
      ruleValidate: {
        id: [
          {
            type: 'string',
            required: true,
            message: '请输入id',
            trigger: 'blur'
          }
        ],
        name: [
          {
            type: 'string',
            required: true,
            message: '请输入',
            trigger: 'blur'
          }
        ],
        ciType: [
          {
            type: 'string',
            required: true,
            message: '请选择',
            trigger: 'blur'
          }
        ],
        dataName: [
          {
            type: 'string',
            required: true,
            message: '请输入',
            trigger: 'blur'
          }
        ],
        dataTitleName: [
          {
            type: 'string',
            required: true,
            message: '请输入',
            trigger: 'blur'
          }
        ]
      },
      recordClickNodeId: ''
    }
  },
  async mounted () {
    // this.MODALHEIGHT = window.MODALHEIGHT
    const { data, statusCode } = await getCiTypeNameMap()
    if (statusCode === 'OK') {
      this.oriDataMap = data
    }
  },
  async created () {
    await this.getReportList()
  },
  methods: {
    async editReport () {
      const { statusCode, data } = await getReportDetail(this.currentReportId)
      if (statusCode === 'OK') {
        const res = await getAllCITypes()
        if (res.statusCode === 'OK') {
          this.newReport.allCiTypes = res.data
        }
        await this.getRolesByCurrentUser()
        await this.getRoleList()
        this.newReport.params.id = data.id
        this.newReport.params.name = data.name
        this.newReport.params.ciType = data.ciType
        this.newReport.params.dataName = data.dataName
        this.newReport.params.dataTitleName = data.dataTitleName
        this.MGMT = data.mgmtRoleList
        this.USE = data.useRoleList
        this.newReport.isAdd = false
        this.newReport.showAddNewReportModal = true
      }
    },
    clearSelectedReport () {
      this.currentReportId = ''
      this.ciGraphData = null
      this.attrs = []
    },
    showData () {
      this.$refs.test.showData()
    },
    async getReportList (needGetCurrentReportId = true) {
      return new Promise(async resolve => {
        this.reportList = []
        const { statusCode, data } = await getReportListByPermission('MGMT')
        if (statusCode === 'OK') {
          this.reportList = data
          if (needGetCurrentReportId && !isEmpty(this.reportList)) {
            setTimeout(() => {
              if (this.$route.query.reportId) {
                this.currentReportId = this.$route.query.reportId
                window.history.replaceState(
                  {},
                  document.title,
                  window.location.origin + window.location.pathname + window.location.hash.split('?')[0]
                )
              } else {
                this.currentReportId = this.reportList[0].id
              }
              this.getReportStruct()
            }, 50)
          }
          resolve(this.reportList)
        }
      })
    },
    async getReportStruct (nodeId = '') {
      this.recordClickNodeId = nodeId
      this.$refs.reportSelect.visible = false
      this.ciGraphData = null
      const { statusCode, data } = await getReportStruct(this.currentReportId)
      if (statusCode === 'OK') {
        this.allStructData = data
        this.ciGraphData = this.formatAttr(data.object)[0]
        this.attrs = this.calCiTypeAttrs(data.object)
      }
    },
    calCiTypeAttrs (cis) {
      const ret = []
      let helper = root => {
        if (!root) return
        if (root.attr && root.attr.length) {
          ret.push({
            label: root.dataTitleName,
            attrList: root.attr.map((_, i) => {
              return {
                ciTypeAttrId: _.id,
                name: _.dataTitleName,
                attrKeyName: _.dataName
              }
            })
          })
        }
        if (root.children) {
          root.children.map(child => helper(child))
        }
      }

      helper(cis)
      return ret
    },
    formatAttr (data) {
      return data.map(_ => {
        let result = {
          ..._,
          attributeList: _.attr
            ? _.attr.map((attrId, index) => {
              let _result = {
                ciTypeAttrId: attrId.id
              }
              _result.name = _.dataTitleName
              _result.attrKeyName = _.dataName
              this.attributeObject[attrId.id] = _result
              return _result
            })
            : []
        }
        if (_.object instanceof Array) {
          result.object = this.formatAttr(_.object)
        }
        return result
      })
    },
    async deleteReport () {
      const { statusCode, data } = await deleteReport(this.currentReportId)
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('success'),
          desc: data
        })
        await this.getReportList()
      }
    },
    async openAddReport () {
      this.newReport.params.id = ''
      this.newReport.params.name = ''
      this.newReport.params.ciType = ''
      this.newReport.params.dataName = this.allStructData.ciType
      this.newReport.params.dataTitleName = this.oriDataMap[this.allStructData.ciType]
      this.USE = []
      this.MGMT = []
      this.$refs.reportSelect.visible = false
      const { statusCode, data } = await getAllCITypes()
      if (statusCode === 'OK') {
        this.newReport.allCiTypes = data
      }
      await this.getRolesByCurrentUser()
      await this.getRoleList()
      this.newReport.showAddNewReportModal = true
      this.newReport.isAdd = true
    },
    async getRolesByCurrentUser () {
      const { statusCode, data } = await getRolesByCurrentUser()
      if (statusCode === 'OK') {
        this.allRoles = data.map(_ => {
          return {
            ..._,
            key: _.roleName,
            label: _.description
          }
        })
      }
    },
    async getRoleList () {
      const { statusCode, data } = await getAllRoles()
      if (statusCode === 'OK') {
        this.allRolesBackUp = data.map(_ => {
          return {
            ..._,
            key: _.roleName,
            label: _.description
          }
        })
      }
    },
    async handleMgmtRoleTransferChange (newTargetKeys, direction, moveKeys) {
      this.MGMT = newTargetKeys
    },
    async handleUseRoleTransferChange (newTargetKeys, direction, moveKeys) {
      this.USE = newTargetKeys
    },
    async beforeSaveValid () {
      const validResult = await this.$refs.reportForm.validate()
      let isRoleValidPass = true
      if (isEmpty(this.USE) || isEmpty(this.MGMT)) {
        this.$Message.error(this.$t('db_role_valid_tips'))
        isRoleValidPass = false
      }
      return new Promise(resolve => {
        resolve(validResult && isRoleValidPass)
      })
    },
    async addNewReport () {
      if (await this.beforeSaveValid()) {
        this.newReport.params.useRole = this.USE.join(',')
        this.newReport.params.mgmtRole = this.MGMT.join(',')
        const method = this.newReport.isAdd ? addReport : editReport
        const { statusCode, data } = await method(this.newReport.params)
        if (statusCode === 'OK') {
          this.cancelNewReport()
          await this.getReportList(false)
          this.currentReportId = data.id
          this.getReportStruct()
        }
      }
    },
    cancelNewReport () {
      this.$refs.reportForm.resetFields()
      this.newReport.showAddNewReportModal = false
    },
    onModalVisibleChange (state) {
      if (!state) {
        this.cancelNewReport()
      }
    }
  },
  components: {
    CiGraph,
    standardTitle
  }
}
</script>
<style lang="scss">
.report-form > div {
  margin-bottom: 20px;
}
</style>
<style lang="scss" scoped>
.graph-content {
  height: calc(100vh - 170px);
  margin-top: 20px;
  // border: 1px solid #e8eaec;
  .graph-title {
    margin-left: 15px;
    margin-top: 10px;
    .report-create-info {
      margin-left: 5px;
      margin-top: 5px;
    }
    .report-create-info > span {
      margin-right: 10px;
    }
  }
  .title-right {
    width: 50%;
    position: relative;
    .split-line {
      position: absolute;
      top: 0;
      left: 0;
      width: 1px;
      height: calc(100vh - 170px);
      background-color: #bbbbbb;
    }
  }
}
.role-transfer-title {
  text-align: center;
  font-size: 13px;
  font-weight: 700;
  background-color: rgb(226, 222, 222);
  margin-bottom: 5px;
}
</style>
