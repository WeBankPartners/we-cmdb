<template>
  <div>
    <Form>
      <FormItem v-for="(stateItem, index) in stateSelect" :key="index">
        <Row>
          <Col span="9">
            <Select v-model="stateItem.key" filterable>
              <template v-for="(itemK, index) in attrAndSelect">
                <Option :value="itemK.label" :key="itemK.label + index">{{ itemK.label }}</Option>
              </template>
            </Select>
          </Col>
          <Col span="2" style="text-align: center"></Col>
          <Col span="9">
            <Select v-model="stateItem.value" @on-open-change="getOptions(stateItem)" multiple>
              <template v-for="(itemV, index) in stateItem.options">
                <Option :value="itemV.code" :key="itemV.code + index">{{ itemV.value }}</Option>
              </template>
            </Select>
          </Col>
          <Col span="3" offset="1">
            <Button icon="ios-add" @click="addItem"></Button>
            <Button v-if="index !== 0" icon="ios-remove" @click="removeItem(index)"></Button>
          </Col>
        </Row>
      </FormItem>
      <FormItem>
        <Button v-if="clearAllData" @click="clearAll">{{ $t('clear_all') }}</Button>
        <Button v-else icon="ios-add" @click="addItem"></Button>
      </FormItem>
    </Form>
  </div>
</template>
<script>
import { getAllSystemEnumCodesWithPayload } from '@/api/server'
export default {
  data () {
    return {
      clearAllData: true,
      // stateSelect: [{ key: '', value: [], options: [] }],
      stateSelect: [],
      attrAndSelect: []
    }
  },
  props: [],
  mounted () {},
  methods: {
    async getOptions (item) {
      if (!item.key) return
      const find = this.stateSelect.filter(i => i.key === item.key)
      if (find.length === 2) {
        this.stateSelect.splice(this.stateSelect.length - 1, 1)
        this.stateSelect.push({ key: '', value: [], options: [] })
        return
      }
      const xx = this.attrAndSelect.find(i => i.label === item.key)
      let params = {
        filters: [{ name: 'catId', operator: 'eq', value: xx.selectList }]
      }
      const { statusCode, data } = await getAllSystemEnumCodesWithPayload(params)
      if (statusCode === 'OK') {
        item.options = data.contents
      }
    },
    clearAll () {
      this.clearAllData = false
      this.stateSelect = []
    },
    initData (attrAndSelect, editGroupValues) {
      this.stateSelect = []
      this.attrAndSelect = attrAndSelect
      if (editGroupValues.length > 0) {
        this.initStateSelect(editGroupValues)
      } else {
        this.stateSelect = [{ key: '', value: [], options: [] }]
      }
    },
    initStateSelect (editGroupValues) {
      editGroupValues.forEach(async item => {
        let tmp = {
          ...item,
          selectList: this.attrAndSelect.find(i => i.label === item.key).selectList || '',
          options: []
        }
        await this.getInitOptions(tmp)
      })
    },
    async getInitOptions (item) {
      let params = {
        filters: [{ name: 'catId', operator: 'eq', value: item.selectList }]
      }
      const { statusCode, data } = await getAllSystemEnumCodesWithPayload(params)
      if (statusCode === 'OK') {
        item.options = data.contents
        this.stateSelect.push(item)
      }
    },
    addItem () {
      if (this.clearAllData) {
        const lastOne = this.stateSelect[this.stateSelect.length - 1]
        if (lastOne.key && lastOne.value) {
          this.stateSelect.push({ key: '', value: [], options: [] })
        } else {
          this.$Notice.info({
            title: 'Warning',
            desc: 'Not allowed to be empty ！'
          })
        }
      } else {
        this.stateSelect.push({ key: '', value: [], options: [] })
      }
      this.clearAllData = true
    },
    removeItem (index) {
      this.stateSelect.splice(index, 1)
    }
  }
}
</script>
