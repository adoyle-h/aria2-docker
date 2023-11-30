.PHONY: build
build:
	@docker buildx build --push \
		--platform linux/amd64,linux/arm64,linux/386,linux/arm/v7,linux/arm/v6 \
		--tag adoyle/aria2:$(IMAGE_VERSION) .

.PHONY: push
push:
	docker compose push

.PHONY: up
up:
	docker compose up -d

.PHONY: exec
exec:
	@docker compose exec aria2 ash
