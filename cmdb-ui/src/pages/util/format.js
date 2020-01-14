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
      if (typeof _['weTableForm'][i] === 'object' && _['weTableForm'][i] !== null) {
        _['weTableForm'][i] = _[i].value || _[i].key_name
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
