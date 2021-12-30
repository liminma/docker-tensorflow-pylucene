image_tag = tensorflow-pylucene

build:
	docker build -t $(image_tag) ./src

run:
	docker run --rm --name tf-pylucene -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes $(image_tag)
