export const pluginErrorMessage = async r => {
  const res = await r
  if (res.statusCode !== 'OK') {
    const errorMes = res.statusMessage
    window.vm &&
      window.vm.$Notice.error({
        title: 'Error',
        desc: errorMes,
        duration: 0
      })
  }
  return r
}
