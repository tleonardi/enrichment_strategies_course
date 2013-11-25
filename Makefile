SHELL := /bin/bash


all: GO.pdf



genes_with_peaks.bed: 
	./ChIPSeq.sh

GO.pdf: genes_with_peaks.bed
	R --vanilla --slave --quiet < enrichment.R

clean:
	rm -rf chip-seq.narrowPeak
	rm -rf gencodev17.bed
	rm -rf top500Peaks.bed
	rm -rf top500Peaks.fa
	rm -rf gencode_promoters.bed
	rm -rf genes_with_peaks.bed
	rm -rf GO.pdf
