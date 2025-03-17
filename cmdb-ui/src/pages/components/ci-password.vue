<template>
  <div>
    <div>
      <Tooltip
        max-width="200"
        class="ci-password-cell-show-span"
        placement="bottom-start"
        :content="isShowPassword ? realPassword : '******'"
      >
        <Input :value="isShowPassword ? realPassword : '******'" disabled></Input>
        <!-- <div class="password-wrapper">{{ isShowPassword ? realPassword : '******11' }}</div> -->
      </Tooltip>
      <div style="float: right; margin-right: 12px;">
        <Button
          size="small"
          type="primary"
          :disabled="isSensitive && sensitiveInfo.queryPermission === false"
          ghost
          @click="
            () => {
              isShowPassword = !isShowPassword
              formData.isShowPassword = isShowPassword
              showPassword()
            }
          "
        >
          <Icon :type="isShowPassword ? 'md-eye-off' : 'md-eye'" size="16" />
        </Button>
        <Button
          size="small"
          type="primary"
          :disabled="disabled || (isSensitive && sensitiveInfo.updatePermission === false)"
          ghost
          @click="resetPassword"
        >
          <Icon type="ios-build-outline" size="16" />
        </Button>
        <!-- <Icon :type="isShowPassword ? 'md-eye-off' : 'md-eye'" @click="showPassword" class="operation-icon-confirm" /> -->
        <!-- <Icon type="ios-build-outline" v-if="!disabled" @click="resetPassword" class="operation-icon-confirm" /> -->
      </div>
    </div>
    <Modal
      v-model="isShowEditModal"
      :title="useLocalValue ? $t('enter_password') : $t('password_edit')"
      class-name="cmdb-password-modal"
    >
      <Form ref="form" :model="editFormData" :rules="rules" label-position="right" :label-width="120">
        <FormItem :label="useLocalValue ? $t('password') : $t('new_password')" prop="newPassword">
          <Input
            class="encrypt-password"
            password
            :placeholder="$t('new_password_input_placeholder')"
            ref="newPasswordInput"
            type="password"
            v-model="editFormData.newPassword"
          />
        </FormItem>
        <FormItem :label="useLocalValue ? $t('confirm_password') : $t('confirm_password')" prop="comparedPassword">
          <Input
            class="encrypt-password"
            password
            :placeholder="$t('please_input_new_password_again')"
            ref="comparedPasswordInput"
            type="password"
            v-model="editFormData.comparedPassword"
          />
        </FormItem>
      </Form>
      <div slot="footer">
        <Button @click="confirm" :loading="modalLoading" type="primary">{{
          useLocalValue ? $t('confirm') : $t('save')
        }}</Button>
        <Button @click="closeEditModal">{{ $t('close') }}</Button>
      </div>
    </Modal>
  </div>
</template>

<script>
import { find, hasIn } from 'lodash'
import { queryPassword } from '@/api/server'
export default {
  name: '',
  data () {
    return {
      realPassword: '',
      useLocalValue: false,
      isShowPassword: false,
      isShowEditModal: false,
      editFormData: {
        newPassword: '',
        comparedPassword: ''
      },
      modalLoading: false,
      rules: {
        newPassword: [
          {
            required: true,
            message: this.$t('new_password_input_placeholder'),
            validator: () => !!this.editFormData.newPassword
          }
        ],
        comparedPassword: [
          {
            required: true,
            message: this.$t('new_password_input_placeholder'),
            validator: () => !!this.editFormData.comparedPassword
          },
          {
            required: true,
            message: this.$t('please_input_right_new_password'),
            validator: () => this.editFormData.newPassword === this.editFormData.comparedPassword
          }
        ]
      },
      sensitiveInfo: {}
    }
  },
  props: ['formData', 'panalData', 'disabled', 'index', 'allSensitiveData'],
  computed: {
    isSensitive () {
      return this.formData.sensitive === 'yes'
    }
  },
  mounted () {
    this.sensitiveInfo =
      find(this.allSensitiveData, {
        guid: this.panalData.guid,
        ciType: this.formData.ciTypeId,
        attrName: this.formData.inputKey
      }) || {}
    this.isShowPassword = false
    if (hasIn(this.formData, 'isShowPassword')) {
      this.isShowPassword = this.formData.isShowPassword
      if (this.isShowPassword === true) {
        this.useLocalValue = true
        this.showPassword()
      }
    }
  },
  methods: {
    resetPassword () {
      this.isShowEditModal = true
    },
    confirm () {
      this.$refs.form.validate(vail => {
        if (vail) {
          this.handleInput()
          this.useLocalValue = true
        }
      })
    },
    async handleInput () {
      this.panalData[this.formData.propertyName] = this.editFormData.newPassword
      this.realPassword = this.editFormData.newPassword
      this.editFormData = {
        newPassword: '',
        comparedPassword: ''
      }
      this.isShowEditModal = false
      // 修改过的密码，需要加密处理
      this.$emit('encryptPassword', {
        key: this.formData.propertyName,
        value: this.panalData[this.formData.propertyName],
        index: this.index
      })
    },
    closeEditModal () {
      this.isShowEditModal = false
      this.editFormData = {
        newPassword: '',
        comparedPassword: ''
      }
    },
    async showPassword () {
      if (this.useLocalValue || !this.panalData.guid) {
        this.realPassword = this.panalData[this.formData.propertyName]
      } else {
        const { statusCode, data } = await queryPassword(
          this.formData.ciTypeId,
          this.panalData.guid,
          this.formData.propertyName,
          {}
        )
        if (statusCode === 'OK') {
          this.realPassword = data
        }
      }
    }
  }
}
</script>

<style scoped lang="scss">
.operation-icon-confirm {
  font-size: 16px;
  border: 1px solid #57a3f3;
  color: #57a3f3;
  border-radius: 4px;
  width: 24px;
  line-height: 24px;
  cursor: pointer;
}
.password-wrapper {
  text-overflow: ellipsis;
  overflow: hidden;
  width: 200px;
  white-space: nowrap;
  line-height: 1.5;
}
</style>
<style>
.encrypt-password .ivu-input-suffix {
  display: none;
}
.cmdb-password-modal .ivu-form-item {
  margin-bottom: 20px;
}
</style>
