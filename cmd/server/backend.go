package main

import (
	"context"
	"errors"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"sync"
	"syscall"
	"time"

	"github.com/rs/zerolog"
)

type config struct {
	env  string
	port int
	db   struct {
		dsn          string
		maxOpenConns int
		maxIdleTime  time.Duration
		maxIdleConns int
	}
}

type backend struct {
	logger zerolog.Logger
	config
	wg sync.WaitGroup
}

// serve starts an HTTP server with configured values and handles graceful
// shutdowns if prompted. Any error occurred during this process is
// returned to the caller.
func (b *backend) serve() error {
	srv := &http.Server{
		Addr:              fmt.Sprintf(":%d", b.port),
		ReadTimeout:       10 * time.Second,
		IdleTimeout:       30 * time.Second,
		ReadHeaderTimeout: 30 * time.Second,
	}
	shutdownError := make(chan error, 1)
	go func() {
		quit := make(chan os.Signal, 1)
		signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
		sig := <-quit
		b.logger.Info().
			Str("signal", sig.String()).
			Msgf("shutting down server")

		ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
		defer cancel()

		err := srv.Shutdown(ctx)
		if err != nil {
			shutdownError <- err
		}
		b.logger.Info().Str("addr", srv.Addr).
			Msgf("completing background tasks")

		b.wg.Wait()
		shutdownError <- nil
	}()
	b.logger.Info().Str("addr", srv.Addr).
		Str("env", b.env).Msgf("server started")

	err := srv.ListenAndServe()
	if !errors.Is(err, http.ErrServerClosed) {
		return fmt.Errorf("failed to listen on addr=%s: %w", srv.Addr, err)
	}
	err = <-shutdownError
	if err != nil {
		return err
	}
	b.logger.Info().Str("addr", srv.Addr).
		Str("env", b.env).Msgf("server stopped")

	return nil
}
