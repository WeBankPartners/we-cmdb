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
          style="width: 75%;"
        >
          <Button type="success" style="width:100%" @click="openAddReport" size="small">
            <Icon type="ios-add" size="24"></Icon>
          </Button>
          <Option v-for="item in reportList" :value="item.id" :key="item.id"
            >{{ item.name
            }}<span style="float:right">
              <Button @click="editReport(item)" icon="ios-create-outline" type="primary" size="small"></Button>
              <Button @click="deleteReport(item)" icon="ios-trash" type="error" size="small"></Button>
            </span>
          </Option>
        </Select>
        <Button type="primary" @click="getReportStruct" :disabled="!currentReportId">{{ $t('query') }}</Button>
      </Col>
    </Row>
    <Row v-if="ciGraphData" style="margin-top: 20px;">
      <Row>
        <Card>
          <CiGraph
            :ciGraphData="ciGraphData"
            :attributeObject="attributeObject"
            :currentReportId="currentReportId"
            @onRefresh="getReportStruct"
          />
        </Card>
      </Row>
    </Row>
    <Modal
      v-model="newReport.showAddNewReportModal"
      width="720"
      :title="newReport.isAdd ? $t('creat_report') : $t('edit_report')"
      :mask-closable="false"
    >
      <div :style="{ maxHeight: MODALHEIGHT + 'px', overflow: 'auto' }">
        <Form :model="newReport.params" :label-width="80">
          <FormItem :label="$t('report_id')">
            <Input v-model="newReport.params.id" :disabled="!newReport.isAdd"></Input>
          </FormItem>
          <FormItem :label="$t('report_name')">
            <Input v-model="newReport.params.name" :disabled="!newReport.isAdd"></Input>
          </FormItem>
          <FormItem label="CI">
            <Select v-model="newReport.params.ciType" filterable :disabled="!newReport.isAdd">
              <template v-for="item in newReport.allCiTypes">
                <Option :value="item.ciTypeId" :key="item.ciTypeId">{{ item.name }}</Option>
              </template>
            </Select>
          </FormItem>
          <FormItem :label="$t('data_name')">
            <Input v-model="newReport.params.dataName" :disabled="!newReport.isAdd"></Input>
          </FormItem>
          <FormItem :label="$t('data_title_name')">
            <Input v-model="newReport.params.dataTitleName" :disabled="!newReport.isAdd"></Input>
          </FormItem>
        </Form>
        <div>
          <div class="role-transfer-title">{{ $t('mgmt_role') }}</div>
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
          <div class="role-transfer-title">{{ $t('use_role') }}</div>
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
        <Button @click="newReport.showAddNewReportModal = false">{{ $t('cancel') }}</Button>
        <Button type="primary" @click="addNewReport">{{ $t('save') }}</Button>
      </div>
    </Modal>
  </div>
</template>

<script>
import CiGraph from '../components/ci-graph.js'
import {
  getAllCITypes,
  addReport,
  getReportListByPermission,
  getReportStruct,
  deleteReport,
  getRolesByCurrentUser,
  editReport,
  getReportDetail,
  getAllRoles
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
      MODALHEIGHT: 600
    }
  },
  mounted () {
    this.MODALHEIGHT = window.MODALHEIGHT
  },
  created () {
    this.getReportList()
  },
  methods: {
    async editReport (report) {
      const { statusCode, data } = await getReportDetail(report.id)
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
    async getReportList () {
      this.reportList = []
      const { statusCode, data } = await getReportListByPermission('MGMT')
      if (statusCode === 'OK') {
        this.reportList = data
      }
    },
    async getReportStruct () {
      this.$refs.reportSelect.visible = false
      this.ciGraphData = null
      const { statusCode, data } = await getReportStruct(this.currentReportId)
      if (statusCode === 'OK') {
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
    async deleteReport (report) {
      this.$Modal.confirm({
        title: this.$t('delete_confirm'),
        'z-index': 1000000,
        onOk: async () => {
          const { statusCode, data } = await deleteReport(report.id)
          if (statusCode === 'OK') {
            this.$Notice.success({
              title: this.$t('success'),
              desc: data
            })
            this.currentReportId = ''
            this.getReportList()
          }
        },
        onCancel: () => {}
      })
      document.querySelector('.ivu-modal-mask').click()
    },
    async openAddReport () {
      this.newReport.params.id = ''
      this.newReport.params.name = ''
      this.newReport.params.ciType = ''
      this.newReport.params.dataName = ''
      this.newReport.params.dataTitleName = ''
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
    async addNewReport () {
      this.newReport.params.useRole = this.USE.join(',')
      this.newReport.params.mgmtRole = this.MGMT.join(',')
      const method = this.newReport.isAdd ? addReport : editReport
      const { statusCode, data } = await method(this.newReport.params)
      if (statusCode === 'OK') {
        this.newReport.showAddNewReportModal = false
        this.currentReportId = data.id
        this.getReportList()
        this.getReportStruct()
      }
    },
    cancelNewReport () {
      this.newReport.showAddNewReportModal = false
    },
    onReportChange () {}
  },
  components: {
    CiGraph
  }
}
</script>
<style lang="scss">
.role-transfer-title {
  text-align: center;
  font-size: 13px;
  font-weight: 700;
  background-color: rgb(226, 222, 222);
  margin-bottom: 5px;
}
</style>
