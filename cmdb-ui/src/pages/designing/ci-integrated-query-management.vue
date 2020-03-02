<template>
  <div>
    <Row>
      <Col span="6">
        <span style="margin-right: 10px">{{ $t('root_ci_type') }}</span>
        <Select v-model="selectedCI.id" filterable style="width: 75%;" @on-change="onCITypeChange">
          <Option v-for="item in allCiTypes" :value="item.ciTypeId" :key="item.ciTypeId">{{ item.name }}</Option>
        </Select>
      </Col>
      <Col span="10" offset="1">
        <span style="margin-right: 10px">{{ $t('integrated_query_name') }}</span>
        <Select
          v-model="selectedQuery.id"
          filterable
          style="width: 75%;"
          :disabled="!selectedCI.id"
          @on-change="onQueryNameSelectChange"
        >
          <Option
            v-for="(item, index) in queryNameList"
            style="overflow:hidden;line-height:24px;"
            :value="item.id"
            :key="item.id"
            >{{ item.name }}
            <span v-if="index === 0">
              <Button
                @click.stop.prevent="createIntQuery(item)"
                v-if="index === 0"
                icon="md-add"
                type="success"
                long
              ></Button>
            </span>
            <span v-else style="float:right">
              <Button @click.stop.prevent="deleteIntQuery(item)" icon="ios-trash" type="error" size="small"></Button>
            </span>
          </Option>
        </Select>
      </Col>
      <Col span="6" offset="1">
        <Button :disabled="!isNewIntQuery" @click="newGraphNameModalVisible = true">{{ $t('create') }}</Button>
        <Button :disabled="saveBtnDisable || isNewIntQuery" @click="saveGraph('update')" :loading="updateLoading">{{
          $t('update')
        }}</Button>
        <Modal
          v-model="newGraphNameModalVisible"
          :title="$t('add_integrated_query_name')"
          @on-ok="saveGraph('create')"
          @on-cancel="() => {}"
        >
          <Input v-model="newGraphName" :placeholder="$t('input_placeholder')" />
        </Modal>
      </Col>
    </Row>
    <Row v-if="ciGraphData" style="margin-top: 20px;">
      <Row>
        <Card>
          <CiGraph :ciGraphData="ciGraphData" @onChange="handleCiGraphChange" />
        </Card>
      </Row>
      <Row style="margin-top: 20px">
        <Card>
          <Row class="attrs" v-for="attr in attrs" :key="attr.label">
            <h4>{{ attr.label }}</h4>
            <Tag type="dot" color="primary" v-for="item in attr.attrList" :key="item">{{ item }}</Tag>
          </Row>
        </Card>
      </Row>
    </Row>
  </div>
</template>

