---
title: 'Sequence assembly'
teaching: 0
exercises: 240
---

Sequence assembly means the alignment and merging of reads in order to reconstruct the original sequence. The assembly of a genome from short sequencing reads can take a while. We will therefore run this process for two genomes only.

::::::::::::::::::::::::::::::::::::::: objectives

- Understand differences between assembly methods
- Assemble the short reads

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How can the information in the sequencing reads be reduced?
- What are the different methods for assembly?

::::::::::::::::::::::::::::::::::::::::::::::::::


## Exercise 1: Sequence assembly with SKESA

The assembler we will run is [SKESA](https://github.com/ncbi/SKESA). SKESA generates a final assembly from multiple kmers. A list of kmers is automatically selected by SKESA using the maximum read length of the input data, and each individual kmer contributes to the final assembly. If desired, the lengths of kmers can be specified with the `--kmer` and `--steps` flags which will adjust automatic kmer selection.

Because assembly of each genome would take a long time, you will only run one assembly here.

::: challenge

### Preparation

Start the interactive session, go to the `molepi` subfolder, create a `results/assembly` subfolder. Then go to the folder containing the fastq files (`data/trimmed_fastq`) that you created in the previous tutorial.

::: hint

You know this by now... 
```bash
interactive
cd
mkdir
```

:::::::::

::: solution

Project is `uppmax2025-3-4`, cluster is `snowy`

```bash
interactive <project> <cluster> <time>
cd /proj/g2020004/nobackup/3MK013/<username>/molepi/
mkdir results/assembly
cd data/trimmed_fastq
```

:::::::::::::

::: instructor

```bash
interactive -A uppmax2025-3-4 -M snowy -t 04:00:00
cd /proj/g2020004/nobackup/3MK013/<username>/molepi/
mkdir results/assembly
cd data/trimmed_fastq
```

:::::::::::::

:::::::::::::


### Running SKESA in a loop

To run SKESA we will use the skesa command with a number of option that we will explore later on. We can start the loop (again, a short loop with only one sample in this actual case to spare computing resources) with the assemblies with: 

```bash
module load bioinfo-tools SKESA
for sample in ERR029206
do
skesa \
--cores 2 \
--memory 8 \
--fastq "${sample}"_1.fastq.gz_trim.fastq "${sample}"_2.fastq.gz_trim.fastq 1> ../../results/assembly/"${sample}".fasta
done
```

A non-quoted backslash, `\` is used as an escape character in Bash. It preserves the literal value of the next character that follows, with the exception of newline. This means that the back slash starts a new line without starting a new command - we only add it for better readability. 

::: discussion 

The output redirection sign (`1>`) is different than the ususal `>`. It specifies that only the standard output (i.e. generally the results) will go to that file, while the standard error (i.e. warning and error messages, or other logging information) are displayed on the console. To save the standard error to a file, use `2>`, e.g. 

```bash
# Information, don't run that
skesa <options> 1> results.fasta 2> logfile
```
::::::::::::::

The assembly should take about 5 minutes per genome, using 2 cores and 8 GB of memory. 

### Downloading the missing assemblies

If you haven't assembled all samples, download the finished contigs to your computer and decompress them. They will decompress in a folder called `assembly`, so one solution is to rename the assembly folder you already have to something else:

```bash
cd ../../results/
mv assembly partial_assembly
tar xvzf /proj/g2020004/nobackup/3MK013/data/assemblies.tar.gz
ls assembly
```

```output
ERR026473.fasta ERR026478.fasta ERR026482.fasta ERR029207.fasta
ERR026474.fasta ERR026481.fasta ERR029206.fasta
```

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge: What do the command line parameters of SKESA mean?

Find out a) the version of SKESA you are using and b) what the used command line parameters mean.

::: hint

```bash 
skesa -h
```

prints the help information in `skesa`

::::::::

:::::::::::::::  solution

## Solution

```output
skesa -h
..
General options:
-h [ --help ]                 Produce help message
-v [ --version ]              Print version
..
--cores arg (=0)              Number of cores to use (default all) [integer]
--memory arg (=32)            Memory available (GB, only for sorted counter)
..  
--fastq arg                   Input fastq file(s) (could be used multiple times for different runs) [string]
..
..
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

### Examine the results of the assembly

You will now explore the files output by SKESA. Find out the number of contigs, and the various assembly statistics.

What do the they mean? What are N50, L50, N80 and L80?

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge: How many contigs were generated by SKESA?

Find out how many contigs there are in the *M. tuberculosis* isolates. Use for example the [GenomeTools](https://genometools.org/) software, available as module with the same name on Uppmax. The main program is called `gt`. The documentation is comprehensive and can be found on the website or via the command line. We are looking for some subcommand that can give use statistics on sequences. 

::: hint

```bash
module load GenomeTools 
```
::::::::

::: hint

```bash
gt --help
```
::::::::

::: hint

```bash
gt seqstat --help
```
::::::::


:::::::::::::::  solution

## Solution

```bash
module load GenomeTools 
gt seqstat <fastafile>
```

```output
# number of contigs:     390
# total contigs length:  4239956
# mean contig size:      10871.68
# contig size first quartile: 989
# median contig size:         5080
# contig size third quartile: 15546
# longest contig:             74938
# shortest contig:            200
# contigs > 500 nt:           323 (82.82 %)
# contigs > 1K nt:            291 (74.62 %)
# contigs > 10K nt:           148 (37.95 %)
# contigs > 100K nt:          0 (0.00 %)
# contigs > 1M nt:            0 (0.00 %)
# N50                25167
# L50                54
# N80                11379
# L80                129
```

:::::::::::::::::::::::::

:::::::::::::::  instructor

```bash
module load GenomeTools 
gt seqstat ERR026473.fasta
```

:::::::::::::::::::::::::


## Challenge: Compare the results of the different samples

How to compare assemblies? What do N50 and L50 mean?

How could you get N50 stats for all the assemblies?

:::hint

Wikipedia is your friend: https://en.wikipedia.org/wiki/N50,_L50,_and_related_statistics

:::::::

:::hint

Write a `for` loop over accessions, printing the accession name and running `gt` on each fasta file. Grepping for the information you want. You can grep two different patterns by prefixing each pattern with `-e`. E.g. `grep -e "this" -e "that"` greps this or that.

:::::::

::: solution


```bash
for accession in <all accessions>
do
  echo <variable name, accessed with ${...}>
  gt seqstat <variable name>.fasta | grep -e <first pattern> -e <second patter>
done

```

::::::::::::

::: instructor

```bash
for accession in ERR029207 ERR029206 ERR026478 ERR026474 ERR026473 ERR026481 ERR026482
do
  echo "${accession}"
  gt seqstat "${accession}".fasta | grep -e N50 -e L50
done

```

::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::


## Exercise 2: assembly with SPAdes

To compare how different assemblers perform, you will also use [SPAdes](https://ablab.github.io/spades/). SPAdes is a very versatile and can assemble many different data types, including combining long and short reads.

:::challenge

## Challenge: Assemble the genomes with SPAdes

You will only perform the assembly on one genome, but use the loop form anyway. You will use the `--isolate` mode, but the `--careful` mode would also be interesting. This might take 5-10 minutes per genome. 

SPAdes can be loaded with the `spades` module, and the main command is `spades.py`. Make a `spades_assembly` folder in the `molepi/results` folder and go there. Then run a 1-genome loop as above. SPAdes has arguments `-1` and `-2` for reads from two ends, the `-o` to use a specific folder to store the output (use `<accession>_spades`), `-t` to use several threads (use 2), and `-m` to set the maximum memory in Gb (use 8).

::: hint

```bash

```

::::::::

::: solution

Folders etc:

```bash
cd /proj/g2020004/nobackup/3MK013/<username>/molepi/results
mkdir spades_assembly
cd spades_assembly
```

Running SPAdes

```bash
module load <module>
for accession in ERR029206
do
  <print the accession with echo>
  spades.py \
    <mode isolate> \
    <flag for read file 1> ../../data/trimmed_fastq/"${accession}"_1.fastq.gz_trim.fastq \
    <flag for read file 2> ../../data/trimmed_fastq/"${accession}"_2.fastq.gz_trim.fastq \
    -o <output folder> \
    <options for 2 threads and 8 Gb memory>
done

```

::::::::::::

::: instructor

```bash
module load spades
cd /proj/g2020004/nobackup/3MK013/<username>/molepi/results
mkdir spades_assembly
cd spades_assembly
for accession in ERR029206
do
  echo "${accession}"
  spades.py \
    --isolate \
    -1 ../../data/trimmed_fastq/"${accession}"_1.fastq.gz_trim.fastq \
    -2 ../../data/trimmed_fastq/"${accession}"_2.fastq.gz_trim.fastq \
    -o "${accession}"_spades \
    -t 2 \
    -m 8
done

```

::::::::::::


## Challenge: Compare the results of the assembly with SPAdes and SKESA

Using Genome Tools, compare the result of the two assemblies.

::: hint

```bash
cd /proj/g2020004/nobackup/3MK013/<username>/molepi/results
gt --help
```


:::

::: solution

```bash
cd /proj/g2020004/nobackup/3MK013/<username>/molepi/results
gt <sequence statistics?> <spades contigs>
gt <sequence statistics?> <skesa contigs>
```

::::::::

::: instructor

```bash
cd /proj/g2020004/nobackup/3MK013/<username>/molepi/results
gt seqstat assembly/ERR029206.fasta
gt seqstat spades_assembly/ERR029206_spades/contigs.fasta
```

::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::


## Exercise 3: Preliminary annotation 

### Physical annotation

The goal here is to find ORFs and start codons, and thus identify proteins in the genome.

::: challenge

## Challenge: Use prodigal

Find how prodigal works and use it to annotate the proteome of ERR029206. Make an `annotation` folder in the `molepi/results` folder. Use default settings, only setting the input file `-i` and writing the protein translations (`-a`) to a `.faa` file. Redirect the standard output (`>`) to a `.gbk` file. For both files, use the accession number as prefix.

::: hint

```bash
module load prodigal
prodigal -h
```

:::

::: solution

```bash
cd /proj/g2020004/nobackup/3MK013/<username>/molepi/results
mkdir annotation
cd annotation
module load prodigal
prodigal -i <contig file> -a <accession.faa> > <accession.gbk>
```

::::::::::::

::: instructor

```bash
cd /proj/g2020004/nobackup/3MK013/<username>/molepi/results
mkdir annotation
cd annotation
module load prodigal
prodigal -i ../assembly/ERR029206.fasta -a ERR029206.faa > ERR029206.gbk
```

::::::::::::

::::::::::::

Examine the resulting files, both the `.faa` and the `.gbk`. Can you make sense of the information there? 

### Functional annotation

The physical annotation provided by prodigal identifies genes (ORFs and start codons), but it does not give any information about the function of the genes identified. The next step is thus to infer a function for each of the identified genes. This process usually involves aligning the proteins to different databases, e.g. using BLAST and other programs. You will not perform a full functional annotation in this exercise, but you will try to use blastp to find a RpoB (RNA polymerase B) homolog in the genome.

::: challenge

## Create a BLAST database

With the proteome (`.faa` file) of sample ERR029206, create a BLAST database, of protein type. Use the `makeblastdb` function that comes with the BLAST package. 

::: hint

```bash
module load blast
makeblastdb -h
```

::::::::::::


::: solution

```bash
module load blast
makeblastdb <database type, protein> -in <proteome file> -out <accession>
```

::::::::::::

::: instructor

```bash
module load blast
makeblastdb -dbtype prot -in ERR029206.faa -out ERR029206
```

::::::::::::

## Find rpoB homologs

Now that you made the database, use the RpoB sequence from *E. coli* that you retrieved in the BLAST exercise to find whether there are one or several RpoB homologs in the proteome you just annotated. Examine the BLAST results: how many homologs to RpoB in that genome?

::: solution

```bash
ls ../../../blast/
blastp -query <fasta file> -db accession
```

Just one has E-values at the right level.

:::::::::::::

::: instructor

```bash
blastp -query ../../../blast/rpoB_ecoli.fasta -db ERR029206
```

:::::::::::::


:::::::::::::

:::::::::::::::::::::::::::::::::::::::: keypoints

- Assembly is a process which aligns and merges fragments from a longer DNA sequence in order to reconstruct the original sequence.
- k-mers are short fragments of DNA of length k

::::::::::::::::::::::::::::::::::::::::::::::::::

