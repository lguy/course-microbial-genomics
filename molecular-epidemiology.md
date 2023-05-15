---
title: 'Molecular Epidemiology'
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- How do you use genomics and phylogenetics to trace a microbial outbreak?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Trace an outbreak of Mycobacterium, from reads to phylogenetic tree.

::::::::::::::::::::::::::::::::::::::::::::::::

## Introduction

This part of the course is largely inspired from[another tutorial](https://github.com/aschuerch/MolecularEpidemiology_AnalysisWGS) developed by [Anita Schürch](https://aschuerch.github.io/). We will redo (part of) the analysis done in the paper described. 


## Background of the data

Epidemiological contact tracing through interviewing of patients can identify potential chains of patients that transmitted an infectious disease to each other. Contact tracing was performed following the [stone-in-the-pond principle](https://www.ncbi.nlm.nih.gov/pubmed/1643300), which  interviews and tests potential contacts in concentric circles around a potential source case.

Tuberculosis (TB) is an infectious disease caused by *Mycobacterium tuberculosis*. It mostly affects the lungs. An infection with *M. tuberculosis* is often asymptomatic (latent infection). Only in about 10% of the cases the latent infection progresses to an active infection during a patients lifetime, which, if untreated, leads to death in about half of the cases. The symptoms of an active TB infection include cough, fever, night sweats, weight loss etc. An active TB infection can spread. Once exposed, people often have latent TB. To identify people with latent TB, a [skin test](https://www.cdc.gov/tb/publications/factsheets/testing/skintesting.htm) can be applied.

Here we have 7 tuberculosis patients with active TB, that form three separate clusters of potential transmission as determined by epidemiological interviews. Patients were asked if they have been in direct contact with each other, or if they visited the same localities. From all patients, a bacterial isolate was grown, DNA isolated, and whole-genome sequenced on an Illumina sequencer.

The three clusters consist of:

Cluster 1

```
- Patient A1 (2011) - sample ERR029207
- Patient A2 (2011) - sample ERR029206
- Patient A3 (2008) - sample ERR026478
```

Cluster 2

```
- Patient B1 (2001) - sample ERR026474
- Patient B2 (2012) - sample ERR026473
```

Cluster 3

```
- Patient C1 (2011) - sample ERR026481
- Patient C2 (2016) - sample ERR026482
```

The second goal of this practicum is to affirm or dispute the inferred transmissions by comparing the bacterial genomes with each other. We will do that by identifying SNPs between the genomes. If time allows a different strategy can be employed as well: identifying variably present genes.



:::::::::::::::::::::::::::::::::::::::: keypoints

- We will work towards confirming or disputing transmission in TB cases
- After this practical training you will have some familiarity with working on the command line

::::::::::::::::::::::::::::::::::::::::::::::::::

