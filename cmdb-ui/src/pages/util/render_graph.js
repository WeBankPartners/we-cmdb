export function render_graph (view_setting, view_data, image_hooker, indexOnly = false) {
  let dot_strings = []
  view_setting.graphs.forEach(function (graph, graph_index) {
    if (indexOnly) {
      if (!indexOnly.includes(graph_index)) {
        return
      }
    }
    let rendered_items = []
    let lines = []
    let dot_string = 'digraph G {\n'
    dot_string += 'rankdir=' + graph.graphDir + ';edge[minlen=3];compound=true;\n'
    if (graph.viewGraphType == 'group') {
      dot_string += 'Node [color="transparent";fixedsize="true";width="1.1";height="1.1";shape=box];\n'
      // make groups plaintext
      dot_string += '{\nnode [shape=plaintext];\n' + graph.nodeGroups + ';\n}\n'
    }
    let default_style = 'penwidth=1;color=black;'
    let user_style = normalize_mapping(graph.rootData, 'graphConfigData', 'graphConfigs')
    view_data.forEach(function (data) {
      
      let metadata = {
        suport_version: view_setting.suportVersion,
        graph_type: graph.viewGraphType,
        graph_dir: graph.graphDir,
        confirm_time: data.confirm_time,
        font_size: 14,
        font_step: 0,
        image_hooker: image_hooker,
        rendered_items: rendered_items
      }
      let label = render_label(graph.rootData.displayExpression, data)
      rendered_items.push(data.guid)
      if (graph.viewGraphType == 'subgraph') {
        let depth = count_depth(graph)
        metadata.font_size = 20
        metadata.font_step = ((metadata.font_size - 14) * 1.0) / (depth - 1)
        dot_string += 'subgraph cluster_' + data.guid + ' { \n'
        dot_string += 'id=' + data.guid + ';\n'
        dot_string += 'fontsize=' + metadata.font_size + ';\n'
        dot_string += 'label="' + label + '";\n'
        dot_string += 'tooltip="' + (data.key_name || label) + '";\n'
        // hidden node represent subgraph
        dot_string += data.guid + '[penwidth=0;width=0;height=0;label=""];\n'
        if (
          metadata.suport_version === 'yes' &&
          (!data.confirm_time || (data.confirm_time === metadata.confirm_time &&
            data.confirm_time === data.update_time)) && user_style.use_mapping
        ) {
          dot_string += (user_style.value[data[graph.rootData.graphConfigData] || ''] || default_style) + '\n'
        } else {
          dot_string += (user_style.use_mapping ? default_style : user_style.value || default_style) + '\n'
        }
      } else if (graph.viewGraphType == 'group') {
        // push root data
        dot_string +=
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
          metadata.font_size +
          ';penwidth=1;width=2;image="' +
          image_hooker(graph.rootData.ciType) +
          '";labelloc="b";shape="box";'
        if (metadata.suport_version === 'yes') {
          dot_string += 'color="#dddddd";penwidth=1;'
        }
        dot_string += ']}\n'
      }
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
            result = render_subgraph(value, data[value.dataName] || [], update_metadata(metadata))
            dot_string += result.dot_string
            lines = lines.concat(result.lines)
            rendered_items.push(...result.rendered_items)
            break
          case 'image':
            result = render_image(value, data, data[value.dataName] || [], update_metadata(metadata))
            dot_string += result.dot_string
            if (metadata.graph_type == 'subgraph') {
              dot_string += arrange_nodes(data[value.dataName] || [])
            }
            lines = lines.concat(result.lines)
            rendered_items.push(...result.rendered_items)
            break
          case 'node':
            result = render_node(value, data[value.dataName] || [], update_metadata(metadata))
            dot_string += result.dot_string
            if (metadata.graph_type == 'subgraph') {
              dot_string += arrange_nodes(data[value.dataName] || [])
            }
            lines = lines.concat(result.lines)
            rendered_items.push(...result.rendered_items)
            break
          case 'line':
            lines.push(push_line(value, data[value.dataName] || [], update_metadata(metadata)))
            break
          default:
            break
        }
      })
      if (graph.viewGraphType == 'subgraph') {
        dot_string += '}\n'
      }
    })
    lines.forEach(function (line) {
      dot_string += render_line(line.setting, line.datas, line.metadata, rendered_items)
    })
    dot_string += '}\n'
    dot_strings.push(dot_string)
  })
  return dot_strings
}