<script>
import {
  getAllCITypes,
  getQueryNames,
  fetchIntQueryById,
  saveIntQuery,
  updateIntQuery,
  deleteIntQuery
} from '@/api/server'
import CiGraph from '../components/ci-graph.js'
export default {
  components: { CiGraph },
  data () {
    return {
      isNewIntQuery: false,
      selectedCI: {
        id: 0,
        value: ''
      },
      allCiTypes: [],
      selectedQuery: {
        id: 0,
        value: ''
      },
      queryNameList: [{ id: 100000, name: '' }],
      ciGraphData: null,
      attrs: [],
      saveBtnDisable: true,
      newGraphNameModalVisible: false,
      newGraphName: '',
      ciGraphResult: null,
      updateLoading: false
    }
  },
  created () {
    this.getAllCITypes()
  },
  methods: {
    async getAllCITypes () {
      let { statusCode, data } = await getAllCITypes()
      if (statusCode === 'OK') {
        this.allCiTypes = data
      }
    },
    onCITypeChange (value) {
      this.getQueryNameList(value)
    },
    async onQueryNameSelectChange (value) {
      this.ciGraphData = null
      this.isNewIntQuery = false
      if (!value) {
        return
      }
      const { statusCode, data } = await fetchIntQueryById(this.selectedCI.id, value)
      if (statusCode === 'OK') {
        this.attrs = this.calCiTypeAttrs(data)
        this.ciGraphData = data
      }
    },
    calCiTypeAttrs (cis) {
      const ret = []
      let helper = root => {
        if (!root) return
        if (root.attrAliases && root.attrAliases.length) {
          ret.push({ label: root.name, attrList: root.attrAliases })
        }
        if (root.children) {
          root.children.map(child => helper(child))
        }
      }

      helper(cis)
      return ret
    },

    handleCiGraphChange (data) {
      this.saveBtnDisable = false
      this.ciGraphResult = data
      this.attrs =
        Object.keys(data).reduce((pre, cur) => {
          if (data[cur].node.attrs && data[cur].node.attrs.length) {
            return pre.concat({
              label: data[cur].node.label,
              attrList: data[cur].node.attrs.map((_, index) => (_.name ? _.name : data[cur].node.attrAliases[index]))
            })
          } else {
            return pre
          }
        }, []) || []
    },
    treeifyCiTypes () {
      const { ciGraphResult } = this
      if (!ciGraphResult) {
        return null
      }
      const key = Object.keys(ciGraphResult).filter(key => ciGraphResult[key].node.index === 1)
      const rootNode = ciGraphResult[key]
      function treefiy (root) {
        if (!root.from.length && !root.to.length) {
          return {
            ciTypeId: root.node.ciTypeId,
            name: root.node.label,
            attrs: root.node.attrs ? root.node.attrs.map(_ => _ && _.ciTypeAttrId) : [],
            attrAliases: root.node.attrs
              ? root.node.attrs.map((_, index) => (_.name ? _.name : root.node.attrAliases[index]))
              : []
          }
        }
        const t = {
          children: [],
          ciTypeId: root.node.ciTypeId,
          name: root.node.label,
          attrs: root.node.attrs ? root.node.attrs.map(_ => _ && _.ciTypeAttrId) : [],
          attrAliases: root.node.attrs.map((_, index) => (_.name ? _.name : root.node.attrAliases[index]))
        }

        if (root.to) {
          t.children = [].concat(
            root.to.map(_ => {
              if (ciGraphResult[_.label]) {
                const ret = treefiy(ciGraphResult[_.label])
                return {
                  attrs: _.attrs ? _.attrs.map(attr => attr && attr.ciTypeAttrId) : [],
                  attrAliases: _.attrs ? _.attrs.map(_ => _ && _.name) : [],
                  ...ret,
                  parentRs: {
                    attrId: _.refPropertyId,
                    isReferedFromParent: true
                  }
                }
              } else {
                return {
                  ciTypeId: _.ciTypeId,
                  name: _.label,
                  attrs: _.attrs ? _.attrs.map(attr => attr && attr.ciTypeAttrId) : [],
                  attrAliases: _.attrs ? _.attrs.map(attr => attr && attr.name) : [],
                  parentRs: {
                    attrId: _.refPropertyId,
                    isReferedFromParent: true
                  }
                }
              }
            })
          )
        }

        if (root.from) {
          t.children = t.children.concat(
            root.from.map(_ => {
              if (ciGraphResult[_.label]) {
                const ret = treefiy(ciGraphResult[_.label])
                return {
                  attrs: _.attrs ? _.attrs.map(attr => attr && attr.ciTypeAttrId) : [],
                  attrAliases: _.attrs ? _.attrs.map(attr => attr && attr.name) : [],
                  ...ret,
                  parentRs: {
                    attrId: _.refPropertyId,
                    isReferedFromParent: false
                  }
                }
              } else {
                return {
                  ciTypeId: _.ciTypeId,
                  name: _.label,
                  attrs: _.attrs ? _.attrs.map(attr => attr && attr.ciTypeAttrId) : [],
                  attrAliases: _.attrs ? _.attrs.map(attr => attr && attr.name) : [],
                  parentRs: {
                    attrId: _.refPropertyId,
                    isReferedFromParent: false
                  }
                }
              }
            })
          )
        }

        return t
      }

      return treefiy(rootNode)
    },
    async deleteIntQuery (item) {
      this.$Modal.confirm({
        title: this.$t('delete_integrated_query'),
        'z-index': 1000000,
        content: `<p>${this.$t('delete_confirm')}</p>`,
        onOk: async () => {
          const { statusCode } = await deleteIntQuery(this.selectedCI.id, item.id)
          if (statusCode === 'OK') {
            this.$Notice.success({
              title: 'DeleteIntQuery Success',
              desc: 'DeleteIntQuery Success'
            })
            this.getQueryNameList(this.selectedCI.id)
          }
        },
        onCancel: () => {}
      })
      document.querySelector('.ivu-modal-mask').click()
    },
    createIntQuery () {
      if (this.selectedCI.id) {
        const found = this.allCiTypes.find(_ => _.ciTypeId === this.selectedCI.id)
        this.ciGraphData = {
          name: found.name,
          ciTypeId: found.ciTypeId,
          children: []
        }
        this.isNewIntQuery = true
        this.attrs = []
      }
      document.querySelector('.content-container').click()
    },
    async saveGraph (type) {
      const reqData = this.treeifyCiTypes()
      if (!reqData) {
        this.$Notice.warning({
          title: 'Warning',
          desc: this.$t('unreasonable_delete_integrated_tips')
        })
      } else {
        if (type === 'update') {
          this.updateLoading = true
        }
        const { statusCode, message } = this.isNewIntQuery
          ? await saveIntQuery(this.selectedCI.id, this.newGraphName, reqData)
          : await updateIntQuery(this.selectedQuery.id, reqData)
        this.updateLoading = false
        if (statusCode === 'OK') {
          this.$Notice.success({
            title: 'Success',
            desc: message
          })
          if (this.isNewIntQuery) {
            this.getQueryNameList(this.selectedCI.id)
          }
        }
      }
    },
    reset () {
      this.queryNameList = [{ id: 100000, name: '' }]
      this.selectedQuery = { id: 0, value: '' }
    },
    async getQueryNameList (ciTypeId) {
      this.reset()
      const { statusCode, data } = await getQueryNames(ciTypeId)
      if (statusCode === 'OK') {
        this.queryNameList = this.queryNameList.concat(data)
      }
    }
  }
}
</script>

<style lang="scss" scoped></style>
