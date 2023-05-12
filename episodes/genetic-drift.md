---
title: 'Genetic drift'
teaching: 2
exercises: 10
---

:::::::::::::::::::::::::::::::::::::: questions 

- How does random genetic drift influence fixation of alleles?
- What is the influence of population size?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Understand how population size influences the probability of fixation of an
allele.
- Understand how slightly deleterious mutations may get fixed in small 
populations.

::::::::::::::::::::::::::::::::::::::::::::::::

## Introduction

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

## Genetic Drift without selection

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

## Genetic Drift with selection

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

## Fixation of slightly deleterious alleles in very small populations

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
