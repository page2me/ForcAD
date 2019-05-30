#!/bin/sh

/await_start.sh

cd /app

case $CELERY_CONTAINER_TYPE in
    "worker")
        echo "[*] Starting celery worker"
        celery worker -A celery_tasks \
        -E -l info \
        --pool=gevent \
        --concurrency=500
        ;;
    "beat")
        echo "[*] Starting celery beat"
        celery beat -A celery_tasks \
            --pidfile=/tmp/celerybeat.pid \
            --schedule=/tmp/celerybeat-schedule
        ;;
    "flower")
        echo "[*] Starting celery flower"
        celery flower -A celery_tasks \
            --basic_auth="$FLOWER_BASIC_AUTH" \
            --url-prefix=flower \
            --host=0.0.0.0 \
            --port=5555
esac