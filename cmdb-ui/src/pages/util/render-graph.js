export function renderGraph (viewSetting, viewData, imageHooker, indexOnly = false) {
  let dotStrings = []
  viewSetting.graphs.forEach(function (graph, graphIndex) {
    if (indexOnly) {
      if (!indexOnly.includes(graphIndex)) {
        return
      }
    }
    let renderedItems = []
    let lines = []
    let dotString = 'digraph G {\n'
    dotString += 'rankdir=' + graph.graphDir + ';edge[minlen=3];compound=true;\n'
    if (graph.viewGraphType === 'group') {
      dotString += 'Node [color="transparent";fixedsize="true";width="1.1";height="1.1";shape=box];\n'
      // make groups plaintext
      dotString += '{\nnode [shape=plaintext];\n' + graph.nodeGroups + ';\n}\n'
    }
    let defaultStyle = 'penwidth=1;color=black;'
    let userStyle = normalizeMapping(graph.rootData, 'graphConfigData', 'graphConfigs')
    viewData.forEach(function (data) {
      let metadata = {
        suport_version: viewSetting.suportVersion,
        graph_type: graph.viewGraphType,
        graph_dir: graph.graphDir,
        confirm_time: data.confirm_time,
        fontSize: 14,
        font_step: 0,
        imageHooker: imageHooker,
        renderedItems: renderedItems
      }
      let label = renderLabel(graph.rootData.displayExpression, data)
      renderedItems.push(data.guid)
      if (graph.viewGraphType === 'subgraph') {
        let depth = countDepth(graph)
        metadata.fontSize = 20
        metadata.font_step = ((metadata.fontSize - 14) * 1.0) / (depth - 1)
        dotString += 'subgraph cluster_' + data.guid + ' { \n'
        dotString += 'id=' + data.guid + ';\n'
        dotString += 'fontsize=' + metadata.fontSize + ';\n'
        dotString += 'label="' + label + '";\n'
        dotString += 'tooltip="' + (data.key_name || label) + '";\n'
        // hidden node represent subgraph
        dotString += data.guid + '[penwidth=0;width=0;height=0;label=""];\n'
        if (
          metadata.suport_version === 'yes' &&
          (!data.confirm_time ||
            (data.confirm_time === metadata.confirm_time && data.confirm_time === data.update_time)) &&
          userStyle.useMapping
        ) {
          dotString += (userStyle.value[_dataExpression(data, graph.rootData.graphConfigData)] || defaultStyle) + '\n'
        } else {
          dotString += (userStyle.useMapping ? defaultStyle : userStyle.value || defaultStyle) + '\n'
        }
      } else if (graph.viewGraphType === 'group') {
        // push root data
        dotString +=
          '{rank=same;"' +
          graph.rootData.nodeGroupName +
          '"; ' +
          data.guid +
          '[id="' +
          data.guid +
          '";label="' +
          label +
          '";' +
          'fontsize=' +
          metadata.fontSize +
          ';penwidth=1;width=2;image="' +
          imageHooker(graph.rootData.ciType) +
          '";labelloc="b";shape="box";'
        if (metadata.suport_version === 'yes') {
          dotString += 'color="#dddddd";penwidth=1;'
        }
        dotString += ']}\n'
      } else if (graph.viewGraphType === 'sequence') {
        dotString = 'sequenceDiagram\n'
      }
      if (graph.viewGraphType !== 'sequence') {
        graph.rootData.children.forEach(function (value) {
          if (
            value.graphFilterData &&
            value.graphFilterValues &&
            !JSON.parse(value.graphFilterValues).includes(data[value.graphFilterData])
          ) {
            return
          }
          let result = null
          switch (value.graphType) {
            case 'subgraph':
              result = renderSubgraph(value, data[value.dataName] || [], updateMetadata(metadata))
              dotString += result.dotString
              lines = lines.concat(result.lines)
              renderedItems.push(...result.renderedItems)
              break
            case 'image':
              result = renderImage(value, data, data[value.dataName] || [], updateMetadata(metadata))
              dotString += result.dotString
              if (metadata.graph_type === 'subgraph') {
                dotString += arrangeNodes(data[value.dataName] || [])
              }
              lines = lines.concat(result.lines)
              renderedItems.push(...result.renderedItems)
              break
            case 'node':
              result = renderNode(value, data[value.dataName] || [], updateMetadata(metadata))
              dotString += result.dotString
              if (metadata.graph_type === 'subgraph') {
                dotString += arrangeNodes(data[value.dataName] || [])
              }
              lines = lines.concat(result.lines)
              renderedItems.push(...result.renderedItems)
              break
            case 'line':
              lines.push(pushLine(value, data[value.dataName] || [], updateMetadata(metadata)))
              break
            default:
              break
          }
        })
      } else {
        let result = renderSequence(graph.rootData, [data], metadata)
        dotString += result.dotString
      }

      if (graph.viewGraphType === 'subgraph') {
        dotString += '}\n'
      }
    })
    if (['subgraph', 'group'].indexOf(graph.viewGraphType) >= 0) {
      lines.forEach(function (line) {
        dotString += renderLine(line.setting, line.datas, line.metadata, renderedItems)
      })
      dotString += '}\n'
    }
    dotStrings.push(dotString)
  })
  return dotStrings
}

