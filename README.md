# codeql-docker

CodeQL Docker image build on Ubuntu latest Docker image

## Building Image

The install script will find and install the latest CodeQL bundle which contains the current version of the CLI and queries.

```bash
docker build -t organization/codeql .
```

## Features

- Autodetect language
- 

## Running

##### Dropping into shell

```bash
docker run -it  -v $PWD:/workspace geekmasher/codeql
```


### Built in commands

**Runs full analysis:**

```bash
# Autodetect language used
codeql-full
```

**Runs stages:**

```bash
# Initialisation of CodeQL
codeql-init --auto-detect
# or manually
codeql-init -l java

# [optional] Build command (tracing is enabled)
mvn clean install -DskipTests=true

# Run analysis
codeql-analyze
```

### Example Using CLI Directly

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
