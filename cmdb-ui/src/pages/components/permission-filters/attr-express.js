import { getCiTypeAttr, getEnumCodesByCategoryId, getRefCiTypeFrom, queryCiData } from '@/api/server.js'
import { operatorList } from '@/const/operator-list.js'
import './attr-express.scss'
import FiltersModal from './filters-modal.js'

export default {
  name: 'AttrExpress',
  components: {
    FiltersModal
  },
  props: {
    value: { required: true },
    disabled: { default: () => false },
    allCiTypes: { default: () => [], type: Array, required: true },
    isFilterAttr: { default: false, type: Boolean, required: false }, // 为true时，根据 displayAttrType 或 hiddenAttrType 显示对应类型的属性
    isReadOnly: { default: false, type: Boolean, required: false },
    displayAttrType: { type: Array, required: false }, // isFilterAttr 为 true 时，下拉框内只显示 inputType 包含于 displayAttrType 内的属性，例如 ['ref', 'multiRef'] 则只显示 ref 及 multiRef 类型的属性
    hiddenAttrType: { type: Array, required: false }, // isFilterAttr 为 true 时，下拉框内只显示 inputType 不包含于 hiddenAttrType 内的属性，例如 ['select', 'multiSelect'] 则不显示 select 及 multiSelect 类型的属性
    operatorList: { default: () => operatorList, type: Array, required: false },
    showAddButton: { default: false, type: Boolean, required: false },
    banRootCiDelete: { default: false, type: Boolean, required: false }, // 为 true 时，禁止删除根节点
    hideFilterModal: { default: false, type: Boolean, required: false }, // 为 true 时，禁止添加过滤项
    hideFirstFilter: { default: false, type: Boolean, required: false }, // 为 true 时，禁止在根节点除添加过滤项
    hideFirstRefBy: { default: false, type: Boolean, required: false }, // 为 true 时，根节点后的第一个节点隐藏 refBy 的节点，即只显示 refTo 的节点
    rootCiTypeId: { required: false }
  },
  data() {
    return {
      firstChange: true,
      expression: [],
      options: [],
      spinShow: false,
      currentNodeIndex: 0,
      filters: [],
      filterCiAttrs: [],
      filterCiAttrOptions: {},
      modalDisplay: false,
      modalSpin: false
    }
  },
  computed: {
    ciTypesObjByTableName() {
      let obj = {}
      this.allCiTypes.forEach(_ => {
        obj[_.ciTypeId] = _
      })
      return obj
    },
    ciTypesObjById() {
      let obj = {}
      this.allCiTypes.forEach(_ => {
        obj[_.ciTypeId] = _
      })
      return obj
    }
  },
  watch: {
    value(val) {
      if (val) {
        this.formatExpression()
        if (this.firstChange) {
          this.firstChange = false
          this.handleInput()
        }
      }
    }
  },
  methods: {
    formatExpression() {
      this.expression = []
      if (!this.value) {
        return
      }
      const arr = this.value.split(/[.~:]/)
      arr.forEach((_, i) => {
        let innerText = _
        let filter = false
        let citype = null
        let ciTypeId = null
        let attr = null
        let nodeType = 'node'
        let className = 'attr-express-node'
        if (_.indexOf('(') >= 0) {
          // refBy
          innerText = '~' + _
          citype = _.split(/[)({[]/)[2]
          ciTypeId = this.ciTypesObjByTableName[citype].ciTypeId
          attr = _.split(/[)({[]/)[1]
        } else if (_.indexOf('>') >= 0) {
          // refTo
          innerText = '.' + _
          citype = _.split(/[>{[]/)[1]
          ciTypeId = this.ciTypesObjByTableName[citype].ciTypeId
          attr = _.split(/[>{[]/)[0]
        } else if (i === 0) {
          // 根节点
          citype = _.split(/[:[{]/)[0]
          ciTypeId = this.rootCiTypeId
        } else if (_.indexOf('[') === 0) {
          // 属性节点
          innerText = ':' + _
          nodeType = 'attr'
          citype = this.expression[i - 1].props.attrs.ciTypeId
          ciTypeId = this.ciTypesObjByTableName[citype].ciTypeId
          attr = _.replace(/[[\]]/g, '')
        } else {
          // 枚举属性
        }
        if (_.indexOf('{') >= 0) {
          filter = true
        }
        this.expression.push({
          innerText,
          props: {
            class: className,
            attrs: {
              'attr-index': i,
              citype,
              ciTypeId,
              attr,
              filter,
              nodeType
            }
          }
        })
      })
      this.handleInput()
    },
    async handleClick(e) {
      e.stopPropagation()
      if (this.isReadOnly) return
      const target = e.target || e.srcElement
      if (target.nodeName !== 'SPAN') return
      const nodeType = target.getAttribute('nodetype')
      const attrIndex = target.getAttribute('attr-index')
      switch (nodeType) {
        case 'add':
          break
        case 'node':
        case 'attr':
          const ciTypeId = target.getAttribute('citype')
          const _attrIndex = nodeType === 'node' ? +attrIndex : +attrIndex - 1
          this.showRefOptions(_attrIndex, ciTypeId)
          break
        default:
          break
      }
    },
    showRefOptions(attrIndex, ciTypeId) {
      this.options = []
      this.optionsDisplay = true
      this.optionPushDeleteNode(attrIndex)
      this.optionPushFilterNode(attrIndex)
      this.getRefData(attrIndex, ciTypeId)
    },
    optionPushDeleteNode(attrIndex) {
      // if (+attrIndex === 0 && !this.banRootCiDelete) {
      //   return
      // }
      this.options.push({
        type: 'option',
        class: 'attr-express-li attr-express-li-delete',
        nodeName: this.$t('auto_fill_delete_node'),
        fn: () => this.deleteNode(attrIndex)
      })
    },
    optionPushFilterNode(attrIndex) {
      if (this.hideFilterModal) {
        return
      }
      if (this.hideFirstFilter && !attrIndex) {
        return
      }
      this.options.push({
        type: 'option',
        class: 'attr-express-li attr-express-li-filter',
        nodeName: this.$t('auto_fill_add_filter'),
        fn: () => this.showFilterModal(attrIndex)
      })
    },
    async getRefData(attrIndex, ciTypeId) {
      this.spinShow = true
      const promiseArray = [getRefCiTypeFrom(ciTypeId), getCiTypeAttr(ciTypeId)]
      const [refFroms, ciAttrs] = await Promise.all(promiseArray)
      this.spinShow = false
      if (refFroms.statusCode === 'OK' && ciAttrs.statusCode === 'OK') {
        this.filterCiAttrs = ciAttrs.data
        // 下拉框添加被引用的CI的选项
        if (attrIndex || !this.hideFirstRefBy) {
          refFroms.data.length &&
            this.options.push({
              type: 'line'
            })
          this.options = this.options.concat(
            refFroms.data.map(_ => {
              const ciType = _.ciTypeId
              const attr = _.propertyName
              const nodeName = `~(${attr})${ciType}`
              const nodeObj = {
                innerText: nodeName,
                props: {
                  class: 'attr-express-node',
                  attrs: {
                    'attr-index': attrIndex + 1,
                    filter: false,
                    citype: ciType,
                    ciTypeId: this.ciTypesObjByTableName[ciType].ciTypeId,
                    nodeType: 'node'
                  }
                },
                data: {
                  inputType: _.inputType,
                  ciTypeId: _.ciTypeId
                }
              }
              return {
                type: 'option',
                class: 'attr-express-li attr-express-li-ref attr-express-li-ref-from',
                nodeName,
                fn: () => this.addNode(attrIndex + 1, nodeObj)
              }
            })
          )
        }
        // 下拉框添加属性及引用的CI的选项
        ciAttrs.data.length &&
          this.options.push({
            type: 'line'
          })
        let _ciAttrs = ciAttrs.data
        if (this.isFilterAttr) {
          if (this.displayAttrType) {
            _ciAttrs = ciAttrs.data.filter(_ => this.displayAttrType.indexOf(_.inputType) >= 0)
          } else if (this.hiddenAttrType) {
            _ciAttrs = ciAttrs.data.filter(_ => this.hiddenAttrType.indexOf(_.inputType) === -1)
          }
        }
        let cacheOptions = []
        _ciAttrs.forEach(_ => {
          const isRef = _.inputType === 'ref' || _.inputType === 'multiRef'
          const _nodeType = isRef ? 'node' : 'attr'
          const ciType = isRef ? this.ciTypesObjById[_.referenceId].ciTypeId : this.ciTypesObjById[ciTypeId].ciTypeId
          const attr = _.propertyName
          const nodeName = isRef ? `.${attr}>${ciType}` : `:[${attr}]`
          let nodeObj = {
            innerText: nodeName,
            props: {
              class: 'attr-express-node',
              attrs: {
                'attr-index': attrIndex + 1,
                filter: false,
                citype: ciType,
                ciTypeId: this.ciTypesObjByTableName[ciType].ciTypeId,
                attr,
                nodeType: _nodeType
              }
            },
            data: {
              inputType: _.inputType,
              ciTypeId: _.referenceId || 0
            }
          }
          cacheOptions.push({
            type: 'option',
            class: 'attr-express-li attr-express-li-ref attr-express-li-ref-to',
            nodeName,
            fn: () => this.addNode(attrIndex + 1, nodeObj)
          })
          if (isRef) {
            const refNodeName = `:[${attr}]`
            let refNode = {
              innerText: refNodeName,
              props: {
                class: 'attr-express-node',
                attrs: {
                  'attr-index': attrIndex + 1,
                  filter: false,
                  citype: ciType,
                  ciTypeId: this.ciTypesObjByTableName[ciType].ciTypeId,
                  attr,
                  nodeType: _nodeType
                }
              },
              data: {
                inputType: _.inputType,
                ciTypeId: _.referenceId || 0
              }
            }

            cacheOptions.push({
              type: 'option',
              class: 'attr-express-li attr-express-li-ref attr-express-li-ref-to',
              nodeName: refNodeName,
              fn: () => this.addNode(attrIndex + 1, refNode)
            })
          }
        })
        this.options = this.options.concat(cacheOptions)
      }
    },
    addNode(attrIndex, nodeObj) {
      let _index = this.expression[attrIndex - 1].props.attrs.nodeType === 'node' ? attrIndex : attrIndex - 1
      this.expression.splice(_index, this.expression.length - _index, nodeObj)
      if (['ref', 'multiRef'].indexOf(nodeObj.data.inputType) >= 0) {
        this.options = []
        this.optionPushDeleteNode(_index)
        this.optionPushFilterNode(_index)
        this.getRefData(_index, nodeObj.data.ciTypeId)
      } else {
        this.options = []
        this.optionsDisplay = false
      }
      this.handleInput()
    },
    addEnum(attrIndex, code) {
      const _attrIndex = +attrIndex + 1
      const nodeObj = {
        innerText: '.' + code,
        props: {
          class: 'attr-express-node',
          attrs: {
            'attr-index': _attrIndex,
            filter: false,
            citype: '',
            ciTypeId: '',
            nodeType: 'enum'
          }
        }
      }
      this.options = []
      this.optionsDisplay = false
      this.expression.splice(_attrIndex, this.expression.length - _attrIndex, nodeObj)
    },
    deleteNode(attrIndex) {
      this.options = []
      this.optionsDisplay = false
      this.expression.splice(attrIndex, this.expression.length - attrIndex)
      this.handleInput()
    },
    async showFilterModal(attrIndex) {
      this.options = []
      this.optionsDisplay = false
      this.currentNodeIndex = +attrIndex
      this.modalDisplay = true
      let currentNode = this.expression[attrIndex].innerText
      let refCiTypeIdArray = []
      let selectCiTypeIdArray = []
      let _filters = currentNode
        .split(/\[\{|},{|}]/)
        .filter((_, i) => i !== 0 && _ !== '')
        .map(_ => {
          const found = this.filterCiAttrs.find(attr => attr.propertyName === _.split(' ')[0])
          let inputType = found ? found.inputType : ''
          let result = {
            name: _.split(' ')[0],
            operator: _.split(' ')[1],
            inputType
          }
          const _value = _.split(' ')[2]
          if (result.operator === 'in') {
            if (['ref', 'multiRef'].indexOf(result.inputType) >= 0) {
              result.value = _value.split(',').map(_ => _.replace(/'|\[|\]/g, ''))
            } else {
              result.value = _value.replace(/'|\[|\]/g, '')
            }
          } else {
            result.value = _value ? _value.split("'").filter(item => item !== '')[0] : null
          }
          if (['ref', 'multiRef'].indexOf(inputType) >= 0) {
            result.referenceId = found.referenceId
            if (refCiTypeIdArray.indexOf(found.referenceId) === -1) {
              refCiTypeIdArray.push({
                referenceId: found.referenceId,
                code: result.name,
                type: 'isRef'
              })
            }
          }
          if (['select', 'multiSelect'].includes(inputType)) {
            if (selectCiTypeIdArray.indexOf(found.name) === -1) {
              selectCiTypeIdArray.push({
                code: result.name,
                type: 'isSelect'
              })
            }
          }
          return result
        })
      this.modalSpin = true
      const refCiDataArray = await Promise.all(
        refCiTypeIdArray.map(_ => {
          return _.type === 'isRef'
            ? queryCiData({
                id: _.referenceId,
                queryObject: {}
              })
            : getEnumCodesByCategoryId(_.referenceId)
        })
      )
      const selectCiDataArray = await Promise.all(
        selectCiTypeIdArray.map(_ => {
          return getEnumCodesByCategoryId(_.code)
        })
      )
      this.modalSpin = false
      this.filters = _filters.map(_ => {
        if (_.referenceId) {
          if (['ref', 'multiRef'].indexOf(_.inputType) >= 0) {
            refCiTypeIdArray.find((attr, i) => {
              if (attr.referenceId === _.referenceId) {
                _.options = refCiDataArray[i].data.contents
                this.filterCiAttrOptions[attr.code] = _.options
              }
            })
          }
        }
        if (['select', 'multiSelect'].includes(_.inputType)) {
          selectCiTypeIdArray.forEach((attr, i) => {
            if (attr.code === _.name) {
              _.options = selectCiDataArray[i].data
              _.value = _.value.split(',')
              this.filterCiAttrOptions[attr.code] = _.options
            }
          })
        }
        return _
      })
    },
    confirmFilter() {
      let _filters = this.filters
        .filter(_ => !(_.operator === 'in' && _.value.length === 0))
        .map(_ => {
          if (['ref', 'multiRef'].indexOf(_.inputType) >= 0 && ['null', 'notNull'].indexOf(_.operator) === -1) {
            let result =
              _.operator === 'in'
                ? `[${_.value
                    .map(item => {
                      return `'${item}'`
                    })
                    .join(',')}]`
                : `'${_.value}'`
            return `${_.name} ${_.operator} ${result}`
          } else if (['null', 'notNull'].indexOf(_.operator) === -1) {
            let result = ''
            if (_.operator === 'in') {
              if (Array.isArray(_.value)) {
                result = `[${_.value.join(',')}]`
              } else {
                result = `[${JSON.parse(_.value).join(',')}]`
              }
            } else {
              result = `'${_.value}'`
            }
            // let result = _.operator === 'in' ? `[${JSON.parse(_.value).join(',')}]` : `'${_.value}'`
            return `${_.name} ${_.operator} ${result}`
          } else if (['null', 'notNull'].indexOf(_.operator) >= 0) {
            return `${_.name} ${_.operator}`
          } else {
            if (_.operator === 'in') {
              let result = `[${_.value.split(',').map(item => {
                let _item = item.trim().replace(/'/g, '')
                if (_item[0] !== "'" || _item[_item.length - 1] !== "'") {
                  return `'${_item}'`
                }
              })}]`
              return `${_.name} ${_.operator} ${result}`
            } else {
              return `${_.name} ${_.operator} '${_.value.trim().replace(/'/g, '')}'`
            }
          }
        })
      const _innerText = this.expression[this.currentNodeIndex].innerText.split('[')[0]
      const filterExpress = _filters.length ? `[${_filters.map(_ => `{${_}}`).join(',')}]` : ''
      this.expression[this.currentNodeIndex].innerText = `${_innerText}${filterExpress}`
      this.cancelFilter()
      this.handleInput()
    },
    cancelFilter() {
      this.currentNodeIndex = 0
      this.filters = []
      this.filterCiAttrs = []
      this.filterCiAttrOptions = {}
    },
    handleInput() {
      const lastNode = this.expression.length ? this.expression[this.expression.length - 1] : null
      const lastNodeText = lastNode ? lastNode.innerText : ''
      if (this.expression.length >= 1 && lastNodeText.split('[').length <= 1) {
        this.$emit('input', null)
        this.expression[this.expression.length - 1].props.class += ' error'
        this.$emit('input', null)
      } else {
        let _value = ''
        this.expression.forEach(_ => {
          _value += _.innerText
          _.props.class = _.props.class.replace(/[ +]error/g, '')
        })
        this.$emit('input', _value)
      }
    },
    renderOptions() {
      return (
        <div slot="content" class="attr-express-options">
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
            this.spinShow ? <Spin fix /> : <span style="display: none"></span>
          ]}
        </div>
      )
    },
    renderAddRule() {
      if (this.isReadOnly || this.expression.length) {
        return [<span></span>]
      } else {
        return [
          <Icon nodeType="add" class="attr-express-add" type="md-add-circle" />,
          <span nodeType="add" class="attr-express-add attr-express-placeholder">
            {this.$t('attr_express_placeholder')}
          </span>
        ]
      }
    },
    renderModal() {
      return (
        <Modal
          value={this.modalDisplay}
          onInput={v => {
            this.modalDisplay = v
          }}
          title={this.$t('attr_express_modal_title')}
          width="800"
          on-on-ok={this.confirmFilter}
          on-on-cancel={this.cancelFilter}
        >
          <FiltersModal
            value={this.filters}
            onInput={v => {
              this.filters = v
            }}
            filterCiAttrs={this.filterCiAttrs}
            filterCiAttrOptions={this.filterCiAttrOptions}
            onUpdateFilterCiAttrOptions={v => {
              this.filterCiAttrOptions = v
            }}
            operatorList={this.operatorList}
            modalSpin={this.modalSpin}
          />
        </Modal>
      )
    },
    renderSpan(v) {
      const p = {
        ...v.props,
        domProps: {
          innerHTML: v.innerText.replace(/\s/g, '&nbsp;').replace(/</g, '&lt;')
        }
      }
      return <span {...p}></span>
    },
    renderExpress() {
      return [
        !this.isReadOnly && this.renderOptions(),
        ...this.expression.map(_ => this.renderSpan(_)),
        this.showAddButton && this.renderAddRule(),
        <span></span>,
        this.renderModal()
      ]
    }
  },
  mounted() {
    this.formatExpression()
  },
  render(h) {
    return (
      <span class="attr-express" onClick={this.handleClick}>
        {this.isReadOnly ? (
          // 只读状态
          this.renderExpress()
        ) : (
          // 可编辑状态
          <Poptip v-model={this.optionsDisplay}>{this.renderExpress()}</Poptip>
        )}
      </span>
    )
  }
}
