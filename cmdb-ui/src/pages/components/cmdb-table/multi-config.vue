<template>
  <div class=" ">
    <Button type="primary" @click="showConfig" :disabled="disabled">{{ $t('configuration') }}</Button>
    <Modal v-model="showModal" :title="$t('configuration')" @on-ok="confirmData" @on-cancel="cancel">
      <template v-for="(item, itemIndex) in multiData">
        <div :key="itemIndex" style="margin:4px">
          <Input v-model="item.value" :type="type" v-if="type !== 'json'" style="width:360px"></Input>
          <Button @click="addItem" type="primary" icon="md-add"></Button>
          <Button @click="deleteItem(itemIndex)" v-if="multiData.length !== 1" type="error" icon="ios-trash"></Button>
        </div>
      </template>
    </Modal>
    <Modal :z-index="2000" v-model="showJsonModal" :title="$t('json_edit')" @on-ok="confirmJsonData" width="700">
      <Button type="primary" @click="addNewJson">新增一组</Button>
      <div style="max-height:500px; overflow:auto">
        <template v-for="(item, itemIndex) in originData">
          <Tree :ref="'jsonTree' + itemIndex" :jsonData="item" :key="itemIndex"></Tree>
        </template>
      </div>
    </Modal>
  </div>
</template>

<script>
import Tree from './tree'
export default {
  name: '',
  data () {
    return {
      showModal: false,
      multiData: [
        {
          value: ''
        }
      ],

      showJsonModal: false,
      originData: []
    }
  },
  props: ['inputKey', 'data', 'type', 'disabled'],
  mounted () {
    let tmp = this.data ? this.data : []
    if (this.type === 'json') {
      this.originData = tmp || []
    } else {
      this.multiData =
        tmp &&
        tmp.map(d => {
          return {
            value: d
          }
        })
      if (this.multiData.length === 0) {
        this.multiData = [
          {
            value: ''
          }
        ]
      }
    }
  },
  methods: {
    confirmJsonData () {
      this.$emit('input', this.originData, this.inputKey)
      this.showJsonModal = false
      this.showModal = false
    },
    addNewJson () {
      this.originData.push({})
    },
    showConfig () {
      if (this.type === 'json') {
        this.showJsonModal = true
      }
      this.showModal = true
    },
    addItem () {
      this.multiData.push({
        value: ''
      })
    },
    deleteItem (index) {
      this.multiData.splice(index, 1)
    },
    confirmData () {
      const res = this.multiData.map(item => {
        if (this.type === 'number') {
          return Number(item.value)
        }
        return item.value
      })
      this.showJsonModal = false
      this.showModal = false
      this.$emit('input', res, this.inputKey)
    },
    cancel () {}
  },
  components: {
    Tree
  }
}
</script>

<style scoped lang="scss"></style>
