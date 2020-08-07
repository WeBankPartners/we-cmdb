<template>
  <Row>
    <Col span="19">
      <WeCMDBAttrInput
        v-if="mappingType === 'CMDB_CI_TYPE'"
        :allCiTypes="allCiTypes"
        :cmdbColumnSource="paramData.cmdbColumnSource"
        :rootCiType="rootCiType"
        v-model="cmdbAttr"
        :ciTypesObj="ciTypesObj"
        :ciTypeAttributeObj="ciTypeAttributeObj"
        @change="cmdbAttrChangeHandler"
      />
      <Select
        v-if="mappingType === 'CMDB_ENUM_CODE'"
        @on-change="cmdbEnumCodeChangeHandler"
        v-model="cmdbEnumCode"
        filterable
      >
        <Option v-for="item in allCodes" :value="item.value" :key="item.value">{{ item.label }}</Option>
      </Select>
    </Col>
    <Col span="4" offset="1">
      <Select @on-change="mappingTypeChangeHandler" v-model="mappingType" filterable>
        <Option value="CMDB_CI_TYPE" key="CMDB_CI_TYPE">{{ $t('ci_type_attribute') }}</Option>
        <Option value="CMDB_ENUM_CODE" key="CMDB_ENUM_CODE">{{ $t('form_enum_type') }}</Option>
      </Select>
    </Col>
  </Row>
</template>
<script>
import WeCMDBAttrInput from './attr-input'
export default {
  components: {
    WeCMDBAttrInput
  },
  data () {
    return {
      mappingType: 'CMDB_CI_TYPE',
      cmdbEnumCode: 0,
      cmdbAttr: ''
    }
  },
  props: {
    allCiTypes: { required: true },
    allCodes: { required: true },
    rootCiType: { required: true },
    ciTypesObj: { required: true },
    ciTypeAttributeObj: { required: true },
    paramData: { required: true },
    value: {}
  },
  watch: {
    paramData: {
      handler (val) {
        this.mappingType = val.mappingType
        this.cmdbEnumCode = val.cmdbEnumCode
      },
      immediate: true
    }
  },
  mounted () {
    this.$emit('input', this.outputValue)
  },
  computed: {
    outputValue () {
      if (this.mappingType === 'CMDB_CI_TYPE') {
        return {
          mappingType: this.mappingType,
          cmdbEnumCode: null,
          cmdbColumnSource: this.cmdbAttr.cmdbColumnSource,
          cmdbColumnCriteria: this.cmdbAttr.cmdbColumnCriteria
        }
      } else {
        return {
          mappingType: this.mappingType,
          cmdbEnumCode: this.cmdbEnumCode,
          cmdbColumnSource: null,
          cmdbColumnCriteria: null
        }
      }
    }
  },
  methods: {
    mappingTypeChangeHandler (v) {
      this.$emit('input', this.outputValue)
    },
    cmdbAttrChangeHandler (v) {
      this.$emit('input', this.outputValue)
    },
    cmdbEnumCodeChangeHandler (v) {
      this.$emit('input', this.outputValue)
    }
  }
}
</script>
