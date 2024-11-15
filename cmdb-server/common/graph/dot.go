package graph

import (
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"math"
	"strconv"
	"strings"
)

var (
	DefaultStyle = "penwidth=1;color=black;"
	ShapeBox     = "box"
	ShapeEllipse = "ellipse"
	ShapeNormal  = "normal"
)

const (
	SubgraphType      = "subgraph"
	ImageType         = "image"
	NodeType          = "node"
	NoneType          = "none"
	LineType          = "line"
	GroupType         = "group"
	SequenceType      = "sequence"
	ServiceInvoke     = "service_invoke"
	AssistItem        = "assist_item"
	ServiceInvokeItem = "service_invoke_item"
)

// RenderDot render dot graph
func RenderDot(graph models.GraphQuery, dataList []map[string]interface{}, option RenderOption) (dot string, err error) {
	suportVersion := option.SuportVersion
	imageMap := option.ImageMap

	dot = "\ndigraph G {\n"
	dot += fmt.Sprintf("rankdir=%s;edge[%s];compound=true;\n", graph.GraphDir, graph.GraphEdgeConfig)

	if graph.ViewGraphType == GroupType {
		dot += "Node [color=\"transparent\";fixedsize=\"true\";width=\"1.1\";height=\"1.1\";shape=box];\n"
		dot += "{\nnode [shape=plaintext];\n" + graph.NodeGroups + ";\n}\n"
	} else {
		dot += fmt.Sprintf("node[%s];\n", graph.GraphNodeConfig)
	}

	var renderedItems []string
	var lines []Line

	for _, data := range dataList {
		confirmTime := mapGetStr(data, "confirm_time")
		guid := mapGetStr(data, "guid")
		keyName := mapGetStr(data, "key_name")

		meta := Meta{
			SuportVersion: suportVersion,
			GraphType:     graph.ViewGraphType,
			GraphDir:      graph.GraphDir,
			ConfirmTime:   confirmTime,
			FontSize:      14,
			FontStep:      1,
			ImagesMap:     imageMap,
			RenderedItems: &renderedItems,
		}
		label := renderLabel(graph.RootData.DisplayExpression, data)

		if graph.RootData.GraphType != NoneType {
			renderedItems = append(renderedItems, guid)
		}

		switch graph.ViewGraphType {
		case GroupType:
			dot += fmt.Sprintf(`{rank=same; "%s"; %s[id="%s"; label="%s"; fontsize=%s; penwidth=1;width=2; image="%s"; labelloc="b"; shape="box";`,
				graph.RootData.NodeGroupName, guid, guid, label, strconv.FormatFloat(meta.FontSize, 'g', -1, 64), option.ImageMap[graph.RootData.CiType])

			if meta.SuportVersion == "yes" {
				dot += `color="#dddddd";penwidth=1;`
			}

			dot += "]}\n"

		case SubgraphType:
			depth := countDepth(graph)

			tooltip := keyName
			if tooltip == "" {
				tooltip = label
			}

			// 忽略 none 类型元素
			if graph.RootData.GraphType != NoneType {
				meta.FontSize = 20
				meta.FontStep = ((meta.FontSize - 14.0) * 1.0) / float64(depth)

				dot += fmt.Sprintf("subgraph cluster_%s { \n", guid)
				dot += fmt.Sprintf("id=%s;\n", guid)
				dot += fmt.Sprintf("fontsize=%s;\n", strconv.FormatFloat(meta.FontSize, 'f', -1, 64))
				dot += fmt.Sprintf("label=\"%s\";\n", label)
				dot += fmt.Sprintf("tooltip=\"%s\";\n", tooltip)
				dot += fmt.Sprintf("%s[penwidth=0;width=0;height=0;label=\"\"];\n", guid)

				style := getStyle(graph.RootData.GraphConfigData, graph.RootData.GraphConfigs, data, meta, DefaultStyle, true)
				dot += fmt.Sprintf("%s\n", style)
			}
		}

		for _, child := range graph.RootData.Children {
			if isFilterFailed(child, data) {
				continue
			}

			ret := renderChild(guid, child, data, meta, true)
			if ret.Error != nil {
				return "", ret.Error
			}

			dot += ret.DotString

			renderedItems = append(renderedItems, ret.RenderedItems...)
			lines = append(lines, ret.Lines...)
		}

		if graph.ViewGraphType == SubgraphType {
			if graph.RootData.GraphType != NoneType {
				dot += "}\n"
			}
		}
	}

	for _, line := range lines {
		dotLine := renderLine(line.Setting, line.DataList, line.MetaData, renderedItems)
		dot += dotLine
	}

	dot += "}\n"

	return
}