function renderSubgraph (setting, datas, metadata) {
  let renderedItems = []
  let lines = []
  let dotString = ''
  let defaultStyle = 'penwidth=1;color=black;'
  let userStyle = normalizeMapping(setting, 'graphConfigData', 'graphConfigs')
  datas.forEach(function (data) {
    if (
      setting.graphFilterData &&
      setting.graphFilterValues &&
      !JSON.parse(setting.graphFilterValues).includes(data[setting.graphFilterData])
    ) {
      return
    }
    if (metadata.renderedItems.includes(data.guid)) {
      return
    }
    renderedItems.push(data.guid)
    let subgraphAttrs = []
    subgraphAttrs.push('id=' + data.guid)
    subgraphAttrs.push('fontsize=' + metadata.fontSize)
    let label = renderLabel(setting.displayExpression, data)
    subgraphAttrs.push('label="' + label + '"')
    subgraphAttrs.push('tooltip="' + (data.key_name || label) + '"')
    if (
      metadata.suport_version === 'yes' &&
      (!data.confirm_time || (data.confirm_time === metadata.confirm_time && data.confirm_time === data.update_time)) &&
      userStyle.useMapping
    ) {
      subgraphAttrs.push(userStyle.value[_dataExpression(data, setting.graphConfigData)] || defaultStyle)
    } else {
      subgraphAttrs.push(userStyle.useMapping ? defaultStyle : userStyle.value || defaultStyle)
    }
    dotString += 'subgraph cluster_' + data.guid + ' {\n'
    dotString += subgraphAttrs.join(';') + '\n'
    dotString += data.guid + '[penwidth=0;width=0;height=0;label=""];\n'
    if (setting.children) {
      setting.children.forEach(function (value) {
        let result = null
        switch (value.graphType) {
          case 'subgraph':
            result = renderSubgraph(value, data[value.dataName] || [], updateMetadata(metadata))
            dotString += result.dotString
            lines = lines.concat(result.lines)
            renderedItems.push(...result.renderedItems)
            break
          case 'image':
            result = renderImage(value, data, data[value.dataName] || [], updateMetadata(metadata))
            dotString += result.dotString
            if (metadata.graph_type === 'subgraph') {
              dotString += arrangeNodes(data[value.dataName] || [])
            }
            lines = lines.concat(result.lines)
            renderedItems.push(...result.renderedItems)
            break
          case 'node':
            result = renderNode(value, data[value.dataName] || [], updateMetadata(metadata))
            dotString += result.dotString
            if (metadata.graph_type === 'subgraph') {
              dotString += arrangeNodes(data[value.dataName] || [])
            }
            lines = lines.concat(result.lines)
            renderedItems.push(...result.renderedItems)
            break
          case 'line':
            lines.push(pushLine(value, data[value.dataName] || [], updateMetadata(metadata)))
            break
          default:
            break
        }
      })
    }
    dotString += '}\n'
  })
  return { dotString: dotString, lines: lines, renderedItems: renderedItems }
}

