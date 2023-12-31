[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/-7_RZisP)



# Day 1
## Creating a naming index

Make a symbolic link to the data files
```
ln -s ~/course/data/day2/fastq/*.fq.gz .
```

Give yourself permission to exectute getNames.sh
```
chmod u+x getNames.sh
```

```
./getNames.sh > names.txt
sed 's/.fq.gz//g' > names
```
We looped through all of the linked FastQ files for their names and removed the ".fq.gz" ending to use the prefix as a stand-in name for the next loop.

## Duplicate removal and mapping

Give yourself permission to exectute rmdupMap.sh
```
chmod u+x rmdupMap.sh
```

We combined the duplicate removal and the mapping into one loop in a bash script.
```
./rmdupMap.sh
```
The summary output of vsearch is piped into logfiles. After the duplicate removal, we count the fragment length of our FastQ file and pipe the output into files ending in "read_length.txt". 
The last step is mapping with bowtie2.

### Parameter selection

We removed the duplicates to reduce the amount of data that is being processed and remove PCR bias.

We also removed fragments that are shorter than 30bp long to reduce the likelihood of the presence of false positives, PCR artefacts and fragments that are too short to be meaningful.


# Day 2
## Sorting bam files
To use our created bam files as input for ngsLCA and metaDMG, we need to sort them first using the following looped command:
```
for i in $(cat names)
do
  samtools sort -n ${i}.bam -@ 5 > ${i}.sort.bam
done
```

## Running ngsLCA and metaDMG
Following the sorting, we run metaDMG to compute the LCA and get our damage profiles. We first construct the config file using all sorted bam files as input.
```
metaDMG config *.sort.bam --names ~/course/data/shared/mapping/taxonomy/names.dmp --nodes ~/course/data/shared/mapping/taxonomy/nodes.dmp --acc2tax ~/course/data/shared/mapping/taxonomy/acc2taxid.map.gz -m /usr/local/bin/metaDMG-cpp
```
Once our config.yaml file has been created, we change the custom_db value to true and run the next command:
```
metaDMG compute config.yaml 
```
This will compute the LCA file and the output needed to visualise the damage pattern, profiles and statistics.
We set the following filters on the dashboard to minimise contamination from modern sources. We set the minimum damage rate to 0.1 and the minimum MAP significance to 2.
This results in the following profile:
<img width="348" alt="image" src="https://github.com/GeoGenetics-edu/case-study-data-processing-documentation-team01/assets/61189065/d7b73c22-3458-4f22-8e02-f3ce31ba30f0">

We were able to identify the genus of bears (Ursus) with the following damage pattern:
<img width="253" alt="image" src="https://github.com/GeoGenetics-edu/case-study-data-processing-documentation-team01/assets/61189065/987245d9-4712-438f-93c7-455cd7dc3cce">

## Plotting the overall distribution
We used the provided bash loops and R plots (shown in the files plotting.sh and plotting2.sh) to make the two files "readlength_distributionTotal.pdf" and "readlength_distributionPerKingdom.pdf". The "readlength_distributionTotal.pdf" plot shows the read length distribution for every sample. While the "readlength_distributionPerKingdom.pdf" file shows the read length distribution for every read assigned to one of the kingdoms. 

# Day 3
## Plotting ancient DNA Authentication in Time series data in R

The plot of significance of the damage for all taxa with a read count of greater than 100:
<img width="806" alt="Significance_of_taxa_ 100_reads" src="https://github.com/GeoGenetics-edu/case-study-data-processing-documentation-team01/assets/64648262/3d233deb-299f-4278-95b0-2710de86a780">

The plot of the damage threshold against the number of reads:
<img width="1025" alt="Damage_by_no _of_reads" src="https://github.com/GeoGenetics-edu/case-study-data-processing-documentation-team01/assets/64648262/e21c9c8a-7ee9-4c76-9b6b-4a2a1bc154e2">


The plot of the plant strat plot:
<img width="1025" alt="Strat_plot" src="https://github.com/GeoGenetics-edu/case-study-data-processing-documentation-team01/assets/64648262/075cd477-a177-4723-9958-d657170fd8d3">

The plot of the percentage of the taxa plotted:
<img width="1024" alt="Per_cent-of_taxa_idenitifes" src="https://github.com/GeoGenetics-edu/case-study-data-processing-documentation-team01/assets/64648262/dfcec483-bfc0-4463-b82d-0668b3a75c35">


### Parameter Selection
We changed the minimum damage threshold to 0.1 because we want to eliminate sequences with 0 damage.  We didn't set it higher because we didn't want to remove true positives. Maybe DNA degrades at different rates, and we don't want to lose any potential data.

We set the MAP significance to 2 because when we looked at the damage plot panel, this was a good cut-off to minimise the contamination or results affected by misalignment.

We used a minimum of 100 reads per taxon, this is a good amount of reads to be able to identify if it is true damage or not.

We used a minimum length of 30 base pairs because anything lower than this may be to short to identify properly (see above for day 1)

### Metadata
Looking at the metadata, we identified the cave's location and the samples to be close to Lima, Peru. To biologically validate our plant taxa we checked their common location and use. 
<img width="408" alt="image" src="https://github.com/GeoGenetics-edu/case-study-data-processing-documentation-team01/assets/61189065/12662268-9c1f-4b15-a69c-1e50b412bed1">
Approximately 75% of the genera is not normally found in Peru. Looking back at the abundance plot, we can see that lots of the plants can be found in the two newest samples, where no evidence of human occupation should be found. 
All of this information led us to redo our initial analysis with stricter filter parameters, as we believed that the found taxa were false positives. 

### Rerun 
Our new parameters were set to have a minimum significance of 3, a minimum damage level of 0.15 and a minimum of 100 reads per taxon. We kept the analysis on the genus level. 
Our rerun led to only identifying four plant genera. 
<img width="512" alt="image" src="https://github.com/GeoGenetics-edu/case-study-data-processing-documentation-team01/assets/61189065/bfed1729-0cd8-4dd8-a69f-992306632e79">

Only one of the taxa is native to Peru (Alnus). This is a very common taxon and cannot be taken as any indication of human presence. 

### Mammalian non-human
As there is no DNA evidence of human presence in any of the samples and the plant communities do not indicate any human presence either we checked other mammalian families that could be present. 
From metaDMG, we know that the youngest samples (PRI-TJPGK-CATN-96-98) show the genus of bears (Ursus) passing all of our filters. 
We rerun our data with euka to access a different database. We got an additional hit to the bears, the Bovidae family. 

<img width="469" alt="image" src="https://github.com/GeoGenetics-edu/case-study-data-processing-documentation-team01/assets/61189065/7e529d92-c907-48f3-aa75-253ad90b8c69">

<img width="471" alt="image" src="https://github.com/GeoGenetics-edu/case-study-data-processing-documentation-team01/assets/61189065/39841b95-e222-49e3-a472-7431508f2063">

The damage pattern and fragment length distribution of the family Bovidae are not quite as good as the one from the bears. This taxon may be a contamination from a modern source or an even more recent sample. 

## Conclusion
To conclude, the only eukaryotic taxon that can be verified is the genus of bears. This is most likely a bear cave, but the samples from the cave show no indication of human presence. 

## Further outlook
One could look more specifically into the microbial communities.


