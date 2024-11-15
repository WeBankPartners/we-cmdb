import './edit-modal.scss'
import lodash from 'lodash'
import moment from 'moment'
import { queryCiData, getAllCITypesByLayerWithAttr } from '@/api/server.js'
// import AutoComplete from './auto-complete.vue'
import JSONConfig from './json-config.vue'
import MultiConfig from './multi-config.vue'
import CIAttrTooltip from '@/pages/components/attr-table-header-tooltip.vue'
import { isJsonArray } from './utils/assist'
const WIDTH = 300
const DATE_FORMAT = 'YYYY-MM-DD HH:mm:ss'
export default {
  data () {
    return {
      editData: [],
      noOfCopy: 1,
      filterColumns: [],
      filteredColumns: [],
      inputSearch: {},
      allCiTypesWithAttr: [],
      allCiTypesFormatByCiTypeId: {}
    }
  },
  props: {
    ascOptions: {},
    modalLoading: {
      default: false,
      type: Boolean
    },
    isEdit: {},
    title: {
      type: String
    },
    modalVisible: {
      required: true,
      type: Boolean
    },
    columns: {
      required: true,
      type: Array
    },
    tableColumns: {
      required: true,
      type: Array
    },
    data: {
      required: true,
      type: Array
    },
    guidFilters: {
      type: Object,
      default () {
        return {}
      }
    },
    guidFilterEffects: {
      type: Array,
      default () {
        return []
      }
    }
  },
  computed: {
    tableWidth () {
      const cols = this.isEdit ? this.filteredColumns : this.columns
      return WIDTH * cols.length + 100
    }
  },
  mounted () {
    this.getAllCITypes()
  },
  watch: {
    data: {
      handler (val) {
        this.editData = this.resetPassword(JSON.parse(JSON.stringify(val)))
      },
      immediate: true
    },
    columns: {
      handler (vals) {
        this.inputSearch = {}
        vals.forEach(_ => {
          if (_.component === 'Input') {
            this.inputSearch[_.inputKey] = { options: [] }
          }
        })
      },
      immediate: true
    },
    modalVisible: {
      handler (val) {
        if (val) {
          this.editData = this.resetPassword(JSON.parse(JSON.stringify(this.data)))
          if (this.isEdit && this.filterColumns.length === 0) {
            this.columns.forEach((column, index) => {
              if (index < 4) {
                this.filterColumns.push(column.name || column.title)
              }
            })
            this.filteredColumns = this.columns.filter(column =>
              this.filterColumns.find(c => column.name === c || column.title === c)
            )
          }
        }
      }
    }
  },
  methods: {
    handleInputSearch: lodash.debounce(async function (value, column, data) {
      if (value.length > 0 && column.ciTypeId) {
        // this.$set(this.inputSearch[column.inputKey], 'options', ['host01', 'host02', 'host11'].map(_ =>  _ + value))
        const res = await queryCiData({
          id: column.ciTypeId,
          queryObject: {
            filters: [{ name: column.inputKey, operator: 'contains', value: value }],
            paging: true,
            dialect: { queryMode: 'new' },
            pageable: { pageSize: 20, startIndex: 0 },
            resultColumns: [column.inputKey]
          }
        })
        let keySet = new Set()
        this.inputSearch[column.inputKey].options = []
        res.data.contents.forEach(item => {
          let val = item[column.inputKey] + ''
          if (!keySet.has(val)) {
            keySet.add(val)
            const label = this.labelMatchValue(value, val)
            this.inputSearch[column.inputKey].options.push({
              label: label,
              value: val
            })
          }
        })
        // iview autocomplete not supported delay options change
        // when we change options, it will show last search options
        // so we trigger render by changing value
        let oldVal = data[column.inputKey]
        data[column.inputKey] = oldVal + ' '
        data[column.inputKey] = oldVal
      }
    }, 800),
    labelMatchValue (value, val) {
      const patt = new RegExp(value, 'gmi')
      let execRes = Array.from(new Set(val.match(patt)))
      return val.replaceAll(execRes[0], `<span style="color:red">${execRes[0]}</span>`)
    },
    resetPassword (data) {
      let needResets = []
      this.columns.forEach(col => {
        if (col.inputType === 'password') {
          needResets.push(col.propertyName)
        }
      })
      data.forEach(d => {
        needResets.forEach(p => {
          if (!this.isEdit) {
            d[p] = null
            d['isNewAddedRow'] = true
          }
        })
        // 处理'[{guid:xxx}]'类型数据为[xxx]
        const keys = Object.keys(d)
        keys.forEach(key => {
          let tag = true
          const find = this.columns.find(col => col.key === key)
          // 普通类型无需转换
          if (find && ['text', 'multiText', 'multiInt', 'longText', 'richText', 'password'].includes(find.inputType)) {
            tag = false
          }
          // 满足'[]'类型数据
          if (tag && isJsonArray(d[key])) {
            d[key] = JSON.parse(d[key])
            d[key] = d[key].map(item => {
              if (typeof item === 'object' && item.hasOwnProperty('guid')) {
                return item.guid
              }
              return item
            })
          }
        })
      })
      return data
    },
    okHandler () {
      const copyData = JSON.parse(JSON.stringify(this.editData))
      copyData.forEach(item => {
        const keys = Object.keys(item)
        keys.forEach(key => {
          const find = this.columns.find(col => col.propertyName === key)
          if (find && find.inputType === 'autofillRule') {
          } else if (find && find.inputType !== 'object') {
            if (
              Array.isArray(item[key]) &&
              !['multiSelect', 'multiRef', 'multiText', 'multiInt', 'multiObject'].includes(find.inputType)
            ) {
              item[key] = item[key].join(',')
            }
            if (find.inputType === 'multiRef') {
              const tmp = item[key]
              if (tmp.includes('{')) {
                const res = JSON.parse(tmp)
                item[key] = res.map(r => r.guid)
              }
            }
          }
        })
      })
      this.$emit('editModalOkHandler', copyData)
    },
    cancelHandler () {
      this.$emit('closeEditModal', false)
    },
    visibleChange (flag) {
      if (!flag) {
        this.$emit('closeEditModal', flag)
        this.editData = []
        this.noOfCopy = 1
      }
    },
    copyData () {
      const columns = this.columns.reduce((arr, x) => {
        if (
          x.key &&
          (x.autofillable === 'no' || (x.autofillable === 'yes' && x.autoFillType === 'suggest')) &&
          x.editable === 'yes'
        ) {
          arr.push(x.key)
        }
        return arr
      }, [])
      const copyRows = this.editData.map(row => {
        let obj = {
          guid: '',
          state: '',
          isNewAddedRow: true
        }
        columns.forEach(x => {
          obj[x] = row[x]
        })
        return obj
      })
      this.editData = []
      for (let i = 0; i < this.noOfCopy; i++) {
        this.editData = this.editData.concat(JSON.parse(JSON.stringify(copyRows)))
        if (this.editData.length > 20) break
      }
    },
    removeAddData (index) {
      this.editData.splice(index, 1)
    },
    isGroupEditDisabled (attr, item) {
      let attrGroupEditDisabled = false
      if (attr.editGroupControl === 'yes') {
        if (attr.editGroupValues.length > 0) {
          let groups = JSON.parse(attr.editGroupValues)
          for (let idx = 0; idx < groups.length; idx++) {
            let group = groups[idx]
            if (attrGroupEditDisabled) {
              break
            }
            const findAttr = this.tableColumns.find(el => {
              if (el.propertyName === group.key) {
                return true
              }
              return false
            })
            if (findAttr && group.value.length > 0) {
              if (!item[findAttr.propertyName]) {
                // 控制字段未赋值，禁用当前字段
                attrGroupEditDisabled = true
              } else if (Array.isArray(item[findAttr.propertyName])) {
                let attrValues = item[findAttr.propertyName]
                let intersect = attrValues.filter(v => {
                  return group.value.indexOf(v) > -1
                })
                // 控制字段是数组且与设置的数据没有交集，禁用当前字段
                if (intersect.length === 0) {
                  attrGroupEditDisabled = true
                }
              } else {
                // 控制字段是单值且不在分组范围，应当禁用当前字段
                if (group.value.indexOf(item[findAttr.propertyName]) < 0) {
                  attrGroupEditDisabled = true
                }
              }
            }
          }
        }
      }
      let attrEditDisabled = attr.editable === 'no' || (attr.autofillable === 'yes' && attr.autoFillType === 'forced')
      return attrEditDisabled || attrGroupEditDisabled
    },
    // 获取所有CI数据，回显过滤规则、填充规则用到
    async getAllCITypes () {
      const { statusCode, data } = await getAllCITypesByLayerWithAttr(['notCreated', 'created', 'dirty'])
      if (statusCode === 'OK') {
        // 初始化自动填充数据
        let allCiTypesWithAttr = []
        let allCiTypesFormatByCiTypeId = {}
        data.forEach(layer => {
          layer.ciTypes &&
            layer.ciTypes.forEach(_ => {
              allCiTypesWithAttr.push(_)
              allCiTypesFormatByCiTypeId[_.ciTypeId] = _
            })
        })
        this.allCiTypesWithAttr = allCiTypesWithAttr
        this.allCiTypesFormatByCiTypeId = allCiTypesFormatByCiTypeId
      }
    },
    renderDataRows () {
      let handleInputSearch = this.handleInputSearch
      let setValueHandler = (v, col, row) => {
        let attrsWillReset = []
        if (['select', 'ref', 'extRef', 'multiSelect', 'multiRef'].indexOf(col.inputType) > -1) {
          this.columns.forEach(_ => {
            if (_.uiFormOrder > col.uiFormOrder && _.referenceFilter) {
              if (['multiSelect', 'multiRef'].indexOf(_.inputType) >= 0) {
                attrsWillReset.push({
                  propertyName: _.propertyName,
                  value: []
                })
              } else if (['select', 'ref', 'extRef'].indexOf(_.inputType) >= 0) {
                attrsWillReset.push({
                  propertyName: _.propertyName,
                  value: ''
                })
              }
            }
          })
        } else if (['datetime'].indexOf(col.inputType) >= 0) {
          v = moment(v).format(DATE_FORMAT)
        } else if (['autofillRule'].includes(col.inputType)) {
          if (v !== '') {
            attrsWillReset.push({
              propertyName: col.inputKey,
              value: JSON.stringify(JSON.parse(v))
            })
          }
        }
        row[col.inputKey] = v
        attrsWillReset.forEach(attr => {
          row[attr.propertyName] = attr.value
        })
      }
      const cols = this.isEdit ? this.filteredColumns : this.columns
      const originColumns = this.columns
      const formatValue = (column, value) => {
        // for edit 多选数据会在保存时转为','拼接
        if (column.component === 'WeCMDBSelect' && column.isMultiple) {
          if (value) {
            return Array.isArray(value) ? value : value.split(',')
          } else {
            return null
          }
        } else {
          return value
        }
      }
      return (
        <div style={`width: ${this.tableWidth}px`}>
          {this.editData.map((d, index) => {
            return (
              <div key={index} style={`width: ${this.tableWidth}px`}>
                {cols.map((column, i) => {
                  if (column.component === 'WeCMDBCIPassword') {
                    return (
                      <div key={i} style={`width:${WIDTH}px;display:inline-block;padding:5px`}>
                        <column.component formData={column} panalData={d} disabled={false} />
                      </div>
                    )
                  } else if (column.component === 'CMDBPermissionFilters') {
                    // eslint-disable-next-line no-unused-vars
                    let value = d[column.propertyName] || []
                    value = Array.isArray(value) ? value : JSON.parse(value)
                    return (
                      <div key={i} style={`width:${WIDTH}px;display:inline-block;padding:5px`}>
                        <column.component
                          allCiTypes={column.allCiTypes}
                          isFilterAttr={true}
                          displayAttrType={column.displayAttrType}
                          disabled={this.isGroupEditDisabled(column, d)}
                          rootCis={column.rootCis}
                          rootCiTypeId={column.ciTypeId}
                          value={value}
                          onInput={v => {
                            setValueHandler(v, column, d)
                          }}
                        />
                      </div>
                    )
                  } else if (column.component === 'WeCMDBRadioRroup') {
                    return (
                      <div key={i} style={`width:${WIDTH}px;display:inline-block;padding:5px`}>
                        <column.component
                          value={d[column.inputKey] || column.defaultValue}
                          disabled={this.isGroupEditDisabled(column, d)}
                          options={column.optionKey ? this.ascOptions[column.optionKey] : column.options}
                          onInput={v => {
                            setValueHandler(v, column, d)
                          }}
                        />
                      </div>
                    )
                  } else if (column.component === 'Input' && column.inputType === 'multiText') {
                    const props = {
                      ...column,
                      disabled: this.isGroupEditDisabled(column, d),
                      data: JSON.parse(JSON.stringify(d[column['inputKey']])),
                      type: 'text'
                    }
                    const fun = {
                      input: function (v) {
                        d[column.inputKey] = v
                      }
                    }
                    const data = {
                      props,
                      on: fun
                    }
                    return (
                      <div style={`width:${WIDTH}px;display:inline-block;padding:5px`}>
                        <MultiConfig {...data}></MultiConfig>
                      </div>
                    )
                  } else if (column.component === 'Input' && column.inputType === 'multiInt') {
                    const props = {
                      ...column,
                      disabled: this.isGroupEditDisabled(column, d),
                      data: JSON.parse(JSON.stringify(d[column['inputKey']])),
                      type: 'number'
                    }
                    const fun = {
                      input: function (v) {
                        d[column.inputKey] = v.trim()
                      }
                    }
                    const data = {
                      props,
                      on: fun
                    }
                    return (
                      <div style={`width:${WIDTH}px;display:inline-block;padding:5px`}>
                        <MultiConfig {...data}></MultiConfig>
                      </div>
                    )
                  } else if (column.component === 'Input' && column.inputType === 'multiObject') {
                    const props = {
                      ...column,
                      disabled: this.isGroupEditDisabled(column, d),
                      data: JSON.parse(JSON.stringify(d[column['inputKey']])),
                      type: 'json'
                    }
                    const fun = {
                      input: function (v) {
                        d[column.inputKey] = v
                      }
                    }
                    const data = {
                      props,
                      on: fun
                    }
                    return (
                      <div style={`width:${WIDTH}px;display:inline-block;padding:5px`}>
                        <MultiConfig {...data}></MultiConfig>
                      </div>
                    )
                  } else if (column.component === 'Input' && column.inputType === 'autofillRule') {
                    let dataTmp = JSON.stringify(d[column.inputKey])
                    // if (d[column.inputKey].length === 1) {
                    //   dataTmp = d[column.inputKey][0].value
                    // }
                    const props = {
                      ...column,
                      data: dataTmp,
                      value: dataTmp
                    }
                    const fun = {
                      input: function (v) {
                        setValueHandler(v.trim(), column, d)
                      }
                    }
                    const data = {
                      props,
                      on: fun
                    }
                    return (
                      <div key={i} style={`width:${WIDTH}px;display:inline-block;padding:5px`}>
                        <Input style="width:80%" {...data}></Input>
                      </div>
                    )
                  } else if (column.component === 'Input' && column.inputType !== 'object') {
                    const props = {
                      ...column,
                      disabled: this.isGroupEditDisabled(column, d),
                      data: this.inputSearch[column.inputKey].options,
                      value: d[column.inputKey]
                    }
                    const fun = {
                      'on-search': function (v) {
                        handleInputSearch(v, column, d)
                      },
                      'on-select': function (v) {
                        setValueHandler(v, column, d)
                      },
                      input: function (v) {
                        setValueHandler(v.trim(), column, d)
                      }
                    }
                    const data = {
                      props,
                      on: fun
                    }
                    const resetAutofillValue = (v, column) => {
                      setValueHandler('suggest#', column, d)
                    }
                    // <AutoComplete {...data}></AutoComplete>
                    return (
                      <div key={i} style={`width:${WIDTH}px;display:inline-block;padding:5px`}>
                        <Input style="width:80%" {...data}></Input>
                        {column.autofillable === 'yes' && column.autoFillType === 'suggest' && (
                          <Button onClick={v => resetAutofillValue(v, column)} icon="md-checkmark"></Button>
                        )}
                      </div>
                    )
                  } else if (column.component === 'Input' && column.inputType === 'object') {
                    const props = {
                      ...column,
                      disabled: this.isGroupEditDisabled(column, d),
                      jsonData: JSON.parse(JSON.stringify(d[column['inputKey']]) || '{}')
                    }
                    const fun = {
                      input: function (v) {
                        setValueHandler(v, column, d)
                      }
                    }
                    const data = {
                      props,
                      on: fun
                    }
                    return (
                      <div style={`width:${WIDTH}px;display:inline-block;padding:5px`}>
                        <JSONConfig {...data}></JSONConfig>
                      </div>
                    )
                  } else {
                    const props =
                      column.component === 'WeCMDBSelect'
                        ? {
                          ...column,
                          value: column.isRefreshable
                            ? column.inputType === 'multiSelect'
                              ? []
                              : ''
                            : column.inputType === 'multiSelect'
                              ? Array.isArray(d[column.inputKey])
                                ? d[column.inputKey]
                                : ''
                              : formatValue(column, d[column.inputKey]),
                          disabled: this.isGroupEditDisabled(column, d),
                          filterParams: column.referenceFilter
                            ? {
                              attrId: column.ciTypeAttrId,
                              params: d
                            }
                            : null,
                          isMultiple: column.isMultiple,
                          options: column.options,
                          enumId: column.referenceId ? column.referenceId : null
                        }
                        : {
                          ...column,
                          value: column.isRefreshable
                            ? ''
                            : column.inputType === 'multiRef'
                              ? Array.isArray(d[column.inputKey])
                                ? d[column.inputKey]
                                : []
                              : d[column.inputKey] || '',
                          disabled: this.isGroupEditDisabled(column, d),
                          filterParams: column.referenceFilter
                            ? {
                              attrId: column.ciTypeAttrId,
                              params: d
                            }
                            : null,
                          ciTypeAttrId: column.ciTypeAttrId,
                          ciType: column.component === 'WeCMDBRefSelect' ? column.ciType : null,
                          guidFilters:
                              column.component === 'WeCMDBRefSelect' ? this.guidFilters[column.ciType.id] : null,
                          guidFilterEnabled:
                              column.component === 'WeCMDBRefSelect'
                                ? this.guidFilterEffects.indexOf(column.propertyName) >= 0
                                : false,
                          ...column,
                          editable: column.editable === 'yes',
                          originColumns: originColumns,
                          type: column.component === 'DatePicker' ? 'datetime' : column.type,
                          guid: d.guid ? d.guid : '123'
                        }
                    const fun = {
                      input: v => {
                        setValueHandler(v, column, d)
                      },
                      change: v => {
                        if (column.onChange) {
                          this.$emit('getGroupList', v)
                        }
                      }
                    }
                    const data = {
                      props,
                      on: fun
                    }
                    return (
                      <div key={i} style={`width:${WIDTH}px;display:inline-block;padding:5px`}>
                        <div class={!column.uiNullable !== 'no' ? 'is-nullable' : ''}>
                          <column.component {...data} />
                        </div>
                      </div>
                    )
                  }
                })}
                {!this.isEdit && (
                  <span
                    onClick={() => this.removeAddData(index)}
                    style={`border-radius: 4px;vertical-align: middle;color:red;font-size:20px;margin-left:8px;cursor:pointer;border: 1px solid red`}
                  >
                    <Icon type="ios-trash-outline" />
                  </span>
                )}
              </div>
            )
          })}
        </div>
      )
    },
    checkboxChangeHandler (v) {
      this.filteredColumns = []
      this.filteredColumns = this.columns.filter(column => v.find(c => column.name === c || column.title === c))
    },
    renderCheckbox () {
      return (
        <div style={'padding:10px'}>
          <CheckboxGroup
            on-on-change={this.checkboxChangeHandler}
            onInput={v => {
              this.filterColumns = v
            }}
            value={this.filterColumns}
          >
            {this.columns.map((column, index) => {
              return (
                <Checkbox label={column.name || column.title}>
                  <span>
                    <span style="color:red; font-weight: 600">{column.uiNullable !== 'no' ? '' : '*'}</span>
                    <span>{column.name || column.title}</span>
                  </span>
                </Checkbox>
              )
            })}
          </CheckboxGroup>
        </div>
      )
    }
  },
  render (h) {
    const cols = this.isEdit ? this.filteredColumns : this.columns
    return (
      <Modal
        mask-closable={false}
        title={this.title}
        width={90}
        value={this.modalVisible}
        footer-hide={true}
        on-on-visible-change={this.visibleChange}
      >
        {!this.isEdit && (
          <div style="margin-bottom: 20px">
            <span style="margin-right: 10px">{this.$t('input_set_of_copy')}</span>
            <InputNumber
              size="small"
              style="margin-right: 10px"
              min={1}
              step={1}
              value={this.noOfCopy}
              onInput={v => (this.noOfCopy = v)}
            />
            <span style="margin-right: 30px">{this.$t('set')}</span>
            <Button onClick={this.copyData} type="primary" size="small">
              {this.$t('confirm')}
            </Button>
          </div>
        )}
        {this.isEdit && this.renderCheckbox()}
        <div style="overflow: auto">
          {this.modalVisible && (
            <div style={`width: ${this.tableWidth}px`}>
              {cols.map((column, index) => {
                return (
                  <div
                    style={`width:${WIDTH}px;display:inline-block;padding:5px;height: 30px;font-weight:600;background-color: #e8eaec`}
                    key={column.ciTypeAttrId || index}
                  >
                    <span style="color:red">{column.uiNullable !== 'no' ? '' : '*'}</span>
                    {column.name || column.title}
                    <CIAttrTooltip
                      style="display:inline-block;"
                      attr={column}
                      allCiTypesWithAttr={this.allCiTypesWithAttr}
                      allCiTypesFormatByCiTypeId={this.allCiTypesFormatByCiTypeId}
                    />
                  </div>
                )
              })}
              {!this.isEdit && (
                <div
                  style={`width:80px;display:inline-block;padding:5px;height: 30px;font-weight:600;background-color: #e8eaec`}
                >
                  {this.$t('delete')}
                </div>
              )}
            </div>
          )}
          {this.modalVisible && this.renderDataRows()}
        </div>
        <div style="margin-top:20px;height: 30px">
          <Button
            style="float: right;margin-right: 20px"
            loading={this.modalLoading}
            onClick={this.okHandler}
            type="primary"
          >
            {this.$t('save')}
          </Button>
          <Button style="float: right;margin-right: 20px" onClick={this.cancelHandler}>
            {this.$t('cancel')}
          </Button>
        </div>
      </Modal>
    )
  }
}
