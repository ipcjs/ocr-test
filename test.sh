#!/bin/bash
out_file=out.txt
echo >$out_file

main() {
    # tesseract sim3.png - -l eng digits
    # tesseract eurotext.png - -l eng digits
    # tesseract sim4.jpg - --psm 11 -l eng | tee -a $out_file
    # tesseract sim2.png - --psm 11 -l eng | tee -a $out_file
    tesseract sim1.png - --psm 11 -l eng | tee -a $out_file
}

test() {
    export TESSDATA_PREFIX="$HOME/github/ocr/tessdata"
    # tesseract sim3.png out -l eng get.images
    # tesseract sim2.png out -l eng --dpi 200 get.images

    # psm_array=(0 1 2 3 4 5 6 7 8 9 10 11 12 13)
    psm_array=(4 11)
    for psm in "${psm_array[@]}"; do
        echo ""
        echo "=====>psm: ${psm}" | tee -a $out_file
        tesseract sim4.jpg - --psm "$psm" -l eng get.images | tee -a $out_file
    done
}

# test
# exit

dirs=(
    ""
    "$HOME/github/ocr/tessdata"
    "$HOME/github/ocr/tessdata_fast"
    "$HOME/github/ocr/tessdata_best"
)

for dir in "${dirs[@]}"; do
    echo
    echo "===> ${dir}" | tee -a $out_file
    if [[ -n "${dir}" ]]; then
        export TESSDATA_PREFIX=$dir
    else
        unset TESSDATA_PREFIX
    fi

    main
done
