<template>
  <div class=" ">
    <Modal v-model="selectFormConfig.isShow" width="900" :title="params.operation">
      <div>
        <Table
          border
          type="selection"
          ref="selection"
          max-height="500"
          :columns="selectFormConfig.table.tableColumns"
          :data="selectFormConfig.table.tableData"
        >
        </Table>
      </div>
      <div slot="footer">
        <Button @click="cancelData">{{ $t('cancel') }}</Button>
        <Button type="primary" @click="confirmData" :disabled="currentChoose === ''">{{ $t('confirm') }}</Button>
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
      selectFormConfig: {
        isShow: false,
        table: {
          tableData: [],
          tableColumns: []
        }
      },
      currentChoose: ''
    }
  },
  methods: {
    cancelData () {
      this.selectFormConfig.isShow = false
      this.currentChoose = ''
    },
    async initFormData (params) {
      this.params = params
      const { statusCode, data } = await getSelectFormData(params)
      if (statusCode === 'OK') {
        data.title.unshift({
          title: '选择',
          key: 'id',
          width: 70,
          align: 'center',
          render: (h, params) => {
            let id = params.row.id
            let flag = false
            if (this.currentChoose !== '' && this.currentChoose === id) {
              flag = true
            }
            let self = this
            return h('div', [
              h('Radio', {
                props: {
                  value: flag
                },
                on: {
                  'on-change': () => {
                    self.currentChoose = id
                  }
                }
              })
            ])
          }
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
    async confirmData () {
      const selectedData = this.selectFormConfig.table.tableData.filter(item => item.id === this.currentChoose)
      const { statusCode, message } = await tableOptionExcute(this.params.operation, this.params.ciType, selectedData)
      if (statusCode === 'OK') {
        this.$Notice.success({
          title: 'successfully',
          desc: message
        })
        this.selectFormConfig.isShow = false
        this.$parent.queryCiData()
      }
      this.currentChoose = ''
    }
  },
  components: {}
}
</script>

<style scoped lang="scss"></style>
