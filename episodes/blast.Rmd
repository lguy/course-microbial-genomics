---
title: 'BLAST'
teaching: 0
exercises: 240
---

:::::::::::::::::::::::::::::::::::::: questions 

- How to use the command-line version of `BLAST`?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Run different flavors of `BLAST`
- Use different databases
- Use profile-based `BLAST` to retrieve distant homologs

::::::::::::::::::::::::::::::::::::::::::::::::

::: instructors

Core: 
Find the protein sequence for RpoB in E. coli
Find homologs in landmark
Extract proteins from database

Extra:
Explore the options of BLAST
- query
- subject
- database
- taxids (etc)
- num_threads
- outfmt
Use psi-blast with a pattern


module load bioinfo-tools blast blast_databases
blastp -db landmark -query rpoB_ecoli.fasta

:::::::::::::::

## Introduction

The goal of this exercise is to practice with the command line-based version of `BLAST`. It is also the first step in building phylogenetic trees, namely by gathering homologous sequences that will then be aligned. The alignment is finally used to build a tree. 

The whole exercise is based on RpoB, the [&Beta;-subunit of the bacterial RNA polymerase](https://en.wikipedia.org/wiki/RpoB). This protein is essential to the cell, and present in all bacteria and plastids. It is also very conserved, and thus suitable for deep-scale phylogenies.

### BLAST

`BLAST` (basic local alignment search tool, also referred to as the Google of biological research) is one of the most widely used tools in bioinformatics. The wide majority of its uses can be performed online, but for larger searches, batches or advanced uses, the command line version, performed locally on a computer or cluster, is indispensable. 

### Resources at UPPMAX

`BLAST` is available at UPPMAX. To load the `blast` module, you will need to load the `bioinfo-tools` module first. To use the standard databases that NCBI maintains, use the `blast_databases` module. All three can be loaded with the same command: 

```bash
module load bioinfo-tools blast blast_databases
```

Databases available at UPPMAX are described here: https://www.uppmax.uu.se/resources/databases/blast-databases/. By using the `blast_databases` module, you don't need to specify where the databases are located on the file system. In detail, it sets the `BLASTDB` variable to the right folder. You can see it by typing `echo $BLASTDB` in the terminal.   

Gene and protein records are usually associated with a `taxid`, to describe what organisms they come from. This can be very useful to limit the search to a certain taxon, or to exclude another taxon. E.g. if you want to investigate whether a certain gene has been transferred from bacteria to archaea: you would search for that specific by excluding all bacteria and eukaryotes. 

Taxonomy resources at UPPMAX are described here: https://www.uppmax.uu.se/resources/databases/ncbi-taxonomy-databases

## Exercise 0: Login to Uppmax

This is just a reminder of the introduction to Linux and how to login to Uppmax. 

:::::: challenge

## Challenge 0.1

Login to Uppmax and navigate to the course folder, create a folder for a `blast` exercise. 

Remember the best practices you learned for file naming.

All exercises should be performed inside `/proj/g2020004/nobackup/3MK013/<username>` where `<username>` is your own folder.

::: solution

```bash
ssh –Y username@rackham.uppmax.uu.se
cd /proj/g2020004/nobackup/3MK013/<username>/
mkdir blast
```
 
::::::::::::

## Challenge 0.2

Access an interactive session that is booked for us.

::: solution

```bash
interactive -A uppmax2024-2-10 -M snowy -t 4:00:00 --reservation=uppmax2023-2-10_x
```

::::::::::::

::::::::::::::::


## Exercise 1: Finding and retrieving homologs

Here, you will first find the protein query to start your search with. You will test different methods to create a file containing only RpoB from *E. coli*. Then, you will use that file as a query to find homologs of RpoB in different databases. 

### Task 1.1: Retrieve the RpoB sequence for *E. coli*

First, use your recently acquired [NCBI-fu](https://en.wiktionary.org/wiki/-fu#English) to retrieve the sequence from *E. coli* K-12. There are many genomes, and thus many identical proteins, grouped into [Identical Protein Groups](https://www.ncbi.nlm.nih.gov/ipg/). NCBI's databases are (almost) non-redundant (that's where the name of the largest protein database, `nr` comes from), and thus only one representative per IPG is present. Thus search in IPG, and find the IPG's accession number. Write down the accession number somewhere. 

:::::: challenge

## Challenge 1.1.1: Finding *E. coli*'s RpoB

Find the accession number for the IPG containing the RpoB sequence of *E. coli* K-12, and download the sequence in `FASTA` format.

::: solution

The IPG record can be found here: https://www.ncbi.nlm.nih.gov/ipg/1258700

The accession number is `WP_000263098.1`.

The sequence in fasta format can be downloaded at https://www.ncbi.nlm.nih.gov/protein/WP_000263098.1?report=fasta by clicking on the "Send to" link and then choosing `FASTA` format. Save the file under `rpoB_ecoli.fasta`.

The fasta file should look like:

```
>WP_000263098.1 MULTISPECIES: DNA-directed RNA polymerase subunit beta [Enterobacteriaceae]
MVYSYTEKKRIRKDFGKRPQVLDVPYLLSIQLDSFQKFIEQDPEGQYGLEAAFRSVFPIQSYSGNSELQY
VSYRLGEPVFDVQECQIRGVTYSAPLRVKLRLVIYEREAPEGTVKDIKEQEVYMGEIPLMTDNGTFVING
```

::::::::::::

::::::::::::::::

### Task 1.2: Push the sequence to UPPMAX

The sequence is located on your computer, and you need to transfer it to your computer. You will test several methods to push it to UPPMAX, to be able to use it as a query for `BLAST`. 

:::::: challenge

## Challenge 1.2.1: Use `scp`

`scp`, secure file copy, is a tool to copy files via SSH, the same protocol you use to login to UPPMAX. You can use it with the following syntax: 

```bash
scp <file to copy> <username>@<server>:<remote file location>
```

The remote file location can be a relative path from your home or an absolute path, starting with `/`. 

::: solution

 
```bash
scp rpoB_ecoli.fasta <username>@rackham.uppmax.uu.se:/proj/g2020004/nobackup/3MK013/<username>/blast
```
::::::::::::

::: hint

Use `man scp` to show the manual for scp.

::::::::

## Challenge 1.2.2: Use copy/paste

A quick and dirty method is to open a graphical text editor on the remote server and paste the information in it. One such tool is `gedit`. Paste the content of the file into `gedit` and save it in the appropriate folder, under `rpoB_ecoli.fasta`.

::: solution

On UPPMAX

```bash
cd /proj/g2020004/nobackup/3MK013/<username>/blast
gedit rpoB_ecoli.fasta &
```

The `&` executes the program in the background, leaving you control of the command line.
 
::::::::::::

## Challenge 1.2.3: Extract sequence from database

Since you know the accession number of the sequence to be used as a query, you can use the `blast` tools to extract that specific sequence from one of the databases available at UPPMAX. The tool in question is `blastdbcmd`. That specific sequence is presumably present in multiple databases. In doubt, one could search `nr`. But since *E. coli* K-12 is present in the tiny [`landmark` database](https://blast.ncbi.nlm.nih.gov/smartblast/smartBlast.cgi?CMD=Web&PAGE_TYPE=BlastDocs#searchSets), you can use that one. 

Put the sequence, in `FASTA` format, into a file called `rpoB_ecoli.fasta`

The manual for `blastdbcmd` can be obtained with: 

```bash
blastdbcmd -help
```

::: solution

```bash
blastdbcmd -db landmark -entry WP_000263098 > rpoB_ecoli.fasta
```
 
::::::::::::

::: hint

You should use the `-db` option and the `-entry` one. 

::::::::

## Challenge 1.2.4 (optional): Size of databases

Can you figure out a way to find the size of these two databases? How does it affect the time to retrieve information from them? Is it worth thinking about it?

::: solution

You can look at the size of the databases by using `blastdbcmd` and the flag `-info`. To see how much time it takes to retrieve that single sequence from either database, use the command `time` in front of the command: 

```bash
blastdbcmd -db landmark -info
blastdbcmd -db nr -info

time blastdbcmd -db landmark -entry WP_000263098 > /dev/null
time blastdbcmd -db nr -entry WP_000263098 > /dev/null
```

```output
Database: Landmark database for SmartBLAST
	403,974 sequences; 229,101,880 total residues

Date: Oct 17, 2023  5:37 PM	Longest sequence: 35,991 residues

[...]

Database: All non-redundant GenBank CDS translations+PDB+SwissProt+PIR+PRF excluding environmental samples from WGS projects
	721,441,320 sequences; 277,730,601,621 total residues

Date: Feb 25, 2024  2:57 AM	Longest sequence: 98,182 residues

[...]
real	0m1.369s     # for landmark
[...]
real	0m10.059s.   # for nr

```

::::::::::::

::::::::::::::::

### Task 1.3: Finding homologs to RpoB with `BLAST`

Now we have a query to start our search. Check that the file is present (`ls`) and that it looks like a `FASTA` file (`less`).

```output
>WP_000263098.1 unnamed protein product [Escherichia coli] >NP_312937.1 RNA polymerase beta subunit [Escherichia coli O157:H7 str. Sakai]
MVYSYTEKKRIRKDFGKRPQVLDVPYLLSIQLDSFQKFIEQDPEGQYGLEAAFRSVFPIQSYSGNSELQYVSYRLGEPVF
```

The file header might look slightly different, depending on how you obtained it. Now use `blastp` to find homologs of the RpoB protein. Use the help for `blastp` to explore the options you need to set.

:::::: challenge

## Challenge 1.3.1: Use `blastp` to find homologs in the landmark database

The path to the databases is already set correctly by the `modules blast_databases` command. See `echo $BLASTDB` to display it. Put the results into a file called `rpoB_landmark.blast`

::: solution

blastp -db landmark -query rpoB_ecoli.fasta > rpoB_landmark.blast

::::::::::::

::: hint

Use the following command to find options. Explore `-database`

```bash
blastp -help
```

::::::::

::::::::::::::::

Explore the results of the `blastp` command by displaying the file in which you put the output of `blastp`. In particular look at the E-values: do all hits look like true homologs? How can you change that?


:::::: challenge

## Challenge 1.3.2: Use `blastp` to find better homologs

Find the right option to change the E-value threshold to include hits. Try to rerun the `blastp` search with a more reasonable value than the default (10). 

::: solution

```bash
blastp -db landmark -query rpoB_ecoli.fasta -evalue 1e-6 > rpoB_landmark.blast
```

::::::::::::

::: hint

As a rule of thumb, hits that have a E-value < 1e-6 are *bona fide* homologs. Look at the `-evalue` option.

::::::::

::::::::::::::::

Explore the results again. Is it better? 

The default format of the `blast` output is "human-friendly", something that resembles the output that is created on the NCBI website. To produce an output that is even closer to NCBI's output, use the `-html` option.

The default format is fine for visual inspection, but not very convenient for computers to read. For example, in some cases you might want to perform data analysis on the output, e.g. to sort the results further or to compare the output of different runs. In that case, a tabular-like output is to prefer. The main option is `-outfmt`, and setting it to `6` will produce such a tabular output. The columns can be further specified, see the manual. 

:::::: challenge

## Challenge 1.3.3: Explore the output format of `BLAST`

Play with the different options for outfmt, the different formats and how to customize the tabular formats (6, 7 and 10).

Finally, produce a standard tabular output for the same run as above and put the result into a file called `rpoB_landmark`.

::: solution

```bash
blastp -db landmark -query rpoB_ecoli.fasta -evalue 1e-6 -outfmt 6 > rpoB_landmark.tab
```
 
::::::::::::

::::::::::::::::

### Task 1.4: Extract the sequences


## Exercise 2: Using PSI-BLAST to retrieve distant homologs of proteins


::: instructors

Sometimes in future we could develop a new exercise, to retrieve 16S sequences within a specific taxon. But so far this episode is long enough, I believe, so I let it be. 

## Exercise 3: Finding full-length 16S sequences within a taxon



:::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- BLAST is a blast!

::::::::::::::::::::::::::::::::::::::::::::::::

