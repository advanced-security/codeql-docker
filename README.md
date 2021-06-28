# codeql-docker

CodeQL Docker image build on Ubuntu latest Docker image

## Building Image

The install script will find and install the latest CodeQL bundle which contains the current version of the CLI and queries.

```bash
docker build -t organization/codeql .
```

## Running

##### Dropping into shell

```bash
docker run -it  -v $PWD:/workspace geekmasher/codeql
```

### Example Analysis

```bash
# Create database
codeql database create database_name --language=javascript

# Run analysis
codeql database analyze database_name \
    --format "sarif-latest" \
    --output "codeql-results.json" \
    javascript-code-scanning.qls

# Upload results to GitHub
codeql github upload-results --repository=<repository-name> \
      --ref=$GIT_REF \
      --commit=$GIT_HASH \
      --sarif="codeql-results.json"

```

### Aliases

In the `~/.bashrc` there is a number of values and functions that hopefully will make it a lot easier to use CodeQL CLI.
This isn't required and can be removed in the `Dockerfile`.
