import Vue from 'vue'
import axios from 'axios'
export const baseURL = '/wecmdb/ui/v2'
export const req = axios.create({
  withCredentials: true,
  baseURL,
  timeout: 50000
})

const throwError = res => new Error(res.message || 'error')
req.interceptors.response.use(
  res => {
    if (res.status === 200) {
      if (res.data.statusCode.startsWith('ERR')) {
        const errorMes = Array.isArray(res.data.data) ? res.data.data.map(_ => _.errorMessage).join('<br/>') : res.data.statusMessage
        Vue.prototype.$Notice.error({
          title: 'Error',
          desc: errorMes,
          duration: 0
        })
      }
      if (!res.headers['username']) {
        window.location.href = '/wecmdb/logout'
      }
      return {
        ...res.data,
        user: res.headers['username'] || ' - '
      }
    } else {
      return {
        data: throwError(res)
      }
    }
  },
  error => {
    const { response } = error
    Vue.prototype.$Notice.error({
      title: 'error',
      desc: (response.data && 'status:' + response.data.status + '<br/> error:' + response.data.error + '<br/> message:' + response.data.message) || 'error'
    })
    return new Promise((resolve, reject) => {
      resolve({
        data: throwError(error)
      })
    })
  }
)

function setHeaders (obj) {
  Object.keys(obj).forEach(key => {
    req.defaults.headers.common[key] = obj[key]
  })
}

export { setHeaders }
