<template>
  <div>
    <Form>
      <FormItem v-for="(stateItem, index) in stateSelect" :key="index">
        <Row>
          <Col span="9">
            <Select v-model="stateItem.key" filterable>
              <template v-for="itemK in stateConfig.valueOption">
                <Option :value="itemK.id" :key="itemK.id">{{ itemK.name }}</Option>
              </template>
            </Select>
          </Col>
          <Col span="2" style="text-align: center"></Col>
          <Col span="9">
            <Select v-model="stateItem.value">
              <template v-for="itemV in stateConfig.valueOption">
                <Option :value="itemV.id" :key="itemV.id">{{ itemV.name }}</Option>
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
export default {
  data () {
    return {
      clearAllData: true,
      stateSelect: [{ key: '', value: '' }]
    }
  },
  props: ['stateConfig'],
  mounted () {},
  methods: {
    clearAll () {
      this.clearAllData = false
      this.stateSelect = []
    },
    initData () {
      this.stateSelect = this.stateConfig.originData
    },
    addItem () {
      if (this.clearAllData) {
        const lastOne = this.stateSelect[this.stateSelect.length - 1]
        if (lastOne.key && lastOne.value) {
          this.stateSelect.push({ key: '', value: '' })
        } else {
          this.$Notice.info({
            title: 'Warning',
            desc: 'Not allowed to be empty ！'
          })
        }
      } else {
        this.stateSelect.push({ key: '', value: '' })
      }
      this.clearAllData = true
    },
    removeItem (index) {
      this.stateSelect.splice(index, 1)
    }
  }
}
</script>
