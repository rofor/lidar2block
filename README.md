

# lidar2block

This is my first BASH script, so I'm sure there's plenty of room for improvement, suggestions welcome!

## Description

This was created in order to process UK Environment Agency LIDAR data, which is available here http://environment.data.gov.uk/ds/survey/

The aim is to create a water tight mesh cuboid the top surface of which is the input terrain.

## Notes

* I've included a rough script called lidar_subdivide which can be used to split large .asc files into smaller chunks.

## Setup

Arch linux specific;

    yaourt -S --noconfirm gdal meshlab imagemagick

Mac OSX specific;

    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null ; brew install caskroom/cask/brew-cask 2> /dev/null
    brew install gdal imagemagick
    brew cask install meshlab

Then;

    git clone https://github.com/rofor/lidar2block.git
    cd lidar2block
    chmod a+x lidar2block.sh
    sh lidar2block.sh /path/to/file.asc

## How

    To create the top surface gdal_translate is used to convert the ASCII grid into a list of XYZ co-ordinates.

    The sides and base are generated from the outer edge values of ASCII grid are compiled into 4 lists.

    Theses lists represent the maximum z positions of the points on the edges of the terrain.

    For each face a loop reads its corresponding list line by line, as this loop moves through the file three more nested loops generate the X, Y, and Z values.

    The code each face is structure slightly differently, I will describe the west face code.

    The first loop reads value on the current line of the file (the max z position) and generates a sequence from one to this value. Each one of these sequences represents z values for each column of the vertically stacked points on the face.

    The second loop reads the current line count and repeats this value for each of the values in the last sequence. Each of these lists of the same repeating value represent the Y positions for each column of points on the face.

    The third loop generates the X positions which on the west face are all 1.

    The terrain point cloud and the five generated point clouds are combined together into one big file with three columns called /temp/block.xyz.

    Finally Meshlabs command line utility meshlabserver is then used in combination with a MLX script to generate a water tight mesh from the point cloud. First Poisson-disk Sampling, then Delete Current Mesh, leaving only the newly created mesh, then Surface Reconstruction: Ball Pivoting, and lastly Close Holes.
