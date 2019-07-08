SERVICE_NAME=hello-k8s
BIN_LOCATION=build/bin/live-scores-betway
IMAGE_NAME=docker.io/goforbroke1006/hello-k8s
IMAGE_TAG=1.0.0
K8S_TMP_FILE=./build/hello-k8s.k8s.tmp.yaml

build:
	go build -o ${BIN_LOCATION} cmd/${SERVICE_NAME}/main.go

docker-build: build
	docker build --file=deployment/docker/Dockerfile --cache-from=${IMAGE_NAME}:${IMAGE_TAG} \
	    --build-arg SERVICE_NAME=${SERVICE_NAME} \
	    --build-arg BINARY_FILE_LOCATION=${BIN_LOCATION} \
	    -t ${IMAGE_NAME}:${IMAGE_TAG} .

docker-publish: docker-build
	docker login
	docker push ${IMAGE_NAME}:${IMAGE_TAG}

minikube: docker-publish
	rm -f ${K8S_TMP_FILE}
	for t in $(shell find ./deployment/k8s/ -type f -name "*.yaml"); do \
		cat $$t | \
			sed -E "s/\{\{(\s*)\.Release(\s*)\}\}/$(IMAGE_TAG)/g" | \
			sed -E "s/\{\{(\s*)\.ServiceName(\s*)\}\}/$(SERVICE_NAME)/g"; \
		echo | echo "\n"; \
	done > ${K8S_TMP_FILE}
	kubectl replace -f ${K8S_TMP_FILE} --force || kubectl apply -f ${K8S_TMP_FILE}
