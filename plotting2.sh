echo "ID,Category,Readlength,Count" > long_table2.csv

for file in *lca.txt.gz
do
    # Extract the ID from the input filename
    id=$(basename "$file" .lca.gz)

    # Sort and count the unique numbers in the file, skip first line, and append to long_table.csv
    zcat "$file"  | grep -e 'Archaea' | cut -d':' -f9 | sort -n | uniq -c | sed 1d | awk -v id="$id" '{print id "," "Archaea" "," $2 "," $1 }' >> Archaea_long_table.csv
    zcat "$file"  | grep -e 'Bacteria' -e 'bacteria' | cut -d':' -f9 | sort -n | uniq -c | sed 1d | awk -v id="$id" '{print id "," "Bacteria" "," $2 "," $1 }' >> Bacteria_long_table.csv
    zcat "$file"  | grep -e 'Viridiplantae' | cut -d':' -f9 | sort -n | uniq -c | sed 1d | awk -v id="$id" '{print id "," "Viridiplantae" "," $2 "," $1 }' >> Viridiplantae_long_table.csv
    zcat "$file"  | grep -e 'Virus' | cut -d':' -f9 | sort -n | uniq -c | sed 1d | awk -v id="$id" '{print id "," "Virus" "," $2 "," $1 }' >> Virus_long_table.csv
    zcat "$file"  | grep -e 'Metazoa' | cut -d':' -f9 | sort -n | uniq -c | sed 1d | awk -v id="$id" '{print id "," "Metazoa" "," $2 "," $1 }' >> Metazoa_long_table.csv
    # Create a long table of all long tables
    cat Archaea_long_table.csv Bacteria_long_table.csv Viridiplantae_long_table.csv Virus_long_table.csv Metazoa_long_table.csv >> long_table2.csv

    # Generate a scatterplot of the data using ggplot2chmod
    Rscript -e "library(ggplot2);library(viridisLite); data <- read.csv('long_table2.csv'); plot <- ggplot(data, aes(x = Readlength, y = Count, fill = Category)) + geom_area(alpha = 0.8) + scale_fill_viridis_d() + facet_wrap(~ID, scales = 'free_y', ncol = 2) + labs(x = 'Read Length', y = 'Count', title = 'Read Length Distribution by Category') + theme(plot.title = element_text(hjust = 0.5)); ggsave('readlength_distributionPerKingdom.pdf', plot, width = 5, height = 7)"
done