function renderImage (setting, parent, datas, metadata) {
  let renderedItems = []
  let lines = []
  let dotString = ''
  let defaultShape = 'box'
  let defaultStyle = 'color="transparent";penwidth=1;'
  let userShape = normalizeMapping(setting, 'graphShapeData', 'graphShapes')
  let userStyle = normalizeMapping(setting, 'graphConfigData', 'graphConfigs')

  if (metadata.suport_version === 'yes') {
    defaultStyle = 'color="#dddddd";penwidth=1;'
  }
  datas.forEach(function (data) {
    if (
      setting.graphFilterData &&
      setting.graphFilterValues &&
      !JSON.parse(setting.graphFilterValues).includes(data[setting.graphFilterData])
    ) {
      return
    }
    if (metadata.renderedItems.includes(data.guid)) {
      return
    }
    renderedItems.push(data.guid)
    let nodeString = ''
    if (metadata.graph_type === 'group') {
      nodeString += '{rank=same;"' + setting.nodeGroupName + '"; ' + data.guid
    } else {
      nodeString += data.guid
    }
    let label = renderLabel(setting.displayExpression, data)
    let nodeAttrs = []
    let imageWidth = 1.1
    nodeAttrs.push('id=' + data.guid)
    nodeAttrs.push('fontsize=' + metadata.fontSize)
    nodeAttrs.push('width=' + imageWidth)
    nodeAttrs.push('height=' + imageWidth)
    nodeAttrs.push('tooltip="' + label + '"')
    nodeAttrs.push('fixedsize="true"')
    let shape = ''
    if (userShape.useMapping) {
      shape = userShape.value[_dataExpression(data, setting.graphShapeData)] || defaultShape
    } else {
      shape = userShape.value || defaultShape
    }
    nodeAttrs.push('shape="' + shape + '"')
    nodeAttrs.push('labelloc="b"')
    let newLable = calculateShapeLabel(shape, imageWidth, metadata.fontSize, label)
    nodeAttrs.push('label="' + newLable + '"')
    nodeAttrs.push('image="' + metadata.imageHooker(setting.ciType) + '"')
    if (
      metadata.suport_version === 'yes' &&
      (!data.confirm_time || (data.confirm_time === metadata.confirm_time && data.confirm_time === data.update_time)) &&
      userStyle.useMapping
    ) {
      nodeAttrs.push(userStyle.value[_dataExpression(data, setting.graphConfigData)] || defaultStyle)
    } else {
      nodeAttrs.push(userStyle.useMapping ? defaultStyle : userStyle.value || defaultStyle)
    }
    nodeString += '[' + nodeAttrs.join(';') + ']'
    if (metadata.graph_type === 'group') {
      nodeString += '}\n'
    }
    dotString += nodeString
    if (parent && metadata.graph_type === 'group') {
      dotString += parent.guid + '->' + data.guid + '[arrowsize=0]\n'
    }
    if (setting.children) {
      setting.children.forEach(function (value) {
        let result = null
        switch (value.graphType) {
          case 'subgraph':
            result = renderSubgraph(value, data[value.dataName] || [], updateMetadata(metadata))
            dotString += result.dotString
            lines = lines.concat(result.lines)
            renderedItems.push(...result.renderedItems)
            break
          case 'image':
            result = renderImage(value, data, data[value.dataName] || [], updateMetadata(metadata))
            dotString += result.dotString
            if (metadata.graph_type === 'subgraph') {
              dotString += arrangeNodes(data[value.dataName] || [])
            }
            lines = lines.concat(result.lines)
            renderedItems.push(...result.renderedItems)
            break
          case 'node':
            result = renderNode(value, data[value.dataName] || [], updateMetadata(metadata))
            dotString += result.dotString
            if (metadata.graph_type === 'subgraph') {
              dotString += arrangeNodes(data[value.dataName] || [])
            }
            lines = lines.concat(result.lines)
            renderedItems.push(...result.renderedItems)
            break
          case 'line':
            lines.push(pushLine(value, data[value.dataName] || [], updateMetadata(metadata)))
            break
          default:
            break
        }
      })
    }
    // handle line
    if (setting.lineStartData && setting.lineEndData) {
      // remove children
      let modSetting = Object.assign({}, setting)
      modSetting.children = []
      let lineProfile = { setting: modSetting, datas: [data], metadata: metadata }
      lines.push(lineProfile)
    }
  })
  return { dotString: dotString, lines: lines, renderedItems: renderedItems }
}

