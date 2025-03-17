<template>
  <div>
    <!-- 搜索区 -->
    <div>
      <Row>
        <Col span="7">
          <span>{{ $t('ci_template') }}</span>
          <Select
            v-model="ciTemplate"
            clearable
            @on-clear="showTable = false"
            filterable
            style="width:300px;margin-left: 12px;"
            ref="ciTemplate"
            @on-open-change="getCiTemplate"
          >
            <Button type="success" style="width:100%" @click="addCiTemplate" size="small">
              <Icon type="ios-add" size="24"></Icon>
            </Button>
            <Option v-for="item in ciTemplateOptions" :value="item.id" :key="item.id"
              >{{ item.description
              }}<span style="float:right">
                <Button
                  @click.stop.prevent="editCiTemplate(item)"
                  icon="ios-create-outline"
                  type="primary"
                  size="small"
                ></Button>
                <Button
                  @click.stop.prevent="deleteCiTemplate(item)"
                  icon="ios-trash"
                  type="error"
                  size="small"
                ></Button> </span
            ></Option>
          </Select>
        </Col>

        <Col span="5">
          <Button @click="getCiTemplateAttr" :disabled="!ciTemplate" type="primary">{{ $t('query') }}</Button>
          <Button @click="addCiTemplateAttr" :disabled="!showTable" style="margin-left: 72px">{{ $t('new') }}</Button>
        </Col>
      </Row>
    </div>
    <div v-if="showTable" style="margin-top:24px">
      <Table border :columns="tableColumns" :data="tableData" :max-height="MODALHEIGHT"></Table>
    </div>

    <Modal
      v-model="newCiTemplate.isShow"
      :title="(newCiTemplate.isAdd ? $t('new') : $t('edit')) + $t('ci_template')"
      @on-ok="confirmCiTemplate"
      @on-cancel="newCiTemplate.isShow = false"
    >
      <Form inline :label-width="80">
        <FormItem label="ID" v-if="newCiTemplate.isAdd">
          <Input type="text" v-model="newCiTemplate.form.id" style="width:400px"></Input>
        </FormItem>
        <FormItem :label="$t('description')">
          <Input type="text" v-model="newCiTemplate.form.description" style="width:400px"></Input>
        </FormItem>
        <FormItem :label="$t('state_machine')">
          <Select
            v-model="newCiTemplate.form.stateMachine"
            filterable
            style="width:400px"
            @on-open-change="getStateMachineList"
          >
            <Option v-for="item in stateMachineOptions" :value="item.id" :key="item.id">{{ item.description }}</Option>
          </Select>
        </FormItem>
        <FormItem :label="$t('icon')" v-if="newCiTemplate.isAdd">
          <Upload :before-upload="handleUpload" action="">
            <Button class="btn-upload">
              <img src="@/styles/icon/UploadOutlined.png" class="upload-icon" />
              {{ $t('upload_icon_btn') }}
            </Button>
            <!-- <Button icon="ios-cloud-upload-outline">{{ $t('upload_icon_btn') }}</Button> -->
          </Upload>
          <div v-if="newCiTemplate.form.fileName">{{ newCiTemplate.form.fileName }}</div>
        </FormItem>
        <FormItem :label="$t('icon')" v-if="!newCiTemplate.isAdd">
          <img
            v-if="newCiTemplate.form.imageFile"
            :src="`/wecmdb/fonts/${newCiTemplate.form.imageFile}`"
            height="58"
            width="58"
          />
          <Upload 
            :before-upload="handleUploadEdit" 
            action="" 
            :disabled="newCiTemplate.form.status === 'deleted'">
            <!-- <Button icon="ios-cloud-upload-outline">{{ $t('upload_icon_btn') }}</Button> -->
            <Button class="btn-upload">
              <img src="@/styles/icon/UploadOutlined.png" class="upload-icon" />
              {{ $t('upload_icon_btn') }}
            </Button>
          </Upload>
          <div v-if="newCiTemplate.form.fileName">{{ newCiTemplate.form.fileName }}</div>
        </FormItem>
      </Form>
    </Modal>
  </div>
</template>

