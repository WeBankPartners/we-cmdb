package models

type SysReportImportHistoryTable struct {
	Guid         string `json:"guid" xorm:"guid"`
	Report       string `json:"report" xorm:"report"`
	RootCiType   string `json:"rootCiType" xorm:"root_ci_type"`
	KeyNames     string `json:"keyNames" xorm:"key_names"`
	TotalCount   int    `json:"totalCount" xorm:"total_count"`
	Status       string `json:"status" xorm:"status"`
	ConfirmTime  string `json:"confirmTime" xorm:"confirm_time"`
	CreateUser   string `json:"createUser" xorm:"create_user"`
	CreateTime   string `json:"createTime" xorm:"create_time"`
	UpdateUser   string `json:"updateUser" xorm:"update_user"`
	UpdateTime   string `json:"updateTime" xorm:"update_time"`
	NotPassCount int    `json:"notPassCount" xorm:"not_pass_count"`
}

type SysCiImportGuidMapTable struct {
	Id               int    `json:"id"`
	Source           string `json:"source"`
	Target           string `json:"target"`
	UpdateTime       string `json:"updateTime"`
	ReportImportGuid string `json:"reportImportGuid"`
	CiType           string `json:"ciType"`
	IsUnique         bool   `json:"isUnique"`
	IsNotEmpty       bool   `json:"isNotEmpty"`
}

type ReportHistoryCiDataStatistics struct {
	CiType            string `json:"ciType" xorm:"ci_type"`
	CiTypeDisplayName string `json:"ciTypeDisplayName" xorm:"ci_type_display_name"`
	TotalCount        int    `json:"totalCount" xorm:"total_count"`
	NotPassCount      int    `json:"notPassCount" xorm:"not_pass_count"`
	IsRootCiType      bool   `json:"isRootCiType"`
	SeqNo             int
}

type SysReportImportHistoryResult struct {
	ReportHistoryObject           *SysReportImportHistoryObj       `json:"reportHistoryObject"`
	ReportHistoryCiDataStatistics []*ReportHistoryCiDataStatistics `json:"reportHistoryCiDataStatistics"`
}

type SysReportImportHistoryObj struct {
	Guid           string `json:"guid" xorm:"guid"`
	Report         string `json:"report" xorm:"report"`
	ReportName     string `json:"reportName" xorm:"report_name"`
	RootCiType     string `json:"rootCiType" xorm:"root_ci_type"`
	RootCiTypeName string `json:"rootCiTypeName" xorm:"root_ci_type_name"`
	CiTypeNames    string `json:"ciTypeNames" xorm:"ci_type_names"`
	KeyNames       string `json:"keyNames" xorm:"key_names"`
	TotalCount     int    `json:"totalCount" xorm:"total_count"`
	Status         string `json:"status" xorm:"status"`
	ConfirmTime    string `json:"confirmTime" xorm:"confirm_time"`
	CreateUser     string `json:"createUser" xorm:"create_user"`
	CreateTime     string `json:"createTime" xorm:"create_time"`
	UpdateUser     string `json:"updateUser" xorm:"update_user"`
	UpdateTime     string `json:"updateTime" xorm:"update_time"`
	NotPassCount   int    `json:"notPassCount" xorm:"not_pass_count"`
}
