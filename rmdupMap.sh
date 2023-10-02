for i in $(cat names)
do
    
    vsearch --fastx_uniques ${i}.fq.gz --fastqout ${i}.vs.fq.gz --minseqlength 30 --strand both > ${i}.log
    zcat ${i}.vs.fq.gz | awk '{if(NR%4==2) print length($1)}' | sort -n | uniq -c > ${i}.vs.fq.gz.read_length.txt 
    bowtie2 --threads 5 -k 100 -x ~/course/data/shared/mapping/db/aegenomics.db -U ${i}.vs.fq.gz --no-unal | samtools view -bS - > ${i}.bam

done
