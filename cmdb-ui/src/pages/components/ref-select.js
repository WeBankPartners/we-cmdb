import {
  queryCiData,
  getCiTypeAttributes,
  getEnumCodesByCategoryId,
  queryReferenceCiData,
  getExtRefDetails
} from '@/api/server'
import { components } from '@/const/actions.js'
import { finalDataForRequest } from '@/pages/util/component-util'
import CustomMultipleRefSelect from './custom-ref-select.vue'
export default {
  name: 'WeCMDBRefSelect',
  components: { CustomMultipleRefSelect },
  props: {
    value: {},
    highlightRow: {},
    ciType: {},
    ciTypeAttrId: '',
    disabled: { default: () => false },
    filterParams: {},
    guidFilters: { default: () => null },
    guidFilterEnabled: { default: () => false },
    title: '',
    inputType: ''
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
      firstChange: true,
      extRefDetail: {
        isShow: false,
        title: '',
        info: '',
        type: ''
      }
    }
  },
  inject: ['ciDataManagementQueryType'],
  mounted () {
    this.getAllDataWithoutPaging()
  },
  methods: {
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
    async getAllDataWithoutPaging () {
      const rows = this.filterParams ? JSON.parse(JSON.stringify(this.filterParams.params)) : {}
      const finalData = finalDataForRequest(rows)
      let noPagingRes = await queryReferenceCiData({
        attrId: this.ciTypeAttrId,
        queryObject: { filters: [], paging: false, dialect: { associatedData: finalData } }
      })
      if (noPagingRes.statusCode === 'OK') {
        let data = noPagingRes.data
        if (this.guidFilterEnabled && this.guidFilters && Array.isArray(this.guidFilters)) {
          data = data.filter(el => {
            if (this.guidFilters.indexOf(el.guid) >= 0) {
              return true
            }
            return false
          })
        }
        this.selectDisabled = false
        this.allTableDataWithoutPaging = data
      }
    },
    handleSubmit (data) {
      this.payload.filters = data
      this.queryCiData()
    },
    async pageChange (current) {
      this.pagination.currentPage = current
      await this.queryCiData()
      this.highlightRowHandler()
    },
    async pageSizeChange (size) {
      this.pagination.pageSize = size
      await this.queryCiData()
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
      query.queryObject.withRefRowData = true
      const { statusCode, data } = this.filterParams ? await queryReferenceCiData(query) : await queryCiData(query)
      if (statusCode === 'OK') {
        this.tableData = data.contents
        this.pagination.total = data.pageInfo.totalRows
      }
    },
    async queryCiAttrs (id) {
      const { statusCode, data } = await getCiTypeAttributes(id)
      let columns = []
      if (statusCode === 'OK') {
        columns = data
          .filter(_ => _.status !== 'decommissioned' && _.status !== 'notCreated' && _.displayByDefault === 'yes')
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
          if (_.referenceId) {
            const { data } = await getEnumCodesByCategoryId(_.referenceId)
            _['options'] = data
              .filter(j => j.status === 'active')
              .map(i => {
                return {
                  label: i.code,
                  value: i.codeId
                }
              })
          }
        }
      })
      return columns
    },
    async showRefModal (e) {
      e.preventDefault()
      e.stopPropagation()
      if (this.inputType === 'extRef') {
        const params = {
          filters: [
            {
              name: 'guid',
              operator: 'eq',
              value: this.selected || ''
            }
          ]
        }
        const { statusCode, data } = await getExtRefDetails(this.ciTypeAttrId, params)
        if (statusCode === 'OK') {
          this.extRefDetail.title = this.$t('details')
          this.extRefDetail.type = 'object'
          this.extRefDetail.info = JSON.stringify(data.contents)
          this.extRefDetail.isShow = true
        }
      } else {
        this.visibleSwap = true
        await this.queryCiAttrs(this.ciType.id)
        await this.queryCiData()
      }
      this.highlightRowHandler()
    },
    highlightRowHandler () {
      if (!this.highlightRow) {
        this.tableData.forEach(i => {
          if (this.selected.includes(i.guid)) {
            this.$set(i, '_checked', true)
          } else {
            this.$set(i, '_checked', false)
          }
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
      <div class="cmdb-ref-select">
        {this.highlightRow && (
          <Select
            onInput={this.handleInput}
            value={this.selected}
            disabled={this.selectDisabled || this.disabled}
            style="width:100%"
            filterable
            clearable
            on-on-change={this.selectChangeHandler}
            on-on-open-change={this.getFilterRulesOptions}
            max-tag-count={2}
            placeholder={this.title || this.$t('select_placeholder')}
          >
            <span slot="prefix" style="cursor:pointer;" onClick={e => this.showRefModal(e)}>
              @
            </span>
            {renderOptions}
          </Select>
        )}
        {// 引用多选下拉框组件封装
          !this.highlightRow && (
            <CustomMultipleRefSelect
              options={this.allTableDataWithoutPaging}
              onShowRefModal={e => this.showRefModal(e)}
              onChange={val => this.$emit('input', val)}
              onOpenChange={this.getFilterRulesOptions}
              disabled={this.selectDisabled || this.disabled}
              v-model={this.selected}
              title={this.title}
            ></CustomMultipleRefSelect>
          )}
        <Modal
          title={this.ciType.name}
          value={this.visibleSwap}
          footer-hide={true}
          mask-closable={false}
          scrollable={true}
          width={1000}
          on-on-visible-change={status => this.hideRefModal(status)}
        >
          <div class="modalTable">
            {this.visibleSwap && (
              <CMDBTable
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
          <div style="text-align:right;margin-top:60px">
            <span style="margin-right:20px">
              <Button type="info" onClick={this.modalOk}>
                OK
              </Button>
            </span>
          </div>
        </Modal>
        <Modal v-model={this.extRefDetail.isShow} footer-hide={true} title={this.extRefDetail.title} width={1100}>
          {this.extRefDetail.type === 'object' && (
            <json-viewer
              style="max-height:400px;overflow-y:scroll"
              value={JSON.parse(this.extRefDetail.info)}
              expand-depth={5}
            ></json-viewer>
          )}
          <div style="margin-top:20px;height: 30px">
            <Button
              style="float: right;margin-right: 20px"
              onClick={() => {
                this.extRefDetail.isShow = false
              }}
            >
              {this.$t('close')}
            </Button>
          </div>
        </Modal>
      </div>
    )
  }
}
