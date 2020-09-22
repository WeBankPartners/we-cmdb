function has (browser) {
  const ua = navigator.userAgent
  if (browser === 'ie') {
    const isIE = ua.indexOf('compatible') > -1 && ua.indexOf('MSIE') > -1
    if (isIE) {
      const reIE = new RegExp('MSIE (\\d+\\.\\d+);')
      reIE.test(ua)
      return parseFloat(RegExp['$1'])
    } else {
      return false
    }
  } else {
    return ua.indexOf(browser) > -1
  }
}

function _isIE11 () {
  let iev = 0
  const ieold = /MSIE (\d+\.\d+);/.test(navigator.userAgent)
  const trident = !!navigator.userAgent.match(/Trident\/7.0/)
  const rv = navigator.userAgent.indexOf('rv:11.0')

  if (ieold) {
    iev = Number(RegExp.$1)
  }
  if (navigator.appVersion.indexOf('MSIE 10') !== -1) {
    iev = 10
  }
  if (trident && rv !== -1) {
    iev = 11
  }

  return iev === 11
}

function _isEdge () {
  return /Edge/.test(navigator.userAgent)
}

function _getDownloadUrl (text) {
  const BOM = '\uFEFF'
  // Add BOM to text for open in excel correctly
  if (window.Blob && window.URL && window.URL.createObjectURL) {
    const csvData = new Blob([BOM + text], { type: 'text/csv' })
    return URL.createObjectURL(csvData)
  } else {
    return 'data:attachment/csv;charset=utf-8,' + BOM + encodeURIComponent(text)
  }
}

export const download = (filename, text) => {
  if (has('ie') && has('ie') < 10) {
    // has module unable identify ie11 and Edge
    const oWin = window.top.open('about:blank', '_blank')
    oWin.document.charset = 'utf-8'
    oWin.document.write(text)
    oWin.document.close()
    oWin.document.execCommand('SaveAs', filename)
    oWin.close()
  } else if (has('ie') === 10 || _isIE11() || _isEdge()) {
    const BOM = '\uFEFF'
    const csvData = new Blob([BOM + text], { type: 'text/csv' })
    navigator.msSaveBlob(csvData, filename)
  } else {
    const link = document.createElement('a')
    link.download = filename
    link.href = _getDownloadUrl(text)
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
  }
}

const newLine = '\r\n'
const appendLine = (content, row, { separator, quoted }) => {
  const line = row.map(data => {
    if (!quoted) return data
    // quote data
    data = typeof data === 'string' ? data.replace(/"/g, '""') : data
    return `"${data}"`
  })
  content.push(line.join(separator))
}

const defaultOptions = {
  separator: ',',
  quoted: true
}

export const dataToCsv = (columns, datas, options, noHeader = false) => {
  options = Object.assign({}, defaultOptions, options)
  let columnOrder
  const content = []
  const column = []

  if (columns) {
    columnOrder = columns.map(v => {
      if (typeof v === 'string') return v
      if (!noHeader) {
        column.push(typeof v.title !== 'undefined' ? v.title : v.key)
      }
      return v.key
    })
    if (column.length > 0) appendLine(content, column, options)
  } else {
    columnOrder = []
    datas.forEach(v => {
      if (!Array.isArray(v)) {
        columnOrder = columnOrder.concat(Object.keys(v))
      }
    })
    if (columnOrder.length > 0) {
      columnOrder = columnOrder.filter((value, index, self) => self.indexOf(value) === index)
      if (!noHeader) appendLine(content, columnOrder, options)
    }
  }

  if (Array.isArray(datas)) {
    datas.forEach(row => {
      if (!Array.isArray(row)) {
        row = columnOrder.map(k => (typeof row[k] !== 'undefined' ? (row[k] === null ? '' : row[k]) : ''))
      }
      appendLine(content, row, options)
    })
  }
  return content.join(newLine)
}
