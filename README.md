[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/-7_RZisP)



# Day 1
## Creating a naming index
```
./getNames.sh > names.txt
sed 's/.fq.gz//g' > names
```
We looped through all of the linked FastQ files for their names and removed the ".fq.gz" ending to use the prefix as a stand-in name for the next loop.

## Duplicate removal and mapping
We combined the duplicate removal and the mapping into one loop in a bash script.
```
./rmdupMap.sh
```
The summary output of vsearch is piped into logfiles. After the duplicate removal, we count the fragment length of our FastQ file and pipe the output into files ending in "read_length.txt". 
The last step is mapping with bowtie2.

## Parameter selection

We removed the duplicates to reduce the amount of data that is being processed and remove pcr bias.

We also removed fragments that are shorter than 30bp long to reduce the liklihood of the presence of false positives, pcr artefacts and fragments that aretoo short to be meaningfil.
