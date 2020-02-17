import zhCN from '../locale/i18n/zh-CN.json'
import enUS from '../locale/i18n/en-US.json'
export const pluginI18n = key => {
  const navLang = navigator.language
  const localLang = window.localStorage.getItem('lang')
  const language = localLang || navLang || 'en-US'
  if (language === 'zh-CN') {
    return zhCN[key]
  } else {
    return enUS[key]
  }
}
