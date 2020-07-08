import { queryCiData, getAllCITypesByLayerWithAttr } from '@/api/server'
let allCITypes = {}
async function getAllCITypes () {
  allCITypes = {}
  const status = ['notCreated', 'created', 'dirty', 'decommissioned']
  const allCITypesInfo = await getAllCITypesByLayerWithAttr(status)
  if (allCITypesInfo.statusCode === 'OK') {
    allCITypesInfo.data.map(_ => {
      _.ciTypes.forEach(ciType => {
        allCITypes[ciType.tableName] = ciType
      })
    })
  }
}

export default async function exprLineFinder (expr, linkData, ciTypeId) {
  await getAllCITypes()
  /*
  连接线数据匹配
  [
      {'link的guid值': {from: [{guid: ...}], to: [{guid: ...}]}
  ]
  */
  let cacheData = {}
  // TODO: replace this with data source(eg. api call)
  const { exprFrom, exprTo } = expr
  const myCiGetter = async (exprData, isBackref, guids) => {
    // expr_data结构如下：
    // {
    //     "backref_attribute":"",
    //     "plugin":"wecmdb",
    //     "ci":"resource_instance_system",
    //     "filters":[{"name":"code","operator":"eq","value":"cd"}
    //     ],
    //     "attribute":""
    // }
    let datas = []
    // TODO: make id with filter
    let id = exprData.ci
    if (cacheData[id]) {
      datas = cacheData[id]
    } else {
      const { statusCode, data } = await queryCiData({
        id: allCITypes[exprData.ci].ciTypeId,
        queryObject: {
          filters: exprData.filters
        }
      })
      if (statusCode === 'OK') {
        datas = data.contents
        cacheData[id] = datas
      }
    }
    if (isBackref) {
      return datas.filter(item => guids.includes(item.data[exprData.backref_attribute].guid))
    } else {
      return datas.filter(item => guids.includes(item.data.guid))
    }
  }
  let lineFrom = await exprMatch(exprParse(exprFrom), linkData, myCiGetter)
  let lineTo = await exprMatch(exprParse(exprTo), linkData, myCiGetter)
  // merge link data
  let linkMapping = {}
  let linkResults = []
  for (let key in lineFrom) {
    if (key in lineTo) {
      linkMapping[key] = { from: lineFrom[key], to: lineTo[key] }
    }
  }
  linkData.forEach(el => {
    let linkGuid = el.data.guid
    if (linkGuid in linkMapping) {
      if (linkMapping[linkGuid].from.length > 0 && linkMapping[linkGuid].to.length > 0) {
        linkResults.push({
          guid: linkGuid,
          label: el.data.code,
          state: el.data.state.code,
          from: linkMapping[linkGuid].from[0].data.guid,
          to: linkMapping[linkGuid].to[0].data.guid,
          linkInfo: {
            ...el.data,
            meta: el.meta,
            ciTypeId: ciTypeId
          }
        })
      }
    }
  })
  // TODO: remove this
  // console.log('link results:', linkResults)
  // for (let key in linkResults) {
  //   let a = linkResults[key].from
  //   let b = linkResults[key].to
  //   if (a.length > 0 && b.length > 0) {
  //     console.log('link:', linkResults[key].guid, ' ,from: ', a, ' ,to: ', b)
  //   }
  // }
  return linkResults
}

function exprOpFinder (expr) {
  let ops = ['~', '>', '->', '<-']
  let results = []
  ops.forEach(el => {
    let index = expr.indexOf(el)
    if (index !== -1) {
      if (el === '>' && expr.charAt(index - 1) === '-') {
        // ignore it, we will find it when op = '->'
      } else {
        results.push({ op: el, index: index })
      }
    }
    while (index !== -1) {
      index = expr.indexOf(el, index + el.length)
      if (index !== -1) {
        if (el === '>' && expr.charAt(index - 1) === '-') {
          // ignore it, we will find it when op = '->'
        } else {
          results.push({ op: el, index: index })
        }
      }
    }
  })
  results.sort((a, b) => a.index - b.index)
  return results
}

