package models

type QueryRequestFilterObj struct {
	Name     string      `json:"name"`
	Operator string      `json:"operator"`
	Value    interface{} `json:"value"`
}

type QueryRequestSorting struct {
	Asc   bool   `json:"asc"`
	Field string `json:"field"`
}

type QueryRequestDialect struct {
	AssociatedData map[string]string `json:"associatedData"`
	QueryMode      string            `json:"queryMode"`
}

type QueryRequestParam struct {
	Filters        []*QueryRequestFilterObj `json:"filters"`
	Dialect        *QueryRequestDialect     `json:"dialect"`
	Paging         bool                     `json:"paging"`
	Pageable       *PageInfo                `json:"pageable"`
	Sorting        *QueryRequestSorting     `json:"sorting"`
	ResultColumns  []string                 `json:"resultColumns"`
	WithRefRowData bool                     `json:"withRefRowData"` // ref选项查询时是否返回整行数据，默认否只返回guid、keyName
}

type TransFiltersParam struct {
	IsStruct   bool
	StructObj  interface{}
	Prefix     string
	KeyMap     map[string]string
	PrimaryKey string
}
