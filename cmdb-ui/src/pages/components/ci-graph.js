import vis from 'vis'
import { getRefCiTypeFrom, getCiTypeAttr, configReport, getCiTypeNameMap } from '@/api/server'
import './ci-graph.scss'
import Attrs from './attr-s.vue'

const visOptions = {
  interaction: {
    hover: true
  },
  nodes: {
    margin: 15,
    color: {
      highlight: {
        background: '#f5c278', // 选中节点的背景色
        border: '#F7990F'
      }
    }
  },
  edges: {
    color: {
      highlight: '#f5c278' // 选中边的颜色
    },
    smooth: {
      type: 'cubicBezier',
      forceDirection: 'horizontal',
      roundness: 1
    }
  },
  layout: {
    hierarchical: {
      direction: 'UD'
    }
  }
  // physics: false
}
let indexMap = {}
export default {
  name: 'CiGraph',
  props: {
    ciGraphData: { type: Object },
    attributeObject: { type: Object },
    // eslint-disable-next-line standard/object-curly-even-spacing
    currentReportId: { type: String },
    editorBoxInRight: {
      type: Boolean,
      default: false
    },
    isPreviewState: {
      type: Boolean,
      default: false
    },
    recordClickNodeId: {
      type: String,
      default: ''
    }
  },
  data () {
    return {
      savedNetWork: '',
      savedClickedNode: {},
      savedRenderedNodes: {},
      savedSelectedRefs: {},
      tos: [],
      bys: [],
      isSwitcherOpen: false,
      isShowError: false,
      checkDataResult: [],
      currentSelectedTos: [],
      referTos: [],
      referBys: [],
      ciTypeAttrs: [],
      selectedAttrs: [],
      currentTab: 'name1',
      editAttr: [],
      editToParams: [],
      editFromParams: [],
      refreshFlag: '',
      oriDataMap: {}
    }
  },
  async mounted () {
    const { data, statusCode } = await getCiTypeNameMap()
    if (statusCode === 'OK') {
      this.oriDataMap = data
    }
    this.renderGraph()
  },
  watch: {
    ciGraphData (val) {
      this.renderGraph()
    }
  },
  methods: {
    createNodes (nodes) {
      let t = []
      Object.keys(nodes).forEach(id => {
        t.push(this.createNode(nodes[id].node))
        if (nodes[id].from) {
          nodes[id].from.forEach(_ => {
            if (_ && !nodes[_.ciTypeId]) {
              t.push(this.createNode(_))
            }
          })
        }
        if (nodes[id].to) {
          nodes[id].to.forEach(_ => {
            if (_ && !nodes[_.ciTypeId]) {
              t.push(this.createNode(_))
            }
          })
        }
      })
      return t
    },
    createNode (item) {
      return {
        id: `${item.label || item.name}`,
        label: `CI[${this.oriDataMap[item.ciType]}]\n${item.label || item.name}`,
        shape: 'box'
      }
    },
    createEdges (nodes) {
      const nodeKeys = Object.keys(nodes)
      let t = []
      nodeKeys.forEach(key => {
        const froms = nodes[key].from
        if (froms && Array.isArray(froms)) {
          t = t.concat(
            froms.map(_ => {
              return {
                from: nodes[key].node.label,
                to: _.label,
                arrows: {
                  to: true
                },
                physics: false
              }
            })
          )
        }
        const tos = nodes[key].to
        if (tos && Array.isArray(tos)) {
          t = t.concat(
            tos.map(_ => {
              return {
                from: nodes[key].node.label,
                to: _.label,
                arrows: {
                  to: {
                    enabled: true,
                    type: 'circle'
                  }
                },
                physics: false
              }
            })
          )
        }
      })
      return t
    },
    deduplicate (data) {
      const ret = []
      data.forEach(d => {
        let found = ret.find(_ => d.label === _.label)
        if (!found) ret.push(d)
      })

      return ret
    },
    calIndex (label) {
      const splitedIndex = label.split('-')
      if (splitedIndex[0] === label) {
        indexMap[1] = 1
        return 1
      } else {
        if (!isNaN(Number(splitedIndex[0])) && !isNaN(Number(splitedIndex[1]))) {
          indexMap[splitedIndex[0]] = splitedIndex[1]
          return Number(splitedIndex[0])
        }
      }
    },
    findRemovedNode (pre, cur, cb) {
      const ret = []
      if (Array.isArray(pre) && Array.isArray(cur)) {
        pre.forEach(item => {
          if (!cur.find(c => c.label === item.label)) {
            ret.push(item)
          }
        })
      }
      return ret
    },
    deleteRemovedNode (host, targets) {
      targets.forEach(target => {
        delete host[target.label]
      })
    },
    generateCiRelation (cis) {
      if (!cis) return {}
      indexMap = {}
      const ret = {}
      const _this = this
      function helper (root) {
        if (!root) return
        const label = root.dataTitleName
        ret[label] = {
          from: [],
          to: [],
          node: {
            label,
            id: root.id,
            ciTypeId: root.ciType,
            attrs: root.attr,
            dataTitleName: root.dataTitleName,
            dataName: root.dataName,
            attributeList: root.attributeList,
            index: _this.calIndex(root.dataTitleName),
            ...root
          }
        }

        if (!root.object) return

        root.object.map(child => {
          const node = {
            id: root.id,
            attrId: child.myAttr,
            attrs: child.attr,
            dataTitleName: child.dataTitleName,
            dataName: child.dataName,
            attributeList: child.attributeList,
            label: child.dataTitleName,
            ciTypeId: child.ciType,
            referenceId: child.ciType,
            index: _this.calIndex(child.dataTitleName),
            ...child
          }
          if (child.myAttr.includes('__guid')) {
            // node.refPropertyId = child.myAttr
            ret[label].to.push(node)
          } else if (child.parentAttr.includes('__guid')) {
            // node.refPropertyId = child.parentAttr
            ret[label].from.push(node)
          } else {
            console.error(1232)
          }
          helper(child)

          return null
        })
      }

      helper(cis)
      return ret
    },
    renderGraph () {
      this.savedRenderedNodes = this.generateCiRelation(this.ciGraphData)
      this.$emit('onMounted', this.savedRenderedNodes)
      let container = document.getElementById('mynetwork')
      let data = {
        nodes: this.deduplicate(this.createNodes(this.generateCiRelation(this.ciGraphData))),
        edges: this.createEdges(this.generateCiRelation(this.ciGraphData))
      }
      const clickedNodeId = this.recordClickNodeId || data.nodes[0].id
      const network = new vis.Network(container, data, visOptions)
      network.once('stabilized', () => {
        network.selectNodes([clickedNodeId])
        setTimeout(() => {
          const params = {
            nodes: [clickedNodeId]
          }
          this.handler(params)
        }, 0)
      })
      this.savedNetWork = network
      this.savedNetWork.on('click', this.handler)
      setTimeout(() => {
        this.refreshFlag = +new Date() + ''
      }, 400) 
    },
    handler (e) {
      if (e.nodes.length === 0) return
      this.currentTab = 'name1'
      this.savedClickedNode = this.savedRenderedNodes[e.nodes[0]]
      if (!this.savedClickedNode) {
        // 从from和to中寻找当前点击node label === e.nodes[0]
        const keys = Object.keys(this.savedRenderedNodes)
        for (let i = 0; i < keys.length; i++) {
          const key = keys[i]
          const { from, to } = this.savedRenderedNodes[key]
          for (let j = 0; j < from.length; j++) {
            const node = from[j]
            if (node.label === e.nodes[0]) {
              this.savedClickedNode = {
                node,
                from: [],
                to: []
              }
              break
            }
          }

          if (this.savedClickedNode) break

          for (let k = 0; k < to.length; k++) {
            const node = to[k]
            if (node.label === e.nodes[0]) {
              this.savedClickedNode = {
                node,
                from: [],
                to: []
              }
              break
            }
          }
          if (this.savedClickedNode) break
        }
      }
      this.savedSelectedRefs.bys = this.savedClickedNode.from
      this.savedSelectedRefs.tos = this.savedClickedNode.to
      this.tos = this.savedClickedNode.to
      this.bys = this.savedClickedNode.from
      this.setIsSwitcherOpen(true)
    },
    async setIsSwitcherOpen (status) {
      if (status) {
        await this.getTosBysAttrs()
      }
      this.isSwitcherOpen = status
      this.refreshFlag = +new Date() + ''
    },
    async getTosBysAttrs () {
      const id = this.savedClickedNode.node.ciTypeId
      let bys = await getRefCiTypeFrom(id)
      if (bys.statusCode === 'OK') {
        this.referBys = bys.data.map(_ => {
          return {
            ..._,
            dataName: _.ciTypeId,
            dataTitleName: _.ciTypeName
          }
        })
      }
      let attrs = await getCiTypeAttr(id)
      if (attrs.statusCode === 'OK') {
        this.ciTypeAttrs = attrs.data.map(_ => {
          return {
            ..._,
            dataName: _.propertyName,
            dataTitleName: _.displayName
          }
        })
        this.referTos = this.ciTypeAttrs.filter(item => item.referenceId !== '')
      }
    },
    renderTos () {
      const referTos = this.referTos.map(_ => {
        let found = this.savedSelectedRefs.tos && this.savedSelectedRefs.tos.find(i => i.parentAttr === _.ciTypeAttrId)
        let attr = JSON.parse(JSON.stringify(_))
        let res = {
          id: '',
          ...attr
        }
        if (found) {
          res.id = found.id
          res.dataName = found.dataName
          res.dataTitleName = found.dataTitleName
        }
        return res
      })
      referTos.forEach(item => {
        item.displayName = `CI[${this.oriDataMap[item.ciTypeId]}]-${item.displayName}`
      })
      return (
        <Attrs
          isPreviewState={this.isPreviewState}
          parentData={referTos}
          ref="toAttrs"
          displayKey="displayName"
          parentkey="ciTypeAttrId"
          childData={this.savedSelectedRefs.tos}
          childKey="parentAttr"
        >
          {' '}
        </Attrs>
      )
    },
    renderBys () {
      const referBys = this.referBys.map(_ => {
        let found = this.savedSelectedRefs.bys && this.savedSelectedRefs.bys.find(i => i.myAttr === _.ciTypeAttrId)
        let attr = JSON.parse(JSON.stringify(_))
        let res = {
          id: '',
          ...attr
        }
        if (found) {
          res.id = found.id
          res.dataName = found.dataName
          res.dataTitleName = found.dataTitleName
        }
        return res
      })
      referBys.forEach(item => {
        item.ciTypeName = `CI[${this.oriDataMap[item.ciTypeId]}]-${item.displayName}`
      })
      return (
        <Attrs
          isPreviewState={this.isPreviewState}
          parentData={referBys}
          ref="byAttrs"
          displayKey="ciTypeName"
          parentkey="ciTypeAttrId"
          childData={this.savedSelectedRefs.bys}
          childKey="myAttr"
        >
          {' '}
        </Attrs>
      )
    },
    renderAttrs () {
      const currentAttrs = this.savedRenderedNodes[this.savedClickedNode.node.label].node.attrs
      const ciTypeAttrs = this.ciTypeAttrs.map(_ => {
        let found = currentAttrs && currentAttrs.find(i => i.ciTypeAttr === _.ciTypeAttrId)
        let res = {
          id: '',
          ..._
        }
        if (found) {
          res.id = found.id
          _.dataName = found.dataName
          _.dataTitleName = found.dataTitleName
        }
        return res
      })
      return (
        <Attrs
          parentData={ciTypeAttrs}
          ref="ownAttrs"
          isPreviewState={this.isPreviewState}
          displayKey="displayName"
          parentkey="ciTypeAttrId"
          childData={currentAttrs}
          childKey="ciTypeAttr"
        >
          {' '}
        </Attrs>
      )
    },
    getRepeatAttrName (arr, key = 'dataName') {
      const tempAttrArr = []
      let resStr = ''
      for (let i = 0; i < arr.length; i++) {
        if (tempAttrArr.includes(arr[i][key])) {
          resStr = arr[i][key]
          break
        } else {
          tempAttrArr.push(arr[i][key])
        }
      }
      return resStr
    },
    getCheckTips (templateText, keyName, boxText) {
      return templateText.replace(/###/, keyName).replace(/xxx/, boxText)
    },
    checkData (attr, toAttrs, byAttrs) {
      const attrDataNameSet = new Set(attr.map(att => att.dataName))
      const attrDataTitleNameSet = new Set(attr.map(att => att.dataTitleName))
      const toAttrDataNameSet = new Set(toAttrs.map(att => att.dataName))
      const toAttrDataTitleNameSet = new Set(toAttrs.map(att => att.dataTitleName))
      const byAttrDataNameSet = new Set(byAttrs.map(att => att.dataName))
      const byAttrDataTitleNameSet = new Set(byAttrs.map(att => att.dataTitleName))
      let checkDataResult = []
      if (attrDataNameSet.size !== attr.length) {
        const repeatDataName = this.getRepeatAttrName(attr)
        const checkTips = this.getCheckTips(this.$t('db_repeat_tips_template'), repeatDataName, this.$t('attribute'))
        checkDataResult.push(checkTips)
      }
      if (attrDataTitleNameSet.size !== attr.length) {
        const repeatDataName = this.getRepeatAttrName(attr, 'dataTitleName')
        const checkTips = this.getCheckTips(this.$t('db_repeat_tips_template'), repeatDataName, this.$t('attribute'))
        checkDataResult.push(checkTips)
      }
      if (toAttrDataNameSet.size !== toAttrs.length) {
        const repeatDataName = this.getRepeatAttrName(toAttrs)
        const checkTips = this.getCheckTips(this.$t('db_repeat_tips_template'), repeatDataName, this.$t('refrence_to'))
        checkDataResult.push(checkTips)
      }
      if (toAttrDataTitleNameSet.size !== toAttrs.length) {
        const repeatDataName = this.getRepeatAttrName(toAttrs, 'dataTitleName')
        const checkTips = this.getCheckTips(this.$t('db_repeat_tips_template'), repeatDataName, this.$t('refrence_to'))
        checkDataResult.push(checkTips)
      }
      if (byAttrDataNameSet.size !== byAttrs.length) {
        const repeatDataName = this.getRepeatAttrName(byAttrs)
        const checkTips = this.getCheckTips(this.$t('db_repeat_tips_template'), repeatDataName, this.$t('refrence_by'))
        checkDataResult.push(checkTips)
      }
      if (byAttrDataTitleNameSet.size !== byAttrs.length) {
        const repeatDataName = this.getRepeatAttrName(byAttrs, 'dataTitleName')
        const checkTips = this.getCheckTips(this.$t('db_repeat_tips_template'), repeatDataName, this.$t('refrence_by'))
        checkDataResult.push(checkTips)
      }
      toAttrs.forEach(ta => {
        if (attrDataNameSet.has(ta.dataName)) {
          const checkTips = this.getCheckTips(
            this.$t('db_conflict_tips_template'),
            ta.dataName,
            this.$t('refrence_to') + this.$t('db_and') + this.$t('refrence_by')
          )
          checkDataResult.push(checkTips)
        }
        if (attrDataTitleNameSet.has(ta.dataTitleName)) {
          const checkTips = this.getCheckTips(
            this.$t('db_conflict_tips_template'),
            ta.dataTitleName,
            this.$t('refrence_to') + this.$t('db_and') + this.$t('refrence_by')
          )
          checkDataResult.push(checkTips)
        }
      })
      byAttrs.forEach(ta => {
        if (attrDataNameSet.has(ta.dataName)) {
          const checkTips = this.getCheckTips(
            this.$t('db_conflict_tips_template'),
            ta.dataName,
            this.$t('refrence_by') + this.$t('db_and') + this.$t('attribute')
          )
          checkDataResult.push(checkTips)
        }
        if (attrDataTitleNameSet.has(ta.dataTitleName)) {
          const checkTips = this.getCheckTips(
            this.$t('db_conflict_tips_template'),
            ta.dataTitleName,
            this.$t('refrence_by') + this.$t('db_and') + this.$t('attribute')
          )
          checkDataResult.push(checkTips)
        }
        if (toAttrDataNameSet.has(ta.dataName)) {
          const checkTips = this.getCheckTips(
            this.$t('db_conflict_tips_template'),
            ta.dataName,
            this.$t('refrence_to') + this.$t('db_and') + this.$t('refrence_by')
          )
          checkDataResult.push(checkTips)
        }
        if (toAttrDataTitleNameSet.has(ta.dataTitleName)) {
          const checkTips = this.getCheckTips(
            this.$t('db_conflict_tips_template'),
            ta.dataTitleName,
            this.$t('refrence_to') + this.$t('db_and') + this.$t('refrence_by')
          )
          checkDataResult.push(checkTips)
        }
      })
      this.checkDataResult = checkDataResult
      if (checkDataResult.length > 0) {
        this.isShowError = true
        return false
      } else {
        return true
      }
    },
    renderError () {
      return (
        <div>
          <ul>
            {this.checkDataResult.map(item => {
              return <li style="list-style:none;margin:0 20px">{item}</li>
            })}
          </ul>
        </div>
      )
    },
    async handleConfirm () {
      const node = this.savedClickedNode.node
      const toAttrs = this.$refs.toAttrs.selectedAttrs().map(attr => {
        return {
          id: attr.id || '',
          dataName: attr.dataName,
          dataTitleName: attr.dataTitleName,
          parentAttr: attr.ciTypeAttrId,
          ciType: attr.referenceId,
          myAttr: attr.referenceId + '__guid'
        }
      })
      const byAttrs = this.$refs.byAttrs.selectedAttrs().map(attr => {
        return {
          id: attr.id || '',
          dataName: attr.dataName,
          dataTitleName: attr.dataTitleName,
          parentAttr: attr.referenceId + '__guid',
          ciType: attr.ciTypeId,
          myAttr: attr.ciTypeAttrId
        }
      })
      const attr = this.$refs.ownAttrs.selectedAttrs().map(attr => {
        return {
          id: attr.id || '',
          dataName: attr.dataName,
          dataTitleName: attr.dataTitleName,
          querialbe: 'yes',
          ciTypeAttr: attr.ciTypeAttrId
        }
      })
      const res = this.checkData(attr, toAttrs, byAttrs)
      if (!res) {
        return
      }
      const params = {
        id: node.id,
        report: this.currentReportId,
        dataName: node.dataName,
        dataTitleName: node.dataTitleName,
        ciType: node.ciTypeId,
        object: [...toAttrs, ...byAttrs],
        attr: attr
      }
      const { statusCode } = await configReport(params)
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: this.$t('success'),
          desc: this.$t('success')
        })
        this.$emit('onRefresh', node.label)
      }
    }
  },
  render (h) {
    const { isSwitcherOpen, editorBoxInRight, savedClickedNode, handleConfirm, isShowError } = this
    return (
      <div>
        <div style="display: flex">
          <div id="mynetwork" class="ci-graph-root" />
          {isSwitcherOpen && editorBoxInRight && (
            <div class="editor-box-right" style="width: 46%">
              <div style="margin-left:20px;" key={this.refreshFlag}>
                <Tabs
                  class="config-tabs"
                  value={this.currentTab}
                  on-input={val => {
                    this.currentTab = val
                  }}
                >
                  <TabPane label={this.$t('db_reference_relationship')} name="name1">
                    <div class="first-tab-pane">
                      <Divider size="small" orientation="left">
                        <span style="size:12px">{this.$t('refrence_to')}</span>
                      </Divider>
                      {isSwitcherOpen && this.renderTos()}
                      <Divider size="small" orientation="left">
                        <span style="size:12px">{this.$t('refrence_by')}</span>
                      </Divider>
                      {isSwitcherOpen && this.renderBys()}
                    </div>
                  </TabPane>
                  <TabPane label={this.$t('attribute')} name="name2">
                    {isSwitcherOpen && this.renderAttrs()}
                  </TabPane>
                </Tabs>
              </div>
              {!this.isPreviewState && (
                <Button
                  style="position: fixed; bottom: 30px; right: 50px"
                  onClick={() => handleConfirm()}
                  type="primary"
                >
                  {this.$t('save')}
                </Button>
              )}
            </div>
          )}
        </div>
        <Modal
          value={isSwitcherOpen && !editorBoxInRight}
          width="800"
          title={(savedClickedNode.node && savedClickedNode.node.label) || ''}
          // on-on-ok={handleConfirm}
          on-on-cancel={() => {
            this.isSwitcherOpen = false
            this.currentTab = 'name1'
          }}
          mask-closable={false}
        >
          <div>
            {isSwitcherOpen && !editorBoxInRight && (
              <Tabs
                value={this.currentTab}
                on-input={val => {
                  this.currentTab = val
                }}
              >
                <TabPane label={this.$t('attribute')} name="name1">
                  {isSwitcherOpen && this.renderAttrs()}
                </TabPane>
                <TabPane label={this.$t('refrence_object')} name="name2">
                  <Divider size="small" orientation="left">
                    <span style="size:12px">{this.$t('refrence_to')}</span>
                  </Divider>
                  {isSwitcherOpen && this.renderTos()}
                  <Divider size="small" orientation="left">
                    <span style="size:12px">{this.$t('refrence_by')}</span>
                  </Divider>
                  {isSwitcherOpen && this.renderBys()}
                </TabPane>
              </Tabs>
            )}
          </div>
          <div slot="footer">
            <Button onClick={() => handleConfirm()} type="primary">
              {this.$t('save')}
            </Button>
          </div>
        </Modal>
        <Modal
          value={isShowError}
          width="800"
          on-footer-hide="true"
          on-on-ok={() => {
            this.isShowError = false
          }}
          on-on-cancel={() => {
            this.isShowError = false
          }}
          title="ERROR"
          mask-closable={false}
        >
          <div>{this.renderError()}</div>
        </Modal>
      </div>
    )
  }
}
