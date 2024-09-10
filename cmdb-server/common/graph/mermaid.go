package graph

import (
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"log"
)

func RenderMermaid(graph models.GraphQuery, dataList []map[string]interface{}, option RenderOption) (dot string, err error) {
	log.Fatal("RenderMermaid not supported")
	return "", nil
}
