package models

type SysGraphTable struct {
	Id         string `json:"graphId" xorm:"id"`
	Name       string `json:"name" xorm:"name"`
	View       string `json:"view" xorm:"view"`
	GraphType  string `json:"graphType" xorm:"graph_type"`
	NodeGroups string `json:"nodeGroups" xorm:"node_groups"`
	GraphDir   string `json:"graphDir" xorm:"graph_dir"`
}

type GraphQuery struct {
	Name          string            `json:"name" xorm:"name"`
	ViewGraphType string            `json:"viewGraphType" xorm:"view_graph_type"`
	NodeGroups    string            `json:"nodeGroups" xorm:"node_groups"`
	GraphDir      string            `json:"graphDir" xorm:"graph_dir"`
	RootData      *GraphElementNode `json:"rootData" xorm:"root_data"`
}

type SysGraphElementTable struct {
	Id                  string `json:"graphElementId" xorm:"id"`
	Graph               string `json:"graph" xorm:"graph"`
	ParentElement       string `json:"parentElement" xorm:"parent_element"`
	ReportObject        string `json:"reportObject" xorm:"report_object"`
	ShowTable           string `json:"showTable" xorm:"show_table"`
	DisplayExpression   string `json:"displayExpression" xorm:"display_expression"`
	NodeGroupName       string `json:"nodeGroupName" xorm:"node_group_name"`
	LineStartData       string `json:"lineStartData" xorm:"line_start_data"`
	LineEndData         string `json:"lineEndData" xorm:"line_end_data"`
	LineDisplayPosition string `json:"lineDisplayPosition" xorm:"line_display_position"`
	GraphType           string `json:"graphType" xorm:"graph_type"`
	GraphShapeData      string `json:"graphShapeData" xorm:"graph_shape_data"`
	GraphShapes         string `json:"graphShapes" xorm:"graph_shapes"`
	GraphConfigData     string `json:"graphConfigData" xorm:"graph_config_data"`
	GraphConfigs        string `json:"graphConfigs" xorm:"graph_configs"`
	EditRefAttr         string `json:"editRefAttr" xorm:"edit_ref_attr"`
	GraphFilterData     string `json:"graphFilterData" xorm:"graph_filter_data"`
	GraphFilterValues   string `json:"graphFilterValues" xorm:"graph_filter_values"`
	Editable            string `json:"editable" xorm:"editable"`
	SeqNo               string `json:"seqNo" xorm:"seq_no"`
	OrderData           string `json:"orderData" xorm:"order_data"`
	UpdateOperation     string `json:"updateOperation" xorm:"update_operation"`
}

type GraphElementNode struct {
	// GraphElement *SysGraphElementTable `json:"graphElement" xorm:"graph_element"`
	Id                  string              `json:"graphElementId" xorm:"id"`
	CiType              string              `json:"ciType" xorm:"ci_type"`
	DataName            string              `json:"dataName" xorm:"data_name"`
	Graph               string              `json:"graph" xorm:"graph"`
	ParentElement       string              `json:"parentElement" xorm:"parent_element"`
	ReportObject        string              `json:"reportObject" xorm:"report_object"`
	ShowTable           string              `json:"showTable" xorm:"show_table"`
	DisplayExpression   string              `json:"displayExpression" xorm:"display_expression"`
	NodeGroupName       string              `json:"nodeGroupName" xorm:"node_group_name"`
	LineStartData       string              `json:"lineStartData" xorm:"line_start_data"`
	LineEndData         string              `json:"lineEndData" xorm:"line_end_data"`
	LineDisplayPosition string              `json:"lineDisplayPosition" xorm:"line_display_position"`
	GraphType           string              `json:"graphType" xorm:"graph_type"`
	GraphShapeData      string              `json:"graphShapeData" xorm:"graph_shape_data"`
	GraphShapes         string              `json:"graphShapes" xorm:"graph_shapes"`
	GraphConfigData     string              `json:"graphConfigData" xorm:"graph_config_data"`
	GraphConfigs        string              `json:"graphConfigs" xorm:"graph_configs"`
	EditRefAttr         string              `json:"-" xorm:"edit_ref_attr"`
	EditRefAttrName     string              `json:"editRefAttr" xorm:"edit_ref_attr_name"`
	GraphFilterData     string              `json:"graphFilterData" xorm:"graph_filter_data"`
	GraphFilterValues   string              `json:"graphFilterValues" xorm:"graph_filter_values"`
	Editable            string              `json:"editable" xorm:"editable"`
	OrderData           string              `json:"orderData" xorm:"order_data"`
	UpdateOperation     string              `json:"updateOperation" xorm:"update_operation"`
	Children            []*GraphElementNode `json:"children" xorm:"children"`
}
