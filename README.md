## Syslog-ng in Alpine Docker

[![CircleCI](https://circleci.com/gh/agowa338-docker/syslog-ng-alpine.svg?style=shield)](https://circleci.com/gh/agowa338-docker/syslog-ng-alpine)

[![](
https://images.microbadger.com/badges/commit/agowa338/syslog-ng-alpine.svg)](
https://github.com/agowa338-docker/syslog-ng-alpine) [![](
https://images.microbadger.com/badges/image/agowa338/syslog-ng-alpine.svg)](
https://microbadger.com/images/agowa338/syslog-ng-alpine
"Get your own image badge on microbadger.com")

### Basic Info
Minimal syslog-ng container that writes logs to `syslog-ng-logs:/$HOST/$PROGRAM.log`.

Modified from [mumblepins-docker/syslog-ng-alpine](https://github.com/mumblepins-docker/syslog-ng-alpine)

Uses Tini for monitoring

Exposed inputs:

* 514/udp
* 601/tcp 
* 6514/TLS
* unix socket `/var/run/syslog-ng/syslog-ng.sock`

Exposed Volumes:
* `/var/log/syslog-ng` (Actual logging location)
* `/var/run/syslog-ng` (Unix Socket)
* `/etc/syslog-ng` (Config File)

#### Usage

Listen on udp port 514 and save logs to volume:

```bash
docker run -d -p 514:514/udp \
  -p 601:601 \
  -p 6514:6514 \
  --name syslog-ng agowa338/syslog-ng-alpine
```

#### Docker-compose example
```yml
version: '3'
services:
  syslog-ng:
    container_name: syslog-ng
    build: .
    ports:
      - "514:514/udp"
      - "601:601"
      - "6514:6514"
    volumes:
      - syslog-ng-logs:/var/log/syslog-ng
      - syslog-ng-socket:/var/run/syslog-ng
      - syslog-ng-config:/etc/syslog-ng

volumes:
  syslog-ng-logs:
  syslog-ng-socket:
    driver_opts:
      type: none
      device: /var/run/syslog-ng
      o: bind
  syslog-ng-config:
```
