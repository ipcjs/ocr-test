#!/bin/bash
git clone https://github.com/tesseract-ocr/tessdata.git &
git clone https://github.com/tesseract-ocr/tessdata_best.git &
git clone https://github.com/tesseract-ocr/tessdata_fast.git &

wait && echo finished!