function renderNode (setting, datas, metadata) {
  let renderedItems = []
  let lines = []
  let dotString = ''
  let defaultShape = 'ellipse'
  let defaultStyle = 'penwidth=1;color=black;'
  let userShape = normalizeMapping(setting, 'graphShapeData', 'graphShapes')
  let userStyle = normalizeMapping(setting, 'graphConfigData', 'graphConfigs')
  datas.forEach(function (data) {
    if (
      setting.graphFilterData &&
      setting.graphFilterValues &&
      !JSON.parse(setting.graphFilterValues).includes(data[setting.graphFilterData])
    ) {
      return
    }
    if (metadata.renderedItems.includes(data.guid)) {
      return
    }
    renderedItems.push(data.guid)
    let nodeWidth = 4
    let nodeString = data.guid
    let nodeAttrs = []
    let label = renderLabel(setting.displayExpression, data)
    nodeAttrs.push('id=' + data.guid)
    nodeAttrs.push('fontsize=' + metadata.fontSize)
    let shape = ''
    if (userShape.useMapping) {
      shape = userShape.value[_dataExpression(data, setting.graphShapeData)] || defaultShape
    } else {
      shape = userShape.value || defaultShape
    }
    let newLable = calculateShapeLabel(shape, nodeWidth, metadata.fontSize, label)
    nodeAttrs.push('shape="' + shape + '"')
    nodeAttrs.push('width=' + nodeWidth)
    nodeAttrs.push('label="' + newLable + '"')
    nodeAttrs.push('tooltip="' + label + '"')
    if (
      metadata.suport_version === 'yes' &&
      (!data.confirm_time || (data.confirm_time === metadata.confirm_time && data.confirm_time === data.update_time)) &&
      userStyle.useMapping
    ) {
      nodeAttrs.push(userStyle.value[_dataExpression(data, setting.graphConfigData)] || defaultStyle)
    } else {
      nodeAttrs.push(userStyle.useMapping ? defaultStyle : userStyle.value || defaultStyle)
    }
    nodeString += '[' + nodeAttrs.join(';') + '];\n'
    if (metadata.graph_type === 'group') {
      nodeString += '{rank=same;"' + setting.nodeGroupName + '"; '
    }
    dotString += nodeString
    if (metadata.graph_type === 'group') {
      nodeString += '}\n'
    }
    if (setting.children) {
      setting.children.forEach(function (value) {
        let result = null
        switch (value.graphType) {
          case 'subgraph':
            result = renderSubgraph(value, data[value.dataName] || [], updateMetadata(metadata))
            dotString += result.dotString
            lines = lines.concat(result.lines)
            renderedItems.push(...result.renderedItems)
            break
          case 'image':
            result = renderImage(value, data, data[value.dataName] || [], updateMetadata(metadata))
            dotString += result.dotString
            if (metadata.graph_type === 'subgraph') {
              dotString += arrangeNodes(data[value.dataName] || [])
            }
            lines = lines.concat(result.lines)
            renderedItems.push(...result.renderedItems)
            break
          case 'node':
            result = renderNode(value, data[value.dataName] || [], updateMetadata(metadata))
            dotString += result.dotString
            if (metadata.graph_type === 'subgraph') {
              dotString += arrangeNodes(data[value.dataName] || [])
            }
            lines = lines.concat(result.lines)
            renderedItems.push(...result.renderedItems)
            break
          case 'line':
            lines.push(pushLine(value, data[value.dataName] || [], updateMetadata(metadata)))
            break
          default:
            break
        }
      })
    }
    // handle line
    if (setting.lineStartData && setting.lineEndData) {
      // remove children
      let modSetting = Object.assign({}, setting)
      modSetting.children = []
      let lineProfile = { setting: modSetting, datas: [data], metadata: metadata }
      lines.push(lineProfile)
    }
  })
  return { dotString: dotString, lines: lines, renderedItems: renderedItems }
}