// renderChildren render children elements
func renderChildren(children []*models.GraphElementNode, data map[string]interface{}, meta Meta) RenderResult {
	var dot string
	var lines []Line
	var renderedItems []string

	guid := mapGetStr(data, "guid")
	for _, child := range children {
		ret := renderChild(guid, child, data, meta, true)
		dot += ret.DotString
		lines = append(lines, ret.Lines...)
		renderedItems = append(renderedItems, ret.RenderedItems...)
	}

	return RenderResult{
		DotString:     dot,
		Lines:         lines,
		RenderedItems: renderedItems,
	}
}

// renderChild render child element
func renderChild(parentGuid string, child *models.GraphElementNode, data map[string]interface{}, meta Meta, needArrange bool) (ret RenderResult) {

	//log.Logger.Debug("renderChild: ", log.String("parent", parent.Id), log.String("child.Id", child.Id), log.String("graphType", child.GraphType), log.String("dataName", child.DataName))

	if meta.GraphType == SubgraphType {
		meta.FontSize = math.Round((meta.FontSize-meta.FontStep)*100) / 100
	}

	var childData []map[string]interface{}
	if childData, ret.Error = mapGetMapList(data, child.DataName); ret.Error != nil {
		return
	}

	switch child.GraphType {
	case SubgraphType:
		ret = renderSubgraph(child, childData, meta)
	case ImageType:
		ret = renderImage(child, parentGuid, childData, meta)
		//if meta.GraphType == SubgraphType && needArrange {
		//	ret.DotString += arrangeNodes(childData)
		//}
	case NodeType:
		ret = renderNode(child, childData, meta)
		//if meta.GraphType == SubgraphType && needArrange {
		//	ret.DotString += arrangeNodes(childData)
		//}
	case LineType:
		ret = RenderResult{
			Lines: []Line{{
				Setting:  child,
				DataList: childData,
				MetaData: meta,
			}},
		}
	}
	return
}

func renderSubgraph(el *models.GraphElementNode, dataList []map[string]interface{}, meta Meta) RenderResult {
	var renderedItems []string
	var lines []Line

	var dot strings.Builder
	for _, data := range dataList {
		// 跳过none元素,实现zone跨代合并
		if el.GraphType == NoneType {
			continue
		}

		guid := mapGetStr(data, "guid")
		if isFilterFailed(el, data) {
			continue
		}
		keyName := mapGetStr(data, "key_name")

		if isIn(guid, *meta.RenderedItems) {
			continue
		}

		renderedItems = append(renderedItems, guid)

		label := renderLabel(el.DisplayExpression, data)
		style := getStyle(el.GraphConfigData, el.GraphConfigs, data, meta, DefaultStyle, true)
		tooltip := keyName
		if tooltip == "" {
			tooltip = label
		}
		subgraphAttrs := []string{
			"id=" + guid,
			"fontsize=" + strconv.FormatFloat(meta.FontSize, 'f', -1, 64),
			"label=\"" + label + "\"",
			"tooltip=\"" + tooltip + "\"",
			style,
		}

		// 写入 subgraph
		dot.WriteString(fmt.Sprintf("subgraph cluster_%s {\n", guid))
		dot.WriteString(strings.Join(subgraphAttrs, ";") + "\n")
		dot.WriteString(fmt.Sprintf("%s[penwidth=0;width=0;height=0;label=\"\"];\n", guid))

		if el.Children != nil {
			ret := renderChildren(el.Children, data, meta)
			lines = append(lines, ret.Lines...)
			renderedItems = append(renderedItems, ret.RenderedItems...)
			dot.WriteString(ret.DotString)
		}

		dot.WriteString("}\n")

	}
	return RenderResult{DotString: dot.String(), Lines: lines, RenderedItems: renderedItems}
}