function render_subgraph (setting, datas, metadata) {
  let rendered_items = []
  let lines = []
  let dot_string = ''
  let default_style = 'penwidth=1;color=black;'
  let user_style = normalize_mapping(setting, 'graphConfigData', 'graphConfigs')
  datas.forEach(function (data) {
    if (
      setting.graphFilterData &&
      setting.graphFilterValues &&
      !JSON.parse(setting.graphFilterValues).includes(data[setting.graphFilterData])
    ) {
      return
    }
    if (metadata.rendered_items.includes(data.guid)) {
      return 
    }
    rendered_items.push(data.guid)
    let subgraph_attrs = []
    subgraph_attrs.push('id=' + data.guid)
    subgraph_attrs.push('fontsize=' + metadata.font_size)
    let label = render_label(setting.displayExpression, data)
    subgraph_attrs.push('label="' + label + '"')
    subgraph_attrs.push('tooltip="' + (data.key_name || label) + '"')
    if (
      metadata.suport_version === 'yes' &&
      (!data.confirm_time || (data.confirm_time === metadata.confirm_time &&
        data.confirm_time === data.update_time)) && user_style.use_mapping
    ) {
      subgraph_attrs.push(user_style.value[data[setting.graphConfigData] || ''] || default_style)
    } else {
      subgraph_attrs.push(user_style.use_mapping ? default_style : user_style.value || default_style)
    }
    dot_string += 'subgraph cluster_' + data.guid + ' {\n'
    dot_string += subgraph_attrs.join(';') + '\n'
    dot_string += data.guid + '[penwidth=0;width=0;height=0;label=""];\n'
    if (setting.children) {
      setting.children.forEach(function (value) {
        let result = null
        switch (value.graphType) {
          case 'subgraph':
            result = render_subgraph(value, data[value.dataName] || [], update_metadata(metadata))
            dot_string += result.dot_string
            lines = lines.concat(result.lines)
            rendered_items.push(...result.rendered_items)
            break
          case 'image':
            result = render_image(value, data, data[value.dataName] || [], update_metadata(metadata))
            dot_string += result.dot_string
            if (metadata.graph_type == 'subgraph') {
              dot_string += arrange_nodes(data[value.dataName] || [])
            }
            lines = lines.concat(result.lines)
            rendered_items.push(...result.rendered_items)
            break
          case 'node':
            result = render_node(value, data[value.dataName] || [], update_metadata(metadata))
            dot_string += result.dot_string
            if (metadata.graph_type == 'subgraph') {
              dot_string += arrange_nodes(data[value.dataName] || [])
            }
            lines = lines.concat(result.lines)
            rendered_items.push(...result.rendered_items)
            break
          case 'line':
            lines.push(push_line(value, data[value.dataName] || [], update_metadata(metadata)))
            break
          default:
            break
        }
      })
    }
    dot_string += '}\n'
  })
  return { dot_string: dot_string, lines: lines, rendered_items: rendered_items }
}

