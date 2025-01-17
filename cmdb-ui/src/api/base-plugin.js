import Vue from 'vue'
import { pluginI18n } from '../const/plugin-i18n'

export const pluginErrorMessage = async r => {
  const res = await r
  if (res.statusCode !== 'OK') {
    let errorMes = res.statusMessage
    if (errorMes && errorMes.indexOf('update_time is diff with database') !== -1) {
      errorMes = window.vm ? pluginI18n('db_update_error_tips') : Vue.t('db_update_error_tips')
    }
    window.vm &&
      window.vm.$Notice.error({
        title: 'Error',
        desc: errorMes,
        duration: 0
      })
  }
  return r
}