function pushLine (setting, datas, metadata) {
  let lineProfile = { setting: setting, datas: datas, metadata: metadata }
  return lineProfile
}

function renderLine (setting, datas, metadata, renderedItems) {
  let dotString = ''
  let lines = []
  let defaultShape = 'normal'
  let defaultStyle = 'penwidth=1;color=black;'
  let userShape = normalizeMapping(setting, 'graphShapeData', 'graphShapes')
  let userStyle = normalizeMapping(setting, 'graphConfigData', 'graphConfigs')
  datas.forEach(function (data) {
    if (
      setting.graphFilterData &&
      setting.graphFilterValues &&
      !JSON.parse(setting.graphFilterValues).includes(data[setting.graphFilterData])
    ) {
      return
    }
    if (setting.children) {
      setting.children.forEach(function (value) {
        let result = null
        switch (value.graphType) {
          case 'subgraph':
            result = renderSubgraph(value, data[value.dataName] || [], updateMetadata(metadata))
            dotString += result.dotString
            lines = lines.concat(result.lines)
            renderedItems.push(...result.renderedItems)
            break
          case 'image':
            result = renderImage(value, false, data[value.dataName] || [], updateMetadata(metadata))
            dotString += result.dotString
            if (metadata.graph_type === 'subgraph') {
              dotString += arrangeNodes(data[value.dataName] || [])
            }
            lines = lines.concat(result.lines)
            renderedItems.push(...result.renderedItems)
            break
          case 'node':
            result = renderNode(value, data[value.dataName] || [], updateMetadata(metadata))
            dotString += result.dotString
            if (metadata.graph_type === 'subgraph') {
              dotString += arrangeNodes(data[value.dataName] || [])
            }
            renderedItems.push(...result.renderedItems)
            break
          case 'line':
            lines.push(pushLine(value, data[value.dataName] || [], updateMetadata(metadata)))
            break
          default:
            break
        }
      })
    }
    let headLines = (setting.lineStartData ? data[setting.lineStartData] : []) || []
    let tailLines = (setting.lineEndData ? data[setting.lineEndData] : []) || []
    if (!Array.isArray(headLines)) {
      headLines = [headLines]
    }
    if (!Array.isArray(tailLines)) {
      tailLines = [tailLines]
    }
    headLines.forEach(hLine => {
      tailLines.forEach(tLine => {
        if (!renderedItems.includes(hLine) || !renderedItems.includes(tLine)) {
          console.warn('ignore line: ', hLine, '->', tLine)
          return
        }
        let lineString = hLine + ' -> ' + tLine
        let lineAttrs = []
        lineAttrs.push('id="' + data.guid + '"')
        lineAttrs.push('fontsize=' + Math.round(metadata.fontSize * 0.6 * 100) / 100)
        if (setting.graphType === 'line') {
          let label = renderLabel(setting.displayExpression, data)
          switch (setting.lineDisplayPosition) {
            case 'middle':
              lineAttrs.push('label="' + label + '"')
              break
            case 'head':
              lineAttrs.push('headlabel="' + label + '"')
              break
            case 'tail':
              lineAttrs.push('taillabel="' + label + '"')
              break
            default:
              break
          }
          lineAttrs.push('tooltip="' + (data.key_name || label) + '"')
        }
        lineAttrs.push('lhead=cluster_' + tLine)
        lineAttrs.push('ltail=cluster_' + hLine)
        if (setting.graphType === 'line') {
          let shapeString = ''
          if (userShape.useMapping) {
            shapeString = userShape.value[_dataExpression(data, setting.graphShapeData)] || defaultShape
          } else {
            shapeString = userShape.value || defaultShape
          }
          if (shapeString.slice(-1) === ';') {
            shapeString = shapeString.slice(0, -1)
          }
          lineAttrs.push('arrowhead=' + shapeString)
          if (
            metadata.suport_version === 'yes' &&
            (!data.confirm_time ||
              (data.confirm_time === metadata.confirm_time && data.confirm_time === data.update_time)) &&
            userStyle.useMapping
          ) {
            lineAttrs.push(userStyle.value[_dataExpression(data, setting.graphConfigData)] || defaultStyle)
          } else {
            lineAttrs.push(userStyle.useMapping ? defaultStyle : userStyle.value || defaultStyle)
          }
        } else {
          lineAttrs.push('arrowhead=icurve')
        }
        lineString += '[' + lineAttrs.join(';') + '];\n'
        dotString += lineString
      })
    })
  })
  return dotString
}

