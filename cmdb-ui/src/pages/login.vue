<template>
  <div>
    <div class="body"></div>
    <div class="header-login">
      <div></div>
    </div>
    <br />
    <div class="login-form">
      <Input type="text" placeholder="username" v-model="username" name="user" @on-enter="login" />

      <Input
        type="password"
        password
        placeholder="password"
        v-model="password"
        name="password"
        @on-enter="login"
        style="margin-top: 20px"
      />
      <Button type="primary" long @click="login" :loading="loading" style="margin-top: 20px">
        Login
      </Button>
      <!-- <Button type="success" long>SUBMIT</Button> -->
    </div>
  </div>
</template>
<script>
import { login } from '../api/server'
import { setCookie } from './util/cookie'
export default {
  data () {
    return {
      username: '',
      password: '',
      loading: false
    }
  },
  methods: {
    async login () {
      let Base64 = require('js-base64').Base64
      if (!this.username || !this.password) return
      this.loading = true
      const payload = {
        username: this.username,
        password: Base64.encode(this.password)
      }
      const { statusCode, data } = await login(payload)
      if (statusCode === 'OK') {
        let localStorage = window.localStorage
        setCookie(data)
        localStorage.setItem('username', this.username)
        this.$router.push('/wecmdb/home')
      }
      this.loading = false
    },
    clearSession () {
      let localStorage = window.localStorage
      localStorage.removeItem('username')
      window.needReLoad = true
    }
  },
  created () {
    this.clearSession()
  }
}
</script>
<style scoped>
.body {
  position: absolute;
  width: 100%;
  height: 100%;
  background-image: url('../assets/bg.jpg');
  background-size: cover;
  -webkit-filter: blur(3px);
  z-index: 0;
}

.header-login {
  position: absolute;
  top: calc(50% - 35px);
  left: calc(50% - 355px);
  z-index: 2;
}

.header-login div {
  width: 600px;
  height: 50px;
  /* background-image: url('../assets/wecube-logo.png'); */
  background-size: contain;
  background-repeat: no-repeat;
}

.login-form {
  position: absolute;
  top: calc(50% - 75px);
  left: calc(50% - 50px);
  height: 150px;
  width: 230px;
  padding: 10px;
  z-index: 2;
  text-align: center;
}
</style>
