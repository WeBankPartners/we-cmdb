<template>
  <Modal
    width="1000"
    :mask-closable="false"
    @on-visible-change="visibleChangeHandler"
    :footer-hide="true"
    v-model="isVisible"
    :title="$t('enum_management')"
  >
    <div style="border-bottom: 1px solid grey;">
      <Form>
        <Row>
          <Col span="5">
            <FormItem :label-width="70" :label="$t('form_name')">
              <Input v-model="form.catName"></Input>
            </FormItem>
          </Col>
          <Col offset="1" span="6">
            <FormItem :label-width="90" :label="$t('form_enum_type')">
              <Select :disabled="!!category" v-model="form.catTypeId">
                <Option v-for="item in catTypes" :value="item.value" :key="item.value">{{ item.label }}</Option>
              </Select>
            </FormItem>
          </Col>
          <Col offset="1" span="5">
            <FormItem :label-width="50" :label="$t('form_group')">
              <Select filterable clearable v-model="form.catGroupId">
                <Option v-for="item in allCategory" :value="item.catId" :key="item.catId">{{ item.catName }}</Option>
              </Select>
            </FormItem>
          </Col>
          <Col offset="1" span="5">
            <Button type="primary" @click="saveCategoryHandler" :loading="buttonLoading">{{ $t('save') }}</Button>
          </Col>
        </Row>
      </Form>
    </div>
    <div class="modalTable" style="padding:40px 10px;">
      <baseData v-if="categoryId > -1" ref="enumModal" :catId="categoryId"></baseData>
    </div>
  </Modal>
</template>
<script>
import baseData from '../enums'
import { createEnumCategory, updateEnumCategory } from '@/api/server'
export default {
  components: {
    baseData
  },
  data () {
    return {
      form: {
        catName: '',
        catTypeId: '',
        catGroupId: ''
      },
      categoryId: -1,
      catTypes: [
        {
          label: this.$t('common_enum'),
          value: 2
        },
        {
          label: this.$t('private_enum'),
          value: 3
        }
      ],
      isVisible: this.enumGroupVisible,
      buttonLoading: false
    }
  },
  watch: {
    enumGroupVisible (val) {
      this.isVisible = val
    },
    category: {
      handler (val) {
        if (val) {
          this.form = {
            ...this.form,
            ...val,
            catTypeId: val.catTypeId === 2 ? val.catTypeId : 3,
            catGroupId: val.groupTypeId
          }
          this.categoryId = val.catId
        } else {
          this.form = {
            catName: '',
            catTypeId: '',
            catGroupId: ''
          }
          this.categoryId = -1
        }
      }
    }
  },
  props: {
    enumGroupVisible: {},
    allEnumCategoryTypes: {},
    currentCiType: {},
    category: {},
    allCategory: {}
  },
  computed: {},
  methods: {
    async saveCategoryHandler () {
      this.buttonLoading = true
      const type = this.allEnumCategoryTypes.find(_ => _.ciTypeId === this.currentCiType.ciTypeId)
      if (this.category) {
        // update
        const payload = {
          catId: this.form.catId,
          catName: this.form.catName,
          catTypeId: this.form.catTypeId,
          groupTypeId: this.form.catGroupId
        }
        const { message, statusCode } = await updateEnumCategory(payload)
        this.buttonLoading = false
        if (statusCode === 'OK') {
          this.$Notice.success({
            title: this.$t('update_category_success_message'),
            desc: message
          })
          this.$refs.enumModal.$refs.table.form.catId = this.categoryId
          this.$refs.enumModal.getGroupList(this.categoryId)
        }
      } else {
        // create
        const payload = {
          catName: this.form.catName,
          catTypeId: this.form.catTypeId === 2 ? this.form.catTypeId : type.catTypeId,
          groupTypeId: this.form.catGroupId
        }
        const { message, data, statusCode } = await createEnumCategory(payload)
        this.buttonLoading = false
        if (statusCode === 'OK') {
          this.$Notice.success({
            title: this.$t('add_category_success_message'),
            desc: message
          })
          this.categoryId = data[0].catId
          this.$nextTick(() => {
            this.$refs.enumModal.$refs.table.form.catId = this.categoryId
            this.$refs.enumModal.getGroupList(this.categoryId)
          })
          this.$emit('getAllEnums')
        }
      }
    },
    visibleChangeHandler (status) {
      if (!status) {
        this.$emit('hideHandler')
        this.form = {
          catName: '',
          catTypeId: '',
          catGroupId: ''
        }
        this.categoryId = -1
      }
      if (status && this.categoryId > 0) {
        this.$nextTick(() => {
          this.$refs.enumModal.$refs.table.form.catId = this.categoryId
        })
      }
    }
  }
}
</script>
