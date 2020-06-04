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
    isReadOnly: { default: false, type: Boolean, required: false },
    leftRootCi: {},
    rightRootCi: {}
  },
  data () {
    return {
      modalDisplay: false,
      editData: {
        left: '',
        operator: 'in',
        right: {
          type: 'expression',
          value: ''
        }
      }
    }
  },
  methods: {
    handleLeftInput (v) {
      // TODO
    },
    handleRightInput () {
      // TODO
    },
    toggleEditModal (type) {
      this.modalDisplay = type
      if (type) {
        // TODO
      } else {
        // TODO
      }
    },
    confirmFilter () {
      // TODO
    },
    cancelFilter () {
      // TODO
    },
    renderEditor () {
      if (this.value.length) {
        const leftValue = this.value[0].filter_1.left
        const operator = this.value[0].filter_1.operator
        const rightType = this.value[0].filter_1.right.type
        const rightValue = this.value[0].filter_1.right.value
        return [
          this.renderLeft(leftValue, true),
          this.renderOperator(operator, true),
          this.renderRight(rightType, rightValue, true),
          this.renderEditIcon(),
          this.renderEditModal()
        ]
      } else {
        return [this.renderEditIcon(), this.renderEditModal()]
      }
    },
    renderLeft (value, isReadOnly = false) {
      return (
        <AttrExpress
          class={`filter-rule-edit-modal-left${isReadOnly ? ' isReadOnly' : ' editable'}`}
          value={value}
          onInput={this.handleLeftInput}
          isReadOnly={isReadOnly}
          allCiTypes={this.allCiTypes}
        />
      )
    },
    renderOperator (operator, isReadOnly = false) {
      if (isReadOnly) {
        return <span>{operator}</span>
      } else {
        return (
          <Select
            class={`filter-rule-edit-modal-operator${isReadOnly ? ' isReadOnly' : ' editable'}`}
            value={this.editData.operator}
            onInput={v => {
              this.editData.operator = v
            }}
          >
            {operatorList.map(_ => (
              <Option key={_.code} value={_.value}>
                {_.value}
              </Option>
            ))}
          </Select>
        )
      }
    },
    renderRight (type, value, isReadOnly = false) {
      const className = `filter-rule-edit-modal-right${isReadOnly ? ' isReadOnly' : ' editable'}`
      switch (type) {
        case 'expression':
          return (
            <AttrExpress
              class={className}
              value={value}
              onInput={this.handleRightInput}
              isReadOnly={isReadOnly}
              allCiTypes={this.allCiTypes}
            />
          )
        case 'value':
          // TODO
          return isReadOnly ? (
            <span class={className}>{value}</span>
          ) : (
            <Input class={className} value={value} onInput={this.handleRightInput} />
          )
        case 'array':
          return isReadOnly ? (
            <span class={className}>{value.join('')}</span>
          ) : (
            <Input class={className} value={value} onInput={this.handleRightInput} />
          )
        default:
          return null
      }
    },
    renderEditIcon () {
      return (
        <span class="filter-rule-edit-icon" onClick={() => this.toggleEditModal(true)}>
          <Icon type="md-create" />
          {!this.value.length && <span>{this.$t('filter_rule_edit_icon_placeholder')}</span>}
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
            {[
              this.renderLeft(this.editData.left),
              this.renderOperator(this.editData.operator),
              this.renderRight(this.editData.right.type, this.editData.right.value)
            ]}
          </div>
        </Modal>
      )
    }
  },
  render (h) {
    return <span class="filter-rule">{this.renderEditor()}</span>
  }
}
