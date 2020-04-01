<template>
  <div>
    <Button @click="showSequence" size="small" type="info">{{ $t('select_invoking_sequential') }}</Button>
    <Modal
      v-model="sequenceVisiable"
      @on-visible-change="visibleChangeHandler"
      width="90"
      :footer-hide="true"
      :mask-closable="false"
      :title="$t('invoking_design')"
    >
      <Row>
        <Col span="17">
          <Card>
            <p slot="title">{{ $t('sequential_graph') }}</p>
            <div :id="'guid_' + guid"></div>
          </Card>
        </Col>
        <Col span="7" style="padding: 0 0 0 20px">
          <Card>
            <p slot="title">{{ $t('invoking_refrence') }}</p>
            <Row class="sequence-diagram-select-row">
              <span :title="$t('select_invoking_refrence')">{{ $t('select_invoking_refrence') }}</span>
              <Select filterable :max-tag-count="1" clearabled v-model="selectedSequence">
                <Option v-for="s in sequenceData" :label="s.key_name" :value="s.guid" :key="s.guid"></Option>
              </Select>
              <Button class="sequence-diagram-select-row-button" @click="pushSequence()">添加</Button>
            </Row>
            <p
              v-for="(sequence, index) in selectedSequenceData"
              class="sequence-diagram-list"
              :key="`${index}-${sequence.guid}`"
            >
              <span class="sequence_name" :title="sequence.key_name">{{ sequence.key_name }}</span>
              <Button
                size="small"
                class="sequence-diagram-icon"
                @click.stop.prevent="moveUpSequence(sequence.guid)"
                icon="md-arrow-round-up"
              ></Button>
              <Button
                size="small"
                class="sequence-diagram-icon"
                @click.stop.prevent="moveDownSequence(sequence.guid)"
                icon="md-arrow-round-down"
              ></Button>
              <Button
                size="small"
                class="sequence-diagram-icon"
                @click.stop.prevent="deleteSequence(index)"
                icon="ios-trash"
              ></Button>
            </p>
          </Card>
        </Col>
      </Row>
    </Modal>
  </div>
</template>
<script>
import { queryCiData } from '@/api/server'
import mermaid from 'mermaid'

export default {
  name: 'WeCMDBSequenceDiagram',
  data () {
    return {
      sequenceData: [],
      selectedSequence: '',
      selectedSequenceList: [],
      selectedSequenceData: [],
      sequenceVisiable: false,
      graphString: 'sequenceDiagram \n A->>B'
    }
  },
  props: {
    guid: {},
    value: {
      default: []
    },
    serviceInvokeDesignId: 0,
    invokeUnitDesign: '',
    invokedUnitDesign: '',
    serviceDesign: ''
  },
  watch: {
    sequenceData: {
      handler (val) {
        if (val.length > 0) {
          this.displaySequence()
        }
      }
    }
  },
  mounted () {
    this.getSequenceData()
  },
  methods: {
    displaySequence () {
      if (this.value) {
        this.selectedSequenceList = this.vaule
        this.selectChangeHandler(this.value)
      }
    },
    pushSequence () {
      this.selectChangeHandler([...this.selectedSequenceList, this.selectedSequence])
    },
    moveUpSequence (id) {
      let currentIndex = this.selectedSequenceData.map(i => i.guid).indexOf(id)
      if (!this.selectedSequenceData[currentIndex - 1]) {
        this.$Notice.warning({
          title: 'Warning',
          desc: this.$t('is_first_layer')
        })
        return
      }
      let clone = JSON.parse(JSON.stringify(this.selectedSequenceData))

      clone[currentIndex] = this.selectedSequenceData[currentIndex - 1]
      clone[currentIndex - 1] = this.selectedSequenceData[currentIndex]

      this.selectedSequenceData = clone
      this.initSequenceGraph()
      this.updateValue(this.selectedSequenceData.map(_ => _.guid))
    },
    moveDownSequence (id) {
      let currentIndex = this.selectedSequenceData.map(i => i.guid).indexOf(id)
      if (!this.selectedSequenceData[currentIndex + 1]) {
        this.$Notice.warning({
          title: 'Warning',
          desc: this.$t('is_last_layer')
        })
        return
      }
      let clone = JSON.parse(JSON.stringify(this.selectedSequenceData))

      clone[currentIndex] = this.selectedSequenceData[currentIndex + 1]
      clone[currentIndex + 1] = this.selectedSequenceData[currentIndex]

      this.selectedSequenceData = clone
      this.initSequenceGraph()
      this.updateValue(this.selectedSequenceData.map(_ => _.guid))
    },
    deleteSequence (index) {
      let value = [...this.selectedSequenceList]
      value.splice(index, 1)
      this.selectChangeHandler(value)
    },
    initSequenceGraph () {
      this.graphString = 'sequenceDiagram \n'
      const graphNode = ['sequenceDiagram']
      if (this.selectedSequenceData.length > 0) {
        this.selectedSequenceData.forEach((_, index) => {
          graphNode.push(
            `${_[this.invokeUnitDesign].key_name.replace(/-/g, '&')}->>${_[this.invokedUnitDesign].key_name.replace(
              /-/g,
              '&'
            )}:${index + 1} : ${_[this.serviceDesign] && _[this.serviceDesign].name ? _[this.serviceDesign].name : ''}`
          )
        })
        this.graphString = graphNode.toString().replace(/,/g, ' \n')
      }
      const element = document.querySelector(`#guid_${this.guid}`)
      element.removeAttribute('data-processed')
      element.innerHTML = this.graphString
      mermaid.parse(this.graphString)
      mermaid.init(undefined, element)
      this.$nextTick(() => {
        this.replaceSvgContentHandler()
      })
    },
    replaceSvgContentHandler () {
      const nodes = document.querySelectorAll('g text tspan')
      nodes.forEach(i => {
        const inner = i.innerHTML
        i.innerHTML = inner.replace(/&amp;/g, '-')
      })
    },
    showSequence () {
      this.sequenceVisiable = true
      this.$nextTick(() => {
        this.initSequenceGraph()
      })
    },
    selectChangeHandler (val) {
      this.selectedSequenceData = val.map(_ => {
        let found = this.sequenceData.find(i => i.guid === _)
        if (found) {
          return found
        }
      })
      this.initSequenceGraph()
      this.updateValue(val)
    },
    updateValue (val) {
      this.selectedSequenceList = val
      this.$emit('input', val)
    },
    visibleChangeHandler (status) {
      this.sequenceVisiable = status
    },
    async getSequenceData () {
      const payload = {
        id: this.serviceInvokeDesignId,
        queryObject: {
          filters: [],
          pageable: { pageSize: 10, startIndex: 0 },
          paging: false,
          sorting: {}
        }
      }
      const { data, statusCode } = await queryCiData(payload)
      if (statusCode === 'OK') {
        this.sequenceData = data.contents.map(_ => {
          return { ..._.data }
        })
      }
    }
  }
}
</script>
<style lang="scss">
.sequence_name {
  display: inline-block;
  width: 85%;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  line-height: 30px;
  height: 30px;
}
.sequence-diagram-select-row {
  display: flex;
  align-items: center;

  > span {
    width: 25%;
  }

  &-button {
    margin-left: 5px;
  }
}
.sequence-diagram-list {
  align-items: center;
  border: 1px dashed gray;
  border-radius: 5px;
  display: flex;
  margin-top: 5px;
  padding: 0 10px;
}
.sequence-diagram-icon {
  margin-left: 5px;
}
</style>
