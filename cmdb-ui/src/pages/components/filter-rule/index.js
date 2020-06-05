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
          filter_1: {
            left: this.leftRootCi,
            operator: 'in',
            right: {
              type: 'expression',
              value: this.rightRootCi
            }
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
          this.modalData = JSON.parse(this.value)
        } else {
          this.modalData = JSON.parse(JSON.stringify(this.defaultModalData))
        }
      } else {
        this.modalData = []
      }
    },
    confirmFilter () {
      // TODO
      console.log(JSON.parse(JSON.stringify(this.modalData)))
      this.toggleEditModal(false)
    },
    cancelFilter () {
      this.toggleEditModal(false)
    },
    handleDelete (i) {
      if (i === 0) {
        return
      }
      let arr = Object.keys(this.modalData[0]).sort()
      arr.splice(i, 1)
      let result = {}
      if (!arr.length) {
        this.modalData = []
        return
      }
      arr.forEach((_, _i) => {
        result[`filter_${i + 1}`] = {
          left: this.modalData[0][_].left,
          operator: this.modalData[0][_].left,
          right: {
            type: this.modalData[0][_].right.type,
            value: this.modalData[0][_].right.value
          }
        }
      })
      this.modalData[0] = result
    },
    renderEditor () {
      if (this.value.length) {
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
          i !== 1 ? <span>and</span> : null,
          this.renderLeft(filter, true),
          this.renderOperator(filter, true),
          this.renderRight(filter, true)
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
          class="filter-rule-edit-modal-delete"
        />
      )
    },
    renderLeft (obj, isReadOnly = false) {
      return (
        <AttrExpress
          class={`filter-rule-edit-modal-left${isReadOnly ? ' isReadOnly' : ' editable'}`}
          value={obj.left}
          onInput={v => {
            this.$set(obj, 'left', v)
          }}
          isReadOnly={isReadOnly}
          allCiTypes={this.allCiTypes}
          isFilterAttr={true}
          hiddenAttrType={this.hiddenAttrType}
        />
      )
    },
    renderOperator (obj, isReadOnly = false) {
      const className = `filter-rule-edit-modal-operator${isReadOnly ? ' isReadOnly' : ' editable'}`
      if (isReadOnly) {
        return <span class={className}>{obj.operator}</span>
      } else {
        return (
          <Select
            class={className}
            value={obj.operator}
            onInput={v => {
              this.$set(obj, 'operator', v)
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
    renderRight (obj, isReadOnly = false) {
      const className = `filter-rule-edit-modal-right${isReadOnly ? ' isReadOnly' : ' editable'}`
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
            {this.modalData.length
              ? Object.keys(this.modalData[0])
                .sort()
                .map((filter, i) => {
                  return (
                    <div class="filter-rule-modal-content-li">
                      {this.renderDeleteIcon(i)}
                      {this.renderLeft(this.modalData[0][filter])}
                      {this.renderOperator(this.modalData[0][filter])}
                      {this.renderRight(this.modalData[0][filter])}
                    </div>
                  )
                })
              : null}
          </div>
        </Modal>
      )
    }
  },
  render (h) {
    return <span class="filter-rule">{this.renderEditor()}</span>
  }
}
