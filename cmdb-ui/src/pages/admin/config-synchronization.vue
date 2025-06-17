<template>
  <div class="config-synchronization">
    <div class="content-left">
      <ContainIconTitle :title="$t('db_data_synchronization_configuration')" @showContentChange="e => this.onShowContentChange(e, 'left')"></ContainIconTitle>
      <div class="content-left-detail" v-show="isShowLeftContent">
        <div class="content-left-detail-item" v-for="(item, index) in synchronizationConfigContent" :key="index">
          <div class="content-left-detail-title">{{(item.labelText ? item.labelText : $t(item.label)) + ':'}}</div>
          <i-switch disabled v-if="item.type === 'switch'" :value="Boolean(dataConfig[item.key] && dataConfig[item.key] === 'Y')" />
          <Select v-if="item.type === 'select'" v-model="synchronizationType" @on-change="onSynchronizationTypeChange" style="width:200px">
            <Option v-for="item in synchronizationTypeList" :value="item.value" :key="item.value">{{ item.name }}</Option>
          </Select>
          <span v-if="item.type === 'text'">{{dataConfig[item.key]}}</span>
        </div>
      </div>
    </div>
    <div class="content-right">
      <ContainIconTitle :title="$t('db_data_synchronization_record')" @showContentChange="e => this.onShowContentChange(e, 'right')"></ContainIconTitle>
      <div v-show="isShowRightContent" class="content-right-detail">
        <RadioGroup
          v-model="configRadioType"
          class="config-synchronization-radio"
          type="button"
          button-style="solid"
        >
          <Radio v-for="item in radioGroupList" :key="item.type" :label="item.type" border>{{ $t(item.label) }}</Radio>
        </RadioGroup>
        <Table 
          v-if="showDataRecord && showDataRecord.length > 0"
          :key="configRadioType"
          border 
          max-height="550"
          :columns="synchronizationTableColumns" 
          :data="showDataRecord"
        />
        <div v-else style="margin-left: 100px">{{$t('no_data')}}</div>
      </div>
    </div>
  </div>
</template>

<script>
import ContainIconTitle from '../components/contain-icon-title'
import {getSynchronizationDetail} from '@/api/server.js'

export default {
  components: {
    ContainIconTitle
  },
  data () {
    return {
      isShowLeftContent: true,
      isShowRightContent: true,
      synchronizationConfigContent: [
        {
          label: 'db_data_synchronization_switch',
          key: 'enable',
          type: 'switch'
        },
        {
          label: 'db_synchronization_type',
          key: 'type',
          type: 'select'
        },
        {
          label: 'db_source_address',
          key: 'source',
          type: 'text'
        },
        {
          label: 'db_nexu_address',
          key: 'nexus_address',
          type: 'text'
        },
        {
          labelText: 'nexu_user',
          key: 'nexus_user',
          type: 'text'
        },
        {
          labelText: 'nexu_psw',
          key: 'nexus_pwd',
          type: 'text'
        },
        {
          labelText: 'nexu_repo',
          key: 'nexus_repo',
          type: 'text'
        }
      ],
      synchronizationTypeList: [
        {
          name: 'source',
          value: 'master'
        },
        {
          name: 'target',
          value: 'slave'
        }
      ],
      synchronizationType: 'master',
      radioGroupList: [
        {
          label: 'db_CMDB_model_synchronization',
          type: 'model'
        }, 
        {
          label: 'db_CMDB_data_synchronization',
          type: 'ciData'
        }
      ],
      configRadioType: 'model',
      synchronizationTableColumns: [
        {
          title: this.$t('db_synchronize_versions'),
          key: 'id',
          align: 'center',
          minWidth: 300
        },
        {
          title: this.$t('db_synchronize_people'),
          key: 'operator',
          align: 'center',
          width: 100,
        },
        {
          title: this.$t('db_modify_ranges'),
          key: 'dataType',
          align: 'center',
          width: 250,
        },
        {
          title: this.$t('db_synchronization_status'),
          key: 'status',
          align: 'center',
          width: 100,
        }
      ],
      dataConfig: {},
      dataRecord: [],
      synchronizationTypeMap: {
        master: {
          label: 'db_source_address',
          key: 'source'
        },
        slave: {
          label: 'db_target_address',
          key: 'target'
        }
      }
    }
  },
  computed: {
    showDataRecord () {
      return this.dataRecord.filter(item => item.dataCategory === this.configRadioType)
    }
  },
  async mounted () {
    const allConfig = await this.getConfigData()
    this.dataConfig = allConfig.config
    this.dataRecord = allConfig.list
    if (this.dataConfig.type) {
      this.synchronizationType = this.dataConfig.type
    }
  },
  methods: {
    onShowContentChange(status, type) {
      if (type === 'left') {
        this.isShowLeftContent = status
      } else {
        this.isShowRightContent = status
      }
    },
    onSynchronizationTypeChange(type) {
      this.synchronizationConfigContent[2].label = this.synchronizationTypeMap[type].label
      this.synchronizationConfigContent[2].key = this.synchronizationTypeMap[type].key
    },
    getConfigData() {
      return new Promise(async resolve => {
        const res = await getSynchronizationDetail()
        resolve(res.data)
      })
    }
  }

}

</script>

<style lang="scss" scoped>
.config-synchronization {
  display: flex;
  .content-left {
    display: flex;
    width: 45%;
    flex-direction: column;
    padding-left: 30px;
    padding-top: 10px;
    .content-left-detail {
      margin-top: 10px;
      margin-left: 20px;
      .content-left-detail-item {
        margin: 15px 0
      }
      .content-left-detail-title {
        display: inline-block;
        width: 150px
      }
    }
  }
  .content-right {
    flex: 1;
    padding-top: 10px;
    .content-right-detail {
      margin-left: 20px
    }

  }
}
</style>
<style lang="scss">
.config-synchronization-radio {
  margin: 20px 0;
  .ivu-radio-wrapper-checked.ivu-radio-border {
    background-color: #5384FF;;
    color: #fff;
  }
}

</style>