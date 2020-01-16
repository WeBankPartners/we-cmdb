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
            <div :id="'abc' + guid"></div>
          </Card>
        </Col>
        <Col span="7" style="padding: 0 0 0 20px">
          <Card>
            <p slot="title">{{ $t('invoking_refrence') }}</p>
            <Row>
              <Col span="7">
                <span>{{ $t('select_invoking_refrence') }}</span>
              </Col>
              <Col span="16">
                <Select
                  multiple
                  filterable
                  @on-change="selectChangeHandler"
                  :max-tag-count="1"
                  clearabled
                  v-model="selectedSequences"
                >
                  <Option v-for="s in sequenceData" :label="s.key_name" :value="s.guid" :key="s.guid"></Option>
                </Select>
              </Col>
            </Row>
            <p
              v-for="sequence in selectedSequenceData"
              style="display: flex;margin-top:5px;border: 1px dashed gray;border-radius: 5px;padding: 0 10px;"
              :key="sequence.guid"
            >
              <span class="sequence_name" :title="sequence.key_name">{{ sequence.key_name }}</span>
              <Button
                size="small"
                @click.stop.prevent="moveUpSequence(sequence.guid)"
                icon="md-arrow-round-up"
              ></Button>
              <Button
                size="small"
                @click.stop.prevent="moveDownSequence(sequence.guid)"
                icon="md-arrow-round-down"
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

const SERVICE_INVOKE_DESIGN_SEQUENCE_CI_TYPE_ID = 35
const INVOKE_UNIT_DESIGN = 'invoke_unit_design'
const INVOKED_UNIT_DESIGN = 'invoked_unit_design'

export default {
  name: 'WeCMDBSequenceDiagram',
  data () {
    return {
      sequenceData: [],
      selectedSequences: [],
      selectedSequenceData: [],
      sequenceVisiable: false,
      graphString: 'sequenceDiagram \n A->>B'
    }
  },
  props: {
    guid: {},
    value: {
      default: []
    }
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
        this.selectedSequences = this.value
        this.selectChangeHandler(this.value)
      }
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
      this.$emit(
        'input',
        this.selectedSequenceData.map(_ => _.guid)
      )
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
      this.$emit(
        'input',
        this.selectedSequenceData.map(_ => _.guid)
      )
    },
    initSequenceGraph () {
      this.graphString = 'sequenceDiagram \n'
      const graphNode = ['sequenceDiagram']
      if (this.selectedSequenceData.length > 0) {
        this.selectedSequenceData.forEach((_, index) => {
          graphNode.push(
            `${_[INVOKE_UNIT_DESIGN].key_name.replace(/-/g, '&')}->>${_[INVOKED_UNIT_DESIGN].key_name.replace(
              /-/g,
              '&'
            )}:${index + 1} : ${_.description.length === 0 ? '' : _.description}`
          )
        })
        this.graphString = graphNode.toString().replace(/,/g, ' \n')
      }
      const element = document.querySelector(`#abc${this.guid}`)
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
      this.$emit('input', val)
    },
    visibleChangeHandler (status) {
      this.sequenceVisiable = status
    },
    async getSequenceData () {
      const payload = {
        id: SERVICE_INVOKE_DESIGN_SEQUENCE_CI_TYPE_ID,
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
</style>