<script>
import {
  addCiTemplate,
  addCiTemplateAttr,
  deleteCiTemplate,
  deleteCiTemplateAttr,
  editCiTemplate,
  editCiTemplateAttr,
  getCiTemplate,
  getCiTemplateAttr,
  getStateMachineList
} from '@/api/server';
import { INPUT_TYPE_CONFIG } from '@/const/init-params.js';
export default {
  data () {
    return {
      MODALHEIGHT: 500,
      ciTemplate: '',
      ciTemplateOptions: [],
      showTable: false,
      tableColumns: [
        {
          title: this.$t('form_name'),
          width: 160,
          render: (h, params) => {
            return (
              <div>
                <Input
                  disabled={params.row.id !== ''}
                  value={params.row.name}
                  onInput={v => {
                    params.row.name = v
                  }}
                />
              </div>
            )
          }
        },
        {
          title: this.$t('description'),
          width: 160,
          render: (h, params) => {
            return (
              <div>
                <Input
                  value={params.row.description}
                  onInput={v => {
                    params.row.description = v
                  }}
                />
              </div>
            )
          }
        },
        {
          title: this.$t('search_filter_number'),
          width: 100,
          render: (h, params) => {
            return (
              <div>
                <InputNumber
                  style="width:60px"
                  min={1}
                  value={params.row.uiSearchOrder}
                  onInput={v => {
                    params.row.uiSearchOrder = v
                  }}
                />
              </div>
            )
          }
        },
        {
          title: this.$t('input_type'),
          width: 110,
          render: (h, params) => {
            return (
              <div>
                <Select
                  value={params.row.inputType}
                  style="width:100%"
                  filterable
                  on-on-change={v => {
                    const find = this.allInputTypes.find(item => v === item.code)
                    params.row.dataType = find.value
                    params.row.inputType = v
                  }}
                >
                  {this.allInputTypes.map(item => {
                    return (
                      <Option value={item.code} key={item.code}>
                        {item.code}
                      </Option>
                    )
                  })}
                </Select>
              </div>
            )
          }
        },
        {
          title: this.$t('data_type'),
          width: 110,
          render: (h, params) => {
            return (
              <div>
                <Input disabled value={params.row.dataType} />
              </div>
            )
          }
        },
        {
          title: this.$t('customizable'),
          width: 110,
          render: (h, params) => {
            return (
              <div>
                <Select
                  value={params.row.customizable}
                  style="width:100%"
                  filterable
                  on-on-change={v => {
                    params.row.customizable = v
                  }}
                >
                  {this.YorN.map(item => {
                    return (
                      <Option value={item.value} key={item.value}>
                        {item.label}
                      </Option>
                    )
                  })}
                </Select>
              </div>
            )
          }
        },
        {
          title: this.$t('length'),
          width: 100,
          render: (h, params) => {
            return (
              <div>
                <InputNumber
                  style="width:60px"
                  min={1}
                  value={params.row.dataLength}
                  onInput={v => {
                    params.row.dataLength = v
                  }}
                />
              </div>
            )
          }
        },
        {
          title: this.$t('is_displayed'),
          width: 110,
          render: (h, params) => {
            return (
              <div>
                <Select
                  value={params.row.displayByDefault}
                  style="width:100%"
                  filterable
                  on-on-change={v => {
                    params.row.displayByDefault = v
                  }}
                >
                  {this.YorN.map(item => {
                    return (
                      <Option value={item.value} key={item.value}>
                        {item.label}
                      </Option>
                    )
                  })}
                </Select>
              </div>
            )
          }
        },
        {
          title: this.$t('display_name'),
          width: 160,
          render: (h, params) => {
            return (
              <div>
                <Input
                  value={params.row.displayName}
                  onInput={v => {
                    params.row.displayName = v
                  }}
                />
              </div>
            )
          }
        },
        {
          title: this.$t('is_editable'),
          width: 100,
          render: (h, params) => {
            return (
              <div>
                <Select
                  value={params.row.editable}
                  style="width:100%"
                  filterable
                  on-on-change={v => {
                    params.row.editable = v
                  }}
                >
                  {this.YorN.map(item => {
                    return (
                      <Option value={item.value} key={item.value}>
                        {item.label}
                      </Option>
                    )
                  })}
                </Select>
              </div>
            )
          }
        },
        {
          title: this.$t('is_nullable'),
          width: 100,
          render: (h, params) => {
            return (
              <div>
                <Select
                  value={params.row.nullable}
                  style="width:100%"
                  filterable
                  on-on-change={v => {
                    params.row.nullable = v
                  }}
                >
                  {this.YorN.map(item => {
                    return (
                      <Option value={item.value} key={item.value}>
                        {item.label}
                      </Option>
                    )
                  })}
                </Select>
              </div>
            )
          }
        },
        {
          title: this.$t('is_access_controlled'),
          width: 100,
          render: (h, params) => {
            return (
              <div>
                <Select
                  value={params.row.permissionUsage}
                  style="width:100%"
                  filterable
                  on-on-change={v => {
                    params.row.permissionUsage = v
                  }}
                >
                  {this.YorN.map(item => {
                    return (
                      <Option value={item.value} key={item.value}>
                        {item.label}
                      </Option>
                    )
                  })}
                </Select>
              </div>
            )
          }
        },
        {
          title: this.$t('is_refreshable'),
          width: 100,
          render: (h, params) => {
            return (
              <div>
                <Select
                  value={params.row.resetOnEdit}
                  style="width:100%"
                  filterable
                  on-on-change={v => {
                    params.row.resetOnEdit = v
                  }}
                >
                  {this.YorN.map(item => {
                    return (
                      <Option value={item.value} key={item.value}>
                        {item.label}
                      </Option>
                    )
                  })}
                </Select>
              </div>
            )
          }
        },
        {
          title: this.$t('text_validate'),
          width: 100,
          render: (h, params) => {
            return (
              <div>
                <Select
                  value={params.row.textValidate}
                  style="width:100%"
                  filterable
                  on-on-change={v => {
                    params.row.textValidate = v
                  }}
                >
                  {this.YorN.map(item => {
                    return (
                      <Option value={item.value} key={item.value}>
                        {item.label}
                      </Option>
                    )
                  })}
                </Select>
              </div>
            )
          }
        },
        {
          title: this.$t('ui_form_order'),
          width: 100,
          render: (h, params) => {
            return (
              <div>
                <InputNumber
                  style="width:60px"
                  min={1}
                  value={params.row.uiFormOrder}
                  onInput={v => {
                    params.row.uiFormOrder = v
                  }}
                />
              </div>
            )
          }
        },
        {
          title: this.$t('is_uiNullable'),
          width: 110,
          render: (h, params) => {
            return (
              <div>
                <Select
                  value={params.row.uiNullable}
                  style="width:100%"
                  filterable
                  on-on-change={v => {
                    params.row.uiNullable = v
                  }}
                >
                  {this.YorN.map(item => {
                    return (
                      <Option value={item.value} key={item.value}>
                        {item.label}
                      </Option>
                    )
                  })}
                </Select>
              </div>
            )
          }
        },
        {
          title: this.$t('is_unique'),
          width: 110,
          render: (h, params) => {
            return (
              <div>
                <Select
                  value={params.row.uniqueConstraint}
                  style="width:100%"
                  filterable
                  on-on-change={v => {
                    params.row.uniqueConstraint = v
                  }}
                >
                  {this.YorN.map(item => {
                    return (
                      <Option value={item.value} key={item.value}>
                        {item.label}
                      </Option>
                    )
                  })}
                </Select>
              </div>
            )
          }
        },
        {
          title: this.$t('actions'),
          width: 150,
          align: 'center',
          render: (h, params) => {
            return h('div', [
              h(
                'Button',
                {
                  props: {
                    type: 'primary',
                    size: 'small'
                  },
                  style: {
                    marginRight: '5px'
                  },
                  on: {
                    click: () => {
                      this.saveRow(params.row)
                    }
                  }
                },
                this.$t('save')
              ),
              h(
                'Button',
                {
                  props: {
                    type: 'error',
                    size: 'small'
                  },
                  on: {
                    click: () => {
                      this.removeRow(params.row, params.index)
                    }
                  }
                },
                this.$t('delete')
              )
            ])
          }
        }
      ],
      tableData: [],
      emptyRow: {
        ciTemplate: '',
        customizable: 'no',
        dataLength: 64,
        dataType: 'varchar',
        description: '',
        displayByDefault: 'yes',
        displayName: '',
        editable: 'yes',
        id: '',
        inputType: 'text',
        name: '',
        nullable: 'yes',
        permissionUsage: 'no',
        resetOnEdit: 'no',
        textValidate: 'no',
        uiFormOrder: 5,
        uiNullable: 'yes',
        uiSearchOrder: 4,
        uniqueConstraint: 'yes'
      },
      allInputTypes: INPUT_TYPE_CONFIG,
      YorN: [
        { label: 'yes', value: 'yes' },
        { label: 'no', value: 'no' }
      ],
      newCiTemplate: {
        isShow: false,
        isAdd: true,
        form: {
          description: '',
          id: '',
          fileName: '',
          imageFile: '',
          stateMachine: ''
        }
      },
      stateMachineOptions: [],
      emptyCiTemplate: {
        description: '',
        id: '',
        imageFile: '',
        stateMachine: ''
      }
    }
  },
  mounted () {
    this.MODALHEIGHT = document.body.scrollHeight - 200
    this.getCiTemplate()
  },
  methods: {
    handleUploadEdit (file) {
      const res = ['jpg', 'jpeg', 'png'].some(item => file.name.includes(item))
      if (!res) {
        this.$Notice.warning({
          title: 'Warning',
          desc: this.$t('file_upload_tips')
        })
        return
      }
      this.newCiTemplate.form.fileName = file.name
      var FR = new FileReader()
      FR.onload = event => {
        const imgData = event.target.result.split(',')
        this.newCiTemplate.form.imageFile = imgData[1]
      }
      FR.readAsDataURL(file)
      return false
    },
    handleUpload (file) {
      const res = ['jpg', 'jpeg', 'png'].some(item => file.name.includes(item))
      if (!res) {
        this.$Notice.warning({
          title: 'Warning',
          desc: this.$t('file_upload_tips')
        })
        return
      }
      this.newCiTemplate.form.fileName = file.name
      var FR = new FileReader()
      FR.onload = event => {
        const imgData = event.target.result.split(',')
        this.newCiTemplate.form.imageFile = imgData[1]
      }
      FR.readAsDataURL(file)
      return false
    },
    async saveRow (item) {
      item.ciTemplate = this.ciTemplate
      const method = item.id === '' ? addCiTemplateAttr : editCiTemplateAttr
      const { statusCode, data } = await method([item])
      if (statusCode === 'OK') {
        item.id = data[0]
        this.$Notice.success({
          title: 'Successful',
          desc: 'Successful'
        })
      }
    },
    removeRow (item, index) {
      this.$Modal.confirm({
        title: this.$t('confirm_delete'),
        'z-index': 1000000,
        loading: true,
        onOk: async () => {
          let res = await deleteCiTemplateAttr(item.id)
          this.$Modal.remove()
          if (res.statusCode === 'OK') {
            this.$Notice.success({
              title: 'Successful',
              desc: 'Successful'
            })
            this.tableData.splice(index, 1)
          }
        },
        onCancel: () => {}
      })
    },
    addCiTemplateAttr () {
      this.tableData.push(JSON.parse(JSON.stringify(this.emptyRow)))
    },
    async getCiTemplateAttr () {
      const params = {
        filters: [
          {
            name: 'ciTemplate',
            operator: 'eq',
            value: this.ciTemplate
          }
        ]
      }
      this.showTable = false
      const { statusCode, data } = await getCiTemplateAttr(params)
      if (statusCode === 'OK') {
        this.showTable = true
        this.tableData = data.contents
      }
    },
    addCiTemplate () {
      this.$refs.ciTemplate.visible = false
      this.newCiTemplate = {
        isShow: true,
        isAdd: true,
        form: {
          ...this.emptyCiTemplate
        }
      }
    },
    editCiTemplate (item) {
      this.$refs.ciTemplate.visible = false
      this.newCiTemplate = {
        isShow: true,
        isAdd: false,
        form: {
          ...item
        }
      }
    },
    async confirmCiTemplate () {
      const method = this.newCiTemplate.isAdd ? addCiTemplate : editCiTemplate
      const { statusCode } = await method(this.newCiTemplate.form)
      if (statusCode === 'OK') {
        this.successTip()
        await this.getCiTemplate()
      }
    },
    successTip () {
      this.$Notice.success({
        title: 'Successful',
        desc: 'Successful'
      })
    },
    deleteCiTemplate (item) {
      this.$refs.ciTemplate.visible = false
      this.$Modal.confirm({
        title: this.$t('confirm_delete'),
        'z-index': 1000000,
        loading: true,
        onOk: async () => {
          let res = await deleteCiTemplate(item.id)
          this.$Modal.remove()
          if (res.statusCode === 'OK') {
            this.successTip()
            this.ciTemplate = ''
            this.getCiTemplate()
          }
        },
        onCancel: () => {}
      })
    },
    async getCiTemplate () {
      const { statusCode, data } = await getCiTemplate()
      if (statusCode === 'OK') {
        this.ciTemplateOptions = data
      }
    },
    async getStateMachineList () {
      const params = {
        filters: []
      }
      const { statusCode, data } = await getStateMachineList(params)
      if (statusCode === 'OK') {
        this.stateMachineOptions = data.contents
      }
    }
  }
}
</script>
