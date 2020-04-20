const WIDTH = 300
export default {
  data () {
    return {
      editData: [],
      noOfCopy: 1
    }
  },
  props: {
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
    data: {
      required: true,
      type: Array
    }
  },
  computed: {
    tableWidth () {
      return WIDTH * this.columns.length
    }
  },
  watch: {
    data: {
      handler (val) {
        this.editData = JSON.parse(JSON.stringify(val))
      },
      immediate: true
    },
    modalVisible: {
      handler (val) {
        if (val) {
          this.editData = JSON.parse(JSON.stringify(this.data))
        }
      }
    }
  },
  methods: {
    okHandler () {
      this.$emit('editModalOkHandler', this.editData)
      this.$emit('closeEditModal', false)
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
        if (x.key && !x.isAuto && x.isEditable) {
          arr.push(x.key)
        }
        return arr
      }, [])
      let temData = JSON.parse(JSON.stringify(this.editData))
      temData = Object.freeze(temData)
      const copyRows = temData.map(row => {
        let obj = {
          guid: '',
          r_guid: '',
          p_guid: '',
          state: '',
          fixed_date: '',
          isRowEditable: true,
          forceEdit: true
        }
        columns.forEach(x => {
          obj[x] = row[x]
        })
        console.log(obj)
        return obj
      })
      console.log(copyRows)
      this.editData = []
      for (let i = 0; i < this.noOfCopy; i++) {
        this.editData = this.editData.concat(copyRows)
        if (this.editData.length > 20) break
      }
    },
    renderDataRows () {
      return (
        <div style={`width: ${this.tableWidth}px`}>
          {this.editData.map((d, index) => {
            return (
              <div key={index} style={`width: ${this.tableWidth}px`}>
                {this.columns.map(column => {
                  if (column.component === 'WeCMDBCIPassword') {
                    return (
                      <div
                        key={column.propertyName + index}
                        style={`width:${WIDTH}px;display:inline-block;padding:5px`}
                      >
                        <column.component
                          ciTypeId={column.ciTypeId}
                          guid={d.guid}
                          isEdit={true}
                          isNewAddedRow={d.isNewAddedRow || false}
                          propertyName={column.propertyName}
                          value={d[column.propertyName]}
                          onInput={v => {
                            d[column.propertyName] = v
                          }}
                        />
                      </div>
                    )
                  } else {
                    const props =
                      column.component === 'WeCMDBSelect'
                        ? {
                          value: column.isRefreshable
                            ? column.inputType === 'multiSelect'
                              ? []
                              : ''
                            : column.inputType === 'multiSelect'
                              ? Array.isArray(d[column.inputKey])
                                ? d[column.inputKey]
                                : ''
                              : d[column.inputKey],
                          filterParams: column.filterRule
                            ? {
                              attrId: column.ciTypeAttrId,
                              params: d
                            }
                            : null,
                          isMultiple: column.isMultiple,
                          enumId: column.referenceId ? column.referenceId : null
                        }
                        : {
                          value: column.isRefreshable
                            ? ''
                            : column.inputType === 'multiRef'
                              ? Array.isArray(d[column.inputKey])
                                ? d[column.inputKey]
                                : ''
                              : d[column.inputKey] || '',
                          filterParams: column.filterRule
                            ? {
                              attrId: column.ciTypeAttrId,
                              params: d
                            }
                            : null,
                          ciType: column.component === 'WeCMDBRefSelect' ? column.ciType : null,
                          ...column,
                          type: column.component === 'DatePicker' ? 'date' : column.type,
                          guid: d.guid ? d.guid : '123'
                        }
                    const fun = {
                      input: v => {
                        d[column.propertyName] = v
                      }
                    }
                    const data = {
                      props,
                      on: fun
                    }
                    return (
                      <div
                        key={column.propertyName + index}
                        style={`width:${WIDTH}px;display:inline-block;padding:5px`}
                      >
                        <column.component {...data} />
                      </div>
                    )
                  }
                })}
              </div>
            )
          })}
        </div>
      )
    }
  },
  render (h) {
    return (
      <Modal
        mask-closable={false}
        title={this.title}
        width={90}
        value={this.modalVisible}
        on-on-visible-change={this.visibleChange}
        on-on-ok={this.okHandler}
        on-on-cancel={this.cancelHandler}
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
        <div style="overflow: auto">
          <div style={`width: ${this.tableWidth}px`}>
            {this.columns.map(column => {
              return (
                <div
                  style={`width:${WIDTH}px;display:inline-block;padding:5px;height: 30px;font-weight:600;background-color: #e8eaec`}
                  key={column.ciTypeAttrId}
                >
                  {column.name}
                </div>
              )
            })}
          </div>
          {this.renderDataRows()}
        </div>
      </Modal>
    )
  }
}
