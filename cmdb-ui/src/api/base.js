import Vue from 'vue'
import axios from 'axios'
// import exportFile from '@/const/export-file'
import { setCookie, getCookie, clearCookie } from '../pages/util/cookie'

export const baseURL = '/wecmdb/api/v1'
export const req = axios.create({
  withCredentials: false,
  baseURL,
  timeout: 500000
})

const throwError = res => {
  Vue.prototype.$Notice.warning({
    title: 'Error',
    desc: (res.data && 'status:' + res.data.status + '<br/> message:' + res.data.message) || 'error',
    duration: 10
  })
}

req.interceptors.request.use(
  config => {
    return new Promise((resolve, reject) => {
      const lang = localStorage.getItem('lang') || 'zh-CN'
      if (lang === 'zh-CN') {
        config.headers['Accept-Language'] = 'zh-CN,zh;q=0.9,en;q=0.8'
      } else {
        config.headers['Accept-Language'] = 'en-US,en;q=0.9,zh;q=0.8'
      }
      const accessToken = getCookie('accessToken')
      if (accessToken && config.url !== '/auth/v1/api/login') {
        config.headers.Authorization = 'Bearer ' + accessToken
        resolve(config)
      } else {
        resolve(config)
      }
    })
  },
  error => {
    return Promise.reject(error)
  }
)

req.interceptors.response.use(
  res => {
    if (res.status === 200) {
      if (res.data.statusCode !== 'OK') {
        const errorMes = res.data.statusMessage
        Vue.prototype.$Notice.error({
          title: 'Error',
          desc: errorMes,
          duration: 0
        })
      }
      // if (
      //   res.headers['content-type'] === 'application/octet-stream' &&
      //   res.request.responseURL.includes('/platform/')
      // ) {
      //   exportFile(res)
      //   Vue.prototype.$Notice.info({
      //     title: 'Success',
      //     desc: '',
      //     duration: 10
      //   })
      //   return
      // }
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
  err => {
    const { response } = err
    if (response.status === 401 && err.config.url !== '/wecmdb/api/v1/login') {
      let refreshToken = getCookie('refreshToken')
      if (refreshToken.length > 0) {
        let refreshRequest = axios.get('/wecmdb/api/v1/refresh-token', {
          headers: {
            Authorization: 'Bearer ' + refreshToken
          }
        })
        return refreshRequest.then(
          resRefresh => {
            setCookie(resRefresh.data.data)
            // replace token with new one and replay request
            err.config.headers.Authorization = 'Bearer ' + getCookie('accessToken')
            err.config.url = err.config.url.replace('/wecmdb/api/v1', '')
            let retryRequest = axios(err.config)
            return retryRequest.then(
              res => {
                if (res.status === 200) {
                  // do request success again
                  if (res.data.status === 'ERROR') {
                    const errorMes = Array.isArray(res.data.data)
                      ? res.data.data.map(_ => _.message || _.errorMessage).join('<br/>')
                      : res.data.message
                    Vue.prototype.$Notice.warning({
                      title: 'Error',
                      desc: errorMes,
                      duration: 10
                    })
                  }
                  // if (
                  //   res.headers['content-type'] === 'application/octet-stream' &&
                  //   res.request.responseURL.includes('/platform/')
                  // ) {
                  //   exportFile(res)
                  //   Vue.prototype.$Notice.info({
                  //     title: 'Success',
                  //     desc: '',
                  //     duration: 10
                  //   })
                  //   return
                  // }
                  return res.data instanceof Array ? res.data : { ...res.data }
                } else {
                  return {
                    data: throwError(res)
                  }
                }
              },
              err => {
                const { response } = err
                return new Promise((resolve, reject) => {
                  resolve({
                    data: throwError(response)
                  })
                })
              }
            )
          },
          // eslint-disable-next-line handle-callback-err
          errRefresh => {
            clearCookie('refreshToken')
            window.location.href = window.location.origin + window.location.pathname + '#/login'
            return {
              data: {} // throwError(errRefresh.response)
            }
          }
        )
      } else {
        window.location.href = window.location.origin + window.location.pathname + '#/login'
        // if (response.config.url === '/auth/v1/api/login') {
        //   Vue.prototype.$Notice.warning({
        //     title: 'Error',
        //     desc: response.data.message || '401',
        //     duration: 10
        //   })
        // }
        // throwInfo(response)
        // return response
      }
    }

    return new Promise((resolve, reject) => {
      resolve({
        data: throwError(response)
      })
    })
  }
)

function setHeaders (obj) {
  Object.keys(obj).forEach(key => {
    req.defaults.headers.common[key] = obj[key]
  })
}

export default req

export { setHeaders }
