package middleware

import "github.com/gin-gonic/gin"

func GetRemoteIp(c *gin.Context) string {
	netIp, ok := c.RemoteIP()
	if ok {
		return netIp.String()
	}
	return c.ClientIP()
}
