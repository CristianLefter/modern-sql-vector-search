# tools/github_publish.ps1
param(
  [string]$RepoName = "modern-sql-vector-search"
)

$Desc = "Modern SQL: Vector Search with Embeddings — demo schema, data, embedding tools, and queries."
$Topics = @("sql-server","vector-search","embeddings","semantic-search","azure-openai","openai","tsql","pluralsight")

# Requires GitHub CLI: https://cli.github.com/
gh repo create $RepoName --public --description $Desc --source . --remote origin --push

# Add topics
foreach ($t in $Topics) { gh repo edit $RepoName --add-topic $t }

# Release
$zipPath = ".\modern-sql-vector-search.zip"
if (Test-Path $zipPath) {
  gh release create v1.0 -t "v1.0" -n "Initial release for Pluralsight audition" $zipPath
}

$login = gh api user | ConvertFrom-Json
Write-Host "Done. Repo: https://github.com/$($login.login)/$RepoName"
