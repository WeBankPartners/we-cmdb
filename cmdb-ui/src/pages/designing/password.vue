<template>
  <div>
    <div>
      <template v-if="panalData[formData.propertyName]">
        <span>******</span>
        <Icon type="ios-eye-outline" v-if="!disabled" @click="showPassword" class="operation-icon-confirm" />
        <Icon type="ios-build-outline" v-if="!disabled" @click="resetPassword" class="operation-icon-confirm" />
      </template>
      <template v-else>
        <Icon type="ios-add" @click="addPassword" class="operation-icon-confirm" />
      </template>
    </div>
    <Modal v-model="isShowPassword" :title="$t('password')">
      <p>{{ realPassword }}</p>
    </Modal>
    <Modal v-model="isShowEditModal" :title="isNewAddedRow ? $t('enter_password') : $t('password_edit')">
      <Form ref="form" :model="editFormData" :rules="rules" label-position="right" :label-width="120">
        <FormItem v-if="!isNewAddedRow" :label="$t('old_password')" prop="newPassword">
          <Input
            password
            :placeholder="$t('old_password_input_placeholder')"
            ref="oldPasswordInput"
            type="password"
            v-model="editFormData.originalValue"
          />
        </FormItem>
        <FormItem :label="isNewAddedRow ? $t('password') : $t('new_password')" prop="newPassword">
          <Input
            password
            :placeholder="$t('new_password_input_placeholder')"
            ref="newPasswordInput"
            type="password"
            v-model="editFormData.newPassword"
          />
        </FormItem>
        <FormItem :label="isNewAddedRow ? $t('confirm_password') : $t('confirm_password')" prop="comparedPassword">
          <Input
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
          isNewAddedRow ? $t('confirm') : $t('save')
        }}</Button>
        <Button @click="closeEditModal">{{ $t('close') }}</Button>
      </div>
    </Modal>
  </div>
</template>

<script>
import { updatePassword, queryPassword } from '@/api/server'
export default {
  name: '',
  data () {
    return {
      realPassword: '',
      isShowPassword: false,

      isShowEditModal: false,
      editFormData: {
        originalValue: '',
        newPassword: '',
        comparedPassword: ''
      },
      modalLoading: false,
      rules: {
        comparedPassword: [
          {
            message: this.$t('please_input_right_new_password'),
            validator: () => this.editFormData.newPassword === this.editFormData.comparedPassword
          }
        ]
      }
    }
  },
  props: ['formData', 'panalData', 'isNewAddedRow', 'disabled'],
  methods: {
    addPassword () {
      this.isShowEditModal = true
    },
    resetPassword () {
      this.isShowEditModal = true
    },
    confirm () {
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
      this.panalData[this.formData.propertyName] = this.editFormData.newPassword
      this.editFormData = {
        originalValue: '',
        newPassword: '',
        comparedPassword: ''
      }
      this.isShowEditModal = false
    },
    async updatePassword () {
      this.modalLoading = true
      if (this.isNewAddedRow) {
        this.handleInput()
        this.isShowPassword = true
        return
      }
      const payload = {
        guid: this.panalData.guid,
        field: this.formData.propertyName,
        value: this.editFormData.newPassword,
        originalValue: this.editFormData.originalValue
      }
      const { statusCode } = await updatePassword(this.formData.ciTypeId, payload)
      this.editFormData = {
        originalValue: '',
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
      this.editFormData = {
        originalValue: '',
        newPassword: '',
        comparedPassword: ''
      }
    },
    async showPassword () {
      if (this.isNewAddedRow) {
        this.realPassword = this.panalData[this.formData.propertyName]
        this.isShowPassword = true
        return
      }
      const { statusCode, data } = await queryPassword(
        this.formData.ciTypeId,
        this.panalData.guid,
        this.formData.propertyName
      )
      if (statusCode === 'OK') {
        this.realPassword = data
        this.isShowPassword = true
      }
    }
  },
  mounted () {}
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
  margin: 6px;
  cursor: pointer;
}
</style>
