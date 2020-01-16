export const pluginErrorMessage = async r => {
  const res = await r
  if (res.statusCode.startsWith('ERR')) {
    const errorMes = Array.isArray(res.data) ? res.data.map(_ => _.errorMessage).join('<br/>') : res.statusMessage
    window.vm &&
      window.vm.$Notice.error({
        title: 'Error',
        desc: errorMes,
        duration: 0
      })
  }
  return r
}
