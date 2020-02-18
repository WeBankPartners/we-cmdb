<template>
  <div class="ci-password">
    <div v-if="isEdit">
      <Button @click="showEditModal" type="primary">{{ $t('password_edit') }}</Button>
    </div>
    <div v-else>
      <span>******</span>
      <a @click="showPassword">{{ $t('show') }}</a>
    </div>
    <!-- 密码编辑弹框 -->
    <Modal v-model="isShowEditModal" :title="$t('password_edit')" @on-ok="confirm" @on-cancel="closeEditModal">
      <Form :model="formData" :rules="rules" label-position="right" :label-width="120">
        <FormItem :label="$t('new_password')" prop="newPassword">
          <Input
            password
            :placeholder="$t('new_password_input_placeholder')"
            ref="newPasswordInput"
            type="password"
            v-model="formData.newPassword"
            @on-enter="inputFocus"
          />
        </FormItem>
        <FormItem :label="$t('confirm_password')" prop="comparedPassword">
          <Input
            password
            :placeholder="$t('please_input_new_password_again')"
            ref="comparedPasswordInput"
            type="password"
            v-model="formData.comparedPassword"
            @on-enter="confirm"
          />
        </FormItem>
      </Form>
    </Modal>
    <!-- 密码显示弹框 -->
    <Modal v-model="isShowPasswordModal" :title="$t('password')" @on-cancel="closePassword">
      <div class="ci-password-span">{{ password }}</div>
      <div slot="footer">
        <Button @click="closePassword">{{ $t('close') }}</Button>
      </div>
    </Modal>
  </div>
</template>

<script>
export default {
  props: {
    isEdit: false,
    guid: '',
    propertyName: ''
  },
  data () {
    return {
      isShowEditModal: false,
      isShowPasswordModal: false,
      password: '',
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
      // const { data, statusCode } = await editPassword({guid: this.guid, propertyName: this.propertyName, newPassword: this.formData.newPassword})
      // if (statusCode === 'OK') {
      //   this.password = data
      //   this.isShowEditModal = false
      // }
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
      // TODO
      // const { data, statusCode } = await getPassword({guid: this.guid, propertyName: this.propertyName})
      // if (statusCode === 'OK') {
      //   this.password = data
      // }
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
