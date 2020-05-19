import './filters-modal.scss'
import { queryCiData, getEnumCodesByCategoryId } from '@/api/server.js'

export default {
  name: 'FiltersModal',
  props: {
    value: { default: () => [], type: Array, required: true },
    filterCiAttrs: { default: () => [], type: Array, required: true },
    operatorList: { default: () => [], type: Array, required: true },
    modalSpin: { default: () => false, type: Boolean, required: false },
    filterCiAttrOptions: { default: () => {}, type: Object, required: false }
  },
  methods: {
    async changeFilter (val, i) {
      let _value = JSON.parse(JSON.stringify(this.value))
      let item = _value[i]
      item.name = val
      const found = this.filterCiAttrs.find(attr => attr.propertyName === val)
      if (found) {
        item.inputType = found.inputType
        if (['ref', 'multiRef'].indexOf(found.inputType) >= 0) {
          if (!this.filterCiAttrOptions[val]) {
            const { data, statusCode } = await queryCiData({
              id: found.referenceId,
              queryObject: {}
            })
            if (statusCode === 'OK') {
              item.options = data.contents.map(ciData => ciData.data)
              let _filterCiAttrOptions = JSON.parse(JSON.stringify(this.filterCiAttrOptions))
              _filterCiAttrOptions[val] = item.options
              this.$emit('updateFilterCiAttrOptions', _filterCiAttrOptions)
            }
          } else {
            item.options = this.filterCiAttrOptions[val]
          }
          item.value = item.operator === 'in' ? [] : ''
        } else if (['select', 'multiSelect'].indexOf(found.inputType) >= 0) {
          if (!this.filterCiAttrOptions[val]) {
            const { data, statusCode } = await getEnumCodesByCategoryId(1, found.referenceId)
            if (statusCode === 'OK') {
              item.options = data
              let _filterCiAttrOptions = JSON.parse(JSON.stringify(this.filterCiAttrOptions))
              _filterCiAttrOptions[val] = item.options
              this.$emit('updateFilterCiAttrOptions', _filterCiAttrOptions)
            }
          } else {
            item.options = this.filterCiAttrOptions[val]
          }
          item.value = item.operator === 'in' ? [] : ''
        } else if (['null', 'notNull'].indexOf(item.operator) >= 0) {
          item.value = null
        } else {
          item.value = ''
        }
      }
      this.$emit('input', _value)
    },
    changeOperator (val, index) {
      let _value = JSON.parse(JSON.stringify(this.value))
      let item = _value[index]
      item.operator = val
      if (
        val === 'in' &&
        ['ref', 'multiRef', 'select', 'multiSelect'].indexOf(item.inputType) >= 0 &&
        !Array.isArray(item.value)
      ) {
        item.value = []
      } else if (['null', 'notNull'].indexOf(val) >= 0) {
        item.value = null
      } else if (typeof item.value !== 'string') {
        item.value = ''
      }
      this.$emit('input', _value)
    },
    changeValue (val, index) {
      let _value = JSON.parse(JSON.stringify(this.value))
      let item = _value[index]
      item.value = val
      this.$emit('input', _value)
    },
    handleDeleteRow (i) {
      let _value = JSON.parse(JSON.stringify(this.value))
      _value.splice(i, 1)
      this.$emit('input', _value)
    },
    handleAddRow () {
      const emptyFilter = {
        name: 'guid',
        inputType: 'text',
        operator: 'in',
        value: ''
      }
      let _value = JSON.parse(JSON.stringify(this.value))
      _value.push(emptyFilter)
      this.$emit('input', _value)
    },
    renderValueInput (data, i) {
      if (['null', 'notNull'].indexOf(data.operator) >= 0) {
        return null
      } else {
        if (['ref', 'multiRef', 'select', 'multiSelect'].indexOf(data.inputType) >= 0) {
          return (
            <Select
              value={data.value}
              onInput={v => this.changeValue(v, i)}
              multiple={data.operator === 'in'}
              class="filters-modal-filter-li-input"
            >
              {['ref', 'multiRef'].indexOf(data.inputType) >= 0
                ? data.options.map(_ => (
                  <Option value={_.guid} key={_.guid}>
                    {_.code}
                  </Option>
                ))
                : data.options.map(_ => (
                  <Option value={_.codeId} key={_.codeId}>
                    {_.value}
                  </Option>
                ))}
            </Select>
          )
        } else {
          return (
            <Input
              value={data.value}
              onInput={v => this.changeValue(v, i)}
              class="filters-modal-filter-li-input"
              type="textarea"
              autosize={true}
            />
          )
        }
      }
    }
  },
  render (h) {
    return (
      <div class="filters-modal">
        {this.modalSpin && <Spin fix />}
        {this.value.map((_, i) => (
          <div class="filters-modal-filter-li">
            <Icon
              type="md-remove-circle"
              color="red"
              onClick={() => this.handleDeleteRow(i)}
              class="filters-modal-filter-li-icon"
            />
            <Select value={_.name} onInput={v => this.changeFilter(v, i)} class="filters-modal-filter-li-select title">
              {this.filterCiAttrs.map(attr => (
                <Option key={attr.ciTypeAttrId} value={attr.propertyName}>
                  {attr.name}
                </Option>
              ))}
            </Select>
            <Select
              value={_.operator}
              onInput={v => this.changeOperator(v, i)}
              class="filters-modal-filter-li-select operator"
            >
              {this.operatorList
                .concat(
                  _.inputType === 'number'
                    ? [
                      { code: 'gt', value: 'Greater' },
                      { code: 'lt', value: 'Less' }
                    ]
                    : []
                )
                .map(o => (
                  <Option key={o.code} value={o.code}>
                    {o.value}
                  </Option>
                ))}
            </Select>
            {this.renderValueInput(_, i)}
          </div>
        ))}
        <Button type="primary" long onClick={this.handleAddRow}>
          {this.$t('auto_fill_filter_modal_button')}
        </Button>
      </div>
    )
  }
}
