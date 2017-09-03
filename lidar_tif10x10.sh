#!/usr/bin/bash

# Dependancies;
# gdal
# OS Open Greenspace 100km2 tile https://www.ordnancesurvey.co.uk/opendatadownload/products.html

v=$1 # define standard input as v
v2=${v::-4} # define v2 aS v minus 4 characters
mkdir $v2-100-tiles # make tile directory
cp $1 $v2-100-tiles/$1 # copy input to tile directory
convert $v2-100-tiles/$1 -crop 10x10@  +repage  +adjoin  $v2-100-tiles/$v2-%d.tif # crop into 100 pieces
