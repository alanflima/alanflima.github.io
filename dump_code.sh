#!/bin/bash
# Gera um arquivo único com todo o código do projeto, indicando o caminho de cada arquivo.
# Uso: ./dump_code.sh [arquivo_saida]

OUTPUT="${1:-code_dump.txt}"
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

# Extensões/arquivos de código a incluir (ignora binários e assets)
EXTENSIONS="html|css|js|ts|json|md|txt|yml|yaml|sh|swift|xml"

> "$OUTPUT"

echo "=== Code Dump - $(date) ===" >> "$OUTPUT"
echo "=== Projeto: $(basename "$PROJECT_ROOT") ===" >> "$OUTPUT"
echo "" >> "$OUTPUT"

OUTPUT_BASENAME="$(basename "$OUTPUT")"

git -C "$PROJECT_ROOT" ls-files | while read -r file; do
  # Pula o próprio arquivo de saída para evitar loop infinito
  [ "$(basename "$file")" = "$OUTPUT_BASENAME" ] && continue

  # Pula binários e arquivos indesejados
  case "$file" in
    *.png|*.jpg|*.jpeg|*.gif|*.svg|*.ico|*.woff|*.woff2|*.ttf|*.eot|*.DS_Store) continue ;;
  esac

  filepath="$PROJECT_ROOT/$file"

  # Verifica se é arquivo de texto
  if file -b --mime-type "$filepath" | grep -q "^text/"; then
    echo "========================================" >> "$OUTPUT"
    echo "📄 Arquivo: $file" >> "$OUTPUT"
    echo "========================================" >> "$OUTPUT"
    cat "$filepath" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
  fi
done

echo "✅ Dump gerado em: $OUTPUT"
echo "   Tamanho: $(wc -c < "$OUTPUT" | xargs) bytes"
echo "   Linhas:  $(wc -l < "$OUTPUT" | xargs)"
