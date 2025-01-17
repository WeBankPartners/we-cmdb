<template>
  <div class="tree-style">
    <Tree :data="data5" :render="renderContent" class="demo-tree-render"></Tree>
  </div>
</template>
<script>
export default {
  data () {
    return {
      data5: [
        {
          title: 'JSON',
          expand: true,
          key: 'JSON',
          render: (h, { root, node, data }) => {
            return (
              <span style="display: inline-block;width: 100%">
                <span>{data.title}</span>
                <span style="display: inline-block;float: right;margin-right: 32px">
                  <Button
                    onClick={() => this.append(data)}
                    type="primary"
                    style="width:64px"
                    size="small"
                    icon="ios-add"
                  ></Button>
                </span>
              </span>
            )
          },
          children: []
        }
      ],
      currentKey: '',
      childrenT: [],
      finalJson: {},
      jsonJ: {
        // region: 'region111',
        // secret_key: 'secret_key11',
        // secret_id: 'access_key11'
      }
      // jsonJ: {
      // instance_id: {
      //   convert: 'sdf',
      //   allow_null: 0,
      //   type: 'string'
      // },
      // eip_id: {
      //   convert: 'eip_id',
      //   allow_null: 0,
      //   type: 'string'
      // },
      // name: '-',
      // private_ip: {
      //   convert: 'private_ip',
      //   allow_null: 1,
      //   type: 'string'
      // }
      // }
    }
  },
  props: ['jsonData'],
  watch: {
    jsonData: {
      handler (val) {
        this.initJSON(this.jsonData)
      },
      deep: true,
      immediate: true
    }
  },
  methods: {
    renderContent (h, { root, node, data }) {
      let formateNodeData = (v, tag) => {
        const res = target({ children: this.data5[0].children }, data.nodeKey)
        data.path = data.path.replace('undefined.', '')
        let attrs = data.path.split('#DME#')
        let attr = attrs.slice(0, attrs.length - 1)
        let copyData
        if (attr.length === 0) {
          copyData = this.jsonJ
        } else {
          copyData = this.renderValue(this.jsonJ, attr)
        }
        if (tag === 'key') {
          if (attr.length === 0) {
            this.jsonJ[v] = this.jsonJ[res.key]
            delete this.jsonJ[res.key]
          } else {
            copyData[v] = copyData[res.key]
            delete copyData[res.key]
          }
        } else {
          if (attr.length === 0) {
            this.jsonJ[res.key] = v
          } else {
            copyData[res.key] = v
          }
        }

        if (tag === 'key') {
          if (attr.length === 0) {
            attr.push(v)
            data.path = attr.join('#DME#')
          } else {
            attr.push(v)
            data.path = attr.join('#DME#')
          }
          res[tag] = res['title'] = v
        } else {
          res[tag] = v
        }
      }

      let target = (js, nodeKey) => {
        let tmp = null
        let levelOne = js.children.find(item => item.nodeKey === data.nodeKey)
        let levelTow = js.children.findIndex(item => item.nodeKey > data.nodeKey)
        tmp = levelOne || js.children[levelTow - 1] || js.children.slice(-1)[0]
        if (tmp.nodeKey === nodeKey) {
          return tmp
        } else {
          return target(tmp, nodeKey)
        }
      }
      let formatData = tmp => {
        return this.isJson(tmp.value) ? '' : tmp.value
      }
      if (data.children.length !== 0) {
        return (
          <span style="display: 'inline-block';width: '100%'">
            <span style="padding: 0 4px">
              Key:<Input value={data.title} style="width:100px" onInput={v => formateNodeData(v, 'key')}></Input>
            </span>
            <span style="display: inline-block;float: right;margin-right: 32px">
              <Button onClick={() => this.append(data)} type="default" size="small" icon="ios-add"></Button>
              <Button
                onClick={() => this.remove(root, node, data)}
                type="default"
                size="small"
                icon="ios-remove"
              ></Button>
            </span>
          </span>
        )
      } else {
        return (
          <span style="display: 'inline-block';width: '100%'">
            <span style="padding: 0 4px">
              Key:<Input value={data.title} style="width:100px" onInput={v => formateNodeData(v, 'key')}></Input>
            </span>
            <span style="padding: 0 4px">
              Value:
              <Input value={formatData(data)} style="width:100px" onInput={v => formateNodeData(v, 'value')}></Input>
            </span>
            <span style="display: inline-block;float: right;margin-right: 32px">
              <Button onClick={() => this.append(data)} type="default" size="small" icon="ios-add"></Button>
              <Button
                onClick={() => this.remove(root, node, data)}
                type="default"
                size="small"
                icon="ios-remove"
              ></Button>
            </span>
          </span>
        )
      }
    },
    renderValue (item, attrs) {
      let itemTmp = item
      let n = 0
      for (n in attrs) {
        if (attrs[n] in itemTmp) {
          itemTmp = itemTmp[attrs[n]]
        } else {
          return {}
        }
      }
      return itemTmp
    },
    // 添加节点，赋初始值
    append (data) {
      const tag = 'key_' + Math.floor(Math.random() * 4000 + 1000)
      const children = data.children || []
      children.push({
        title: tag,
        key: tag,
        expand: true,
        children: [],
        value: '',
        path: data.path ? data.path + '#DME#' + tag : tag
      })
      data.value = {
        [tag]: ''
      }
      this.$set(data, 'children', children)
      if (data.path) {
        let attrs = data.path.split('#DME#')
        let attr
        if (attrs.length !== 1) {
          attr = attrs.slice(0, attrs.length - 1)
          let copyData = this.renderValue(this.jsonJ, attr)
          if (this.isJson(copyData[data.key])) {
            copyData[data.key] = {
              ...copyData[data.key],
              [tag]: ''
            }
          } else {
            copyData[data.key] = {
              [tag]: ''
            }
          }
        } else {
          let copyData = this.renderValue(this.jsonJ, attr)
          if (this.isJson(copyData[data.key])) {
            copyData[data.key] = {
              ...copyData[data.key],
              [tag]: ''
            }
          } else {
            copyData[data.key] = {
              [tag]: ''
            }
          }
        }
      } else {
        // 根节点
        this.jsonJ[tag] = ''
      }
    },
    remove (root, node, data) {
      this.currentKey = data.key
      const parentKey = root.find(el => el === node).parent
      const parent = root.find(el => el.nodeKey === parentKey).node
      const index = parent.children.indexOf(data)
      parent.children.splice(index, 1)
      let attrs = data.path.split('#DME#')

      let attr = attrs.slice(0, attrs.length - 1)
      let copyData = this.renderValue(this.jsonJ, attr)
      if (Object.keys(copyData).length === 1) {
        // 只剩一个母节点情况
        if (attrs.length === 1) {
          this.jsonJ = {}
        } else {
          let attr2 = attrs.slice(0, attrs.length - 2)
          let copyData2 = this.renderValue(this.jsonJ, attr2)
          const key = attr.slice(-1)[0]
          copyData2[key] = ''
        }
      } else {
        delete copyData[data.key]
      }
    },
    initJSON (val) {
      this.jsonJ = val
      const data = this.formatTreeData(this.jsonJ, {})
      this.data5[0].children = data
    },
    isJson (obj) {
      return (
        typeof obj === 'object' &&
        Object.prototype.toString.call(obj).toLowerCase() === '[object object]' &&
        !obj.length
      )
    },
    formatTreeData (tmp, parentNode) {
      const keys = Object.keys(tmp)
      let childrenTmp = []
      keys.forEach(key => {
        let params = {
          title: key,
          expand: true,
          key: key,
          value: tmp[key],
          path: JSON.stringify(parentNode) === '{}' ? key : parentNode.path + '#DME#' + key
        }
        if (this.isJson(tmp[key])) {
          params.children = this.formatTreeData(tmp[key], params)
        } else {
          params.children = []
        }
        childrenTmp.push(params)
      })
      return childrenTmp
    }
  }
}
</script>
<style>
.demo-tree-render .ivu-tree-title {
  width: 96%;
}
</style>
<style scoped lang="scss">
.tree-style {
  overflow: auto;
  width: 100%;
  max-height: 'calc(100vh - 300px)';
}
</style>
