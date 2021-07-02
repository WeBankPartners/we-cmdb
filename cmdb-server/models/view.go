package models

import "time"

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
	ViewId      string `json:"viewId" xorm:"view_id" binding:"required"`
	RootCi      string `json:"rootCi" xorm:"root_ci" binding:"required"`
	ConfirmTime string `json:"confirmTime" xorm:"confirm_time"`
	// Permission  string `json:"permission" xorm:"permission" binding:"required"`
}
