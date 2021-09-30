# github-actions-runner-docker
A simple, Dockerized runner for GitHub Actions.

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
    image: ghcr.io/chrisromp/github-actions-runner # FIXME: once published
    environment: # pulled from .env file (not tracked)
      - ORGANIZATION
      - ACCESS_TOKEN
      - RUNNER_LABELS
    volumes:
      - /usr/share/docker-config/swag/config/r3web:/services/r3web
    restart: unless-stopped
    healthcheck:
      test: "ps ax | grep \"/home/docker/actions-runner/bin/Runner.Listener run\" | grep -v grep"
      interval: 1m
      timeout: 10s
      retries: 3
      start_period: 10s
```
