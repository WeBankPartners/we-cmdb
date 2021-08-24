<template>
  <div class=" ">
    <Modal v-model="selectFormConfig.isShow" width="1000" :title="params.operation">
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
    <Modal v-model="dataDetail.isShow" :fullscreen="fullscreen" width="800" :mask-closable="false" footer-hide>
      <p slot="header">
        <span>{{ $t('details') }}</span>
        <Icon v-if="!fullscreen" @click="fullscreen = true" class="header-icon" type="ios-expand" />
        <Icon v-else @click="fullscreen = false" class="header-icon" type="ios-contract" />
      </p>
      <div :style="{ overflow: 'auto', 'max-height': fullscreen ? '' : '500px' }">
        <pre>{{ dataDetail.data }}</pre>
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
      MODALHEIGHT: 500,
      fullscreen: false,
      dataDetail: {
        isShow: false,
        data: {}
      },
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
  mounted () {
    this.MODALHEIGHT = document.body.scrollHeight - 200
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
        data.title.forEach(item => {
          item.width = 200
          if (['object', 'multiObject'].includes(item.type)) {
            item.width = 260
            item.render = (h, params) => {
              return (
                <div>
                  <div style="display:inline-block;width: 190px;overflow: hidden;text-overflow:ellipsis;white-space: nowrap">
                    {JSON.stringify(params.row[item.key])}
                  </div>
                  {params.row[item.key] !== '' && (
                    <Button
                      onClick={() => {
                        this.showInfo(params.row[item.key])
                      }}
                      style="vertical-align: top;"
                      icon="ios-search"
                      type="primary"
                      ghost
                      size="small"
                    ></Button>
                  )}
                </div>
              )
            }
          }
        })
        const finalData = this.managementData(data.title, data.data)
        data.title.unshift({
          title: this.$t('select_placeholder'),
          key: 'id',
          width: 80,
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
                  value: flag,
                  disabled: params.row._disabled
                },
                on: {
                  'on-change': () => {
                    if (self.currentChoose === id) {
                      self.currentChoose = ''
                    } else {
                      self.currentChoose = id
                    }
                  }
                }
              })
            ])
          }
        })
        this.selectFormConfig = {
          isShow: true,
          table: {
            tableData: finalData,
            tableColumns: data.title
          }
        }
      }
    },
    showInfo (data) {
      this.dataDetail.data = ''
      this.dataDetail.isShow = true
      this.dataDetail.data = data
    },
    managementData (title, data) {
      const titleJson = {}
      title.forEach(item => {
        titleJson[item.key] = item.type
      })
      const keys = Object.keys(titleJson)
      data.forEach(d => {
        keys.forEach(k => {
          if (titleJson[k] === 'ref') {
            d[k] = d[k].key_name || ''
          }
          if (titleJson[k] === 'multiRef') {
            d[k] = d[k].map(item => item.key_name).join(',')
          }
        })
      })
      return data
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
        if (this.$parent.queryCiData) {
          this.$parent.queryCiData()
        } else {
          this.$emit('callback')
        }
      }
      this.currentChoose = ''
    }
  },
  components: {}
}
</script>

<style scoped lang="scss"></style>
