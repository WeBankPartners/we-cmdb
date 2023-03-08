<template>
  <div style="max-height:500px;overflow-y:auto">
    <CheckboxGroup v-model="social">
      <template v-for="item in parent">
        <div :key="item.ciTypeAttrId" style="line-height: 32px">
          <Checkbox :label="item.ciTypeAttrId">
            <Tooltip :content="item.name + '/' + item.propertyName">
              <div style="width:150px;display:inline-block;">
                {{ item[displayKey] }}
                <span v-if="item.nullable === 'no'" style="color:red;font-size:16px;vertical-align: sub;">*</span>
              </div>
            </Tooltip>
            <!-- <div style="width:150px;display:inline-block;">{{ item[displayKey] }}</div> -->
            <div style="width:250px;display:inline-block;" v-show="social.includes(item.ciTypeAttrId)">
              <span>{{ $t('data_name') }}</span>
              <Input v-model="item.dataName" style="width:150px"></Input>
            </div>
            <div style="width:250px;display:inline-block;" v-show="social.includes(item.ciTypeAttrId)">
              <span>{{ $t('data_title_name') }}</span>
              <Input v-model="item.dataTitleName" style="width:150px"></Input>
            </div>
          </Checkbox>
        </div>
      </template>
    </CheckboxGroup>
  </div>
</template>
<script>
export default {
  data () {
    return {
      parent: [],
      child: [],
      social: []
    }
  },
  props: ['parentData', 'parentkey', 'childData', 'childKey', 'displayKey'],
  mounted () {
    this.parent = this.parentData
    this.child = this.childData
    this.social =
      this.child &&
      this.child.map(item => {
        return item[this.childKey]
      })
  },
  methods: {
    selectedAttrs () {
      const res = this.parent.filter(p => this.social.includes(p.ciTypeAttrId))
      return res
    }
  }
}
</script>
<style>
.demo-tree-render .ivu-tree-title {
  width: 100%;
}
</style>
