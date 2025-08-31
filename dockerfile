# Base image
FROM alpine:3.18

# Author label
LABEL maintainer="prosenjit@example.com"

# Run a test command
CMD ["echo", "Hello from Docker image pushed via GitHub Actions!"]
