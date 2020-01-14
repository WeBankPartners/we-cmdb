<template>
  <div style="display: inline-block;float: right;">
    <Button @click="showOrchestration" size="small" shape="circle" type="primary" icon="ios-build-outline"></Button>
    <Modal
      v-model="orchestrationVisiable"
      @on-visible-change="visibleChangeHandler"
      width="300"
      :mask-closable="false"
      :title="$t('select_orchestration')"
      @on-ok="saveOrchestration"
    >
      <Select filterable v-model="selectedOrchestration">
        <Option v-for="i in allOrchestration" :label="i.label" :value="i.codeId" :key="i.codeId"></Option>
      </Select>
    </Modal>
  </div>
</template>
<script>
import { getEnumCodesByCategoryId, updateCiDatas } from '@/api/server'
export default {
  name: 'WeCMDBOrchestration',
  data () {
    return {
      orchestrationVisiable: false,
      allOrchestration: [],
      selectedOrchestration: ''
    }
  },
  props: {
    row: {},
    col: {}
  },

  mounted () {
    this.getAllOrchestration()
  },
  methods: {
    async getAllOrchestration () {
      const { data, statusCode } = await getEnumCodesByCategoryId(0, this.col.referenceId)
      if (statusCode === 'OK') {
        this.allOrchestration = data.map(_ => {
          return {
            label: _.value,
            codeId: _.codeId
          }
        })
      }
    },
    async saveOrchestration () {
      console.log('aa', this.selectedOrchestration, this.row)
      let payload = {
        id: this.row.citypeId,
        updateData: [
          {
            guid: this.row.guid,
            WeCMDBOrchestration: this.selectedOrchestration
          }
        ]
      }
      let { statusCode, message } = await updateCiDatas(payload)
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: 'Success',
          desc: message
        })
        this.$emit('handleSubmit')
      }
    },
    visibleChangeHandler (state) {
      this.orchestrationVisiable = state
    },
    showOrchestration () {
      this.orchestrationVisiable = true
      this.selectedOrchestration = this.row.WeCMDBOrchestration || '' // 回显
    }
  }
}
</script>
