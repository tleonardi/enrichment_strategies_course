library("topGO")
library("org.Hs.eg.db")
library("ggplot2")
library("reshape")
# Load annotation
genes <- read.delim("genes_with_peaks.bed", stringsAsFactors=F, header=F)

# Make a list of trascript names removing the version number (trailing .[0-9])
selectedTranscripts <- gsub("\\.[0-9]+","",genes$V4,perl=T)

g2t <- read.delim("gene2transcript.txt", stringsAsFactors=F, header=T)

bgGenes <- unique(g2t[,1])

# Get the list of transcripts associated with pcRNAs and convert it to gene IDs
selectedGenes <- g2t[g2t[,2] %in% selectedTranscripts,1]

# Make the geneList for topGO
geneList <- factor(as.integer( bgGenes %in% selectedGenes))
names(geneList) <- bgGenes

# Create topGO object
data <- new("topGOdata", ontology = "BP", allGenes = geneList, annot = annFUN.org, ID = "ensembl", mapping="org.Hs.eg.db")

# Run test and correct p-vals
resultFis <- runTest(data, algorithm = "classic", statistic = "fisher")
score(resultFis) <- p.adjust(score(resultFis), method="BH")


allRes <- GenTable(data, classic = resultFis,orderBy="classic", topNodes=20)
#showSigOfNodes(data, score(resultFis), firstSigNodes = 5, useInfo = "all")
allRes$classic <- as.numeric(allRes$classic)
allRes$Term <- paste(allRes$Term,allRes$GO.ID)
allRes$Term <- factor(allRes$Term, levels=allRes$Term[order(allRes$Significant/allRes$Annotated,decreasing=F)])
pdf("GO.pdf")
ggplot(allRes,aes(y=Significant/Annotated,x=Term,fill=classic)) + geom_bar(stat="identity", aes(order=desc(classic))) + scale_fill_gradient(low="red",high="yellow")   + coord_flip()
dev.off()