function exprSplit (expr, indexes) {
  let results = []
  let start = 0
  indexes.forEach(el => {
    results.push({ type: 'expr', value: expr.slice(start, el.index), data: null })
    results.push({ type: 'op', value: el.op, data: null })
    start = el.index + el.op.length
  })
  results.push({ type: 'expr', value: expr.slice(start, expr.length), data: null })
  return results
}

function exprFilterParse (exprFilter) {
  let gRule = /\{([_a-zA-Z][_a-zA-Z0-9]*)\s+([a-zA-Z]+)\s+([^}]+)\}/g
  let rule = /\{([_a-zA-Z][_a-zA-Z0-9]*)\s+([a-zA-Z]+)\s+([^}]+)\}/
  let results = []
  if (exprFilter.length > 0) {
    let ret = exprFilter.match(gRule)
    if (ret) {
      ret.forEach(el => {
        let filter = rule.exec(el)
        let filterOp = filter[2]
        let filterVal = filter[3]
        if (filterVal.startsWith("'") && filterVal.endsWith("'")) {
          // 转换字符串
          filterVal = filterVal.substr(1, filterVal.length - 2)
        } else if (filterVal.startsWith('[') && filterVal.endsWith(']')) {
          // 转换数组
          filterVal = JSON.parse(filterVal.replace(/'/g, '"'))
        } else if (filterVal === 'NULL') {
          // 转换NULL特殊值
          filterVal = null
        }
        // TODO：转换OP
        results.push({ name: filter[1], operator: filterOp, value: filterVal })
      })
    }
  }
  return results
}

function exprSegParse (expr) {
  let rule = /(?:\(([_a-zA-Z][_a-zA-Z0-9]*)\))?(?:([_a-zA-Z][_a-zA-Z0-9]*):)?([_a-zA-Z][_a-zA-Z0-9]*)((?:\{[_a-zA-Z][_a-zA-Z0-9]*\s+[a-zA-Z]+\s+.*\}){1,30})?(?:\.([_a-zA-Z][_a-zA-Z0-9]*))?$/
  let segs = rule.exec(expr)
  if (segs) {
    let ret = {
      backref_attribute: segs[1] || '',
      plugin: segs[2] || '',
      ci: segs[3] || '',
      filters: segs[4] || '',
      attribute: segs[5] || ''
    }
    ret.filters = exprFilterParse(ret.filters)
    return ret
  }
  // throw 'invalid expression: ' + expr
}

function exprParse (expr) {
  let splitRes = exprSplit(expr, exprOpFinder(expr))
  splitRes.forEach(el => {
    if (el.type === 'expr') {
      el.data = exprSegParse(el.value)
    }
  })
  return splitRes
}

async function exprMatch (exprGroups, inputData, ciGetter) {
  let results = {}
  for (let eIndex = 0; eIndex < inputData.length; eIndex++) {
    let el = inputData[eIndex]
    // inputData.forEach(async el => {
    let isBackref = false
    let guids = []
    let curData = []
    for (let i = 0; i < exprGroups.length; i++) {
      let expr = exprGroups[i]
      let exprData = expr.data
      // user input_data
      if (i === 0) {
        let guid = el.data[exprData.attribute].guid
        if (guid) {
          guids.push(guid)
        }
        continue
      }
      if (expr.type === 'expr') {
        // user ci, backref_attribute.guid in guids[if is_backref], filters
        curData = await ciGetter(exprData, isBackref, guids)
        guids = []
        for (let j = 0; j < curData.length; j++) {
          let guid = ''
          if (exprData.attribute.length > 0) {
            guid = curData[j].data[exprData.attribute].guid
          } else {
            guid = curData[j].data.guid
          }
          if (guid) {
            guids.push(guid)
          }
        }
      } else if (expr.type === 'op') {
        if (expr.value === '>' || expr.value === '->') {
          isBackref = false
        } else if (expr.value === '~' || expr.value === '<-') {
          isBackref = true
        }
      }
    }
    results[el.data.guid] = curData
  }
  return results
}
