<!--
 * @Author: wanghao7717 792974788@qq.com
 * @Date: 2023-10-25 15:36:01
 * @LastEditors: wanghao7717 792974788@qq.com
 * @LastEditTime: 2024-12-26 11:55:41
-->
<template>
  <div class="json-config">
    <Tooltip v-if="disabled" max-width="350" style="width: 100%" placement="bottom-start" :content="jsonDataString">
      <Input v-model="jsonDataString" :disabled="true" />
    </Tooltip>
    <Button v-else type="primary" :disabled="disabled" @click="showTreeConfig">{{ $t('configuration') }}</Button>
    <Modal :z-index="2000" v-model="showEdit" :title="$t('json_edit')" @on-ok="confirmJsonData" width="700">
      <Button type="primary" v-if="isArray" @click="addNewJson">新增一组</Button>
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
      showEdit: false,
      jsonDataString: '',
      isArray: false,
      originData: [],
      finalData: null,
      last: null
    }
  },
  props: ['inputKey', 'jsonData', 'disabled'],
  mounted () {
    this.initData()
  },
  methods: {
    initData () {
      this.originData = []
      const jsonData = JSON.parse(JSON.stringify(this.jsonData))
      this.isArray = Array.isArray(jsonData)
      if (this.isArray) {
        this.originData = jsonData
      } else {
        this.originData.push(jsonData || {})
      }
      const jsonDataString = JSON.stringify(jsonData)
      this.jsonDataString = jsonDataString === '""' ? '' : jsonDataString
    },
    showTreeConfig () {
      this.showEdit = true
      this.initData()
    },
    confirmJsonData () {
      if (this.isArray) {
        this.finalData = []
        const len = this.originData.length
        for (let i = 0; i < len; i++) {
          this.finalData.push(this.$refs['jsonTree' + i][0].jsonJ)
        }
        this.last = this.finalData
      } else {
        this.finalData = this.$refs['jsonTree' + 0][0].jsonJ
        this.last = this.finalData
      }
      this.$emit('input', this.last, this.inputKey)
      this.showEdit = false
    },
    addNewJson () {
      this.originData.push({})
    }
  },
  components: {
    Tree
  }
}
</script>

<style scoped lang="scss">
.json-config {
  width: 100%;
}
</style>
