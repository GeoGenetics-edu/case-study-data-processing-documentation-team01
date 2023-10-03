for file in *lca.txt.gz
do
    # Extract the ID from the input filename
    id=$(basename "$file" .lca.gz) 

    # Sort and count the unique numbers in the file, skip first line, and append to long_table.csv
    zcat "$file" | cut -d':' -f9 | sort | uniq -c | sed 1d | awk -v id="$id" '{print id "," $2 "," $1}' >> long_table.csv

    # Generate a scatterplot of the data using ggplot2
    Rscript -e "library(ggplot2); data <- read.csv('long_table.csv'); myplot <- ggplot(data, aes(x=Readlength, y=Count)) + geom_point() + facet_wrap(~ID, ncol = 2, scales = 'free_y'); ggsave('readlength_distributionTotal.pdf', myplot, width = 6, height = 4)"
done