#!/bin/bash
shopt -s nullglob

tesseract_bin=tesseract

test1() {
    out_file=out.md
    echo >$out_file

    # tesseract sim3.png - -l eng digits
    # tesseract eurotext.png - -l eng digits
    # tesseract sim4.jpg - --psm 11 -l eng | tee -a $out_file
    # tesseract sim2.png - --psm 11 -l eng | tee -a $out_file
    $tesseract_bin sim1.png - --psm 11 -l eng | tee -a $out_file
}

process() {
    # export TESSDATA_PREFIX="$HOME/github/ocr/tessdata"
    # tesseract sim3.png out -l eng get.images
    # tesseract sim2.png out -l eng --dpi 200 get.images

    images=(
        sim1.png sim2.png sim3.png sim4.jpg
        temp/extra/*.{jpg,png}
    )
    for image in "${images[@]}"; do
        echo ""
        echo "## image: ${image##*/}"
        # psm_array=(0 1 2 3 4 5 6 7 8 9 10 11 12 13)

        # for multi line
        # psm_array=(4 11)
        # psm_array=(11)

        # for single line
        # psm_array=(4 6)
        # psm_array=(6)

        psm_array=(4 6 11)
        for psm in "${psm_array[@]}"; do
            echo ""
            echo "### psm: ${psm}"
            echo '```'

            configs=(
                -c load_system_dawg=F
                -c load_freq_dawg=F
                -c tessedit_char_whitelist=0123456789N
            )
            $tesseract_bin "$image" - --psm "$psm" -l eng "${configs[@]}" get.images

            echo ''
            echo '```'
        done
    done

}

for_each_bin_and_repo() {
    bin_array=(
        tesseract
        # download from https://github.com/AlexanderP/tesseract-appimage/releases
        temp/bin/*.AppImage
    )
    repo_array=(
        # ""
        "tessdata"
        "tessdata_fast"
        "tessdata_best"
    )
    for tesseract_bin in "${bin_array[@]}"; do
        version=$($tesseract_bin --version | grep -Po '(?<=tesseract )[\d.]+')

        # for_each_repo | tee -a "$out_file"

        for repo in "${repo_array[@]}"; do
            repo_name="default"
            if [[ -n "${repo}" ]]; then
                export TESSDATA_PREFIX=$repo
                repo_name="${repo##*/}"
            else
                unset TESSDATA_PREFIX
            fi

            out_file="out/${version}_${repo_name}.md"
            echo "" > "$out_file"
            echo "- version: ${version}" | tee -a "$out_file"
            echo "- repo: $repo_name" | tee -a "$out_file"

            process | tee -a "$out_file"
        done
    done
}

for_each_bin_and_repo