function updateMetadata (metadata) {
  let newMetadata = Object.assign({}, metadata)
  if (metadata.graph_type === 'subgraph') {
    // recalculate font size in subgraph
    newMetadata.fontSize = Math.round((metadata.fontSize - metadata.font_step) * 100) / 100
  }
  return newMetadata
}

function countDepth (graph) {
  let depths = []
  graph.rootData.children.forEach(function (setting) {
    depths.push(countItemDepth(setting, 2))
  })
  let maxDepth = Math.max.apply(null, depths)
  return maxDepth
}

function countItemDepth (setting, depth) {
  let depths = []
  if (setting.children) {
    setting.children.forEach(function (item) {
      depths.push(countItemDepth(item, depth + 1))
    })
  }
  let maxDepth = Math.max.apply(null, depths)
  maxDepth = maxDepth > depth ? maxDepth : depth
  return maxDepth
}

// function shapeDetection (attrString) {
//   let reg = /shape\s*=\s*([a-z]+)/
//   let shape = 'ellipse'
//   if (reg.test(attrString)) {
//     shape = RegExp.$1
//   }
//   return shape
// }
function calculateShapeLabel (shape, width, fontSize, label) {
  let factorMapping = {
    ellipse: 0.00887311,
    box: 0.0066548,
    diamond: 0.01611,
    hexagon: 0.01224489,
    circle: 0.007653061
  }
  let scaleFactor = factorMapping[shape] || factorMapping.ellipse
  let charLength = Math.floor(width / scaleFactor / fontSize)
  let cutLabel = label.length > charLength ? label.slice(0, charLength - 3) + '...' : label
  return cutLabel
}

function arrangeNodes (nodes) {
  let dotString = ''
  let rowHeadNodes = []
  if (nodes.length > 3) {
    let numRow = Math.sqrt(nodes.length)
    numRow = numRow - Math.floor(numRow) !== 0 ? Math.floor(numRow) + 1 : numRow
    for (let index = 0; index < nodes.length; index++) {
      if (index % numRow === 0) {
        dotString += '{rank=same;'
        rowHeadNodes.push(nodes[index].guid)
      }
      dotString += nodes[index].guid + ';'
      if (index % numRow === numRow - 1) {
        dotString += '}\n'
      }
    }
    // add rand end if nodes are not filled perfectly
    if ((nodes.length - 1) % numRow !== numRow - 1) {
      dotString += '}\n'
    }
    for (let index = 0; index < rowHeadNodes.length - 1; index++) {
      dotString += rowHeadNodes[index] + '->' + rowHeadNodes[index + 1] + '[penwidth=0;minlen=1;arrowsize=0];\n'
    }
  }
  return dotString
}

function renderLabel (expression, data) {
  let parts = JSON.parse(expression)
  let label = ''
  parts.forEach(function (value) {
    if (value.slice(0, 1) === "'") {
      label += value.slice(1, -1)
    } else {
      label += _dataExpression(data, value)
    }
  })
  return label
}

function normalizeMapping (setting, dataField, mapField, defaultValue) {
  let useMapping = setting[dataField].length !== 0
  let value = {}
  if (useMapping) {
    value = JSON.parse(setting[mapField])
  } else {
    value = setting[mapField] || defaultValue
  }
  return { useMapping: useMapping, value: value }
}

