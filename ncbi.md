---
title: 'NCBI'
teaching: 0
exercises: 240
---

:::::::::::::::::::::::::::::::::::::: questions 

- How do you efficiently and reliably navigate NCBI's website?

::::::::::::::::::::::::::::::::::::::::::::::::

## Exercise 1: Global Cross-database NCBI Search

::::::::::::::::::::::::::::::::::::: objectives

- Familiarize yourself with the NCBI databases
- Browse and search the databases
- Understand sequences
- Retrieve sequence meta-information
- Cross-link sequences and publications
- Understand the differences between Gene/Protein/Nucleotide databases

::::::::::::::::::::::::::::::::::::::::::::::::

This part is to encourage you to explore NCBI resources. Questions are examples or real-life questions that you might ask yourself later. There are not necessarily exactly one solution to the question. 
Start by going to NCBI's web site, main search page: https://www.ncbi.nlm.nih.gov/search/. There, you have the list of most of NCBI’s databases, sorted by category. Take some time to explore the following sections: Literature, Genomes, Genes and Proteins.

### Task 1.1: Find publications (this is a warm up!)

You want to find the following articles: 

1. an article about Escherichia coli O104:H4 published by Matthew K Waldor in the New England Journal of Medicine; and 
1. a paper about E. coli whose last author is L. Wang, published in PLoS ONE in 2014. 

NOTE: you do not know the exact title, list of authors, PMID etc. Use your search skills (solution provided below). There may be more than one result.

::::::::::::::::::::::::::::::::::::: challenge 

## Challenge 1.1.1

Find the two articles above using NCBI's literature database.

:::::::::::::::::::::::: hint

Use the advanced search from PubMed, by clicking on “Advanced” (tutorial https://www.ncbi.nlm.nih.gov/books/NBK3827/#pubmedhelp.PubMed_Quick_Start), to build an exact search. Use the different fields to build a search that returns only a single match.

:::::::::::::::::::::::::::::

:::::::::::::::::::::::: solution 

1. Rasko DA, Webster DR, […], Waldor MK. Origins of the E. coli strain causing an outbreak of hemolytic-uremic syndrome in Germany. N Engl J Med. 2011 Aug 25;365(8):709-17. doi: 10.1056/NEJMoa1106920. Epub 2011 Jul 27.
1. Zhang X, Li Y, Liu B, Wang J, Feng C, Gao M, Wang L. Prevalence of veterinary antibiotics and antibiotic-resistant Escherichia coli in the surface water of a livestock production region in northern China. PLoS One. 2014 Nov 5;9(11):e111026. doi: 10.1371/journal.pone.0111026. eCollection 2014.

:::::::::::::::::::::::::::::::::

## Challenge 1.1.2

Now try to find the most recent paper citing the first article by Rasko et al above. NCBI provides the “Cited by” link (right menu), but you can also use 

- Google Scholar (https://scholar.google.com) or 
- Web of Knowledge (https://www.webofknowledge.com; Access from UU: https://www.ub.uu.se/ > Databases A-Z > W > Web of Science Core Collection). The language settings of Google Scholar can be adjusted in the menu under Settings.

Then: 

- How did the two search engines compare? 
- Which one was easier to work with dates? 
- Which one returned most results? 
- Which one has more complete information?

::::::::::::::::::::::::::::::::::::::::::::::::

### Task 1.2: Find Gene records

You want to find sequences for the subunit A of the Shiga toxin in E. coli O157:H7 Sakai. Try to search in the three following databases: Gene, Nucleotide and Protein. 

:::::: challenge

## Challenge 1.2.1

What do the three different databases contain? What information do you get from them? 

::: hint

If you get too many hits, go to the field “Search details”, and refine your search, using the [Organism] field, for example. You don’t need to get exactly one hit or to get the result you want on top. By default, the search will include everything that has the species name anywhere in the record.

::::::::

## Challenge 1.2.2

What do the five top results from the Protein database show?

::::::::::::::::

### Task 1.3: Understand Gene records

Click on a Gene search result from Task 1.2 and skim through the entire page. 

:::::: challenge

## Challenge 1.3.1 

Who published the sequence? When? Is there a paper? 

::::::::::::::::

:::::: challenge

## Challenge 1.3.2 

What is known about the gene? Does the record include taxonomy information? 

::::::::::::::::

Click on the Organism link and go to the Taxonomy Browser. 

:::::: challenge

## Challenge 1.3.3 

What can you learn about species taxonomy there? What other useful information is given on this page?

::::::::::::::::

Back to the Gene page, have a look at the “Related information” section in the right column. 

:::::: challenge

## Challenge 1.3.4 

Where can you go from there? 

::: hint

All the information in that section ("Related information") is coming through the Entrez system. In the `FASTA` record, look for `\dbxref` (database cross-reference) which provides the Entrez links.

::::::::

::::::::::::::::

### Task 1.4: Understanding Protein records and sequences

Click on the Protein link for this gene. Look at the content of one of the records. 

:::::: challenge

## Challenge 1.4.1 

What can you learn here? What information do you find here? What is the name of this format? Are there any known protein domains in this protein? Can you identify a link to these? 


::: hint

You can change the format by clicking on the top left corner.
Look for "Related information" in the right menu.

::::::::

::::::::::::::::

:::::: challenge

## Challenge 1.4.2 

Can you find just the sequence information in FASTA format? How is the format organized? What is included in the header? Discuss the advantages of the two formats. Can you find a definition of both formats on the NCBI website or elsewhere?

::: solution

If you are stuck, here is the link to

- one Gene record: https://www.ncbi.nlm.nih.gov/gene/916678 
- one Protein record: https://www.ncbi.nlm.nih.gov/protein/NP_311001.1 

::::::::::::

::::::::::::::::

:::::: challenge

## Challenge 1.4.3 

Can you find a 3D protein structure for this protein? 

::::::::::::::::

:::::: challenge

## Challenge 1.4.4 

Can you display the genome record on which this gene is encoded?

::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- NCBI website is very, very comprehensive
- The Entrez cross-referencing system helps retrieving links bits of data of different type.

::::::::::::::::::::::::::::::::::::::::::::::::

