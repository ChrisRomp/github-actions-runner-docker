# github-actions-runner-docker

A simple, Dockerized runner for GitHub Actions. This project will check for an updated release of the [official runner](https://github.com/actions/runner) hourly and build a new release as needed.

This is a _Proof-of-Concept_ project only. You should fork this and customize it to your needs if you wish to use it in a production environment.

[![Docker Publish](https://github.com/ChrisRomp/github-actions-runner-docker/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/ChrisRomp/github-actions-runner-docker/actions/workflows/docker-publish.yml)

## Configuration

You will need to set the following environment variables for the container:

* `ORGANIZATION`
  * The name of the GitHub organization the runner will bind to, e.g., `https://github.com/{ORGANIZATION}` 
* `ACCESS_TOKEN`
  * A GitHub personal access token with the `admin:org` permission
* `RUNNER_LABELS`
  * A set of labels to apply to the runner to control job affinity (i.e., where your jobs will run)
  
## Docker Compose

A sample docker-compose.yaml. You should include the aforementioned environment variables in a `.env` file in the same directory to avoid saving them in the compose file.

```yaml
version: '2.3'

services:
  runner:
    image: ghcr.io/chrisromp/github-actions-runner
    environment: # pulled from .env file (not tracked)
      - ORGANIZATION
      - ACCESS_TOKEN
      - RUNNER_LABELS
#    volumes: # Mount resources the runner will need access to
#      - /var/www:/services/www
    restart: unless-stopped
    healthcheck:
      test: "ps ax | grep \"/home/docker/actions-runner/bin/Runner.Listener run\" | grep -v grep"
      interval: 1m
      timeout: 10s
      retries: 3
      start_period: 10s
```
