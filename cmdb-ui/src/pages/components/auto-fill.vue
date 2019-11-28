<template>
  <div class="auto_fill">
    <Poptip v-model="optionsHide" placement="bottom">
      <div class="input_in">
        <textarea
          ref="textarea"
          :rows="2"
          @input="inputHandler"
          :value="inputVal"
          :disabled="disabled"
        ></textarea>
      </div>
      <div slot="content">
        <div class="attr-ul">
          <ul v-for="opt in allCi" :key="opt.ciTypeId">
            <li @click="selectCiType(opt)">{{ opt.name }}</li>
          </ul>
          <ul v-for="opt in attrNameArray" :key="opt.attrId">
            <li @click="selectAttr(opt)">
              {{
                (opt.inputType === "ref" || opt.inputType === "multiRef")
                  ? `( ${opt.ciTypeAttrName} ) ${opt.ciTypeName}`
                  : opt.ciTypeAttrName
              }}
            </li>
          </ul>
          <ul v-if="isShowSelect" v-for="item in enumCodes" :key="item">
            <li @click="selectEnumCode(item)">{{ item }}</li>
          </ul>
        </div>
      </div>
    </Poptip>
  </div>
</template>

<script>
import { getRefCiTypeFrom, getCiTypeAttr } from "@/api/server.js";
export default {
  data() {
    return {
      optionsHide: false,
      options: [],
      inputVal: "",
      optests: [],
      routine: [],
      allCi: [],
      attrNameArray: [],
      isShowSelect: false,
      enumCodes: ["id", "code", "value", "groupCodeId"],
      autoFillArray: [],
      inputRuleStatus: 1 // 0 - 花括号内 ; 1 - 花括号外
    };
  },
  props: {
    allLayers: {
      required: true,
      default: []
    },
    disabled: {
      required: false,
      default: false
    },
    value: {
      required: true,
      default: ""
    },
    rootCiTypeId: {
      required: false
    }
  },
  computed: {
    allCiTypes() {
      let result = [];
      this.allLayers.forEach(layer => {
        if (layer.ciTypes instanceof Array) {
          result = result.concat(layer.ciTypes);
        }
      });
      return result;
    },
    ciTypesObj() {
      let obj = {};
      this.allCiTypes.forEach(_ => {
        obj[_.ciTypeId] = _;
      });
      return obj;
    },
    ciTypeAttrsObj() {
      let obj = {};
      this.allCiTypes.forEach(ciType => {
        ciType.attributes.forEach(attr => {
          obj[attr.ciTypeAttrId] = attr;
        });
      });
      return obj;
    },
    autoFillLastObjValue() {
      return this.autoFillArray[this.autoFillArray.length - 1].value;
    }
  },
  watch: {
    optionsHide() {
      let doms = document.getElementsByClassName("attr-ul");
      for (let i = 0; i < doms.length; i++) {
        doms[i].style.width = this.$refs.textarea.clientWidth + "px";
      }
    },
    allCiTypes() {
      this.displayInputData();
    }
  },
  mounted() {
    this.displayInputData();
  },
  methods: {
    inputHandler(v) {
      if (this.inputRuleStatus === 1) {
        const rule = /[\/\\\-_a-zA-Z0-9]{1}/;
        if (v.data) {
          if (rule.test(v.data)) {
            this.inputVal = this.$refs.textarea.value;
            if (this.autoFillArray.length) {
              this.setAutoData();
            } else {
              this.autoFillArray.push({
                type: "delimiter",
                value: this.inputVal
              });
            }
            this.$emit("input", JSON.stringify(this.autoFillArray));
          } else if (v.data === "{") {
            if (this.rootCiTypeId) {
              this.inputVal =
                this.$refs.textarea.value +
                " " +
                this.ciTypesObj[this.rootCiTypeId].name +
                " ";
              const val = [
                {
                  ciTypeId: this.rootCiTypeId
                }
              ];
              this.autoFillArray.push({
                type: "rule",
                value: JSON.stringify(val)
              });
            } else {
              this.inputVal = this.$refs.textarea.value + " ";
              this.allCi = this.allCiTypes;
              this.optionsHide = true;
              this.autoFillArray.push({ type: "rule", value: "" });
            }
            this.inputRuleStatus = 0;
          } else {
            this.$refs.textarea.value = this.inputVal;
            this.$Message.error({
              content: this.$t("auto_fill_legitimate_character_tips")
            });
          }
        } else if (v.inputType === "deleteContentBackward") {
          if (this.autoFillLastObjValue.length) {
            this.inputVal = this.inputVal.substr(0, this.inputVal.length - 1);
            this.setAutoData();
          } else {
            this.autoFillArray.splice(-2, 2);
            this.inputVal = this.inputVal.substr(
              0,
              this.inputVal.lastIndexOf("{")
            );
          }
          if (this.inputVal) {
            this.$emit("input", JSON.stringify(this.autoFillArray));
          } else {
            this.autoFillArray = [];
            this.$emit("input", "");
          }
        } else {
          this.$refs.textarea.value = this.inputVal;
        }
      } else {
        if (v.data) {
          if (!this.autoFillLastObjValue) {
            this.$refs.textarea.value = this.inputVal;
            this.$Message.error({
              content: this.$t("please_select_ci_type")
            });
          } else {
            const objList = JSON.parse(this.autoFillLastObjValue);
            const obj = objList[objList.length - 1];
            if (
              !obj.parentRs ||
              this.ciTypeAttrsObj[obj.parentRs.attrId].inputType === "ref" || this.ciTypeAttrsObj[obj.parentRs.attrId].inputType === "multiRef"
            ) {
              if (v.data === "." || v.data === "-") {
                if (
                  this.inputVal[this.inputVal.length - 1] === "." ||
                  this.inputVal[this.inputVal.length - 1] === "-"
                ) {
                  this.inputVal = this.inputVal.replace(/.$/, v.data);
                } else {
                  this.inputVal = this.$refs.textarea.value;
                }
                this.optionsHide = true;
                this.getNextRef(v.data);
              } else {
                this.$refs.textarea.value = this.inputVal;
                this.$Message.error({
                  content: this.$t(
                    "auto_fill_legitimate_operation_character_tips"
                  )
                });
              }
            } else if (
              !obj.parentRs ||
              ((this.ciTypeAttrsObj[obj.parentRs.attrId].inputType === "select" || this.ciTypeAttrsObj[obj.parentRs.attrId].inputType === "multiSelect") &&
                !obj.enumCodeAttr)
            ) {
              this.$refs.textarea.value = this.inputVal;
              this.$Message.error({
                content: this.$t("please_select_enum")
              });
            } else {
              if (v.data === "}") {
                this.$emit("input", JSON.stringify(this.autoFillArray));
                this.autoFillArray.push({ type: "delimiter", value: "" });
                this.inputVal = this.$refs.textarea.value;
                this.inputRuleStatus = 1;
              } else {
                this.$refs.textarea.value = this.inputVal;
                this.$Message.error({
                  content: this.$t("auto_fill_close_rule_tips")
                });
              }
            }
          }
        } else if (v.inputType === "deleteContentBackward") {
          if (
            this.autoFillLastObjValue !== "[]" &&
            this.autoFillLastObjValue !== ""
          ) {
            let val = JSON.parse(this.autoFillLastObjValue);
            this.isShowSelect = false;
            if (this.rootCiTypeId && val.length === 1) {
              this.attrNameArray = [];
              this.optionsHide = false;
              this.autoFillArray.splice(-1, 1);
              this.inputVal = this.inputVal.substr(
                0,
                this.inputVal.lastIndexOf("{")
              );
              if (!this.inputVal) {
                this.autoFillArray = [];
                this.$emit("input", "");
              }
              this.inputRuleStatus = 1;
              this.optionsHide = false;
              return;
            }
            let lastAttrVal = "";
            const lastAttrObj = val[val.length - 1];
            const ciTypeName = this.ciTypesObj[lastAttrObj.ciTypeId].name;
            let ciTypeAttrName = "";
            if (lastAttrObj.parentRs) {
              const attrName = this.ciTypeAttrsObj[lastAttrObj.parentRs.attrId]
                .name;
              lastAttrVal +=
                lastAttrObj.parentRs.isReferedFromParent === 1 ? "." : "-";
              if (
                this.ciTypeAttrsObj[lastAttrObj.parentRs.attrId].inputType === "ref" || this.ciTypeAttrsObj[lastAttrObj.parentRs.attrId].inputType === "multiRef"
              ) {
                ciTypeAttrName = `(${attrName})${ciTypeName} `;
              } else {
                ciTypeAttrName = `${attrName} `;
              }
              lastAttrVal += ciTypeAttrName;
            } else {
              lastAttrVal += ciTypeName;
            }
            this.inputVal = this.inputVal.substr(
              0,
              this.inputVal.lastIndexOf(lastAttrVal)
            );
            val.splice(-1, 1);
            this.autoFillArray[
              this.autoFillArray.length - 1
            ].value = JSON.stringify(val);
            if (this.inputVal[this.inputVal.length - 2] === "{") {
              this.allCi = this.allCiTypes;
              this.optionsHide = true;
            } else {
              this.attrNameArray = [];
              this.optionsHide = false;
            }
          } else {
            this.autoFillArray.splice(-1, 1);
            this.inputVal = this.inputVal.substr(
              0,
              this.inputVal.lastIndexOf("{")
            );
            this.inputRuleStatus = 1;
            this.allCi = [];
            this.optionsHide = false;
            if (!this.inputVal) {
              this.$emit("input", "");
              this.autoFillArray = [];
            }
          }
        } else {
          this.$refs.textarea.value = this.inputVal;
        }
      }
    },
    setAutoData() {
      let val = this.inputVal.split(/[\{\}]/);
      this.autoFillArray[this.autoFillArray.length - 1].value =
        val[val.length - 1];
    },
    async getNextRef(operator) {
      const objList = JSON.parse(this.autoFillLastObjValue);
      const obj = objList[objList.length - 1];
      let attrArray = [];
      if (operator === ".") {
        let { statusCode, data, message } = await getCiTypeAttr(obj.ciTypeId);
        if (statusCode === "OK") {
          data.forEach(_ => {
            attrArray.push({
              ..._,
              ciTypeName:
                (_.inputType === "ref" || _.inputType === "multiRef")
                  ? this.allCiTypes.find(i => i.ciTypeId === _.referenceId).name
                  : this.allCiTypes.find(i => i.ciTypeId === _.ciTypeId).name,
              ciTypeAttrName: _.name,
              isReferedFromParent: 1,
              id: (_.inputType === "ref" || _.inputType === "multiRef") ? _.referenceId : _.ciTypeId
            });
          });
          this.attrNameArray = attrArray;
        }
      } else if (operator === "-") {
        let { statusCode, data, message } = await getRefCiTypeFrom(obj.ciTypeId);
        if (statusCode === "OK") {
          attrArray = data.map(_ => {
            return {
              ..._,
              ciTypeName: this.allCiTypes.find(i => i.ciTypeId === _.ciTypeId)
                .name,
              ciTypeAttrName: _.name,
              isReferedFromParent: 0,
              id: _.ciTypeId
            };
          });
          this.attrNameArray = attrArray;
        }
      }
    },
    selectCiType(opt) {
      this.optionsHide = false;
      this.autoFillArray[this.autoFillArray.length - 1].value = JSON.stringify([
        {
          ciTypeId: opt.ciTypeId
        }
      ]);
      this.inputVal += opt.name + " ";
      this.allCi = [];
      this.$refs.textarea.focus();
    },
    selectAttr(opt) {
      this.optionsHide = false;
      const val = {
        ciTypeId: opt.id,
        parentRs: {
          attrId: opt.ciTypeAttrId,
          isReferedFromParent: opt.isReferedFromParent
        }
      };
      let result = JSON.parse(this.autoFillLastObjValue);
      result.push(val);
      this.autoFillArray[this.autoFillArray.length - 1].value = JSON.stringify(
        result
      );
      this.inputVal +=
        (opt.inputType === "ref" || opt.inputType === "multiRef")
          ? `(${opt.ciTypeAttrName})${opt.ciTypeName} `
          : opt.ciTypeAttrName + " ";
      this.attrNameArray = [];
      this.$refs.textarea.focus();
      if (opt.inputType === "select" || opt.inputType ===  "multiSelect") {
        this.isShowSelect = true;
        this.optionsHide = true;
      }
    },
    selectEnumCode(code) {
      this.optionsHide = false;
      this.isShowSelect = false;
      this.inputVal += `.${code} `;
      let result = JSON.parse(this.autoFillLastObjValue);
      result[result.length - 1].enumCodeAttr = code;
      this.autoFillArray[this.autoFillArray.length - 1].value = JSON.stringify(
        result
      );
      this.$refs.textarea.focus();
    },
    displayInputData() {
      if (!this.allCiTypes.length || !this.value) {
        return;
      }
      this.inputVal = "";
      this.autoFillArray = JSON.parse(this.value);
      if (
        this.autoFillArray[this.autoFillArray.length - 1].type !== "delimiter"
      ) {
        this.autoFillArray.push({ type: "delimiter", value: "" });
      }
      this.autoFillArray.forEach(_ => {
        if (_.type === "delimiter") {
          this.inputVal += _.value;
        } else {
          let val = "{ ";
          let data = JSON.parse(_.value);
          data.forEach(item => {
            const ciTypeName = this.ciTypesObj[item.ciTypeId].name;
            if (item.parentRs) {
              const refType =
                item.parentRs.isReferedFromParent === 1 ? "." : "-";
              const attrName = this.ciTypeAttrsObj[item.parentRs.attrId].name;
              if (
                this.ciTypeAttrsObj[item.parentRs.attrId].inputType === "ref" || this.ciTypeAttrsObj[item.parentRs.attrId].inputType === "multiRef"
              ) {
                val += `${refType}(${attrName})${ciTypeName} `;
              } else if (
                this.ciTypeAttrsObj[item.parentRs.attrId].inputType === "select" || this.ciTypeAttrsObj[item.parentRs.attrId].inputType === "multiSelect"
              ) {
                val += `${refType}${attrName} .${item.enumCodeAttr} `;
              } else {
                val += `${refType}${attrName} `;
              }
            } else {
              val += ciTypeName + " ";
            }
          });
          val += "}";
          this.inputVal += val;
        }
      });
    }
  }
};
</script>

<style lang="scss">
.attr-ul {
  width: 100%;
  z-index: 3000;
  background: white;
  max-height: 200px;
  overflow: auto;
}
.auto_fill .ivu-poptip {
  width: 100%;
}
.auto_fill .ivu-poptip .ivu-poptip-rel {
  width: 100%;
}
.input_in {
  width: 100%;
}
.input_in textarea {
  font-size: 11px;
  line-height: 20px;
  width: 100%;
}
.attr-ul ul {
  width: 100%;
  border-radius: 3px;
}
.ul-li-selected {
  color: rgb(6, 130, 231);
}
.attr-ul ul li {
  width: 100%;
  height: 25px;
  line-height: 25px;
  cursor: pointer;
  &:hover {
    background-color: rgb(227, 231, 235);
  }
}
</style>