// renderImage render image element basically as same to the renderNode
func renderImage(el *models.GraphElementNode, parentGuid string, dataList []map[string]interface{}, meta Meta) RenderResult {
	var renderedItems []string
	var lines []Line
	var dotString string

	var defaultImageStyle string
	if meta.SuportVersion == "yes" {
		defaultImageStyle = `color="#dddddd";penwidth=1;`
	} else {
		defaultImageStyle = `color="transparent";penwidth=1;`
	}

	for _, data := range dataList {
		guid := mapGetStr(data, "guid")
		if isFilterFailed(el, data) {
			continue
		}
		if isIn(guid, *meta.RenderedItems) {
			continue
		}
		renderedItems = append(renderedItems, guid)

		nodeAttrs := []string{
			fmt.Sprintf("id=%s", guid),
			fmt.Sprintf("fontsize=%s", strconv.FormatFloat(meta.FontSize, 'f', -1, 64)),
		}

		shape := getShape(el.GraphShapeData, el.GraphShapes, data, ShapeBox)
		// 为空时不设置
		if shape != "" {
			nodeAttrs = append(nodeAttrs, fmt.Sprintf("shape=\"%s\"", shape))
		}

		style := getStyle(el.GraphConfigData, el.GraphConfigs, data, meta, defaultImageStyle, true)
		label := renderLabel(el.DisplayExpression, data)
		nodeAttrs = append(nodeAttrs,
			"width=1.1",
			"height=1.1",
			`labelloc="b"`,
			"fixedsize=true",
			fmt.Sprintf(`label="%s"`, label),
			fmt.Sprintf(`tooltip="%s"`, label),
			fmt.Sprintf(`image="%s"`, meta.ImagesMap[el.CiType]),
			style,
		)

		nodeString := fmt.Sprintf("%s[%s];\n", guid, strings.Join(nodeAttrs, ";"))
		if meta.GraphType == GroupType {
			dotString += fmt.Sprintf("{rank=same;\"%s\"; %s}\n", el.NodeGroupName, nodeString)
			if parentGuid != "" {
				dotString += fmt.Sprintf("%s -> %s [arrowsize=0]\n", parentGuid, guid)
			}
		}

		// 找到zones，并从原来的children中剔除
		var zoneRoot *models.GraphElementNode

		// 深度拷贝正常的children，用于后续正常渲染
		normalChildren := make([]*models.GraphElementNode, len(el.Children))
		copy(normalChildren, el.Children)
		log.Logger.Debug("renderImage: ", log.JsonObj("normalChildren-copy", normalChildren))
		for i, c := range normalChildren {
			if c.GraphType == SubgraphType {
				normalChildren = append(normalChildren[:i], normalChildren[i+1:]...)
				zoneRoot = c
				break
			}
		}

		// 继续渲染 normalChildren
		ret := renderChildren(normalChildren, data, meta)
		nodeString += ret.DotString
		lines = append(lines, ret.Lines...)
		renderedItems = append(renderedItems, ret.RenderedItems...)

		if el.LineStartData != "" && el.LineEndData != "" {
			el.Children = nil
			lines = append(lines, Line{
				Setting:  el,
				MetaData: meta,
				DataList: []map[string]interface{}{data},
			})
		}

		// 向外包裹区域
		if zoneRoot != nil {
			zones := getZones(zoneRoot, data)
			for _, zone := range zones {
				nodeString = fmt.Sprintf(
					"subgraph cluster_%s {\nid=%s;label=\"%s\";tooltip=\"%s\";%s\n%s}\n",
					zone.guid, zone.guid, zone.label, zone.tooltip, zone.style, nodeString,
				)

			}
		}

		// 追加包裹后的元素
		dotString += nodeString
	}

	return RenderResult{
		DotString:     dotString,
		Lines:         lines,
		RenderedItems: renderedItems,
	}
}

