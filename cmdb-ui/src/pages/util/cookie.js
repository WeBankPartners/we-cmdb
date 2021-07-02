function setCookie (tokens) {
  tokens.forEach(_ => {
    document.cookie = `${_.tokenType}=${_.token};path=/`
    document.cookie = `${_.tokenType}ExpirationTime=${_.expiration};path=/`
  })
}

function getCookie (name) {
  // eslint-disable-next-line no-useless-escape
  const reg = new RegExp('(?:(?:^|.*;\\s*)' + name + '\\s*\\=\\s*([^;]*).*$)|^.*$')
  return document.cookie.replace(reg, '$1')
}

function clearCookie (name) {
  document.cookie = `${name}=;path=/`
}
function clearAllCookie () {
  // eslint-disable-next-line no-useless-escape
  var keys = document.cookie.match(/[^ =;]+(?=\=)/g)
  if (keys) {
    for (var i = keys.length; i--;) {
      document.cookie = keys[i] + '=0;expires=' + new Date(0).toUTCString()
    }
  }
}

export { setCookie, getCookie, clearCookie, clearAllCookie }
