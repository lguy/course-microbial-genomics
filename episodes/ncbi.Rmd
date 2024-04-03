---
title: 'NCBI'
teaching: 0
exercises: 240
---

## Exercise 1: Global Cross-database NCBI Search

:::::::::::::::::::::::::::::::::::::: questions 

Exercise 1
- How do you efficiently and reliably navigate NCBI's website?
Exercise 2
- How do you search sequences?
- How do you use the right BLAST flavor?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

Exercise 1
- Familiarize yourself with the differences NCBI databases
- Browse and search the databases, using cross-links
Exercise 2
- Use and understand blast alignment tools
- Characterize sequences
- Understand genomic context and synteny

::::::::::::::::::::::::::::::::::::::::::::::::

This part is to encourage you to explore NCBI resources. Questions are examples or real-life questions that you might ask yourself later. There are not necessarily exactly one solution to the question. 
Start by going to NCBI's web site, main search page: https://www.ncbi.nlm.nih.gov/search/. There, you have the list of most of NCBI’s databases, sorted by category. Take some time to explore the following sections: Literature, Genomes, Genes and Proteins.

### Task 1.1: Find publications (this is a warm up!)

You want to find the following articles: 

1. an article about *Escherichia coli* O104:H4 published by Matthew K Waldor in the New England Journal of Medicine; and 
1. a paper about *E. coli* whose last author is L. Wang, published in PLoS ONE in 2014. 

NOTE: you do not know the exact title, list of authors, PMID etc. Use your search skills (solution provided below). There may be more than one result.

::::::::::::::::::::::::::::::::::::: challenge 

## Challenge 1.1.1

Find the two articles above using NCBI's literature database.

:::::::::::::::::::::::: hint