function render_image (setting, parent, datas, metadata) {
  let rendered_items = []
  let lines = []
  let dot_string = ''
  let default_shape = 'box'
  let default_style = 'color="transparent";penwidth=1;'
  let user_shape = normalize_mapping(setting, 'graphShapeData', 'graphShapes')
  let user_style = normalize_mapping(setting, 'graphConfigData', 'graphConfigs')

  if (metadata.suport_version === 'yes') {
    default_style = 'color="#dddddd";penwidth=1;'
  }
  datas.forEach(function (data) {
    if (
      setting.graphFilterData &&
      setting.graphFilterValues &&
      !JSON.parse(setting.graphFilterValues).includes(data[setting.graphFilterData])
    ) {
      return
    }
    if (metadata.rendered_items.includes(data.guid)) {
      return 
    }
    rendered_items.push(data.guid)
    let node_string = ''
    if (metadata.graph_type === 'group') {
      node_string += '{rank=same;"' + setting.nodeGroupName + '"; ' + data.guid
    } else {
      node_string += data.guid
    }
    let label = render_label(setting.displayExpression, data)
    let node_attrs = []
    let image_width = 1.1
    node_attrs.push('id=' + data.guid)
    node_attrs.push('fontsize=' + metadata.font_size)
    node_attrs.push('width=' + image_width)
    node_attrs.push('height=' + image_width)
    node_attrs.push('tooltip="' + label + '"')
    node_attrs.push('fixedsize="true"')
    let shape = ''
    if (user_shape.use_mapping) {
      shape = user_shape.value[data[setting.graphShapeData]] || default_shape
    } else {
      shape = user_shape.value || default_shape
    }
    node_attrs.push('shape="' + shape + '"')
    node_attrs.push('labelloc="b"')
    let new_lable = calculate_shape_label(shape, image_width, metadata.font_size, label)
    node_attrs.push('label="' + new_lable + '"')
    node_attrs.push('image="' + metadata.image_hooker(setting.ciType) + '"')
    if (
      metadata.suport_version === 'yes' &&
      (!data.confirm_time || (data.confirm_time === metadata.confirm_time &&
        data.confirm_time === data.update_time)) && user_style.use_mapping
    ) {
      node_attrs.push(user_style.value[data[setting.graphConfigData] || ''] || default_style)
    } else {
      node_attrs.push(user_style.use_mapping ? default_style : user_style.value || default_style)
    }
    node_string += '[' + node_attrs.join(';') + ']'
    if (metadata.graph_type === 'group') {
      node_string += '}\n'
    }
    dot_string += node_string
    if (parent && metadata.graph_type === 'group') {
      dot_string += parent.guid + '->' + data.guid + '[arrowsize=0]\n'
    }
    if (setting.children) {
      setting.children.forEach(function (value) {
        let result = null
        switch (value.graphType) {
          case 'subgraph':
            result = render_subgraph(value, data[value.dataName] || [], update_metadata(metadata))
            dot_string += result.dot_string
            lines = lines.concat(result.lines)
            rendered_items.push(...result.rendered_items)
            break
          case 'image':
            result = render_image(value, data, data[value.dataName] || [], update_metadata(metadata))
            dot_string += result.dot_string
            if (metadata.graph_type == 'subgraph') {
              dot_string += arrange_nodes(data[value.dataName] || [])
            }
            lines = lines.concat(result.lines)
            rendered_items.push(...result.rendered_items)
            break
          case 'node':
            result = render_node(value, data[value.dataName] || [], update_metadata(metadata))
            dot_string += result.dot_string
            if (metadata.graph_type == 'subgraph') {
              dot_string += arrange_nodes(data[value.dataName] || [])
            }
            lines = lines.concat(result.lines)
            rendered_items.push(...result.rendered_items)
            break
          case 'line':
            lines.push(push_line(value, data[value.dataName] || [], update_metadata(metadata)))
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
      let line_profile = { setting: modSetting, datas: [data], metadata: metadata }
      lines.push(line_profile)
    }
  })
  return { dot_string: dot_string, lines: lines, rendered_items: rendered_items }
}

function render_node (setting, datas, metadata) {
  let rendered_items = []
  let lines = []
  let dot_string = ''
  let default_shape = 'ellipse'
  let default_style = 'penwidth=1;color=black;'
  let user_shape = normalize_mapping(setting, 'graphShapeData', 'graphShapes')
  let user_style = normalize_mapping(setting, 'graphConfigData', 'graphConfigs')
  datas.forEach(function (data) {
    if (
      setting.graphFilterData &&
      setting.graphFilterValues &&
      !JSON.parse(setting.graphFilterValues).includes(data[setting.graphFilterData])
    ) {
      return
    }
    if (metadata.rendered_items.includes(data.guid)) {
      return 
    }
    rendered_items.push(data.guid)
    let node_width = 4
    let node_string = data.guid
    let node_attrs = []
    let label = render_label(setting.displayExpression, data)
    node_attrs.push('id=' + data.guid)
    node_attrs.push('fontsize=' + metadata.font_size)
    let shape = ''
    if (user_shape.use_mapping) {
      shape = user_shape.value[data[setting.graphShapeData]] || default_shape
    } else {
      shape = user_shape.value || default_shape
    }
    let new_lable = calculate_shape_label(shape, node_width, metadata.font_size, label)
    node_attrs.push('shape="' + shape + '"')
    node_attrs.push('width=' + node_width)
    node_attrs.push('label="' + new_lable + '"')
    node_attrs.push('tooltip="' + label + '"')
    if (
      metadata.suport_version === 'yes' &&
      (!data.confirm_time || (data.confirm_time === metadata.confirm_time &&
        data.confirm_time === data.update_time)) && user_style.use_mapping
    ) {
      node_attrs.push(user_style.value[data[setting.graphConfigData] || ''] || default_style)
    } else {
      node_attrs.push(user_style.use_mapping ? default_style : user_style.value || default_style)
    }
    node_string += '[' + node_attrs.join(';') + '];\n'
    if (metadata.graph_type === 'group') {
      node_string += '{rank=same;"' + setting.nodeGroupName + '"; '
    }
    dot_string += node_string
    if (metadata.graph_type === 'group') {
      node_string += '}\n'
    }
    if (setting.children) {
      setting.children.forEach(function (value) {
        let result = null
        switch (value.graphType) {
          case 'subgraph':
            result = render_subgraph(value, data[value.dataName] || [], update_metadata(metadata))
            dot_string += result.dot_string
            lines = lines.concat(result.lines)
            rendered_items.push(...result.rendered_items)
            break
          case 'image':
            result = render_image(value, data, data[value.dataName] || [], update_metadata(metadata))
            dot_string += result.dot_string
            if (metadata.graph_type == 'subgraph') {
              dot_string += arrange_nodes(data[value.dataName] || [])
            }
            lines = lines.concat(result.lines)
            rendered_items.push(...result.rendered_items)
            break
          case 'node':
            result = render_node(value, data[value.dataName] || [], update_metadata(metadata))
            dot_string += result.dot_string
            if (metadata.graph_type == 'subgraph') {
              dot_string += arrange_nodes(data[value.dataName] || [])
            }
            lines = lines.concat(result.lines)
            rendered_items.push(...result.rendered_items)
            break
          case 'line':
            lines.push(push_line(value, data[value.dataName] || [], update_metadata(metadata)))
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
      let line_profile = { setting: modSetting, datas: [data], metadata: metadata }
      lines.push(line_profile)
    }
  })
  return { dot_string: dot_string, lines: lines, rendered_items: rendered_items }
}

function push_line (setting, datas, metadata) {
  let line_profile = { setting: setting, datas: datas, metadata: metadata }
  return line_profile
}

function render_line (setting, datas, metadata, rendered_items) {
  let dot_string = ''
  let lines = []
  let default_shape = 'normal'
  let default_style = 'penwidth=1;color=black;'
  let user_shape = normalize_mapping(setting, 'graphShapeData', 'graphShapes')
  let user_style = normalize_mapping(setting, 'graphConfigData', 'graphConfigs')
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
            result = render_subgraph(value, data[value.dataName] || [], update_metadata(metadata))
            dot_string += result.dot_string
            lines = lines.concat(result.lines)
            rendered_items.push(...result.rendered_items)
            break
          case 'image':
            result = render_image(value, false, data[value.dataName] || [], update_metadata(metadata))
            dot_string += result.dot_string
            if (metadata.graph_type == 'subgraph') {
              dot_string += arrange_nodes(data[value.dataName] || [])
            }
            lines = lines.concat(result.lines)
            rendered_items.push(...result.rendered_items)
            break
          case 'node':
            result = render_node(value, data[value.dataName] || [], update_metadata(metadata))
            dot_string += result.dot_string
            if (metadata.graph_type == 'subgraph') {
              dot_string += arrange_nodes(data[value.dataName] || [])
            }
            rendered_items.push(...result.rendered_items)
            break
          case 'line':
            lines.push(push_line(value, data[value.dataName] || [], update_metadata(metadata)))
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
        if (!rendered_items.includes(hLine) || !rendered_items.includes(tLine)) {
          console.warn('ignore line: ', hLine, '->', tLine)
          return
        }
        let line_string = hLine + ' -> ' + tLine
        let line_attrs = []
        line_attrs.push('id="' + data.guid + '"')
        line_attrs.push('fontsize=' + Math.round((metadata.font_size * 0.6) * 100) / 100)
        if (setting.graphType === 'line') {
          let label = render_label(setting.displayExpression, data)
          switch (setting.lineDisplayPosition) {
            case 'middle':
              line_attrs.push('label="' + label + '"')
              break
            case 'head':
              line_attrs.push('headlabel="' + label + '"')
              break
            case 'tail':
              line_attrs.push('taillabel="' + label + '"')
              break
            default:
              break
          }
          line_attrs.push('tooltip="' + (data.key_name || label) + '"')
        }
        line_attrs.push('lhead=cluster_' + tLine)
        line_attrs.push('ltail=cluster_' + hLine)
        if (setting.graphType === 'line') {
          let shape_string = ''
          if (user_shape.use_mapping) {
            shape_string = user_shape.value[data[setting.graphShapeData]] || default_shape
          } else {
            shape_string = user_shape.value || default_shape
          }
          if (shape_string.slice(-1) == ';') {
            shape_string = shape_string.slice(0, -1)
          }
          line_attrs.push('arrowhead=' + shape_string)
          if (
            metadata.suport_version === 'yes' &&
            (!data.confirm_time || (data.confirm_time === metadata.confirm_time &&
              data.confirm_time === data.update_time)) && user_style.use_mapping
          ) {
            line_attrs.push(user_style.value[data[setting.graphConfigData] || ''] || default_style)
          } else {
            line_attrs.push(user_style.use_mapping ? default_style : user_style.value || default_style)
          }
        } else {
          line_attrs.push('arrowhead=icurve')
        }
        line_string += '[' + line_attrs.join(';') + '];\n'
        dot_string += line_string
      });
    });
  })
  return dot_string
}

