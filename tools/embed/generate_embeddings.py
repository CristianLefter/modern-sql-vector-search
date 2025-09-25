#!/usr/bin/env python3
"""
Generate embeddings for a CSV file with columns: title, text.

Usage:
  python tools/embed/generate_embeddings.py \
    --input data/sample_corpus.csv \
    --output data/sample_with_embeddings.csv

Choose one provider by setting env vars (see README).
- OpenAI: OPENAI_API_KEY, OPENAI_EMBED_MODEL
- Azure OpenAI: AZURE_OPENAI_ENDPOINT, AZURE_OPENAI_API_KEY, AZURE_OPENAI_EMBED_DEPLOYMENT, AZURE_OPENAI_API_VERSION
"""
import os, csv, json, argparse, sys

def use_openai():
    return bool(os.getenv("OPENAI_API_KEY"))

def use_azure_openai():
    return bool(os.getenv("AZURE_OPENAI_ENDPOINT") and os.getenv("AZURE_OPENAI_API_KEY") and os.getenv("AZURE_OPENAI_EMBED_DEPLOYMENT"))

def embed_openai(texts):
    """Return list of vectors using OpenAI embeddings API."""
    try:
        from openai import OpenAI
    except Exception:
        print("Please `pip install openai`.", file=sys.stderr)
        sys.exit(1)

    model = os.getenv("OPENAI_EMBED_MODEL", "text-embedding-3-small")
    client = OpenAI()
    resp = client.embeddings.create(model=model, input=texts)
    return [item.embedding for item in resp.data]

def embed_azure_openai(texts):
    """Return list of vectors using Azure OpenAI embeddings API."""
    try:
        from openai import AzureOpenAI
    except Exception:
        print("Please `pip install openai` (>=1.0).", file=sys.stderr)
        sys.exit(1)

    endpoint = os.getenv("AZURE_OPENAI_ENDPOINT")
    key = os.getenv("AZURE_OPENAI_API_KEY")
    deployment = os.getenv("AZURE_OPENAI_EMBED_DEPLOYMENT")
    api_version = os.getenv("AZURE_OPENAI_API_VERSION", "2024-02-15-preview")

    client = AzureOpenAI(
        azure_endpoint=endpoint,
        api_key=key,
        api_version=api_version
    )
    resp = client.embeddings.create(model=deployment, input=texts)
    return [item.embedding for item in resp.data]

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--input", required=True)
    ap.add_argument("--output", required=True)
    args = ap.parse_args()

    rows = []
    with open(args.input, "r", newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for r in reader:
            rows.append(r)

    texts = [r.get("text") or "" for r in rows]
    if use_openai():
        vectors = embed_openai(texts)
    elif use_azure_openai():
        vectors = embed_azure_openai(texts)
    else:
        print("No embedding provider configured. Set either OpenAI or Azure OpenAI env vars.", file=sys.stderr)
        sys.exit(2)

    # Write output
    fieldnames = list(rows[0].keys()) + ["embedding"]
    with open(args.output, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        for r, v in zip(rows, vectors):
            r["embedding"] = json.dumps(v)
            w.writerow(r)

    print(f"Wrote {args.output}")

if __name__ == "__main__":
    main()
