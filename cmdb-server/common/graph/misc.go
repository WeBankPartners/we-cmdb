package graph

import (
	"encoding/json"
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"math"
	"strings"
)

func mapGetStr(m map[string]interface{}, attr string) string {
	if v, ok := m[attr].(string); ok {
		return v
	}
	return ""
}

func isIn(str string, strList []string) bool {
	for _, item := range strList {
		if item == str {
			return true
		}
	}
	return false
}

func asList(data interface{}) []string {
	// Helper function to ensure the data is converted to a list of strings
	if list, ok := data.([]string); ok {
		return list
	}
	return []string{data.(string)}
}

func isFilterFailed(setting *models.GraphElementNode, data map[string]interface{}) bool {
	var filterValues []string
	if setting.GraphFilterData != "" && setting.GraphFilterValues != "" {
		if err := json.Unmarshal([]byte(setting.GraphFilterValues), &filterValues); err != nil {
			return false
		}

		wantVal := mapGetStr(data, setting.GraphFilterData)
		return !isIn(wantVal, filterValues)
	}
	return false
}

func renderLabel(expression string, data map[string]interface{}) string {
	var parts []string
	if err := json.Unmarshal([]byte(expression), &parts); err != nil {
		return ""
	}

	label := ""
	for _, value := range parts {
		if value[0] == '\'' {
			label += value[1 : len(value)-1]
		} else {
			label += exprGetString(data, value)
		}
	}
	return label
}

func exprGetString(data map[string]interface{}, expr string) string {
	// 将 expr 按 "." 分割成多个部分
	parts := strings.Split(expr, ".")

	// 从顶层的 data 开始，深度搜索，直到非map的part
	result := data
	for _, part := range parts {
		// 判断当前 result 是否为 map[string]interface{} 类型
		if temp, ok := result[part].(map[string]interface{}); ok {
			result = temp
		} else {
			// 如果取不到值，则返回expr
			if value, exists := result[part]; exists {
				return value.(string)
			}
			return expr
		}
	}
	// 如果取不到值，则返回expr
	return expr
}

func getShape(graphShapeData, graphShapes string, data map[string]interface{}, defaultShape string) string {
	if graphShapeData != "" {
		var shapesMap map[string]string
		if err := json.Unmarshal([]byte(graphShapes), &shapesMap); err == nil {
			key := exprGetString(data, graphShapeData)
			shape, exists := shapesMap[key]
			if exists {
				return strings.TrimSuffix(shape, ";")
			}
		}
	}
	shape := graphShapes
	if shape == "" {
		shape = defaultShape
	}
	return strings.TrimSuffix(shape, ";")
}

func getStyle(
	graphConfigData string,
	graphConfigs string,
	data map[string]interface{},
	metadata Meta,
	defaultStyle string,
) string {
	// 确保 confirm_time 和 update_time 存在
	confirmTime := ""
	if val, exists := data["confirm_time"]; exists {
		confirmTime = val.(string)
	}
	updateTime := ""
	if val, exists := data["update_time"]; exists {
		updateTime = val.(string)
	}

	// 处理配置信息
	var userStyleMap map[string]string
	useMapping := graphConfigData != ""
	if useMapping {
		if err := json.Unmarshal([]byte(graphConfigs), &userStyleMap); err != nil {
			// 如果解析失败，则返回默认样式
			return defaultStyle
		}
	}

	// 根据条件返回样式
	if metadata.SuportVersion == "yes" &&
		(confirmTime == "" || (confirmTime == metadata.ConfirmTime && confirmTime == updateTime)) &&
		useMapping {
		exprResult := exprGetString(data, graphConfigData)
		if style, exists := userStyleMap[exprResult]; exists && style != "" {
			return style
		}
	} else {
		if useMapping {
			return defaultStyle
		}

		if graphConfigs != "" {
			return graphConfigs
		}
	}

	return defaultStyle
}

func calculateShapeLabel(shape string, width, fontSize float64, label string) string {
	// 形状对应的缩放因子
	factorMapping := map[string]float64{
		"ellipse": 0.00887311,
		"box":     0.0066548,
		"diamond": 0.01611,
		"hexagon": 0.01224489,
		"circle":  0.007653061,
	}

	// 获取缩放因子，默认是 ellipse 的值
	scaleFactor, ok := factorMapping[shape]
	if !ok {
		scaleFactor = factorMapping["ellipse"]
	}

	// 计算可以显示的字符数
	charLength := int(width / scaleFactor / fontSize)
	if charLength < 1 {
		charLength = 1
	}

	// 根据可显示的字符数截断标签，并加上省略号
	if len(label) > charLength {
		return label[:charLength-3] + "..."
	}
	return label
}

func arrangeNodes(nodes []map[string]interface{}) string {
	var dot strings.Builder
	var rowHeadNodes []string

	if len(nodes) > 3 {
		numRow := int(math.Ceil(math.Sqrt(float64(len(nodes)))))

		for index, node := range nodes {
			guid := mapGetStr(node, "guid")

			if index%numRow == 0 {
				dot.WriteString("{rank=same;")
				rowHeadNodes = append(rowHeadNodes, guid)
			}

			dot.WriteString(guid + ";")

			if index%numRow == numRow-1 {
				dot.WriteString("}\n")
			}
		}

		if (len(nodes)-1)%numRow != numRow-1 {
			dot.WriteString("}\n")
		}

		for i := 0; i < len(rowHeadNodes)-1; i++ {
			dot.WriteString(fmt.Sprintf("%s->%s[penwidth=0;minlen=1;arrowsize=0];\n", rowHeadNodes[i], rowHeadNodes[i+1]))
		}
	}

	return dot.String()
}

func countDepth(graph models.GraphQuery) int {
	var dfs func(*models.GraphElementNode, int) int
	dfs = func(curNode *models.GraphElementNode, curDepth int) int {
		if curNode.Children == nil || len(curNode.Children) == 0 {
			return curDepth
		}

		maxDepth := curDepth
		for _, child := range curNode.Children {
			childDepth := dfs(child, curDepth+1)
			if childDepth > maxDepth {
				maxDepth = childDepth
			}
		}
		return maxDepth
	}

	maxDepth := 0
	for _, child := range graph.RootData.Children {
		childDepth := dfs(child, 1)
		if childDepth > maxDepth {
			maxDepth = childDepth
		}
	}
	return maxDepth
}

func copyMetaData(metaData Meta) Meta {
	newMetaData := Meta{
		ConfirmTime:   metaData.ConfirmTime,
		FontSize:      metaData.FontSize,
		FontStep:      metaData.FontStep,
		GraphDir:      metaData.GraphDir,
		GraphType:     metaData.GraphType,
		ImagesMap:     metaData.ImagesMap,
		RenderedItems: metaData.RenderedItems,
		SuportVersion: metaData.SuportVersion,
	}

	if newMetaData.GraphType == SubgraphType {
		// 修改meta的副本不会影响外面的meta，不再需要手动copy
		newMetaData.FontSize = math.Round((newMetaData.FontSize-newMetaData.FontStep)*100) / 100
	}
	return newMetaData
}
