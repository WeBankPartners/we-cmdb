package models

import "regexp"

var (
	normalReg = regexp.MustCompile("^[a-z0-9_]+$")
)

func ValidateNormalString(input string) bool {
	return normalReg.MatchString(input)
}
