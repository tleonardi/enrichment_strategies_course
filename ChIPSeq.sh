#!/bin/bash

wget -O - http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeSydhTfbs/wgEncodeSydhTfbsK562CmycStdPk.narrowPeak.gz | gunzip > chip-seq.narrowPeak

wget -O - "http://www.ebi.ac.uk/~tl344/GencodeV17_basic.bed.gz" | gunzip > gencodev17.bed

# Extract top 500 peaks with best peaks
sort -k9,9g chip-seq.narrowPeak | head -500 > top500Peaks.bed

# Get FASTA for DREME
bedtools getfasta -fi ../../tom/projects/pcRNAs/analysis/data/hg19.fa -bed top500Peaks.bed -fo top500Peaks.fa

# Annotate gencode promoters
awk 'BEGIN{OFS=FS="\t"}{if($6=="+"){print $1,$2-500,$2+500,$4,$5,$6}if($6=="-"){print $1,$3-500,$3+500,$4,$5,$6}}' gencodev17.bed > gencode_promoters.bed

# Overlap ChIP Seq peaks with the promoter annotation
bedtools intersect -a gencode_promoters.bed -b top500Peaks.bed -wa > genes_with_peaks.bed

