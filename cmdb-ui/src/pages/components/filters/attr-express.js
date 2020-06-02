import { getRefCiTypeFrom, getCiTypeAttr, queryCiData, getEnumCodesByCategoryId } from '@/api/server.js'
import { operatorList } from '@/const/operator-list.js'
import FiltersModal from './filters-modal.js'
import './attr-express.scss'

export default {
  name: 'AttrExpress',
  components: {
    FiltersModal
  },
  props: {
    value: { required: true },
    allCiTypes: { default: () => [], type: Array, required: true },
    isFilterAttr: { default: false, type: Boolean, required: false },
    isReadOnly: { default: false, type: Boolean, required: false },
    displayAttrType: { type: Array, required: false },
    hiddenAttrType: { type: Array, required: false },
    operatorList: {
      default: () => operatorList,
      type: Array,
      required: false
    }
  },
  data () {
    return {
      firstChange: true,
      expression: [],
      options: [],
      spinShow: false,
      enumCodes: ['id', 'code', 'value', 'groupCodeId'],
      currentNodeIndex: 0,
      filters: [],
      filterCiAttrs: [],
      filterCiAttrOptions: {},
      modalDisplay: false,
      modalSpin: false
    }
  },
  computed: {
    ciTypesObjByTableName () {
      let obj = {}
      this.allCiTypes.forEach(_ => {
        obj[_.tableName] = _
      })
      return obj
    },
    ciTypesObjById () {
      let obj = {}
      this.allCiTypes.forEach(_ => {
        obj[_.ciTypeId] = _
      })
      return obj
    }
  },
  watch: {
    value (val) {
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
    formatExpression () {
      const arr = this.value.split(/[.~:]/)
      this.expression = []
      arr.forEach((_, i) => {
        let innerText = _
        let filter = false
        let citype = null
        let attr = null
        let nodeType = 'node'
        let className = 'attr-express-node'
        if (_.indexOf('(') >= 0) {
          // refBy
          innerText = '~' + _
          citype = _.split(/[)({[]/)[2]
          attr = _.split(/[)({[]/)[1]
        } else if (_.indexOf('>') >= 0) {
          // refTo
          innerText = '.' + _
          citype = _.split(/[>{[]/)[1]
          attr = _.split(/[>{[]/)[0]
        } else if (i === 0) {
          // 根节点
          citype = _.split(/[:[{]/)[0]
        } else if (_.indexOf('[') === 0) {
          // 属性节点
          innerText = ':' + _
          nodeType = 'attr'
          citype = this.expression[i - 1].props.attrs.citype
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
              attr,
              filter,
              nodeType
            }
          }
        })
      })
    },
    async handleClick (e) {
      if (this.isReadOnly) return
      const target = e.target || e.srcElement
      if (target.nodeName !== 'SPAN') return
      const nodeType = target.getAttribute('nodeType')
      const attrIndex = target.getAttribute('attr-index')
      switch (nodeType) {
        case 'add':
          break
        case 'node':
        case 'attr':
          const ciTypeId = this.ciTypesObjByTableName[target.getAttribute('citype')].ciTypeId
          this.showRefOptions(attrIndex, ciTypeId)
          break
        default:
          break
      }
    },
    showRefOptions (attrIndex, ciTypeId) {
      this.options = []
      this.optionsDisplay = true
      this.optionPushDeleteNode(attrIndex)
      this.optionPushFilterNode(attrIndex)
      this.getRefData(attrIndex, ciTypeId)
    },
    optionPushDeleteNode (attrIndex) {
      this.options.push({
        type: 'option',
        class: 'attr-express-li attr-express-li-delete',
        nodeName: this.$t('auto_fill_delete_node'),
        fn: () => this.deleteNode(attrIndex)
      })
    },
    optionPushFilterNode (attrIndex) {
      this.options.push({
        type: 'option',
        class: 'attr-express-li attr-express-li-filter',
        nodeName: this.$t('auto_fill_add_filter'),
        fn: () => this.showFilterModal(attrIndex)
      })
    },
    showEnumOptions (attrIndex) {
      this.options.push({
        type: 'line'
      })
      this.options = this.options.concat(
        this.enumCodes.map(_ => {
          return {
            type: 'option',
            class: 'attr-express-li attr-express-li-enum',
            nodeName: _,
            fn: () => this.addEnum(attrIndex, _)
          }
        })
      )
    },
    async getRefData (attrIndex, ciTypeId) {
      this.spinShow = true
      const promiseArray = [getRefCiTypeFrom(ciTypeId), getCiTypeAttr(ciTypeId)]
      const [refFroms, ciAttrs] = await Promise.all(promiseArray)
      this.spinShow = false
      if (refFroms.statusCode === 'OK' && ciAttrs.statusCode === 'OK') {
        this.filterCiAttrs = ciAttrs.data
        // 下拉框添加被引用的CI的选项
        refFroms.data.length &&
          this.options.push({
            type: 'line'
          })
        this.options = this.options.concat(
          refFroms.data.map(_ => {
            const ciType = _.ciType.tableName
            const attr = _.propertyName
            const nodeName = `~(${attr})${ciType}`
            const nodeObj = {
              innerText: nodeName,
              props: {
                class: 'attr-express-node',
                attrs: {
                  'attr-index': +attrIndex + 1,
                  filter: false,
                  citype: ciType,
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
              fn: () => this.addNode(+attrIndex + 1, nodeObj)
            }
          })
        )
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
        this.options = this.options.concat(
          _ciAttrs.map(_ => {
            const isRef = _.inputType === 'ref' || _.inputType === 'multiRef'
            const ciType = isRef ? this.ciTypesObjById[_.referenceId].tableName : null
            const attr = _.propertyName
            const nodeName = isRef ? `.${attr}>${ciType}` : `:[${attr}]`
            const nodeObj = {
              innerText: nodeName,
              props: {
                class: 'attr-express-node',
                attrs: {
                  'attr-index': +attrIndex + 1,
                  filter: false,
                  citype: ciType,
                  attr: attr,
                  nodeType: 'node'
                }
              },
              data: {
                inputType: _.inputType,
                ciTypeId: _.referenceId || 0
              }
            }
            return {
              type: 'option',
              class: 'attr-express-li attr-express-li-ref attr-express-li-ref-to',
              nodeName,
              fn: () => this.addNode(+attrIndex + 1, nodeObj)
            }
          })
        )
      }
    },
    addNode (attrIndex, nodeObj) {
      let _index = this.expression[attrIndex - 1].props.attrs.nodeType === 'node' ? attrIndex : attrIndex - 1
      this.expression.splice(_index, this.expression.length - _index, nodeObj)
      if (['ref', 'multiRef'].indexOf(nodeObj.data.inputType) >= 0) {
        this.options = []
        this.optionPushDeleteNode(_index)
        this.optionPushFilterNode(_index)
        this.getRefData(_index, nodeObj.data.ciTypeId)
      } else if (['select', 'multiSelect'].indexOf(nodeObj.data.inputType) >= 0) {
        this.options = []
        this.optionPushDeleteNode(_index)
        this.showEnumOptions(_index)
      } else {
        this.options = []
        this.optionsDisplay = false
      }
      this.handleInput()
    },
    addEnum (attrIndex, code) {
      const _attrIndex = +attrIndex + 1
      const nodeObj = {
        innerText: '.' + code,
        props: {
          class: 'attr-express-node',
          attrs: {
            'attr-index': _attrIndex,
            filter: false,
            citype: '',
            nodeType: 'enum'
          }
        }
      }
      this.options = []
      this.optionsDisplay = false
      this.expression.splice(_attrIndex, this.expression.length - _attrIndex, nodeObj)
    },
    deleteNode (attrIndex) {
      this.options = []
      this.optionsDisplay = false
      this.expression.splice(attrIndex, this.expression.length - attrIndex)
      this.handleInput()
    },
    async showFilterModal (attrIndex) {
      this.options = []
      this.optionsDisplay = false
      this.currentNodeIndex = +attrIndex
      this.modalDisplay = true
      let currentNode = this.expression[attrIndex].innerText
      let refCiTypeIdArray = []
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
            } else if (['select', 'multiSelect'].indexOf(result.inputType) >= 0) {
              result.value = _value.split(',').map(_ => +_.replace(/\[|\]/g, ''))
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
          } else if (['select', 'multiSelect'].indexOf(inputType) >= 0) {
            result.referenceId = found.referenceId
            if (refCiTypeIdArray.indexOf(found.referenceId) === -1) {
              refCiTypeIdArray.push({
                referenceId: found.referenceId,
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
            : getEnumCodesByCategoryId(1, _.referenceId)
        })
      )
      this.modalSpin = false
      this.filters = _filters.map(_ => {
        if (_.referenceId) {
          if (['ref', 'multiRef'].indexOf(_.inputType) >= 0) {
            refCiTypeIdArray.find((attr, i) => {
              if (attr.referenceId === _.referenceId) {
                _.options = refCiDataArray[i].data.contents.map(ciData => ciData.data)
                this.filterCiAttrOptions[attr.code] = _.options
              }
            })
          } else if (['select', 'multiSelect'].indexOf(_.inputType) >= 0) {
            refCiTypeIdArray.find((attr, i) => {
              if (attr.referenceId === _.referenceId) {
                _.options = refCiDataArray[i].data
                this.filterCiAttrOptions[attr.code] = _.options
              }
            })
          }
        }
        return _
      })
    },
    confirmFilter () {
      let _filters = this.filters
        .filter(_ => _.value !== '' || (_.operator === 'in' && _.value.length))
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
          } else if (
            ['select', 'multiSelect'].indexOf(_.inputType) >= 0 &&
            ['null', 'notNull'].indexOf(_.operator) === -1
          ) {
            let result = _.operator === 'in' ? `[${_.value.join(',')}]` : `'${_.value}'`
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
    cancelFilter () {
      this.currentNodeIndex = 0
      this.filters = []
      this.filterCiAttrs = []
      this.filterCiAttrOptions = {}
    },
    handleInput () {
      const lastNode = this.expression.length ? this.expression[this.expression.length - 1] : null
      const lastNodeText = lastNode ? lastNode.innerText : ''
      if (this.expression.length >= 1 && lastNodeText.split('[').length <= 1) {
        this.$emit('input', null)
        this.expression[this.expression.length - 1].props.class += ' error'
      } else {
        let _value = ''
        this.expression.forEach(_ => {
          _value += _.innerText
        })
        this.$emit('input', _value)
      }
    },
    renderOptions () {
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
            this.spinShow ? <Spin fix /> : null
          ]}
        </div>
      )
    },
    renderAddRule () {
      if (this.isReadOnly || this.expression.length) {
        return [<span></span>]
      } else {
        return [
          <Icon nodeType="add" class="attr-express-add" type="md-add-circle" />,
          <span nodeType="add" class="attr-express-add attr-express-placeholder">
            {this.$t('auto_fill_filter_placeholder')}
          </span>
        ]
      }
    },
    renderModal () {
      return (
        <Modal
          value={this.modalDisplay}
          onInput={v => {
            this.modalDisplay = v
          }}
          title={this.$t('auto_fill_filter_modal_title')}
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
    renderSpan (v) {
      const p = {
        ...v.props,
        domProps: {
          innerHTML: v.innerText.replace(/\s/g, '&nbsp;').replace(/</g, '&lt;')
        }
      }
      return <span {...p}></span>
    },
    renderExpress () {
      return [
        !this.isReadOnly && this.renderOptions(),
        ...this.expression.map(_ => this.renderSpan(_)),
        // ...this.renderAddRule(),
        <span></span>,
        this.renderModal()
      ]
    }
  },
  mounted () {
    this.formatExpression()
  },
  render (h) {
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
