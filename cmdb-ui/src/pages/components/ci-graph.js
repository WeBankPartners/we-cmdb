import vis from 'vis'
import { getRefCiTypeFrom, getRefCiTypeTo, getCiTypeAttr } from '@/api/server'
import './ci-graph.scss'

const visOptions = {
  interaction: {
    hover: true
  },
  edges: {
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
    ciGraphData: { type: Object }
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
      currentSelectedTos: [],
      referTos: [],
      referBys: [],
      ciTypeAttrs: [],
      selectedAttrs: [],
      currentTab: 'name1'
    }
  },
  mounted () {
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
        label: `${item.label || item.name}`,
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
        const label = root.name
        ret[label] = {
          from: [],
          to: [],
          node: {
            label,
            ciTypeId: root.ciTypeId,
            attrs: root.attrs
              ? root.attrs.map(_ => {
                return {
                  ciTypeAttrId: _
                }
              })
              : [],
            attrAliases: root.attrAliases,
            index: _this.calIndex(root.name)
          }
        }

        if (!root.children) return

        root.children.map(child => {
          const node = {
            attrId: child.parentRs.attrId,
            refPropertyId: child.parentRs.attrId,
            attrs: child.attrs
              ? child.attrs.map(_ => {
                return {
                  ciTypeAttrId: _
                }
              })
              : [],
            attrAliases: child.attrAliases,
            label: child.name,
            ciTypeId: child.ciTypeId,
            referenceId: child.ciTypeId,
            index: _this.calIndex(child.name)
          }

          if (child.parentRs.isReferedFromParent) {
            ret[label].to.push(node)
          } else {
            ret[label].from.push(node)
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
      console.log(this.savedRenderedNodes)
      let container = document.getElementById('mynetwork')
      let data = {
        nodes: this.deduplicate(this.createNodes(this.generateCiRelation(this.ciGraphData))),
        edges: this.createEdges(this.generateCiRelation(this.ciGraphData))
      }

      const network = new vis.Network(container, data, visOptions)
      this.savedNetWork = network
      this.savedNetWork.on('click', this.handler)
    },
    handler (e) {
      if (e.nodes.length === 0) return
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
    setIsSwitcherOpen (status) {
      this.isSwitcherOpen = status
      if (status) {
        this.getTosBysAttrs()
      }
    },
    async getTosBysAttrs () {
      const id = this.savedClickedNode.node.ciTypeId
      let tos = await getRefCiTypeTo(id)
      if (tos.statusCode === 'OK') {
        this.referTos = tos.data.map(_ => {
          return {
            ..._,
            refPropertyId: _.ciTypeAttrId,
            ciTypeId: _.referenceId
          }
        })
      }
      let bys = await getRefCiTypeFrom(id)
      if (bys.statusCode === 'OK') {
        this.referBys = bys.data.map(_ => {
          return {
            ..._.ciType,
            referenceName: _.name,
            refPropertyId: _.ciTypeAttrId
          }
        })
      }
      let attrs = await getCiTypeAttr(id)
      if (attrs.statusCode === 'OK') {
        this.ciTypeAttrs = attrs.data
      }
    },
    renderTos () {
      const currentTos = this.savedRenderedNodes[this.savedClickedNode.node.label].to
      let data = [
        {
          title: this.$t('all'),
          id: 'all',
          expand: true,
          children: this.referTos.map(_ => {
            let found = currentTos && currentTos.find(i => i.referenceId === _.referenceId && i.name === _.name)
            return {
              id: _.referenceId,
              title: _.name,
              checked: !!found
            }
          })
        }
      ]
      return (
        <Tree
          data={data}
          show-checkbox={true}
          on-on-check-change={(all, current) => this.handleReferToChange(all, current)}
          class="ci-graph-tree"
        />
      )
    },
    renderBys () {
      const currentBys = this.savedRenderedNodes[this.savedClickedNode.node.label].from
      let data = [
        {
          title: this.$t('all'),
          id: 'all',
          expand: true,
          children: this.referBys.map(_ => {
            let found = currentBys && currentBys.find(i => i.ciTypeId === _.ciTypeId)
            return {
              id: _.ciTypeId,
              title: _.name,
              checked: !!found
            }
          })
        }
      ]
      return (
        <Tree
          data={data}
          show-checkbox={true}
          on-on-check-change={(all, current) => this.handleReferByChange(all, current)}
          class="ci-graph-tree"
        />
      )
    },
    renderAttrs () {
      const currentAttrs = this.savedRenderedNodes[this.savedClickedNode.node.label].node.attrs
      let data = [
        {
          title: this.$t('all'),
          id: 'all',
          expand: true,
          children: this.ciTypeAttrs
            .filter(attr => attr.isDisplayed)
            .map(_ => {
              let found = currentAttrs && currentAttrs.find(i => i.ciTypeAttrId === _.ciTypeAttrId)
              return {
                id: _.ciTypeAttrId,
                title: _.name,
                checked: !!found
              }
            })
        }
      ]
      return (
        <Tree
          data={data}
          show-checkbox={true}
          on-on-check-change={(all, current) => this.handleCiTypeAttrChange(all, current)}
          class="ci-graph-tree"
        />
      )
    },

    handleReferByChange (all, current) {
      let data = all.map(_ => {
        return {
          ciTypeId: _.id,
          name: _.title
        }
      })
      data && data.length > 0 && data[0].ciTypeId === 'all' && data.splice(0, 1)
      this.savedSelectedRefs.bys = data
      this.tos = this.savedClickedNode.to
      this.bys = this.savedClickedNode.from
    },

    handleReferToChange (all, current) {
      let data = all.map(_ => {
        return {
          ciTypeId: _.id,
          name: _.title
        }
      })
      data && data.length > 0 && data[0].ciTypeId === 'all' && data.splice(0, 1)
      this.savedSelectedRefs.tos = data
      this.tos = this.savedClickedNode.to
      this.bys = this.savedClickedNode.from
    },
    handleCiTypeAttrChange (all, current) {
      let data = all.map(_ => {
        return {
          ciTypeAttrId: _.id,
          name: _.title
        }
      })
      data && data.length > 0 && data[0].ciTypeAttrId === 'all' && data.splice(0, 1)
      this.selectedAttrs = data
      this.savedClickedNode.node.attrs = data
    },
    handleConfirm () {
      const nodes = []
      const selectedNode = this.savedClickedNode
      const parentIndex = selectedNode.node.index
      const selectedNodeLabel = selectedNode.node.label
      const childIndexBase = Number(String(parentIndex || 1).split('-')[0]) + 1
      if (this.savedSelectedRefs.bys.length) {
        this.savedSelectedRefs.bys.forEach(by => {
          const found = this.referBys
            .map(_ => {
              let currentIndex
              if (indexMap[childIndexBase]) {
                currentIndex = `${childIndexBase}-${Number(indexMap[childIndexBase]) + 1}`
              } else {
                currentIndex = `${childIndexBase}-1`
              }

              // 如果已经存在froms中 则不重复计算
              const existNode = this.savedClickedNode.from.find(_ => _.ciTypeId === by.ciTypeId)

              if (existNode) {
                return existNode
              }
              if (_.ciTypeId === by.ciTypeId) {
                indexMap[childIndexBase] = Number(indexMap[childIndexBase] || 0) + 1

                const label = `${currentIndex}-${_.name}-${_.referenceName}`
                const node = {
                  ..._,
                  label,
                  index: currentIndex
                }
                this.savedRenderedNodes[label] = {
                  node,
                  from: [],
                  to: []
                }

                return node
              }

              return null
            })
            .filter(_ => _)[0]

          found && nodes.push(found)
        })

        const removed = this.findRemovedNode(selectedNode.from, nodes)
        if (removed.length) {
          this.deleteRemovedNode(this.savedRenderedNodes, removed)
        }

        this.savedRenderedNodes[selectedNodeLabel] = {
          to: selectedNode.to,
          node: selectedNode.node,
          from: [...nodes]
        }
      } else if (this.savedSelectedRefs.bys.length === 0) {
        this.deleteRemovedNode(this.savedRenderedNodes, this.savedRenderedNodes[selectedNodeLabel].from)

        this.savedRenderedNodes[selectedNodeLabel].from = []
      }

      nodes.length = 0
      if (this.savedSelectedRefs.tos.length) {
        this.savedSelectedRefs.tos.forEach(to => {
          const found = this.referTos
            .map(_ => {
              let currentIndex
              if (indexMap[childIndexBase]) {
                currentIndex = `${childIndexBase}-${Number(indexMap[childIndexBase]) + 1}`
              } else {
                currentIndex = `${childIndexBase}-1`
              }
              // 如果已经存在froms中 则不重复计算
              const existNode = this.savedClickedNode.to.find(_ => _.referenceId === to.ciTypeId && _.name === to.name)
              if (existNode) {
                return existNode
              }
              // eslint-disable-next-line
              if (_.referenceId == to.ciTypeId && _.name === to.name) {
                indexMap[childIndexBase] = Number(indexMap[childIndexBase] || 0) + 1
                const label = `${currentIndex}-${_.name}-${_.referenceName}`
                const node = {
                  ..._,
                  label,
                  index: currentIndex
                }
                this.savedRenderedNodes[label] = {
                  node,
                  from: [],
                  to: []
                }
                return node
              }

              return null
            })
            .filter(_ => _)[0]
          found && nodes.push(found)
        })

        const removed = this.findRemovedNode(selectedNode.to, nodes)
        if (removed.length) {
          this.deleteRemovedNode(this.savedRenderedNodes, removed)
        }

        this.savedRenderedNodes[selectedNodeLabel] = {
          to: [...nodes],
          node: selectedNode.node,
          from: this.savedRenderedNodes[selectedNodeLabel].from
        }
      } else if (this.savedSelectedRefs.tos.length === 0) {
        this.deleteRemovedNode(this.savedRenderedNodes, this.savedRenderedNodes[selectedNodeLabel].to)

        this.savedRenderedNodes[selectedNodeLabel].to = []
      }

      // destroy();

      // create a network
      let container = document.getElementById('mynetwork')

      let data = {
        nodes: this.deduplicate(this.createNodes(this.savedRenderedNodes)),
        edges: this.createEdges(this.savedRenderedNodes)
      }
      const network = new vis.Network(container, data, visOptions)
      this.savedNetWork = network
      this.savedNetWork.on('click', this.handler)

      // props.onChange && props.onChange(savedRenderedNodes.current);
      console.log('this.savedRenderedNodes', this.savedRenderedNodes)
      this.$emit('onChange', this.savedRenderedNodes)

      this.savedSelectedRefs.bys = []
      this.savedSelectedRefs.tos = []
      this.isSwitcherOpen = false
      this.currentTab = 'name1'
    }
  },
  render (h) {
    const { isSwitcherOpen, savedClickedNode, handleConfirm } = this

    return (
      <div>
        <div id="mynetwork" class="CiGraph-root" style="height: 600px" />
        <Modal
          value={isSwitcherOpen}
          title={(savedClickedNode.node && savedClickedNode.node.label) || ''}
          on-on-ok={handleConfirm}
          on-on-cancel={() => {
            this.isSwitcherOpen = false
            this.currentTab = 'name1'
          }}
          mask-closable={false}
        >
          <div>
            <Tabs
              value={this.currentTab}
              on-input={val => {
                this.currentTab = val
              }}
            >
              <TabPane label={this.$t('attribute')} name="name1">
                {isSwitcherOpen && this.renderAttrs()}
              </TabPane>
              <TabPane label={this.$t('refrence_to')} name="name2">
                {isSwitcherOpen && this.renderTos()}
              </TabPane>
              <TabPane label={this.$t('refrence_by')} name="name3">
                {isSwitcherOpen && this.renderBys()}
              </TabPane>
            </Tabs>
          </div>
        </Modal>
      </div>
    )
  }
}
