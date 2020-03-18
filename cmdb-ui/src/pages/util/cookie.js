export const setCookie = tokens => {
  tokens.forEach(_ => {
    document.cookie = `${_.tokenType}=${_.token};path=/`
    document.cookie = `${_.tokenType}ExpirationTime=${_.expiration};path=/`
  })
}

export const getCookie = name => {
  // eslint-disable-next-line no-useless-escape
  const reg = new RegExp('(?:(?:^|.*;\\s*)' + name + '\\s*\\=\\s*([^;]*).*$)|^.*$')
  return document.cookie.replace(reg, '$1')
}
