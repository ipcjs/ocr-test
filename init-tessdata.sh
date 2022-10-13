#!/bin/bash
repos=(
    'tessdata'
    'tessdata_best'
    'tessdata_fast'
)

for repo in "${repos[@]}"; do
    if [[ "${repo}" != *"://"* ]]; then
        repo="https://github.com/tesseract-ocr/$repo.git"
    fi
    git clone "$repo" --recurse-submodules &
done

wait && echo finished!
