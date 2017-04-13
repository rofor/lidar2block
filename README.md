

# lidar2block

This is my first BASH script, so I'm sure there's plenty of room for improvement, suggestions welcome!

## Description

This was created in order to process UK Environment Agency LIDAR data, which is available here http://environment.data.gov.uk/ds/survey/

The aim is to create a water tight mesh cuboid the top surface of which is the input terrain.

## How

To create the top surface gdal_translate is used to convert the ASCII grid into a list of XYZ co-ordinates.

The sides and base generated from the outer edge values of ASCII grid are compiled into 4 lists.

Theses lists represent the maximum z positions of the points on the edges of the terrain.

For each face a loop reads its corresponding list line by line, as this loop moves through the file three more nested loops are run.

The code each face are structure slightly differently, I will describe the west face code.

The first loop reads value on the current line of the file (the max z position) and generates a sequence from one to this value. Each one of these sequences represents z values for each column of the vertically stacked points on the face.

The second loop reads the current line count and repeats this number this value for each of the values in the last sequence. Each of these lists of the same number represent the Y positions for each column of points on the face.

The third loop generates the X positions which are all 1.

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
