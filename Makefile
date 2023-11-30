.PHONY: build
build:
	docker compose build

.PHONY: push
push:
	docker compose push

.PHONY: up
up:
	docker compose up -d

.PHONY: exec
exec:
	@docker compose exec aria2 ash