function renderSequence (setting, datas, metadata) {
  let dotString = ''
  datas.forEach(function (data) {
    if (
      setting.graphFilterData &&
      setting.graphFilterValues &&
      !JSON.parse(setting.graphFilterValues).includes(data[setting.graphFilterData])
    ) {
      return
    }
    if (setting.children) {
      let assistSetting = null
      let invokeSetting = null
      let assistItems = []
      let invokeItems = []
      setting.children.forEach(subSetting => {
        let items = data[subSetting.dataName] || []
        let orderField = subSetting.orderData || 'order_number'
        items.sort((item1, item2) => {
          if (orderField in item1) {
            return parseInt(item1.order_number) - parseInt(item2.order_number)
          }
          return 1
        })
        switch (subSetting.graphType) {
          case 'assist_item':
            assistSetting = subSetting
            for (let i = 0; i < items.length; i++) {
              if (
                subSetting.graphFilterData &&
                subSetting.graphFilterValues &&
                !JSON.parse(subSetting.graphFilterValues).includes(items[i][subSetting.graphFilterData])
              ) {
              } else {
                assistItems.push({ ...items[i], __index: i })
              }
            }
            break
          case 'service_invoke_item':
            invokeSetting = subSetting
            for (let i = 0; i < items.length; i++) {
              if (
                subSetting.graphFilterData &&
                subSetting.graphFilterValues &&
                !JSON.parse(subSetting.graphFilterValues).includes(items[i][subSetting.graphFilterData])
              ) {
              } else {
                invokeItems.push({ ...items[i], __index: i })
              }
            }
            break
        }
      })
      let invokeResult = renderInvoke(invokeSetting, invokeItems, metadata)
      // node1, node2, dotString, __index, node1[display_expression, node2[display_expression]
      let assitResult = renderAssist(assistSetting, assistItems, invokeResult.lines, metadata)
      let lines = invokeResult.lines.concat(assitResult.lines)
      lines.sort((item1, item2) => {
        return item1[5] - item2[5]
      })
      let reduceNodes = {}
      invokeResult.lines.forEach(item => {
        reduceNodes[item[0].guid] = [item[0], item[3]]
        reduceNodes[item[1].guid] = [item[1], item[4]]
      })
      for (let key in reduceNodes) {
        let item = reduceNodes[key]
        dotString +=
          'participant ' + item[0].guid + ' as ' + ('${' + item[0].guid + '}' + renderLabel(item[1], item[0])) + '\n'
      }
      lines.forEach(item => {
        dotString += item[2] + '\n'
      })
    }
  })
  return { dotString: dotString, lines: [], renderedItems: [] }
}

function renderInvoke (setting, datas, metadata) {
  // // node1, node2, dotString, display_expression, display_expression, __index
  let lines = []
  let nodes = []
  datas.forEach(function (data) {
    let label = renderLabel(setting.displayExpression, data)
    if (setting.children) {
      setting.children.forEach(function (subSetting) {
        switch (subSetting.graphType) {
          case 'service_invoke':
            let result = renderServiceInvoke(subSetting, data[subSetting.dataName] || [], metadata)
            result.lines.forEach(item => {
              lines.push([
                item[0],
                item[1],
                item[2] + ': ' + ('${' + data.guid + '}') + label,
                item[3],
                item[4],
                data.__index
              ])
            })
            nodes = nodes.concat(result.nodes)
            break
        }
      })
    }
  })
  let nodeMapping = {}
  nodes.forEach(node => {
    nodeMapping[node.guid] = node
  })
  lines.forEach(line => {
    line[0] = nodeMapping[line[0]]
    line[1] = nodeMapping[line[1]]
  })
  return { lines: lines }
}

function renderServiceInvoke (setting, datas, metadata) {
  // [node_guid, node_guid, dotString, display_expression, display_expression]
  let lines = []
  let nodes = []
  let defaultArrow = '->>'
  let userShape = normalizeMapping(setting, 'graphShapeData', 'graphShapes')
  datas.forEach(function (data) {
    let arrow = ''
    if (userShape.useMapping) {
      arrow = userShape.value[_dataExpression(data, setting.graphShapeData)] || defaultArrow
    } else {
      arrow = userShape.value || defaultArrow
    }
    let headNodes = (setting.lineStartData ? data[setting.lineStartData] : []) || []
    let tailNodes = (setting.lineEndData ? data[setting.lineEndData] : []) || []
    if (!Array.isArray(headNodes)) {
      headNodes = [headNodes]
    }
    if (!Array.isArray(tailNodes)) {
      tailNodes = [tailNodes]
    }
    headNodes.forEach(hNode => {
      tailNodes.forEach(tNode => {
        lines.push([hNode, tNode, hNode + ' ' + arrow + ' ' + tNode])
      })
    })
    if (setting.children) {
      setting.children.forEach(function (subSetting) {
        switch (subSetting.graphType) {
          case 'node':
            nodes = nodes.concat(data[subSetting.dataName] || [])
            lines.forEach(item => {
              item.push(subSetting.displayExpression)
            })
            break
        }
      })
    }
  })
  return { lines: lines, nodes: nodes }
}

