<template>
  <div>
    <span class="tech-sel-wrapper">
      <div
        ref="selectBox"
        :class="['select-box', { active: showClass.isActive }]"
        tabindex="-1"
        @blur="blur"
        @focus="focus"
        @mouseenter="hover"
        @mouseleave="
          () => {
            this.showClear = false
          }
        "
        :style="{ width: `${width}px` }"
      >
        <div class="tag-box">
          <span style="color: #c5c8ce" v-if="selectNodes.length < 1">{{ placeholder }}</span>
          <template v-for="(item, index) in selectNodes">
            <Tag
              :fade="false"
              closable
              :key="index"
              v-show="index < maxTagCount"
              @on-close="closeTag"
              :name="JSON.stringify(item)"
            >
              {{ item.title }}
            </Tag>
          </template>
          <Tag v-if="selectNodes.length > maxTagCount">+ {{ selectNodes.length - maxTagCount }}...</Tag>
        </div>
        <div v-if="clearable && showClear" class="clear-btn" @click="clear">
          <Icon type="ios-close-circle-outline" size="19" />
        </div>
        <div
          :class="['content-box', { 'fade-in': showClass.fadeIn }, { 'fade-out': showClass.fadeIn }]"
          ref="contentBox"
        >
          <div class="tree-box" ref="treeBox">
            <Tree :data="originData" multiple show-checkbox @on-check-change="setSelectNodes"></Tree>
          </div>
        </div>
      </div>
    </span>
  </div>
</template>

<script>
const contains = (parentNode, childNode) => {
  if (parentNode && childNode) return parentNode.contains(childNode)
  return false
}
export default {
  props: {
    maxTagCount: {},
    placeholder: {},
    data: {
      type: Array,
      default: null,
      required: true
    },
    searchable: {
      type: Boolean,
      default: false,
      required: false
    },
    clearable: {
      type: Boolean,
      default: false,
      required: false
    },
    width: {
      type: [String, Number],
      default: 300,
      required: false
    },
    value: {
      type: Array,
      default: null,
      required: true
    },
    pkey: {
      type: String,
      default: 'title',
      required: false
    }
  },
  data () {
    return {
      originData: [],
      selectNodes: [],
      keyWord: null,
      showClear: false,
      showClass: {
        isActive: false,
        fadeIn: false,
        fadeOut: false
      }
    }
  },
  watch: {
    data: {
      handler (val) {
        this.restoreData()
      }
    }
  },
  methods: {
    focus () {
      this.showClass.isActive = true
      this.showClass.fadeIn = true
    },
    blur ({ relatedTarget }) {
      switch (true) {
        case contains(this.$refs.inputBox, relatedTarget):
          break
        case contains(this.$refs.treeBox, relatedTarget):
          this.$refs.selectBox.focus()
          break
        default:
          this.showClass.isActive = false
          this.showClass.fadeIn = false
          this.showClass.fadeOut = true
      }
    },
    hover () {
      if (this.selectNodes.length > 0) this.showClear = true
    },
    clear () {
      this.selectNodes = []
      this.originData = this.resetTree(node => {
        delete node.checked
        delete node.indeterminate
      })
      this.setSelectNodes()
    },
    setSelectNodes () {
      let nodes = []
      this.traverseTree({ children: this.originData }, node => {
        if (node.checked || node.indeterminate) nodes.push(node)
      })
      this.selectNodes = nodes
      const ids = nodes.map(_ => _.guid)
      this.$emit('input', ids)
    },
    closeTag (event, value) {
      let curKey = JSON.parse(value)[this.pkey]
      this.originData = this.resetTree(node => {
        if (node.children && node.children.length > 0) {
          delete node.checked
          delete node.indeterminate
        } else if (node[this.pkey] === curKey) node.checked = false
      })
      this.setSelectNodes()
    },
    traverseTree (node, callBack, parentNode) {
      callBack && callBack(node, parentNode)
      if (node.children && node.children.length > 0) {
        for (let index in node.children) {
          this.traverseTree(node.children[index], callBack, node)
        }
      }
    },
    resetTree (callBack) {
      let cloneNode = JSON.parse(JSON.stringify(this.originData.length > 0 ? this.originData : this.data))
      this.traverseTree({ children: cloneNode }, callBack)
      return cloneNode
    },
    restoreData () {
      this.selectNodes = []
      this.originData = this.resetTree((node, parentNode) => {
        if (parentNode && parentNode[this.pkey]) {
          node.value = `${parentNode.value}/${node[this.pkey]}`
        } else {
          node.value = node[this.pkey]
        }
        if (this.value.includes(node['guid'])) {
          this.selectNodes.push(node)
          node.checked = true
        }
      })
    }
  },
  created () {
    this.restoreData()
    this.setSelectNodes()
  }
}
</script>

<style scoped lang="scss">
.tech-sel-wrapper {
  display: inline-block;
  text-align: left;
  .select-box {
    position: relative;
    min-height: 32px;
    border-radius: 5px;
    border: 1px solid #ccc;
    transition: 0.3s;
    .clear-btn {
      position: absolute;
      right: 10px;
      top: 8px;
      transition: 0.5s;
      cursor: pointer;
      &:hover {
        color: #f07649;
      }
    }
    .tag-box {
      width: 100%;
      padding: 5px;
      max-height: 300px;
      overflow-y: auto;
    }
    &:hover {
      border-color: #57a3f3;
    }
    &:focus,
    &.active {
      border-color: #57a3f3;
      box-shadow: 0 0 0 2px rgba(45, 140, 240, 0.2);
      outline: none;
    }
    .content-box {
      height: 0;
      background-color: #fff;
      position: absolute;
      z-index: 100;
      left: 0;
      top: 100%;
      margin-top: 5px;
      padding-left: 10px;
      box-shadow: rgba(0, 0, 0, 0.15) 0 2px 8px 0;
      width: 100%;
      max-height: 400px;
      overflow-y: auto;
      &.fade-out {
        animation: fade-out 0.5s forwards;
      }
      &.fade-in {
        animation: fade-in 0.3s forwards;
      }
      .input-box {
        padding-top: 5px;
        padding-right: 10px;
        text-align: right;
      }
    }
  }
}
@keyframes fade-in {
  0% {
    height: auto;
    opacity: 0;
  }
  100% {
    height: auto;
    opacity: 1;
  }
}
@keyframes fade-out {
  0% {
    height: auto;
    opacity: 1;
  }
  50% {
    opacity: 0;
  }
  100% {
    height: 0;
  }
}
</style>