Use the advanced search from PubMed, by clicking on “Advanced” (tutorial https://www.ncbi.nlm.nih.gov/books/NBK3827/#pubmedhelp.PubMed_Quick_Start), to build an exact search. Use the different fields to build a search that returns only a single match.

:::::::::::::::::::::::::::::

:::::::::::::::::::::::: solution 

1. Rasko DA, Webster DR, […], Waldor MK. Origins of the *E. coli* strain causing an outbreak of hemolytic-uremic syndrome in Germany. N Engl J Med. 2011 Aug 25;365(8):709-17. doi: 10.1056/NEJMoa1106920. Epub 2011 Jul 27.
1. Zhang X, Li Y, Liu B, Wang J, Feng C, Gao M, Wang L. Prevalence of veterinary antibiotics and antibiotic-resistant *Escherichia coli* in the surface water of a livestock production region in northern China. PLoS One. 2014 Nov 5;9(11):e111026. doi: 10.1371/journal.pone.0111026. eCollection 2014.

:::::::::::::::::::::::::::::::::

## Challenge 1.1.2

Now try to find the most recent paper citing the first article by Rasko et al above. NCBI provides the “Cited by” link (right menu), but you can also use 

- Google Scholar (https://scholar.google.com) or 
- Web of Knowledge (https://www.webofknowledge.com; Access from UU: https://www.ub.uu.se/ > Databases A-Z > W > Web of Science Core Collection). The language settings of Google Scholar can be adjusted in the menu under Settings.

Then: 

- How did the two search engines compare? 
- Which one was easier to work with dates? 
- Which one returned most results? 
- Which one has more complete information?

::::::::::::::::::::::::::::::::::::::::::::::::

### Task 1.2: Find Gene records

You want to find sequences for the subunit A of the Shiga toxin in *E. coli* O157:H7 Sakai. Try to search in the three following databases: Gene, Nucleotide and Protein. 

:::::: challenge

## Challenge 1.2.1

What do the three different databases contain? What information do you get from them? 

::: hint

NCBI is not as smart as Google, and copy/pasting might fail. Try spelling out *Escherichia coli* and removing parts of the search text.

If you get too many hits, go to the field “Search details”, and refine your search, using the [Organism] field, for example. You don’t need to get exactly one hit or to get the result you want on top. By default, the search will include everything that has the species name anywhere in the record.

Nucleotide database contains mostly **genome** records, so the Shiga toxin gene might be anywhere there.

::::::::

## Challenge 1.2.2

What do the five top results from the Protein database show?

::::::::::::::::

### Task 1.3: Understand Gene records

Click on a Gene search result from Task 1.2 and skim through the entire page. 

:::::: challenge

## Challenge 1.3.1 

Who published the sequence? When? Is there a paper? 

::::::::::::::::

:::::: challenge

## Challenge 1.3.2 

What is known about the gene? Does the record include taxonomy information? 

::::::::::::::::

Click on the Organism link and go to the Taxonomy Browser. 

:::::: challenge

## Challenge 1.3.3 

What can you learn about species taxonomy there? What other useful information is given on this page?

::::::::::::::::

Back to the Gene page, have a look at the “Related information” section in the right column. 

:::::: challenge

## Challenge 1.3.4 

Where can you go from there? 

::: hint

All the information in that section ("Related information") is coming through the Entrez system. In the `FASTA` record, look for `\dbxref` (database cross-reference) which provides the Entrez links.

::::::::

::::::::::::::::

### Task 1.4: Understanding Protein records and sequences

Click on the Protein link for this gene. Look at the content of one of the records. 

:::::: challenge

## Challenge 1.4.1 

What can you learn here? What information do you find here? What is the name of this format? Are there any known protein domains in this protein? Can you identify a link to these? 


::: hint

You can change the format by clicking on the top left corner.
Look for "Related information" in the right menu.

::::::::

::::::::::::::::

:::::: challenge

## Challenge 1.4.2 

Can you find just the sequence information in `FASTA` format? How is the format organized? What is included in the header? Discuss the advantages of the two formats. Can you find a definition of both formats on the NCBI website or elsewhere?

::: solution

If you are stuck, here is the link to

- one Gene record: https://www.ncbi.nlm.nih.gov/gene/916678 
- one Protein record: https://www.ncbi.nlm.nih.gov/protein/NP_311001.1 

::::::::::::

::::::::::::::::

:::::: challenge

## Challenge 1.4.3 

Can you find a 3D protein structure for this protein? 

::::::::::::::::

:::::: challenge

## Challenge 1.4.4 

Can you display the genome record on which this gene is encoded?

::::::::::::::::


## Exercise 2: Sequence alignments

In this exericse, you will use the sequence alignment tool BLAST to align and retrieve sequences. 

NOTE: the NCBI blast service can be under very heavy load (especially during daytime in the US), and don’t be surprised if a single blast takes >10 minutes. As an alternative, you can use the BLAST service at the EBI website (http://www.ebi.ac.uk). Note that the EBI doesn’t have the same level of tool integration as NCBI, and some parts of the questions might be more challenging to answer with the EBI tools. A good tip to accelerate your searches and to reduce the load on the NCBI server is to consider smaller databases than the standard nr/nt ones.

### Task 2.1: Find nucleotide blast hits

Find the NCBI blast main page. 



:::::: challenge

## Challenge 2.1.1 

- What is BLAST? 
- What different kinds of BLAST searches are there? 
- What is blastn? blastx? blastp? tblastn?


::::::::::::::::

Find sequence hits for the following sequence, but first consider the options available on the BLAST page. One option that might come in very handy is the “open results in another window”, which will allow you to modify your query and rerun it quickly without losing the results:

```
>a
GATTACTTCAGCCAAAAGGAACACCTGTATATGAAGTGTATATTATTTAAATGGGTACTG
TGCCTGTTACTGGGTTTTTCTTCGGTATCCTATTCCCGGGAGTTTACGATAGACTTTTCG
ACCCAACAAAGTTATGTCTCTTCGTTAAATAGTATACGGACAGAGATATCGACCCCTCTT
GAACATATATCTCAGGGGACCACATCGGTGTCTGTTATTAACCACACCCCACCGGGCAGT
TATTTTGCTGTGGATATACGAGGGCTTGATGTCTATCAGGCGCGTTTTGACCATCTTCGT
CTGATTATTGAGCAAAATAATTTATATGTGGCCGGGTTCGTTAATACGGCAACAAATACT
TTCTACCGTTTTTCAGATTTTACACATATATCAGTGCCCGGTGTGACAACGGTTTCCATG
ACAACGGACAGCAGTTATACCACTCTGCAACGTGTCGCAGCGCTGGAACGTTCCGGAATG
CAAATCAGTCGTCACTCACTGGTTTCATCATATCTGGCGTTAATGGAGTTCAGTGGTAAT
ACAATGACCAGAGATGCATCCAGAGCAGTTCTGCGTTTTGTCACTGTCACAGCAGAAGCC
TTACGCTTCAGGCAGATACAGAGAGAATTTCGTCAGGCACTGTCTGAAACTGCTCCTGTG
TATACGATGACGCCGGGAGACGTGGACCTCACTCTGAACTGGGGGCGAATCAGCAATGTG
CTTCCGGAGTATCGGGGAGAGGATGGTGTCAGAGTGGGGAGAATATCCTTTAATAATATA
TCAGCGATACTGGGGACTGTGGCCGTTATACTGAATTGCCATCATCAGGGGGCGCGTTCT
GTTCGCGCCGTGAATGAAGAGAGTCAACCAGAATGTCAGATAACTGGCGACAGGCCCGTT
ATAAAAATAAACAATACATTATGGGAAAGTAATACAGCTGCAGCGTTTCTGAACAGAAAG
TCACAGTTTTTATATACAACGGGTAAATAAAGGAGTTAAGCATGAAGAAGATGTTTATGG
```

:::::: challenge

## Challenge 2.1.2 

- Is it a gene? 
- If yes, what does it encode? 
- What is the closest organism? What can you infer about its taxonomic distribution?

::: hint

What does a protein-coding gene need to produce proteins? 

::::::::

::::::::::::::::

Now go back to the blast main page.

:::::: challenge

## Challenge 2.1.3 

- Did you choose the right blast algorithm to answer the questions above? 
- Can you do better?


::: hint

What if you try another flavor of the blast suite?

::::::::

::::::::::::::::

Repeat the procedure for this other sequence:

```
>b
GATTACTTCAGCCAAAAGGAACACCTGTATATGAAGTGTATATTATTTAAATGGGTACTG
TGCCTGTTACTGGGTTTTTCTTCGGTATCCTATTCCCGGGAGTTTACGATAGACTTTTCG
ACCCAACAAAGTTATGTCTCTTCGTTAAATAGTATACGGACAGAGATATCGACCCCTCTT
GAACATATATCTCAGGGGACCACATCGGTGTCTGTTATTAACCACACCCCACCGGGCAGT
TATTTTGCTGTGGATATACGAGGGCTTGATGTCTATCAGGCGCGTTTTGACCATCTTCGT
CTGATTATTGAGCAAAATAATTTATATGTGGCCGGGTTCGTTAATACGGCAACAAATACT
TTCTACCGTTTTTCAGATTTTACACATATATCAGTGCCCGGTGGACAACGGTTTCCATGA
CAACGGACAGCAGTTATACCACTCTGCAACGTGTCGCAGCGCTGGAACGTTCCGGAATGC
AAATCAGTCGTCACTCACTGGTTTCATCATATCTGGCGTTAATGGAGTTCAGTGGTAATA
CAATGACCAGAGATGCATCCAGAGCAGTTCTGCGTTTTGACTGTCACTGTCACAGCAGAA
GCCTTACGCTTCAGGCAGATACAGAGAGAATTTCGTCAGGCACTGTCTGAAACTGCTCCT
GTGTATACGATGACGCCGGGAGACGTGGACCTCTTTTTTTACTCTGAACTGGGGGCGAAT
CAGCAATGTGCTTCCGGAGTATCGGGGAGAGGATGGTGTCAGAGTGGGGAGAATATCCTT
TAATAATATATCAGCGATACTGGGGACTGTGGCCGTTATACTGAATTGCCATCATCAGGG
GGCGCGTTCTGTTCGCGCCGTGAATGAAGAGAGTCAACCAGAATGTCAGATAACTGGCGA
CAGGCCCGTTATAAAAATAAACAATACATTATGGGAAAGTAATACAGCTGCAGCGTTTCT
GAACAGAAAGTCACAGTTTTTATATACAACGGGTAAATAAAGGAGTTAAGCATGAAGAAG
ATGTTTATGG
```

:::::: challenge

## Challenge 2.1.4 

How does sequence `b` compare to the first sequence? Is it also a gene? 


::: hint

if you get stuck, try e.g. StarORF (http://star.mit.edu/orf/index.html). 

::::::::

::::::::::::::::

:::::: challenge

## Challenge 2.1.5 

- Can you perform a pairwise alignment between both sequences? 
- What are the differences? 

::::::::::::::::


### Task 2.2: Find protein blast hits

Now find sequences with similarity to this protein

```
>c
MMNRSIYRQFVRYTIPTVAAMLVNGLYQVVDGIFIGHYVGAEGLAGINVAWPVIGTILGIGMLVGVGTGA 
LASIKQGEGHPDSAKRILATGLMSLLLLAPIVAVILWFMADDFLRWQGAEGRVFELGLQYLQVLIVGCLF 
TLGSIAMPFLLRNDHSPNLATLLMVIGALTNIALDYLFIAWLQWELTGAAIATTLAQVVVTLLGLAYFFS 
ARANMRLTRRCLRLEWHSLPKIFAIGVSSFFMYAYGSTMVALHNTLMIEYGNAVMVGAYAVMGYIVTIYY 
LTVEGIANGMQPLASYHFGARNYDHIRKLLRLAMGIAVLGGMAFVLVLNLFPEQAIAIFNSSDSELIAGA 
QMGIKLHLFAMYLDGFLVVSAAYYQSTNRGGKAMFITVGNMSIMLPFLFILPQFFGLTGVWIALPISNIV 
LSTVVGIMLWRDVNKMGKPTQVSYA
```

:::::: challenge

## Challenge 2.2.1 

- What is this gene coding for? 
- Where did it likely come from?  

::::::::::::::::

:::::: challenge

## Challenge 2.2.2 

- Can you align nucleotide sequences (sequence `a`, Task 2.1) against a protein database? 
- If so, how? 

::::::::::::::::

:::::: challenge

## Challenge 2.2.3 

- Can you align proteins to a nucleotide database? 
- If so, how? If not, why not?


::::::::::::::::

### Task 2.3: Find gene and genome hits

This task should be performed at the NCBI page (not at EBI). 

What is the following sequence? 

```
>d
GTGTCTAAAGAAAAATTTGAACGTACAAAACCGCACGTTAACGTTGGTACTATCGGCCACGTTGACCACG
GTAAAACTACTCTGACCGCTGCAATCACCACCGTACTGGCTAAAACCTACGGCGGTGCTGCTCGTGCATT
CGACCAGATCGATAACGCGCCGGAAGAAAAAGCTCGTGGTATCACCATCAACACTTCTCACGTTGAATAT
GACACCCCGACCCGTCACTACGCACACGTAGACTGCCCGGGGCACGCCGACTATGTTAAAAACATGATCA
CCGGTGCTGCTCAGATGGACGGCGCGATCCTGGTAGTTGCTGCGACTGACGGCCCGATGCCGCAGACTCG
TGAGCACATCCTGCTGGGTCGTCAGGTAGGCGTTCCGTACATCATCGTGTTCCTGAACAAATGCGACATG
GTTGATGACGAAGAGCTGCTGGAACTGGTTGAAATGGAAGTTCGTGAACTTCTGTCTCAGTACGACTTCC
CGGGCGACGACACTCCGATCGTTCGTGGTTCTGCTCTGAAAGCGCTGGAAGGCGACGCAGAGTGGGAAGC
GAAAATCCTGGAACTGGCTGGCTTCCTGGATTCTTACATTCCGGAACCAGAGCGTGCGATTGACAAGCCG
TTCCTGCTGCCGATCGAAGACGTGTTCTCCATCTCCGGTCGTGGTACCGTTGTTACCGGTCGTGTAGAAC
GCGGTATCATCAAAGTTGGTGAAGAAGTTGAAATCGTTGGTATCAAAGAGACTCAGAAGTCTACCTGTAC
TGGCGTTGAAATGTTCCGCAAACTGCTGGACGAAGGCCGTGCTGGTGAGAACGTAGGTGTTCTGCTGCGT
GGTATCAAACGTGAAGAAATCGAACGTGGTCAGGTACTGGCTAAGCCGGGCACCATCAAACCGCACACCA
AGTTCGAATCTGAAGTGTACATTCTGTCCAAAGATGAAGGCGGCCGTCATACTCCGTTCTTCAAAGGCTA
CCGTCCGCAGTTCTACTTCCGTACTACTGACGTGACTGGTACCATCGAACTGCCGGAAGGCGTAGAGATG
GTAATGCCGGGCGACAACATCAAAATGGTTGTTACCCTGATCCACCCGATCGCGATGGACGACGGTCTGC
GTTTCGCAATCCGTGAAGGCGGCCGTACCGTTGGTGCGGGCGTTGTTGCTAAAGTTCTGGGCTAA
```

:::::: challenge

## Challenge 2.3.1 

- What organism is it likely from? 
- Is it a gene? 
- If yes, which one?
- What does it code for? 

::: hint

Use rather blastn to identify the origin of the gene. Explore the alignments of the first hit, and try the “Graphics” button associated with the results. 

::::::::

### Challenge 2.3.2 

- Where is it located on the genome (precision at ~10kb is good enough)? 
- Are there several copies in the genome?

::: hint

Mark down the name of the gene (generally three letters in lower case and one in uppercase). From the protein record, there is a link to the genome record, which has a “graphics” interface.

::::::::

::: hint 

Not all genomes are equally well annotated and you might have to search for a genome that is well annotated. One good example is *Escherichia fergusonii* ATCC 35469

::::::::

::::::::::::::::

:::::: challenge

## Challenge 2.3.3 

- How far is this gene (and possible copies) from the origin of replication? 
- How is it oriented with respect to replication? 

::: hint

What genes are reliable markers for the origin of replication? 
Can you find a paper about that? 
Now can you find that gene in the genome above?

:::::::

::: hint

What is the dnaA gene doing?

:::::::

::::::::::::::::

### Task 2.4 (optional): Explore the synteny functions of the STRING database

We are interested in genes that are normally located next to each other, and their taxonomic breadth.

Open the STRING database (https://string-db.org/). Search for the Shiga toxin-encoding genes in bacteria.

:::::: challenge

## Challenge 2.4.1 

- Can you find the Shiga toxin-coding genes in *Escherichia coli* K-12? 
- Do you find the same strain as above? 

::::::::::::::::

:::::: challenge

## Challenge 2.4.2 

Can you tell on what chromosomal feature these genes are located?

::: hint

What genes are located next to these genes?

::::::::

::: hint

What is a lysogenic phage?

::::::::

::::::::::::::::

Feel free to explore the different functions of the database. What do the different links in the network mean? What happens if you remove the least reliable interaction sources (i.e. text mining and databases? 

Now modify the settings to keep only Neighborhood as edges. Go back to the Viewers tab. Search for the other gene discussed above, *tufA*, do the same as for *stx1*, and compare the results. 

:::::: challenge

## Challenge 2.4.3 

- How many genes are co-localized with *stx1*? 
- What are the functions of these? 

::::::::::::::::

:::::: challenge

## Challenge 2.4.4 

- How many genes are co-localized with *tufA*? 
- What are the functions of the gene? 
- Does the function correlate with the taxonomic breadth of the gene?

::::::::::::::::

For both genes, select the Neighborhood viewer. 

:::::: challenge

## Challenge 2.4.5 

- How taxonomically widespread are the *stx1*, respectively *tufA* genes? 
- How conserved is the gene order for these two genes?

::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- NCBI website is very, very comprehensive
- The Entrez cross-referencing system helps retrieving links bits of data of different type.

::::::::::::::::::::::::::::::::::::::::::::::::

