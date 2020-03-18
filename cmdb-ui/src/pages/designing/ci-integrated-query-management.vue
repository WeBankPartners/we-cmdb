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
        <Button :disabled="saveBtnDisable || isNewIntQuery" @click="beforeUpdateGraph()" :loading="updateLoading">{{
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
          <CiGraph
            :ciGraphData="ciGraphData"
            :attributeObject="attributeObject"
            @onChange="handleCiGraphChange"
            @onMounted="updateGraphData"
          />
        </Card>
      </Row>
      <Row style="margin-top: 20px">
        <Card>
          <Row v-if="attrs.length" style="margin-bottom: 10px;">
            <Button style="margin-right: 10px;" @click="showKeyNameModal">{{ $t('change_key_name') }}</Button>
            <span>{{ $t('show_key_name') }}</span>
            <i-switch size="small" v-model="isShowAttrKeyNames" />
          </Row>
          <Row class="attrs" v-for="attr in attrs" :key="attr.label">
            <h4>{{ attr.label }}</h4>
            <Tag type="dot" color="primary" v-for="item in attr.attrList" :key="item.name">{{
              isShowAttrKeyNames && !!item.attrKeyName ? `${item.name}(${item.attrKeyName})` : item.name
            }}</Tag>
          </Row>
        </Card>
      </Row>
    </Row>
    <Modal :title="$t('change_key_name')" :mask-closable="false" v-model="iskeyNameModalShow" width="600">
      <Form class="key-name-form" :rules="ruleValidate" ref="form">
        <div v-for="item in formAttrs" :key="item.label">
          <h4>{{ item.label }}</h4>
          <FormItem
            class="validation-form"
            v-for="attr in item.attrList"
            :key="attr.name"
            :label="attr.name"
            :prop="attr.ciTypeAttrId + ''"
            label-position="right"
            :label-width="80"
          >
            <Input v-model="attr.attrKeyName"></Input>
          </FormItem>
        </div>
      </Form>
      <div slot="footer">
        <Button type="primary" @click="changeKeyName">{{ $t('confirm') }}</Button>
        <Button @click="closeKeyNameModal">{{ $t('cancel') }}</Button>
      </div>
    </Modal>
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
      formAttrs: [],
      saveBtnDisable: true,
      newGraphNameModalVisible: false,
      newGraphName: '',
      ciGraphResult: null,
      updateLoading: false,
      isShowAttrKeyNames: true,
      iskeyNameModalShow: false,
      ruleValidate: {},
      attributeObject: {},
      needToUpdate: false
    }
  },
  computed: {
    attrsList () {
      let arr = []
      this.formAttrs.forEach(ciType => {
        if (ciType.attrList instanceof Array) {
          ciType.attrList.forEach(attr => {
            arr.push(attr)
          })
        }
      })
      return arr
    },
    attrsObject () {
      let obj = {}
      this.attrs.forEach(ciType => {
        obj[ciType.label] = ciType.attrList || []
      })
      return obj
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
        this.attributeObject = {}
        this.ciGraphData = this.formatAttr([data])[0]
        this.attrs = this.calCiTypeAttrs(data)
      }
      this.isShowAttrKeyNames = true
    },
    calCiTypeAttrs (cis) {
      const ret = []
      let helper = root => {
        if (!root) return
        if (root.attrs && root.attrs.length) {
          ret.push({
            label: root.name,
            attrList: root.attrs.map((_, i) => {
              return {
                ciTypeAttrId: _,
                name: this.attributeObject[_] ? this.attributeObject[_].name : '',
                attrKeyName: this.attributeObject[_] ? this.attributeObject[_].attrKeyName : ''
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
          attributeList: _.attrs.map((attrId, index) => {
            let _result = {
              ciTypeAttrId: attrId
            }
            if (_.attrAliases instanceof Array && _.attrAliases[index]) {
              _result.name = _.attrAliases[index]
            }
            if (_.attrKeyNames instanceof Array && _.attrKeyNames[index]) {
              _result.attrKeyName = _.attrKeyNames[index]
            }
            this.attributeObject[attrId] = _result
            return _result
          })
        }
        if (_.children instanceof Array) {
          result.children = this.formatAttr(_.children)
        }
        return result
      })
    },

    handleCiGraphChange (data) {
      this.saveBtnDisable = false
      this.updateGraphData(data)
    },
    updateGraphData (data) {
      this.ciGraphResult = data
      this.attrs =
        Object.keys(data).reduce((pre, cur) => {
          if (data[cur].node.attributeList && data[cur].node.attributeList.length) {
            return pre.concat({
              label: data[cur].node.label,
              attrList: data[cur].node.attributeList.map(_ => {
                return {
                  ciTypeAttrId: _.ciTypeAttrId,
                  attrKeyName: _.attrKeyName,
                  name: _.name
                }
              })
            })
          } else {
            return pre
          }
        }, []) || []
    },
    treeifyCiTypes () {
      const { ciGraphResult, attrsObject } = this
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
            attrs: attrsObject[root.node.label].map(_ => _.ciTypeAttrId),
            attrAliases: attrsObject[root.node.label].map(_ => _.name),
            attrKeyNames: attrsObject[root.node.label].map(_ => _.attrKeyName)
          }
        }
        const t = {
          children: [],
          ciTypeId: root.node.ciTypeId,
          name: root.node.label,
          attrs: attrsObject[root.node.label].map(_ => _.ciTypeAttrId),
          attrAliases: attrsObject[root.node.label].map(_ => _.name),
          attrKeyNames: attrsObject[root.node.label].map(_ => _.attrKeyName)
        }

        if (root.to) {
          t.children = [].concat(
            root.to.map(_ => {
              if (ciGraphResult[_.label]) {
                const ret = treefiy(ciGraphResult[_.label])
                return {
                  attrs: attrsObject[_.label].map(_ => _.ciTypeAttrId),
                  attrAliases: attrsObject[_.label].map(_ => _.name),
                  attrKeyNames: attrsObject[_.label].map(_ => _.attrKeyName),
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
                  attrs: attrsObject[_.label].map(_ => _.ciTypeAttrId),
                  attrAliases: attrsObject[_.label].map(_ => _.name),
                  attrKeyNames: attrsObject[_.label].map(_ => _.attrKeyName),
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
                  attrs: attrsObject[_.label].map(_ => _.ciTypeAttrId),
                  attrAliases: attrsObject[_.label].map(_ => _.name),
                  attrKeyNames: attrsObject[_.label].map(_ => _.attrKeyName),
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
                  attrs: attrsObject[_.label].map(_ => _.ciTypeAttrId),
                  attrAliases: attrsObject[_.label].map(_ => _.name),
                  attrKeyNames: attrsObject[_.label].map(_ => _.attrKeyName),
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
      this.selectedQuery = {
        id: 0,
        value: ''
      }
      if (this.selectedCI.id) {
        const found = this.allCiTypes.find(_ => _.ciTypeId === this.selectedCI.id)
        this.ciGraphData = {
          name: found.name,
          ciTypeId: found.ciTypeId,
          children: []
        }
        this.isNewIntQuery = true
        this.isShowAttrKeyNames = false
        this.attrs = []
        this.attributeObject = {}
      }
      document.querySelector('.content-container').click()
    },
    beforeUpdateGraph () {
      this.formAttrs = JSON.parse(JSON.stringify(this.attrs))
      let validator = true
      this.attrsList.reduce((pre, cur) => {
        if (pre.indexOf(cur) >= 0 || !cur.attrKeyName) {
          validator = false
        }
        return pre.concat(cur.attrKeyName)
      }, [])
      if (validator) {
        this.saveGraph('update')
      } else {
        this.needToUpdate = true
        this.showKeyNameModal()
      }
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
    },
    showKeyNameModal () {
      this.ruleValidate = {}
      this.formData = {}
      this.formAttrs = JSON.parse(JSON.stringify(this.attrs))
      this.formAttrs.forEach(_ => {
        this.formData[_.label] = _.attrList
        if (_.attrList instanceof Array) {
          _.attrList.forEach(attr => {
            this.ruleValidate[attr.ciTypeAttrId] = [
              { validator: (rule, value, callback) => this.formValidator(attr, callback), trigger: 'blur' }
            ]
            this.formData[attr.ciTypeAttrId] = attr
          })
        }
      })
      this.iskeyNameModalShow = true
    },
    formValidator (attr, callback) {
      const found = this.attrsList.find(
        _ => (_.ciTypeAttrId !== attr.ciTypeAttrId && _.attrKeyName === attr.attrKeyName) || !attr.attrKeyName
      )
      if (found) {
        return callback(new Error(this.$t('keyname_should_be_unique')))
      } else {
        return callback()
      }
    },
    closeKeyNameModal () {
      this.iskeyNameModalShow = false
      this.formData = {}
      this.formAttrs = []
      this.needToUpdate = false
    },
    changeKeyName () {
      this.$refs.form.validate(vaild => {
        if (vaild) {
          this.attrs = JSON.parse(JSON.stringify(this.formAttrs))
          this.isShowAttrKeyNames = true
          this.iskeyNameModalShow = false
          this.saveBtnDisable = false
          this.attributeObject = {}
          this.attrsList.forEach(_ => {
            this.attributeObject[_.ciTypeAttrId] = {
              ciTypeAttrId: _.ciTypeAttrId,
              name: _.name,
              attrKeyName: _.attrKeyName
            }
          })
          if (this.needToUpdate === true) {
            this.saveGraph('update')
            this.needToUpdate = false
          }
        } else {
          this.$Message.error(this.$t('keyname_should_be_unique'))
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.key-name-form {
  height: 60vh;
  overflow-y: auto;
  width: 100%;
}
.validation-form {
  margin-bottom: 12px;
}
.validation-form /deep/ .ivu-form-item-error-tip {
  padding-top: 0;
}
</style>
