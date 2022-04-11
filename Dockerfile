FROM python:3.9.7-alpine

# ARG timestamp
# ARG commit

LABEL maintainer="valentin.colin78@gmail.com"
LABEL image="https://hub.docker.com/r/valentincolin/website"
LABEL source="https://github.com/valentincolin/website"
LABEL link="https://valentin-colin.fr"
# LABEL build.timestamp=timestamp                                        # Récup un <build at ...>
# LABEL build.commit=commit                                              # Récup un <run at ...>

COPY . /app
WORKDIR /app

# No .pyo and easier debugging
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apk add curl
RUN pip install -r requirements.txt

ENV PORT 80
ENV HOST 0.0.0.0
EXPOSE 80

HEALTHCHECK --interval=30s \
            --timeout=10s \
            --start-period=1m \
            --retries=3 \
             CMD curl -sSf http://127.0.0.1:$PORT/live || exit 1

ENTRYPOINT ["/app/entrypoint.sh"]