func renderNode(el *models.GraphElementNode, dataList []map[string]interface{}, meta Meta) RenderResult {
	var renderedItems []string
	var lines []Line
	var dotString string

	for _, data := range dataList {
		guid := mapGetStr(data, "guid")
		if isFilterFailed(el, data) {
			continue
		}
		if isIn(guid, *meta.RenderedItems) {
			continue
		}
		renderedItems = append(renderedItems, guid)

		nodeAttrs := []string{
			fmt.Sprintf("id=%s", guid),
			fmt.Sprintf("fontsize=%s", strconv.FormatFloat(meta.FontSize, 'f', -1, 64)),
		}

		shape := getShape(el.GraphShapeData, el.GraphShapes, data, "")
		// 为空时不设置
		if shape != "" {
			nodeAttrs = append(nodeAttrs, fmt.Sprintf("shape=\"%s\"", shape))
		}

		style := getStyle(el.GraphConfigData, el.GraphConfigs, data, meta, DefaultStyle, true)
		label := renderLabel(el.DisplayExpression, data)
		nodeAttrs = append(nodeAttrs,
			//fmt.Sprintf("shape=\"%s\"", shape),
			//fmt.Sprintf("width=%.1f", 4.0),
			fmt.Sprintf("label=\"%s\"", label),
			fmt.Sprintf("tooltip=\"%s\"", label),
			style,
		)

		nodeString := fmt.Sprintf("%s[%s];\n", guid, strings.Join(nodeAttrs, ";"))

		if meta.GraphType == GroupType {
			dotString += fmt.Sprintf("{rank=same;\"%s\"; %s}\n", el.NodeGroupName, nodeString)
		}

		// 找到zones，并从原来的children中剔除
		var zoneRoot *models.GraphElementNode

		// 深度拷贝正常的children，用于后续正常渲染
		normalChildren := make([]*models.GraphElementNode, len(el.Children))
		copy(normalChildren, el.Children)
		for i, c := range normalChildren {
			if c.GraphType == SubgraphType {
				normalChildren = append(normalChildren[:i], normalChildren[i+1:]...)
				zoneRoot = c
				break
			}
		}

		// 继续渲染 normalChildren
		ret := renderChildren(normalChildren, data, meta)
		nodeString += ret.DotString
		lines = append(lines, ret.Lines...)
		renderedItems = append(renderedItems, ret.RenderedItems...)

		if el.LineStartData != "" && el.LineEndData != "" {
			normalChildren = nil
			lines = append(lines, Line{
				Setting:  el,
				MetaData: meta,
				DataList: []map[string]interface{}{data},
			})
		}

		// 向外包裹区域
		if zoneRoot != nil {
			zones := getZones(zoneRoot, data)
			for _, zone := range zones {
				nodeString = fmt.Sprintf(
					"subgraph cluster_%s {\nid=%s;label=\"%s\";tooltip=\"%s\";%s\n%s}\n",
					zone.guid, zone.guid, zone.label, zone.tooltip, zone.style, nodeString,
				)
			}
		}

		// 追加包裹后的元素
		dotString += nodeString
	}

	return RenderResult{
		DotString:     dotString,
		Lines:         lines,
		RenderedItems: renderedItems,
	}
}

func renderLine(el *models.GraphElementNode, dataList []map[string]interface{}, meta Meta, renderedItems []string) string {
	var dot strings.Builder
	var lines []Line

	for _, data := range dataList {
		if isFilterFailed(el, data) {
			continue
		}

		keyName := mapGetStr(data, "key_name")
		guid := mapGetStr(data, "guid")

		for _, child := range el.Children {
			ret := renderChild("", child, data, meta, false)
			if child.GraphType != LineType {
				dot.WriteString(ret.DotString)
				lines = append(lines, ret.Lines...)
				renderedItems = append(renderedItems, ret.RenderedItems...)
			}
		}

		headLines := asStringList(data[el.LineStartData])
		tailLines := asStringList(data[el.LineEndData])

		for _, hLine := range headLines {
			for _, tLine := range tailLines {
				if !isIn(hLine, renderedItems) || !isIn(tLine, renderedItems) {
					fmt.Printf("ignore line: %s -> %s\n items=%s", hLine, tLine, renderedItems)
					continue
				}

				lineString := fmt.Sprintf("%s -> %s", hLine, tLine)
				lineAttrs := []string{
					fmt.Sprintf(`id="%s"`, guid),
					fmt.Sprintf("fontsize=%.2f", meta.FontSize*0.6),
				}

				if el.GraphType == LineType {
					label := renderLabel(el.DisplayExpression, data)
					switch el.LineDisplayPosition {
					case "middle":
						lineAttrs = append(lineAttrs, fmt.Sprintf(`label="%s"`, label))
					case "head":
						lineAttrs = append(lineAttrs, fmt.Sprintf(`headlabel="%s"`, label))
					case "tail":
						log.Logger.Debug("renderLine style", log.String("taillabel", label))
						lineAttrs = append(lineAttrs, fmt.Sprintf(`taillabel="%s"`, label))
					}

					tooltip := keyName
					if tooltip == "" {
						tooltip = label
					}
					lineAttrs = append(lineAttrs, fmt.Sprintf(`tooltip="%s"`, tooltip))
				}

				lineAttrs = append(lineAttrs, fmt.Sprintf("lhead=cluster_%s", tLine))
				lineAttrs = append(lineAttrs, fmt.Sprintf("ltail=cluster_%s", hLine))

				if el.GraphType == LineType {
					shape := getShape(el.GraphShapeData, el.GraphShapes, data, ShapeNormal)
					lineAttrs = append(lineAttrs, fmt.Sprintf("arrowhead=%s", shape))

					style := getStyle(el.GraphConfigData, el.GraphConfigs, data, meta, "penwidth=1;color=black;", true)
					lineAttrs = append(lineAttrs, style)
				} else {
					lineAttrs = append(lineAttrs, "arrowhead=icurve")
				}

				lineString += fmt.Sprintf("[%s];\n", strings.Join(lineAttrs, ";"))
				dot.WriteString(lineString)
			}
		}
	}

	return dot.String()
}
