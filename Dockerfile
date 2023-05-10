FROM python:alpine

WORKDIR /app

RUN set -xe;

COPY . .

RUN apk add --no-cache tini mysql mysql-client gcc musl-dev mariadb-connector-c-dev; \
    pip install --upgrade pip setuptools-scm django==4.1 mysqlclient ddtrace; \
    python3 setup.py install; \
    python3 martor_demo/manage.py makemigrations; \
    python3 martor_demo/manage.py migrate; \
    addgroup -g 1000 appuser; \
    adduser -u 1000 -G appuser -D -h /app appuser; \
    chown -R appuser:appuser /app

USER appuser
EXPOSE 8000/tcp
ENTRYPOINT [ "tini", "--" ]
CMD [ "python3", "/app/martor_demo/manage.py", "runserver", "0.0.0.0:8000" ]