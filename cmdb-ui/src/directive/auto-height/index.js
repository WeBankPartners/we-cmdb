import content from './content'
import Vue from 'vue'

const install = function (Vue) {
  Vue.directive('auto-height', content)
}

if (window.Vue) {
  window['auto-height'] = content
  Vue.use(install)
}

content.install = install
export default content
