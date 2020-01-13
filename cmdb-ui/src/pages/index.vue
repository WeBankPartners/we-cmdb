<template>
  <div id="cmdb">
    <div class="header">
      <Header @allMenus="allMenus" />
    </div>
    <div class="content-container">
      <Breadcrumb style="margin: 10px 0;" v-if="isShowBreadcrum && !isSetting">
        <BreadcrumbItem to="/">{{ $t('home') }}</BreadcrumbItem>
        <BreadcrumbItem>{{ parentBreadcrumb }}</BreadcrumbItem>
        <BreadcrumbItem>{{ childBreadcrumb }}</BreadcrumbItem>
      </Breadcrumb>
      <transition name="fade" mode="out-in">
        <router-view class="pages"></router-view>
      </transition>
    </div>
  </div>
</template>

<script>
import Header from './components/header'
import { MENUS } from '../const/menus.js'
export default {
  components: {
    Header
  },
  data () {
    return {
      isShowBreadcrum: true,
      allMenusAry: [],
      parentBreadcrumb: '',
      childBreadcrumb: '',
      isSetting: this.$route.path.startsWith('/setting')
    }
  },
  methods: {
    allMenus (data) {
      this.allMenusAry = data
    },
    setBreadcrumb () {
      if (this.$route.path === '/homepage' || this.$route.path === '/404') {
        this.isShowBreadcrum = false
        return
      }
      if (this.$route.path === '/comingsoon') {
        this.parentBreadcrumb = '-'
        this.childBreadcrumb = 'Coming Soon'
        return
      }
      let currentLangKey = localStorage.getItem('lang') || navigator.language
      const menuObj = MENUS.find(m => m.link === this.$route.path)
      if (menuObj) {
        this.allMenusAry.forEach(_ => {
          _.submenus.forEach(sub => {
            if (menuObj.code === sub.code) {
              this.parentBreadcrumb = currentLangKey === 'zh-CN' ? _.cnName : _.enName
            }
          })
        })
        this.childBreadcrumb = currentLangKey === 'zh-CN' ? menuObj.cnName : menuObj.enName
      } else {
        this.parentBreadcrumb = '-'
        this.childBreadcrumb = this.$route.path.substr(1)
      }
    }
  },
  mounted () {},
  watch: {
    allMenusAry: {
      handler (val) {
        this.setBreadcrumb()
      },
      immediate: true
    }
  }
}
</script>

<style lang="scss" scoped>
#cmdb {
  height: 100%;
}
.header {
  width: 100%;
  background-color: #515a6e;
  display: block;
}
.content-container {
  height: calc(100% - 50px);
  padding: 5px 30px;
}

.ivu-breadcrumb {
  color: #515a6e;
}
</style>
