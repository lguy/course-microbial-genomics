---
title: 'Phylogenetics'
teaching: 0
exercises: 240
---

:::::::::::::::::::::::::::::::::::::: questions 

- How do you build a simple, distance-based phylogenetic tree?
- How do you build a phylogenetic tree with more advanced methods?
- How do you ascertain statistical support for phylogenetic trees?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Learn the basic of phylogenetics tree building, taking the simplest of the examples with a UPGMA tree.
- Learn how to use phylogenetics algorithms, neighbor-joining and maximum-likelihood.
- Learn how to perform and show bootstraps.

::::::::::::::::::::::::::::::::::::::::::::::::

## Exercise 1: Paper-and-pen phylogenetic tree

### Setup

The exercise is done for a large part with pen and paper, and then a 
demonstration in R. We'll also use the R package 
[`ape`](https://emmanuelparadis.github.io/) , which you should
install if it's not present on your setup:

```r
install.packages('ape')
```

And to load it:


```r
library(ape)
```

### UPGMA-based tree

Load the tree in fasta format, reading from a `temp` file

```r
FASTAfile <- tempfile("aln", fileext = ".fasta")
cat(">A", "----ATCCGCTGATCGGCTG----",
    ">B", "GCTGATCCGTTGATCGG-------",
    ">C", "----ATCTGCTCATCGGCT-----",
    ">D", "----ATTCGCTGAACTGCTGGCTG",
    file = FASTAfile, sep = "\n")
aln <- read.dna(FASTAfile, format = "fasta")
```
Now look at the alignment. Notice there are gaps, which we don't want in 
this example. We also remove the non-informative (identical) columns. 


```r
alview(aln)
```

```{.output}
  000000000111111111122222
  123456789012345678901234
A ----ATCCGCTGATCGGCTG----
B GCTG.....T.......---....
C .......T...C.......-....
D ......T......A.T....GCTG
```

```r
aln_filtered <- aln[,c(7,8,10,12,14,16)]
alview(aln_filtered)
```

```{.output}
  123456
A CCCGTG
B ..T...
C .T.C..
D T...AT
```
Now we have a simple alignment as in the lecture. Dots (`.`) mean that the
sequence is identical to the top row, which makes it easier to calculate 
distances.

::::::::::::::::::::::::::::::::::::: challenge 

### Calculating distance "by hand"

Let's use a matrix to calculate distances between sequences. We'll just count
the number of differences between the sequences. We'll then group the two 
closest sequences. Which are they?

Table: Distances between the sequences.

|   | A  | B  | C  | D  |
| - | -: | -: | -: | -: |
| A |    |    |    |    |
| B |    |    |    |    |
| C |    |    |    |    |
| D |    |    |    |    |

:::::::::::::::::::::::: solution 

Here is the solution:

Table: Distances between the sequences.

|   | A  | B  | C  | D  |
| - | -: | -: | -: | -: |
| A |    |    |    |    |
| B |  1 |    |    |    |
| C |  2 | 3  |    |    |
| D |  3 | 4  | 5  |    |

The two closest sequences are A and B.

:::::::::::::::::::::::::::::::::

Let's now cluster together A and B, and calculate the average distance 
from AB to the other sequences, weighted by the size of the clusters. 

Table: Recalculated distances.

|    | AB  | C  | D  |
| -  | -:  | -: | -: |
| AB |     |    |    |
| C  |     |    |    |
| D  |     |    |    |

:::::::::::::::::::::::: solution 

The average distance for AB to C is calculated as follow:

$d(AB,C) = \dfrac{d(A,C) + d(B,C)}{2} = \dfrac{2 + 3}{2} = 2.5$

And so on for the other distances:

Table: Recalculated distances.

|    | AB  | C  | D  |
| -  | -:  | -: | -: |
| AB |     |    |    |
| C  | 2.5 |    |    |
| D  | 3.5 |  5 |    |

:::::::::::::::::::::::::::::::::

Now the shortest distance is AB to C. Let's recalculate the distance to D again.

Table: Recalculated distances.

|    | ABC | D  |
| -  | -:  | -: |
| ABC|     |    |
| D  |     |    |

:::::::::::::::::::::::: solution 

$d(ABC,D) = \dfrac{d(AB,D) * 2 + d(C,D) * 1}{2 + 1} = \dfrac{3.5 * 2 + 5 * 1}{3} = 4$

Table: Recalculated distances.

|    | ABC | D  |
| -  | -:  | -: |
| ABC|     |    |
| D  | 4   |    |

:::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::

The tree is reconstructed by dividing the distances equally between the two
leaves. 
- A-B: each 0.5.
- AB-C: each side gets 2.5/2 = 1.25. The branch to AB is 1.25 - 0.75 = 0.75
- ABC-D: each side gets 4/2 = 2. The branch to ABC is 2 - 0.75 - 0.5 = 0.75

![UPGMA tree](fig/upgma_manual.png){alt='Manually built UPGMA tree'}


Let's know do the same using bioinformatics tools. 

::::::::::::::::::::::::::::::::::::: challenge 

We'll use `dist.dna` to 
calculate the distances. We'll use a "N" model, that just counts the differences
and doesn't correct or normalizes. We'll use the function `hclust` to perform
the UPGMA method calculation. The tree is then plotted, and the branch 
lengths plotted with `edgelabels`:

:::::::::::::::::::::::: solution 



```r
dist_matrix <- dist.dna(aln_filtered, model="N")
dist_matrix
```

```{.output}
  A B C
B 1    
C 2 3  
D 3 4 5
```

```r
tree <- as.phylo(hclust(dist_matrix, "average"))
plot(tree)
edgelabels(tree$edge.length)
```

<img src="fig/phylogenetics-rendered-unnamed-chunk-4-1.png" style="display: block; margin: auto;" />

:::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::

## Exercise 2: maximum-likelihood tree

### Introduction

In the previous episode, we inferred a simple phylogenetic tree using UPGMA, without correcting the distance matrix for multiple substitutions. UPGMA has many shortcomings, and gets worse as distance increases. Here we'll test Neighbor-Joining, which is also a distance-based, and a maximum-likelihood based approach with [IQ-TREE](http://www.iqtree.org/).

### Neighbor-joining

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

### Maximum likelihood

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

### Bootstraps

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


- The simplest of the trees are distance-based.
- UPGMA works by clustering the two closest leaves and recalculating the distance matrix.
- Neighbor-joining is distance-based and fast, but not necessarily very accurate
- Maximum-likelihood is slower, but more accurate

::::::::::::::::::::::::::::::::::::::::::::::::

## Exercise 3: Genetic drift

As a practical way to understand genetic drift, let's play with population size, selection coefficients, number of generations, etc.

:::::::::::::::::::::::::::::::::::::: questions 

- How does random genetic drift influence fixation of alleles?
- What is the influence of population size?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Understand how population size influences the probability of fixation of an allele.
- Understand how slightly deleterious mutations may get fixed in small populations.

::::::::::::::::::::::::::::::::::::::::::::::::

### Introduction

This exercise is to illustrate the concepts of selection, population size and
genetic drift, using simulations. We will use mostly 
[Red Lynx] by 
[Reed A. Cartwright](https://github.com/reedacartwright). 

Another option is to
use a [web interface](https://phytools.shinyapps.io/drift-selection/) to the [R]
[learnPopGen](https://github.com/liamrevell/learnPopGen) package, but the last
one is mostly for biallelic genes (and thus not that relevant for bacteria).

Open now the [Red Lynx] website and get familiar with the different options. 

You won't need the right panel (but feel free to explore). The dominance option
in the left panel won't be used either. 


::::::::::::::::::::::::::::::::::::: challenge 

### Genetic Drift without selection

In the first part, you will only play with the number of generations, the
initial frequency and the population size. 

- Lower the number of generations to 200. 
- Adjust the population size to 1000.
- Make sure the intial frequency is set to 50%.
- Run a few simulations (ca 20).

Did any allele got fixed? What is the range of frequencies after 200 generations?

:::::::::::::::::::::::: solution 

In my simulations, no allele got fixed, the final allele frequencies range 
20-80%

:::::::::::::::::::::::::::::::::

Now increase the population to 100'000, clear the graph, and repeat the 
simulations. What's the range of final frequencies now?

:::::::::::::::::::::::: solution 

In my simulations, no allele got fixed, and the final allele frequencies range
45-55%

:::::::::::::::::::::::::::::::::

Now decrease the population to 10 individuals, clear the graph and repeat
these simulations. What's the range of final frequencies now?

:::::::::::::::::::::::: solution 

In my simulations, one allele got fixed quickly, the latest one was at
generation 100.

:::::::::::::::::::::::::::::::::

What do you conclude here?

:::::::::::::::::::::::: solution 

It is clear that stochastic (random) variation in allele frequencies 
strongly affects the probability of fixation of alleles in small populations,
not so much in large ones.

:::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: challenge 

### Genetic Drift with selection

So far we've only looked at how allele frequencies vary in the absence of 
selection, that is when the two alleles provide an equal fitness. What's the
influence of random genetic drift when alleles are not neutral?

The selection strength is equivalent to the selection coefficient, i.e.
how much higher relative fitness the new allele provides. A selection 
coefficient of 0.01 means that the organism harboring the new allele has a 
1% increased fitness.

- Increase the number of generations to 1000.
- Set the selection strength to 0.01 (1%).
- Set the population size first to 100'000, then to 1000, then to 100.

How long does it take for the allele to get fixed - in average - with
the three population sizes?

:::::::::::::::::::::::: solution 

About the same time, but the trajectories are much smoother with larger
populations. In the small population, it happens that the beneficial allele
disappears from the population (although not often).

:::::::::::::::::::::::::::::::::

### Fixation of slightly deleterious alleles in very small populations

We're now simulating what would happen in a very small population (or a 
population that undergoes very narrow bottlenecks), when a gene mutates. We'll
have a very small population (10 individuals), a selection value of -0.01 
(the mutated allele provides a 1% lower fitness), and a 10% initial frequency, 
which corresponds to one individual getting a mutation:

- Set the population to 10 individuals.
- Set generations to 200.
- Set initial frequency to 10%.
- Set the selection strength to -0.01.

Run many simulations. What happens?

:::::::::::::::::::::::: solution 

Most new alleles go extinct quickly. In my simulations, I usually get one
of the slightly deleterious mutations fixed after 20 simulations.

:::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::

That's it for that part, but feel free to continue playing with the different 
settings later.

::::::::::::::::::::::::::::::::::::: keypoints 

- Random genetic drift has a large influence on the probability of fixation of
alleles in small populations, even for non-neutral alleles.
- Random genetic drift has very little influence of the probability of fixation of
alleles in large populations.
- Slightly deleterious mutations can get fixed into the population through
random genetic drift, if the population is small enough and the selective value
is not too large.

::::::::::::::::::::::::::::::::::::::::::::::::


<!-- References -->

[Red Lynx]: https://cartwrig.ht/apps/redlynx/

