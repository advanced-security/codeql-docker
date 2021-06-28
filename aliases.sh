#!/bin/bash

export CODEQL_DATABASES="/codeql/databases"
export CODEQL_RESULTS="/codeql/results"
export GIT_HASH=$(git rev-parse HEAD)


# Based on https://gist.github.com/GeekMasher/de827764860a7377d1b75d73a0d10d93
function codeql-full {
    # Just a placeholder for the name of the database + results file(s)
    PROJECT_NAME="$GITHUB_REPOSITORY"
    # Using the CLI, there isn't language detection like the Runner
    CODEQL_LANGUAGE="$1"
    # CodeQL Database name for this analysis
    CODEQL_DATABASE="$CODEQL_DATABASES/$PROJECT_NAME-$CODEQL_LANGUAGE"

    SARIF_PATH="$CODEQL_RESULTS/$PROJECT_NAME-$CODEQL_LANGUAGE.sarif"

    # Setting which query suites are run automatically
    #   https://codeql.github.com/docs/codeql-cli/using-custom-queries-with-the-codeql-cli/
    #   https://codeql.github.com/docs/codeql-cli/creating-codeql-query-suites/
    CODEQL_SUITE="$CODEQL_LANGUAGE-code-scanning.qls"

    echo "[+] CodeQL Database Location  :: $CODEQL_DATABASE"
    echo "[+] CodeQL Results Location   :: $CODEQL_RESULTS"

    if [[ "$CODEQL_LANGUAGE" =~ ^(cpp|csharp|java|javascript|go|python)$ ]]; then
        echo "[+] CodeQL Language           :: $CODEQL_LANGUAGE"
    else
        echo "!!! No language that matches supported languages"
        exit 1
    fi

    # Make sure all the dirs are created
    mkdir -p $CODEQL_DATABASES
    mkdir -p $CODEQL_RESULTS

    # Creating CodeQL Database
    #   https://codeql.github.com/docs/codeql-cli/creating-codeql-databases/
    codeql database create \
        --language="$CODEQL_LANGUAGE" \
        $CODEQL_DATABASE


    # Upgrade the CodeQL Database (if needed)
    #   https://codeql.github.com/docs/codeql-cli/upgrading-codeql-databases/
    codeql database upgrade $CODEQL_DATABASE


    # CodeQL runs the analysis on the Database
    #   https://codeql.github.com/docs/codeql-cli/analyzing-databases-with-the-codeql-cli/
    codeql database analyze \
        --format="sarif-latest" \
        --output="$SARIF_PATH" \
        $CODEQL_DATABASE \
        $CODEQL_SUITE


    # Upload SARIF
    #   https://github.blog/changelog/2021-03-12-codeql-code-scanning-improvements-for-users-analyzing-codebases-on-3rd-party-ci-cd-systems/
    # - Uses $GITHUB_TOKEN by default for access token
    codeql github upload-results \
        -r "$GITHUB_REPOSITORY" \
        -f "$GIT_REF" \
        -c "$GIT_HASH" \
        -s "$SARIF_PATH"

    echo "[+] CodeQL Finished"
    
}
