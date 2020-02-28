import './auto-fill.scss'
import { getRefCiTypeFrom, getCiTypeAttr } from '@/api/server.js'

export const AutoFill = {
  name: 'autoFill',
  props: {
    allCiTypes: { default: () => [], required: true },
    isReadOnly: { default: () => false, required: false },
    value: { default: () => '', required: true },
    rootCiTypeId: { type: Number, required: true },
    specialDelimiters: { default: () => [], required: true }
  },
  data () {
    return {
      hoverSpan: '',
      hoverAttr: '',
      currentRule: '',
      currentAttr: '',
      activeDelimiterIndex: '',
      activeDelimiterValue: '',
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
      enumCodes: ['id', 'code', 'value', 'groupCodeId'],
      spinShow: false
    }
  },
  computed: {
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
    }
  },
  watch: {
    allCiTypes () {
      this.initAutoFillArray()
    },
    optionsDisplay (val) {
      if (!val) {
        this.currentRule = ''
        this.currentAttr = ''
        this.options = []
      }
    }
  },
  methods: {
    renderEditor () {
      return [
        !this.isReadOnly && this.renderOptions(),
        this.autoFillArray.map((_, i) => {
          switch (_.type) {
            case 'rule':
              return this.renderExpression(_.value, i)
            case 'delimiter':
              return this.renderDelimiter(_.value, i)
            case 'specialDelimiter':
              return this.renderSpecialDelimiter(_.value, i)
            default:
              break
          }
        }),
        this.renderAddRule(),
        this.renderModal()
      ]
    },
    // 将过滤规则格式化为可读值
    formaFillRule (value) {
      return value
        .map((_, i) => {
          switch (_.type) {
            case 'rule':
              return this.renderExpression(_.value, i, 'string')
            case 'delimiter':
              return _.value
            case 'specialDelimiter':
              const found = this.specialDelimiters.find(item => item.code === value)
              return found ? found.value : ''
            default:
              break
          }
        })
        .join('')
    },
    renderOptions () {
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
    mouseover (e) {
      if (e.target.className.indexOf('auto-fill-span') === -1) {
        return
      }
      this.hoverSpan = e.target.getAttribute('index')
      this.hoverAttr = e.target.getAttribute('attr-index')
    },
    mouseout (e) {
      this.hoverSpan = ''
      this.hoverAttr = ''
    },
    handleClick (e) {
      if (this.isReadOnly) {
        return
      }
      if (e.target.className.indexOf('auto-fill-span') >= 0) {
        const ruleIndex = e.target.getAttribute('index')
        if (e.target.className.indexOf('auto-fill-special-delimiter') >= 0) {
          this.showSpecialOptions(ruleIndex)
          return
        }
        let attrIndex = null
        if (e.target.hasAttribute('attr-index')) {
          attrIndex = e.target.getAttribute('attr-index')
        }
        this.showRuleOptions(ruleIndex, attrIndex)
      } else if (e.target.className.indexOf('auto-fill-add') >= 0) {
        // 选择属性表达式或连接符
        this.showAddOptions()
      } else {
      }
    },
    showAddOptions () {
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
        }
      )
    },
    addRule (type) {
      this.options = []
      switch (type) {
        case 'rule':
          this.autoFillArray.push({
            type,
            value: JSON.stringify([{ ciTypeId: this.rootCiTypeId }])
          })
          this.showRuleOptions(this.autoFillArray.length - 1 + '', '0')
          break
        case 'delimiter':
          this.autoFillArray.push({
            type,
            value: ''
          })
          this.activeDelimiterIndex = this.autoFillArray.length - 1 + ''
          this.optionsDisplay = false
          break
        case 'specialDelimiter':
          this.getSpecialConnector()
          break
        default:
          break
      }
    },
    // 特殊连接符
    getSpecialConnector () {
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
    showRuleOptions (ruleIndex, attrIndex) {
      this.options = []
      this.optionsDisplay = true
      const isAttrNode = attrIndex ? !!JSON.parse(this.autoFillArray[ruleIndex].value)[attrIndex].parentRs : false
      const attrInputType = isAttrNode
        ? this.ciTypeAttrsObj[JSON.parse(this.autoFillArray[ruleIndex].value)[attrIndex].parentRs.attrId].inputType
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

      const node = JSON.parse(this.autoFillArray[ruleIndex].value)[attrIndex]
      if (
        !node.parentRs ||
        this.ciTypeAttrsObj[node.parentRs.attrId].inputType === 'ref' ||
        this.ciTypeAttrsObj[node.parentRs.attrId].inputType === 'multiRef'
      ) {
        const ciTypeId = JSON.parse(this.autoFillArray[ruleIndex].value)[attrIndex].ciTypeId
        this.getRefData(ruleIndex, attrIndex, ciTypeId)
      } else if (
        (node.parentRs && this.ciTypeAttrsObj[node.parentRs.attrId].inputType === 'select') ||
        this.ciTypeAttrsObj[node.parentRs.attrId].inputType === 'multiSelect'
      ) {
        this.showEnumOptions(ruleIndex, attrIndex)
      }
    },
    showSpecialOptions (ruleIndex) {
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
          nodeName: this.$t('auto_fill_change_special_delimiter'),
          fn: () => this.changeSpecialDelimiterNode(ruleIndex)
        }
      ]
      this.optionsDisplay = true
    },
    async getRefData (ruleIndex, attrIndex, ciTypeId) {
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
            const ciTypeName = this.ciTypesObj[_.ciTypeId].name
            const attrName = this.ciTypeAttrsObj[_.ciTypeAttrId].name
            const nodeObj = {
              ciTypeId: _.ciTypeId,
              parentRs: {
                attrId: _.ciTypeAttrId,
                isReferedFromParent: 0
              }
            }
            return {
              type: 'option',
              class: 'auto-fill-li auto-fill-li-ref auto-fill-li-ref-from',
              nodeName: `<-(${ciTypeName})${attrName}`,
              fn: () => this.addNode(ruleIndex, attrIndex, nodeObj)
            }
          })
        )
        // 下拉框添加属性及引用的CI的选项
        ciAttrs.data.length &&
          this.options.push({
            type: 'line'
          })
        this.options = this.options.concat(
          ciAttrs.data
            .filter(_ => _.inputType !== 'password')
            .map(_ => {
              const isRef = _.inputType === 'ref' || _.inputType === 'multiRef'
              const ciTypeName = isRef ? this.ciTypesObj[_.referenceId].name : this.ciTypesObj[_.ciTypeId].name
              const attrName = this.ciTypeAttrsObj[_.ciTypeAttrId].name
              const nodeName = isRef ? `->(${ciTypeName})${attrName}` : `.${attrName}`
              const nodeObj = {
                ciTypeId: isRef ? _.referenceId : _.ciTypeId,
                parentRs: {
                  attrId: _.ciTypeAttrId,
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
    // 显示枚举属性下拉框
    showEnumOptions (ruleIndex, attrIndex) {
      this.currentRule = ruleIndex
      this.currentAttr = attrIndex
      this.options.push({
        type: 'line'
      })
      this.options = this.options.concat(
        this.enumCodes.map(_ => {
          return {
            type: 'option',
            class: 'auto-fill-li auto-fill-li-enum',
            nodeName: _,
            fn: () => this.addEnum(ruleIndex, attrIndex, _)
          }
        })
      )
    },
    // 点击选择枚举属性
    addEnum (ruleIndex, attrIndex, code) {
      let ruleArr = JSON.parse(this.autoFillArray[ruleIndex].value)
      ruleArr[attrIndex].enumCodeAttr = code
      this.autoFillArray[ruleIndex].value = JSON.stringify(ruleArr)
      this.optionsDisplay = false
      this.handleInput()
    },
    // 点击删除节点
    deleteNode (ruleIndex, attrIndex) {
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
        }
      }
      this.optionsDisplay = false
    },
    // 点击更换特殊连接符节点
    changeSpecialDelimiterNode (ruleIndex) {
      this.options = []
      this.specialDelimiters.forEach(_ => {
        this.options.push({
          type: 'option',
          class: 'auto-fill-li auto-fill-li-special-delimiter',
          nodeName: _.value,
          fn: () => {
            this.autoFillArray.splice(+ruleIndex, 1, {
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
    editDelimiter (ruleIndex) {
      this.activeDelimiterIndex = ruleIndex
      this.optionsDisplay = false
      this.handleInput()
    },
    async showFilterModal (ruleIndex, attrIndex) {
      this.filterCiTypeId = JSON.parse(this.autoFillArray[ruleIndex].value)[attrIndex].ciTypeId
      const filters = JSON.parse(this.autoFillArray[ruleIndex].value)[attrIndex].filters || []
      this.filterIndex = [ruleIndex, attrIndex]
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
    addNode (ruleIndex, attrIndex, nodeObj) {
      const i = +attrIndex
      let ruleArr = JSON.parse(this.autoFillArray[ruleIndex].value)
      ruleArr.splice(i + 1, ruleArr.length - i - 1, nodeObj)
      this.autoFillArray[ruleIndex].value = JSON.stringify(ruleArr)
      const inputType = this.ciTypeAttrsObj[ruleArr[ruleArr.length - 1].parentRs.attrId].inputType
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
      } else if (inputType === 'select' || inputType === 'multiSelect') {
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
        this.showEnumOptions(ruleIndex, i + 1 + '')
      } else {
        this.optionsDisplay = false
      }
      this.handleInput()
    },
    renderExpression (val, i, renderType = 'dom') {
      // type === rule 时，链式属性表达式
      let result = JSON.parse(val).map((_, attrIndex) => {
        let isLegal = true
        if (attrIndex === JSON.parse(val).length - 1) {
          const lastInputType = JSON.parse(val)[attrIndex].parentRs
            ? this.ciTypeAttrsObj[JSON.parse(val)[attrIndex].parentRs.attrId].inputType
            : ''
          if (lastInputType === 'ref' || lastInputType === 'multiRef' || !lastInputType) {
            isLegal = false
          } else if (lastInputType === 'select' || lastInputType === 'multiSelect') {
            isLegal = !!JSON.parse(val)[attrIndex].enumCodeAttr
          }
        }
        let filterNode = ''
        if (_.filters) {
          filterNode += '['
          filterNode += _.filters
            .map((filter, filterIndex) => {
              let filterValue = ''
              if (filter.type === 'value') {
                filterValue = Array.isArray(filter.value) ? `[${filter.value.join(',')}]` : filter.value
              } else {
                filterValue = this.formaFillRule(JSON.parse(filter.value))
              }
              return `${filterIndex > 0 ? ' | ' : ''}${filter.name} ${filter.operator} ${filterValue}`
            })
            .join('')
          filterNode += ']'
        }
        const ciTypeName = this.ciTypesObj[_.ciTypeId].name
        if (!_.parentRs) {
          return renderType === 'dom'
            ? `${ciTypeName}${filterNode}`.split('').map(_ => {
              const classList = {
                'auto-fill-span': true,
                'auto-fill-hover': this.hoverAttr === attrIndex + '' && this.hoverSpan === i + '',
                'auto-fill-current-node': this.currentRule === i + '' && this.currentAttr === attrIndex + '',
                'auto-fill-error': !isLegal
              }
              const className = Object.keys(classList).map(key => {
                if (classList[key]) {
                  return key
                }
              })
              return (
                <span class={className} index={i} attr-index={attrIndex}>
                  {_}
                </span>
              )
            })
            : `${ciTypeName}${filterNode}`
        } else {
          const inputType = this.ciTypeAttrsObj[_.parentRs.attrId].inputType
          const ref =
            _.parentRs.isReferedFromParent === 1 ? (inputType === 'ref' || inputType === 'multiRef' ? '->' : '.') : '<-'
          const attrName = this.ciTypeAttrsObj[_.parentRs.attrId].name
          const enumCode = _.enumCodeAttr ? `.${_.enumCodeAttr}` : ''
          if (
            this.ciTypeAttrsObj[_.parentRs.attrId].inputType === 'ref' ||
            this.ciTypeAttrsObj[_.parentRs.attrId].inputType === 'multiRef'
          ) {
            return renderType === 'dom'
              ? ` ${ref}(${ciTypeName})${attrName}${filterNode}`.split('').map(_ => {
                const classList = {
                  'auto-fill-span': true,
                  'auto-fill-hover': this.hoverAttr === attrIndex + '' && this.hoverSpan === i + '',
                  'auto-fill-current-node': this.currentRule === i + '' && this.currentAttr === attrIndex + '',
                  'auto-fill-error': !isLegal
                }
                const className = Object.keys(classList).map(key => {
                  if (classList[key]) {
                    return key
                  }
                })
                return (
                  <span class={className} index={i} attr-index={attrIndex}>
                    {_}
                  </span>
                )
              })
              : ` ${ref}(${ciTypeName})${attrName}${filterNode}`
          } else {
            return renderType === 'dom'
              ? ` ${ref}${attrName}${enumCode}${filterNode}`.split('').map(_ => {
                const classList = {
                  'auto-fill-span': true,
                  'auto-fill-hover': this.hoverAttr === attrIndex + '' && this.hoverSpan === i + '',
                  'auto-fill-current-node': this.currentRule === i + '' && this.currentAttr === attrIndex + '',
                  'auto-fill-error': !isLegal
                }
                const className = Object.keys(classList).map(key => {
                  if (classList[key]) {
                    return key
                  }
                })
                return (
                  <span class={className} index={i} attr-index={attrIndex}>
                    {_}
                  </span>
                )
              })
              : ` ${ref}${attrName}${enumCode}${filterNode}`
          }
        }
      })
      return renderType === 'dom'
        ? [
          <span class={`auto-fill-span auto-fill-braces${this.hoverSpan === i + '' ? ' contains' : ''}`} index={i}>
            {'{ '}
          </span>,
          result,
          <span class={`auto-fill-span auto-fill-braces${this.hoverSpan === i + '' ? ' contains' : ''}`} index={i}>
            {' }'}
          </span>
        ]
        : `{ ${result.join('')} }`
    },
    renderDelimiter (val, i) {
      // type === delimiter 时，连接符
      let result = null
      if (this.activeDelimiterIndex === i + '') {
        result = (
          <Input
            ref="delimiterInput"
            on-on-blur={() => this.confirmDelimiter(i)}
            on-on-enter={() => this.$refs.delimiterInput.blur()}
            onInput={v => this.onDelimiterInput(v, i)}
            value={val}
          />
        )
      } else {
        result = [
          <span style="margin-left:5px;"></span>,
          val.split('').map(_ => {
            return (
              <span class={`auto-fill-span${this.hoverSpan === i + '' ? ' hover' : ''}`} index={i}>
                {_}
              </span>
            )
          }),
          <span style="margin-right:5px;"></span>
        ]
      }
      return result
    },
    renderSpecialDelimiter (value, i) {
      const found = this.specialDelimiters.find(item => item.code === value)
      const specialDelimiter = found ? found.value : ''
      return [
        <span style="margin-left:5px;"></span>,
        specialDelimiter.split('').map(_ => {
          return (
            <span
              class={`auto-fill-span auto-fill-special-delimiter${this.hoverSpan === i + '' ? ' hover' : ''}`}
              index={i}
            >
              {_}
            </span>
          )
        }),
        <span style="margin-right:5px;"></span>
      ]
    },
    // 连接符输入框失焦或按回车时，需要更新 this.autoFillArray
    confirmDelimiter (i) {
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
    onDelimiterInput (v, i) {
      this.autoFillArray[i].value = v
    },
    renderAddRule () {
      return [
        <Icon class="auto-fill-add" type="md-add-circle" />,
        !this.autoFillArray.length && (
          <span class="auto-fill-add auto-fill-placeholder">{this.$t('auto_fill_filter_placeholder')}</span>
        )
      ]
    },
    initAutoFillArray () {
      if (!this.allCiTypes.length || !this.value) {
        return
      }
      this.autoFillArray = JSON.parse(this.value)
    },
    focusInput () {
      // 点击编辑连接符后，需要聚焦 Input
      if (this.activeDelimiterIndex && this.$refs.delimiterInput) {
        this.$nextTick(() => {
          this.$refs.delimiterInput.focus()
        })
      }
    },
    // 添加过滤添加的弹框
    renderModal () {
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
          title={this.$t('auto_fill_filter_modal_title')}
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
              <Select
                value={_.name}
                on-on-change={v => this.changeFilter(v, i)}
                class="auto-fill-filter-li-select title"
              >
                {this.filterCiAttrs.map(attr => (
                  <Option key={attr.ciTypeAttrId} value={attr.propertyName}>
                    {attr.name}
                  </Option>
                ))}
              </Select>
              <Select
                value={_.operator}
                on-on-change={v => (this.filters[i].operator = v)}
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
                on-on-change={v => {
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
                  onInput={v => {
                    this.filters[i].value = v
                  }}
                  rootCiTypeId={rootCiTypeId}
                  specialDelimiters={specialDelimiters}
                  value={_.value}
                />
              )}
            </div>
          ))}
          <Button type="primary" long onClick={() => this.filters.push(emptyFilter)}>
            {this.$t('auto_fill_filter_modal_button')}
          </Button>
        </Modal>
      )
    },
    changeFilter (val, i) {
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
    confirmFilter () {
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
      let value = JSON.parse(this.autoFillArray[this.filterIndex[0]].value)
      if (filters.length) {
        value[this.filterIndex[1]].filters = filters
      } else {
        delete value[this.filterIndex[1]].filters
      }
      this.autoFillArray[this.filterIndex[0]].value = JSON.stringify(value)
      this.cancelFilter()
      this.handleInput()
    },
    cancelFilter () {
      this.filterCiTypeId = 0
      this.filters = []
      this.filterCiAttrs = []
      this.filterIndex = []
    },
    handleInput () {
      const value = this.autoFillArray.length ? JSON.stringify(this.autoFillArray) : ''
      let isLegal = true
      this.autoFillArray.forEach(_ => {
        if (_.type === 'rule') {
          const ruleArray = JSON.parse(_.value)
          const lastNode = ruleArray[ruleArray.length - 1]
          const lastAttrId = lastNode.parentRs ? lastNode.parentRs.attrId : 0
          const inputType = this.ciTypeAttrsObj[lastAttrId].inputType
          if (lastNode.parentRs) {
            if (inputType === 'ref' || inputType === 'multiRef') {
              isLegal = false
            } else if (inputType === 'select' || inputType === 'multiSelect') {
              if (!lastNode.enumCodeAttr) {
                isLegal = false
              }
            }
          }
        }
      })
      if (isLegal) {
        this.$emit('input', value)
      }
    }
  },
  mounted () {
    this.initAutoFillArray()
  },
  updated () {
    this.focusInput()
  },
  render (h) {
    return (
      <div class="auto-fill" onmouseover={this.mouseover} onmouseout={this.mouseout} onClick={this.handleClick}>
        {this.isReadOnly ? (
          // 只读状态
          this.renderEditor(this.autoFillArray)
        ) : (
          // 可编辑状态
          <Poptip v-model={this.optionsDisplay}>{this.renderEditor(this.autoFillArray)}</Poptip>
        )}
      </div>
    )
  }
}
