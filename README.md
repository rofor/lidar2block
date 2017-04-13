

# lidar2block

This is my first BASH script, so I'm sure there's plenty of room for improvement, suggestions welcome!

## Description

I wrote this in order to process UK Environment Agency LIDAR data, which is available here http://environment.data.gov.uk/ds/survey/index.jsp#/survey

This script converts 1m resolution ESRI grid data with 2000 columns and 2000 rows into a list of XYZ co-ordinates.

It also generates a sea level point cloud base surface and closes the sides with four appropriately shaped point cloud surfaces.

The resulting "block" in the form of a list of XYZ values can be opened with CloudCompare and saved as a PLY mesh.

This PLY mesh can then be imported into MeshLab and exported as an STL from which GCODE can be generated for 3d printing or CNC routing.

## Setup

Required dependencies:

    gdal
    awk
    seq
    paste
    sed
    cat

Optional dependencies:

    CloudCompare
    MeshLab

Clone this repository:

    git clone https://github.com/rofor/lidar2block.git
    cd lidar2block

Run the script:

    lidar2block.sh /path/to/file.asc
