<template>
  <div class="attribute-content">
    <CheckboxGroup v-model="social">
      <template v-for="item in parent">
        <div :key="item.ciTypeAttrId" style="line-height: 32px">
          <Checkbox
            :label="item.ciTypeAttrId"
            :disabled="['guid'].includes(item.dataName) || isPreviewState"
          >
            <Tooltip :content="item.name + '/' + item.propertyName">
              <div style="min-width:200px;display:inline-block;">
                {{ item[displayKey] }}
                <span v-if="item.nullable === 'no'" style="color:red;font-size:16px;vertical-align: sub;">*</span>
              </div>
            </Tooltip>
            <!-- <div style="width:150px;display:inline-block;">{{ item[displayKey] }}</div> -->
            <div style="display: flex">
              <div style="width:250px;display:inline-block;" v-if="social.includes(item.ciTypeAttrId)">
                <span>{{ $t('data_name') }}</span>
                <Input
                  v-model="item.dataName"
                  style="width:150px"
                  :disabled="['guid'].includes(item.dataName) || isPreviewState"
                ></Input>
              </div>
              <div style="width:250px;display:inline-block;" v-if="social.includes(item.ciTypeAttrId)">
                <span>{{ $t('data_title_name') }}</span>
                <Input
                  v-model="item.dataTitleName"
                  style="width:150px"
                  :disabled="['guid'].includes(item.dataName) || isPreviewState"
                ></Input>
              </div>
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
  props: ['parentData', 'parentkey', 'childData', 'childKey', 'displayKey', 'isPreviewState'],
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
<style lang="scss">
.attribute-content {
  max-height: calc(100vh - 380px);
  overflow-y: auto;
}
.demo-tree-render .ivu-tree-title {
  width: 100%;
}
</style>
