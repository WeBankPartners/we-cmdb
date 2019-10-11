<template>
  <div>
    <Row>
      <Input
        class="input"
        placeholder="输入用户名过滤用户"
        v-model="inputData"
        clearable
      />
    </Row>
    <Alert style="margin: 5px;">点击用户名为其重置密码</Alert>
    <Row>
      <Button
        class="user-button"
        v-for="user in filterUsers"
        :key="user.username"
        @click="() => selectUser(user.username)"
        >{{ user.username }}({{ user.description }})</Button
      >
    </Row>
    <Modal v-model="modalVisible" width="360" @on-ok="handleReset">
      <p slot="header" style="color:#f60;text-align:center">
        <Icon type="ios-information-circle"></Icon>
        <span>重置密码</span>
      </p>
      <div style="text-align:center">
        <p style="font-size: 14px;">
          是否重置
          <span style="font-weight: 600;">{{ targetUser }} </span>的密码
        </p>
      </div>
    </Modal>
  </div>
</template>

<script>
import { getAllUsers, resetPassword } from "@/api/server";

export default {
  data() {
    return {
      inputData: "",
      users: [],
      username: "",
      targetUser: "",
      modalVisible: false
    };
  },
  computed: {
    filterUsers() {
      const text = this.inputData.trim().toLowerCase();
      return this.users.filter(
        _ =>
          _.username.toLowerCase().indexOf(text) >= 0 &&
          _.username !== this.username
      );
    }
  },
  methods: {
    async getAllUsers() {
      const { status, data, message, user } = await getAllUsers();
      if (status === "OK") {
        this.username = user;
        this.users = data.map(_ => {
          return {
            id: _.userId,
            username: _.username,
            fullName: _.fullName,
            description: _.description,
            checked: false,
            color: "#5cadff"
          };
        });
      }
    },
    selectUser(username) {
      this.targetUser = username;
      this.modalVisible = true;
    },
    async handleReset() {
      const { status, data, message } = await resetPassword({
        username: this.targetUser
      });
      if (status === "OK") {
        this.modalVisible = false;
        this.$Modal.info({
          title: `请保存 ${this.targetUser} 的新密码`,
          content: data
        });
      }
    }
  },
  mounted() {
    this.getAllUsers();
  }
};
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
