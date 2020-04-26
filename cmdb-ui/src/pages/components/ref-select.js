import { queryCiData, getCiTypeAttributes, getEnumCodesByCategoryId, queryReferenceCiData } from '@/api/server'
import { components } from '@/const/actions.js'
export default {
  name: 'WeCMDBRefSelect',
  props: {
    value: {},
    highlightRow: {},
    ciType: {},
    filterParams: {}
  },
  watch: {
    value: {
      handler (val) {
        this.selected = val
      },
      immediate: true
    }
  },
  data () {
    return {
      payload: {
        filters: [],
        pageable: {
          pageSize: 10,
          startIndex: 0
        },
        paging: true,
        sorting: {}
      },
      pagination: {
        pageSize: 10,
        currentPage: 1,
        total: 0
      },
      visibleSwap: false,
      tableData: [],
      allTableDataWithoutPaging: [],
      tableColumns: [],
      selected: [],
      tableValue: [],
      selectDisabled: true,
      firstInput: true,
      firstChange: true
    }
  },
  mounted () {
    this.getAllDataWithoutPaging()
  },
  methods: {
    async getAllDataWithoutPaging () {
      const rows = this.filterParams ? JSON.parse(JSON.stringify(this.filterParams.params)) : {}
      delete rows.isRowEditable
      delete rows.weTableForm
      delete rows.weTableRowId
      delete rows.isNewAddedRow
      delete rows.nextOperations
      let noPagingRes = this.filterParams
        ? await queryReferenceCiData({
          attrId: this.filterParams.attrId,
          queryObject: { filters: [], paging: false, dialect: { data: rows } }
        })
        : await queryCiData({
          id: this.ciType.id,
          queryObject: { filters: [], paging: false }
        })
      if (noPagingRes.statusCode === 'OK') {
        this.selectDisabled = false
        this.allTableDataWithoutPaging = this.filterParams
          ? noPagingRes.data.contents
          : noPagingRes.data.contents.map(_ => _.data)
      }
    },
    handleSubmit (data) {
      this.payload.filters = data
      this.queryCiData()
    },
    pageChange (current) {
      this.pagination.currentPage = current
      this.queryCiData()
      this.highlightRowHandler()
    },
    pageSizeChange (size) {
      this.pagination.pageSize = size
      this.queryCiData()
      this.highlightRowHandler()
    },
    async queryCiData () {
      this.payload.pageable.pageSize = this.pagination.pageSize
      this.payload.pageable.startIndex = (this.pagination.currentPage - 1) * this.pagination.pageSize
      const rows = this.filterParams ? JSON.parse(JSON.stringify(this.filterParams.params)) : {}
      delete rows.isRowEditable
      delete rows.weTableForm
      delete rows.weTableRowId
      delete rows.isNewAddedRow
      delete rows.nextOperations
      const query = {
        id: this.ciType.id,
        attrId: this.filterParams ? this.filterParams.attrId : null,
        queryObject: this.filterParams ? { ...this.payload, dialect: { data: rows } } : this.payload
      }
      const { statusCode, data } = this.filterParams ? await queryReferenceCiData(query) : await queryCiData(query)
      if (statusCode === 'OK') {
        this.tableData = this.filterParams ? data.contents : data.contents.map(_ => _.data)
        this.pagination.total = data.pageInfo.totalRows
      }
    },
    async queryCiAttrs (id) {
      const { statusCode, data } = await getCiTypeAttributes(id)
      let columns = []
      if (statusCode === 'OK') {
        columns = data
          .filter(
            _ => _.status !== 'decommissioned' && _.status !== 'notCreated' && _.isDisplayed && _.isDisplayed !== 0
          )
          .map(_ => {
            return {
              ..._,
              title: _.name,
              key: _.propertyName,
              inputKey: _.propertyName,
              inputType: _.inputType,
              referenceId: _.referenceId,
              placeholder: _.description,
              ciType: { id: _.referenceId, name: _.name },
              isMultiple: _.inputType === 'multiSelect',
              component: 'Input',
              type: 'text',
              ...components[_.inputType]
            }
          })
        this.tableColumns = this.getSelectOptions(columns)
      }
    },
    getSelectOptions (columns) {
      columns.forEach(async _ => {
        if (_.inputType === 'select' || _.inputType === 'multiSelect') {
          const { data } = await getEnumCodesByCategoryId(0, _.referenceId)
          _['options'] = data
            .filter(j => j.status === 'active')
            .map(i => {
              return {
                label: i.code,
                value: i.codeId
              }
            })
        }
      })
      return columns
    },
    showRefModal (e) {
      e.preventDefault()
      e.stopPropagation()
      this.visibleSwap = true
      this.queryCiAttrs(this.ciType.id)
      this.queryCiData()
      this.$nextTick(() => {
        this.highlightRowHandler()
      })
    },
    highlightRowHandler () {
      if (!this.highlightRow) {
        /* to get iview original data to reset _ischecked flag */
        let data = this.$refs.refTable.$refs.table.$refs.tbody.objData
        for (let obj in data) {
          data[obj]._isChecked = false
        }
        this.selected.forEach(_ => {
          const index = this.tableData.findIndex(el => el.guid === _)
          data[index]._isChecked = true
        })
      } else {
        const index = this.tableData.findIndex(el => el.guid === this.selected)
        const tr = document.querySelectorAll('.modalTable tr')
        if (index > -1) {
          tr[index + 1].classList.add('ivu-table-row-highlight')
          // tr[index+1].click()
        }
      }
    },
    hideRefModal (status) {
      if (status) return
      this.visibleSwap = false
    },
    getTableValue (val) {
      this.tableValue = val
    },
    modalOk () {
      this.selected = !this.highlightRow
        ? this.tableValue.map(_ => {
          return _.guid
        })
        : this.tableValue.length > 0
          ? this.tableValue[0].guid
          : ''
      this.$emit('input', this.selected)
      this.visibleSwap = false
    },
    handleInput (v) {
      if (!this.highlightRow && this.firstInput) {
        this.firstInput = false
        return
      }
      this.selected = v
    },
    selectChangeHandler (val) {
      if (!this.highlightRow && this.firstChange) {
        this.firstChange = false
        return
      }
      if (Array.isArray(val)) {
        this.$emit('input', val)
      } else {
        this.$emit('input', val || '')
      }
    },
    getFilterRulesOptions (val) {
      this.firstInput = false
      this.firstChange = false
      if (val) {
        this.pagination.currentPage = 1
        // this.queryCiData();
        this.getAllDataWithoutPaging()
      }
    }
  },
  render (h) {
    let renderOptions = this.allTableDataWithoutPaging.map(_ => {
      return (
        <Option value={_.guid || ''} key={_.guid}>
          {_.key_name}
        </Option>
      )
    })

    return (
      <div style="width:100%">
        <Select
          onInput={this.handleInput}
          value={this.selected}
          multiple={!this.highlightRow}
          disabled={this.selectDisabled}
          style="width:100%"
          filterable
          clearable
          on-on-change={this.selectChangeHandler}
          on-on-open-change={this.getFilterRulesOptions}
          max-tag-count={2}
        >
          <span slot="prefix" onClick={e => this.showRefModal(e)}>
            @
          </span>
          {renderOptions}
        </Select>
        <Modal
          title={this.ciType.name}
          value={this.visibleSwap}
          footer-hide={true}
          mask-closable={false}
          scrollable={true}
          width={1300}
          on-on-visible-change={status => this.hideRefModal(status)}
        >
          <div class="modalTable" style="padding:20px;">
            {this.visibleSwap && (
              <WeCMDBTable
                tableData={this.tableData}
                tableColumns={this.tableColumns}
                tableHeight={650}
                onGetSelectedRows={this.getTableValue}
                onHandleSubmit={this.handleSubmit}
                onPageChange={this.pageChange}
                onPageSizeChange={this.pageSizeChange}
                pagination={this.pagination}
                showCheckbox={true}
                highlightRow={this.highlightRow}
                tableOuterActions={null}
                tableInnerActions={null}
                ascOptions={{}}
                ref="refTable"
              />
            )}
          </div>
          <div style="text-align:right;margin-top:40px">
            <span style="margin-right:20px">
              <Button type="info" onClick={this.modalOk}>
                OK
              </Button>
            </span>
          </div>
        </Modal>
      </div>
    )
  }
}
