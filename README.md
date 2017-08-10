# syslog-ng in Alpine Docker

Minimal syslog-ng container that writes logs to `/var/log/syslog-ng/$HOST/$PROGRAM.log`.

Modified from [karantin2020/docker-syslog-ng](https://github.com/karantin2020/docker-syslog-ng), and the [balabit docker image's](https://github.com/balabit/syslog-ng-docker) config file (which isn't included in that build...)

Includes a default config file if none specified, or alternatively use your own by binding `/etc/syslog-ng`.

Includes S6 for monitoring.

Exposed inputs:

* 514/udp
* 601/tcp 
* 6514/TLS
* unix socket `/var/run/syslog-ng/syslog-ng.sock`

Exposed Volumes:
* `/var/log/syslog-ng` (Actual logging location)
* `/var/run/syslog-ng` (Unix Socket)
* `/etc/syslog-ng` (Config File)

## Usage

Listen for udp port 514 on `localhost` and save logs to `/var/log/syslog-ng`:

```
docker run -d -p 127.0.0.1:514:514/udp \
    -v /var/log/syslog-ng:/var/log/syslog-ng \
    --name syslog-ng mumblepins/syslog-ng-alpine
```

#### Docker-compose example
```YAML
version: '3'
services:
  syslog-ng:
    container_name: syslog-ng
    build: .
    ports:
      - "514:514"
      - "601:601"
      - "6514:6514"
    volumes:
      - "./syslog-ng/logs:/var/log/syslog-ng"
      - "./syslog-ng/socket:/var/run/syslog-ng"
      - "./syslog-ng/config/:/etc/syslog-ng"
```