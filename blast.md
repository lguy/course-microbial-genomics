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

<!---

Feedback VT2025
- Perhaps too long / challenging; 80% of students stayed until the last minute
- They don't know what a PSSM (if that's the word) is; Chayan explained it on the blackboard
- The "big" blast takes >1h, so afaik a single student had it finished in time. I let others copy from his folder for the sake of comparison

NOTES: 

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


module load bioinfo-tools blast
blastp -db landmark -query rpoB_ecoli.fasta

---> 

## Introduction

The goal of this exercise is to practice with the command line-based version of `BLAST`. It is also the first step in building phylogenetic trees, namely by gathering homologous sequences that will then be aligned. The alignment is finally used to build a tree. 

The whole exercise is based on RpoB, the [&beta;-subunit of the bacterial RNA polymerase](https://en.wikipedia.org/wiki/RpoB). This protein is essential to the cell, and present in all bacteria and plastids. It is also very conserved, and thus suitable for deep-scale phylogenies.

### BLAST

`BLAST` (basic local alignment search tool, also referred to as the Google of biological research) is one of the most widely used tools in bioinformatics. The wide majority of its uses can be performed online, but for larger searches, batches or advanced uses, the command line version, performed locally on a computer or cluster, is indispensable. 

### Resources at UPPMAX

`BLAST` is available at UPPMAX. To load the `blast` module, you will need to load the `bioinfo-tools` module first. The `blast` module also loads the `blast_databases` module, to be able to use the standard databases that NCBI maintains. 

```bash
module load bioinfo-tools blast
```

Databases available at UPPMAX are described here: https://docs.uppmax.uu.se/databases/blast/. The `blast_databases` module implies that you don't need to specify where the databases are located on the file system. In detail, it sets the `BLASTDB` variable to the right folder. You can see it by typing `echo $BLASTDB` in the terminal.   

Gene and protein records are usually associated with a `taxid`, to describe what organisms they come from. This can be very useful to limit the search to a certain taxon, or to exclude another taxon. E.g. if you want to investigate whether a certain gene has been transferred from bacteria to archaea: you would search for that specific by excluding all bacteria and eukaryotes. 

Taxonomy resources at UPPMAX are described here: https://docs.uppmax.uu.se/databases/ncbi/

## Exercise 0: Login to Uppmax

This is just a reminder of the introduction to Linux and how to login to Uppmax. 

:::::: challenge

## Challenge 0.1

Login to Uppmax and navigate to the course folder, create a folder for a `blast` exercise. 

Remember the best practices you learned for file naming.

All exercises should be performed inside `/proj/g2020004/nobackup/3MK013/<username>` where `<username>` is your own folder.

::: hint

`ssh` is used to connect to an external server. `-Y` forwards the graphical display to your computer. The address of the server is `rackham.uppmax.uu.se`. You need to add your user name in front of it, with a `@` in between. 

The course folder is at `/proj/g2020004/nobackup/3MK013/`.

There, make a folder with your username. 

Inside it, create a `blast` folder for this exercise.

::::::::

::: instructor

```bash
ssh –Y username@rackham.uppmax.uu.se
cd /proj/g2020004/nobackup/3MK013/<username>/
mkdir blast
```

::::::::::::


## Challenge 0.2

Access an `interactive` session that is booked for us. The session is `uppmax2025-3-4`. Use the `snowy` cluster, for 4 hours.

::: solution

```bash
interactive -A <project> -M <cluster> -t <hh:mm:ss> 
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

The accession number is `WP_000263098.1`.

The sequence in fasta format can be downloaded at https://www.ncbi.nlm.nih.gov/protein/ by searching the accession number clicking on the "Send to" link and then choosing `FASTA` format. Save the file under `rpoB_ecoli.fasta`.

The fasta file should look like:

```
>WP_000263098.1 MULTISPECIES: DNA-directed RNA polymerase subunit beta [Enterobacteriaceae]
MVYSYTEKKRIRKDFGKRPQVLDVPYLLSIQLDSFQKFIEQDPEGQYGLEAAFRSVFPIQSYSGNSELQY
VSYRLGEPVFDVQECQIRGVTYSAPLRVKLRLVIYEREAPEGTVKDIKEQEVYMGEIPLMTDNGTFVING
```

::::::::::::

::: instructor

The IPG record can be found here: https://www.ncbi.nlm.nih.gov/ipg/1258700

The fasta file can be found here: https://www.ncbi.nlm.nih.gov/protein/WP_000263098.1?report=fasta

::::::::::::::

::::::::::::::::

### Task 1.2: Push the sequence to UPPMAX

The sequence is located on your computer, and you need to transfer it to your computer. You will test several methods to push it to UPPMAX, to be able to use it as a query for `BLAST`. 

:::::: challenge

## Challenge 1.2.1: Use `scp`

`scp`, secure file copy, is a tool to copy files via SSH, the same protocol you use to login to UPPMAX. You can use it *on your computer* with the following syntax: 

```bash
scp <file to copy> <username>@<server>:<remote file location>
```

The remote file location can be a relative path from your home or an absolute path, starting with `/`. 

To bring up a local terminal on your Windows computer, click on the "+" sign on the main window of MobaXTerm. If that doesn't work, use SFTP. Click on Session, SFTP, and fill in the Remote host as usual `rackham.uppmax.uu.se` and your username. Navigate to `/proj/g2020004/nobackup/3MK013/<username>/blast` on the right panel, then drag and drop files between your computer and Uppmax.

::: instructor

```bash
scp rpoB_ecoli.fasta <username>@rackham.uppmax.uu.se:/proj/g2020004/nobackup/3MK013/<username>/blast
```

::::::::::::::

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

::: hint

If you have closed your session, you may need to use `module load` to load the appropriate module.

You may want to look into `-db` and `-entry` arguments.

::::::::


::: solution

```bash
blastdbcmd -db <db name> -entry <accession> > <file>
```
 
::::::::::::

::: instructor

```bash
blastdbcmd -db landmark -entry WP_000263098 > rpoB_ecoli.fasta
```
 
::::::::::::::

::: hint

You should use the `-db` option and the `-entry` one. 

::::::::

## Challenge 1.2.4 (optional): Size of databases

Can you figure out a way to find the size of these two databases? How does it affect the time to retrieve information from them? Is it worth thinking about it?

::: hint

You can look at the size of the databases by using `blastdbcmd` and the flag `-info`. To see how much time it takes to retrieve that single sequence from either database, use the command `time` in front of the command: 

::::::::

::: solution

```bash
blastdbcmd -db <db> -info

time blastdbcmd -db <db> -entry <accession> > /dev/null
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

::: instructor

```bash
blastdbcmd -db landmark -info
blastdbcmd -db nr -info

time blastdbcmd -db landmark -entry WP_000263098 > /dev/null
time blastdbcmd -db nr -entry WP_000263098 > /dev/null
```
::::::::::::::

::::::::::::::::

### Task 1.3: Finding homologs to RpoB with `BLAST`

Now we have a query to start our search. Check that the file is present (`ls`) and that it looks like a `FASTA` file (`less`).

```output
>WP_000263098.1 unnamed protein product [Escherichia coli] >NP_312937.1 RNA polymerase beta subunit [Escherichia coli O157:H7 str. Sakai]
MVYSYTEKKRIRKDFGKRPQVLDVPYLLSIQLDSFQKFIEQDPEGQYGLEAAFRSVFPIQSYSGNSELQYVSYRLGEPVF
[...]
```

The file header might look slightly different, depending on how you obtained it. Now use `blastp` to find homologs of the RpoB protein. Use the help for `blastp` to explore the options you need to set.

:::::: challenge

## Challenge 1.3.1: Use `blastp` to find homologs in the landmark database

The path to the databases is already set correctly by the `modules load blast` command. See `echo $BLASTDB` to display it. Put the results into a file called `rpoB_landmark.blast`

::: hint

Use the following command to find options. Explore `-database`

```bash
blastp -help
```

::::::::


::: solution

```bash
blastp -db <db> -query <fasta file> > <output file>
```

::::::::::::

::: instructor

```bash
blastp -db landmark -query rpoB_ecoli.fasta > rpoB_landmark.blast
```

::::::::::::::

::::::::::::::::

Explore the results of the `blastp` command by displaying the file in which you put the output of `blastp`. Inspect the alignments, including those at the bottom of file, which have worse alignments. In particular look at the E-values: do all hits look like true homologs? How can you change that?


:::::: challenge

## Challenge 1.3.2: Use `blastp` to find better homologs

Find the right option to change the E-value threshold to include hits. What is the default E-value? What does that mean? 

Try to rerun the `blastp` search with a more reasonable value than the default. 

::: hint

As a rule of thumb, hits that have a E-value < 1e-6 are *bona fide* homologs. Look at the `-evalue` option.

::::::::

::: solution

```bash
blastp -db <db> -query <fasta_file> -evalue <evalue> > output
```

::::::::::::

::: instructor

```bash
blastp -db landmark -query rpoB_ecoli.fasta -evalue 1e-6 > rpoB_landmark.blast
```

::::::::::::

::::::::::::::::

Explore the results again. Is it better, even the last alignments?

The default format of the `blast` output is "human-friendly", something that resembles the output that is created on the NCBI website. To produce an output that is even closer to NCBI's output, use the `-html` option.

The default format is fine for visual inspection, but not very convenient for computers to read. For example, in some cases you might want to perform data analysis on the output, e.g. to sort the results further or to compare the output of different runs. In that case, a tabular-like output is to prefer. The main option is `-outfmt`, and setting it to `6` will produce such a tabular output. The columns can be further specified, see the manual. 

:::::: challenge

## Challenge 1.3.3: Explore the output format of `BLAST`

Play with the different options for outfmt, the different formats and how to customize the tabular formats (6, 7 and 10).

Finally, produce a standard tabular output for the same run as above and put the result into a file called `rpoB_landmark.tab`. This file can then downloaded to your own computer and opened with `R` or with Excel. 

Note that the query sometimes yields several hits in the same query protein. This is caused by the protein being long and having its different domains being separated by less conserved domains. 

::: solution

`blastp` command:

```bash
blastp -db <db> -query <fasta file> -evalue <e-value> -outfmt <number> > <output_file>
```

To import the file to your computer, to the current directory, use the same `scp` program as above. **This should be run on your own computer, not from UPPMAX**.

```bash
scp <username>@rackham.uppmax.uu.se:<course base folde>/3MK013/<username>/blast/<file> .
```

::::::::::::

::: instructor

```bash
blastp -db landmark -query rpoB_ecoli.fasta -evalue 1e-6 -outfmt 6 > rpoB_landmark.tab
``` 

```bash
scp <username>@rackham.uppmax.uu.se:/proj/g2020004/nobackup/3MK013/<username>/blast/rpoB_landmark.tab .
```

::::::::::::

::::::::::::::::

### Task 1.4: Use a larger database

So far you have used the `landmark` database, which is tiny. Now, use a different, larger database, to gather more results from a broader set of bacteria. Run a `blastp` again. How many significant hits do you find in these?

:::::: challenge

## Challenge 1.4.1: Larger database

`refseq_select_prot` and `refseq_protein` are good candidates. The former is smaller than the latter. Note that these two runs will take time, so run only the one to `refseq_select_prot`. We will run it in the background (adding a `&` at the end of the command) so that you can continue with other tasks and come back to that one later. 

You can check whether `blastp` is still running by typing `ps`:

```bash
ps
```

```output
  PID TTY          TIME CMD
13920 pts/64   00:00:00 bash
33117 pts/64   00:00:00 blastp
35427 pts/64   00:00:00 ps
```

If you see `blastp` there, it means it is still running. It could take up to 30 minutes. When `blastp` is done, count the number of hits obtained. 

::: hint

The list of locally available databases is listed here: 
https://www.uppmax.uu.se/resources/databases/blast-databases/ 

::::::::


::: solution


```bash
blastp -db <db> -query <fasta file> -evalue <e-value> -outfmt 6 > rpoB_<db>.tab &
```
When it has finished (it may take up to 30 minutes), count the rows to have the number of hits:

```bash
wc -l rpoB_<db>.tab
```

```output
500 rpoB_refseq_select.tab
```

You have actually hit the maximum number of aligned sequences to keep by default (500). You could change that by using the `-max_target_seqs` option and setting it to a larger number. 
 
::::::::::::

::: instructor


```bash
blastp -db refseq_select_prot -query rpoB_ecoli.fasta -evalue 1e-6 -outfmt 6 > rpoB_refseq_select.tab &
```

```bash
wc -l rpoB_refseq_select.tab
```
 
::::::::::::


::::::::::::::::


### Task 1.5: Extract the sequences from the database

You found hits, i.e. proteins that show similarity with the query protein. To prepare for the next steps (multiple sequence alignment and building trees), you will need to retrieve the actual proteins and put them in a `FASTA` file. The simplest way is to directly extract them from the database, using the same tool (`blastdbcmd`) as above. You will first need to extract a list of the accession numbers from the blast results. 

:::::: challenge

## Challenge 1.5.1: Extract the sequences with `blastdbcmd`

Use `blastdbcmd` to retrieve the accession ids from the `landmark` database. To prepare the list of proteins to extract, `cut` the blast results to keep the accession number of the hits. As you noticed above, there are multiple hits per protein and one hit per line, resulting in each subject protein being possibly present several times. You will need to produce a non-redundant list of ids.

::: hint

```bash
blastdbcmd -help
man uniq
man sort
```

::::::::

::: hint

The second column of the default tabular output provides the accession id. `cut` the tabular output of the blast file, pipe it to `sort` and then to `uniq`, and send the result in a file. Then use that file as a input to `blastcmd` to extract the proteins. Last time we used `-entry` because we had just one, but there is another argument that takes a list of entries instead. Put the result in the `rpoB_homologs.fasta` file. 

::::::::

::: solution

```bash
cut -f2 <blast_output_file> | sort | uniq > <id_file> 
blastdbcmd -db <db> -entry_batch <id_file> > rpoB_homologs.fasta
```
 
::::::::::::

::: instructor

```bash
cut -f2 rpoB_landmark.tab | sort | uniq > rpoB_landmark_ids 
blastdbcmd -db landmark -entry_batch rpoB_landmark_ids > rpoB_homologs.fasta
```
 
::::::::::::


## Challenge 1.5.2: Count the sequences

Can you count how many sequences were included in the fasta file? Use `grep` and your knowledge of the `FASTA` format.


::: hint

```bash
man grep
man wc
```

::::::::

::: solution

You can take a look at the sequences that were included in the blast:

```bash
grep ">" <fasta_file> | less
```

And then count them by piping the result to `wc` instead.

There should be around 70 sequences. 

```output
70
```

For the upcoming episode on multiple sequence alignment, you will use a subset of these. 
 
::::::::::::

::: instructor


```bash
grep ">" rpoB_homologs.fasta | less
grep ">" rpoB_homologs.fasta | wc -l 
```
 
::::::::::::

::::::::::::::::


## Exercise 2: Using PSI-BLAST to retrieve distant homologs of proteins

In this exercise, you will use another flavor of `BLAST` to retrieve distant homologs of a protein. As an example, we will use the protein RavC, present in the genomes of  [*Legionella* bacteria](https://en.wikipedia.org/wiki/Legionella). This protein is an effector protein, injected by *Legionella* into the cytoplasm of their host (protists). The exact function is unknown, but it is presumably important, as it is conserved throughout the whole order *Legionellales*. Many effectors found in this group are derived from eukaryotic proteins, and this is what you will test here: does RavC have a homolog in eukarotes?

The strategy is to use `psiblast`, which uses - instead of a single query - a matrix of amino-acid frequencies as a query. `psiblast` is an iterative program: you generally start with one sequence, gather *bona fide* homologs, use the profile of these to query the database again, gather new homologs, recalculate the profile, then re-query the database, etc. The search may converge after a certain number of iterations, i.e. there no more new homologs to find with the latest profile. 

In this case, you will use a slightly different strategy: you will start with one sequence, align it to `refseq_select_prot` but only to sequences in the order *Legionellales*, using the `taxids` options that limits the taxonomic scope of the search. You will save the profile (PSSM) generated by the first `psiblast` round and reuse this to then query the whole database, with three iterations. 

### Task 2.1: Extract RavC from a database

As above, you will extract the sequence of RavC from a database. This time you will use `refseq_select_prot`, since there are no *Legionella* in `landmark`. The accession number of RavC that you will use is [`WP_010945868.1`](https://www.ncbi.nlm.nih.gov/protein/WP_010945868.1).

:::::: challenge

## Challenge 2.1.1: Extract RavC

Retrieve sequence `WP_010945868.1` from the `refseq_protein` database and put it into a file called `ravC_LP.fasta`. Check the content of the `FASTA` file.

::: hint

`blastdbcmd -help`

::::::::

::: solution

```bash
blastdbcmd -db <db> -entry <accession> > <output_file>
```

```output
>WP_010945868.1 RMD1 family protein [Legionella pneumophila] >ERH46094.1 hypothetical protein N750_05210 [Legionella pneumophila str. Leg01/53] >ERH46577.1 hypothetical protein N751_07400 [Legionella pneumophila str. Leg01/11] >ERI48669.1 hypothetical protein N749_09265 [Legionella pneumophila str. Leg01/20] >MFO2512789.1 RMD1 family protein [Legionella pneumophila serogroup 2] >MFO2594790.1 RMD1 family protein [Legionella pneumophila serogroup 3] >MFO2645706.1 RMD1 family protein [Legionella pneumophila serogroup 8] >MFO2989133.1 RMD1 family protein [Legionella pneumophila serogroup 6] >MFO3234997.1 RMD1 family protein [Legionella pneumophila serogroup 5] >MFO3476243.1 RMD1 family protein [Legionella pneumophila serogroup 7] >MFO8588967.1 RMD1 family protein [Legionella pneumophila serogroup 14] >MFO8774718.1 RMD1 family protein [Legionella pneumophila serogroup 10] >MFP3789783.1 RMD1 family protein [Legionella pneumophila serogroup 9]
MECLSFCVAKTIDLTRLDLHLKNVSKEFSAVKTRDVIRLNSHRNKDHTLFIFKNGTVVSWGVKRYQIHEYLDIIKLLVDK
PVALLVHDEFHYQIGDKTAIEPHGFYDVDCLTIEEDSDELKLSLSYGFSQSVKLQYFETIIDALIEKYNPLIQALSHKGE
MPISRKQIQQVIGEILGAKSELNLISNFLYHPKYFWQHPTLEEHFSMLERYLHIQRRVNAINHRLDTLNEIFDMFNGYLE
SRHGHHLEIIIIVLIAVEIIIAVMNFHF
```

::::::::::::

::: instructor

```bash
blastdbcmd -db refseq_protein -entry WP_010945868.1 > ravC_LP.fasta
```

::::::::::::::

::::::::::::::::

### Task 2.2: Align RavC to sequences belonging to *Legionellales*

That task is a bit complex, so let's break it down in several steps. You will:

1. align the RavC sequence to the `refseq_select_prot` database, using `psiblast`, and put the result into the file `ravC_Leg.psiblast`. 
1. save the [PSSM (the amino-acid profile built by psiblast)](https://en.wikipedia.org/wiki/Position_weight_matrix) after the last round, both in its "native" form and in text format.
1. filter hits so that only hits with E-value < 1e-6 are shown
1. filter hits so that only hits with E-value < 1e-10 are included in the PSSM
1. filter hits so that only hits belonging to the order *Legionelalles* are included

:::::: challenge

## Challenge 2.2.1: Psiblast 

Build the command, using the `psiblast` command, the query you extracted above and the `refseq_select_prot` database. 

::: caution 

Don't run the command yet, as this will run for a while! We are just building the command now. Wait for the end of the section.

::::::::::

::: hint

```bash
psiblast -help
```
::::::::

::: solution

That is the base of the command:

```bash
psiblast -query <fasta file> -db <db> > ravC_Leg.psiblast
```
 
::::::::::::

::: instructor

```bash
psiblast -query ravC_LP.fasta -db refseq_select_prot > ravC_Leg.psiblast
```
 
::::::::::::


### Challenge 2.2.2: Saving the PSSM

Now add the options to save the PSSM after the last round, and save the PSSM both as binary and ascii form. Add these options to the command above, but you will only run it when it is finished.

::: hint 

In the PSI-blast help there is a "PSI-BLAST options" section.

For long help pages, it is sometimes useful to pipe the help message to `grep` and use a combination of `-A` (after), `-B` (before), and `--color` (color matches).


```bash
psiblast -help
psiblast -help | grep --color -B 5 -A 2 pssm
```

::::::::

::: solution

```bash
psiblast -query <fasta_file> -db <db> -save_pssm_after_last_round -out_pssm <pssm_file> -out_ascii_pssm <pssm_file.txt> > ravC_Leg.psiblast
```
 
::::::::::::

::: instructor

```bash
psiblast -query ravC_LP.fasta -db refseq_select_prot -save_pssm_after_last_round -out_pssm ravC_Leg.pssm -out_ascii_pssm ravC_Leg.pssm.txt > ravC_Leg.psiblast
```
 
::::::::::::

### Challenge 2.2.3: Thresholds

Now add the E-value thresholds. You want to display hits with E-value < 1e-6, but only include those with E-value < 1e-10. Add the options to the rest.

::: solution

```bash
psiblast -query <fasta_file> -db <db> -save_pssm_after_last_round -out_pssm <pssm_file> -out_ascii_pssm <pssm_file.txt> -inclusion_ethresh <evalue> -evalue <evalue> > ravC_Leg.psiblast
```
 
::::::::::::

::: instructor

```bash
psiblast -query ravC_LP.fasta -db refseq_select_prot -save_pssm_after_last_round -out_pssm ravC_Leg.pssm -out_ascii_pssm ravC_Leg.pssm.txt -inclusion_ethresh 1e-10 -evalue 1e-6 > ravC_Leg.psiblast
```
 
::::::::::::


### Challenge 2.2.4: Taxonomic range

Now limit the results to the order *Legionellales*. Find the taxid of this group on the NCBI website.

Note: this feature has been upgraded in the latest version of `BLAST` (2.15.0+). It is now possible to include all descendants of a single taxid, using only that taxid. In previous versions of `BLAST`, you had to include all descending taxids using a script. 

::: hint

Check out the Taxonomy section of NCBI: https://www.ncbi.nlm.nih.gov/Taxonomy/

::::::::

::: solution

https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=Info&id=118969&lvl=3&lin=f&keep=1&srchmode=1&unlock 

```bash
psiblast -query <fasta_file> -db <db> -save_pssm_after_last_round -out_pssm <pssm_file> -out_ascii_pssm <pssm_file.txt> -inclusion_ethresh <evalue> -evalue <evalue> -taxids <taxid> > ravC_Leg.psiblast
```
 
::::::::::::

::: instructor

```bash
psiblast -query ravC_LP.fasta -db refseq_select_prot -save_pssm_after_last_round -out_pssm ravC_Leg.pssm -out_ascii_pssm ravC_Leg.pssm.txt -inclusion_ethresh 1e-10 -evalue 1e-6 -taxids 118969 > ravC_Leg.psiblast
```
 
::::::::::::


### Challenge 2.2.5: Running the command and examining the results

Run now the full command as above. When it's done, look at the resulting files. There should be three of them. Take some time to explore these three files, especially the alignments resulting from the `psiblast`.


::::::::::::::::


### Task 2.3: Align the PSSM to the whole database

You will now take the resulting PSSM and use that as a query to perform a `psiblast` against the whole `refseq_select_prot` database (not only against *Legionellales*). You want to perform max 10 iterations (the search will stop if it converges before the tenth iteration), and increase the max number of target sequences to gather to 1000 per iteration. You also want to change the output to a tabular form with comments and add more columns to get into more details.

:::::: challenge

## Challenge 2.3.1: Align the PSSM, set E-value thresholds, iteration and max sequences

Build the command as above, but don't set the `-query` option, use the option that allows to input a PSSM instead. Set the E-value thresholds as above, the number of iterations to 10 and the maximum number of sequences to gather to 1000 (per round). Direct the result to the file `ravC_all.psiblast`. 

Don't run it yet, more options to come.


::: hint

```bash
psiblast -help
psiblast -help | grep --color -B 5 -A 2 pssm
```

::::::::

::: solution

```bash
psiblast -in_pssm <binary pssm file> -db <db> -inclusion_ethresh <evalue> -evalue <evalue> -max_target_seqs <number> -num_iterations 10 > ravC_all.psiblast
```

::::::::::::

::: instructor

psiblast -in_pssm ravC_Leg.pssm -db refseq_select_prot -inclusion_ethresh 1e-10 -evalue 1e-6 -max_target_seqs 1000 -num_iterations 10 > ravC_all.psiblast


::::::::::::

## Challenge 2.3.2: Set the output format

You want to have a tabular result format with comments, to help you understand the output. You also want to use the standard columns but add the query coverage per subject, the scientific and common name of the subject sequence, as well as which super-kingdom (or domain) it belongs to.

::: hint

Inspect the "Formatting options" section of the psiblast help page.

:::

::: solution

The correct `-outfmt` is 7. The string with the correct columns is composed with this number and then column names, separated by spaces, the whole enclosed by double quotes. An example in the help file of psiblast is `"10 delim=@ qacc sacc score"`

psiblast -in_pssm <binary pssm file> -db <db> -inclusion_ethresh <evalue> -evalue <evalue> -max_target_seqs <number> -num_iterations 10 -outfmt "<format_number> <col1> <col2> ..." > ravC_all.psiblast

::::::::::::

::: instructor

psiblast -in_pssm ravC_Leg.pssm -db refseq_select_prot -inclusion_ethresh 1e-10 -evalue 1e-6 -max_target_seqs 1000 -num_iterations 10 -outfmt "7 qaccver saccver pident length mismatch gapopen qstart qend sstart send qcovs evalue bitscore ssciname scomname sskingdom" > ravC_all.psiblast

::::::::::::


## Challenge 2.3.3: Run the command and examine the results

This will take a while to run, maybe 30 minutes. When done, open the result file and examine it. Did you find hits in the eukaryotes? 

::::::::::::::::


<!---

Sometimes in future we could develop a new exercise, to retrieve 16S sequences within a specific taxon. But so far this episode is long enough, I believe, so I let it be. 


## Exercise 3: Finding full-length 16S sequences within a taxon

--->

::::::::::::::::::::::::::::::::::::: keypoints 

- Using BLAST is a blast! 
- Choice of database is a crucial trade-off between efficiency and sensitivity

::::::::::::::::::::::::::::::::::::::::::::::::

