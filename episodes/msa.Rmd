---
title: 'Multiple sequence alignment'
teaching: 10
exercises: 30
---

:::::::::::::::::::::::::::::::::::::: questions 

- How do you align multiple sequences?
- Why is it important to properly align sequences?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Use `mafft` to align multiple sequences.
- Test different algorithms.

::::::::::::::::::::::::::::::::::::::::::::::::

## Introduction

In this short episode, we are exploring multiple sequence alignment (MSA). We are going to use [`mafft`](https://mafft.cbrc.jp/alignment/software/algorithms/algorithms.html) to align homologs of [RpoB](https://en.wikipedia.org/wiki/RpoB), the β subunit of the bacterial RNA polymerase. It is a long, multi-domain protein, suitable for showing issues related to MSA. 

First, go to your home folder and create a phylogenetics folder

:::::::::::::::::::::::::::::::::::::::  challenge

## Exercise

Go to your home, use the `mkdir` command to make a `phylogenetics` subfolder, and move into it:  

:::::::::::::::  solution

## Solution

```bash
$ cd ~
$ mkdir phylogenetics

 
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

Second, download a [fasta file](episodes/files/rpoB.fasta) containing 19 sequences of RpoB, gathered by aligning RpoB from *E. coli* to a very small database present at NCBI, the [landmark](https://blast.ncbi.nlm.nih.gov/smartblast/smartBlast.cgi?CMD=Web&PAGE_TYPE=BlastDocs) database. Move that file to your newly created `~/phylogenetics/` folder.

## Renaming sequences

Look at the accession ids of the fasta sequences: they are not very informative: 

```bash
$ grep '>' rpoB.fasta | head -n 5
```

```output
>WP_000263098.1 MULTISPECIES: DNA-directed RNA polymerase subunit beta [Enterobacteriaceae]
>WP_011070610.1 DNA-directed RNA polymerase subunit beta [Shewanella oneidensis]
>WP_003114335.1 DNA-directed RNA polymerase subunit beta [Pseudomonas aeruginosa]
>WP_002228870.1 DNA-directed RNA polymerase subunit beta [Neisseria meningitidis]
>WP_003436174.1 MULTISPECIES: DNA-directed RNA polymerase subunit beta [Eubacteriales]
```

Keep the taxonomic name following the accession id, separated by `_`, using a bit of `sed` magic. Save the resulting file for later use, and show the headers again. 
```bash
$ sed "/^>/ s/>\([^ ]*\) \([^\[]*\)\[\(.*\)\]/>\\3_\\1/"  rpoB.fasta | sed "s/ /_/g" > rpoB_renamed.fasta
$ grep '>' rpoB_renamed.fasta | head -n 5
```

```output
>Enterobacteriaceae_WP_000263098.1
>Shewanella_oneidensis_WP_011070610.1
>Pseudomonas_aeruginosa_WP_003114335.1
>Neisseria_meningitidis_WP_002228870.1
>Eubacteriales_WP_003436174.1
```

It looks better.

## Alignment with progressive algorithm

Use `mafft` with a progressive algorithm to align the sequences. 

:::::::::::::::::::::::::::::::::::::::  challenge

Use the FFT-NS-2 algorithm from mafft to align the renamed sequences. Also, record the time it takes for `mafft` to complete the task. 

Hint: type `mafft` and try tab-complete to see all versions of `mafft`.

Hint: try the command `time` 

:::::::::::::::  solution

```bash
$ time mafft-fftns rpoB_renamed.fasta > rpoB.fftns.aln
```

```output
...
Strategy:
 FFT-NS-2 (Fast but rough)
 Progressive method (guide trees were built 2 times.)

If unsure which option to use, try 'mafft --auto input > output'.
For more information, see 'mafft --help', 'mafft --man' and the mafft page.

The default gap scoring scheme has been changed in version 7.110 (2013 Oct).
It tends to insert more gaps into gap-rich regions than previous versions.
To disable this change, add the --leavegappyregion option.

mafft-fftns rpoB_renamed.fasta > rpoB.fftns.aln  1.02s user 0.52s system 104% cpu 1.471 total
```

The last line is the output of the `time` command. It took 1.47 seconds to complete this time.

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

## Alignment with iterative algorithm

Now use one of the supposedly better iterative algorithm of `mafft` to align the same sequences. Choose the [E-INS-i algorithm](https://mafft.cbrc.jp/alignment/software/algorithms/algorithms.html) which is suited for proteins that have highly conserved motifs interspersed with less conserved ones. 

:::::::::::::::::::::::::::::::::::::::  challenge

Use the E-INS-i algorithm from mafft to align the renamed sequences. Also, record the time it takes for `mafft` to complete the task. 

:::::::::::::::  solution

```bash
$ time mafft-einsi rpoB_renamed.fasta > rpoB.einsi.aln
```

```output
...
Strategy:
 E-INS-i (Suitable for sequences with long unalignable regions, very slow)
 Iterative refinement method (<16) with LOCAL pairwise alignment with generalized affine gap costs (Altschul 1998)

If unsure which option to use, try 'mafft --auto input > output'.
For more information, see 'mafft --help', 'mafft --man' and the mafft page.

The default gap scoring scheme has been changed in version 7.110 (2013 Oct).
It tends to insert more gaps into gap-rich regions than previous versions.
To disable this change, add the --leavegappyregion option.

Parameters for the E-INS-i option have been changed in version 7.243 (2015 Jun).
To switch to the old parameters, use --oldgenafpair, instead of --genafpair.

mafft-einsi rpoB_renamed.fasta > rpoB.einsi.aln  6.84s user 0.65s system 99% cpu 7.542 total
```

It now took 7.54 seconds to complete this time, i.e. about 5 times slower than with the progressive algorithm. It doesn't make a big difference now, but with hundreds of sequences it will make one.

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

## Alignment visualization 

Compare the two 
