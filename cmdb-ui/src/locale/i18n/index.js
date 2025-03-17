import Vue from 'vue'
import VueI18n from 'vue-i18n'

import zh from 'view-design/dist/locale/zh-CN'
import en from 'view-design/dist/locale/en-US'

import ZH from './zh-CN.json'
import EN from './en-US.json'

Vue.use(VueI18n)

const messages = {
  'zh-CN': { ...zh, ...ZH },
  'en-US': { ...en, ...EN }
}

const i18n = new VueI18n({
  locale:
    localStorage.getItem('lang') || (navigator.language || navigator.userLanguage === 'zh-CN' ? 'zh-CN' : 'en-US'),
  fallbackLocale: 'en-US',
  messages
})

export default i18n
