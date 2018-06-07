# !/bin/bash

#############################################################
# Script for downloading and preprocessing data files
#############################################################

# Note: The script must be in the same folder with url.txt 

# For setting the appropriate permissions to the file use: chmod 755 preprocessing.sh 

#############################################################
# Section A: Downloading Data
#############################################################

# Creation of URLs variable array
declare urls=( `cat "url.txt" `)

# Download files from URL list
for m in "${urls[@]}"
do wget -U 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4' "$m"
done

# Renaming of files for convenience of referral
mv cal.cnode nodes
mv cal.cedge edges
mv CA category
mv calmap.txt poi_e

#############################################################
# Section B: Data Transformation - Nodes.csv
#############################################################

# Add headings
echo 'NodeID Longitude Latitude' | cat - nodes > temp && mv temp nodes

# Use comma as delimiter and save in CSV format
cat nodes | sed 's/ /,/g' > nodes.csv
rm nodes

#############################################################
# Section C: Data Transformation - Edges.csv
#############################################################

# Add headings
echo 'edgeid startnodeid endnodeid l2distance' | cat - edges > temp && mv temp edges

# Save in csv format
cat edges | sed 's/ /,/g' > edges.csv
rm edges

#############################################################
# Section D: Data Transformation - Poi_n.csv
#############################################################

# Save category name and  corresponding category id along with headers in CSV format
awk '{printf "%s\n",$1}' category | sort -u |awk '{printf("%d %s\n", NR-1, $0)}'| sed 's/ /,/g' > tmp
echo 'categoryid categoryname' | cat - tmp > temp && mv temp poi_n
cat poi_n | sed 's/ /,/g' > poi_n.csv

# Delete unnecessary temporary files
rm poi_n
rm tmp
rm category

#############################################################
# Section E & F: Data Transformation - Poi_n.csv & no_poi.csv
#############################################################

# Delete edges with no points of interest
awk '$NF>0' poi_e > temp

# Split the initial file into 2: one contains edges and the second one pois
awk 'NR % 2 != 0' temp > no_poi
awk 'NR % 2 == 0' temp > temp_poi

# Merge the two files line by line so that each line includes all POIs between the corresponding crossroads
paste -d " " no_poi temp_poi > tmp

# Delete unnecessary columns (3rd and 4th columns)
awk '!($3="")' tmp | awk '!($3="")' > temp2

# Split lines with multiple points of interest so that each line corresponds to a single POI
awk '{for (i=3;i<=NF;i+=2)print $1,$2,$i,$(i+1)}' temp2 > poi_ed

# Delete unnecessary temporary files
rm temp_poi

# Add headings in no_poi and poi_e files
echo 'startnode endnode categoryid distancefromstart' | cat - poi_ed > temp && mv temp poi_ed
echo 'startnode endnode distance nopoi' | cat - no_poi > temp && mv temp no_poi

# Set comma as delimiter and save into CSV format
cat poi_ed | sed 's/ /,/g' > poi_e.csv
cat no_poi | sed 's/ /,/g' > no_poi.csv

# Delete unnecessary temporary files
rm no_poi
rm poi_ed
rm temp2
rm tmp
rm poi_e