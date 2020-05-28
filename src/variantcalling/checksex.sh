#!/bin/bash

xcov=$(echo "scale=4; $(samtools idxstats $1 | grep 'chrX[^_]' | cut -f 3)/$(samtools idxstats $1 | grep 'chrX[^_]' | cut -f 2)" | bc)
echo $xcov
ycov=$(echo "scale=4; $(samtools idxstats $1 | grep "chrY[^_]" | cut -f 3)/$(samtools idxstats $1 | grep "chrY[^_]" | cut -f 2)" | bc)
echo $ycov

rat=$(echo "scale=4; ${xcov}/${ycov}" | bc)

echo $rat