function update_metadata (metadata) {
  let new_metadata = Object.assign({}, metadata)
  if (metadata.graph_type == 'subgraph') {
    // recalculate font size in subgraph
    new_metadata.font_size = Math.round((metadata.font_size - metadata.font_step) * 100) / 100
  }
  return new_metadata
}

function count_depth (graph) {
  let depths = []
  graph.rootData.children.forEach(function (setting) {
    depths.push(count_item_depth(setting, 2))
  })
  let max_depth = Math.max.apply(null, depths)
  return max_depth
}

function count_item_depth (setting, depth) {
  let depths = []
  if (setting.children) {
    setting.children.forEach(function (item) {
      depths.push(count_item_depth(item, depth + 1))
    })
  }
  let max_depth = Math.max.apply(null, depths)
  max_depth = max_depth > depth ? max_depth : depth
  return max_depth
}

function shape_detection (attr_string) {
  let reg = /shape\s*=\s*([a-z]+)/
  let shape = 'ellipse'
  if (reg.test(attr_string)) {
    shape = RegExp.$1
  }
  return shape
}

function calculate_shape_label (shape, width, font_size, label) {
  let factor_mapping = {
    ellipse: 0.00887311,
    box: 0.0066548,
    diamond: 0.01611,
    hexagon: 0.01224489,
    circle: 0.007653061
  }
  let scale_factor = factor_mapping[shape] || factor_mapping.ellipse
  let char_length = Math.floor(width / scale_factor / font_size)
  let cut_label = label.length > char_length ? label.slice(0, char_length - 3) + '...' : label
  return cut_label
}

