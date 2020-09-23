import '../table.scss'
import moment from 'moment'
import EditModal from './edit-modal.js'
import { dataToCsv, download } from './export-csv.js'
import { createPopper } from '@popperjs/core'
const DEFAULT_FILTER_NUMBER = 5
const MIN_WIDTH = 200
const DATE_FORMAT = 'YYYY-MM-DD HH:mm:ss'

export default {
  name: 'CMDBTable',
  props: {
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
    isColumnsFilterOn: { default: () => true }
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
      timer: null
    }
  },
  component: {
    EditModal
  },
  mounted () {
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
      this.selectedRows = []
    },
    tableColumns: {
      handler (val, oldval) {
        this.tableColumns.forEach(_ => {
          if (_.children) {
            _.children.forEach(j => {
              if (!j.isNotFilterable) {
                this.$set(this.form, j.inputKey, '')
              }
            })
          } else {
            if (!_.isNotFilterable) {
              this.$set(this.form, _.inputKey, '')
            }
          }
        })
        this.calColumn()
      },
      immediate: true
    },
    ascOptions: {
      handler (val, oldval) {
        this.calColumn()
      },
      deep: true,
      immediate: true
    }
  },
  computed: {},
  methods: {
    pushNewAddedRowToSelections (data) {
      this.selectedRows.push(data)
    },
    formatTableData () {
      this.data = this.tableData.map((_, index) => {
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
          if (
            typeof _['weTableForm'][i] === 'object' &&
            _['weTableForm'][i] !== null &&
            !Array.isArray(_['weTableForm'][i]) &&
            i !== 'weTableForm'
          ) {
            _[i] = _['weTableForm'][i].codeId || _['weTableForm'][i].guid
            _['weTableForm'][i] = _['weTableForm'][i].value || _['weTableForm'][i].key_name
          } else {
            if (Array.isArray(_['weTableForm'][i]) && i !== 'nextOperations') {
              _['weTableForm'][i] = _['weTableForm'][i]
              const found = this.tableColumns.find(q => q.inputKey === i)
              if (found && found.inputType === 'multiSelect') {
                _[i] = _['weTableForm'][i].map(j => j.codeId)
              }
              if (found && found.inputType === 'multiRef') {
                _[i] = _['weTableForm'][i].map(j => j.guid)
              }
            }
          }
          if (this.isRefreshable) {
            const found = this.tableColumns.find(q => q.inputKey === i)
            if (found && found.isRefreshable) {
              _[i] = null
            }
          }
        }
      })
    },
    handleSubmit (ref) {
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
          case 'date':
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
            .filter(_ => _.searchSeqNo || _.children)
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
      this.$emit('handleSubmit', filters)
    },
    reset (ref) {
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
    },
    getTableOuterActions () {
      if (this.tableOuterActions) {
        return this.tableOuterActions.map(_ => {
          return (
            <Button
              style="margin-right: 10px"
              {..._}
              onClick={() => {
                this.$emit('actionFun', _.actionType, this.selectedRows, this.columns)
              }}
            >
              {_.label}
            </Button>
          )
        })
      }
    },
    renderFormItem (item, index = 0) {
      if (item.isNotFilterable) return
      const data = {
        props: {
          ...item,
          enumId: item.referenceId ? item.referenceId : null
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
                onInput={v => (this.form[item.inputKey] = v)}
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
                onInput={v => (this.form[item.inputKey] = v)}
                value={this.form[item.inputKey]}
                {...data}
              />
            )
          default:
            return (
              <item.component
                on-on-enter={() => this.handleSubmit('form')}
                value={this.form[item.inputKey]}
                onInput={v => (this.form[item.inputKey] = v)}
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
          <FormItem label={item.title} prop={item.inputKey} key={item.inputKey}>
            {renders(item)}
          </FormItem>
        </Col>
      )
    },
    getFormFilters () {
      let compare = (a, b) => {
        if (a.searchSeqNo < b.searchSeqNo) {
          return -1
        }
        if (a.searchSeqNo > b.searchSeqNo) {
          return 1
        }
        return 0
      }
      return (
        <Form ref="form" label-position="top" inline>
          <Row>
            {this.tableColumns
              .filter(_ => !!_.children || !!_.searchSeqNo)
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
                          .filter(_ => !!_.searchSeqNo)
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
                {this.tableColumns.filter(_ => !!_.searchSeqNo).sort(compare).length > DEFAULT_FILTER_NUMBER &&
                  (!this.isShowHiddenFilters ? (
                    <FormItem>
                      <div slot="label" style="visibility: hidden;">
                        <span>Placeholder</span>
                      </div>
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
                      <div slot="label" style="visibility: hidden;">
                        <span>Placeholder</span>
                      </div>
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
                  <div slot="label" style="visibility: hidden;">
                    <span>Placeholder</span>
                  </div>
                  <Button type="primary" icon="ios-search" onClick={() => this.handleSubmit('form')}>
                    {this.$t('search')}
                  </Button>
                </FormItem>
                <FormItem>
                  <div slot="label" style="visibility: hidden;">
                    <span>Placeholder</span>
                  </div>
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
        if (a.displaySeqNo < b.displaySeqNo) {
          return -1
        }
        if (a.displaySeqNo > b.displaySeqNo) {
          return 1
        }
        return 0
      }
      const columns = this.tableColumns.filter(_ => (_.isDisplayed && _.displaySeqNo > 0) || _.children).sort(compare)
      const tableWidth = this.$refs.table ? this.$refs.table.$el.clientWidth : 1000 // 获取table宽度，默认值1000
      const colLength = columns.length // 获取传入展示的column长度
      this.colWidth = Math.floor(tableWidth / colLength)
      this.columns = columns.map((_, idx) => {
        // const isLast = colLength - 1 === idx
        if (_.children) {
          const children = _.children.filter(_ => _.isDisplayed || _.displaySeqNo).sort(compare)
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
        this.columns.unshift({
          type: 'selection',
          width: 60,
          align: 'center',
          fixed: 'left'
        })
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
                  if (
                    _.visible
                      ? _.visible.key === 'nextOperations'
                        ? !!params.row[_.visible.key].find(op => op === _.actionType)
                        : _.visible.value === !!params.row[_.visible.key]
                      : true
                  ) {
                    if (_.actionType === 'confirm') {
                      return (
                        <Button
                          {...{ props: { ..._.props } }}
                          disabled={_.isDisabled && _.isDisabled(params.row)}
                          loading={_.isLoading && _.isLoading(params.row)}
                          style="marginRight: 5px"
                          onClick={() => {
                            this.$Modal.confirm({
                              title: this.$t('operation_confirm').replace('{state}', params.row.state_code),
                              'z-index': 1000000,
                              onOk: async () => {
                                this.$emit('actionFun', _.actionType, params.row)
                              },
                              onCancel: () => {}
                            })
                          }}
                        >
                          <Tooltip content={this.$t('operation_confirm_tips')} placement="left-start" max-width="250">
                            <span>{_.label}</span>
                          </Tooltip>
                        </Button>
                      )
                    } else {
                      return (
                        <Button
                          {...{ props: { ..._.props } }}
                          disabled={_.isDisabled && _.isDisabled(params.row)}
                          loading={_.isLoading && _.isLoading(params.row)}
                          style="marginRight: 5px"
                          onClick={() => {
                            this.$emit('actionFun', _.actionType, params.row)
                          }}
                        >
                          {_.label}
                        </Button>
                      )
                    }
                  }
                })}
              </div>
            )
          }
        })
    },
    renderCol (col, isLastCol = false) {
      return {
        ...col,
        tooltip: true,
        minWidth: MIN_WIDTH,
        width: isLastCol ? null : this.colWidth < MIN_WIDTH ? MIN_WIDTH : this.colWidth, // 除最后一列，都加上默认宽度，等宽
        resizable: !isLastCol, // 除最后一列，该属性都为true
        sortable: this.isSortable ? 'custom' : false,
        render: (h, params) => {
          let content = ''
          if (Array.isArray(params.row.weTableForm[col.key])) {
            if (['select', 'multiSelect'].indexOf(params.column.inputType) >= 0) {
              content = params.row.weTableForm[col.key].map(_ => _.value).toString()
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
    },
    showEditModal () {
      this.modalTitle = this.titles.edit
      this.modalVisible = true
    },
    showAddModal () {
      this.modalTitle = this.titles.add
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
      if (this.modalTitle === this.titles.edit) {
        this.$emit('confirmEditHandler', data)
      } else {
        this.$emit('confirmAddHandler', data)
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
      ascOptions
    } = this
    return (
      <div>
        {!filtersHidden && <div>{this.getFormFilters()}</div>}
        <Row style="margin-bottom:10px">{this.getTableOuterActions()}</Row>
        <Table
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
          title={this.modalTitle}
          columns={columns.filter(col => !col.isAuto && col.isEditable)}
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
            <div style="word-break: break-word;background-color: rgba(70,76,91,.9);padding: 8px 12px;color: #fff;text-align: left;border-radius: 4px;border-radius: 4px;box-shadow: 0 1px 6px rgba(0,0,0,.2);width: 250px;">
              {this.tipContent}
            </div>
          )}
        </div>
      </div>
    )
  }
}
