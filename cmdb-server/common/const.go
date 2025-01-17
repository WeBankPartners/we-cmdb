package models

const (
	DateTimeFormat       = "2006-01-02 15:04:05"
	SysTableIdConnector  = "__"
	UrlPrefix            = "/wecmdb"
	MultiRefType         = "multiRef"
	AutofillRuleType     = "autofillRule"
	ObjectInputType      = "object"
	TimeTriggerInputType = "timeTrigger"
	CountInputType       = "count"
	SumInputType         = "sum"
	AvgInputType         = "avg"
	PasswordInputType    = "password"
	ExtRefInputType      = "extRef"
	FloatInputType       = "float"
	AutofillSuggest      = "suggest#"
	SystemUser           = "system"
	AdminUser            = "SUPER_ADMIN"
	AdminRole            = "SUPER_ADMIN"
	SystemRole           = "SUB_SYSTEM"
	PlatformUser         = "SYS_PLATFORM"
	PasswordDisplay      = "****"
	RollbackAction       = "rollback"
	FilterTypeExpression = "expression"
	FilterTypeSelectList = "selectList"

	HeaderAuthorization = "Authorization"

	MultiText      = "multiText"
	MultiInt       = "multiInt"
	Int            = "int"
	MultiObject    = "multiObject"
	MultiSelect    = "multiSelect"
	ContextApiCode = "apiCode"
)

var (
	SEPERATOR = string([]byte{0x01})
)
