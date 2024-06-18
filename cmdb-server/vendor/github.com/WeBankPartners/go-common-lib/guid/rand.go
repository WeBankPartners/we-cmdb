package guid

import (
	"crypto/rand"
	"fmt"
	"sort"
	"time"
)

func CreateGuid() string {
	b := make([]byte, 16)
	rand.Read(b)
	return fmt.Sprintf("%x%x", time.Now().UnixMicro(), b[4:8])
}

func CreateGuidList(num int) []string {
	var guidList guidSortList
	for i := 0; i < num; i++ {
		guidList = append(guidList, CreateGuid())
	}
	sort.Sort(guidList)
	return guidList
}

type guidSortList []string

func (l guidSortList) Len() int {
	return len(l)
}

func (l guidSortList) Swap(i, j int) {
	l[i], l[j] = l[j], l[i]
}

func (l guidSortList) Less(i, j int) bool {
	return l[i] < l[j]
}
