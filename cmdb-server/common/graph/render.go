package graph

import (
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
)

func Render(graph models.GraphQuery, dataList []map[string]interface{}, option RenderOption) (string, error) {
	//log.Logger.Info("render graph", log.JsonObj("graph", graph), log.JsonObj("data", dataList))
	if graph.ViewGraphType == "sequence" {
		return RenderMermaid(graph, dataList, option)
	}
	return RenderDot(graph, dataList, option)
}
