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
<img width="348" alt="image" src="https://github.com/GeoGenetics-edu/case-study-data-processing-documentation-team01/blob/main/aeCourse.DNAdamageLRJitterPlot%20(2).pdf">

The plot of the damage threshold against the number of reads:
<img width="348" alt="image" src="https://github.com/GeoGenetics-edu/case-study-data-processing-documentation-team01/blob/main/aeCourse.DNAdamageModelJitterPlot%20(2).pdf">

The plot of the plant strat plot:
<img width="348" alt="image" src="https://github.com/GeoGenetics-edu/case-study-data-processing-documentation-team01/blob/main/aeCourse.Stratplot_Plants_area.pdf">

The plot of the percentage of the taxa plotted:
<img width="348" alt="image" src="https://github.com/GeoGenetics-edu/case-study-data-processing-documentation-team01/blob/main/aeCourseLastPlot.pdf">

### Parameter Selection
We changed minimum damage threshold to 0.1 because we want to get rid of sequences that have 0 damage.  We didn't set it higher because we don't want to be removing true positives. Maybe DNA degrades at different rates and we don't want to lose any potential data.

We set the MAP significance to 2, because when we looked at the damage plot panel this was a good cut-off to minimise the amount of contamination or results affected by misalignment

We used a minimum of 100 reads per taxon, this is a good amount of reads to be able to identify if it is true damage or not

We used a min length of 30 base pairs because anything lower than this may be to short to identify properly (see above for day 1)
