<template>
  <div class=" ">
    <Modal v-model="selectFormConfig.isShow" width="900" :title="params.operation">
      <div>
        <Table
          border
          type="selection"
          ref="selection"
          max-height="500"
          @on-selection-change="selectionChange"
          :columns="selectFormConfig.table.tableColumns"
          :data="selectFormConfig.table.tableData"
        >
        </Table>
      </div>
      <div slot="footer">
        <Button @click="selectFormConfig.isShow = false">{{ $t('cancel') }}</Button>
        <Button type="primary" @click="confirmData" :disabled="selectedData.length === 0">{{ $t('confirm') }}</Button>
      </div>
    </Modal>
  </div>
</template>

<script>
import { getSelectFormData, tableOptionExcute } from '@/api/server'
export default {
  name: '',
  data () {
    return {
      params: {},
      selectedData: [],
      selectFormConfig: {
        isShow: false,
        table: {
          tableData: [],
          tableColumns: []
        }
      }
    }
  },
  methods: {
    async initFormData (params) {
      this.params = params
      const { statusCode, data } = await getSelectFormData(params)
      if (statusCode === 'OK') {
        console.log(data)
        data.title.unshift({
          type: 'selection',
          width: 60,
          align: 'center'
        })
        this.selectFormConfig = {
          isShow: true,
          table: {
            tableData: data.data,
            tableColumns: data.title
          }
        }
      }
    },
    selectionChange (items) {
      this.selectedData = items
    },
    async confirmData () {
      const { statusCode, message } = await tableOptionExcute(
        this.params.operation,
        this.params.ciType,
        this.selectedData
      )
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: 'successfully',
          desc: message
        })
        this.selectFormConfig.isShow = false
        this.$parent.queryCiData()
      }
    }
  },
  components: {}
}
</script>

<style scoped lang="scss"></style>