function arrange_nodes (nodes) {
  let dot_string = ''
  let row_head_nodes = []
  if (nodes.length > 3) {
    let num_row = Math.sqrt(nodes.length)
    num_row = num_row - Math.floor(num_row) != 0 ? Math.floor(num_row) + 1 : num_row
    for (let index = 0; index < nodes.length; index++) {
      if (index % num_row == 0) {
        dot_string += '{rank=same;'
        row_head_nodes.push(nodes[index].guid)
      }
      dot_string += nodes[index].guid + ';'
      if (index % num_row == num_row - 1) {
        dot_string += '}\n'
      }
    }
    // add rand end if nodes are not filled perfectly
    if ((nodes.length - 1) % num_row != num_row - 1) {
      dot_string += '}\n'
    }
    for (let index = 0; index < row_head_nodes.length - 1; index++) {
      dot_string += row_head_nodes[index] + '->' + row_head_nodes[index + 1] + '[penwidth=0;minlen=1;arrowsize=0];\n'
    }
  }
  return dot_string
}

function render_label (expression, data) {
  let parts = JSON.parse(expression)
  let label = ''
  parts.forEach(function (value) {
    if (value.slice(0, 1) == "'") {
      label += value.slice(1, -1)
    } else {
      label += data[value] || ''
    }
  })
  return label
}

function normalize_mapping (setting, data_field, map_field, default_value) {
  let use_mapping = setting[data_field].length != 0
  let value = {}
  if (use_mapping) {
    value = JSON.parse(setting[map_field])
  } else {
    value = setting[map_field] || default_value
  }
  return { use_mapping: use_mapping, value: value }
}
