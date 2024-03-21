# Running interactive session on rackham
ssh -Y lionel@rackham.uppmax.uu.se

cd /proj/g2020004/nobackup/3MK013/lionel/
interactive -A uppmax2024-2-10 -M snowy -t 00:05:00

## Blast commands
module load bioinfo-tools blast blast_databases

time blastdbcmd -db nr -entry WP_000263098 > rpoB_ecoli_nr.fasta
time blastdbcmd -db landmark -entry WP_000263098 > rpoB_ecoli.fasta


blastp -db landmark -query rpoB_ecoli.fasta
