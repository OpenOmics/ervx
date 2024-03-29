## Steps for Building Docker Images

Directly below are instructions for building an image using the provided Dockerfile:

```bash
# See listing of images on computer
docker image ls

# Build from Dockerfile
docker build --no-cache -f Dockerfile --tag=ncbr_telescope:v0.1.0 .

# Testing, take a peek inside
docker run -ti ncbr_telescope:v0.1.0 /bin/bash

# Updating Tag  before pushing to DockerHub
docker tag ncbr_telescope:v0.1.0 org_account/ncbr_telescope:v0.1.0
docker tag ncbr_telescope:v0.1.0 org_account/ncbr_telescope         # latest

# Check out new tag(s)
docker image ls

# Push new tagged image to DockerHub
docker push org_account/ncbr_telescope:v0.1.0
docker push org_account/ncbr_telescope:latest
```

### Other Recommended Steps

Scan your image for known vulnerabilities:

```bash
docker ncbr_telescope:v0.1.0
```

> **Please Note**: Any references to `org_account` should be replaced your username if you would also like to push the image to a non-org account.
