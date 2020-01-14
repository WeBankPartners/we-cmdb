<template>
  <div>
    <Row>
      <Input class="input" :placeholder="$t('input_username_to_filter_user')" v-model="inputData" clearable />
    </Row>
    <Alert style="margin: 5px;">{{ $t('click_to_reset_password') }}</Alert>
    <Row>
      <Button class="user-button" v-for="user in filterUsers" :key="user.username" @click="() => selectUser(user)"
        >{{ user.username }}({{ user.description }})</Button
      >
    </Row>
    <Modal v-model="modalVisible" width="360" @on-ok="handleReset">
      <p slot="header" style="color:#f60;text-align:center">
        <Icon type="ios-information-circle"></Icon>
        <span>{{ $t('reset_password') }}</span>
      </p>
      <div style="text-align:center">
        <p style="font-size: 14px;">
          {{ resetPasswordTips }}
        </p>
      </div>
    </Modal>
  </div>
</template>

<script>
import { getAllUsers, resetPassword } from '@/api/server'
import { formatString } from '../util/format.js'

export default {
  data () {
    return {
      inputData: '',
      users: [],
      username: '',
      targetUser: {},
      modalVisible: false
    }
  },
  computed: {
    filterUsers () {
      const text = this.inputData.trim().toLowerCase()
      return this.users.filter(_ => _.username.toLowerCase().indexOf(text) >= 0 && _.username !== this.username)
    },
    resetPasswordTips () {
      return formatString(this.$t('whether_reset_or_not'), this.targetUser.username)
    }
  },
  methods: {
    async getAllUsers () {
      const { statusCode, data, user } = await getAllUsers()
      if (statusCode === 'OK') {
        this.username = user
        this.users = data.map(_ => {
          return {
            id: _.userId,
            username: _.username,
            fullName: _.fullName,
            description: _.description,
            checked: false,
            color: '#5cadff'
          }
        })
      }
    },
    selectUser (user) {
      this.targetUser = user
      this.modalVisible = true
    },
    async handleReset () {
      const { statusCode, data } = await resetPassword({
        username: this.targetUser.username
      })
      if (statusCode === 'OK') {
        this.modalVisible = false
        this.$Modal.info({
          title: formatString(this.$t('save_password_please'), this.targetUser.username, this.targetUser.description),
          content: data
        })
      }
    }
  },
  mounted () {
    this.getAllUsers()
  }
}
</script>

<style lang="scss" scoped>
.input {
  margin: 5px;
  width: 200px;
}
.user-button {
  margin: 5px;
}
</style>
