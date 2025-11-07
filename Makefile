# Include variables from .envrc file
include .envrc

.PHONY: run
run:
	@go run ./cmd/server

.PHONY: db/mig/new
db/mig/new:
	@echo "Creating new migration files for ${name}"
	migrate create -seq -ext=.sql -dir=./migrations ${name}

.PHONY: db/mig/up
db/mig/up:
	@echo "Running 'up' migrations..."
	migrate -path ./migrations -database ${ACTIVITY_TRACKER_DSN} up

.PHONY: db/mig/down
db/mig/down:
	@echo "Running 'down' migrations..."
	migrate -path ./migrations -database ${ACTIVITY_TRACKER_DSN} down

.PHONY: db/mig
db/mig:
	@echo "Running command ${command}"
	migrate -path ./migrations -database ${ACTIVITY_TRACKER_DSN} ${command}
