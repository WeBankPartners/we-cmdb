package graph

import (
	"encoding/json"
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"log"
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
	SubgraphType = "subgraph"
	ImageType    = "image"
	NodeType     = "node"
	LineType     = "line"
	GroupType    = "group"
)

// RenderDot render dot graph
func RenderDot(graph models.GraphQuery, dataList []map[string]interface{}, option RenderOption) (dot string, err error) {
	suportVersion := option.SuportVersion
	imageMap := option.ImageMap

	dot = "\ndigraph G {\n"
	dot += fmt.Sprintf("rankdir=%s;edge[minlen=3];compound=true;\n", graph.GraphDir)
	if graph.ViewGraphType == "group" {
		dot += "Node [color=\"transparent\";fixedsize=\"true\";width=\"1.1\";height=\"1.1\";shape=box];\n"
		dot += "{\nnode [shape=plaintext];\n" + graph.NodeGroups + ";\n}\n"
	}

	var renderedItems []string
	var lines []Line

	for _, data := range dataList {
		confirmTime := mapGetStringAttr(data, "confirm_time")
		guid := mapGetStringAttr(data, "guid")
		keyName := mapGetStringAttr(data, "key_name")

		meta := Meta{
			SuportVersion: suportVersion,
			GraphType:     graph.ViewGraphType,
			GraphDir:      graph.GraphDir,
			ConfirmTime:   confirmTime,
			FontSize:      14,
			FontStep:      0,
			ImagesMap:     imageMap,
			RenderedItems: &renderedItems,
		}
		label := renderLabel(graph.RootData.DisplayExpression, data)
		renderedItems = append(renderedItems, guid)

		tooltip := keyName
		if tooltip == "" {
			tooltip = label
		}

		switch graph.ViewGraphType {
		case GroupType:
			dot += fmt.Sprintf("{rank=same; \"%s\"; %s[id=\"%s\";label=\"%s\"; fontsize=%s; penwidth=1;width=2; image=\"%s\"; labelloc=\"b\"; shape=\"box\";",
				graph.RootData.NodeGroupName, guid, guid, label, strconv.FormatFloat(meta.FontSize, 'g', -1, 64), option.ImageMap[graph.RootData.CiType])

			if meta.SuportVersion == "yes" {
				dot += "color=\"#dddddd\";penwidth=1;"
			}

			dot += "}\n"

		case SubgraphType:
			depth := countDepth(graph)
			meta.FontSize = 20
			meta.FontStep = ((meta.FontSize - 14.0) * 1.0) / float64(depth-1)
			dot += fmt.Sprintf("subgraph cluster_%s { \n", guid)
			dot += fmt.Sprintf("id=%s;\n", guid)
			dot += fmt.Sprintf("fontsize=%s;\n", strconv.FormatFloat(meta.FontSize, 'f', -1, 64))
			dot += fmt.Sprintf("label=\"%s\";\n", label)
			dot += fmt.Sprintf("tooltip=\"%s\";\n", tooltip)
			dot += fmt.Sprintf("%s[penwidth=0;width=0;height=0;label=\"\"];\n", guid)

			style := getStyle(graph.RootData.GraphConfigData, graph.RootData.GraphConfigs, data, meta, DefaultStyle)
			dot += fmt.Sprintf("%s\n", style)
		}

		for index, child := range graph.RootData.Children {
			if isFilterFailed(child, data) {
				continue
			}

			ret := renderChild(index, child, data, meta)
			if ret.Error != nil {
				return "", ret.Error
			}

			dot += ret.DotString
			renderedItems = append(renderedItems, ret.RenderedItems...)
			lines = append(lines, ret.Lines...)
		}

		if graph.ViewGraphType == SubgraphType {
			dot += "}\n"
		}
	}

	for index, line := range lines {
		dotLine := renderLine(line.Setting, line.DataList, line.MetaData, renderedItems)
		fmt.Printf("%d ---> \n %s", index, dotLine)
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

	for index, child := range children {
		ret := renderChild(index, child, data, meta)
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
func renderChild(index int, child *models.GraphElementNode, data map[string]interface{}, meta Meta) (ret RenderResult) {
	if meta.GraphType == SubgraphType {
		meta.FontSize = math.Round((meta.FontSize-meta.FontStep)*100) / 100
	}
	//newMeta := meta
	//newMeta := copyMetaData(meta)

	var childData []map[string]interface{}
	tmp, _ := json.Marshal(data[child.DataName])
	err := json.Unmarshal(tmp, &childData)
	if err != nil {
		log.Fatalf("childData err: %v+", err)
	}

	//fmt.Printf("childData: %v+", childData)
	//childData, ok = data[child.DataName].([]map[string]interface{})

	nodeDot := ""
	if child.GraphType != SubgraphType && meta.GraphType == SubgraphType {
		nodeDot = arrangeNodes(childData)
	}

	switch child.GraphType {
	case SubgraphType:
		ret = renderSubgraph(child, childData, meta)
	case ImageType:
		parentGuid := mapGetStringAttr(data, "guid")
		ret = renderImage(child, parentGuid, childData, meta)
		ret.DotString += nodeDot
	case NodeType:
		ret = renderNode(child, childData, meta)
		ret.DotString += nodeDot
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
		if isFilterFailed(el, data) {
			continue
		}
		guid := mapGetStringAttr(data, "guid")
		keyName := mapGetStringAttr(data, "key_name")

		if isIn(guid, *meta.RenderedItems) {
			continue
		}

		renderedItems = append(renderedItems, guid)

		label := renderLabel(el.DisplayExpression, data)
		style := getStyle(el.GraphConfigData, el.GraphConfigs, data, meta, DefaultStyle)

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

func renderImage(el *models.GraphElementNode, parentGuid string, dataList []map[string]interface{}, meta Meta) RenderResult {
	var renderedItems []string
	var lines []Line
	var dot strings.Builder
	var defaultImageStyle string

	if meta.SuportVersion == "yes" {
		defaultImageStyle = `color="#dddddd";penwidth=1;`
	} else {
		defaultImageStyle = `color="transparent";penwidth=1;`
	}

	for _, data := range dataList {
		guid := mapGetStringAttr(data, "guid")
		if isFilterFailed(el, data) {
			continue
		}

		if isIn(guid, *meta.RenderedItems) {
			continue
		}
		renderedItems = append(renderedItems, guid)
		var nodeString strings.Builder

		if meta.GraphType == "group" {
			nodeString.WriteString(fmt.Sprintf(`{rank=same;"%s"; %s`, el.NodeGroupName, guid))
		} else {
			nodeString.WriteString(guid)
		}

		label := renderLabel(el.DisplayExpression, data)

		nodeAttrs := []string{
			"id=" + guid,
			"fontsize=" + strconv.FormatFloat(meta.FontSize, 'g', 4, 64),
			"width=1.1",
			"height=1.1",
			fmt.Sprintf(`tooltip="%s"`, label),
			"fixedsize=true",
		}

		shape := getShape(el.GraphShapeData, el.GraphShapes, data, ShapeBox)
		style := getStyle(el.GraphConfigData, el.GraphConfigs, data, meta, defaultImageStyle)

		nodeAttrs = append(nodeAttrs, []string{
			fmt.Sprintf(`shape="%s"`, shape),
			`labelloc="b"`,
			fmt.Sprintf(`label="%s"`, calculateShapeLabel(shape, 1.1, meta.FontSize, label)),
			fmt.Sprintf(`image="%s"`, meta.ImagesMap[el.CiType]),
			style,
		}...)

		nodeString.WriteString("[" + strings.Join(nodeAttrs, ";") + "]\n")

		if meta.GraphType == "group" {
			nodeString.WriteString("}")
		}

		dot.WriteString(nodeString.String())

		if parentGuid != "" && meta.GraphType == "group" {
			dot.WriteString(fmt.Sprintf(`%s -> %s [arrowsize=0]\n`, parentGuid, guid))
		}

		ret := renderChildren(el.Children, data, meta)
		dot.WriteString(ret.DotString)
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
	}

	return RenderResult{
		DotString:     dot.String(),
		Lines:         lines,
		RenderedItems: renderedItems,
		Error:         nil,
	}
}

func renderNode(el *models.GraphElementNode, dataList []map[string]interface{}, meta Meta) RenderResult {
	var renderedItems []string
	var lines []Line
	var dot strings.Builder

	for _, data := range dataList {
		guid := mapGetStringAttr(data, "guid")

		if isFilterFailed(el, data) {
			continue
		}

		if isIn(guid, *meta.RenderedItems) {
			continue
		}

		renderedItems = append(renderedItems, guid)

		nodeWidth := 4.0
		nodeAttrs := []string{
			fmt.Sprintf("id=%s", guid),
			fmt.Sprintf("fontsize=%s", strconv.FormatFloat(meta.FontSize, 'f', -1, 64)),
		}

		label := renderLabel(el.DisplayExpression, data)

		shape := getShape(el.GraphShapeData, el.GraphShapes, data, ShapeEllipse)

		newLabel := calculateShapeLabel(shape, nodeWidth, meta.FontSize, label)

		style := getStyle(el.GraphConfigData, el.GraphConfigs, data, meta, DefaultStyle)

		nodeAttrs = append(nodeAttrs,
			fmt.Sprintf("shape=\"%s\"", shape),
			fmt.Sprintf("width=%.1f", nodeWidth),
			fmt.Sprintf("label=\"%s\"", newLabel),
			fmt.Sprintf("tooltip=\"%s\"", label),
			style,
		)

		nodeString := fmt.Sprintf("%s[%s];\n", guid, strings.Join(nodeAttrs, ";"))
		dot.WriteString(nodeString)

		if meta.GraphType == "group" {
			dot.WriteString(fmt.Sprintf("{rank=same;\"%s\"; %s}\n", el.NodeGroupName, nodeString))
		}

		ret := renderChildren(el.Children, data, meta)
		dot.WriteString(ret.DotString)
		lines = append(lines, ret.Lines...)
		renderedItems = append(renderedItems, ret.RenderedItems...)

		if el.LineStartData != "" && el.LineEndData != "" {
			el.Children = nil
			//el.Children = []*models.GraphElementNode{}
			//el.Children = make([]*models.GraphElementNode, 0)
			lines = append(lines, Line{
				Setting:  el,
				MetaData: meta,
				DataList: []map[string]interface{}{data},
			})
		}
	}

	return RenderResult{
		DotString:     dot.String(),
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

		for _, child := range el.Children {
			var ret RenderResult

			var childData []map[string]interface{}
			tmp, _ := json.Marshal(data[child.DataName])
			_ = json.Unmarshal(tmp, &childData)

			if meta.GraphType == SubgraphType {
				meta.FontSize = math.Round((meta.FontSize-meta.FontStep)*100) / 100
			}
			//newMeta := meta
			//newMeta := copyMetaData(meta)

			// Process based on the graphType
			switch child.GraphType {
			case SubgraphType:
				ret = renderSubgraph(child, childData, meta)
			case ImageType:
				parentGuid := mapGetStringAttr(data, "guid")
				ret = renderImage(child, parentGuid, childData, meta)
			case NodeType:
				ret = renderNode(child, childData, meta)
			case LineType:
				lines = append(lines, Line{
					Setting:  child,
					DataList: dataList,
					MetaData: meta,
				})
			}
			if child.GraphType != "line" {
				dot.WriteString(ret.DotString)
				lines = append(lines, ret.Lines...)
				renderedItems = append(renderedItems, ret.RenderedItems...)
			}

		}

		headLines := asList(data[el.LineStartData])
		tailLines := asList(data[el.LineEndData])

		for _, hLine := range headLines {
			for _, tLine := range tailLines {
				// Only render lines if both head and tail are already rendered
				if !isIn(hLine, renderedItems) || !isIn(tLine, renderedItems) {
					fmt.Printf("ignore line: %s -> %s\n items=%s", hLine, tLine, renderedItems)
					continue
				}

				// Create line string
				lineString := fmt.Sprintf("%s -> %s", hLine, tLine)
				lineAttrs := []string{
					fmt.Sprintf(`id="%s"`, data["guid"].(string)),
					fmt.Sprintf("fontsize=%.2f", meta.FontSize*0.6),
				}

				// Handle labels based on display position of line
				if el.GraphType == "line" {
					label := renderLabel(el.DisplayExpression, data)
					switch el.LineDisplayPosition {
					case "middle":
						lineAttrs = append(lineAttrs, fmt.Sprintf(`label="%s"`, label))
					case "head":
						lineAttrs = append(lineAttrs, fmt.Sprintf(`headlabel="%s"`, label))
					case "tail":
						lineAttrs = append(lineAttrs, fmt.Sprintf(`taillabel="%s"`, label))
					}
					lineAttrs = append(lineAttrs, fmt.Sprintf(`tooltip="%s"`, data["key_name"].(string)))
				}

				// Add attributes for clusters
				lineAttrs = append(lineAttrs, fmt.Sprintf("lhead=cluster_%s", tLine))
				lineAttrs = append(lineAttrs, fmt.Sprintf("ltail=cluster_%s", hLine))

				// Add arrowhead and style if it's a line graph type
				if el.GraphType == "line" {
					shape := getShape(el.GraphShapeData, el.GraphShapes, data, ShapeNormal)
					lineAttrs = append(lineAttrs, fmt.Sprintf("arrowhead=%s", shape))

					style := getStyle(el.GraphConfigData, el.GraphConfigs, data, meta, DefaultStyle)
					lineAttrs = append(lineAttrs, style)
				} else {
					lineAttrs = append(lineAttrs, "arrowhead=icurve")
				}

				// Append the line to the dot string
				lineString += fmt.Sprintf("[%s];\n", strings.Join(lineAttrs, ";"))
				dot.WriteString(lineString)
			}
		}
	}

	return dot.String()
}
