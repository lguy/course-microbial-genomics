---
title: 'Protein structure prediction'
teaching: 0
exercises: 120
---

::: questions
-   How can we predict a protein's 3D structure from its sequence?
-   How do we evaluate the confidence of predicted structures?
:::

::: objectives
-   Predict protein and protein complex structure using `AlphaFold`.
-   Interpret prediction confidence scores.
-   Visualize predicted structures.
-   Compare predicted structures to known structures.
:::

## Introduction

In this episode, we are going to explore protein structure prediction using [`AlphaFold`](https://www.nature.com/articles/s41586-021-03819-2), a deep learning model based tool developed by DeepMind. We will (1) predict the structure of protein and protein complex, (2) interpret the confidence of the predictions, (3) visualize the predicted structures, and (4) compare them to the known structures. Let's get started by setting up our environment for prediction on Pelle.

## Task 1: Predicting structure of a protein

We will use the `AlphaFold/3.0.1` module from Pelle for protein structure prediction. Before we can run the prediction, we need to prepare the input files and parameters for `AlphaFold3`. We will go through these steps in the following challenges.

:::::: challenge
## Challenge 1.1: prepare the terrain

First, using your username and password you need to login to Pelle. The course base folder is at `/proj/g2020004/nobackup/3MK013`. Go to your own folder, create a `protein-structure-exercise` subfolder, and move into it.

::: hint
Remember those commands?

``` bash
ssh -Y
cd
mkdir
ls
```
:::

::: solution
``` bash
ssh -Y <username>@pelle.uppmax.uu.se
```

Remember to replace `<basefolder>` and `<username>` accordingly.

``` bash
cd <basefolder>/<username>
mkdir protein-structure-exercise
cd protein-structure-exercise
```
:::

::: instructor
``` bash
ssh -Y <username>@pelle.uppmax.uu.se
```

``` bash
cd /proj/g2020004/nobackup/3MK013/<username>
mkdir protein-structure-exercise
cd protein-structure-exercise
```
:::
::::::

:::::: challenge
## Challenge 1.2: upload the AlphaFold3 parameters file

Probably you already have downloaded the AlphaFold3 models using this [link](https://forms.gle/svvpY4u2jsHEwWYS6). We will need these parameters to run the AlphaFold3 prediction on Pelle.

Let's create a `params` sub-directory under `protein-structure-exercise` directory to store the AlphaFold3 parameters file. Then we will upload the parameters file from the local machine into that `params` directory (on Pelle).

::: hint
Use `mkdir` command to create a new directory, and upload the file into the `params` directory using `scp` command.
:::

::: solution
``` bash
# create params directory on Pelle
mkdir <basefolder>/<username>/protein-structure-exercise/params 
# Open a new terminal on your local machine and use the following command to upload the parameters file to Pelle. Remember to replace `<path_to_parameters_file>` and `<username>` accordingly.
scp <path_to_parameters_file> <username>@pelle.uppmax.uu.se:<basefolder>/<username>/protein-structure-exercise/params
```
:::
::::::

:::::: challenge
## Challenge 1.3: prepare the input file

AlphaFold takes the amino acid (AA) sequence of a protein as input and predicts its 3D structure. For this task, we will use the AA sequence of Adenylate kinase from *Escherichia coli* (UniProt ID: [P69441](https://www.uniprot.org/uniprot/P69441)). You can download the sequence of Adenylate kinase using the following code:

``` bash
wget https://rest.uniprot.org/uniprotkb/P69441.fasta
```

This command will download a FASTA file containing the amino acid (AA) sequence of Adenylate kinase from UniProt Database. 

Q.1 Can you tell how many amino acids are in the sequence? You can use the `grep` command to count.

::: hint
The `grep -v ">"` command removes the header line, `tr -d '\n'` removes newlines, and `wc -c` counts the number of characters, which corresponds to the number of amino acids.
:::

::: solution
``` bash
grep -v ">" P69441.fasta | tr -d '\n' | wc -c
```
:::

You can check how `AlphaFold3` input files look like [here](https://github.com/google-deepmind/alphafold3/blob/main/docs/input.md). You can manually format the input file according to the specifications. But for this exercise, we will use a script that automates the process.

But first, we create a directory called `af3-input`:

::: hint
Use `mkdir` command to create a new directory.
:::

::: solution
``` bash
mkdir af3-input
```
:::

Now use the following command to prepare the input file for AlphaFold3:

``` bash
python3 <basefolder>/scripts/fasta_to_af3_json.py -i ./P69441.fasta -n P69441 -o ./af3-input/
```

This command will take the FASTA file as input and generate a JSON file that can be used as AlphaFold3 input. You can inspect the structure of the JSON file using the `cat` or `less` command.

``` bash
cat ./af3-input/P69441.json
```

Q.2 Can you explain why the P69441.json file has its version set to 1 ? Does it follow AlphaFold3 input specification?

::: hint
Check AlphaFold3 input file preparation instruction [here](https://github.com/google-deepmind/alphafold3/blob/main/docs/input.md)
:::

::: solution
Check the section about versions in the AlphaFold3 input file preparation instruction.
:::
::::::


:::::: challenge
## Challenge 1.4: run AlphaFold3 prediction

Now that we have the input file ready, we can run the `AlphaFold3` prediction.

First, we create output directory for storing the AF3 predicted results:

``` bash
mkdir af3-output
```

Now, we will load the `AlphaFold3` module, which allows us to run an already installed version AlphaFold3. Use the following command:

``` bash
module load AlphaFold/3.0.1
```

You should check whether the module is actually loaded by using the following command:

``` bash
module list
```

We will run AlphaFold3 using [slurm](https://docs.uppmax.uu.se/cluster_guides/slurm/). You can check the instructions. For this course, we will use a python script that generates a ready-to-use `slurm` shell script.

Run the following command:

``` bash
python3 <basefolder>/scripts/create_af3_slurm_job.py -p <Project-Code> -i ./af3-input/P69441.json -o ./af3-output -m ./params > job.sh
```

Now, we execute the slurm job as following using `sbatch` command:

``` bash
sbatch job.sh
```

This command runs the AlphaFold3 prediction using the input JSON file and saves the results in the `af3-output` directory. You can check the status of your job using the `squeue -u <username>` command.

Q.3 How long did the prediction take? 

::: hint
You can check the log file generated by the `slurm` job. Alternatively, you can use the `sacct` command.
:::

::: solution
The log file will have a name like `slurm-<job_id>.out`. Use `cat` or `less` command to check the contents of the log file. Alternatively, you can use the `sacct -j <job_id> --format=JobID,Elapsed` command to get a summary of the job's execution time.
:::

::::::


## Task 2: Interpret the confidence score of the predictions

Now that we have predicted the structure, we will evaluate how reliable it is.

In the output directory (`af3-output`), you will find several files. One with the suffix `_summary_confidences.json`, contains the confidence scores for the predicted structure. You can use the following command to view the contents of the confidence summary file:

``` bash
cat af3-output/p69441/p69441_summary_confidences.json 
```

The predicted template modeling (pTM) score and the interface predicted template modeling (ipTM) score are both derived from a measure called the template modeling (TM) score. This measures the accuracy of the entire structure. A pTM score above 0.5 means the overall predicted fold for the complex might be similar to the true structure. ipTM measures the accuracy of the predicted relative positions of the subunits within the complex. Values higher than 0.8 represent confident high-quality predictions, while values below 0.6 suggest likely a failed prediction. ipTM values between 0.6 and 0.8 are a gray zone where predictions could be correct or incorrect. [source](https://alphafoldserver.com/welcome).


:::::: challenge
## Challenge 2.1: checking prediction quality
Q.4 What are the pTM and ipTM scores for the predicted structure of Adenylate kinase? Does it indicate a good prediction?

::: hint
You can find the pTM and ipTM scores in the `_summary_confidences.json` file. Look for the keys `"pTM"` and `"ipTM"` in the JSON file.
:::

::: solution
First find the confidence scores using the command below:

```bash
cat af3-output/p69441/p69441_summary_confidences.json 
```

A pTM score above 0.5 suggests the overall fold is likely correct.  
High ipTM values (e.g. >0.8) indicate confident prediction of interactions.  
If your scores fall in these ranges, the prediction is likely reliable.
:::
::::::

## Task 3: Visualize the predicted structures

To visualize the predicted structure, you can use a molecular visualization tool such as [PyMOL](https://pymol.org/2/). In case you can not install these tools on your local machine, you can use the web-based tool [RCSB 3D View](https://www.rcsb.org/3d-view) to visualize the predicted structure. However, for this course we will use PyMOL and here is the installation instruction [link](https://pymol.org/dokuwiki/doku.php?id=installation).

To visualize the predicted structure using PyMOL, you can follow these steps:

Download the predicted structure file (with suffix `_model.cif`) from the `af3-output` directory to your local machine.

You can use the `scp` command to securely copy the file from the remote server to your local machine. Replace `<username>` with your actual username and `<local_path>` with the path where you want to save the file on your local machine.

``` bash
scp <username>@pelle.uppmax.uu.se:<basefolder>/<username>/protein-structure-exercise/af3-output/p69441/p69441_model.cif <local_path>
```

Open PyMOL software on your local machine. PyMol has it's own command line interface, just like the terminal. You can use that terminal and type the following command to load the predicted structure file:

``` bash         
load <path_to_cif_file>/p69441_model.cif
```

## Task 4: Compare predicted structures to known structures

From UniProt Db entry for Adenylate kinase ([P69441](https://www.uniprot.org/uniprot/P69441)), we can see that there are several known structures for this protein in the Protein Data Bank (PDB).

You can find the PDB IDs for the known structures in the UniProt entry under the "Structure" section. For this exercise, we will compare our predicted structure to the known structure with PDB ID `1AKE`.

Using PyMol terminal, you can fetch the known structure from the PDB database using the following command:

``` bash         
fetch 1AKE
```

You can then align the predicted structure to the known structure using the following command:

``` bash        
align p69441_model, 1AKE
```

This will align the predicted structure (P69441_model) to the known structure (1AKE) and provide you with an RMSD (Root Mean Square Deviation) value, which indicates how closely the predicted structure matches the known structure. A lower RMSD value indicates a better match.

You can also superimpose the two structures to visually compare them using the following command:

``` bash         
super p69441_model, 1AKE
```

This will superimpose the predicted structure onto the known structure, allowing you to visually assess the similarities and differences between the two structures.

:::::: challenge
## Challenge 4.1: checking structural alignment
Q.5 What is the RMSD value between the predicted structure and the known structure? Does it indicate a good prediction?

::: hint
Align predicted structure with the known structure from PDB database, using PyMOL.  
:::

::: solution
A low RMSD (e.g. <2 Å) indicates strong agreement with the known structure.  
Higher values suggest deviations and lower prediction accuracy.
:::
::::::

## Task 5: Predict structure of a protein complex

In this section, we will predict structure of a protein complex [4fqb](https://www.rcsb.org/structure/4FQB), where one protein is a toxic effector Tse1 and the other one is an immune protein Tsi1. They together form a protein complex, soon we will see their complex structure.

Let's begin with copying the FASTA file from <basefolder>/data/ directory to your `<basefolder>/<username>/protein-structure-exercise` directory. The file we need to copy is called `4fqb.fasta`.

``` bash
cp <basefolder>/data/4fqb.fasta <basefolder>/<username>/protein-structure-exercise/ 
```

Then, we prepare the AlphaFold3 input `JSON` file using the `fasta_to_af3_json.py` script. Use the following command:

``` bash
python3 <basefolder>/scripts/fasta_to_af3_json.py -i ./4fqb.fasta -n 4fqb -o ./af3-input/
```

Next, you need to run AlphaFold3 prediction using `af3-input/4fqb.json` file as input. It is very similar as the steps described in Challenge 1.4. Only exception is when you use `create_af3_slurm_job.py` script, the input (-i) should be changed as `-i af3-input/4fqb.json`. See below:

Check whether the AlphaFold3 module is still loaded:

``` bash
module list
```

If not, load AlphaFold3 module:

``` bash
module load AlphaFold/3.0.1
```

Check whether the module is now loaded successfully:

``` bash
module list
```

Then, we create slurm job:

``` bash
python3 <basefolder>/scripts/create_af3_slurm_job.py -p <Project-Code> -i ./af3-input/4fqb.json -o ./af3-output -m ./params > job_complex.sh
```

Now we execute the job as following:

``` bash
sbatch job_complex.sh
```

:::::: challenge
## Challenge 2: check the confidence score, visualise and compare the predicted complex with experimentally derived structure

After the prediction is complete, check the confidence score and compare the predicted structure with the known structure from the PDB database (4FQB) using instruction from Task 2, 3 and 4.

Q.6 Based on the confidence score and RMSD value, do you think AlphaFold3 performed well in predicting the protein complex?

::: solution

If both confidence scores (pTM/ipTM) are high and RMSD is low, AlphaFold3 performed well.  
If scores are low or RMSD is high, the prediction may be unreliable.

:::

::::::


In this episode, we explored how to predict, evaluate, and validate protein structures using AlphaFold3.

::::::::: keypoints

- AlphaFold predicts structure from sequence
- pTM/ipTM indicate confidence
- RMSD measures structural similarity

:::::::::