function _findMaxLessThan (datas, index) {
  let indexFind = -1
  let itemFind = null
  datas.forEach(item => {
    if (item[5] < index && item[5] > indexFind) {
      indexFind = item[5]
      itemFind = item
    }
  })
  return itemFind
}

function _dataExpression (data, expr) {
  let parts = expr.split('.')
  let result = data
  for (let i = 0; i < parts.length; i++) {
    let part = parts[i]
    if (Array.isArray(result)) {
      result = result.length > 0 ? result[0] : null
    }
    if (result && typeof result === 'object' && result.constructor === Object) {
      if (part in result) {
        result = result[part]
      } else {
        result = ''
        break
      }
    } else {
      result = ''
      break
    }
  }
  return result
}

function renderAssist (setting, datas, invokeLines, metadata) {
  let lines = []
  let activateStackItems = []
  datas.forEach(data => {
    let label = renderLabel(setting.displayExpression, data)
    if (label.trimStart().toLowerCase().startsWith('activate')) {
      let invokeLine = _findMaxLessThan(invokeLines, data.__index)
      if (invokeLine) {
        label = 'ACTIVATE ' + invokeLine[1].guid
        activateStackItems.push(invokeLine[1].guid)
      }
    } else if (label.trimStart().toLowerCase().startsWith('deactivate')) {
      let activateGuid = activateStackItems.pop()
      label = 'DEACTIVATE ' + activateGuid
    } else if (label.trimStart().toLowerCase().startsWith('note')) {
      let rets = /note\s+((?:left\s+of)|(?:right\s+of)|over)(?:\s+[-_a-z0-9]+(?:,\s*[-_a-z0-9]+)?)?\s*:\s*(.*)/gi.exec(
        label.trimStart()
      )
      let invokeLine = _findMaxLessThan(invokeLines, data.__index)
      if (rets) {
        if (rets[1].toLowerCase().startsWith('left')) {
          label =
            'NOTE LEFT OF ' +
            (invokeLine ? invokeLine[1].guid : '') +
            ' : ' +
            ('${' + data.guid + '}') +
            (rets[2] || '')
        } else if (rets[1].toLowerCase().startsWith('right')) {
          label =
            'NOTE RIGHT OF ' +
            (invokeLine ? invokeLine[1].guid : '') +
            ' : ' +
            ('${' + data.guid + '}') +
            (rets[2] || '')
        } else {
          // over
          label =
            'NOTE OVER ' +
            (invokeLine ? invokeLine[0].guid : '') +
            ',' +
            (invokeLine ? invokeLine[1].guid : '') +
            ' : ' +
            ('${' + data.guid + '}') +
            (rets[2] || '')
        }
      } else {
        // default right
        label =
          'NOTE LEFT OF ' +
          (invokeLine ? invokeLine[1].guid : '') +
          ' : ' +
          ('${' + data.guid + '}') +
          (label.slice('note'.length).trimStart() || '')
      }
    } else if (label.trimStart().toLowerCase().startsWith('loop')) {
      label += '${' + data.guid + '}'
    } else if (label.trimStart().toLowerCase().startsWith('alt')) {
      label += '${' + data.guid + '}'
    } else if (label.trimStart().toLowerCase().startsWith('par')) {
      label += '${' + data.guid + '}'
    } else if (label.trimStart().toLowerCase().startsWith('and')) {
      label += '${' + data.guid + '}'
    } else if (label.trimStart().toLowerCase().startsWith('opt')) {
      label += '${' + data.guid + '}'
    }
    lines.push([null, null, label, null, null, data.__index])
  })
  return { lines: lines }
}
