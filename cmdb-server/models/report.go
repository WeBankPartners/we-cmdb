package models

type SysReportTable struct {
	Id         string `json:"id" xorm:"id"`
	Name       string `json:"name" xorm:"name"`
	CiType     string `json:"ciType" xorm:"ci_type"`
	CreateTime string `json:"createTime" xorm:"create_time"`
	CreateUser string `json:"createUser" xorm:"create_user"`
	UpdateTime string `json:"updateTime" xorm:"update_time"`
	UpdateUser string `json:"updateUser" xorm:"update_user"`
	SqlCache   string `json:"-" xorm:"sql_cache"`
}

type SysReportObjectTable struct {
	Id            string `json:"reportObjectId" xorm:"id"`
	Report        string `json:"report" xorm:"report"`
	ParentObject  string `json:"parentObject" xorm:"parent_object"`
	ParentAttr    string `json:"parentAttr" xorm:"parent_attr"`
	CiType        string `json:"ciType" xorm:"ci_type"`
	MyAttr        string `json:"myAttr" xorm:"my_attr"`
	DataName      string `json:"dataName" xorm:"data_name"`
	DataTitleName string `json:"dataTitleName" xorm:"data_title_name"`
	SeqNo         int    `json:"seqNo" xorm:"seq_no"`
}

type SysRoleReportTable struct {
	Id         string `json:"id" xorm:"id"`
	Role       string `json:"role" xorm:"role"`
	Report     string `json:"report" xorm:"report"`
	Permission string `json:"permission" xorm:"permission"`
}

type SysReportObjectAttrTable struct {
	Id            string `json:"reportObjectAttrId" xorm:"id"`
	ReportObject  string `json:"reportObject" xorm:"report_object"`
	CiTypeAttr    string `json:"ciTypeAttr" xorm:"ci_type_attr"`
	DataName      string `json:"dataName" xorm:"data_name"`
	DataTitleName string `json:"dataTitleName" xorm:"data_title_name"`
	Querialbe     string `json:"querialbe" xorm:"querialbe"`
}

type SysReportObjectFilterTable struct {
	Id                string `json:"reportObjectFilterId" xorm:"id"`
	FilterName        string `json:"filterName" xorm:"filter_name"`
	FilterCiType      string `json:"filterCiType" xorm:"filter_ci_type"`
	FilterRule        string `json:"filterRule" xorm:"filter_rule"`
	SysReportObject   string `json:"sysReportObject" xorm:"sys_report_object"`
	Multiple          string `json:"multiple" xorm:"multiple"`
	FilterDisplayName string `json:"filterDisplayName" xorm:"filter_display_name"`
}

type ReportObjectNode struct {
	Id                string `json:"reportObjectId" xorm:"id"`
	Report            string `json:"report" xorm:"report"`
	ParentObject      string `json:"parentObject" xorm:"parent_object"`
	ParentAttr        string `json:"parentAttr" xorm:"parent_attr"`
	CiType            string `json:"ciType" xorm:"ci_type"`
	MyAttr            string `json:"myAttr" xorm:"my_attr"`
	DataName          string `json:"dataName" xorm:"data_name"`
	DataDisplayName   string `json:"dataDisplayName" xorm:"data_display_name"`
	Status            string `json:"status" xorm:"status"`
	ReportObjAttrName string `json:"reportObjAttrName" xorm:"report_obj_attr_name"`
	// Children          []*ReportObjectNode `json:"children" xorm:"children"`
}

type QueryReport struct {
	Id         string               `json:"id" xorm:"id"`
	Name       string               `json:"name" xorm:"name"`
	CiType     string               `json:"ciType" xorm:"ci_type"`
	CreateTime string               `json:"createTime" xorm:"create_time"`
	CreateUser string               `json:"createUser" xorm:"create_user"`
	UpdateTime string               `json:"updateTime" xorm:"update_time"`
	UpdateUser string               `json:"updateUser" xorm:"update_user"`
	SqlCache   string               `json:"-" xorm:"sql_cache"`
	Object     []*QueryReportObject `json:"object" xorm:"object"`
}

