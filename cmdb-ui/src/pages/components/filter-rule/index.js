import AttrExpress from '../permission-filters/attr-express.js'
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
    rootCiTypeId: { required: false },
    leftRootCi: { type: String, required: true },
    rightRootCi: { type: String, required: true },
    isReadOnly: { default: false, type: Boolean, required: false }
  },
  data () {
    return {
      modalDisplay: false,
      modalData: [],
      hiddenAttrType: []
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
      this.modalData = []
      if (type) {
        if (this.value) {
          let filterObj = JSON.parse(this.value)[0]
          this.modalData = Object.keys(filterObj)
            .sort()
            .map(_ => {
              return filterObj[_]
            })
        } else {
          this.modalData = []
          // this.modalData = JSON.parse(JSON.stringify(this.defaultModalData))
        }
      } else {
        this.modalData = []
      }
    },
    confirmFilter () {
      let result = {}
      const arr = this.modalData.filter(_ => {
        if (['notNull', 'null', 'notEmpty', 'empty', 'eq', 'ne'].indexOf(_.operator) === -1 && !_.right.value) {
          return false
        }
        if (!_.left) {
          return false
        }
        return true
      })
      if (arr.length) {
        arr.forEach((_, i) => {
          if (_.right.type === 'array') {
            _.right.value = _.right.value.split(',')
          }
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
        return [...this.renderFilterBody(JSON.parse(this.value)), this.renderEditIcon()]
      } else {
        return this.renderEditIcon()
      }
    },
    renderFilterBody (value) {
      const arr = Object.keys(value[0])
        .sort()
        .map(_ => {
          return value[0][_]
        })
      let result = []
      arr.forEach((_, i) => {
        result.push(
          i !== 0 ? <span class="filter-rule-key-word">and</span> : <span></span>,
          <span class="filter-rule-key-word">{'{'}</span>,
          this.renderLeft(_, true),
          this.renderOperator(_, true),
          this.renderRight(_, true),
          <span class="filter-rule-key-word">{'}'}</span>
        )
      })
      return result
    },
    renderDeleteIcon (i) {
      return (
        <Icon
          type="md-remove-circle"
          color="red"
          onClick={() => this.handleDelete(i)}
          class="filter-rule-edit-modal input delete"
        />
      )
    },
    renderLeft (obj, isReadOnly = false) {
      return (
        <div style="max-width:400px;display:inline-block">
          <AttrExpress
            class={`filter-rule-edit-modal input left${isReadOnly ? ' isReadOnly' : ' editable'}`}
            value={obj.left}
            onInput={v => {
              this.$set(obj, 'left', v)
            }}
            isReadOnly={isReadOnly}
            allCiTypes={this.allCiTypes}
            rootCiTypeId={this.leftRootCi}
            isFilterAttr={true}
            hiddenAttrType={this.hiddenAttrType}
            hideFilterModal={true}
          />
        </div>
      )
    },
    renderOperator (obj, isReadOnly = false) {
      const className = `filter-rule-edit-modal input operator${
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
      const className = 'filter-rule-edit-modal input right-type'
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
      const className = `filter-rule-edit-modal input right${isReadOnly ? ' isReadOnly' : ' editable'}`
      if (['notNull', 'null', 'notEmpty', 'empty'].indexOf(obj.operator) >= 0) {
        return <Input class={className} disabled />
      }
      switch (obj.right.type) {
        case 'expression':
          return (
            <div style="max-width:400px;display:inline-block">
              <AttrExpress
                class={className}
                value={obj.right.value}
                onInput={v => {
                  this.$set(obj.right, 'value', v)
                }}
                isReadOnly={isReadOnly}
                allCiTypes={this.allCiTypes}
                rootCiTypeId={this.rightRootCi}
                isFilterAttr={true}
                hiddenAttrType={this.hiddenAttrType}
                hideFirstFilter={true}
                hideFirstRefBy={true}
              />
            </div>
          )
        case 'value':
          return isReadOnly ? (
            <span class={className}>{obj.right.value ? obj.right.value : "''"}</span>
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
          if (obj.right.value instanceof Array) {
            obj.right.value = obj.right.value.join(',')
          }
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
          width="900"
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
            <Button
              type="primary"
              long
              onClick={() => this.modalData.push(JSON.parse(JSON.stringify(this.defaultModalData))[0])}
            >
              {this.$t('filter_rule_add_button')}
            </Button>
          </div>
        </Modal>
      )
    }
  },
  render (h) {
    return (
      <span class="filter-rule">
        {this.renderEditModal()}
        {this.renderEditor()}
      </span>
    )
  }
}
