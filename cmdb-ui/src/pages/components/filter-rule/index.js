import AttrExpress from '../filters/attr-express.js'
import { operatorList } from '@/const/operator-list.js'
import './filter-rule.scss'

export default {
  name: 'FilterRule',
  components: {
    AttrExpress
  },
  props: {
    value: { required: true },
    allCiTypes: { default: () => [], type: Array, required: true },
    leftRootCi: { type: String, required: true },
    rightRootCi: { type: String, required: true },
    isReadOnly: { default: false, type: Boolean, required: false }
  },
  data () {
    return {
      modalDisplay: false,
      modalData: [],
      hiddenAttrType: ['select', 'multiSelect']
    }
  },
  computed: {
    defaultModalData () {
      return [
        {
          left: this.leftRootCi + ':[guid]',
          operator: 'in',
          right: {
            type: 'expression',
            value: this.rightRootCi
          }
        }
      ]
    }
  },
  methods: {
    toggleEditModal (type) {
      this.modalDisplay = type
      if (type) {
        if (this.value) {
          let filterObj = JSON.parse(this.value)[0]
          this.modalData = Object.keys(filterObj)
            .sort()
            .map(_ => {
              return filterObj[_]
            })
        } else {
          this.modalData = JSON.parse(JSON.stringify(this.defaultModalData))
        }
      } else {
        this.modalData = []
      }
    },
    confirmFilter () {
      let result = {}
      const arr = this.modalData.filter(_ => {
        if (['notNull', 'null', 'notEmpty', 'empty'].indexOf(_.operator) === -1 && !_.right.value) {
          return false
        }
        if (!_.left) {
          return false
        }
        return true
      })
      if (arr.length) {
        arr.forEach((_, i) => {
          result[`filter_${i + 1}`] = _
        })
        this.$emit('input', JSON.stringify([result]))
      } else {
        this.$emit('input', '')
      }
      this.toggleEditModal(false)
    },
    cancelFilter () {
      this.toggleEditModal(false)
    },
    handleDelete (i) {
      let arr = JSON.parse(JSON.stringify(this.modalData))
      arr.splice(i, 1)
      this.modalData = arr
    },
    renderEditor () {
      if (this.value) {
        return [...this.renderFilterBody(JSON.parse(this.value)), this.renderEditIcon(), this.renderEditModal()]
      } else {
        return [this.renderEditIcon(), this.renderEditModal()]
      }
    },
    renderFilterBody (value) {
      let result = []
      const fn = i => {
        const filter = value[0][`filter_${i}`]
        result = result.concat([
          i !== 1 ? <span class="filter-rule-key-word">and</span> : <span></span>,
          <span class="filter-rule-key-word">{'{'}</span>,
          this.renderLeft(filter, true),
          this.renderOperator(filter, true),
          this.renderRight(filter, true),
          <span class="filter-rule-key-word">{'}'}</span>
        ])
        if (value[0][`filter_${i + 1}`]) {
          fn(i + 1)
        }
      }
      fn(1)
      return result
    },
    renderDeleteIcon (i) {
      return (
        <Icon
          type="md-remove-circle"
          color="red"
          onClick={() => this.handleDelete(i)}
          class="filter-rule-edit-modal-input filter-rule-edit-modal-delete"
        />
      )
    },
    renderLeft (obj, isReadOnly = false) {
      return (
        <AttrExpress
          class={`filter-rule-edit-modal-input filter-rule-edit-modal-left${isReadOnly ? ' isReadOnly' : ' editable'}`}
          value={obj.left}
          onInput={v => {
            this.$set(obj, 'left', v)
          }}
          isReadOnly={isReadOnly}
          allCiTypes={this.allCiTypes}
          isFilterAttr={true}
          hiddenAttrType={this.hiddenAttrType}
          hideFilterModal={true}
        />
      )
    },
    renderOperator (obj, isReadOnly = false) {
      const className = `filter-rule-edit-modal-input filter-rule-edit-modal-operator${
        isReadOnly ? ' isReadOnly filter-rule-key-word' : ' editable'
      }`
      if (isReadOnly) {
        return <span class={className}>{obj.operator}</span>
      } else {
        return (
          <Select
            class={className}
            value={obj.operator}
            onInput={v => {
              this.$set(obj, 'operator', v)
              if (['notNull', 'null', 'notEmpty', 'empty'].indexOf(v) >= 0) {
                this.$set(obj.right, 'type', 'value')
                this.$set(obj.right, 'value', '')
              } else if (v === 'in') {
                this.$set(obj.right, 'type', 'expression')
                this.$set(obj.right, 'value', this.rightRootCi)
              } else {
                this.$set(obj.right, 'type', 'value')
                if (obj.right.value !== null && obj.right.value.indexOf(this.rightRootCi) === 0) {
                  this.$set(obj.right, 'value', '')
                }
              }
            }}
          >
            {operatorList.map(_ => (
              <Option key={_.code} value={_.code}>
                {_.value}
              </Option>
            ))}
          </Select>
        )
      }
    },
    renderRightType (obj) {
      const className = 'filter-rule-edit-modal-input filter-rule-edit-modal-right-type'
      if (['notNull', 'null', 'notEmpty', 'empty'].indexOf(obj.operator) >= 0) {
        return <Input class={className} disabled />
      }
      let types = []
      if (obj.operator === 'in') {
        types = ['expression', 'array']
      } else {
        types = ['value']
      }
      return (
        <Select
          class={className}
          value={obj.right.type}
          onInput={v => {
            this.$set(obj.right, 'type', v)
            const value = v === 'expression' ? this.rightRootCi : ''
            this.$set(obj.right, 'value', value)
          }}
        >
          {types.map(_ => (
            <Option key={_} value={_}>
              {_}
            </Option>
          ))}
        </Select>
      )
    },
    renderRight (obj, isReadOnly = false) {
      const className = `filter-rule-edit-modal-input filter-rule-edit-modal-right${
        isReadOnly ? ' isReadOnly' : ' editable'
      }`
      if (['notNull', 'null', 'notEmpty', 'empty'].indexOf(obj.operator) >= 0) {
        return <Input class={className} disabled />
      }
      switch (obj.right.type) {
        case 'expression':
          return (
            <AttrExpress
              class={className}
              value={obj.right.value}
              onInput={v => {
                this.$set(obj.right, 'value', v)
              }}
              isReadOnly={isReadOnly}
              allCiTypes={this.allCiTypes}
              isFilterAttr={true}
              hiddenAttrType={this.hiddenAttrType}
            />
          )
        case 'value':
          return isReadOnly ? (
            <span class={className}>{obj.right.value}</span>
          ) : (
            <Input
              class={className}
              value={obj.right.value}
              onInput={v => {
                this.$set(obj.right, 'value', v)
              }}
            />
          )
        case 'array':
          return isReadOnly ? (
            <span class={className}>{obj.right.value.join('')}</span>
          ) : (
            <Input
              class={className}
              value={obj.right.value}
              onInput={v => {
                this.$set(obj.right, 'value', v)
              }}
            />
          )
        default:
          return <Input class={className} disabled />
      }
    },
    renderEditIcon () {
      return (
        <span class="filter-rule-edit-icon" onClick={() => this.toggleEditModal(true)}>
          <Icon type="md-add-circle" />
          {!this.value && <span>{this.$t('filter_rule_edit_icon_placeholder')}</span>}
        </span>
      )
    },
    renderEditModal () {
      return (
        <Modal
          value={this.modalDisplay}
          onInput={v => {
            this.modalDisplay = v
          }}
          title={this.$t('filter_rule_modal_title')}
          width="800"
          on-on-ok={this.confirmFilter}
          on-on-cancel={this.cancelFilter}
        >
          <div class="filter-rule-modal-content">
            {this.modalData.length ? (
              this.modalData.map((_, i) => {
                return (
                  <div class="filter-rule-modal-content-li">
                    {this.renderDeleteIcon(i)}
                    {this.renderLeft(this.modalData[i])}
                    {this.renderOperator(this.modalData[i])}
                    {this.renderRightType(this.modalData[i])}
                    {this.renderRight(this.modalData[i])}
                  </div>
                )
              })
            ) : (
              <span></span>
            )}
            <Button type="primary" long onClick={() => this.modalData.push(...this.defaultModalData)}>
              {this.$t('filter_rule_add_button')}
            </Button>
          </div>
        </Modal>
      )
    }
  },
  render (h) {
    return <span class="filter-rule">{this.renderEditor()}</span>
  }
}
