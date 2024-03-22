# Running interactive session on rackham
ssh -Y lionel@rackham.uppmax.uu.se

cd /proj/g2020004/nobackup/3MK013/lionel/blast
interactive -A uppmax2024-2-10 -M snowy -t 00:45:00

## Blast commands
module load bioinfo-tools blast

time blastdbcmd -db nr -entry WP_000263098 > rpoB_ecoli_nr.fasta
time blastdbcmd -db landmark -entry WP_000263098 > rpoB_ecoli.fasta


blastp -db landmark -query rpoB_ecoli.fasta


blastp -db landmark -query rpoB_ecoli.fasta -evalue 1e-6 -outfmt 6 > rpoB_landmark.tab


blastdbcmd -db nr -entry AAU26214 > ravC_LP.fasta
blastp -query ravC_LP.fasta -db refseq_select_prot -evalue 1e-6 -outfmt 6 > ravC.blast

blastp -query ravC_LP.fasta -db refseq_select_prot -evalue 1e-6 -outfmt 6 -taxids 118969 > ravC_Leg.blast

blastp -query ravC_LP.fasta -db refseq_select_prot -evalue 1e-6 > ravC.blast

psiblast -query ravC_LP.fasta -db refseq_select_prot -save_pssm_after_last_round -out_pssm ravC_Leg.pssm -out_ascii_pssm ravC_Leg.pssm.txt -inclusion_ethresh 1e-10 -evalue 1e-6 -taxids 118969 > ravC_Leg.psiblast

psiblast -in_pssm ravC_Leg.pssm -db refseq_select_prot -inclusion_ethresh 1e-10 -evalue 1e-6 -max_target_seqs 1000 -num_iterations 0 -outfmt "7 qaccver saccver pident length mismatch gapopen qstart qend sstart send qcovs evalue bitscore ssciname scomname sskingdom" > ravC_all.psiblast
