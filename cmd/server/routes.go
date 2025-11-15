package main

import (
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func (b *backend) setupRoutes(e *echo.Echo) {
	prod := e.Group("/v1")
	prod.Use(middleware.Logger())
	prod.Use(middleware.Recover())

	prod.GET("/show", b.healthCheck)
}
