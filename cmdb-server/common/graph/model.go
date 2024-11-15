package graph

import "github.com/WeBankPartners/we-cmdb/cmdb-server/models"

type RenderOption struct {
	SuportVersion string            `json:"suport_version"`
	ImageMap      map[string]string `json:"image_map"`
}

type Meta struct {
	GraphType     string            `json:"graph_type"`
	GraphDir      string            `json:"graph_dir"`
	ConfirmTime   string            `json:"confirm_time"`
	FontSize      float64           `json:"fontSize"`
	FontStep      float64           `json:"font_step"`
	SuportVersion string            `json:"suport_version"`
	ImagesMap     map[string]string `json:"imagesMap"`
	RenderedItems *[]string         `json:"renderedItems"`
}

type Line struct {
	Setting  *models.GraphElementNode `json:"setting"`
	DataList []map[string]interface{} `json:"datas"`
	MetaData Meta                     `json:"metadata"`
}

type RenderResult struct {
	DotString     string   `json:"dot_string"`
	Lines         []Line   `json:"lines"`
	RenderedItems []string `json:"renderedItems"`
	Error         error    `json:"error,omitempty"`
}

type StyleConfig struct {
	Name          string `json:"name"`
	SuportVersion string `json:"suport_version"`
}

type Link struct {
	Start      map[string]interface{} `json:"start"`
	End        map[string]interface{} `json:"end"`
	Text       string                 `json:"text"`
	StartLabel string                 `json:"startLabel"`
	EndLabel   string                 `json:"endLabel"`
	Seq        int                    `json:"seq"`
}

type InvokeResult struct {
	Lines [][]interface{}
	Links []Link
	Nodes []map[string]interface{}
}

type Zone struct {
	label   string
	guid    string
	tooltip string
	style   string
}
