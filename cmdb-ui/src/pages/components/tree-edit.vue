<template>
  <div>
    <Tree
      :data="data5"
      :render="renderContent"
      @on-check-change="test"
      show-checkbox
      multiple
      class="demo-tree-render"
    ></Tree>
  </div>
</template>
<script>
export default {
  data () {
    return {
      data5: [
        {
          title: 'ROOT',
          expand: true,
          render: (h, { root, node, data }) => {
            return h(
              'span',
              {
                style: {
                  display: 'inline-block',
                  width: '100%'
                }
              },
              [h('span', data.title)]
            )
          },
          children: [
            {
              title: 'child 1-2',
              dataName: '1111',
              dataTitleName: '1111'
            },
            {
              title: 'child 1-3',
              dataName: '2222',
              dataTitleName: '2222'
            }
          ]
        }
      ]
    }
  },
  methods: {
    showData () {
      console.log(this.data5[0].children)
    },
    test (allSelect, currentSelect) {
      console.log(allSelect, currentSelect)
    },
    renderContent (h, { root, node, data }) {
      let formateNodeData = (v, tag) => {
        let node = this.data5[0].children.find(child => child.title === data.title)
        node[tag] = v
      }
      return (
        <span style="display: 'inline-block';width: '90%'">
          <span style="padding: 0 4px">{data.title}</span>
          <span style="padding: 0 4px">
            DataName:
            <Input value={data.dataName} onInput={v => formateNodeData(v, 'dataName')} style="width:100px"></Input>
          </span>
          <span style="padding: 0 4px">
            DataTitleName:
            <Input
              value={data.dataTitleName}
              onInput={v => formateNodeData(v, 'dataTitleName')}
              style="width:100px"
            ></Input>
          </span>
        </span>
      )
    }
  }
}
</script>
<style>
.demo-tree-render .ivu-tree-title {
  width: 100%;
}
</style>
