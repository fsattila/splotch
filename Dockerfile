FROM gcc:9.2 as build

COPY . /app
WORKDIR /app

RUN make

FROM ubuntu:20.04

#Install splotch, magick
ENV TZ=Europe/Budapest
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y libgomp1 libfontconfig libx11-dev libharfbuzz-dev libfribidi-dev \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /app /app
COPY magick /app
WORKDIR /app

ENV PATH="/app/:${PATH}"

#Install rclone
RUN apt-get update && apt-get install -y unzip curl \
    && curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip \
    && unzip rclone-current-linux-amd64.zip \
    && cp rclone-*-linux-amd64/rclone /usr/bin/ \
    && chown root:root /usr/bin/rclone \
    && chmod 755 /usr/bin/rclone \
    && rm -r rclone-* \
    && apt-get -y purge unzip curl \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["./docker-entrypoint.sh"]