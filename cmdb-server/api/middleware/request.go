package middleware

import "github.com/gin-gonic/gin"

func GetRemoteIp(c *gin.Context) string {
	return c.ClientIP()
}
