import '../table.scss'
import moment from 'moment'
import lodash, { cloneDeep, hasIn, isEmpty, filter, map } from 'lodash'
import { debounce } from '@/const/util.js'
import EditModal from './edit-modal.js'
import { dataToCsv, download } from './export-csv.js'
import { createPopper } from '@popperjs/core'
import {
  queryCiData,
  getCiTypeAttributes,
  queryPassword,
  getExtRefDetails,
  getCiTypeNameMap,
  searchSensitiveData
} from '@/api/server'
const DEFAULT_FILTER_NUMBER = 5
const MIN_WIDTH = 200
const DATE_FORMAT = 'YYYY-MM-DD HH:mm:ss'

export default {
  name: 'CMDBTable',
  props: {
    ciTypeId: { default: () => '', require: true },
    tableColumns: { default: () => [], require: true },
    tableData: { default: () => [] },
    showCheckbox: { default: () => true },
    highlightRow: { default: () => false },
    isSortable: { default: () => true },
    filtersHidden: { default: () => false },
    tableOuterActions: { default: () => [] },
    tableInnerActions: { default: () => [] },
    pagination: { type: Object },
    ascOptions: { type: Object },
    isRefreshable: { default: () => false },
    isColumnsFilterOn: { default: () => true },
    guidFilters: {
      type: Object,
      default () {
        return {}
      }
    },
    guidFilterEffects: {
      type: Object,
      default () {
        return {}
      }
    }
  },
  data () {
    return {
      form: {},
      selectedRows: [],
      data: [],
      isShowHiddenFilters: false,
      columns: [],
      modalVisible: false,
      titles: {
        add: this.$t('new'),
        edit: this.$t('edit'),
        copy: this.$t('copyToNew')
      },
      modalTitle: '',
      modalLoading: false,
      tableLoading: false,
      tipContent: '',
      randomId: '',
      timer: null,
      currentOperateType: '',
      tableDetailInfo: {
        isShow: false,
        type: '',
        title: '',
        info: []
      },
      isShowFilter: false, // 控制列过滤功能
      diffVariableKeyName: '', // 所选差异化值所在行唯一名称
      diffVariableColKey: '', // 差异化值对应的key
      remarkedKeys: [], // 差异化值中标记出的值
      oriDataMap: {},
      loadFilters: true // 解决重置未清空数据问题
    }
  },
  component: {
    EditModal
  },
  async mounted () {
    const { data, statusCode } = await getCiTypeNameMap()
    if (statusCode === 'OK') {
      this.oriDataMap = data
    }
    this.formatTableData()
    let len = 32
    let chars = 'ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz'
    let maxPos = chars.length
    let randomId = ''
    for (let i = 0; i < len; i++) {
      randomId += chars.charAt(Math.floor(Math.random() * maxPos))
    }
    this.randomId = randomId
  },
  watch: {
    tableData (val) {
      this.formatTableData()
    },
    tableColumns: {
      handler (val, oldval) {
        // 勿删！！
        // 编辑列显示时会触发清空搜索条件，未想到用处，此处暂时屏蔽
        // this.tableColumns.forEach(_ => {
        //   if (_.children) {
        //     _.children.forEach(j => {
        //       if (!j.isNotFilterable) {
        //         this.$set(this.form, j.inputKey, '')
        //       }
        //     })
        //   } else {
        //     if (!_.isNotFilterable) {
        //       this.$set(this.form, _.inputKey, '')
        //     }
        //   }
        // })
        this.calColumn()
      },
      immediate: true,
      deep: true
    },
    ascOptions: {
      handler (val, oldval) {
        this.calColumn()
      },
      deep: true,
      immediate: true
    },
    showCheckbox: {
      handler: function (val) {
        if (val && !this.highlightRow) {
          const haveSelection = this.columns.some(c => c.type === 'selection')
          if (!haveSelection) {
            this.columns.unshift({
              type: 'selection',
              width: 60,
              align: 'center',
              fixed: 'left'
            })
          }
        }
      },
      deep: true,
      immediate: true
    }
  },
  beforeDestroy () {
    this.$emit('getSelectedRows', [], false)
  },
  computed: {},
  methods: {
    formatData (row, key) {
      const vari = row[key].split('\u0001=\u0001')
      const keys = vari[0].split(',\u0001')
      const values = vari[1].split(',\u0001')
      let res = []
      for (let i = 0; i < keys.length; i++) {
        res.push({
          key: (keys[i] || '').replace('\u0001', ''),
          value: (values[i] || '').replace('\u0001', '')
        })
      }
      res = res.sort((first, second) => {
        const firstKey = first.key.toLocaleUpperCase()
        const secondKey = second.key.toLocaleUpperCase()
        if (firstKey < secondKey) {
          return -1
        } else if (firstKey > secondKey) {
          return 1
        } else {
          return 0
        }
      })
      return res
    },
    pushNewAddedRowToSelections (data) {
      if (this.selectedRows.length === 0) {
        this.selectedRows.push(data)
      }
    },
    formatTableData () {
      this.selectedRows = []
      this.data = this.tableData.map((_, index) => {
        const keys = Object.keys(_)
        keys.forEach(key => {
          if (!['nextOperations'].includes(key) && Array.isArray(_[key])) {
            _[key] = JSON.stringify(_[key])
          }
        })
        let result = {
          ..._,
          isRowEditable: _.forceEdit ? _.isRowEditable : _.isRowEditable && index === 0 ? _.isRowEditable : false,
          weTableForm: { ..._ }
        }
        if (_.guid && _.r_guid && _.r_guid !== _.guid) {
          result.nextOperations = []
          result._disabled = true
        }
        return result
      })
      this.data.forEach(_ => {
        for (let i in _['weTableForm']) {
          const found = this.tableColumns.find(q => q.inputKey === i)
          if (found && found.inputType === 'object') {
            // normailize object display
            if (_['weTableForm'][i]) {
              _['weTableForm'][i] = JSON.stringify(_['weTableForm'][i], null, 4)
            }
          } else if (
            typeof _['weTableForm'][i] === 'object' &&
            _['weTableForm'][i] !== null &&
            !Array.isArray(_['weTableForm'][i]) &&
            i !== 'weTableForm'
          ) {
            _[i] = _['weTableForm'][i].codeId || _['weTableForm'][i].guid
            _['weTableForm'][i] = _['weTableForm'][i].value || _['weTableForm'][i].key_name
          } else {
            if (Array.isArray(_['weTableForm'][i]) && i !== 'nextOperations') {
              if (found && found.inputType === 'multiSelect') {
                if (isObjArray(_['weTableForm'][i])) {
                  _[i] = _['weTableForm'][i].map(j => j.codeId)
                } else {
                  _[i] = _['weTableForm'][i]
                }
              }
              if (found && found.inputType === 'multiRef') {
                _[i] = _['weTableForm'][i].map(j => j.guid)
              }
            } else if (isArrayString(_['weTableForm'][i]) && i !== 'nextOperations') {
              if (found && found.inputType === 'multiSelect') {
                _['weTableForm'][i] = JSON.parse(_['weTableForm'][i])
                if (isObjArray(_['weTableForm'][i])) {
                  _[i] = _['weTableForm'][i].map(j => j.codeId)
                } else {
                  _[i] = _['weTableForm'][i]
                }
              }
            }
          }
          if (this.isRefreshable) {
            if (found && found.isRefreshable) {
              _[i] = null
            }
          }
        }
        if (hasIn(_, '_checked')) {
          // 这里用于每次都记录已经点击的列，用于下次刷新时不丢失状态
          const selectItem = cloneDeep(_)
          if (_['_checked'] === true) {
            const filterSelect = this.tableColumns.filter(item => item.component === 'WeCMDBSelect')
            filterSelect.forEach(item => {
                const find = item.options.find(o => o.label === selectItem[item.key])
                if (find) {
                  selectItem[item.key] = find.value
                }
            })
            this.selectedRows.push(selectItem)
          }
          delete selectItem._checked
        }
      })

      function isArrayString (str) {
        try {
          const array = JSON.parse(str)
          return Array.isArray(array)
        } catch (error) {
          return false
        }
      }
      function isObjArray (arr) {
        for (let i of arr) {
          if (typeof i === 'object' && i !== null) {
            return true
          } else {
            return false
          }
        }
      }
      if (!isEmpty(this.selectedRows)) {
        // 用于非第一次刷新时，更新选中列
        this.$emit('getSelectedRows', this.selectedRows, false)
      }
    },
    filterMgmt () {
      const generateFilters = (type, i) => {
        switch (type) {
          case 'text':
          case 'textArea':
            filters.push({
              name: i,
              operator: 'contains',
              value: this.form[i]
            })
            break
          case 'select':
          case 'ref':
            filters.push({
              name: i,
              operator: 'eq',
              value: this.form[i]
            })
            break
          case 'datetime':
            if (this.form[i][0] !== '' && this.form[i][1] !== '') {
              filters.push({
                name: i,
                operator: 'gt',
                value: moment(this.form[i][0]).format(DATE_FORMAT)
              })
              filters.push({
                name: i,
                operator: 'lt',
                value: moment(this.form[i][1]).format(DATE_FORMAT)
              })
            }
            break

          case 'multiSelect':
          case 'multiRef':
            if (Array.isArray(this.form[i]) && this.form[i].length) {
              filters.push({
                name: i,
                operator: 'in',
                value: this.form[i]
              })
            }
            break
          case 'number':
            filters.push({
              name: i,
              operator: 'eq',
              value: +this.form[i]
            })
            break

          default:
            filters.push({
              name: i,
              operator: 'contains',
              value: this.form[i]
            })
            break
        }
      }

      let filters = []
      for (let i in this.form) {
        if (!!this.form[i] && this.form[i] !== '' && this.form[i] !== 0) {
          this.tableColumns
            .filter(_ => _.uiSearchOrder || _.children)
            .forEach(_ => {
              if (_.children) {
                _.children.forEach(j => {
                  if (i === j.inputKey) {
                    generateFilters(j.inputType, i)
                  }
                })
              } else {
                if (i === _.inputKey) {
                  generateFilters(_.inputType, i)
                }
              }
            })
        }
      }
      return filters
    },
    handleSubmit: debounce(function (ref) {
      const filters = this.filterMgmt()
      this.$emit('handleSubmit', filters)
    }, 1000),
    searchHandler () {
      this.pagination.currentPage = 1
      this.handleSubmit('form')
    },
    reset (ref) {
      this.loadFilters = false
      this.tableColumns.forEach(_ => {
        if (_.children) {
          _.children.forEach(j => {
            if (!j.isNotFilterable) {
              this.form[j.inputKey] = ''
            }
          })
        } else {
          if (!_.isNotFilterable) {
            this.form[_.inputKey] = ''
          }
        }
      })
      this.$nextTick(() => {
        this.calColumn()
        this.handleSubmit('form')
        this.$emit('resetSearchForm')
        this.loadFilters = true
      })
    },
    getTableOuterActions () {
      if (this.tableOuterActions) {
        const lang = localStorage.getItem('lang')
        return this.tableOuterActions.map(_ => {
          if (_.operationFormType === 'import_form') {
            return (
              <div style="margin-left:100px; width:200px;display:inline-block;">
                <Upload
                  action=""
                  beforeUpload={file => {
                    this.$emit('actionFun', _, this.selectedRows, this.ciTypeId, file)
                  }}
                >
                  <Button class="btn-upload">
                    <img style='margin-right: 3px' src={require("@/styles/icon/UploadOutlined.png")} class="upload-icon" />
                    {lang === 'en-US' ? _.operation_en : _.operation}
                  </Button>
                  {/* <Button icon="ios-cloud-upload-outline">{lang === 'en-US' ? _.operation_en : _.operation}</Button> */}
                </Upload>
              </div>
            )
          }
          if (_.operationFormType === 'import_ci_form') {
            return (
              <div style="margin-left:8px; width:200px;display:inline-block;">
                <Upload
                  action=""
                  accept=".csv"
                  beforeUpload={file => {
                    this.$emit('actionFun', _, this.selectedRows, this.ciTypeId, file)
                  }}
                >
                  <Button class="btn-upload">
                    <img style='margin-right: 3px' src={require("@/styles/icon/UploadOutlined.png")} class="upload-icon" />
                    {lang === 'en-US' ? _.operation_en : _.operation}
                  </Button>
                  {/* <Button icon="ios-cloud-upload-outline">{lang === 'en-US' ? _.operation_en : _.operation}</Button> */}
                </Upload>
              </div>
            )
          }

          if (_.operationFormType === 'export_form' || _.actionType === 'export') {
            return (
              <Button
                class="btn-upload"
                style="margin-right: 10px"
                onClick={() => {
                  const filters = this.filterMgmt()
                  this.currentOperateType = _.operation_en
                  this.$emit('actionFun', _, this.selectedRows, this.columns, filters)
                }}
              >
                <img style='margin-right: 3px' src={require("@/styles/icon/DownloadOutlined.png")} class="upload-icon" />
                {lang === 'en-US' ? _.operation_en : _.operation}
              </Button>
            )
          }

          return (
            <Button
              style="margin-right: 10px"
              {..._}
              onClick={() => {
                const filters = this.filterMgmt()
                this.currentOperateType = _.operation_en
                this.$emit('actionFun', _, this.selectedRows, this.columns, filters)
              }}
            >
              {lang === 'en-US' ? _.operation_en : _.operation}
            </Button>
          )
        })
      }
    },
    renderFormItem (item, index = 0) {
      if (item.isNotFilterable) return

      const filterParamsForRefSelect = item => {
        const filters = this.filterMgmt()
        let params = {}
        filters.forEach(f => {
          params[f.name] = f.value
        })
        return params
      }
      const data = {
        props: {
          ...item,
          editable: item.editable === 'yes',
          enumId: item.referenceId ? item.referenceId : null,
          filterParams: {
            attrId: item.ciTypeAttrId || '', // 搜索处赋值
            params: filterParamsForRefSelect()
          }
        },
        style: {
          width: '100%'
        }
      }

      let renders = item => {
        switch (item.component) {
          case 'WeCMDBSelect':
            return (
              <item.component
                on-on-enter={() => this.handleSubmit('form')}
                onInput={v => {
                  this.form[item.inputKey] = v
                  this.handleSubmit('form')
                }}
                onChange={v => item.onChange && this.$emit(item.onChange, v)}
                value={this.form[item.inputKey]}
                filterable
                clearable
                {...data}
                options={item.optionKey ? this.ascOptions[item.optionKey] : item.options}
              />
            )
          case 'WeCMDBRefSelect':
            return (
              <item.component
                on-on-enter={() => this.handleSubmit('form')}
                onInput={v => {
                  this.form[item.inputKey] = v
                  this.handleSubmit('form')
                }}
                value={this.form[item.inputKey]}
                {...data}
              />
            )
          default:
            return (
              <item.component
                on-on-enter={() => this.handleSubmit('form')}
                value={this.form[item.inputKey]}
                clearable={true}
                onInput={v => {
                  this.form[item.inputKey] = v
                  this.handleSubmit('form')
                }}
                isReadOnly={item.component === 'CMDBPermissionFilters'}
                {...data}
              />
            )
        }
      }
      return (
        <Col
          span={item.span || 3}
          class={
            index < DEFAULT_FILTER_NUMBER ? '' : this.isShowHiddenFilters ? 'hidden-filters-show' : 'hidden-filters'
          }
        >
          <FormItem
            // label={lodash.hasIn(item, 'uiFormLabelShow') && item.uiFormLabelShow === false || true ? '' : item.title}
            label=""
            prop={item.inputKey}
            key={item.inputKey}
          >
            {renders(item)}
          </FormItem>
        </Col>
      )
    },
    getFormFilters () {
      let compare = (a, b) => {
        if (a.uiSearchOrder < b.uiSearchOrder) {
          return -1
        }
        if (a.uiSearchOrder > b.uiSearchOrder) {
          return 1
        }
        return 0
      }
      return (
        <Form ref="form" label-position="top" inline>
          <Row>
            {this.tableColumns
              .filter(_ => (!!_.children || !!_.uiSearchOrder) && _.inputType !== 'password' && _.sensitive !== 'yes')
              .sort(compare)
              .map((_, index) => {
                if (_.children) {
                  return (
                    <Row>
                      <Col span={3}>
                        <strong>{_.title}</strong>
                      </Col>
                      <Col span={21}>
                        {_.children
                          .filter(_ => !!_.uiSearchOrder)
                          .sort(compare)
                          .map(j => {
                            let o = { ...j }
                            if (j.optionKey) {
                              o = {
                                ...j,
                                optionKey: null,
                                options: this.ascOptions[j.optionKey]
                              }
                            }
                            return this.renderFormItem(o)
                          })}
                      </Col>
                    </Row>
                  )
                }
                let obj = { ..._ }
                if (_.optionKey) {
                  obj = {
                    ..._,
                    optionKey: null,
                    options: this.ascOptions[_.optionKey]
                  }
                }
                return this.renderFormItem(obj, index)
              })}
            <Col span={6}>
              <div style="display: flex;">
                {this.tableColumns.filter(_ => !!_.uiSearchOrder).sort(compare).length > DEFAULT_FILTER_NUMBER &&
                  (!this.isShowHiddenFilters ? (
                    <FormItem>
                      {/* {this.tableColumns.every(
                        item => lodash.hasIn(item, 'uiFormLabelShow') && item.uiFormLabelShow === false
                      ) ? null : (
                          <div slot="label" style="visibility: hidden;">
                            <span>Placeholder</span>
                          </div>
                        )} */}
                      <Button
                        type="info"
                        ghost
                        shape="circle"
                        icon="ios-arrow-down"
                        onClick={() => {
                          this.isShowHiddenFilters = true
                        }}
                      >
                        {this.$t('more_filter')}
                      </Button>
                    </FormItem>
                  ) : (
                    <FormItem>
                      <Button
                        type="info"
                        ghost
                        shape="circle"
                        icon="ios-arrow-up"
                        onClick={() => {
                          this.isShowHiddenFilters = false
                        }}
                      >
                        {this.$t('less_filter')}
                      </Button>
                    </FormItem>
                  ))}

                <FormItem>
                  <Button type="primary" icon="ios-search" onClick={() => this.searchHandler()}>
                    {this.$t('search')}
                  </Button>
                </FormItem>
                <FormItem>
                  <Button icon="md-refresh" onClick={() => this.reset('form')}>
                    {this.$t('reset')}
                  </Button>
                </FormItem>
              </div>
            </Col>
          </Row>
        </Form>
      )
    },
    onCheckboxSelect (selection) {
      // 将WeCMDBSelect枚举类型的数据值从label转换成value以便选择框正确回显
      const filterSelect = this.tableColumns.filter(item => item.component === 'WeCMDBSelect')
      filterSelect.forEach(item => {
        selection.forEach(d => {
          const find = item.options.find(o => o.label === d[item.key])
          if (find) {
            d[item.key] = find.value
          }
        })
      })
      this.selectedRows = selection
      this.$emit('getSelectedRows', selection, false)
    },
    onRadioSelect (current, old) {
      this.$emit('getSelectedRows', [current], false)
    },
    sortHandler (sort) {
      this.$emit('sortHandler', sort)
    },
    export (params) {
      // remove checkbox column
      params.columns = this.columns.filter(_ => {
        if (_.title || _.key) {
          return _
        }
      })
      params.quoted = true
      // normalize filename
      if (params.filename) {
        if (params.filename.indexOf('.csv') === -1) {
          params.filename += '.csv'
        }
      } else {
        params.filename = 'table.csv'
      }
      // process data
      let columns = []
      let datas = []
      if (params.columns && params.data) {
        columns = params.columns
        datas = params.data
      } else {
        columns = this.$refs.table.allColumns
        if (!('original' in params)) params.original = true
        datas = params.original ? this.$refs.table.data : this.$refs.table.rebuildData
      }
      // noheader
      let noHeader = false
      if ('noHeader' in params) noHeader = params.noHeader
      // array to csv text
      const data = dataToCsv(columns, datas, params, noHeader)
      // callback or download
      if (params.callback) params.callback(data)
      else download(params.filename, data)
    },
    onColResize (newWidth, oldWidth, column, event) {
      let cols = [...this.columns]
      cols.find(x => x.key === column.key).width = newWidth
      this.columns = cols
    },
    calColumn () {
      let compare = (a, b) => {
        if (a.uiFormOrder < b.uiFormOrder) {
          return -1
        }
        if (a.uiFormOrder > b.uiFormOrder) {
          return 1
        }
        return 0
      }
      const columns = this.tableColumns
        .filter(_ => (_.displayByDefault === 'yes' && _.uiFormOrder > 0) || _.children)
        .sort(compare)
      const tableWidth = this.$refs.table ? this.$refs.table.$el.clientWidth : 1000 // 获取table宽度，默认值1000
      const colLength = columns.length // 获取传入展示的column长度
      this.colWidth = Math.floor(tableWidth / colLength)
      this.columns = columns.map((_, idx) => {
        // const isLast = colLength - 1 === idx
        if (_.children) {
          const children = _.children.filter(_ => _.displayByDefault === 'yes' || _.uiFormOrder).sort(compare)
          return {
            ..._,
            children: children.map((j, index) => {
              // const isChildLast = isLast && children.length - 1 === index
              return this.renderCol(j, true)
            })
          }
        } else {
          return this.renderCol(_, false)
        }
      })
      if (this.showCheckbox && !this.highlightRow) {
        const haveSelection = this.columns.some(c => c.type === 'selection')
        if (!haveSelection) {
          this.columns.unshift({
            type: 'selection',
            width: 60,
            align: 'center',
            fixed: 'left'
          })
        }
      }
      this.tableInnerActions &&
        this.columns.push({
          title: this.$t('actions'),
          fixed: 'right',
          key: 'actions',
          maxWidth: 500,
          minWidth: 200,
          render: (h, params) => {
            return (
              <div>
                {this.tableInnerActions.map(_ => {
                  return (
                    <Button
                      style="margin-right: 10px"
                      {..._}
                      size="small"
                      onClick={() => {
                        this.currentOperateType = _.operation_en
                        this.$emit('actionFun', _, params.row, this.columns)
                      }}
                    >
                      {_.operation}
                    </Button>
                  )
                })}
              </div>
            )
          }
        })
    },
    isJSON (jsons) {
      try {
        if (typeof jsons === 'object' && jsons) {
          return true
        } else {
          return false
        }
      } catch (e) {
        return false
      }
    },
    async managementRefData (guid) {
      const lastPosition = guid.lastIndexOf('_')
      const ci = guid.substring(0, lastPosition)

      const { data } = await queryCiData({
        id: ci,
        queryObject: {
          dialect: { queryMode: 'new' },
          filters: [{ name: 'guid', operator: 'eq', value: guid }],
          paging: false
        }
      })
      const attrRes = await getCiTypeAttributes(ci)
      const showAttr = attrRes.data
        .filter(item => item.displayByDefault === 'yes')
        .map(attr => {
          return {
            attr: attr.ciTypeAttrId.split('__')[1],
            displayName: attr.displayName
          }
        })
      const res = showAttr.map(sa => {
        let tmp = {
          key: sa.displayName,
          value: ''
        }
        const attrValue = data.contents[0][sa.attr]
        if (Array.isArray(attrValue)) {
          tmp.value = attrValue
            .map(item => {
              return item.key_name
            })
            .join(',')
        } else if (this.isJSON(attrValue)) {
          tmp.value = attrValue.key_name
        } else {
          tmp.value = attrValue
        }
        return tmp
      })
      return res
    },
    // 自定义渲染表格内容
    renderCol (col, isLastCol = false) {
      // 弹框展示JSON数据
      const getObjectdata = async val => {
        this.tableDetailInfo.isShow = false
        this.tableDetailInfo.title = col.title
        this.tableDetailInfo.type = 'object'
        this.tableDetailInfo.info = val
        this.tableDetailInfo.isShow = true
      }
      const getRefdata = async val => {
        this.tableDetailInfo.isShow = false
        const refData = this.tableData.find(item => {
          if (item[col.key].key_name === val) {
            return item
          }
        })[col.key]
        this.tableDetailInfo.title = this.$t('details')
        this.tableDetailInfo.type = 'array'
        this.tableDetailInfo.info = [
          {
            title: val,
            value: await this.managementRefData(refData.guid)
          }
        ]
        this.tableDetailInfo.isShow = true
      }
      const getExtRefData = async (key, val) => {
        this.tableDetailInfo.isShow = false
        const refData =
          this.tableData.find(item => {
            if (item[col.key] && item[col.key].key_name === val) {
              return true
            }
          })[col.key] || {}
        this.tableDetailInfo.title = this.$t('details')
        const params = {
          filters: [
            {
              name: 'guid',
              operator: 'eq',
              value: refData.guid || ''
            }
          ]
        }
        const { statusCode, data } = await getExtRefDetails(key, params)
        if (statusCode === 'OK') {
          this.tableDetailInfo.type = 'object'
          this.tableDetailInfo.info = JSON.stringify(data.contents)
          this.tableDetailInfo.isShow = true
        }
      }
      const getMutiRefdata = async val => {
        val = JSON.parse(val)
        this.tableDetailInfo.isShow = false
        this.tableDetailInfo.title = this.$t('details')
        this.tableDetailInfo.type = 'array'
        this.tableDetailInfo.info = []
        await val.forEach(async v => {
          this.tableDetailInfo.info.push({
            title: v.key_name,
            value: await this.managementRefData(v.guid)
          })
        })
        this.tableDetailInfo.isShow = true
      }
      const getPassword = async (row, key) => {
        this.tableDetailInfo.isShow = false
        const rowData = this.tableData.find(item => row.guid === item.guid)
        const { statusCode, data } = await queryPassword(this.ciTypeId, rowData.guid, key, {})
        if (statusCode === 'OK') {
          this.tableDetailInfo.title = this.$t('password')
          this.tableDetailInfo.type = 'string'
          this.tableDetailInfo.info = data || this.$t('no_password_set')
          this.tableDetailInfo.isShow = true
        }
      }

      const getSensitiveInfo = async (row, col) => {
        if (col.sensitive !== 'yes') {
          return
        }
        this.tableDetailInfo.isShow = false
        const params = [
          {
            ciType: col.ciTypeId,
            attrName: col.inputKey,
            guid: row.weTableForm.guid
          }
        ]
        const { statusCode, data } = await searchSensitiveData(params)
        if (statusCode === 'OK') {
          this.tableDetailInfo.title = col.displayName
          this.tableDetailInfo.type = 'string'
          const detailInfo = data[0]
          this.tableDetailInfo.info = detailInfo.queryPermission ? data[0].value : this.$t('db_no_viewing_permission')
          this.tableDetailInfo.isShow = true
        }
      }

      const getDiffVariable = async (row, key) => {
        this.remarkedKeys = []
        this.diffVariableKeyName = row.guid
        this.diffVariableColKey = key
        this.tableDetailInfo.isShow = false
        const res = await this.formatData(row, key)
        this.tableDetailInfo.title = this.$t('variable_format')
        this.tableDetailInfo.type = 'diffVariable'
        this.tableDetailInfo.info = res
        this.$nextTick(() => {
          this.tableDetailInfo.isShow = true
        })
      }
      // 自定义渲染表格内容generalParams.render
      const generalParams = {
        ...col,
        tooltip: true,
        minWidth: MIN_WIDTH,
        width: isLastCol ? null : this.colWidth < MIN_WIDTH ? MIN_WIDTH : this.colWidth, // 除最后一列，都加上默认宽度，等宽
        resizable: !isLastCol, // 除最后一列，该属性都为true
        sortable: this.isSortable ? 'custom' : false
      }
      if (col.inputType === 'text' || (col.inputType === 'password' && col.sensitive === 'yes')) {
        generalParams.render = (h, params) => {
          return (
            <span style="display: flex">
              {col.sensitive === 'yes' && (
                <Icon
                  size="16"
                  type="ios-apps-outline"
                  color="#5384FF"
                  style="cursor:pointer"
                  onClick={() => getSensitiveInfo(params.row, col)}
                />
              )}
              <Tooltip max-width="300" placement="top-start">
                <div style="width: 90%; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                  {params.row.weTableForm[col.key]}
                </div>
                <div slot="content">
                  <p>{params.row.weTableForm[col.key]} </p>
                </div>
              </Tooltip>
            </span>
          )
        }
        return generalParams
      } else if (col.inputType === 'object') {
        generalParams.render = (h, params) => {
          return (
            <span>
              {params.row.weTableForm[col.key] && (
                <Icon
                  size="16"
                  type="ios-apps-outline"
                  color="#5384FF"
                  style="cursor:pointer"
                  onClick={() => getObjectdata(params.row.weTableForm[col.key])}
                />
              )}
              {params.row.weTableForm[col.key]}
            </span>
          )
        }
      } else if (col.inputType === 'ref') {
        generalParams.render = (h, params) => {
          return (
            <span>
              {params.row.weTableForm[col.key] && (
                <Icon
                  size="16"
                  type="ios-apps-outline"
                  color="#5384FF"
                  style="cursor:pointer"
                  onClick={() => getRefdata(params.row.weTableForm[col.key])}
                />
              )}
              {params.row.weTableForm[col.key]}
            </span>
          )
        }
        return generalParams
      } else if (col.inputType === 'multiRef') {
        const find = this.columns.find(column => column.ciTypeAttrId === col.ciTypeAttrId)
        let style = ''
        if (find !== undefined) {
          style = `width:${find.width - 20}px;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;`
        }
        generalParams.render = (h, params) => {
          let res = ''
          if (col.component === 'CMDBPermissionFilters') {
            // 兼容模型配置中数据权限对multiRef类型数据回显支持
            res = params.row.weTableForm[col.key]
          } else {
            res = JSON.parse(params.row.weTableForm[col.key])
              .map(item => item.key_name)
              .join(', ')
          }
          return (
            <Tooltip
              max-width="300"
              content={JSON.parse(params.row.weTableForm[col.key])
                .map(item => item.key_name)
                .join(', ')}
              placement="top-start"
            >
              <div style={style}>
                {params.row.weTableForm[col.key] && (
                  <Icon
                    size="16"
                    type="ios-apps-outline"
                    color="#5384FF"
                    style="cursor:pointer"
                    onClick={() => getMutiRefdata(params.row.weTableForm[col.key])}
                  />
                )}
                {res}
              </div>
              <div slot="content" style="white-space: normal;">
                <p>
                  {JSON.parse(params.row.weTableForm[col.key])
                    .map(item => item.key_name)
                    .join(', ')}
                </p>
              </div>
            </Tooltip>
          )
        }
        return generalParams
      } else if (col.inputType === 'extRef') {
        generalParams.render = (h, params) => {
          const isJumpMonitor = ['monitor:endpoint', 'monitor:service_group'].includes(col.extRefEntity)
          const jumpToMonitor = () => {
            if (col.extRefEntity === 'monitor:endpoint') {
              window.sessionStorage.currentPath = ''
              const path = `${window.location.origin}/#/monitorConfigIndex/endpointManagement?name=${
                params.row.weTableForm[col.key]
              }`
              window.open(path, '_blank')
            } else if (col.extRefEntity === 'monitor:service_group') {
              window.sessionStorage.currentPath = ''
              const path = `${window.location.origin}/#/monitorConfigIndex/resourceLevel?name=${
                params.row.weTableForm[col.key]
              }`
              window.open(path, '_blank')
            }
          }
          return (
            <span>
              {params.row.weTableForm[col.key] && (
                <Icon
                  size="16"
                  type="ios-apps-outline"
                  color="#5384FF"
                  style="cursor:pointer"
                  onClick={() => getExtRefData(col.ciTypeAttrId, params.row.weTableForm[col.key])}
                />
              )}
              {isJumpMonitor && (
                <span style="color:#5384FF;cursor:pointer;" onClick={() => jumpToMonitor()}>
                  {params.row.weTableForm[col.key]}
                </span>
              )}
              {!isJumpMonitor && <span>{params.row.weTableForm[col.key]}</span>}
            </span>
          )
        }
        return generalParams
      } else if (col.inputType === 'password') {
        generalParams.render = (h, params) => {
          return (
            <span>
              <Icon
                size="16"
                type="ios-apps-outline"
                color="#5384FF"
                onClick={() => getPassword(params.row, col.key)}
              />
              {params.row.weTableForm[col.key]}
            </span>
          )
        }
        return generalParams
      } else if (col.inputType === 'diffVariable') {
        generalParams.render = (h, params) => {
          const val = params.row.weTableForm[col.key]
          if (val) {
            return (
              <span>
                <Icon
                  size="16"
                  type="ios-apps-outline"
                  color="#5384FF"
                  style="cursor:pointer"
                  onClick={() => getDiffVariable(params.row, col.key)}
                />
                {params.row.weTableForm[col.key].slice(0, 18) + '...'}
              </span>
            )
          }
        }
        return generalParams
      } else if (col.inputType === 'tagShow') {
        generalParams.width = generalParams.colWidth ? generalParams.colWidth : generalParams.width
        generalParams.render = (h, params) => {
          const val = params.row.weTableForm[col.key]
          if (!col.tagOptions) {
            return <div>-</div>
          }
          if (!val) {
            return <div>-</div>
          }
          const realVal = JSON.parse(val)
          if (Array.isArray(realVal) && !lodash.isEmpty(realVal)) {
            return (
              <div class="tag-column" style="display: flex; flex-wrap: wrap">
                {realVal.map(single => {
                  const item = lodash.find(col.tagOptions, {
                    value: single
                  })
                  return (
                    <Tag style={{ 'min-width': item.width }} color={item.color}>
                      {item.label}
                    </Tag>
                  )
                })}
              </div>
            )
          }
        }
        return generalParams
      } else {
        generalParams.render = (h, params) => {
          let content = ''
          if (Array.isArray(params.row.weTableForm[col.key])) {
            if (['select', 'multiSelect'].indexOf(params.column.inputType) >= 0) {
              content = params.row.weTableForm[col.key]
                .map(_ => {
                  if (typeof _ === 'object' && _ !== null) {
                    return _.value
                  } else {
                    return _
                  }
                })
                .toString()
            } else if (params.column.inputType === 'multiRef') {
              content = params.row.weTableForm[col.key].map(_ => _.key_name).toString()
            }
            if (params.column.component === 'CMDBPermissionFilters') {
              content = params.row.weTableForm[col.key].join(' | ')
            }
          } else {
            content = params.row.weTableForm[col.key]
          }
          const containerId = 'ref' + Math.ceil(Math.random() * 1000000)

          return h(
            'span',
            {
              class: 'ivu-table-cell-tooltip-content',
              on: {
                mouseenter: event => {
                  if (
                    document.getElementById(containerId).scrollWidth > document.getElementById(containerId).clientWidth
                  ) {
                    this.timer = setTimeout(
                      params => {
                        this.tipContent = content
                        const popcorn = document.querySelector('#' + containerId)
                        const tooltip = document.querySelector('#' + params.randomId)
                        createPopper(popcorn, tooltip, {
                          placement: 'bottom'
                        })
                      },
                      800,
                      {
                        randomId: this.randomId,
                        content
                      }
                    )
                  }
                },
                mouseleave: event => {
                  clearInterval(this.timer)
                  this.tipContent = ''
                }
              },
              attrs: {
                id: containerId
              }
            },
            content
          )
        }
      }
      return generalParams
    },
    showEditModal () {
      this.modalTitle = this.titles.edit
      this.modalVisible = true
    },
    showAddModal () {
      this.modalTitle = this.titles.add

      const allFilterColumns =
        filter(this.columns, item => item.sensitive === 'yes' || item.component === 'WeCMDBCIPassword') || []
      const allFilterAttr = map(allFilterColumns, 'inputKey') || []

      this.selectedRows.forEach(row => {
        delete row.guid
        allFilterAttr.forEach(attr => {
          row[attr] = ''
        })
      })
      this.modalVisible = true
    },
    showCopyModal () {
      this.modalTitle = this.titles.copy
      this.modalVisible = true
    },
    closeEditModal (flag) {
      if (this.modalTitle === this.titles.add) {
        this.selectedRows = []
      }
      this.$emit('getSelectedRows', [], false)
      this.$refs.table.selectAll(false)
      this.modalVisible = flag
    },
    resetModalLoading () {
      this.modalLoading = false
    },
    isTableLoading (flag) {
      this.tableLoading = flag
    },
    editModalOkHandler (data) {
      this.modalLoading = true
      // data.operateType = this.currentOperateType
      // this.$emit('confirmEditHandler', data, this.currentOperateType)
      if (this.modalTitle === this.titles.edit) {
        this.$emit('confirmEditHandler', data, this.currentOperateType)
      } else {
        this.$emit('confirmAddHandler', data, this.currentOperateType)
      }
    }
  },
  render (h) {
    const {
      data,
      columns,
      pagination,
      highlightRow,
      filtersHidden,
      modalVisible,
      selectedRows,
      modalLoading,
      tableLoading,
      ascOptions,
      loadFilters
    } = this
    // TODO 逻辑待优化
    const isDisplay = col => {
      if (col.editable === 'yes') {
        if (col.autofillable === 'yes') {
          if (col.autoFillType !== 'forced') {
            return true
          } else {
            return false
          }
        } else {
          return true
        }
      } else {
        return false
      }
    }
    const filterColums = columns => {
      const res = columns.filter(col => isDisplay(col))
      return res
    }
    const closeModal = () => {
      this.tableDetailInfo.isShow = false
    }
    let selectAttrs = []
    this.tableColumns.forEach(t => {
      if (t.ciTypeAttrId) {
        this.isShowFilter = true
      }
      if (t.displayByDefault === 'yes') {
        selectAttrs.push(t.ciTypeAttrId)
      }
    })
    const changeColDisplay = ciTypeAttrId => {
      let attr = this.tableColumns.find(t => t.ciTypeAttrId === ciTypeAttrId)
      attr.displayByDefault = attr.displayByDefault === 'yes' ? 'no' : 'yes'
      if (selectAttrs.includes(ciTypeAttrId)) {
        const index = selectAttrs.findIndex(s => s === ciTypeAttrId)
        selectAttrs = selectAttrs.splice(index, 1)
      } else {
        selectAttrs.push(ciTypeAttrId)
      }
    }

    const choiceKey = chioceObj => {
      const key = chioceObj.key
      if (this.remarkedKeys.includes(key)) {
        // 元素存在于数组中，移除它
        const index = this.remarkedKeys.indexOf(key)
        this.remarkedKeys.splice(index, 1)
      } else {
        // 元素不存在于数组中，添加它
        this.remarkedKeys.push(key)
      }
    }

    const refreshDiffVariable = async () => {
      const { data } = await queryCiData({
        id: this.ciTypeId,
        queryObject: {
          dialect: { queryMode: 'new' },
          filters: [{ name: 'guid', operator: 'eq', value: this.diffVariableKeyName }],
          paging: false
        }
      })
      const res = await this.formatData(data.contents[0], this.diffVariableColKey)
      this.$nextTick(() => {
        this.tableDetailInfo.info = res
        this.tableDetailInfo.isShow = true
      })
    }
    return (
      <div>
        {!filtersHidden && loadFilters && <div class="form-filter">{this.getFormFilters()}</div>}
        <Row style="margin-bottom:10px">{this.getTableOuterActions()}</Row>
        {this.isShowFilter && (
          <div style="position: relative;top: -40px;right: 30px;float: right;">
            <Poptip placement="bottom">
              <Button type="primary" shape="circle" icon="ios-funnel-outline"></Button>
              <div slot="content" style="max-height: 400px;">
                {this.tableColumns.map(t => {
                  const ciTypeAttrId = t.ciTypeAttrId
                  if (selectAttrs.includes(ciTypeAttrId)) {
                    return (
                      <div
                        onClick={() => changeColDisplay(ciTypeAttrId)}
                        style="cursor:pointer;height: 22px;line-height: 22px;margin: 2px 4px 2px 0;padding: 0 2px;border: 1px solid #5384FF;color:#5384FF;font-size: 12px;vertical-align: middle;opacity: 1;overflow: hidden;border-radius: 3px;"
                      >
                        {t.displayName}
                      </div>
                    )
                  } else {
                    return (
                      <div
                        onClick={() => changeColDisplay(ciTypeAttrId)}
                        style="cursor:pointer;height: 22px;line-height: 22px;margin: 2px 4px 2px 0;padding: 0 2px;border: 1px solid #e8eaec;font-size: 12px;vertical-align: middle;opacity: 1;overflow: hidden;border-radius: 3px;"
                      >
                        {t.displayName}
                      </div>
                    )
                  }
                })}
              </div>
            </Poptip>
          </div>
        )}
        <Table
          class='cmdb-table'
          loading={tableLoading}
          ref="table"
          border
          data={data}
          columns={columns}
          highlight-row={highlightRow}
          on-on-selection-change={this.onCheckboxSelect}
          on-on-current-change={this.onRadioSelect}
          on-on-sort-change={this.sortHandler}
          on-on-column-width-resize={this.onColResize}
          size="small"
        />
        {pagination && (
          <Page
            total={pagination.total}
            page-size={pagination.pageSize}
            current={pagination.currentPage}
            on-on-change={v => this.$emit('pageChange', v)}
            on-on-page-size-change={v => this.$emit('pageSizeChange', v)}
            show-elevator
            show-sizer
            show-total
            style="float: right; margin: 10px 0;"
          />
        )}
        <EditModal
          isEdit={this.modalTitle === this.titles.edit}
          title={(this.oriDataMap[this.ciTypeId] ? this.oriDataMap[this.ciTypeId] + ' / ' : '') + this.modalTitle}
          columns={filterColums(columns)}
          tableColumns={this.tableColumns}
          guidFilters={this.guidFilters}
          guidFilterEffects={this.guidFilterEffects[this.ciTypeId] || []}
          data={selectedRows}
          ascOptions={ascOptions}
          on-closeEditModal={this.closeEditModal}
          on-editModalOkHandler={this.editModalOkHandler}
          modalVisible={modalVisible}
          modalLoading={modalLoading}
          onGetGroupList={v => this.$emit('getGroupList', v)}
        ></EditModal>
        <div id={this.randomId} style="z-index: 100;">
          {this.tipContent && (
            <div style="word-break: break-word;background-color: rgba(70,76,91,.9);padding: 8px 12px;color: #fff;text-align: left;border-radius: 4px;border-radius: 4px;box-shadow: 0 1px 6px rgba(0,0,0,.2);width: 400px;">
              <p style="white-space: pre-wrap;">{this.tipContent}</p>
            </div>
          )}
        </div>
        <Modal value={this.tableDetailInfo.isShow} footer-hide={true} title={this.tableDetailInfo.title} width={1100}>
          {this.tableDetailInfo.type === 'string' && (
            <div style="text-align: justify;word-break: break-word;">{this.tableDetailInfo.info}</div>
          )}
          {this.tableDetailInfo.type === 'array' && (
            <div style="overflow: auto;max-height:500px;overflow:auto">
              <Collapse>
                {this.tableDetailInfo.info.map(column => {
                  return (
                    <Panel name={column.title}>
                      {column.title}
                      <p slot="content">
                        <Form label-width={200}>
                          {column.value.map(val => {
                            return (
                              <FormItem label={val.key}>
                                <Input value={val.value} disabled />
                              </FormItem>
                            )
                          })}
                        </Form>
                      </p>
                    </Panel>
                  )
                })}
              </Collapse>
            </div>
          )}
          {this.tableDetailInfo.type === 'diffVariable' && (
            <div style="text-align: justify;word-break: break-word;overflow-y:auto;max-height:500px">
              <div style="text-align: left;">
                <Alert type="warning">如出现页面值未显示，请点击刷新按钮</Alert>
              </div>
              {this.tableDetailInfo.info.map(val => {
                return (
                  <div
                    onClick={() => choiceKey(val)}
                    style={this.remarkedKeys.includes(val.key) ? 'background:#d9d9d9' : ''}
                  >
                    <div style="width: 300px;display:inline-block;word-break: break-all;margin:4px 0;vertical-align: top;text-align:right;cursor:pointer">
                      <span style={!['', 'NULL'].includes(val.value) ? '' : 'color:red'}>{val.key}</span>
                    </div>
                    <div style="width: 740px;display:inline-block;word-break: break-all;margin:4px 0;">
                      ：{val.value}
                    </div>
                  </div>
                )
              })}
            </div>
          )}
          {this.tableDetailInfo.type === 'object' && (
            <json-viewer value={JSON.parse(this.tableDetailInfo.info)} expand-depth={5}></json-viewer>
          )}
          <div style="margin-top:20px;height: 30px">
            <Button style="float: right;margin-right: 20px" onClick={() => closeModal()}>
              {this.$t('close')}
            </Button>
            {this.tableDetailInfo.type === 'diffVariable' && (
              <Button style="float: right;margin-right: 20px" type="primary" onClick={() => refreshDiffVariable()}>
                {this.$t('refresh')}
              </Button>
            )}
          </div>
        </Modal>
      </div>
    )
  }
}
