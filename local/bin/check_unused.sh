#!/bin/bash

echo "Checking for potentially unused files..."
echo "======================================="

# Get all JS/TS files in src
find ./src -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" | while read file; do
  # Get filename without extension and path
  basename_file=$(basename "$file" | sed 's/\.[^.]*$//')

  # Skip certain files that are typically entry points or have special purposes
  if [[ "$file" =~ (page\.|layout\.|loading\.|error\.|not-found\.|route\.|middleware\.|globals\.|tailwind\.config|next\.config|payload\.config) ]]; then
    continue
  fi

  # Check if this file is imported anywhere
  if ! grep -r --include="*.js" --include="*.jsx" --include="*.ts" --include="*.tsx" \
    -l "from.*['\"].*$basename_file['\"]" ./src >/dev/null 2>&1 &&
    ! grep -r --include="*.js" --include="*.jsx" --include="*.ts" --include="*.tsx" \
      -l "import.*['\"].*$basename_file['\"]" ./src >/dev/null 2>&1 &&
    ! grep -r --include="*.js" --include="*.jsx" --include="*.ts" --include="*.tsx" \
      -l "require.*['\"].*$basename_file['\"]" ./src >/dev/null 2>&1; then
    echo "Potentially unused: $file"
  fi
done
