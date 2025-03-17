package graph

import (
	"fmt"
	"regexp"
	"sort"
	"strconv"
	"strings"

	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
)

var (
	reNote = regexp.MustCompile(`note\s+((?:left\s+of)|(?:right\s+of)|over)(?:\s+[-_a-z0-9]+(?:,\s*[-_a-z0-9]+)?)?\s*:\s*(.*)`)
)

func RenderMermaid(graph models.GraphQuery, dataList []map[string]interface{}) (string, error) {
	dot := "sequenceDiagram\n"
	for _, data := range dataList {
		if ret := renderSequence(graph.RootData, []map[string]interface{}{data}); ret.Error != nil {
			return "", ret.Error
		} else {
			dot += ret.DotString
		}
	}

	return dot, nil
}

func renderSequence(el *models.GraphElementNode, dataList []map[string]interface{}) RenderResult {
	var dotString string
	var allLinks []Link

	for _, data := range dataList {
		if isFilterFailed(el, data) {
			continue
		}

		var assistSetting, invokeSetting *models.GraphElementNode
		var assistItems, invokeItems []map[string]interface{}

		// 遍历子项，按类型分类
		for _, subSetting := range el.Children {
			items, _ := mapGetMapList(data, subSetting.DataName)
			orderField := subSetting.OrderData
			if orderField == "" {
				orderField = "order_number"
			}

			// 根据item["order_number"]排序
			sort.SliceStable(items, func(i, j int) bool {
				iOrder := 0
				if vi, ok := items[i][orderField].(string); ok {
					iOrder, _ = strconv.Atoi(vi)
				}
				jOrder := 0
				if vj, ok := items[j][orderField].(string); ok {
					jOrder, _ = strconv.Atoi(vj)
				}
				return iOrder < jOrder
			})

			// 根据 graphType 分类处理
			switch subSetting.GraphType {
			case AssistItem:
				assistSetting = subSetting
				for i, item := range items {
					if !isFilterFailed(subSetting, item) {
						item["__index"] = i
						assistItems = append(assistItems, item)
					}
				}

			case ServiceInvokeItem:
				invokeSetting = subSetting
				for i, item := range items {
					if !isFilterFailed(subSetting, item) {
						item["__index"] = i
						invokeItems = append(invokeItems, item)
					}
				}
			}
		}

		// 渲染子项
		invokeResult := renderInvoke(invokeSetting, invokeItems)
		assistLinks := renderAssist(
			assistSetting, assistItems, invokeResult.Links,
		)

		// 合并并根据 item[5] 排序所有的 lines
		allLinks = append(allLinks, invokeResult.Links...)
		allLinks = append(allLinks, assistLinks...)
		sort.Slice(allLinks, func(i, j int) bool {
			return allLinks[i].Seq < allLinks[j].Seq
		})

		var existNodes []string
		for _, link := range invokeResult.Links {
			startGuid := link.Start["guid"].(string)
			endGuid := link.End["guid"].(string)

			if !isIn(startGuid, existNodes) {
				label := renderLabel(link.StartLabel, link.Start)
				existNodes = append(existNodes, startGuid)
				dotString += fmt.Sprintf("participant %s as ${%s}%s\n", startGuid, startGuid, label)
			}

			if !isIn(endGuid, existNodes) {
				existNodes = append(existNodes, endGuid)
				label := renderLabel(link.EndLabel, link.End)
				dotString += fmt.Sprintf("participant %s as ${%s}%s\n", endGuid, endGuid, label)
			}
		}

		for _, link := range allLinks {
			dotString += link.Text + "\n"
		}

	}

	return RenderResult{
		DotString: dotString,
	}
}

func renderInvoke(el *models.GraphElementNode, dataList []map[string]interface{}) InvokeResult {
	var lines [][]interface{}
	var nodes []map[string]interface{}
	for _, data := range dataList {
		label := renderLabel(el.DisplayExpression, data)
		for _, subSetting := range el.Children {
			if subSetting.GraphType == ServiceInvoke {
				subData, _ := mapGetMapList(data, subSetting.DataName)
				result := renderServiceInvoke(subSetting, subData)
				for _, item := range result.Lines {
					newItem := []interface{}{
						item[0],
						item[1],
						fmt.Sprintf("%s: ${%s}%s", item[2], data["guid"], label),
						item[3],
						item[4],
						data["__index"],
					}
					lines = append(lines, newItem)
				}
				nodes = append(nodes, result.Nodes...)
			}
		}
	}

	nodeMapping := make(map[string]map[string]interface{})
	for _, node := range nodes {
		nodeMapping[node["guid"].(string)] = node
	}

	var links []Link
	for _, line := range lines {
		links = append(links, Link{
			Start:      nodeMapping[line[0].(string)],
			End:        nodeMapping[line[1].(string)],
			Text:       line[2].(string),
			StartLabel: line[3].(string),
			EndLabel:   line[4].(string),
			Seq:        line[5].(int),
		})
	}

	return InvokeResult{
		Links: links,
		Nodes: nodes,
	}
}

