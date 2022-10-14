#!/bin/bash
shopt -s nullglob

out_file=out.md
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

  
    images=(
        sim1.png sim2.png sim3.png sim4.jpg 
        temp/extra/*.{jpg,png}
    )
    for image in "${images[@]}"; do
        echo "" | tee -a $out_file
        echo "## image: ${image}" | tee -a $out_file
        # psm_array=(0 1 2 3 4 5 6 7 8 9 10 11 12 13)

        # for multi line
        # psm_array=(4 11)
        # psm_array=(11)

        # for single line
        # psm_array=(4 6)
        # psm_array=(6)

        psm_array=(4 6 11)
        for psm in "${psm_array[@]}"; do
            echo "" | tee -a $out_file
            echo "### psm: ${psm}" | tee -a $out_file
            echo '```' | tee -a $out_file

            configs=(
                -c load_system_dawg=false
                -c load_freq_dawg=false
                -c tessedit_char_whitelist=0123456789
            )
            tesseract "$image" - --psm "$psm" -l eng "${configs[@]}" get.images | tee -a $out_file
            
            echo '' | tee -a $out_file
            echo '```' | tee -a $out_file
        done
    done

}

test
exit

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
