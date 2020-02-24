<template>
  <div class="ci-password">
    <!-- 新增及编辑状态单元格 -->
    <div v-if="isEdit">
      <Button v-if="isNewAddedRow && !value" @click="showEditModal" :disabled="disabled" type="primary">{{
        $t('enter_password')
      }}</Button>
      <div class="ci-password-cell-show" v-else-if="isNewAddedRow && value">
        <Tooltip class="ci-password-cell-show-span" :content="isShowPassword ? value : '******'">
          <span>{{ isShowPassword ? value : '******' }}</span>
        </Tooltip>
        <a @click="() => (isShowPassword = !isShowPassword)">{{ isShowPassword ? $t('hide') : $t('show') }}</a>
        <a @click="showEditModal">{{ $t('edit') }}</a>
      </div>
      <Button v-else @click="showEditModal" :disabled="disabled" type="primary">{{ $t('password_edit') }}</Button>
    </div>
    <!-- 只读状态单元格 -->
    <div v-else class="ci-password-cell-show">
      <span class="ci-password-cell-show-span">{{ value }}</span>
      <a @click="showPassword">{{ $t('show') }}</a>
    </div>
    <!-- 密码编辑弹框 -->
    <Modal v-model="isShowEditModal" :title="isNewAddedRow ? $t('enter_password') : $t('password_edit')">
      <Form ref="form" :model="formData" :rules="rules" label-position="right" :label-width="120">
        <FormItem :label="isNewAddedRow ? $t('password') : $t('new_password')" prop="newPassword">
          <Input
            password
            :placeholder="$t('new_password_input_placeholder')"
            ref="newPasswordInput"
            type="password"
            v-model="formData.newPassword"
          />
        </FormItem>
        <FormItem :label="isNewAddedRow ? $t('confirm_password') : $t('confirm_password')" prop="comparedPassword">
          <Input
            password
            :placeholder="$t('please_input_new_password_again')"
            ref="comparedPasswordInput"
            type="password"
            v-model="formData.comparedPassword"
          />
        </FormItem>
      </Form>
      <div slot="footer">
        <Button @click="confirm" :loading="modalLoading" type="primary">{{
          isNewAddedRow ? $t('confirm') : $t('save')
        }}</Button>
        <Button @click="closeEditModal">{{ $t('close') }}</Button>
      </div>
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
    },
    isNewAddedRow: false,
    value: ''
  },
  data () {
    return {
      isShowPassword: false,
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
        comparedPassword: [
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
      this.$refs.form.validate(vail => {
        if (vail) {
          if (this.isNewAddedRow) {
            this.handleInput()
          } else {
            this.updatePassword()
          }
        }
      })
    },
    handleInput () {
      this.$emit('input', this.formData.newPassword)
      this.formData = {
        newPassword: '',
        comparedPassword: ''
      }
      this.isShowEditModal = false
    },
    async updatePassword () {
      this.modalLoading = true
      const payload = {
        guid: this.guid,
        field: this.propertyName,
        value: this.formData.newPassword
      }
      const { statusCode } = await updatePassword(this.ciTypeId, payload)
      this.formData = {
        newPassword: '',
        comparedPassword: ''
      }
      this.modalLoading = false
      if (statusCode === 'OK') {
        this.isShowEditModal = false
        this.$Notice.success({
          title: 'Success',
          desc: this.$t('reset_password_success')
        })
      }
    },
    closeEditModal () {
      this.isShowEditModal = false
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

<style lang="scss" scoped>
.ci-password-span {
  align-items: center;
  display: flex;
  height: 100%;
  justify-content: center;
  min-height: 50px;
  padding: 20px;
  width: 100%;
}
.ci-password-cell-show {
  display: flex;
  &-span {
    flex: 1;
    text-overflow: ellipsis;
    white-space: nowrap;
    overflow: hidden;

    span {
      display: inline-block;
      width: 100%;
      text-overflow: ellipsis;
      white-space: nowrap;
      overflow: hidden;
    }
  }
  a {
    margin-left: 5px;
  }
}
</style>
