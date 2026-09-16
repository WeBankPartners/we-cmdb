import { getCiTypeAttr, getRefCiTypeFrom } from '@/api/server.js'
import './auto-fill.scss'

export default {
  name: 'AutoFill',
  props: {
    allCiTypes: { default: () => [], required: true },
    isReadOnly: { default: () => false, required: false },
    value: { default: () => '', required: true },
    rootCiTypeId: { type: String, required: true },
    specialDelimiters: { default: () => [], required: true }
  },
  data() {
    return {
      hoverSpan: '',
      hoverAttr: '',
      currentRule: '',
      currentAttr: '',
      activeDelimiterIndex: '',
      activeDelimiterValue: '',
      activeArgPath: null,
      optionsDisplay: false,
      options: [],
      autoFillArray: [],
      modalDisplay: false,
      filterCiTypeId: 0,
      filters: [],
      filterCiAttrs: [],
      operatorList: [
        { code: 'in', value: 'In' },
        { code: 'contains', value: 'Contains' },
        { code: 'eq', value: 'Equal' },
        { code: 'gt', value: 'Greater' },
        { code: 'lt', value: 'Less' },
        { code: 'ne', value: 'NotEqual' },
        { code: 'notNull', value: 'NotNull' },
        { code: 'null', value: 'Null' }
      ],
      spinShow: false,
      calcDelimiters: [
        { code: '+', value: '+' },
        { code: '-', value: '-' }
      ],
      calcFuncs: [
        { code: 'sum', value: 'sum' },
        { code: 'count', value: 'count' }
      ],
      charFuncs: [
        { code: 'upperCase', value: 'upperCase' },
        { code: 'lowerCase', value: 'lowerCase' },
        { code: 'lowerDash', value: 'lowerDash' },
        { code: 'replaceStr', value: 'replaceStr' }
      ]
    }
  },
  computed: {
    ciTypesObj() {
      let obj = {}
      this.allCiTypes.forEach(_ => {
        obj[_.ciTypeId] = _
      })
      return obj
    },
    ciTypeAttrsObj() {
      let obj = {}
      this.allCiTypes.forEach(ciType => {
        ciType.attributes.forEach(attr => {
          attr.ciTypeTableName = ciType.ciTypeId
          obj[attr.ciTypeAttrId] = attr
        })
      })
      return obj
    }
  },
  watch: {
    allCiTypes() {
      this.initAutoFillArray()
    },
    optionsDisplay(val) {
      if (!val) {
        this.currentRule = ''
        this.currentAttr = ''
        this.options = []
      }
    }
  },
  methods: {
    getPropertyNameByCiTypeIdAndAttrId(ciTypeIdAndAttrId) {
      const [ciTypeId, attrId] = ciTypeIdAndAttrId.split('#')
      const keys = Object.values(this.ciTypeAttrsObj)
      const attr = keys.find(item => {
        if (ciTypeId === item.ciTypeTableName && attrId === item.propertyName) {
          return item
        }
      })
      return attr || ''
    },
    isReplaceStrNode(node) {
      return !!(node && node.type === 'charFunc' && node.value === 'replaceStr')
    },
    getActiveArgIndex(ruleIndex) {
      if (
        this.activeArgPath &&
        String(this.activeArgPath.nodeIndex) === String(ruleIndex) &&
        this.activeArgPath.argIndex != null &&
        this.activeArgPath.argIndex !== ''
      ) {
        return +this.activeArgPath.argIndex
      }
      return null
    },
    getFillToken(ruleIndex) {
      const argIndex = this.getActiveArgIndex(ruleIndex)
      if (argIndex != null) {
        const parent = this.autoFillArray[+ruleIndex]
        if (parent && Array.isArray(parent.args)) {
          return parent.args[argIndex]
        }
      }
      return this.autoFillArray[+ruleIndex]
    },
    setFillTokenValue(ruleIndex, value) {
      const token = this.getFillToken(ruleIndex)
      if (token) {
        this.$set(token, 'value', value)
      }
    },
    ensureReplaceArgs(node) {
      if (!node) {
        return
      }
      const args = Array.isArray(node.args) ? node.args.slice() : []
      while (args.length < 3) {
        args.push(null)
      }
      this.$set(node, 'args', args)
    },
    buildCharFuncNode(code) {
      const node = {
        type: 'charFunc',
        value: code
      }
      if (code === 'replaceStr') {
        node.args = [null, null, null]
      }
      return node
    },
    isRuleTokenLegal(token) {
      if (!token || token.type !== 'rule') {
        return true
      }
      const ruleArray = JSON.parse(token.value)
      const lastNode = ruleArray[ruleArray.length - 1]
      const lastAttrId = lastNode.parentRs ? lastNode.parentRs.attrId : 0
      if (!lastAttrId) {
        return false
      }
      const inputType = this.getPropertyNameByCiTypeIdAndAttrId(lastAttrId).inputType
      if (lastNode.parentRs && (inputType === 'ref' || inputType === 'multiRef')) {
        return false
      }
      return true
    },
    renderEditor() {
      const tokens = []
      this.autoFillArray.forEach((_, i) => {
        let rendered
        switch (_.type) {
          case 'rule':
            rendered = this.renderExpression(_.value, i)
            break
          case 'delimiter':
            rendered = this.renderDelimiter(_.value, i)
            break
          case 'specialDelimiter':
            rendered = this.renderSpecialDelimiter(_.value, i)
            break
          case 'calcSymbol':
            rendered = this.renderCalcDelimiter(_.value, i)
            break
          case 'calcFunc':
            rendered = this.renderCalcFunc(_.value, i)
            break
          case 'charFunc':
            rendered = this.renderCharFunc(_, i)
            break
          default:
            break
        }
        if (Array.isArray(rendered)) {
          tokens.push(...rendered)
        } else if (rendered) {
          tokens.push(rendered)
        }
      })
      return [
        !this.isReadOnly && this.renderOptions(),
        ...tokens,
        ...this.renderAddRule(),
        this.renderModal()
      ]
    },
    // 将过滤规则格式化为可读值
    formatFillRule(value, props) {
      let result = []
      value.forEach((_, i) => {
        switch (_.type) {
          case 'rule':
            result.push(...this.renderExpression(_.value, i, props))
            break
          case 'delimiter':
            result.push(this.renderSpan(_.value, props))
            break
          case 'specialDelimiter':
            const found = this.specialDelimiters.find(item => item.code === _.value)
            if (found) {
              result.push(this.renderSpan(found.value, props))
            } else {
              result.push(this.renderSpan(_.value, props))
            }
            break
          case 'calcSymbol':
            const foundCalcDelimiter = this.getCalcConnector.find(item => item.code === _.value)
            if (foundCalcDelimiter) {
              result.push(this.renderSpan(foundCalcDelimiter.value, props))
            } else {
              result.push(this.renderSpan(_.value, props))
            }
            break
          case 'calcFunc':
            const foundCalcDelimiterss = this.getCalcFunc.find(item => item.code === _.value)
            if (foundCalcDelimiterss) {
              result.push(this.renderSpan(foundCalcDelimiterss.value, props))
            } else {
              result.push(this.renderSpan(_.value, props))
            }
            break
          case 'charFunc':
            const charFuncNodes = this.renderCharFunc(_, i, props)
            if (Array.isArray(charFuncNodes)) {
              result.push(...charFuncNodes)
            } else if (charFuncNodes) {
              result.push(charFuncNodes)
            }
            break
          default:
            break
        }
      })
      return result
    },
    renderOptions() {
      return (
        <div slot="content" class="auto-fill-options">
          {[
            this.options.map(_ =>
              _.type === 'option' ? (
                <div class={_.class} onClick={_.fn}>
                  {_.nodeName}
                </div>
              ) : (
                <hr />
              )
            ),
            this.spinShow ? <Spin fix /> : null
          ]}
        </div>
      )
    },
    mouseover(e) {
      if (e.target.className.indexOf('auto-fill-span') === -1) {
        return
      }
      this.hoverSpan = e.target.getAttribute('index')
      this.hoverAttr = e.target.getAttribute('attr-index')
    },
    mouseout(e) {
      this.hoverSpan = ''
      this.hoverAttr = ''
    },
    handleClick(e) {
      if (this.isReadOnly) {
        return
      }
      if (e.target.className.indexOf('auto-fill-span') >= 0) {
        const ruleIndex = e.target.getAttribute('index')
        const argIndexAttr = e.target.getAttribute('arg-index')
        if (argIndexAttr != null && argIndexAttr !== '') {
          this.activeArgPath = { nodeIndex: +ruleIndex, argIndex: +argIndexAttr }
        } else {
          this.activeArgPath = null
        }
        if (e.target.className.indexOf('auto-fill-replace-slot') >= 0) {
          this.showReplaceSlotOptions(ruleIndex, argIndexAttr)
          return
        }
        if (e.target.className.indexOf('auto-fill-special-delimiter') >= 0) {
          this.showSymbolOptions(
            this.$t('auto_fill_change_special_delimiter'),
            ruleIndex,
            'specialDelimiters',
            'specialDelimiter'
          )
          return
        }
        if (e.target.className.indexOf('auto-fill-calc-delimiter') >= 0) {
          this.showSymbolOptions(this.$t('auto_fill_change_calc_delimiter'), ruleIndex, 'calcDelimiters', 'calcSymbol')
          return
        }
        if (e.target.className.indexOf('auto-fill-calc-func') >= 0) {
          this.showSymbolOptions(this.$t('auto_fill_change_calc_function'), ruleIndex, 'calcFuncs', 'calcFunc')
          return
        }
        if (e.target.className.indexOf('auto-fill-char-func') >= 0) {
          this.showSymbolOptions(this.$t('auto_fill_change_char_function'), ruleIndex, 'charFuncs', 'charFunc')
          return
        }
        let attrIndex = null
        if (e.target.hasAttribute('attr-index')) {
          attrIndex = e.target.getAttribute('attr-index')
        }
        this.showRuleOptions(ruleIndex, attrIndex)
      } else if (e.target.className.indexOf('auto-fill-add') >= 0) {
        // 选择属性表达式或连接符
        this.activeArgPath = null
        this.showAddOptions()
      } else {
      }
    },
    showAddOptions() {
      this.options = []
      this.optionsDisplay = true
      this.options.push(
        {
          type: 'option',
          class: 'auto-fill-li',
          nodeName: this.$t('auto_fill_add_rule'),
          fn: () => this.addRule('rule')
        },
        {
          type: 'option',
          class: 'auto-fill-li',
          nodeName: this.$t('auto_fill_add_delimiter'),
          fn: () => this.addRule('delimiter')
        },
        {
          type: 'option',
          class: 'auto-fill-li',
          nodeName: this.$t('auto_fill_special_delimiter'),
          fn: () => this.addRule('specialDelimiter')
        },
        {
          type: 'option',
          class: 'auto-fill-li',
          nodeName: this.$t('auto_fill_calc_delimiter'),
          fn: () => this.addRule('calcSymbol')
        },
        {
          type: 'option',
          class: 'auto-fill-li',
          nodeName: this.$t('auto_fill_calc_function'),
          fn: () => this.addRule('calcFunc')
        },
        {
          type: 'option',
          class: 'auto-fill-li',
          nodeName: this.$t('auto_fill_char_function'),
          fn: () => this.addRule('charFunc')
        }
      )
    },
    addRule(type) {
      this.options = []
      const addToSlot = this.activeArgPath && this.activeArgPath.argIndex != null
      const nodeIndex = addToSlot ? this.activeArgPath.nodeIndex : null
      const argIndex = addToSlot ? this.activeArgPath.argIndex : null
      const pushToken = token => {
        if (addToSlot) {
          this.ensureReplaceArgs(this.autoFillArray[nodeIndex])
          this.$set(this.autoFillArray[nodeIndex].args, argIndex, token)
        } else {
          this.autoFillArray.push(token)
        }
      }
      switch (type) {
        case 'rule':
          pushToken({
            type,
            value: JSON.stringify([{ ciTypeId: this.ciTypesObj[this.rootCiTypeId].ciTypeId }])
          })
          this.showRuleOptions((addToSlot ? nodeIndex : this.autoFillArray.length - 1) + '', '0')
          break
        case 'delimiter':
          pushToken({
            type,
            value: ''
          })
          this.activeDelimiterIndex = addToSlot
            ? `${nodeIndex}:${argIndex}`
            : this.autoFillArray.length - 1 + ''
          this.optionsDisplay = false
          break
        case 'specialDelimiter':
          this.getSpecialConnector()
          break
        case 'calcSymbol':
          this.getCalcConnector()
          break
        case 'calcFunc':
          this.getCalcFunc()
          break
        case 'charFunc':
          this.getCharFunc()
          break
        default:
          break
      }
    },
    // 特殊连接符
    getSpecialConnector() {
      this.specialDelimiters.forEach(_ => {
        this.options.push({
          type: 'option',
          class: 'auto-fill-li auto-fill-li-special-delimiter',
          nodeName: _.value,
          fn: () => {
            this.autoFillArray.push({
              type: 'specialDelimiter',
              value: _.code
            })
            this.options = []
            this.optionsDisplay = false
            this.handleInput()
          }
        })
      })
    },
    // 特殊连接符
    getCalcConnector() {
      this.calcDelimiters.forEach(_ => {
        this.options.push({
          type: 'option',
          class: 'auto-fill-li auto-fill-li-special-delimiter',
          nodeName: _.value,
          fn: () => {
            this.autoFillArray.push({
              type: 'calcSymbol',
              value: _.code
            })
            this.options = []
            this.optionsDisplay = false
            this.handleInput()
          }
        })
      })
    },
    // 运算函数
    getCalcFunc() {
      this.calcFuncs.forEach(_ => {
        this.options.push({
          type: 'option',
          class: 'auto-fill-li auto-fill-li-special-delimiter',
          nodeName: _.value,
          fn: () => {
            this.autoFillArray.push({
              type: 'calcFunc',
              value: _.code
            })
            this.options = []
            this.optionsDisplay = false
            this.handleInput()
          }
        })
      })
    },
    // 字符串转换函数
    getCharFunc() {
      this.charFuncs.forEach(_ => {
        this.options.push({
          type: 'option',
          class: 'auto-fill-li auto-fill-li-special-delimiter',
          nodeName: _.value,
          fn: () => {
            this.autoFillArray.push(this.buildCharFuncNode(_.code))
            this.options = []
            this.optionsDisplay = false
            this.handleInput()
          }
        })
      })
    },
    showReplaceSlotOptions() {
      this.options = [
        {
          type: 'option',
          class: 'auto-fill-li',
          nodeName: this.$t('auto_fill_add_rule'),
          fn: () => this.addRule('rule')
        },
        {
          type: 'option',
          class: 'auto-fill-li',
          nodeName: this.$t('auto_fill_add_delimiter'),
          fn: () => this.addRule('delimiter')
        }
      ]
      this.optionsDisplay = true
    },
    showRuleOptions(ruleIndex, attrIndex) {
      this.options = []
      this.optionsDisplay = true
      const fillToken = this.getFillToken(ruleIndex)
      if (!fillToken || fillToken.type !== 'rule') {
        this.options.push({
          type: 'option',
          class: 'auto-fill-li auto-fill-li-delete',
          nodeName: this.$t('auto_fill_delete_node'),
          fn: () => this.deleteNode(ruleIndex, attrIndex)
        })
        if (!attrIndex) {
          this.options.push({
            type: 'option',
            class: 'auto-fill-li auto-fill-li-edit',
            nodeName: this.$t('auto_fill_edit_delimiter'),
            fn: () => this.editDelimiter(ruleIndex, attrIndex)
          })
        }
        return
      }
      const isAttrNode = attrIndex ? !!JSON.parse(fillToken.value)[attrIndex].parentRs : false
      const attrInputType = isAttrNode
        ? this.getPropertyNameByCiTypeIdAndAttrId(
            JSON.parse(fillToken.value)[attrIndex].parentRs.attrId
          ).inputType
        : ''
      // 删除节点
      this.options.push({
        type: 'option',
        class: 'auto-fill-li auto-fill-li-delete',
        nodeName: this.$t('auto_fill_delete_node'),
        fn: () => this.deleteNode(ruleIndex, attrIndex)
      })
      // 连接符
      if (!attrIndex) {
        this.options.push({
          type: 'option',
          class: 'auto-fill-li auto-fill-li-edit',
          nodeName: this.$t('auto_fill_edit_delimiter'),
          fn: () => this.editDelimiter(ruleIndex, attrIndex)
        })
        return
      }
      // 添加过滤条件
      if (attrInputType === 'ref' || attrInputType === 'multiRef' || !attrInputType) {
        this.options.push({
          type: 'option',
          class: 'auto-fill-li auto-fill-li-filter',
          nodeName: this.$t('auto_fill_add_filter'),
          fn: () => this.showFilterModal(ruleIndex, attrIndex)
        })
      }

      const node = JSON.parse(fillToken.value)[attrIndex]
      if (
        !node.parentRs ||
        this.getPropertyNameByCiTypeIdAndAttrId(node.parentRs.attrId).inputType === 'ref' ||
        this.getPropertyNameByCiTypeIdAndAttrId(node.parentRs.attrId).inputType === 'multiRef'
      ) {
        const ciTypeId = JSON.parse(fillToken.value)[attrIndex].ciTypeId
        this.getRefData(ruleIndex, attrIndex, ciTypeId)
      }
    },
    // 显示运算符
    showSymbolOptions(nodeName, ruleIndex, symbolOptions, type) {
      this.options = [
        {
          type: 'option',
          class: 'auto-fill-li auto-fill-li-delete',
          nodeName: this.$t('auto_fill_delete_node'),
          fn: () => this.deleteNode(ruleIndex)
        },
        {
          type: 'option',
          class: 'auto-fill-li auto-fill-li-change-special-delimiter',
          nodeName: nodeName,
          fn: () => this.changeSymbolNode(ruleIndex, symbolOptions, type)
        }
      ]
      this.optionsDisplay = true
    },
    ciTypeTableNameToId(tableName) {
      const keys = Object.values(this.ciTypesObj)
      const ciTypeId = keys.find(item => {
        if (tableName === item.ciTypeId) {
          return item
        }
      }).ciTypeId
      return ciTypeId
    },
    async getRefData(ruleIndex, attrIndex, ciTypeId) {
      ciTypeId = this.ciTypeTableNameToId(ciTypeId)
      this.spinShow = true
      this.currentRule = ruleIndex
      this.currentAttr = attrIndex
      const promiseArray = [getRefCiTypeFrom(ciTypeId), getCiTypeAttr(ciTypeId)]
      const [refFroms, ciAttrs] = await Promise.all(promiseArray)
      this.spinShow = false
      if (refFroms.statusCode === 'OK' && ciAttrs.statusCode === 'OK') {
        // 下拉框添加被引用的CI的选项
        refFroms.data.length &&
          this.options.push({
            type: 'line'
          })
        this.options = this.options.concat(
          refFroms.data.map(_ => {
            const ciTypeName = this.ciTypesObj[_.ciTypeId] ? this.ciTypesObj[_.ciTypeId].ciTypeId : 'undefined'
            const attrName = this.ciTypeAttrsObj[_.ciTypeAttrId]
              ? this.ciTypeAttrsObj[_.ciTypeAttrId].propertyName
              : 'undefined'
            const nodeObj = {
              ciTypeId: ciTypeName,
              parentRs: {
                attrId: this.ciTypeAttrsObj[_.ciTypeAttrId].ciTypeTableName + '#' + attrName,
                isReferedFromParent: 0
              }
            }
            return {
              type: 'option',
              class: 'auto-fill-li auto-fill-li-ref auto-fill-li-ref-from',
              nodeName: `<-(${attrName})${ciTypeName}`,
              fn: () => this.addNode(ruleIndex, attrIndex, nodeObj)
            }
          })
        )
        // 下拉框添加属性及引用的CI的选项
        ciAttrs.data.length &&
          this.options.push({
            type: 'line'
          })
        // 运算符中控制只能选择引用及数字类型的属性
        const previousValue = this.autoFillArray[ruleIndex - 1]
        let previousValueType = previousValue ? previousValue.type : ''
        const needToFilterAttr = ['calcFunc', 'calcSymbol'].includes(previousValueType)
        const attr = needToFilterAttr
          ? ciAttrs.data.filter(attr => ['int', 'float', 'ref', 'multiRef', 'extRef'].includes(attr.inputType))
          : ciAttrs.data
        this.options = this.options.concat(
          attr.map(_ => {
            const isRef = _.inputType === 'ref' || _.inputType === 'multiRef'
            const ciTypeName = isRef ? this.ciTypesObj[_.referenceId].ciTypeId : this.ciTypesObj[_.ciTypeId].ciTypeId
            const attrName = this.ciTypeAttrsObj[_.ciTypeAttrId].propertyName
            const nodeName = isRef ? `->(${attrName})${ciTypeName}` : `.${attrName}`
            const nodeObj = {
              ciTypeId: ciTypeName,
              parentRs: {
                attrId: this.ciTypeAttrsObj[_.ciTypeAttrId].ciTypeTableName + '#' + attrName,
                isReferedFromParent: 1
              }
            }
            return {
              type: 'option',
              class: 'auto-fill-li auto-fill-li-ref auto-fill-li-ref-to',
              nodeName,
              fn: () => this.addNode(ruleIndex, attrIndex, nodeObj)
            }
          })
        )
      }
    },
    // 点击选择枚举属性
    addEnum(ruleIndex, attrIndex, code) {
      let ruleArr = JSON.parse(this.getFillToken(ruleIndex).value)
      ruleArr[attrIndex].enumCodeAttr = code
      this.setFillTokenValue(ruleIndex, JSON.stringify(ruleArr))
      this.optionsDisplay = false
      this.handleInput()
    },
    // 点击删除节点
    deleteNode(ruleIndex, attrIndex) {
      const argIndex = this.getActiveArgIndex(ruleIndex)
      if (argIndex != null) {
        if (!attrIndex || attrIndex === '0') {
          this.ensureReplaceArgs(this.autoFillArray[+ruleIndex])
          this.$set(this.autoFillArray[+ruleIndex].args, argIndex, null)
          this.handleInput()
        } else {
          const token = this.getFillToken(ruleIndex)
          let ruleArr = JSON.parse(token.value)
          ruleArr.splice(attrIndex, ruleArr.length - attrIndex)
          this.setFillTokenValue(ruleIndex, JSON.stringify(ruleArr))
          this.$emit('input', null)
        }
        this.optionsDisplay = false
        return
      }
      if (!attrIndex) {
        // 删除连接符
        this.autoFillArray.splice(ruleIndex, 1)
        this.handleInput()
      } else {
        if (attrIndex === '0') {
          // 删除该属性表达式（即该花括号内的内容）
          this.autoFillArray.splice(ruleIndex, 1)
          if (
            ruleIndex !== '0' &&
            this.autoFillArray[+ruleIndex - 1] &&
            this.autoFillArray[+ruleIndex - 1].type === 'delimiter' &&
            this.autoFillArray[ruleIndex] &&
            this.autoFillArray[ruleIndex].type === 'delimiter'
          ) {
            this.autoFillArray[+ruleIndex - 1].value += this.autoFillArray[ruleIndex].value
            this.autoFillArray.splice(ruleIndex, 1)
          }
          this.handleInput()
        } else {
          // 删除属性表达式中，该节点及之后的节点
          let ruleArr = JSON.parse(this.autoFillArray[ruleIndex].value)
          ruleArr.splice(attrIndex, ruleArr.length - attrIndex)
          this.autoFillArray[ruleIndex].value = JSON.stringify(ruleArr)
          this.$emit('input', null)
        }
      }
      this.optionsDisplay = false
    },
    // 点击更换连接符节点
    changeSymbolNode(ruleIndex, symbolOptions, type) {
      this.options = []
      this[symbolOptions].forEach(_ => {
        this.options.push({
          type: 'option',
          class: 'auto-fill-li auto-fill-li-special-delimiter',
          nodeName: _.value,
          fn: () => {
            const next = type === 'charFunc' ? this.buildCharFuncNode(_.code) : { type, value: _.code }
            this.autoFillArray.splice(+ruleIndex, 1, next)
            this.options = []
            this.optionsDisplay = false
            this.handleInput()
          }
        })
      })
    },
    editDelimiter(ruleIndex) {
      const argIndex = this.getActiveArgIndex(ruleIndex)
      this.activeDelimiterIndex = argIndex != null ? `${+ruleIndex}:${argIndex}` : ruleIndex
      this.optionsDisplay = false
      this.handleInput()
    },
    async showFilterModal(ruleIndex, attrIndex) {
      this.filterCiTypeId = this.ciTypeTableNameToId(
        JSON.parse(this.getFillToken(ruleIndex).value)[attrIndex].ciTypeId
      )
      const filters = JSON.parse(this.getFillToken(ruleIndex).value)[attrIndex].filters || []
      this.filterIndex = [ruleIndex, attrIndex, this.getActiveArgIndex(ruleIndex)]
      this.modalDisplay = true
      this.optionsDisplay = false
      const { data, statusCode } = await getCiTypeAttr(this.filterCiTypeId)
      if (statusCode === 'OK') {
        this.filterCiAttrs = data
        this.filters = filters.map(_ => {
          const found = data.find(attr => attr.propertyName === _.name)
          if (found) {
            _.inputType = found.inputType
          }
          if (_.operator === 'in' && _.type === 'value') {
            _.value = _.value.join(',')
          }
          return _
        })
      }
    },
    addNode(ruleIndex, attrIndex, nodeObj) {
      const i = +attrIndex
      let ruleArr = JSON.parse(this.getFillToken(ruleIndex).value)
      ruleArr.splice(i + 1, ruleArr.length - i - 1, nodeObj)
      this.setFillTokenValue(ruleIndex, JSON.stringify(ruleArr))
      // const inputType = this.ciTypeAttrsObj[ruleArr[ruleArr.length - 1].parentRs.attrId].inputType
      const inputType = this.getPropertyNameByCiTypeIdAndAttrId(ruleArr[ruleArr.length - 1].parentRs.attrId).inputType
      const ciTypeId = nodeObj.ciTypeId
      if (inputType === 'ref' || inputType === 'multiRef') {
        this.options = [
          {
            type: 'option',
            class: 'auto-fill-li auto-fill-li-delete',
            nodeName: this.$t('auto_fill_delete_node'),
            fn: () => this.deleteNode(ruleIndex, i + 1)
          },
          {
            type: 'option',
            class: 'auto-fill-li auto-fill-li-filter',
            nodeName: this.$t('auto_fill_add_filter'),
            fn: () => this.showFilterModal(ruleIndex, i + 1)
          }
        ]
        this.getRefData(ruleIndex, i + 1 + '', ciTypeId)
      } else {
        this.optionsDisplay = false
      }
      this.handleInput()
    },
    renderSpan(value, props) {
      const text = value == null ? '' : String(value)
      const p = {
        ...props,
        domProps: {
          innerHTML: text.replace(/\s/g, '&nbsp;').replace(/</g, '&lt;')
        }
      }
      return <span {...p}></span>
    },
    formatClassName(classList) {
      return Object.keys(classList).map(key => {
        if (classList[key]) {
          return key
        }
      })
    },
    renderExpression(val, i, props, argIndex) {
      // type === rule 时，链式属性表达式
      let result = []
      const argAttrs = argIndex != null ? { 'arg-index': argIndex } : {}
      JSON.parse(val).forEach((_, attrIndex) => {
        let isLegal = true
        if (attrIndex === JSON.parse(val).length - 1) {
          const lastInputType = JSON.parse(val)[attrIndex].parentRs
            ? this.getPropertyNameByCiTypeIdAndAttrId(JSON.parse(val)[attrIndex].parentRs.attrId).inputType
            : ''
          if (lastInputType === 'ref' || lastInputType === 'multiRef' || !lastInputType) {
            isLegal = false
          } else if (lastInputType === 'select' || lastInputType === 'multiSelect') {
            isLegal = !!JSON.parse(val)[attrIndex].enumCodeAttr
          }
        }
        // 样式
        const classList = {
          'auto-fill-span': true,
          'auto-fill-hover': this.hoverAttr === attrIndex + '' && this.hoverSpan === i + '',
          'auto-fill-current-node': this.currentRule === i + '' && this.currentAttr === attrIndex + '',
          'auto-fill-error': !isLegal
        }
        const defaultProps = {
          class: this.formatClassName(classList),
          attrs: {
            index: i,
            'attr-index': attrIndex,
            ...argAttrs
          }
        }
        const _props = props || defaultProps
        const _propsWithkeyWord = {
          ..._props,
          class: [..._props.class, 'auto-fill-key-word']
        }
        // 过滤条件
        let filterNode = []
        if (_.filters) {
          const attrs = this.ciTypesObj[_.ciTypeId] ? this.ciTypesObj[_.ciTypeId].attributes : []
          filterNode = [
            <span {..._propsWithkeyWord}>{' [ '}</span>,
            ..._.filters.map((filter, filterIndex) => {
              let filterValue = []
              const operatorFound = this.operatorList.find(operator => operator.code === filter.operator)
              const operator = operatorFound ? operatorFound.value : filter.operator
              const attrFound = attrs.find(attr => attr.propertyName === filter.name)
              const filterName = attrFound ? attrFound.name : filter.name
              if (filter.type && filter.type === 'autoFill') {
                filterValue = this.formatFillRule(JSON.parse(filter.value), defaultProps)
              } else {
                const _filterValue = Array.isArray(filter.value) ? `[${filter.value.join(',')}]` : filter.value
                filterValue = [this.renderSpan(_filterValue, _props)]
              }
              return [
                filterIndex > 0 && <span {..._propsWithkeyWord}> | </span>,
                this.renderSpan(filterName, _props),
                this.renderSpan(` ${operator} `, _propsWithkeyWord),
                ...filterValue
              ]
            }),
            <span {..._propsWithkeyWord}>{' ] '}</span>
          ]
        }
        // const ciTypeName = this.ciTypesObj[_.ciTypeId].tableName
        const ciTypeName = _.ciTypeId
        if (!_.parentRs) {
          result.push(this.renderSpan(ciTypeName, _props), ...filterNode)
        } else {
          const inputType = this.getPropertyNameByCiTypeIdAndAttrId(_.parentRs.attrId).inputType
          const ref =
            _.parentRs.isReferedFromParent === 1 ? (inputType === 'ref' || inputType === 'multiRef' ? '->' : '.') : '<-'
          const attrName = this.getPropertyNameByCiTypeIdAndAttrId(_.parentRs.attrId).propertyName
          const enumCode = _.enumCodeAttr ? `.${_.enumCodeAttr}` : ''
          if (
            this.getPropertyNameByCiTypeIdAndAttrId(_.parentRs.attrId).inputType === 'ref' ||
            this.getPropertyNameByCiTypeIdAndAttrId(_.parentRs.attrId).inputType === 'multiRef'
          ) {
            result.push(this.renderSpan(` ${ref}(${attrName})${ciTypeName}`, _props), ...filterNode)
          } else {
            result.push(this.renderSpan(` ${ref}${attrName}${enumCode}`, _props), ...filterNode)
          }
        }
      })
      const bracesClassList = {
        'auto-fill-span': true,
        'auto-fill-key-word': true,
        contains: this.hoverSpan === i + ''
      }
      const propsWithBraces = props
        ? {
            ...props,
            class: [...props.class, 'auto-fill-key-word']
          }
        : {
            class: this.formatClassName(bracesClassList),
            attrs: {
              index: i,
              ...argAttrs
            }
          }
      return [<span {...propsWithBraces}>{' { '}</span>, ...result, <span {...propsWithBraces}>{' } '}</span>]
    },
    renderDelimiter(val, i, argIndex) {
      // type === delimiter 时，连接符
      const activeKey = argIndex == null ? i + '' : `${i}:${argIndex}`
      if (this.activeDelimiterIndex === activeKey) {
        return (
          <Input
            ref="delimiterInput"
            on-on-blur={() => this.confirmDelimiter(i)}
            on-on-enter={() => this.$refs.delimiterInput.blur()}
            onInput={v => this.onDelimiterInput(v, i)}
            value={val}
          />
        )
      } else {
        const classList = {
          'auto-fill-span-delimiter': true,
          hover: this.hoverSpan === i + ''
        }
        const _props = {
          class: this.formatClassName(classList),
          attrs: {
            index: i,
            ...(argIndex != null ? { 'arg-index': argIndex } : {})
          }
        }
        return this.renderSpan(val, _props)
      }
    },
    renderSpecialDelimiter(value, i) {
      const found = this.specialDelimiters.find(item => item.code === value)
      const specialDelimiter = found ? found.value : ''
      const classList = {
        'auto-fill-span': true,
        'auto-fill-special-delimiter': true,
        hover: this.hoverSpan === i + ''
      }
      const _props = {
        class: this.formatClassName(classList),
        attrs: {
          index: i
        }
      }
      return this.renderSpan(specialDelimiter, _props)
    },
    renderCalcDelimiter(value, i) {
      const found = this.calcDelimiters.find(item => item.code === value)
      const calcDelimiter = found ? found.value : ''
      const classList = {
        'auto-fill-span': true,
        'auto-fill-calc-delimiter': true,
        hover: this.hoverSpan === i + ''
      }
      const _props = {
        class: this.formatClassName(classList),
        attrs: {
          index: i
        }
      }
      return this.renderSpan(calcDelimiter, _props)
    },
    renderCalcFunc(value, i) {
      const found = this.calcFuncs.find(item => item.code === value)
      const calcDelimiter1 = found ? found.value : ''
      const classList = {
        'auto-fill-span': true,
        'auto-fill-calc-func': true,
        hover: this.hoverSpan === i + ''
      }
      const _props = {
        class: this.formatClassName(classList),
        attrs: {
          index: i
        }
      }
      return this.renderSpan(calcDelimiter1, _props)
    },
    renderCharFunc(node, i, props) {
      const value = node && node.value != null ? node.value : node
      const found = this.charFuncs.find(item => item.code === value)
      const charFunc = found ? found.value : value
      const classList = {
        'auto-fill-span': true,
        'auto-fill-char-func': true,
        hover: this.hoverSpan === i + ''
      }
      const _props = props || {
        class: this.formatClassName(classList),
        attrs: {
          index: i
        }
      }
      const result = [this.renderSpan(charFunc, _props)]
      if (!this.isReplaceStrNode(node)) {
        return result
      }
      const args = Array.isArray(node.args) ? node.args.slice() : []
      while (args.length < 3) {
        args.push(null)
      }
      args.forEach((arg, argIndex) => {
        result.push(this.renderReplaceParen(' ( ', i, props))
        const slot = this.renderReplaceArg(arg, i, argIndex, props)
        if (Array.isArray(slot)) {
          result.push(...slot)
        } else {
          result.push(slot)
        }
        result.push(this.renderReplaceParen(' ) ', i, props))
      })
      return result
    },
    renderReplaceParen(text, i, props) {
      if (props) {
        return this.renderSpan(text, {
          ...props,
          class: [...(props.class || []), 'auto-fill-key-word']
        })
      }
      return <span class="auto-fill-replace-paren">{text}</span>
    },
    renderReplaceSlotPlaceholder(i, argIndex) {
      const classList = {
        'auto-fill-span': true,
        'auto-fill-replace-slot': true,
        'auto-fill-placeholder': true
      }
      const _props = {
        class: this.formatClassName(classList),
        attrs: {
          index: i,
          'arg-index': argIndex
        }
      }
      return this.renderSpan(this.$t('auto_fill_replace_slot_placeholder'), _props)
    },
    renderReplaceArg(arg, i, argIndex, props) {
      if (!arg || !arg.type) {
        if (props) {
          return this.renderSpan(this.$t('auto_fill_replace_slot_placeholder'), props)
        }
        return this.renderReplaceSlotPlaceholder(i, argIndex)
      }
      if (arg.type === 'rule') {
        return this.renderExpression(arg.value, i, props, argIndex)
      }
      if (arg.type === 'delimiter') {
        if (props) {
          return this.renderSpan(arg.value, props)
        }
        return this.renderDelimiter(arg.value, i, argIndex)
      }
      return this.renderSpan(arg.value || '', props)
    },
    // 连接符输入框失焦或按回车时，需要更新 this.autoFillArray
    confirmDelimiter(i) {
      const parts = String(this.activeDelimiterIndex).split(':')
      if (parts.length === 2) {
        this.activeDelimiterIndex = ''
        this.handleInput()
        return
      }
      if (this.autoFillArray[i].value === '') {
        // 如果输入框没有值，则在 this.autoFillArray 中删掉该项
        this.autoFillArray.splice(i, 1)
      } else {
        // 将相邻两项 type === delimiter 合并为一项
        if (this.autoFillArray[i + 1] && this.autoFillArray[i + 1].type === 'delimiter') {
          this.autoFillArray[i].value += this.autoFillArray[i + 1].value
          this.autoFillArray.splice(i + 1, 1)
        }
        if (i > 0 && this.autoFillArray[i - 1].type === 'delimiter') {
          this.autoFillArray[i - 1].value += this.autoFillArray[i].value
          this.autoFillArray.splice(i, 1)
        }
      }
      this.activeDelimiterIndex = ''
      this.handleInput()
    },
    onDelimiterInput(v, i) {
      const parts = String(this.activeDelimiterIndex).split(':')
      if (parts.length === 2) {
        const node = this.autoFillArray[+parts[0]]
        if (node && node.args && node.args[+parts[1]]) {
          node.args[+parts[1]].value = v
        }
        return
      }
      this.autoFillArray[i].value = v
    },
    renderAddRule() {
      if (this.isReadOnly) {
        return [<span></span>]
      } else {
        return [
          <Icon class="auto-fill-add" type="md-add-circle" />,
          !this.autoFillArray.length && (
            <span class="auto-fill-add auto-fill-placeholder">{this.$t('attr_express_placeholder')}</span>
          )
        ]
      }
    },
    initAutoFillArray() {
      if (!this.allCiTypes.length || !this.value) {
        return
      }
      this.autoFillArray = JSON.parse(this.value)
    },
    focusInput() {
      // 点击编辑连接符后，需要聚焦 Input
      if (this.activeDelimiterIndex && this.$refs.delimiterInput) {
        this.$nextTick(() => {
          this.$refs.delimiterInput.focus()
        })
      }
    },
    // 添加过滤添加的弹框
    renderModal() {
      const emptyFilter = {
        name: '',
        inputType: 'text',
        operator: 'in',
        type: 'value',
        value: ''
      }
      const { rootCiTypeId, allCiTypes, specialDelimiters } = this
      return (
        <Modal
          value={this.modalDisplay}
          onInput={v => (this.modalDisplay = v)}
          title={this.$t('attr_express_modal_title')}
          width="800"
          on-on-ok={this.confirmFilter}
          on-on-cancel={this.cancelFilter}
        >
          {this.filters.map((_, i) => (
            <div class="auto-fill-filter-li">
              <Icon
                type="md-remove-circle"
                color="red"
                onClick={() => this.filters.splice(i, 1)}
                class="auto-fill-filter-li-icon"
              />
              <Select value={_.name} onInput={v => this.changeFilter(v, i)} class="auto-fill-filter-li-select title">
                {this.filterCiAttrs.map(attr => (
                  <Option key={attr.ciTypeAttrId} value={attr.propertyName}>
                    {attr.name}
                  </Option>
                ))}
              </Select>
              <Select
                value={_.operator}
                onInput={v => (this.filters[i].operator = v)}
                class="auto-fill-filter-li-select operator"
              >
                {this.operatorList.map(o => (
                  <Option key={o.code} value={o.code}>
                    {o.value}
                  </Option>
                ))}
              </Select>
              <Select
                value={_.type}
                onInput={v => {
                  this.filters[i].value = ''
                  this.filters[i].type = v
                }}
                class="auto-fill-filter-li-select type"
              >
                <Option key="value" value="value">
                  {this.$t('value')}
                </Option>
                <Option key="autoFill" value="autoFill">
                  {this.$t('auto_fill_rule')}
                </Option>
              </Select>
              {_.type === 'value' ? (
                <Input
                  class="auto-fill-filter-li-input"
                  onInput={v => (this.filters[i].value = v)}
                  value={_.value}
                  type="textarea"
                  autosize={true}
                />
              ) : (
                <AutoFill
                  class="auto-fill-filter-li-input"
                  allCiTypes={allCiTypes}
                  isReadOnly={false}
                  onInput={v => (this.filters[i].value = v)}
                  rootCiTypeId={rootCiTypeId}
                  specialDelimiters={specialDelimiters}
                  value={_.value}
                />
              )}
            </div>
          ))}
          <Button type="primary" long onClick={() => this.filters.push(emptyFilter)}>
            {this.$t('attr_express_modal_button')}
          </Button>
        </Modal>
      )
    },
    changeFilter(val, i) {
      this.filters[i].name = val
      const found = this.filterCiAttrs.find(_ => _.propertyName === val)
      const inputType = found.inputType
      switch (inputType) {
        case 'number':
          this.filters[i].value = 0
          break
        default:
          this.filters[i].value = ''
          break
      }
      this.filters[i].inputType = inputType
    },
    confirmFilter() {
      const filters = this.filters
        .filter(_ => _.name && _.operator)
        .map(_ => {
          if (_.type === 'value') {
            if (_.operator === 'in') {
              _.value = _.value.split(',')
            }
            if (_.inputType === 'number') {
              if (Array.isArray(_.value)) {
                _.value = _.value.map(v => Number(v))
              } else {
                _.value = Number(_.value)
              }
            }
          }
          return {
            name: _.name,
            operator: _.operator,
            type: _.type,
            value: _.value
          }
        })
      const ruleIndex = this.filterIndex[0]
      const attrIndex = this.filterIndex[1]
      const savedArgIndex = this.filterIndex[2]
      if (savedArgIndex != null) {
        this.activeArgPath = { nodeIndex: +ruleIndex, argIndex: savedArgIndex }
      }
      let value = JSON.parse(this.getFillToken(ruleIndex).value)
      if (filters.length) {
        value[attrIndex].filters = filters
      } else {
        delete value[attrIndex].filters
      }
      this.setFillTokenValue(ruleIndex, JSON.stringify(value))
      this.cancelFilter()
      this.handleInput()
    },
    cancelFilter() {
      this.filterCiTypeId = 0
      this.filters = []
      this.filterCiAttrs = []
      this.filterIndex = []
    },
    handleInput() {
      const value = this.autoFillArray.length ? JSON.stringify(this.autoFillArray) : ''
      let isLegal = true
      this.autoFillArray.forEach(_ => {
        if (_.type === 'rule') {
          if (!this.isRuleTokenLegal(_)) {
            isLegal = false
          }
        } else if (this.isReplaceStrNode(_)) {
          const args = Array.isArray(_.args) ? _.args : []
          if (args.length < 3 || args.some(arg => !arg || !arg.type)) {
            isLegal = false
          } else {
            args.forEach(arg => {
              if (!this.isRuleTokenLegal(arg)) {
                isLegal = false
              }
            })
          }
        }
      })
      if (isLegal) {
        this.$emit('input', value)
      } else {
        this.$emit('input', null)
      }
    }
  },
  mounted() {
    this.initAutoFillArray()
  },
  updated() {
    this.focusInput()
  },
  render(h) {
    return (
      <div class="auto-fill" onmouseover={this.mouseover} onmouseout={this.mouseout} onClick={this.handleClick}>
        {this.isReadOnly ? (
          // 只读状态
          this.renderEditor()
        ) : (
          // 可编辑状态
          <Poptip v-model={this.optionsDisplay}>{this.renderEditor()}</Poptip>
        )}
      </div>
    )
  }
}
