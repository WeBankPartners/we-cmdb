<template>
  <div class="ci-password">
    <!-- 编辑状态单元格 -->
    <div v-if="isEdit">
      <Button @click="showEditModal" :disabled="disabled" type="primary">{{ $t('password_edit') }}</Button>
    </div>
    <!-- 查看状态单元格 -->
    <div v-else>
      <span>******</span>
      <a @click="showPassword">{{ $t('show') }}</a>
    </div>
    <!-- 密码编辑弹框 -->
    <Modal
      v-model="isShowEditModal"
      :title="$t('password_edit')"
      :loading="modalLoading"
      @on-ok="confirm"
      @on-cancel="closeEditModal"
    >
      <Form :model="formData" :rules="rules" label-position="right" :label-width="120">
        <FormItem :label="$t('new_password')" prop="newPassword">
          <Input
            password
            :placeholder="$t('new_password_input_placeholder')"
            ref="newPasswordInput"
            type="password"
            v-model="formData.newPassword"
          />
        </FormItem>
        <FormItem :label="$t('confirm_password')" prop="comparedPassword">
          <Input
            password
            :placeholder="$t('please_input_new_password_again')"
            ref="comparedPasswordInput"
            type="password"
            v-model="formData.comparedPassword"
          />
        </FormItem>
      </Form>
    </Modal>
    <!-- 密码显示弹框 -->
    <Modal v-model="isShowPasswordModal" :title="$t('password')" @on-cancel="closePassword">
      <Spin size="large" fix v-if="spinShow">
        <Icon type="ios-loading" size="44" class="spin-icon-load"></Icon>
        <div>{{ $t('loading') }}</div>
      </Spin>
      <div class="ci-password-span">{{ password }}</div>
      <div slot="footer">
        <Button @click="closePassword">{{ $t('close') }}</Button>
      </div>
    </Modal>
  </div>
</template>

<script>
import { updatePassword, queryPassword } from '@/api/server'
export default {
  props: {
    isEdit: false,
    guid: '',
    propertyName: '',
    disabled: false,
    ciTypeId: {
      required: true,
      type: Number
    }
  },
  data () {
    return {
      isShowEditModal: false,
      isShowPasswordModal: false,
      password: '',
      spinShow: false,
      modalLoading: false,
      formData: {
        newPassword: '',
        comparedPassword: ''
      },
      rules: {
        newPassword: [
          {
            required: true,
            message: this.$t('is_required'),
            trigger: 'blur'
          }
        ],
        comparedPassword: [
          {
            required: true,
            message: this.$t('is_required'),
            trigger: 'blur'
          },
          {
            message: this.$t('please_input_right_new_password'),
            validator: () => this.formData.newPassword === this.formData.comparedPassword
          }
        ]
      }
    }
  },
  methods: {
    showEditModal () {
      this.isShowEditModal = true
      this.$nextTick(() => {
        this.$refs.newPasswordInput.focus()
      })
    },
    inputFocus () {
      this.$refs.comparedPasswordInput.focus()
    },
    async confirm () {
      // TODO
      this.modalLoading = true
      const payload = {
        guid: this.guid,
        field: this.propertyName,
        value: this.formData.newPassword
      }
      const { data, statusCode } = await updatePassword(this.ciTypeId, payload)
      this.modalLoading = false
      if (statusCode === 'OK') {
        this.password = data
        this.isShowEditModal = false
      }
    },
    closeEditModal () {
      this.isShowEditModal = false
      this.modalLoading = false
      this.formData = {
        newPassword: '',
        comparedPassword: ''
      }
    },
    async showPassword () {
      this.isShowPasswordModal = true
      this.spinShow = true
      const { ciTypeId, guid, propertyName } = this
      const { data, statusCode } = await queryPassword(ciTypeId, guid, propertyName)
      this.spinShow = false
      if (statusCode === 'OK') {
        this.password = data || this.$t('no_password')
      } else {
        this.password = this.$t('fetch_password_failed')
      }
    },
    closePassword () {
      this.password = ''
      this.isShowPasswordModal = false
    }
  }
}
</script>

<style scoped>
.ci-password-span {
  align-items: center;
  display: flex;
  height: 100%;
  justify-content: center;
  min-height: 50px;
  padding: 20px;
  width: 100%;
}
</style>
