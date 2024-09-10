package models

import "time"

var BaseElementColumns = []string{"graph", "report_object ", "show_table", "display_expression", "node_group_name", "line_start_data", "line_end_data", "line_display_position", "graph_type", "graph_shape_data", "graph_shapes", "graph_config_data", "graph_configs", "graph_filter_data", "graph_filter_values", "editable", "seq_no", "order_data", "update_operation"}

type SysViewTable struct {
	Id            string    `json:"viewId" xorm:"id"`
	Name          string    `json:"name" xorm:"name"`
	Report        string    `json:"report" xorm:"report"`
	Editable      string    `json:"editable" xorm:"editable"`
	SuportVersion string    `json:"suportVersion" xorm:"suport_version"`
	Multiple      string    `json:"multiple" xorm:"multiple"`
	CreateTime    time.Time `json:"createTime" xorm:"create_time"`
	CreateUser    string    `json:"createUser" xorm:"create_user"`
	UpdateTime    time.Time `json:"updateTime" xorm:"update_time"`
	UpdateUser    string    `json:"updateUser" xorm:"update_user"`
	FilterAttr    string    `json:"filterAttr" xorm:"filter_attr"`
	FilterValue   string    `json:"filterValue" xorm:"filter_value"`
}

type ViewQuery struct {
	Editable       string        `json:"editable" xorm:"editable"`
	SuportVersion  string        `json:"suportVersion" xorm:"suport_version"`
	Multiple       string        `json:"multiple" xorm:"multiple"`
	Report         string        `json:"report" xorm:"report"`
	CiType         string        `json:"ciType" xorm:"ci_type"`
	FilterAttr     string        `json:"-" xorm:"filter_attr"`
	FilterAttrName string        `json:"filterAttr" xorm:"filter_attr_name"`
	FilterValue    string        `json:"filterValue" xorm:"filter_value"`
	Graphs         []*GraphQuery `json:"graphs" xorm:"graphs"`
}

type ViewData struct {
	ViewId      string `json:"viewId" xorm:"view_id"`
	RootCi      string `json:"rootCi" xorm:"root_ci"`
	ReportId    string `json:"reportId"`
	ConfirmTime string `json:"confirmTime" xorm:"confirm_time"`
	// Permission  string `json:"permission" xorm:"permission" binding:"required"`
	RootCiList      []string `json:"rootCiList"`
	WithoutChildren bool     `json:"withoutChildren"`
}

type GraphViewData struct {
	ViewId      string `json:"viewId" binding:"required"`
	RootCi      string `json:"rootCi" binding:"required"`
	GraphId     string `json:"graphId" binding:"required"`
	ConfirmTime string `json:"confirmTime"`
}

type UpdateViewParam struct {
	Id            string   `json:"viewId" xorm:"id" binding:"required"`
	Name          string   `json:"name" xorm:"name" binding:"required"`
	Report        string   `json:"report" xorm:"report" binding:"required"`
	Editable      string   `json:"editable" xorm:"editable"`
	SuportVersion string   `json:"suportVersion" xorm:"suport_version"`
	Multiple      string   `json:"multiple" xorm:"multiple"`
	FilterAttr    string   `json:"filterAttr" xorm:"filter_attr"`
	FilterValue   string   `json:"filterValue" xorm:"filter_value"`
	MGMT          []string `json:"MGMT" xorm:"-"`
	USE           []string `json:"USE" xorm:"-"`
}

type SysRoleViewTable struct {
	Id         string `json:"id" xorm:"id"`
	Role       string `json:"role" xorm:"role"`
	View       string `json:"view" xorm:"view"`
	Permission string `json:"permission" xorm:"permission"`
}
