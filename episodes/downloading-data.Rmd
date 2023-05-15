---
title: 'Downloading data'
teaching: 10
exercises: 50
---

This episode describes how to retrieve all necessary data from public repositories - the raw sequenced data of our isolates and a reference genome. It also introduces for loops which we will use for the rest of our analysis.

::::::::::::::::::::::::::::::::::::::: objectives

- Create a file system for a bioinformatics project.
- Download files necessary for further analysis.
- Use 'for' loops to automate operations on multiple files

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How can I organize my file system for a new bioinformatics project?
- How and where can data be downloaded?

::::::::::::::::::::::::::::::::::::::::::::::::::


## Getting your project started

Project organization is one of the most important parts of a sequencing project, and yet is often overlooked amidst the
excitement of getting a first look at new data. Of course, while it's best to get yourself organized before you even begin your analyses,it's never too late to start, either.

Genomics projects can quickly accumulate hundreds of files across tens of folders. Every computational analysis you perform over the course of your project is going to create many files, which can especially become a problem when you'll inevitably want to run some of those analyses again. For instance, you might have made significant headway into your project, but then have to remember the PCR conditions you used to create your sequencing library months prior.

Other questions might arise along the way:

- What were your best alignment results?
- Which folder were they in: Analysis1, AnalysisRedone, or AnalysisRedone2?
- Which quality cutoff did you use?
- What version of a given program did you implement your analysis in?

In this exercise we will setup a file system for the project we will be working on during this workshop.

We will start by creating a directory that we can use for the rest of the workshop. First navigate to your home directory. Then confirm that you are in the correct directory using the `pwd` command.

```bash
$ cd
$ pwd
```

You should see the output:

```output
/home/chewbe
```

:::::::::::::::::::::::::::::::::::::::::  callout

## Tip

If you aren't in your home directory, the easiest way to get there is to enter the command `cd`, which
always returns you to home.  


::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::  challenge

## Exercise

Use the `mkdir` command to make the following directories:  
dc\_workshop  
dc\_workshop/docs  
dc\_workshop/data  
dc\_workshop/results

:::::::::::::::  solution

## Solution

```bash
$ mkdir molepi
$ mkdir molepi/docs
$ mkdir molepi/data
$ mkdir molepi/results
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

Use `ls -R` to verify that you have created these directories. The `-R` option for `ls` stands for recursive. This option causes
`ls` to return the contents of each subdirectory within the directory
iteratively.

```bash
$ ls -R molepi
```

You should see the following output:

```output
molepi/:
data  docs  results

molepi/data:

molepi/docs:

molepi/results: 
```

## Selection of a reference genome

Reference sequences (including many pathogen genomes) are available at [NCBI's refseq database](https://www.ncbi.nlm.nih.gov/refseq/)

A reference genome is a genome that was previously sequenced and is closely related to the isolates we would like to analyse. The selection of a closely related reference genome is not trivial and will warrant an analysis in itself. However, for simplicity, here we will work with the *M. tuberculosis* reference genome H37Rv.

### Download reference genomes from NCBI

Download the *M.tuberculosis* reference genome from the NCBI ftp site.

First, we switch to the data folder to store all our data

```source
$ cd molepi/data 
```

The reference genome will be downloaded programmatically from NCBI with `wget`. `wget` is a computer program that retrieves content from web servers.  Its name derives from World Wide Web and get.

```source
$ wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/195/955/GCF_000195955.2_ASM19595v2/GCF_000195955.2_ASM19595v2_genomic.fna.gz
```

This file is compressed as indicated by the extension of `.gz`. It means that this file has been compressed using the `gzip` command.

Extract the file by typing

```source
$ gunzip GCF_000195955.2_ASM19595v2_genomic.fna.gz
```

Make sure that is was extracted

```source
$ ls
```

```output
GCF_000195955.2_ASM19595v2_genomic.fna
```

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge: What is the size of the genome?

Find out how many basepairs the genome has. Hints:

```
assembly-stats
```

Get assembly statistics from FASTA and FASTQ files.

:::::::::::::::  solution

## Solution

The genome has 4'411'532 bp.

```bash
$ assembly-stats GCF_000195955.2_ASM19595v2_genomic.fna
```

```output

stats for GCF_000195955.2_ASM19595v2_genomic.fna
sum = 4411532, n = 1, ave = 4411532.00, largest = 4411532
N50 = 4411532, n = 1
N60 = 4411532, n = 1
N70 = 4411532, n = 1
N80 = 4411532, n = 1
N90 = 4411532, n = 1
N100 = 4411532, n = 1
N_count = 0
Gaps = 0

