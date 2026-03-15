---
title: 'Protein structure prediction'
teaching: 0
exercises: 120
---
:::::::::::::::::::::::::::::::::::::: questions 
- How can we predict a protein's 3D structure from its sequence?
- How do we evaluate the confidence of predicted structures?
::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::: objectives
- Predict a protein structure using `AlphaFold`.
- Interpret prediction confidence scores.
- Visualize predicted structures.
- Compare predicted structures to known structures.
::::::::::::::::::::::::::::::::::::::::::::::::
## Introduction
In this episode, we are going to explore protein structure prediction. For structure prediction, you are going to use [`AlphaFold`](https://www.nature.com/articles/s41586-021-03819-2), a deep learning model based tool developed by DeepMind that has revolutionized the field of protein structure prediction.
We will (1) predict the structure of a protein, (2) interpret the confidence of the predictions, (3) visualize the predicted structures, and (4) compare them to known structures.
Let's get started by setting up our environment for prediction and loading the necessary libraries.
## Task 1: Predicting a protein structure
To predict a protein structure using `AlphaFold`, we will use the `alphafold` module from Pelle.
For protein structure prediction, we need to provide the amino acid (AA) sequence of the protein we want to predict. 
For this episode, we will use the AA sequence of Adenylate kinase from *Escherichia coli* (UniProt ID: [P69441](https://www.uniprot.org/uniprot/P69441)).
## Challenge 1.1: prepare the terrain
The course base folder is at `/proj/g2020004/nobackup/3MK013`. Go to your own folder, create a `protein-structure-exercise` subfolder, and move into it. Also, start the `interactive` session, for 4 hours. The session name is `uppmax2025-3-4` and the cluster is `snowy`.
::: hint
Remember those commands?
```bash
ssh -Y
cd
mkdir
ls
interactive
```
::::::::
:::::::::::::::  solution
```bash
ssh -Y <username>@pelle.uppmax.uu.se
```
Remember to replace `<username>` by your name.
```bash
interactive -A <session> -M <cluster> -t <hh::mm::ss>
cd <basefolder>/<username>
mkdir <folder>
cd <folder>
```
:::::::::::::::::::::::::
:::::::::::::::  instructor
```bash
ssh -Y <username>@pelle.uppmax.uu.se
```
```bash
interactive -A uppmax2025-3-4 -M snowy -t 4:00:00 # Need to add GPU as well.
cd /proj/g2020004/nobackup/3MK013/<username>
mkdir protein-structure-exercise
cd protein-structure-exercise
```
:::::::::::::::::::::::::
## Challenge 1.2: prepare the input file
You can download the sequence of Adenylate kinase using the following code:
```bash
wget https://rest.uniprot.org/uniprotkb/P69441.fasta
```
This will download the FASTA file containing the amino acid sequence of the protein.
Q.1 Can you tell how many amino acids are in the sequence? You can use the `grep` command to count. 
::: hint
The `grep -v ">"` command removes the header line, `tr -d '\n'` removes newlines, and `wc -c` counts the number of characters, which corresponds to the number of amino acids.
::::::::
::: hint
::::::::
:::::::::::::::  solution
```bash
grep -v ">" P69441.fasta | tr -d '\n' | wc -c
```
:::::::::::::::::::::::::
You can check how AlphaFold input files look like [here](https://github.com/google-deepmind/alphafold3/blob/main/docs/input.md). 
You can manually format the input file according to the specifications, but for this exercise, we will use a script that automates the process.
Please use the following command to prepare the input file for AlphaFold:
```bash
python3 <basefolder>/<script_folder>/make_AF3_input_from_fasta.py -i P69441.fasta -o P69441.json -n P69441
```
This command will take the FASTA file as input and generate a JSON file that can be used for AlphaFold prediction.
Then we create a directory called `af3-input` and move the generated JSON file into it:
```bash
mkdir input
mv P69441.json input/
```
## Challenge 1.3: run AlphaFold prediction
Now that we have the input file ready, we can run the AlphaFold prediction. 
First, we need to load the `alphafold` module:
```bash
module load AlphaFold/3.0.1
```
Then, we create output directory for storing the AF3 predicted results:
```bash
mkdir af3-output
```
Then, we can run the prediction using the following command:
```bash  
apptainer exec \
--nv \
--bind <basefolder>/<username>/protein-structure-exercise/af3-input:/root/af3-input \
--bind <basefolder>/<username>/protein-structure-exercise/af3-output:/root/af3-output \
--bind <basefolder>/<username>/protein-structure-exercise/params/:/root/models \
--bind $ALPHAFOLD_DATASET:/root/public_databases \
$ALPHAFOLD_ROOT/alphafold3.sif \
bash -c "XLA_FLAGS=--xla_disable_hlo_passes=custom-kernel-fusion-rewriter \
python /app/alphafold/run_alphafold.py \
--json_path=/root/af3-input/P69441.json \
--model_dir=/root/models \
--db_dir=/root/public_databases \
--output_dir=/root/af3-output \
--flash_attention_implementation=xla"
```
This command runs the AlphaFold prediction using the input JSON file and saves the results in the `af3-output` directory.
## Challenge 2: interpret the confidence of the predictions
In the output directory, you will find several files, including one with suffix`_summary_confidences.json`, which contains the confidence scores for the predicted structure.
You can use the following command to view the contents of the confidence summary file:
```bash
cat af3-output/P69441_summary_confidences.json
```
pTM is an integrated measure of how well AlphaFold-Multimer has predicted the overall structure of the complex. 
It is derived from the predicted aligned error (PAE) matrix, which estimates the expected positional error at residue level. The pTM score ranges from 0 to 1, where higher scores indicate higher confidence in the predicted structure. A pTM score above 0.7 is generally considered a good prediction.
In contrast, ipTM measures the accuracy of the predicted relative positions of the subunits forming the protein-protein complex. 
Values higher than 0.8 represent confident high-quality predictions, while values below 0.6 suggest likely a failed prediction.
Q.2 What are the pTM and ipTM scores for the predicted structure of Adenylate kinase? Does it indicate a good prediction?
::: hint
You can find the pTM and ipTM scores in the `_summary_confidences.json` file. Look for the keys `"pTM"` and `"ipTM"` in the JSON file.
::::::::
## Challenge 3: visualize the predicted structures
To visualize the predicted structure, you can use a molecular visualization tool such as [PyMOL](https://pymol.org/2/).
In case you can not install these tools on your local machine, you can use the web-based tool [RCSB 3D View](https://www.rcsb.org/3d-view) to visualize the predicted structure.
To visualize the predicted structure using RCSB 3D View, you can follow these steps:
Download the predicted structure file (with suffix `_model.cif`) from the `af3-output` directory to your local machine.
::: hint
You can use the `scp` command to securely copy the file from the remote server to your local machine. Replace `<username>` with your actual username and `<local_path>` with the path where you want to save the file on your local machine.
```bash
scp <username>@pelle.uppmax.uu.se:/proj/g2020004/nobackup/3MK013/<username>/protein-structure-exercise/af3-output/P69441_model.cif <local_path>
```
::::::::
To visualize in PyMOL, first open PyMOL on your local machine. PyMol has it's own command line interface, just like the terminal. 
You can use the following command to load the predicted structure file: 
```
load <path_to_downloaded_file>/P69441_model.cif # Run it using PyMOL's command line interface to load the predicted structure file.
```
## Challenge 4: compare predicted structures to known structures
From UniProt Db entry for Adenylate kinase ([P69441](https://www.uniprot.org/uniprot/P69441)), we can see that there are several known structures for this protein in the Protein Data Bank (PDB).
You can find the PDB IDs for the known structures in the UniProt entry under the "Structure" section.
For this exercise, we will compare our predicted structure to the known structure with PDB ID `1AKE`.
Using PyMol terminal, you can fetch the known structure from the PDB database using the following command:
```
fetch 1AKE
```
You can then align the predicted structure to the known structure using the following command:
```
align P69441_model, 1AKE
```
This will align the predicted structure (P69441_model) to the known structure (1AKE) and provide you with an RMSD (Root Mean Square Deviation) value, which indicates how closely the predicted structure matches the known structure. 
A lower RMSD value indicates a better match.
You can superimpose the two structures to visually compare them using the following command:
```
super P69441_model, 1AKE
```
This will superimpose the predicted structure onto the known structure, allowing you to visually assess the similarities and differences between the two structures.
Q.3 What is the RMSD value between the predicted structure and the known structure? Does it indicate a good prediction?