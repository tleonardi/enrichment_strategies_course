Enrichment Strategies Course
============================
Bioinformatics worshop
----------------------------

In this practical you will:
- Download a ChIP Seq dataset, identify the peaks, obtain the corresponding DNA sequences and discover enriched motifs inside these sequences. Hopefully, by matching the identified motif with a database of Transcription Factor motifs you will be able to determine for which TF the ChIP-Seq experiment was made.

To begin with, download a ChIP-Seq dataset produced by the ENCODE project and available on UCSC:

```bash
wget -O - "http://genome.ucsc.edu/cgi-bin/hgTables?hgsid=353809755&boolshad.hgta_printCustomTrackHeaders=0&hgta_ctName=tb_wgEncodeSydhTfbsK562CmycStdPk&hg    ta_ctDesc=table+browser+query+on+wgEncodeSydhTfbsK562CmycStdPk&hgta_ctVis=pack&hgta_ctUrl=&fbQual=whole&fbUpBases=200&fbDownBases=200&hgta_doGetBed=get+BE    D" > chip-seq.narrowPeak
```
For more information on the format of this file, go here: http://genome.ucsc.edu/FAQ/FAQformat.html#format12
Now you can sort this file by q-value (column 9) and extract the top 500 peaks:

```bash
sort -k9,9g chip-seq.narrowPeak | head -500 > top500Peaks.bed
```

We now have an annotation of the genomic coordinates of the 500 most significant peaks. We can use bedtools to extract the corresponding DNA sequences in FASTA format:

```bash
bedtools getfasta -fi ../../tom/projects/pcRNAs/analysis/data/hg19.fa -bed top500Peaks.bed -fo top500Peaks.fa
```

There are various tools to discover enriched short motifs in a given set of sequences. One of the most popular ones is DREME (http://meme.nbcr.net/meme/cgi-bin/dreme.cgi). Go to the website, upload the FASTA file produced in the step above and enter your email address. You might also want to set the Count limit to a small number (e.g. 2 or 3), so that the execution doesn't take too long.

In the DREME results there's the list of identified enriched motifs together with their p-values and seqlogos. To find out if that motif corresponds to any know sequence bound by a transcription factor you can match it against a database of known motifs (two popular ones are Transfac and Jaspar). The MEME suite has a tool called TOMTOM that does this for you. Find the top motif, click submit and select TOMTOM from the list. When the search is done you should have a list of matches between the motif discovered by DREME and motifs in the database.

 

