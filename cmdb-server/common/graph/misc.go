package graph

import (
	"encoding/json"
	"fmt"
	"math"
	"strings"

	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"go.uber.org/zap"
)

func mapGetMapList(m map[string]interface{}, attr string) ([]map[string]interface{}, error) {
	var childData []map[string]interface{}
	if tmp, err := json.Marshal(m[attr]); err != nil {
		return childData, fmt.Errorf("marshal attr %s err: %s", attr, err)
	} else {
		if err = json.Unmarshal(tmp, &childData); err != nil {
			return childData, fmt.Errorf("unmarshal attr %s err: %s", attr, err)
		}
	}

	return childData, nil
}

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

// asStringList ensure the data is converted to a list of strings
func asStringList(data interface{}) []string {
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
		log.Debug(nil, log.LOGGER_APP, "renderLabel for plain expression", zap.String("expression", expression))
		return ""
	}

	label := ""
	for _, value := range parts {
		if value[0] == '\'' {
			label += value[1 : len(value)-1]
		} else {
			// 支持列表数据：["DB","HTTP","RMB"]
			labelVal := exprGetString(data, value)
			if strings.Contains(labelVal, "[") {
				var valItems []string
				if err := json.Unmarshal([]byte(labelVal), &valItems); err == nil {
					labelVal = strings.Join(valItems, ",")
				}
			}
			label += labelVal
		}
	}
	log.Debug(nil, log.LOGGER_APP, "renderLabel for json expression",
		zap.String("expression", expression), zap.String("parts", strings.Join(parts, ",")), zap.String("label", label))
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
	addColorFilled bool,
	addWhite bool,
) string {

	if addColorFilled {
		defaultStyle += "style=filled;"
		if addWhite {
			defaultStyle += "fillcolor=white;"
		}
	}

	// 处理配置信息，支持两级配置
	var userStyleMap map[string]string
	var userStyleMapEmbeded map[string]map[string]string

	// 无配置，走默认
	if graphConfigData == "" {
		log.Debug(nil, log.LOGGER_APP, "No graphConfigData or graphConfigs found, use default style")
		return defaultStyle
	}

	// 根据条件返回样式
	var styleConfigs []StyleConfig

	// 确保 confirm_time 和 update_time 存在
	elConfirmTime := ""
	if val, exists := data["confirm_time"]; exists {
		elConfirmTime = val.(string)
	}
	elUpdateTime := ""
	if val, exists := data["update_time"]; exists {
		elUpdateTime = val.(string)
	}

	//isVersionMatched := metadata.SuportVersion == "yes" && (elConfirmTime == "" || (elConfirmTime == metadata.ConfirmTime && elConfirmTime == elUpdateTime))
	isVersionMatched := elConfirmTime == "" || (elConfirmTime == metadata.ConfirmTime && elConfirmTime == elUpdateTime)
	//isVersionMatched := metadata.SuportVersion == "yes" && (elConfirmTime == "" || elConfirmTime == metadata.ConfirmTime) && (elUpdateTime == "" || elConfirmTime == elUpdateTime)
	log.Debug(nil, log.LOGGER_APP, "getStyle start: ", zap.Bool("isVersionMatched", isVersionMatched),
		zap.String("elConfirmTime", elConfirmTime),
		zap.String("elUpdateTime", elUpdateTime),
		zap.String("metadata.ConfirmTime", metadata.ConfirmTime),
	)
	// 支持多级配置 {
	//  "graphConfigData": [{"name":"state","suport_version":"yes"},{"name":"subsystem_type","suport_version":"no"}],
	//  "graphConfigs": {
	//    "state": {
	//      "added_0": "pencolor=xxx;"
	//    },
	//    "subsystem_type": {
	//      "update_0": "pencolor=xxx;"
	//    }
	//  }
	//}

	// 尝试解析多层映射配置
	if err := json.Unmarshal([]byte(graphConfigData), &styleConfigs); err == nil {
		if err = json.Unmarshal([]byte(graphConfigs), &userStyleMapEmbeded); err != nil {
			// 如果解析失败，则返回默认样式
			log.Debug(nil, log.LOGGER_APP, "Failed to parse graphConfigs, use default style")
			return defaultStyle
		}

		var style string
		for _, styleConfig := range styleConfigs {
			if styleConfig.SuportVersion == "no" || styleConfig.SuportVersion == "yes" && isVersionMatched {
				configMap := userStyleMapEmbeded[styleConfig.Name]
				configKey := exprGetString(data, styleConfig.Name)
				if s, exists := configMap[configKey]; exists && s != "" {
					style += s
				}
			}
			if style != "" && addColorFilled && !strings.Contains(style, "style=") {
				log.Debug(nil, log.LOGGER_APP, "Add color filled for style in multi map config", zap.String("style", style))
				//style += "fillcolor=white;style=filled;"
				style += "style=filled;"
				if addWhite {
					style += "fillcolor=white;"
				}
			}
		}

		// 错误配置兜底
		if style == "" {
			log.Debug(nil, log.LOGGER_APP, "No style found, use default style")
			return defaultStyle
		}
		return style
	} else {
		log.Debug(nil, log.LOGGER_APP, "Failed to parse map of map graphConfigData", zap.Bool("isVersionMatched", isVersionMatched), zap.String("error", err.Error()), log.JsonObj("graphConfigData", graphConfigData), log.JsonObj("graphConfigs", graphConfigs))
	}

	// 尝试解析单层映射配置
	//if isVersionMatched {
	if err := json.Unmarshal([]byte(graphConfigs), &userStyleMap); err != nil {
		// 如果解析失败，则返回默认样式
		log.Debug(nil, log.LOGGER_APP, "Failed to parse single map of graphConfigData", zap.String("error", err.Error()), log.JsonObj("graphConfigs", graphConfigs))
		return defaultStyle
	}

	configKey := exprGetString(data, graphConfigData)
	log.Debug(nil, log.LOGGER_APP, "Add color filled for style in single map config", zap.String("configKey", configKey), log.JsonObj("userStyleMap", userStyleMap))
	if style, exists := userStyleMap[configKey]; exists && style != "" {
		if addColorFilled && !strings.Contains(style, "style=") {
			log.Debug(nil, log.LOGGER_APP, "Add color filled for style in single map config",
				zap.String("style", style), zap.String("graphConfigData", graphConfigData), log.JsonObj("data", data),
				zap.String("configKey", configKey), log.JsonObj("userStyleMap", userStyleMap))
			//style += "fillcolor=white;style=filled;"
			style += "style=filled;"
			if addWhite {
				style += "fillcolor=white;"
			}
		} else {
			log.Debug(nil, log.LOGGER_APP, "Add color filled for style in single map config", zap.Bool("addColorFilled", addColorFilled), log.JsonObj("style", style))
		}
		// 错误配置兜底
		if style == "" {
			log.Debug(nil, log.LOGGER_APP, "Add color filled for style in single map config, empty style final")
			return defaultStyle
		}
		return style
	}
	//}

	return defaultStyle
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

func getZones(zoneRoot *models.GraphElementNode, curData map[string]interface{}) []Zone {
	//log.Warn(nil, log.LOGGER_APP, "getZones childData: ", log.JsonObj("childData", childData))
	cur := zoneRoot
	childData, err := mapGetMapList(curData, cur.DataName)

	var zones []Zone
	if len(childData) == 0 || err != nil {
		log.Debug(nil, log.LOGGER_APP, "parse child data failed", zap.Error(err))
		return zones
	}

	data := childData[0]
	tooltip := mapGetStr(data, "key_name")
	guid := mapGetStr(data, "guid")
	label := renderLabel(cur.DisplayExpression, data)
	log.Debug(nil, log.LOGGER_APP, "getZones -> renderLabel", zap.String("label", label))
	if tooltip == "" {
		tooltip = label
	}

	style := getStyle(cur.GraphConfigData, cur.GraphConfigs, data, Meta{
		SuportVersion: "yes",
		ConfirmTime:   "",
	}, DefaultStyle, true, true)

	// ensure style ends with ;
	if style != "" && !strings.HasSuffix(style, ";") {
		style += ";"
	}

	zones = append(zones, Zone{
		guid:    guid,
		label:   label,
		tooltip: tooltip,
		style:   style,
	})

	// zones: [subgraph] -> [subgraph]
	if len(cur.Children) == 1 && cur.Children[0].GraphType == SubgraphType {
		subZones := getZones(cur.Children[0], childData[0])
		zones = append(zones, subZones...)
	}

	return zones
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
		scaleFactor = factorMapping[ShapeEllipse]
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
