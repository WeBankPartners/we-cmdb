<template>
  <div>
    <Form>
      <FormItem v-for="(selectItem, index) in selectList" :key="index">
        <Row>
          <Col span="15">
            <Input v-model="selectItem.key" />
          </Col>
          <Col span="8" offset="1">
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
      selectList: [
        {
          key: ''
        }
      ]
    }
  },
  props: ['selectListConfig'],
  mounted () {},
  methods: {
    clearAll () {
      this.clearAllData = false
      this.selectList = []
    },
    initData () {
      this.selectList = this.selectListConfig.originData
    },
    addItem () {
      if (this.clearAllData) {
        const lastOne = this.selectList[this.selectList.length - 1]
        if (lastOne.key) {
          this.selectList.push({ key: '' })
        } else {
          this.$Notice.info({
            title: 'Warning',
            desc: 'Not allowed to be empty ！'
          })
        }
      } else {
        this.selectList.push({ key: '' })
      }
      this.clearAllData = true
    },
    removeItem (index) {
      this.selectList.splice(index, 1)
    }
  }
}
</script>
