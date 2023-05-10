.PHONY: build-martor

build: build-martor

build-martor:
	docker buildx build -t esara/martor-demo:datadog --platform "linux/amd64,linux/arm64" --push .

deploy:
	kubectl apply -f k8s.yaml
