<template>
  <div class=" ">
    <Button type="primary" @click="showConfig" :disabled="disabled">{{ $t('configuration') }}</Button>
    <Modal v-model="showModal" :title="$t('configuration')">
      <template v-for="(item, itemIndex) in multiData">
        <div :key="itemIndex" style="margin:4px">
          <InputNumber
            v-if="type === 'number'"
            :max="99999999"
            :min="-99999999"
            style="width:360px"
            :precision="0"
            v-model="item.value"
          />
          <Input v-else v-model="item.value" :maxlength="255" show-word-limit style="width:360px"></Input>
          <Button @click="addItem" type="primary" icon="md-add"></Button>
          <Button @click="deleteItem(itemIndex)" v-if="multiData.length !== 1" type="error" icon="ios-trash"></Button>
        </div>
      </template>
      <template #footer>
        <Button @click="showModal = false">{{ $t('cancel') }}</Button>
        <Button @click="confirmData" type="primary">{{ $t('confirm') }}</Button>
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
    this.initData()
  },
  methods: {
    initData () {
      const data = JSON.parse(JSON.stringify(this.data))
      let tmp = data || []
      if (typeof tmp === 'string') {
        tmp = JSON.parse(tmp)
      }
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
      } else {
        this.showModal = true
      }
      this.initData()
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
      const emptyFlag = this.multiData.some(item => item.value === '')
      if (emptyFlag) {
        this.$Message.warning(this.$t('data_cannot_empty'))
      } else {
        const res = this.multiData.map(item => {
          if (this.type === 'number') {
            return Number(item.value)
          }
          return item.value
        })
        this.showJsonModal = false
        this.showModal = false
        this.$emit('input', res, this.inputKey)
      }
    },
    cancel () {}
  },
  components: {
    Tree
  }
}
</script>

<style scoped lang="scss"></style>
