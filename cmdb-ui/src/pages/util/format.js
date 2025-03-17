import Vue from 'vue'
import { pluginI18n } from '../../const/plugin-i18n'
export const formatData = data => {
  let exportData = []
  exportData = data.map((_, index) => {
    return {
      ..._,
      weTableForm: { ..._ }
    }
  })

  exportData.forEach(_ => {
    for (let i in _['weTableForm']) {
      let tmp = _['weTableForm'][i]
      if (typeof tmp === 'object' && tmp !== null) {
        if (Array.isArray(tmp)) {
          const tmpArr = tmp.map(t => t.guid || t.value || t.key_name || t)
          _['weTableForm'][i] = tmpArr.join(',')
        } else {
          _['weTableForm'][i] = _[i].guid || _[i].value || _[i].key_name || _[i]
        }
      }
    }
  })
  return exportData.map(_ => _.weTableForm)
}

export const formatString = (str, ...v) => {
  v.forEach((_, i) => {
    str = str.replace(new RegExp(`\\{${i}\\}`, 'g'), _)
  })
  return str
}

export const normalizeFormData = formData => {
  let copyForm = JSON.parse(JSON.stringify(formData))
  delete copyForm.isRowEditable
  delete copyForm.nextOperations
  delete copyForm._nextOperations
  delete copyForm.weTableForm
  delete copyForm._id
  const keys = Object.keys(copyForm)
  keys.forEach(key => {
    if (Array.isArray(copyForm[key])) {
      const guidGroup = copyForm[key].map(arr => {
        if (typeof copyForm[key] === 'object') {
          return arr.guid
        } else {
          return arr
        }
      })
      copyForm[key] = guidGroup.join(',')
    } else if (copyForm[key] === null) {
    } else if (typeof copyForm[key] === 'string') {
    } else if (typeof copyForm[key] === 'number') {
    } else if (typeof copyForm[key] === 'object') {
      if (copyForm[key].__meta !== 'json') {
        copyForm[key] = copyForm[key].guid
      } else {
        delete copyForm[key].__meta
      }
    }
  })
  return copyForm
}

const formatDateToString = () => {
  const date = new Date()
  const monthNames = [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ]
  const year = date.getFullYear() // 4位数的年份
  const month = date.getMonth() + 1 // 月份，从0开始，所以加1
  const day = date.getDate() // 日期
  const hours = date.getHours() // 小时
  const minutes = date.getMinutes() // 分钟
  const seconds = date.getSeconds() // 秒数

  const formatNumber = n => (n < 10 ? '0' + n : n)
  const lang = localStorage.getItem('lang') || navigator.language
  const formattedZHDate = `${year}/${formatNumber(month)}/${formatNumber(day)} ${formatNumber(hours)}:${formatNumber(
    minutes
  )}:${formatNumber(seconds)}`
  const formattedENDate = `${monthNames[month]} ${day}, ${year} ${formatNumber(hours)}:${formatNumber(
    minutes
  )}:${formatNumber(seconds)}`
  return lang === 'zh-CN' ? formattedZHDate : formattedENDate
}

const useI18n = str => (window.vm ? pluginI18n(str) : pluginI18n(str))

export const intervalTips = h => {
  return h(
    'div',
    {
      style: {
        marginLeft: '10px'
      }
    },
    [
      h('div', useI18n('db_table_refresh_success')),
      h(
        'div',
        {
          style: {
            marginTop: '5px'
          }
        },
        useI18n('db_time') + ':' + formatDateToString()
      )
    ]
  )
}
