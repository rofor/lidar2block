

# lidar2block

This is my first BASH script, so I'm sure there's plenty of room for improvement, suggestions welcome!

## Description

This was created in order to process UK Environment Agency LIDAR data, which is available here http://environment.data.gov.uk/ds/survey/

The script uses gdal_translate to convert 1m resolution ASCII grid terrain data with 2000 columns and 2000 rows into a list of XYZ co-ordinates.

It also generates a sea level point cloud as a base and appropriately shaped north, east, south, and west point clouds as sides.

The terrain point cloud and the five generated point clouds are combined together into a big list of XYZ values, and output as block.xyz.

CloudCompare can be used to open block.xyz, and save it as a PLY mesh.

This PLY mesh can then be imported into MeshLab and exported as an STL from which GCODE can be generated for 3d printing or CNC machining.

## Setup

Required dependencies:

    gdal

Optional dependencies:

    CloudCompare
    MeshLab

Clone this repository:

    git clone https://github.com/rofor/lidar2block.git
    cd lidar2block

Run the script:

    lidar2block.sh /path/to/file.asc
