#!/bin/sh

../../crf_learn -a CRF-L2 -f 3 -c 4.0 -p 2 template cws-train.txt model
../../crf_test -m model cws-test.txt >> cws-result.txt

