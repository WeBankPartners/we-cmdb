<template>
  <div class="filter_rule">
    <Poptip v-model="optionsHide" placement="bottom">
      <div class="input_in">
        <textarea ref="textarea" :rows="2" @input="inputHandler" :value="inputVal" :disabled="disabled"></textarea>
      </div>
      <div slot="content">
        <div class="attr-ul">
          <ul v-for="opt in allCi" :key="opt.ciTypeId">
            <li @click="selectCiType(opt)">{{ opt.name }}</li>
          </ul>
          <ul v-for="opt in attrNameArray" :key="opt.attrId">
            <li @click="selectAttr(opt)">
              {{
                opt.inputType === 'ref' || opt.inputType === 'multiRef'
                  ? `( ${opt.ciTypeAttrName} ) ${opt.ciTypeName}`
                  : opt.ciTypeAttrName
              }}
            </li>
          </ul>
          <ul v-if="isShowSelect" v-for="item in enumCodes" :key="item">
            <li @click="selectEnumCode(item)">{{ item }}</li>
          </ul>
          <ul v-if="isShowSelectRules" v-for="item in rules" :key="item">
            <li @click="selectRules(item)">{{ item }}</li>
          </ul>
        </div>
      </div>
    </Poptip>
  </div>
</template>

<script>
import { getRefCiTypeFrom, getCiTypeAttr } from '@/api/server.js'
export default {
  data () {
    return {
      optionsHide: false,
      options: [],
      inputVal: '',
      isInputStartWithArray: false,
      allCi: [],
      lastCiTypeId: 0,
      filters: [],
      attrNameArray: [],
      isShowSelect: false,
      isShowSelectRules: false,
      isLeftFilterRuleStart: false,
      isLeftFilterRule: true,
      enumCodes: ['codeId', 'code', 'value', 'groupCodeId'],
      rules: ['and'],
      filterRuleArray: [],
      inputRuleStatus: 1 // 0 - 花括号内 ; 1 - 花括号外
    }
  },
  props: {
    filterAttr: {},
    allLayers: {
      required: true,
      default: []
    },
    disabled: {
      required: false,
      default: false
    },
    value: {
      required: true,
      default: ''
    },
    rootCiTypeId: {
      required: false
    }
  },
  computed: {
    allCiTypes () {
      let result = []
      this.allLayers.forEach(layer => {
        if (layer.ciTypes instanceof Array) {
          result = result.concat(layer.ciTypes)
        }
      })
      return result
    },
    ciTypesObj () {
      let obj = {}
      this.allCiTypes.forEach(_ => {
        obj[_.ciTypeId] = _
      })
      return obj
    },
    ciTypeAttrsObj () {
      let obj = {}
      this.allCiTypes.forEach(ciType => {
        ciType.attributes.forEach(attr => {
          obj[attr.ciTypeAttrId] = attr
        })
      })
      return obj
    },
    filterRuleLastObjValue () {
      return this.filterRuleArray[this.filterRuleArray.length - 1]
    }
  },
  watch: {
    optionsHide () {
      let doms = document.getElementsByClassName('attr-ul')
      for (let i = 0; i < doms.length; i++) {
        doms[i].style.width = this.$refs.textarea.clientWidth + 'px'
      }
    },
    allCiTypes () {
      this.displayInputData()
    }
  },
  mounted () {
    this.displayInputData()
  },
  methods: {
    inputHandler (v) {
      if (this.inputRuleStatus === 1) {
        if (v.data) {
          if (v.data === '{') {
            if (!this.isLeftFilterRuleStart) {
              if (this.filterAttr.inputType === 'ref' || this.filterAttr.inputType === 'multiRef') {
                this.inputVal = this.$refs.textarea.value + ' ' + this.filterAttr.name + ' '
                const val = [
                  {
                    ciTypeId: this.filterAttr.referenceId
                  }
                ]
                this.filterRuleArray.push(val)
                this.inputRuleStatus = 0
                this.lastCiTypeId =
                  this.filterAttr.inputType === 'ref' || this.filterAttr.inputType === 'multiRef'
                    ? this.filterAttr.referenceId
                    : this.filterAttr.ciTypeId
              } else if (this.filterAttr.inputType === 'select' || this.filterAttr.inputType === 'multiSelect') {
                this.isShowSelect = true
                this.optionsHide = true
                this.inputRuleStatus = 0
                this.inputVal = this.$refs.textarea.value + ' ' + this.filterAttr.name + ' '
                const val = [
                  {
                    ciTypeId: this.filterAttr.ciTypeId
                  },
                  {
                    ciTypeId: this.filterAttr.ciTypeId,
                    parentRs: {
                      attrId: this.filterAttr.ciTypeAttrId,
                      isReferedFromParent: 1
                    }
                  }
                ]
                this.filterRuleArray.push(val)
              } else {
                this.inputVal = this.$refs.textarea.value + ' ' + this.filterAttr.name + ' '
                const val = [
                  {
                    ciTypeId: this.rootCiTypeId
                  }
                ]
                this.filterRuleArray.push(val)
              }
              this.isLeftFilterRuleStart = true
            } else {
              if (this.rootCiTypeId) {
                this.inputVal = this.$refs.textarea.value + ' ' + this.ciTypesObj[this.rootCiTypeId].name + ' '
                const val = [
                  {
                    ciTypeId: this.rootCiTypeId
                  }
                ]
                this.filterRuleArray.push(val)
              } else {
                this.inputVal = this.$refs.textarea.value + ' '
                this.allCi = this.allCiTypes
                this.optionsHide = true
              }
              this.inputRuleStatus = 0
            }
          } else if (v.data === ' ') {
            const val = this.inputVal.split(' ')
            if (this.filterRuleArray.length % 2 === 0 && this.filterRuleArray.length > 0) {
              if (val[val.length - 2] === '}' || val[val.length - 2].indexOf(']') !== -1) {
                this.isShowSelectRules = true
                this.optionsHide = true
              } else {
                this.$refs.textarea.value = this.inputVal
                this.$Message.error({
                  content: this.$t('filter_rule_input_tips_to_start_rule')
                })
              }
            } else {
              if (val[val.length - 2] === 'in') {
                this.$refs.textarea.value = this.inputVal
                this.$Message.error({
                  content: this.$t('filter_rule_input_tips_to_start_rule_without_any_input')
                })
              } else {
                this.$refs.textarea.value = this.inputVal
                this.$Message.error({
                  content: this.$t('filter_rule_input_tips_to_start_rule')
                })
              }
            }
          } else if (v.data === '[') {
            if (this.filterRuleArray.length % 2 === 1 && this.filterRuleArray.length > 0) {
              this.isInputStartWithArray = true
              this.inputRuleStatus = 0
              this.inputVal = this.$refs.textarea.value
            } else {
              this.$refs.textarea.value = this.inputVal
              this.$Message.error({
                content: this.$t('filter_rule_input_tips_to_start_rule')
              })
            }
          } else {
            const val = this.inputVal.split(' ')
            if (val.length > 1) {
              if (val[val.length - 2] === '}' || val[val.length - 2].indexOf(']') !== -1) {
                this.$refs.textarea.value = this.inputVal
                this.$Message.error({
                  content: this.$t('filter_rule_input_tips_to_link_rule')
                })
              } else if (val[val.length - 2] === 'in') {
                this.$refs.textarea.value = this.inputVal
                this.$Message.error({
                  content: this.$t('filter_rule_input_tips_to_start_rule_without_any_input')
                })
              } else {
                this.$refs.textarea.value = this.inputVal
                this.$Message.error({
                  content: this.$t('filter_rule_input_tips_to_start_rule')
                })
              }
            } else {
              this.$refs.textarea.value = this.inputVal
              this.$Message.error({
                content: this.$t('filter_rule_input_tips_to_start_rule')
              })
            }
          }
        } else if (v.inputType === 'deleteContentBackward') {
          const val = this.inputVal.split(' ')
          if (val[val.length - 2] !== '}') {
            if (val[val.length - 2] === 'in') {
              this.inputVal = this.inputVal.substr(0, this.inputVal.lastIndexOf('{'))
              this.filterRuleArray.splice(-1, 1)
              if (this.filterRuleArray.length % 2 === 0) {
                this.isLeftFilterRuleStart = false
                this.isLeftFilterRule = true
                this.createRespRuleData()
                if (this.filterRuleArray.length !== 0) {
                  this.$emit('input', JSON.stringify(this.filters))
                } else {
                  this.$emit('input', '')
                }
              } else {
                this.isLeftFilterRuleStart = true
                this.isLeftFilterRule = false
              }
            } else if (val[val.length - 2].indexOf('[') !== -1) {
              this.inputVal = this.inputVal.substr(0, this.inputVal.lastIndexOf('['))
              this.filterRuleArray.splice(-1, 1)
              this.isLeftFilterRuleStart = true
            } else if (val[val.length - 3].indexOf(']') !== -1) {
              this.inputVal = this.inputVal.substr(0, this.inputVal.lastIndexOf(']') + 2)
              this.isLeftFilterRuleStart = false
            } else {
              this.inputVal = this.inputVal.substr(0, this.inputVal.lastIndexOf('}') + 2)
            }
          } else {
            this.inputVal = this.inputVal.substr(0, this.inputVal.lastIndexOf('{'))
            this.filterRuleArray.splice(-1, 1)
            if (this.filterRuleArray.length % 2 === 0) {
              this.isLeftFilterRule = true
              this.isLeftFilterRuleStart = false
            } else {
              this.isLeftFilterRuleStart = true
              this.isLeftFilterRule = false
            }
          }
          this.optionsHide = false
          this.isShowSelectRules = false
        } else {
          this.$refs.textarea.value = this.inputVal
        }
      } else {
        if (v.data) {
          if (this.isInputStartWithArray === true) {
            // eslint-disable-next-line no-useless-escape
            const rule = /[\,\"\_a-zA-Z0-9]{1}/
            if (rule.test(v.data)) {
              this.inputVal = this.$refs.textarea.value
            } else if (v.data === ']') {
              this.isInputStartWithArray = false
              this.inputRuleStatus = 1
              this.isLeftFilterRuleStart = false
              this.isLeftFilterRule = false
              this.inputVal = this.$refs.textarea.value
              let groupInfo = this.inputVal
                .substring(this.inputVal.lastIndexOf('[') + 1, this.inputVal.lastIndexOf(']'))
                .split(',')
              this.filterRuleArray.push(groupInfo)
              this.inputVal = this.$refs.textarea.value + ' '
              this.createRespRuleData()
              if (this.filterRuleArray.length !== 0) {
                this.$emit('input', JSON.stringify(this.filters))
              } else {
                this.$emit('input', '')
              }
            }
          } else {
            const objList = this.filterRuleLastObjValue
            const obj = objList[objList.length - 1]
            if (
              !obj.parentRs ||
              this.ciTypeAttrsObj[obj.parentRs.attrId].inputType === 'ref' ||
              this.ciTypeAttrsObj[obj.parentRs.attrId].inputType === 'multiRef'
            ) {
              if (this.isLeftFilterRule) {
                if (v.data === '.') {
                  if (
                    this.inputVal[this.inputVal.length - 1] === '.' ||
                    this.inputVal[this.inputVal.length - 1] === '-'
                  ) {
                    this.inputVal = this.inputVal.replace(/.$/, v.data)
                  } else {
                    this.inputVal = this.$refs.textarea.value
                  }
                  this.optionsHide = true
                  this.getNextRef(v.data)
                } else {
                  this.$refs.textarea.value = this.inputVal
                  this.$Message.error({
                    content: this.$t('filter_tule_please_input_legitimate_character')
                  })
                }
              } else {
                if (v.data === '.' || v.data === '-') {
                  if (
                    this.inputVal[this.inputVal.length - 1] === '.' ||
                    this.inputVal[this.inputVal.length - 1] === '-'
                  ) {
                    this.inputVal = this.inputVal.replace(/.$/, v.data)
                  } else {
                    this.inputVal = this.$refs.textarea.value
                  }
                  this.optionsHide = true
                  this.getNextRef(v.data)
                } else {
                  this.$refs.textarea.value = this.inputVal
                  this.$Message.error({
                    content: this.$t('please_input_legitimate_character')
                  })
                }
              }
            } else if (
              !obj.parentRs ||
              ((this.ciTypeAttrsObj[obj.parentRs.attrId].inputType === 'select' ||
                this.ciTypeAttrsObj[obj.parentRs.attrId].inputType === 'multiSelect') &&
                !obj.enumCodeAttr)
            ) {
              this.$refs.textarea.value = this.inputVal
              this.$Message.error({
                content: this.$t('please_select_enum')
              })
            } else {
              if (v.data === '}') {
                if (this.filterRuleArray.length > 0 && this.filterRuleArray.length % 2 === 1) {
                  this.inputVal = this.$refs.textarea.value + ' in '
                  this.isLeftFilterRuleStart = true
                  this.isLeftFilterRule = false
                } else if (this.filterRuleArray.length > 0 && this.filterRuleArray.length % 2 === 0) {
                  this.inputVal = this.$refs.textarea.value + ' '
                  this.isLeftFilterRuleStart = false
                  this.isLeftFilterRule = true
                  this.createRespRuleData()
                  if (this.filterRuleArray.length !== 0) {
                    this.$emit('input', JSON.stringify(this.filters))
                  } else {
                    this.$emit('input', '')
                  }
                }
                this.inputRuleStatus = 1
              } else {
                this.$refs.textarea.value = this.inputVal
                this.$Message.error({
                  content: this.$t('filter_rule_input_tips_to_end_rule')
                })
              }
            }
          }
        } else if (v.inputType === 'deleteContentBackward') {
          if (this.isInputStartWithArray === true) {
            this.inputVal = this.inputVal.substr(0, this.inputVal.lastIndexOf('['))
            this.inputRuleStatus = 1
            this.isLeftFilterRuleStart = true
            this.isInputStartWithArray = false
          } else {
            this.inputVal = this.inputVal.substr(0, this.inputVal.lastIndexOf('{'))
            this.inputRuleStatus = 1
            this.filterRuleArray.splice(-1, 1)
            if (this.filterRuleArray.length % 2 === 0) {
              this.isLeftFilterRule = true
              this.isLeftFilterRuleStart = false
            } else {
              this.isLeftFilterRule = false
              this.isLeftFilterRuleStart = true
            }
            this.optionsHide = false
            this.isShowSelect = false
          }
        } else {
          this.$refs.textarea.value = this.inputVal
        }
      }
    },
    createRespRuleData () {
      let filterNum = 1
      if (this.filterRuleArray.length > 0) {
        this.filters = [{}]
        for (let i = 0; i < this.filterRuleArray.length; i++) {
          if (i % 2 === 1) {
            continue
          } else {
            const rs = `filter_${filterNum}`
            if (i + 1 < this.filterRuleArray.length) {
              if (this.filterRuleArray[i + 1][0].ciTypeId) {
                this.filters[0][rs] = {
                  left: JSON.stringify(this.filterRuleArray[i]),
                  operator: 'in',
                  right: JSON.stringify(this.filterRuleArray[i + 1])
                }
              } else {
                this.filters[0][rs] = {
                  left: JSON.stringify(this.filterRuleArray[i]),
                  operator: 'in',
                  right: this.filterRuleArray[i + 1]
                }
              }
            }
            filterNum++
          }
        }
      }
    },
    async getNextRef (operator) {
      const objList = this.filterRuleLastObjValue
      const obj = objList[objList.length - 1]
      let attrArray = []
      if (operator === '.') {
        if (this.lastCiTypeId !== 0) {
          let { statusCode, data } = await getCiTypeAttr(this.lastCiTypeId)
          if (statusCode === 'OK') {
            data.forEach(_ => {
              attrArray.push({
                ..._,
                ciTypeName:
                  _.inputType === 'ref' || _.inputType === 'multiRef'
                    ? this.allCiTypes.find(i => i.ciTypeId === _.referenceId).name
                    : this.allCiTypes.find(i => i.ciTypeId === _.ciTypeId).name,
                ciTypeAttrName: _.name,
                isReferedFromParent: 1,
                id: _.inputType === 'ref' || _.inputType === 'multiRef' ? _.referenceId : _.ciTypeId
              })
            })
            this.attrNameArray = attrArray
          }
          this.lastCiTypeId = 0
        } else {
          let { statusCode, data } = await getCiTypeAttr(obj.ciTypeId)
          if (statusCode === 'OK') {
            if (
              this.isLeftFilterRule === true &&
              objList.length === 2 &&
              (this.ciTypeAttrsObj[objList[1].parentRs.attrId].inputType === 'ref' ||
                this.ciTypeAttrsObj[objList[1].parentRs.attrId].inputType === 'multiRef')
            ) {
              data.forEach(_ => {
                if (_.propertyName === 'guid') {
                  attrArray.push({
                    ..._,
                    ciTypeName:
                      _.inputType === 'ref' || _.inputType === 'multiRef'
                        ? this.allCiTypes.find(i => i.ciTypeId === _.referenceId).name
                        : this.allCiTypes.find(i => i.ciTypeId === _.ciTypeId).name,
                    ciTypeAttrName: _.name,
                    isReferedFromParent: 1,
                    id: _.inputType === 'ref' || _.inputType === 'multiRef' ? _.referenceId : _.ciTypeId
                  })
                  this.attrNameArray = attrArray
                }
              })
            } else {
              data.forEach(_ => {
                attrArray.push({
                  ..._,
                  ciTypeName:
                    _.inputType === 'ref' || _.inputType === 'multiRef'
                      ? this.allCiTypes.find(i => i.ciTypeId === _.referenceId).name
                      : this.allCiTypes.find(i => i.ciTypeId === _.ciTypeId).name,
                  ciTypeAttrName: _.name,
                  isReferedFromParent: 1,
                  id: _.inputType === 'ref' || _.inputType === 'multiRef' ? _.referenceId : _.ciTypeId
                })
              })
              this.attrNameArray = attrArray
            }
          }
        }
      } else if (operator === '-') {
        if (this.lastCiTypeId !== 0) {
          let { statusCode, data } = await getRefCiTypeFrom(this.lastCiTypeId)
          if (statusCode === 'OK') {
            attrArray = data.map(_ => {
              return {
                ..._,
                ciTypeName: this.allCiTypes.find(i => i.ciTypeId === _.ciTypeId).name,
                ciTypeAttrName: _.name,
                isReferedFromParent: 0,
                id: _.ciTypeId
              }
            })
            this.attrNameArray = attrArray
          }
          this.lastCiTypeId = 0
        } else {
          let { statusCode, data } = await getRefCiTypeFrom(obj.ciTypeId)
          if (statusCode === 'OK') {
            attrArray = data.map(_ => {
              return {
                ..._,
                ciTypeName: this.allCiTypes.find(i => i.ciTypeId === _.ciTypeId).name,
                ciTypeAttrName: _.name,
                isReferedFromParent: 0,
                id: _.ciTypeId
              }
            })
            this.attrNameArray = attrArray
          }
        }
      }
    },
    selectCiType (opt) {
      console.log(JSON.parse(JSON.stringify(opt)))
      this.optionsHide = false
      this.filterRuleArray[this.filterRuleArray.length - 1] = [
        {
          ciTypeId: opt.ciTypeId
        }
      ]
      this.inputVal += opt.name + ' '
      this.allCi = []
      this.$refs.textarea.focus()
    },
    selectAttr (opt) {
      console.log(JSON.parse(JSON.stringify(opt)))
      this.optionsHide = false
      const val = {
        ciTypeId: opt.id,
        parentRs: {
          attrId: opt.ciTypeAttrId,
          isReferedFromParent: opt.isReferedFromParent
        }
      }
      let result = this.filterRuleLastObjValue
      result.push(val)
      this.filterRuleArray[this.filterRuleArray.length - 1] = result
      this.inputVal +=
        opt.inputType === 'ref' || opt.inputType === 'multiRef'
          ? `(${opt.ciTypeAttrName})${opt.ciTypeName} `
          : opt.ciTypeAttrName + ' '
      this.attrNameArray = []
      this.$refs.textarea.focus()
      if (opt.inputType === 'select' || opt.inputType === 'multiSelect') {
        this.isShowSelect = true
        this.optionsHide = true
        this.isShowSelectRules = false
      }
    },
    selectRules (code) {
      console.log(JSON.parse(JSON.stringify(code)))
      this.optionsHide = false
      this.isShowSelectRules = false
      this.inputVal += `${code} `
      this.$refs.textarea.focus()
    },
    selectEnumCode (code) {
      console.log(JSON.parse(JSON.stringify(code)))
      this.optionsHide = false
      this.isShowSelect = false
      this.inputVal += `.${code} `
      let result = this.filterRuleLastObjValue
      result[result.length - 1].enumCodeAttr = code
      this.filterRuleArray[this.filterRuleArray.length - 1] = result
      this.$refs.textarea.focus()
    },
    displayInputData () {
      if (!this.allCiTypes.length || !this.value) {
        return
      }
      if (this.value) {
        this.filterRuleArray = []
        this.inputVal = ''
        this.filters = JSON.parse(this.value)
        const keyArray = Object.keys(this.filters[0])
        let val = '{ '
        if (keyArray.length > 0) {
          let num = 0
          keyArray.forEach(key => {
            let filterLeftRule = JSON.parse(this.filters[0][key].left)
            this.filterRuleArray.push(filterLeftRule)
            filterLeftRule.forEach((item, index) => {
              if (item.parentRs) {
                const attrName = this.ciTypeAttrsObj[item.parentRs.attrId].name
                if (index === 1) {
                  if (this.ciTypeAttrsObj[item.parentRs.attrId].inputType === 'ref') {
                    val += `${this.ciTypesObj[filterLeftRule[0].ciTypeId].name} .(${attrName})${
                      this.ciTypesObj[item.ciTypeId].name
                    } `
                  } else if (
                    this.ciTypeAttrsObj[item.parentRs.attrId].inputType === 'select' ||
                    this.ciTypeAttrsObj[item.parentRs.attrId].inputType === 'multiSelect'
                  ) {
                    if (filterLeftRule[0].ciTypeId === this.filterAttr.ciTypeId) {
                      val += `${attrName} .${item.enumCodeAttr} `
                    } else {
                      val += `${this.ciTypesObj[filterLeftRule[0].ciTypeId].name} .${attrName} .${item.enumCodeAttr} `
                    }
                  } else {
                    val += `${this.ciTypesObj[item.ciTypeId].name} .${attrName} `
                  }
                } else {
                  if (
                    this.ciTypeAttrsObj[item.parentRs.attrId].inputType === 'select' ||
                    this.ciTypeAttrsObj[item.parentRs.attrId].inputType === 'multiSelect'
                  ) {
                    val += `.${attrName} .${item.enumCodeAttr} `
                  } else {
                    val += `.${attrName} `
                  }
                }
              }
            })
            val += '} '

            let filterRightRule = []
            if (typeof this.filters[0][key].right === 'string') {
              filterRightRule = JSON.parse(this.filters[0][key].right)
            } else {
              filterRightRule = this.filters[0][key].right
            }
            this.filterRuleArray.push(filterRightRule)
            if (filterRightRule.length > 0) {
              if (!filterRightRule[0].ciTypeId) {
                val += 'in [' + filterRightRule + '] '
              } else {
                val += 'in { '
                filterRightRule.forEach(item => {
                  const ciTypeName = this.ciTypesObj[item.ciTypeId].name
                  if (item.parentRs) {
                    const refType = item.parentRs.isReferedFromParent === 1 ? '.' : '-'
                    const attrName = this.ciTypeAttrsObj[item.parentRs.attrId].name
                    if (this.ciTypeAttrsObj[item.parentRs.attrId].inputType === 'ref') {
                      val += `${refType}(${attrName})${ciTypeName} `
                    } else if (
                      this.ciTypeAttrsObj[item.parentRs.attrId].inputType === 'select' ||
                      this.ciTypeAttrsObj[item.parentRs.attrId].inputType === 'multiSelect'
                    ) {
                      val += `${refType}${attrName} .${item.enumCodeAttr} `
                    } else {
                      val += `${refType}${attrName} `
                    }
                  } else {
                    val += ciTypeName + ' '
                  }
                })
                val += '} '
              }
            }
            num++
            if (num < keyArray.length) {
              val += 'and { '
            }
          })
        }
        this.inputVal += val
      }
    }
  }
}
</script>

<style lang="scss">
.attr-ul {
  width: 100%;
  z-index: 3000;
  background: white;
  max-height: 200px;
  overflow: auto;
}
.filter_rule .ivu-poptip {
  width: 100%;
}
.filter_rule .ivu-poptip .ivu-poptip-rel {
  width: 100%;
}
.input_in {
  width: 100%;
}
.input_in textarea {
  font-size: 11px;
  line-height: 20px;
  width: 100%;
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
