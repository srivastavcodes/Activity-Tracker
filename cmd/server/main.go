package main

import (
	"log"

	"github.com/joho/godotenv"
	"github.com/rs/zerolog"
)

// todo := add db connections tomorrow and model operations if possible

func init() {
	err := godotenv.Load(".envrc")
	if err != nil {
		log.Fatal("Error loading .envrc file")
	}
}

func main() {
	zlog := zerolog.New(zerolog.NewConsoleWriter()).With().Timestamp().Logger()
	cfg := config{
		env:  "dev",
		port: 4000,
	}
	bkd := &backend{
		logger: zlog,
		config: cfg,
	}
	err := bkd.serve()
	if err != nil {
		zlog.Err(err).Str("env", bkd.env).
			Any("port", bkd.port).
			Msg("error starting server")
	}
}