func renderServiceInvoke(el *models.GraphElementNode, dataList []map[string]interface{}) InvokeResult {
	var lines [][]interface{}
	var nodes []map[string]interface{}
	defaultShape := "->>"

	for _, data := range dataList {
		shape := getShape(
			el.GraphShapeData,
			el.GraphShapes,
			data,
			defaultShape,
		)

		headNodes := asStringList(data[el.LineStartData])
		tailNodes := asStringList(data[el.LineEndData])

		for _, hNode := range headNodes {
			for _, tNode := range tailNodes {
				lines = append(lines, []interface{}{hNode, tNode, fmt.Sprintf("%v %s %v", hNode, shape, tNode)})
			}
		}

		for _, subSetting := range el.Children {
			if subSetting.GraphType == NodeType {
				nodeDataList, _ := mapGetMapList(data, subSetting.DataName)
				nodes = append(nodes, nodeDataList...)
				for i := range lines {
					lines[i] = append(lines[i], subSetting.DisplayExpression)
				}
			}
		}
	}

	return InvokeResult{
		Lines: lines,
		Nodes: nodes,
	}
}

func renderAssist(el *models.GraphElementNode, dataList []map[string]interface{}, invokeLines []Link) []Link {
	// 辅助函数：查找 invokeLines 中索引小于给定值的最大项
	findMaxLessThan := func(items []Link, index int) Link {
		var itemFind Link
		indexFind := -1
		for _, item := range items {
			if item.Seq < index && item.Seq > indexFind {
				indexFind = item.Seq
				itemFind = item
			}
		}
		return itemFind
	}

	var links []Link
	activateStackItems := make([]string, 0)

	for _, data := range dataList {
		label := renderLabel(el.DisplayExpression, data)
		formattedLabel := strings.TrimSpace(strings.ToLower(label))
		dataGuid := data["guid"].(string)
		dataGuidLabel := fmt.Sprintf("${%s}", dataGuid)

		switch {
		case strings.HasPrefix(formattedLabel, "activate"):
			invokeLine := findMaxLessThan(invokeLines, data["__index"].(int))
			if invokeLine.End != nil {
				guid := invokeLine.End["guid"].(string)
				label = "ACTIVATE " + guid
				activateStackItems = append(activateStackItems, guid)
			}

		case strings.HasPrefix(formattedLabel, "deactivate"):
			if len(activateStackItems) > 0 {
				guid := activateStackItems[len(activateStackItems)-1]
				activateStackItems = activateStackItems[:len(activateStackItems)-1]
				label = "DEACTIVATE " + guid
			}

		case strings.HasPrefix(formattedLabel, "note"):
			rets := reNote.FindStringSubmatch(strings.ToLower(label))
			invokeLine := findMaxLessThan(invokeLines, data["__index"].(int))

			guid1, guid2 := "", ""
			if invokeLine.Start != nil {
				guid1 = invokeLine.Start["guid"].(string)
			}
			if invokeLine.End != nil {
				guid2 = invokeLine.End["guid"].(string)
			}

			if len(rets) > 0 {
				dir := strings.ToLower(rets[1])
				if strings.HasPrefix(dir, "left") {
					label = fmt.Sprintf("NOTE LEFT OF %s : ${%s}%s", guid2, dataGuid, rets[2])
				} else if strings.HasPrefix(dir, "right") {
					label = fmt.Sprintf("NOTE RIGHT OF %s : ${%s}%s", guid2, dataGuid, rets[2])
				} else {
					label = fmt.Sprintf("NOTE OVER %s,%s : ${%s}%s", guid1, guid2, dataGuid, rets[2])
				}
			} else {
				label = fmt.Sprintf("NOTE LEFT OF %s : ${%s}%s", guid2, dataGuid, label[len("note"):])
			}

		case strings.HasPrefix(formattedLabel, "alt"):
			label += dataGuidLabel

		case strings.HasPrefix(formattedLabel, "par"):
			label += dataGuidLabel

		case strings.HasPrefix(formattedLabel, "and"):
			label += dataGuidLabel

		case strings.HasPrefix(formattedLabel, "opt"):
			label += dataGuidLabel
		}

		links = append(links, Link{
			Text: label,
			Seq:  data["__index"].(int),
		})
	}

	return links
}
