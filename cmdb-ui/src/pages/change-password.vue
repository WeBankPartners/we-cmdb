<template>
  <div id="changePassword">
    <Form
      ref="formValidate"
      :model="formItem"
      :label-width="120"
      :rules="ruleValidate"
    >
      <FormItem label="旧密码" prop="oldPassword">
        <Input
          v-model="formItem.oldPassword"
          ref="oldPassword"
          type="password"
          class="input"
          placeholder="请输入原密码"
        />
      </FormItem>
      <FormItem label="新密码" prop="newPassword">
        <Input
          v-model="formItem.newPassword"
          type="password"
          class="input"
          placeholder="请输入新密码"
        />
      </FormItem>
      <FormItem label="确认密码" prop="confimPassword">
        <Input
          v-model="formItem.confimPassword"
          type="password"
          class="input"
          placeholder="请确认新密码"
        />
      </FormItem>
      <FormItem>
        <Button type="primary" @click="handleSubmit('formValidate')"
          >确认</Button
        >
        <Button @click="handleReset('formValidate')" style="margin-left: 8px"
          >取消</Button
        >
      </FormItem>
    </Form>
  </div>
</template>

<script>
import { editPassword } from "@/api/server.js";
export default {
  data() {
    return {
      formItem: {
        oldPassword: "",
        newPassword: "",
        confimPassword: ""
      },
      ruleValidate: {
        oldPassword: [{ required: true, message: "请输入原密码" }],
        newPassword: [{ required: true, message: "请输入新密码" }],
        confimPassword: [
          { required: true, message: "请再次输入新密码" },
          { validator: this.checkNewPassword }
        ]
      }
    };
  },
  methods: {
    checkNewPassword(rule, value, callback) {
      if (value !== this.formItem.newPassword) {
        callback(new Error("请输入与新密码相同的值"));
      } else {
        callback();
      }
    },
    handleSubmit(name) {
      this.$refs[name].validate(valid => {
        if (valid) {
          this.editPassword();
        } else {
          this.$Message.error("Fail!");
          return;
        }
      });
    },
    async editPassword() {
      const { status, data, message } = await editPassword({
        password: this.formItem.oldPassword,
        newPassword: this.formItem.newPassword
      });
      if (status === "OK") {
        this.$Message.success("密码重设成功！");
        this.$router.push("/homepage");
      }
    },
    handleReset(name) {
      this.$refs[name].resetFields();
    },
    focusOnInput() {
      this.$nextTick(() => {
        this.$refs["oldPassword"].focus();
      });
    }
  },
  mounted() {
    this.focusOnInput();
  }
};
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
