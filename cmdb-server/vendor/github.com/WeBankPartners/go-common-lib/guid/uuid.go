package guid

import "github.com/google/uuid"

func GenerateUUIDV4() string {
	return uuid.New().String()
}
