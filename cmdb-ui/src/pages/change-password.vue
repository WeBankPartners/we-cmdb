<template>
  <div id="changePassword">
    <Form ref="formValidate" :model="formItem" :label-width="120" :rules="ruleValidate">
      <FormItem :label="$t('old_password')" prop="oldPassword">
        <Input v-model="formItem.oldPassword" ref="oldPassword" type="password" class="input" :placeholder="$t('old_password_input_placeholder')" />
      </FormItem>
      <FormItem :label="$t('new_password')" prop="newPassword">
        <Input v-model="formItem.newPassword" type="password" class="input" :placeholder="$t('new_password_input_placeholder')" />
      </FormItem>
      <FormItem :label="$t('confirm_password')" prop="confimPassword">
        <Input v-model="formItem.confimPassword" type="password" class="input" :placeholder="$t('confirm_new_password_placeholder')" />
      </FormItem>
      <FormItem>
        <Button type="primary" @click="handleSubmit('formValidate')">{{ $t('confirm') }}</Button>
        <Button @click="handleReset('formValidate')" style="margin-left: 8px">{{ $t('cancel') }}</Button>
      </FormItem>
    </Form>
  </div>
</template>

<script>
import { editPassword } from '@/api/server.js'
export default {
  data () {
    return {
      formItem: {
        oldPassword: '',
        newPassword: '',
        confimPassword: ''
      },
      ruleValidate: {
        oldPassword: [{ required: true, message: this.$t('old_password_input_placeholder') }],
        newPassword: [{ required: true, message: this.$t('new_password_input_placeholder') }],
        confimPassword: [
          {
            required: true,
            message: this.$t('please_input_new_password_again')
          },
          { validator: this.checkNewPassword }
        ]
      }
    }
  },
  methods: {
    checkNewPassword (rule, value, callback) {
      if (value !== this.formItem.newPassword) {
        callback(new Error(this.$t('please_input_right_new_password')))
      } else {
        callback()
      }
    },
    handleSubmit (name) {
      this.$refs[name].validate(valid => {
        if (valid) {
          this.editPassword()
        } else {
          this.$Message.error('Fail!')
        }
      })
    },
    async editPassword () {
      const { statusCode } = await editPassword({
        password: this.formItem.oldPassword,
        newPassword: this.formItem.newPassword
      })
      if (statusCode === 'OK') {
        this.$Message.success(this.$t('reset_password_success'))
        this.$router.push('/homepage')
      }
    },
    handleReset (name) {
      this.$refs[name].resetFields()
    },
    focusOnInput () {
      this.$nextTick(() => {
        this.$refs['oldPassword'].focus()
      })
    }
  },
  mounted () {
    this.focusOnInput()
  }
}
</script>

<style lang="scss" scoped>
#changePassword {
  align-items: center;
  display: flex;
  height: 100%;
  justify-content: center;
  width: 100%;

  .input {
    margin-right: 120px;
    width: 200px;
  }
}
</style>
