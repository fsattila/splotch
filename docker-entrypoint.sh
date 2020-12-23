#!/bin/bash

set -e

if [ "$S3" = "true" ] || [ "$S3" = "True" ]; then
	rclone config create s3_server s3 env_auth $S3_ENV_AUTH access_key_id $S3_ACCESS_KEY_ID secret_access_key $S3_SECRET_ACCESS_KEY region $S3_REGION endpoint $S3_ENDPOINT
	rclone copy s3_server:$S3_BUCKET/$S3_JOB .
	chmod +x $S3_JOB
	./$S3_JOB
fi

if [ "${1:0:1}" = '-' ]; then
	set -- ./Splotch6-generic "$@"
fi

exec "$@"