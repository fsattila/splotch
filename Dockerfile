FROM gcc:9.2 as build

COPY . /app
WORKDIR /app

RUN make

FROM ubuntu:20.04

RUN apt update && apt-get install -y libgomp1 && rm -rf /var/lib/apt/lists/*

COPY --from=build /app /app
WORKDIR /app

ENTRYPOINT ["./docker-entrypoint.sh"]
