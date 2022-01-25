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
