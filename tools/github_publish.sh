#!/usr/bin/env bash
# tools/github_publish.sh
# Create a GitHub repo, push current contents, add topics, and create a release with the ZIP.

set -euo pipefail

REPO_NAME="${1:-modern-sql-vector-search}"
DESC="Modern SQL: Vector Search with Embeddings — demo schema, data, embedding tools, and queries."
TOPICS="sql-server,vector-search,embeddings,semantic-search,azure-openai,openai,tsql,pluralsight"

# Requires GitHub CLI: https://cli.github.com/
gh repo create "$REPO_NAME" --public --description "$DESC" --source . --remote origin --push

# Add topics
gh repo edit "$REPO_NAME" --add-topic $(echo $TOPICS | tr , ' ')

# Create a release and upload the ZIP artifact (if present)
ZIP_PATH="./modern-sql-vector-search.zip"
if [ -f "$ZIP_PATH" ]; then
  gh release create v1.0 -t "v1.0" -n "Initial release for Pluralsight audition" "$ZIP_PATH"
fi

echo "Done. Repo: https://github.com/$(gh api user | jq -r .login)/$REPO_NAME"
