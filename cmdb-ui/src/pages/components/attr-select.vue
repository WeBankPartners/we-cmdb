<template>
  <div class="container">
    <Input style="width:150px" :placeholder="$t('please_select_ci_type')" v-if="allCmdbAttrs.length === 0"></Input>
    <Input
      style="width:150px"
      v-else
      :placeholder="$t('please_select_ci_type')"
      @on-change="rootChange"
      :value="allCmdbAttrs[0].val"
    ></Input>
    <Select
      :style="{
        'border-radius': '4px',
        width: '150px',
        border: `1px solid ${attr.color}`
      }"
      v-for="(attr, index) in allCmdbAttrs"
      v-if="index > 0"
      :key="index"
      filterable
      @on-query-change="selectChange($event, index)"
      v-model="attr.val"
      @on-change="changeValue($event, index)"
    >
      <Option v-for="opt in attr.options" :key="opt.attrId" :value="opt.refName">{{
        `${opt.ciTypeName} ( ${opt.refName} )`
      }}</Option>
    </Select>
  </div>
</template>
<script>
import { getRefCiTypeFrom, getCiTypeAttr } from '@/api/server.js'
export default {
  data () {
    return {
      loading: false,
      opt: [],
      rootCiTypeOption: [],
      allCmdbAttrs: [],
      allCi: [],
      currentValue: {
        id: '',
        label: ''
      }
    }
  },
  props: {
    value: {
      type: Object,
      required: false
    },
    rootCiType: {
      default: ''
    },
    allCiTypes: {
      type: Array,
      required: true
    },
    cmdbColumnSource: {
      default: ''
    }
  },
  watch: {
    value (val) {},
    cmdbColumnSource (val) {},
    rootCiType (val) {
      this.allCmdbAttrs = []
      const ci = this.allCi.find(_ => _.ciTypeId === val)
      if (ci) {
        const opt = {
          name: ci.name,
          ciTypeName: ci.name,
          refName: ci.name,
          ciTypeId: ci.ciTypeId,
          id: ci.ciTypeId,
          attrId: null
        }
        this.allCmdbAttrs.push({
          val: ci.name,
          type: 'root',
          color: '#FFD225',
          options: [opt]
        })
      }

      this.$emit('input', this.getValue(this.allCmdbAttrs))
    }
  },
  mounted () {
    this.restoreOpeation()
    this.formatAllCiType()
  },
  methods: {
    restoreOpeation () {
      if (this.cmdbColumnSource) {
        const colors = {
          ref: '#FFD225',
          attr: '#9BC418',
          root: ''
        }
        const h = JSON.parse(this.cmdbColumnSource)
        const attrs = []
        h.forEach(async _ => {
          let opt = []
          if (_.t === 'root') {
            opt = [
              {
                ciTypeName: _.v,
                refName: _.v,
                ciTypeId: _.id,
                attrId: null
              }
            ]
          }
          if (_.t === 'ref') {
            let { statusCode, data } = await getRefCiTypeFrom(_.id)
            if (statusCode === 'OK') {
              opt = data.map(p => {
                return {
                  ...p,
                  ciTypeName: p.name,
                  refName: p.refName,
                  ciTypeId: p.ciTypeId,
                  attrId: p.refPropertyId
                }
              })
            }
          }
          if (_.t === 'attr') {
            let { statusCode, data } = await getCiTypeAttr(_.id)
            if (statusCode === 'OK') {
              opt = data.map(p => {
                return {
                  ...p,
                  ciTypeName:
                    p.inputType === 'ref'
                      ? this.allCi.find(i => i.ciTypeId === p.referenceId).name
                      : this.allCi.find(i => i.ciTypeId === _.id).name,
                  refName: p.name,
                  ciTypeId: _.id,
                  attrId: p.ciTypeAttrId
                }
              })
            }
          }
          attrs.push({
            color: colors[_.t],
            type: _.t,
            val: _.v,
            options: opt
          })
        })
        this.allCmdbAttrs = attrs
        this.$emit('input', this.getValue(attrs))
      }
    },
    rootChange (val) {
      this.allCmdbAttrs = [this.allCmdbAttrs.shift()]
      this.getNextRef(val.data)
      this.$emit('input', this.getValue(this.allCmdbAttrs))
    },
    selectChange (val, index) {
      const operator = val.charAt(val.length - 1)
      this.getNextRef(operator)
      this.$emit('input', this.getValue(this.allCmdbAttrs))
    },
    async getNextRef (operator) {
      const lastciTypeName = this.allCmdbAttrs[this.allCmdbAttrs.length - 1].val
      const found = this.allCmdbAttrs[this.allCmdbAttrs.length - 1].options.find(_ => _.refName === lastciTypeName)
      const isRef = found && found.inputType && found.inputType === 'ref'
      if (found && (!found.inputType || isRef)) {
        const id = isRef ? found.referenceId : found.ciTypeId
        if (operator === '.') {
          let { statusCode, data, message } = await getCiTypeAttr(id)
          if (statusCode === 'OK') {
            const opt = data.map(_ => {
              return {
                ..._,
                ciTypeName:
                  _.inputType === 'ref'
                    ? this.allCi.find(i => i.ciTypeId === _.referenceId).name
                    : this.allCi.find(i => i.ciTypeId === found.ciTypeId).name,
                refName: _.name,
                ciTypeId: id,
                id: _.inputType === 'ref' ? _.referenceId : id,
                attrId: _.ciTypeAttrId
              }
            })
            this.allCmdbAttrs.push({
              val: '',
              color: '#9BC418',
              type: 'attr',
              options: opt
            })
            this.$emit('input', this.getValue(this.allCmdbAttrs))
          } else {
            this.$Message.error({
              content: message
            })
          }
        }
        if (operator === '-') {
          let { statusCode, data, message } = await getRefCiTypeFrom(id)
          if (statusCode === 'OK') {
            const opt = data.map(_ => {
              return {
                ..._,
                ciTypeName: _.name,
                refName: _.refName,
                ciTypeId: _.ciTypeId,
                id: _.ciTypeId,
                attrId: _.refPropertyId
              }
            })
            this.allCmdbAttrs.push({
              val: '',
              color: '#FFD225',
              type: 'ref',
              options: opt
            })
            this.$emit('input', this.getValue(this.allCmdbAttrs))
          } else {
            this.$Message.error({
              content: message
            })
          }
        }
      }
    },
    formatAllCiType () {
      this.allCiTypes.forEach(_ => {
        this.allCi = this.allCi.concat([..._.ciTypes])
      })
    },
    getValue (data) {
      let val = {
        cmdbColumnCriteria: [],
        cmdbColumnSource: []
      }
      let criteria = {
        ciTypeId: '',
        ciTypeName: '',
        routine: [],
        attributes: []
      }
      data.forEach((_, i) => {
        const opt = _.type === 'attr' ? _.options.find(i => i.name === _.val) : _.options.find(i => i.refName === _.val)
        const prev = i > 0 ? data[i - 1] : data[0]
        //
        if (opt) {
          const nodeId = _.type === 'ref' ? prev.options.find(o => o.name === prev.val).id : opt.ciTypeId
          criteria.ciTypeId = opt.ciTypeId
          criteria.ciTypeName = opt.ciTypeName
          criteria.attributes = [
            {
              attrId: opt.attrId,
              isCondition: true,
              isDiaplayed: true
            }
          ]
          opt.attrId && criteria.routine.push(opt.attrId)
          criteria.routine.push(opt.ciTypeId)
          val.cmdbColumnSource.push({
            id: nodeId,
            // id: opt.ciTypeId,
            v: _.val,
            t: _.type
          })
        }
      })
      val.cmdbColumnCriteria.push(criteria)
      return val
    },
    changeValue (val, index) {
      this.allCmdbAttrs = this.allCmdbAttrs.slice(0, index + 1)
      this.$emit('input', this.getValue(this.allCmdbAttrs))
    }
  }
}
</script>
<style lang="scss">
.container {
  .ivu-select-selection {
    border: none;
    box-shadow: 0 0 0 0;
  }
}
</style>
