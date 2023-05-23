---
title: 'Phylogenetics - Others'
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- How do you build a phylogenetic tree with more advanced methods?
- How do you ascertain statistical support for phylogenetic trees?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Learn how to use phylogenetics algorithms, neighbor-joining and maximum-likelihood.
- Learn how to perform and show bootstraps.

::::::::::::::::::::::::::::::::::::::::::::::::

## Introduction

In the previous episode, we inferred a simple phylogenetic tree using UPGMA, without correcting the distance matrix for multiple substitutions. UPGMA has many shortcomings, and gets worse as distance increases. Here we'll test Neighbor-Joining, which is also a distance-based, and a maximum-likelihood based approach with [IQ-TREE](http://www.iqtree.org/).

## Neighbor-joining

The principle of [Neighbor-joining method](https://en.wikipedia.org/wiki/Neighbor_joining) (NJ) is to start from a star-like tree, find the two branches that, if joined, minimize the total tree length, join then, and repeat with the joined branches and the rest of the branches.

::::::::::::::::::::::::::::::::::::: challenge 

To perform NJ on our sequences, we'll use the function inbuilt in Seaview. First (re-)open the alignment we obtained from `mafft` with the E-INS-i method. 

:::::::::::::::::::::::: solution 

```bash
seaview rpoB.einsi.aln &
```

:::::::::::::::::::::::::::::::::

In the Seaview window, select Trees -> Distance methods. Keep the BioNJ option ticked. BioNJ is an updated version of NJ, more accurate for longer distances. Tick the "Bootstrap" option and leave it at 100. We'll discuss these later. Then click on "Go".

::::::::::::::::::::::::::::::::::::::::::::::::

What do you see? Is the tree rooted? Is the pattern species coherent with what you know of the tree of life? Any weird results?

::::::::::::::::::::::::::::::::::::: challenge 

Redo the BioNJ tree for the other alignment we inferred.

:::::::::::::::::::::::: solution 

```bash
seaview rpoB.fftns.aln &
```

:::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::

Do you see any differences between the two trees? What can you make out of it?

## Maximum likelihood

We will now use IQ-TREE to infer a maximum-likelihood tree of the RpoB dataset we aligned with `mafft` previously. 

```bash
$ iqtree -s rpoB.einsi.aln -m TEST -B 1000
```

Here, we tell IQ-TREE to use the alignment `rpoB.einsi.aln`, and to test among the standard substitution models which one fits best (`-m TEST`). We also tell IQ-TREE to perform 1000 ultra-fast bootstraps (`-B 1000`). We'll discuss these later.

IQ-TREE is a very complete program that can do a large variety of phylogenetic analysis. To get a flavor of what it's capable of, look at its [extensive documentation](http://www.iqtree.org/doc/). 

Have a look at the output files:

```bash
ls rpoB.einsi.aln.*
```

```output
rpoB.einsi.aln.bionj      rpoB.einsi.aln.iqtree     rpoB.einsi.aln.model.gz
rpoB.einsi.aln.ckp.gz     rpoB.einsi.aln.log        rpoB.einsi.aln.splits.nex
rpoB.einsi.aln.contree    rpoB.einsi.aln.mldist     rpoB.einsi.aln.treefile
```

There are two important files:  
* `*.iqtree` file provides a text summary of the analysis. 
* `*.treefile` is the resulting tree in [Newick format](https://en.wikipedia.org/wiki/Newick_format). 

Now display the resulting tree in FigTree. 

```bash
$ figtree rpoB.einsi.aln.treefile &
```

A window will pop-up and ask to provide a name for branch/node labels. Use e.g. 'bootstraps'.

The tree appears as unrooted. It is good practice to start by ordering the nodes and root it. Since we don't really know otherwise where the root is, we'll do a mid-point rooting to start with.

In the left menu, develop the 'Trees' menu. Tick the 'Root tree' and select 'Midpoint' from the drop-down menu. Tick the 'Order nodes' box and keep the 'increasing' option selected. 

Scrutinize the tree. Is it different from the BioNJ tree generated in Seaview? How?


::::::::::::::::::::::::::::::::::::: challenge 

Redo a ML tree from the other alignment (FFT-NS) we inferred with `mafft` and display the resulting tree in FigTree

:::::::::::::::::::::::: solution 

```bash
$ iqtree -s rpoB.fftns.aln -m TEST -B 1000
$ figtree rpoB.fftns.aln.treefile &
```

:::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::

## Bootstraps

We have inferred four trees:
* Two based on the alignment generated from the E-INS-i algorithm, two from the FFT-NS.
* Two inferred with the BioNJ algorithm and two with the ML algorithm (IQ-Tree)

Along the way, we've generated bootstraps for all our trees. Now show them on all four trees.
* For the Seaview trees, tick the 'Br support' box
* For the trees shown in FigTree, develop the 'Branch labels' menu, tick the corresponding box and select 'bootstraps' from the 'Display' drop-down menu.

::::::::::::::::::::::::::::::::::::: challenge 

Compare all four trees. Do you find any significant differences? 

Hint: what are *Glycine* and *Arabidopsis*? What about *Synechocystis* and *Microcystis*?

Hint: search for the accession number of the *Glycine* RpoB sequence on [NCBI](https://www.ncbi.nlm.nih.gov/search/). Any hint there?

:::::::::::::::::::::::: solution 

The two plant RpoB sequences are from chloroplastic genomes, and thus branch together with the cyanobacterial sequences, in some of the phylogenies at least. 

:::::::::::::::::::::::::::::::::

What about the support values for grouping these two groups? How high are they?

::::::::::::::::::::::::::::::::::::::::::::::::


::::::::::::::::::::::::::::::::::::: keypoints 

- Neighbor-joining is distance-based and fast, but not necessarily very accurate
- Maximum-likelihood is slower, but more accurate

::::::::::::::::::::::::::::::::::::::::::::::::

