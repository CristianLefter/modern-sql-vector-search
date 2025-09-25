# Modern SQL: Vector Search with Embeddings

A concise, hands-on repo to accompany the presentation **“Modern SQL: Vector Search with Embeddings.”**  
Focus: how to store embeddings in **SQL Server 2025** and run **semantic search** with `VECTOR_DISTANCE(...)`.

> **Why this repo?** A minimal, production-friendly starting point: schema, sample data, embedding script, and example queries.

---

## Contents

```
modern-sql-vector-search/
├─ slides/                     # Slide deck
├─ src/
│  └─ sql/
│     ├─ 01-schema.sql        # Tables + constraints
│     ├─ 02-insert-sample.sql # Sample rows + sample embeddings (small demo)
│     └─ 03-search.sql        # Cosine/Euclidean search examples
├─ data/
│  └─ sample_corpus.csv       # Short text corpus for demo
├─ tools/
│  └─ embed/
│     └─ generate_embeddings.py  # Generates embeddings via OpenAI or Azure OpenAI
├─ scripts/
│  ├─ run_all.ps1             # PowerShell quickstart
│  └─ run_all.sh              # Bash quickstart
├─ .github/workflows/
│  └─ lint.yml                # Basic CI for formatting checks
├─ .gitignore
├─ CONTRIBUTING.md
└─ LICENSE
```

---

## Prerequisites

- **SQL Server 2025** (or newer) with the vector data type and `VECTOR_DISTANCE(...)` available.
- **Python 3.9+** if you want to generate embeddings locally.
- An embedding provider (choose one):
  - **OpenAI** (e.g., `text-embedding-3-large` or `text-embedding-3-small`)
  - **Azure OpenAI** (deployment of an embedding-capable model)

> **Note:** Embeddings are generated outside SQL Server (via a model) and then stored in the database.

---

## Quick Start

### 1) Create the database objects
Use **sqlcmd** (Windows/macOS/Linux) or Azure Data Studio/SSMS.

```bash
# Windows (PowerShell)
sqlcmd -S . -d master -Q "CREATE DATABASE VectorDemo"
sqlcmd -S . -d VectorDemo -i src/sql/01-schema.sql
sqlcmd -S . -d VectorDemo -i src/sql/02-insert-sample.sql

# Linux/macOS
/opt/mssql-tools/bin/sqlcmd -S localhost -d VectorDemo -i src/sql/01-schema.sql
/opt/mssql-tools/bin/sqlcmd -S localhost -d VectorDemo -i src/sql/02-insert-sample.sql
```

### 2) (Optional) Generate embeddings for your own text
```bash
python tools/embed/generate_embeddings.py   --input data/sample_corpus.csv   --output data/sample_with_embeddings.csv
```

Environment variables (choose one provider):

**OpenAI**
```bash
export OPENAI_API_KEY="sk-..."
export OPENAI_EMBED_MODEL="text-embedding-3-small"  # or -large
```

**Azure OpenAI**
```bash
export AZURE_OPENAI_ENDPOINT="https://<your-resource>.openai.azure.com/"
export AZURE_OPENAI_API_KEY="<your-key>"
export AZURE_OPENAI_EMBED_DEPLOYMENT="<your-embedding-deployment-name>"
export AZURE_OPENAI_API_VERSION="2024-02-15-preview"
```

### 3) Load your data with embeddings into SQL
You can adapt `src/sql/02-insert-sample.sql` or bulk-insert from CSV after you generate embeddings.

### 4) Query with vector search
```bash
sqlcmd -S . -d VectorDemo -i src/sql/03-search.sql
```

---

## What you’ll find in the SQL scripts

- **`01-schema.sql`** – Creates a `Documents` table with a `VECTOR` column and helpers.
- **`02-insert-sample.sql`** – Inserts a few demo rows with **toy embeddings** (small vectors) to keep it simple.
- **`03-search.sql`** – Demonstrates **cosine distance** and **top-K** retrieval using `ORDER BY VECTOR_DISTANCE(...)`.

---

## FAQ

**Q: Can I use a different embedding model?**  
Yes. Any model that returns a vector (array of floats) will work—just keep vector dimensions consistent.

**Q: Can I store vectors as JSON?**  
This demo stores them in the **native vector type** and also shows exposing them as JSON if you want to inspect them.

**Q: Does this handle huge datasets?**  
This repo is a *teaching* scaffold. For *extreme scale*, you’d consider advanced indexing strategies and more tuning.

---

## Credits

- Author: **Cristian Lefter** (@xmldeveloper) — Datapreneur and Educator
- Slides included with permission for educational use.

---

## License

MIT — see [LICENSE](LICENSE).

## Codespaces / Dev Container

A ready-to-use GitHub Codespaces configuration is included under **.devcontainer**.  
It spins up two services via Docker Compose:

- **db** — `mcr.microsoft.com/mssql/server:2025-latest` (SQL Server 2025 Preview)
- **app** — a minimal devcontainer with recommended VS Code extensions

**How to use**

1. Push this repo to GitHub.
2. Click **Code ▸ Codespaces ▸ Create codespace on main**.
3. After the container builds, use the **SQL Server (mssql)** extension to connect to `db` (preconfigured).  
   The default password is provided via `MSSQL_SA_PASSWORD` (change it or use a Codespaces secret).
4. Run your SQL from `src/sql/00-Using-Embeddings-for-Search.sql`.

> Notes:  
> - Image tag `2025-latest` is used for SQL Server 2025 (17.x) **Preview**.  
> - For stability, consider pinning to a specific RC tag if Microsoft publishes one.
