<template>
  <div class="attr_input">
    <Poptip v-if="!isReadOnly" v-model="optionsHide" placement="bottom">
      <div ref="wecube_cmdb_attr" class="input_in">
        <textarea ref="textarea" :rows="1.5" @input="inputHandler" :value="inputVal"></textarea>
        <span class="wecube-error-message">{{ $t('please_select_without_refrence') }}</span>
      </div>
      <div slot="content">
        <div v-if="rootCiType" class="attr-ul">
          <ul v-for="opt in options" :key="opt.attrId">
            <li class="" @click="optClickHandler(opt)">
              {{ opt.inputType === 'ref' ? `( ${opt.ciTypeAttrName} ) ${opt.ciTypeName}` : opt.ciTypeAttrName }}
            </li>
          </ul>
        </div>
        <div v-else class="attr-ul">
          <ul v-for="opt in allCi" :key="opt.ciTypeId">
            <li @click="() => rootCiTypeChange(opt)">{{ opt.name }}</li>
          </ul>
        </div>
      </div>
    </Poptip>
    <span v-else>{{ displayValue }}</span>
  </div>
</template>
<script>
import { getRefCiTypeFrom, getCiTypeAttr } from '@/api/server.js'
export default {
  data () {
    return {
      optionsHide: false,
      isRefFromParent: null,
      allCi: [],
      options: [],
      inputVal: '',
      inputValBackup: '',
      routine: []
    }
  },
  computed: {
    displayValue () {
      if (this.sourceData) {
        const data = JSON.parse(this.sourceData)
        return data
          .map(_ => {
            let ciType = ''
            let ciTypeAttr = ''
            let refType = ''
            ciType = this.ciTypesObj[_.ciTypeId].name
            if (_.parentRs) {
              refType = _.parentRs.isReferedFromParent === 1 ? '.' : '-'
              ciTypeAttr = `(${this.ciTypeAttributeObj[_.parentRs.attrId].name})`
              if (this.ciTypeAttributeObj[_.parentRs.attrId].inputType !== 'ref') {
                ciTypeAttr = this.ciTypeAttributeObj[_.parentRs.attrId].name
                return refType + ciTypeAttr
              }
            }
            return refType + ciTypeAttr + ciType
          })
          .join(' ')
      }
    }
  },
  props: {
    value: {
      required: false
    },
    rootCiType: {
      default: ''
    },
    allCiTypes: {
      type: Array
    },
    cmdbColumnSource: {
      default: ''
    },
    canReSelectCiType: {
      default: false,
      required: false
    },
    isReadOnly: {
      default: false,
      required: false
    },
    ciTypesObj: {
      default: null,
      required: false
    },
    ciTypeAttributeObj: {
      default: null,
      required: false
    },
    sourceData: {
      type: String,
      required: false
    },
    isEndWithCIType: {
      type: Boolean,
      default: false,
      required: false
    }
  },
  watch: {
    cmdbColumnSource (val) {
      this.restoreOpeation()
    },
    ciTypeAttributeObj (val) {
      this.restoreOpeation()
    },
    rootCiType (val) {
      if (!val) {
        return
      }
      this.routine = []
      if (val) {
        const ci = this.allCi.find(_ => _.ciTypeId === val)
        this.routine.push({
          ciTypeId: ci.ciTypeId,
          ciTypeName: ci.name
        })
        this.inputVal = ci.name + ' '
      }
      this.$emit('input', this.getValue(this.routine))
      this.$emit('change', this.getValue(this.routine))
    },
    allCiTypes (val) {
      this.formatAllCiType()
    },
    routine (val) {
      this.$emit('updateRoutine', this.getValue(val).cmdbColumnCriteria.routine)
      const attrId = val[val.length - 1].ciTypeAttrId
      if (attrId) {
        if (
          this.ciTypeAttributeObj[attrId].inputType === 'ref' ||
          this.ciTypeAttributeObj[attrId].inputType === 'multiRef'
        ) {
          !this.isEndWithCIType && this.$refs['wecube_cmdb_attr'].classList.add('wecube-error')
        } else {
          this.$refs['wecube_cmdb_attr'].classList.remove('wecube-error')
        }
      }
    }
  },
  methods: {
    restoreOpeation () {
      if (this.cmdbColumnSource && this.ciTypeAttributeObj) {
        this.routine = JSON.parse(this.cmdbColumnSource)
        let val = this.ciTypesObj[this.routine[0].ciTypeId].name + ' '
        this.routine.forEach((_, i) => {
          if (i > 0) {
            const refVal = _.isReferedFromParent === 1 ? '.' : '-'
            const ciTypeAttrName = this.ciTypeAttributeObj[_.ciTypeAttrId].name
            const ciTypeName = this.ciTypesObj[_.ciTypeId].name
            const newVal =
              this.ciTypeAttributeObj[_.ciTypeAttrId].inputType === 'ref'
                ? `(${ciTypeAttrName})${ciTypeName} `
                : ciTypeAttrName + ' '
            val = val + refVal + newVal
          }
        })
        this.inputVal = val
        this.$emit('input', this.getValue(this.routine))
        this.$emit('change', this.getValue(this.routine))
      } else {
        if (this.rootCiType) {
          const ci = this.allCi.find(_ => _.ciTypeId === this.rootCiType)
          this.routine.push({
            ciTypeId: ci.ciTypeId,
            ciTypeName: ci.name
          })
          this.inputVal = ci.name + ' '
          this.$emit('input', this.getValue(this.routine))
          this.$emit('change', this.getValue(this.routine))
        }
      }
    },
    async getNextRef (operator) {
      const last = this.routine[this.routine.length - 1]
      const isRef = !last.isReferedFromParent || this.ciTypeAttributeObj[last.ciTypeAttrId].inputType === 'ref'
      if (isRef) {
        const id = this.routine[this.routine.length - 1].ciTypeId
        if (operator === '.') {
          this.inputVal = this.inputVal + operator
          let { statusCode, data, message } = await getCiTypeAttr(id)
          if (statusCode === 'OK') {
            let attr = []
            data.forEach(_ => {
              if (_.status === 'created') {
                attr.push({
                  ..._,
                  ciTypeName:
                    _.inputType === 'ref'
                      ? this.allCi.find(i => i.ciTypeId === _.referenceId).name
                      : this.allCi.find(i => i.ciTypeId === _.ciTypeId).name,
                  ciTypeAttrName: _.name,
                  isReferedFromParent: 1,
                  id: _.inputType === 'ref' ? _.referenceId : _.ciTypeId
                })
              }
            })
            this.options = this.isEndWithCIType
              ? attr.filter(_ => _.inputType === 'ref' || _.inputType === 'multiRef')
              : attr
          } else {
            this.$Message.error({
              content: message
            })
          }
        }
        if (operator === '-') {
          this.inputVal = this.inputVal + operator
          let { statusCode, data, message } = await getRefCiTypeFrom(id)
          if (statusCode === 'OK') {
            this.options = data.map(_ => {
              let found = this.allCi.find(i => i.ciTypeId === _.ciTypeId)
              return {
                ..._,
                ciTypeName: found ? found.name : '',
                ciTypeAttrName: _.name,
                ciTypeAttrId: _.ciTypeAttrId,
                isReferedFromParent: 0,
                id: _.ciTypeId
              }
            })
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
        this.allCi = this.allCi.concat(_.ciTypes ? [..._.ciTypes] : [])
      })
    },
    inputHandler (v) {
      if (!v.data) {
        let valList = this.inputVal.split(' ')
        let val = ''
        if (valList.length > 2) {
          valList.splice(-2, 2)
          valList.forEach(_ => {
            val += _ + ' '
          })
          this.inputVal = val
          this.routine.splice(-1, 1)
          this.$emit('input', this.getValue(this.routine))
          this.$emit('change', this.getValue(this.routine))
        } else if (valList.length <= 2 && this.canReSelectCiType) {
          this.inputVal = ''
          this.routine = []
          this.$emit('input', this.getValue(this.routine))
          this.$emit('change', this.getValue(this.routine))
          this.$emit('handleRootCiTypeChange', '')
        }
        this.$refs.textarea.value = this.inputVal
        return
      }
      if (!(v.data === '.' || v.data === '-')) {
        this.$Message.error({
          content: this.$t('please_input_legitimate_character')
        })
        this.$refs.textarea.value = this.inputVal
      } else {
        if (this.inputVal[this.inputVal.length - 1] === '.' || this.inputVal[this.inputVal.length - 1] === '-') {
          this.inputVal = this.inputVal.substr(0, this.inputVal.length - 1)
        }
        this.routine.length > 0 && this.getNextRef(v.data)
        this.optionsHide = true
      }
    },
    optClickHandler (item) {
      this.optionsHide = false
      const newValue =
        item.inputType === 'ref' ? `(${item.ciTypeAttrName})${item.ciTypeName} ` : item.ciTypeAttrName + ' '
      this.inputVal = this.inputVal + newValue
      this.inputValBackup = this.inputVal
      this.routine.push({
        ...item,
        ciTypeId: item.id,
        ciTypeName: this.allCi.find(i => i.ciTypeId === item.id).name
      })
      this.options = []
      this.$refs['textarea'].focus()
      this.$emit('input', this.getValue(this.routine))
      this.$emit('change', this.getValue(this.routine))
    },
    getValue (data) {
      let val = {
        cmdbColumnCriteria: {
          routine: [],
          attribute: {
            attrId: '',
            isCondition: true,
            isDiaplayed: true
          }
        },
        cmdbColumnSource: []
      }
      data.forEach((_, i) => {
        if (i === 0) {
          val.cmdbColumnSource.push({ ciTypeId: _.ciTypeId })
          val.cmdbColumnCriteria.routine.push({ ciTypeId: _.ciTypeId })
        } else {
          val.cmdbColumnCriteria.routine.push({
            ciTypeId: _.ciTypeId,
            parentRs: {
              attrId: _.ciTypeAttrId,
              isReferedFromParent: _.isReferedFromParent
            }
          })
          val.cmdbColumnCriteria.attribute.attrId = _.ciTypeAttrId
          val.cmdbColumnSource.push({
            ciTypeId: _.ciTypeId,
            ciTypeAttrId: _.ciTypeAttrId,
            isReferedFromParent: _.isReferedFromParent
          })
        }
      })
      return val
    },
    blurHandler () {
      this.optionsHide = false
    },
    rootCiTypeChange (opt) {
      this.$emit('handleRootCiTypeChange', opt.ciTypeId)
      this.optionsHide = false
    }
  },
  mounted () {
    this.formatAllCiType()
    this.restoreOpeation()
    if (document.querySelector('.attr-ul')) {
      document.querySelector('.attr-ul').style.width = document.querySelector('.input_in textarea').clientWidth + 'px'
    }
  }
}
</script>
<style lang="scss">
* {
  padding: 0;
  margin: 0;
  list-style: none;
  font-size: 14px;
}
.attr-ul {
  width: 100%;
  z-index: 3000;
  background: white;
  max-height: 200px;
  overflow: auto;
}
.attr_input .ivu-poptip {
  width: 100%;
}
.attr_input .ivu-poptip .ivu-poptip-rel {
  width: 100%;
}
.input_in {
  width: 100%;
  display: flex;
  flex-direction: column;

  textarea {
    font-size: 11px;
    line-height: 28px;
    width: 100%;
    border-radius: 5px;
  }
  .wecube-error-message {
    display: none;
  }

  &.wecube-error {
    textarea {
      border: 1px solid #f00;
    }
    .wecube-error-message {
      display: block;
      height: 20px;
      line-height: 16px;
      color: #f00;
      padding: 2px 0;
      font-size: 12px;
    }
  }
}
.attr-ul ul {
  width: 100%;
  border-radius: 3px;
}
.ul-li-selected {
  color: rgb(6, 130, 231);
}
.attr-ul ul li {
  width: 100%;
  height: 25px;
  line-height: 25px;
  cursor: pointer;
  &:hover {
    background-color: rgb(227, 231, 235);
  }
}
</style>
