export const getAccessToken = () => {
  let token = ''
  if (window.request) {
    token = localStorage.getItem('wecube-accessToken')
  } else {
    token = localStorage.getItem('taskman-accessToken')
  }
  return token
}

export const getRefreshToken = () => {
  let token = ''
  if (window.request) {
    token = localStorage.getItem('wecube-refreshToken')
  } else {
    token = localStorage.getItem('taskman-refreshToken')
  }
  return token
}