type QueryReportObject struct {
	Id            string                   `json:"id" xorm:"id"`
	Report        string                   `json:"report" xorm:"report"`
	ParentObject  string                   `json:"parentObject" xorm:"parent_object"`
	ParentAttr    string                   `json:"parentAttr" xorm:"parent_attr"`
	CiType        string                   `json:"ciType" xorm:"ci_type"`
	MyAttr        string                   `json:"myAttr" xorm:"my_attr"`
	DataName      string                   `json:"dataName" xorm:"data_name"`
	DataTitleName string                   `json:"dataTitleName" xorm:"data_title_name"`
	Object        []*QueryReportObject     `json:"object" xorm:"object"`
	Attr          []*QueryReportObjectAttr `json:"attr" xorm:"attr"`
}

type QueryReportObjectAttr struct {
	Id            string `json:"id" xorm:"id"`
	ReportObject  string `json:"reportObject" xorm:"report_object"`
	CiTypeAttr    string `json:"ciTypeAttr" xorm:"ci_type_attr"`
	DataName      string `json:"dataName" xorm:"data_name"`
	DataTitleName string `json:"dataTitleName" xorm:"data_title_name"`
	Querialbe     string `json:"querialbe" xorm:"querialbe"`
}

type ModifyReport struct {
	Id            string   `json:"id" xorm:"id"`
	Name          string   `json:"name" xorm:"name"`
	CiType        string   `json:"ciType" xorm:"ci_type"`
	CreateUser    string   `json:"createUser" xorm:"create_user"`
	UpdateUser    string   `json:"updateUser" xorm:"update_user"`
	UseRole       string   `json:"useRole" xorm:"use_role"`
	UseRoleList   []string `json:"useRoleList"`
	MgmtRole      string   `json:"mgmtRole" xorm:"mgmt_role"`
	MgmtRoleList  []string `json:"mgmtRoleList"`
	DataName      string   `json:"dataName" xorm:"data_name"`
	DataTitleName string   `json:"dataTitleName" xorm:"data_title_name"`
}

type ModifyReportObject struct {
	Id            string                    `json:"id" xorm:"id"`
	DataName      string                    `json:"dataName" xorm:"data_name"`
	DataTitleName string                    `json:"dataTitleName" xorm:"data_title_name"`
	Report        string                    `json:"report" xorm:"report"`
	ParentAttr    string                    `json:"parentAttr" xorm:"parent_attr"`
	CiType        string                    `json:"ciType" xorm:"ci_type"`
	MyAttr        string                    `json:"myAttr" xorm:"my_attr"`
	Object        []*ModifyReportObject     `json:"object" xorm:"object"`
	Attr          []*ModifyReportObjectAttr `json:"attr" xorm:"attr"`
}

type ModifyReportObjectAttr struct {
	Id            string `json:"id" xorm:"id"`
	CiTypeAttr    string `json:"ciTypeAttr" xorm:"ci_type_attr"`
	DataName      string `json:"dataName" xorm:"data_name"`
	DataTitleName string `json:"dataTitleName" xorm:"data_title_name"`
	Querialbe     string `json:"querialbe" xorm:"querialbe"`
}

type ExportReportParam struct {
	ReportId   string   `json:"reportId" binding:"required"`
	RootCiData []string `json:"rootCiData"`
}

type ExportReportResult struct {
	ReportId   string                `json:"reportId"`
	ExportTime string                `json:"exportTime"`
	RootCiType string                `json:"rootCiType"`
	CiData     []*ExportReportCiData `json:"ciData"`
}

type ExportReportCiData struct {
	CiType             string                   `json:"ciType"`
	ParentCiType       string                   `json:"parentCiType"`
	ParentAttribute    string                   `json:"parentAttribute"`
	RefParentAttribute string                   `json:"refParentAttribute"`
	Attributes         []string                 `json:"attributes"`
	Data               []map[string]interface{} `json:"data"`
}