```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::


## Loops

*Loops* are key to productivity improvements through automation as they allow us to execute commands repeatedly. Similar to wildcards and tab completion, using loops also reduces the amount of typing (and typing mistakes). Our next task is to download our [data](../episodes/molecular-epidemiology.Rmd) from the short read archive [(SRA) at the European Nucleotide Archive (ENA)](https://www.ebi.ac.uk/ena). There are many repositories for public data. Some model organisms or fields have specific databases, and there are ones for particular types of data. Two of the most comprehensive are the National Center for Biotechnology Information (NCBI) and European Nucleotide Archive (EMBL-EBI). In this lesson we're working with the ENA, but the general process is the same for any database.

We can do this one by one but given that each download takes about one to two hours, this could keep us up all night. Instead of downloading one by one we can apply a loop. Let's see what that looks like and then we'll discuss what we're doing with each line of our loop.

```bash
$ for filename in ERR01 ERR02 ERR03
> do
> echo ftp://ftp.sra.ebi.ac.uk/"${filename}".fastq.gz
> done
```

When the shell sees the keyword `for`,
it knows to repeat a command (or group of commands) once for each item in a list.
Each time the loop runs (called an iteration), an item in the list is assigned in sequence to
the **variable**, and the commands inside the loop are executed, before moving on to
the next item in the list.

Inside the loop,
we call for the variable's value by putting `$` in front of it.
The `$` tells the shell interpreter to treat
the **variable** as a variable name and substitute its value in its place,
rather than treat it as text or an external command.

In this example, the list is seven filenames/
Each time the loop iterates, it will assign a file name to the variable `filename`
and run the `wget` command.
The first time through the loop,
`$filename` is `ERR01.fastq.gz`.
The interpreter runs the command `wget` on `ERR01.fastq.gz` at the server [ftp://ftp.sra.ebi.ac.uk/](ftp://ftp.sra.ebi.ac.uk/)
For the second iteration, `$filename` becomes
`ERR02.fastq.gz`. This time, the shell runs `wget` on `ERR02.fastq.gz`.

Use {} to wrap the variable so that .fastq.gz will not be interpreted as part of the variable name. In addition, quoting the shell variables is a good practice AND necessary if your variables have spaces in them.

For more, check [Bash Pitfalls](https://mywiki.wooledge.org/BashPitfalls)

:::::::::::::::::::::::::::::::::::::::::  callout

## Follow the Prompt

The shell prompt changes from `$` to `>` and back again as we were
typing in our loop. The second prompt, `>`, is different to remind
us that we haven't finished typing a complete command yet. A semicolon, `;`,
can be used to separate two commands written on a single line.


::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::  callout

## Same Symbols, Different Meanings

Here we see `>` being used a shell prompt, whereas `>` is also
used to redirect output.
Similarly, `$` is used as a shell prompt, but, as we saw earlier,
it is also used to ask the shell to get the value of a variable.

If the *shell* prints `>` or `$` then it expects you to type something,
and the symbol is a prompt.

If *you* type `>` or `$` yourself, it is an instruction from you that
the shell to redirect output or get the value of a variable.


::::::::::::::::::::::::::::::::::::::::::::::::::

We have called the variable in this loop `filename`
in order to make its purpose clearer to human readers.
The shell itself doesn't care what the variable is called;
if we wrote this loop as:

```bash
$ for x in ERR01 ERR02 ERR03
do
echo ftp://ftp.sra.ebi.ac.uk/"${x}".fastq.gz
done
```

or:

```bash
$ for temperature in ERR01 ERR02 ERR03
do
echo ftp://ftp.sra.ebi.ac.uk/"${temperature}".fastq.gz
done
```

it would work exactly the same way.
*Don't do this.*
Programs are only useful if people can understand them,
so meaningless names (like `x`) or misleading names (like `temperature`)
increase the odds that the program won't do what its readers think it does.

:::::::::::::::::::::::::::::::::::::::::  callout

## Multipart commands

The `for` loop is interpreted as a multipart command.  If you press the up arrow on your keyboard to recall the command, it may be shown like so (depends on your bash version):

```bash
$ for filename in ERR01 ERR02 ERR03; do echo ftp://ftp.sra.ebi.ac.uk/"${filename}".fastq.gz ; done
```

When you check your history later, it will help your remember what you did!

::::::::::::::::::::::::::::::::::::::::::::::::::

## Download the sequenced genomes from the European Nucleotide Archive (ENA)

To ensure that we complete this tutorial in time, we will not perform all operations on all genomes, only on one or two. The principles are - however - the same for two or seven (or, to some extent, 189) genomes. 

Let's download data for two *M. tuberculosis* genomes with a for loop

```bash
$ cd molepi/data
$ for files in ERR029/ERR029207 ERR029/ERR029206
do 
wget "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/"${files}"/*fastq.gz"
done
```

This will run over night. We will therefore detach the session to work further.

The command for downloading all data (*Don't do this.*) would be:

```bash
$ for files in ERR029/ERR029207 ERR029/ERR029206 ERR026/ERR026478 ERR026/ERR026474 ERR026/ERR026473 ERR026/ERR026481 ERR026/ERR026482
do 
# wget "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/"${files}"/*fastq.gz"
done
```

The main command (`wget`) is commented out (prefixed with `#`) to prevent unintentional use.

:::::::::::::::::::::::::::::::::::::::: keypoints

- `wget` is a computer program to get data from the internet
- `for` loops let you perform the same set of operations on multiple files with a single command
- Sequencing data is large

::::::::::::::::::::::::::::::::::::::::::::::::::
