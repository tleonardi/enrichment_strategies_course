Enrichment Strategies Course
============================
Bioinformatics worshop
----------------------------

In this practical you will:
- Download a ChIP Seq dataset, identify the peaks, obtain the corresponding DNA sequences and discover enriched motifs inside these sequences. Hopefully, by matching the identified motif with a database of Transcription Factor motifs you will be able to determine for which TF the ChIP-Seq experiment was made.

Before you start, download a copy of the human genome in fasta format.
If you are on linux type the following in a terminal:
```bash
wget -O - http://www.ebi.ac.uk/~tl344/hg19.fa.gz | gunzip > hg19.fa
```
If you are on a Mac:
```bash
curl -o - http://www.ebi.ac.uk/~tl344/hg19.fa.gz | gunzip > hg19.fa
```

While the dowload completes you can procede and download a ChIP-Seq dataset produced by the ENCODE project and available on UCSC:

### Download the ChIP-Seq dataset for the transcription factor X
```bash
wget -O - http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeSydhTfbs/wgEncodeSydhTfbsK562CmycStdPk.narrowPeak.gz | gunzip > chip-seq.narrowPeak
```

For more information on the format of this file, go here: http://genome.ucsc.edu/FAQ/FAQformat.html#format12
Now you can sort this file by q-value (column 9) and extract the top 500 peaks:

```bash
sort -k9,9g chip-seq.narrowPeak | head -500 > top500Peaks.bed
```

### What is the motif bound by TF X?
We now have an annotation of the genomic coordinates of the 500 most significant peaks. We can use bedtools to extract the corresponding DNA sequences in FASTA format:

```bash
bedtools getfasta -fi hg19.fa -bed top500Peaks.bed -fo top500Peaks.fa
```

There are various tools to discover enriched short motifs in a given set of sequences. One of the most popular ones is DREME (http://meme.nbcr.net/meme/cgi-bin/dreme.cgi). Go to the website, upload the FASTA file produced in the step above and enter your email address. You might also want to set the Count limit to a small number (e.g. 2 or 3), so that the execution doesn't take too long.

In the DREME results there's the list of identified enriched motifs together with their p-values and seqlogos. To find out if that motif corresponds to any know sequence bound by a transcription factor you can match it against a database of known motifs (two popular ones are Transfac and Jaspar). The MEME suite has a tool called TOMTOM that does this for you. Find the top motif, click submit and select TOMTOM from the list. When the search is done you should have a list of matches between the motif discovered by DREME and motifs in the database.

 
### What type of genes does X bind to?

The BED file with the ChIP-Seq peaks tells us where in the genome the TF binds, but we still have no idea whethere those regions are the promoters of some genes or not.
A quick and dirty way of finding it out is to obtain an annotation of all promoters in the human genome and check whether the peaks fall inside these promoters.

Download the annotation of all Gencode genes:

```bash
wget -O - "http://www.ebi.ac.uk/~tl344/GencodeV17_basic.bed.gz" | gunzip > gencodev17.bed
```

To obtain the coordinates of the promoters we can extend the TSS of each gene by 500bp each side. Keep in mind that the strand matters!

```bash
awk 'BEGIN{OFS=FS="\t"}{if($6=="+"){print $1,$2-500,$2+500,$4,$5,$6}if($6=="-"){print $1,$3-500,$3+500,$4,$5,$6}}' gencodev17.bed > gencode_promoters.bed
```

We can now intersect the peak annotation with the promoter annotation and report only the genes with a peak in their promoter:
```bash
bedtools intersect -a gencode_promoters.bed -b top500Peaks.bed -wa > genes_with_peaks.bed
cut -f4 gencodev17.bed > all_gencode_transcripts.txt
```

Now following the comments in the enrichment.R script try to do GO enrichment on this list of genes.






















