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

We will now use IQ-TREE to 

```bash
$ iqtree -s rpoB.einsi.aln -m TEST -B 1000
```

::::::::::::::::::::::::::::::::::::: keypoints 

- Neighbor-joining is distance-based and fast, but not necessarily very accurate
- Maximum-likelihood is slower, but more accurate

::::::::::::::::::::::::::::::::::::::::::::::::

