package models

type SysBaseKeyCatTable struct {
	Id          string `json:"catId" xorm:"id" binding:"required"`
	Name        string `json:"catName" xorm:"name"`
	Description string `json:"description" xorm:"description"`
}

type SysBaseKeyCodeTable struct {
	Id          string              `json:"codeId" xorm:"id"`
	CatId       string              `json:"catId" xorm:"cat_id"`
	Code        string              `json:"code" xorm:"code"`
	Value       string              `json:"value" xorm:"value"`
	Description string              `json:"codeDescription" xorm:"description"`
	SeqNo       int                 `json:"seqNo" xorm:"seq_no"`
	Status      string              `json:"status" xorm:"status"`
	Cat         *SysBaseKeyCatTable `json:"cat" xorm:"-"`
}

type BaseKeyCodeCreateObj struct {
	CodeId      string `json:"codeId"`
	CatId       string `json:"catId"`
	Code        string `json:"code"`
	Value       string `json:"value"`
	Status      string `json:"status"`
	Description string `json:"codeDescription"`
}

type BaseKeyCodeSwapPositionParam struct {
	CodeId      string `json:"codeId" binding:"required"`
	TargetIndex int    `json:"targetIndex"`
	Up          bool   `json:"up"`
}
