#!/bin.bash

wget -O - "http://genome.ucsc.edu/cgi-bin/hgTables?hgsid=353809755&boolshad.hgta_printCustomTrackHeaders=0&hgta_ctName=tb_wgEncodeSydhTfbsK562CmycStdPk&hgta_ctDesc=table+browser+query+on+wgEncodeSydhTfbsK562CmycStdPk&hgta_ctVis=pack&hgta_ctUrl=&fbQual=whole&fbUpBases=200&fbDownBases=200&hgta_doGetBed=get+BED" > wgEncodeSydhTfbsK562CmycStdPk.narrowPeak

wget -O - "http://genome.ucsc.edu/cgi-bin/hgTables?hgsid=353810773&boolshad.hgta_printCustomTrackHeaders=0&hgta_ctName=tb_wgEncodeGencodeBasicV17&hgta_ctDesc=table+browser+query+on+wgEncodeGencodeBasicV17&hgta_ctVis=pack&hgta_ctUrl=&fbQual=whole&fbUpBases=200&fbExonBases=0&fbIntronBases=0&fbDownBases=200&hgta_doGetBed=get+BED" > gencodev17.bed

# Extract top 500 peaks with best peaks
sort -k9,9g wgEncodeSydhTfbsK562CmycStdPk.narrowPeak  | head -500 > top500Peaks.bed

# To what genes do the promoters map?



# Submitted to DREME at 11.52
bedtools getfasta -fi ../../tom/projects/pcRNAs/analysis/data/hg19.fa -bed top500Peaks.bed -fo top500Peaks.fa



findMotifsGenome.pl top500Peaks.bed hg19 top500Peaks.out -len 6


# Annotate gencode promoters
awk 'BEGIN{OFS=FS="\t"}{if($6=="+"){print $1,$2-500,$2+500,$4,$5,$6}if($6=="-"){print $1,$3-500,$3+500,$4,$5,$6}}' gencodev17.bed > gencode_promoters.bed

# Overlap ChIP Seq peaks with the promoter annotation
bedtools intersect -a gencode_promoters.bed -b top500Peaks.bed -wa > genes_with_peaks.bed

cut -f4 gencodev17.bed > all_gencode_transcripts.txt
