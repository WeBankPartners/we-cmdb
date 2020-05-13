import './filters.scss'
import AttrExpress from './attr-express.js'

export default {
  name: 'FiltersRule',
  component: {
    AttrExpress
  },
  props: {
    value: { default: [], type: Array, required: true },
    allCiTypes: { default: () => [], type: Array, required: true },
    isFilterAttr: { default: false, type: Boolean, required: false },
    displayAttrType: { default: () => [], type: Array, required: false },
    rootCis: { default: () => [], type: Array, required: true }
  },
  data () {
    return {
      modalDisplay: false,
      optionsDisplay: false
    }
  },
  methods: {
    addExpression (v) {
      let _value = JSON.parse(JSON.stringify(this.value))
      _value.push(v + ':[guid]')
      this.$emit('input', _value)
      this.optionsDisplay = false
    },
    handleInput (v, i) {
      let _value = JSON.parse(JSON.stringify(this.value))
      if (v === '') {
        _value.splice(i, 1)
      } else {
        _value.splice(i, 1, v)
      }
      this.$emit('input', _value)
    },
    renderAddIcon () {
      if (this.isReadOnly) {
        return null
      } else {
        return (
          <Poptip v-model={this.optionsDisplay}>
            <div slot="content" class="filters-rule-options">
              {this.rootCis.map(_ => (
                <div onClick={() => this.addExpression(_)}>{_}</div>
              ))}
            </div>
            <Button class="filters-rule-add" size="small">
              {this.$t('add_expression')}
            </Button>
          </Poptip>
        )
      }
    }
  },
  render (h) {
    if (this.isReadOnly && !this.value.length) {
      return null
    } else {
      return (
        <div class="filters-rule" filterIndex>
          {this.value.map((_, i) => [
            i > 0 ? <span> | </span> : null,
            <AttrExpress
              value={_}
              onInput={v => this.handleInput(v, i)}
              allCiTypes={this.allCiTypes}
              isFilterAttr={this.isFilterAttr}
              displayAttrType={this.displayAttrType}
            />
          ])}
          {this.renderAddIcon()}
        </div>
      )
    }
  }
}
