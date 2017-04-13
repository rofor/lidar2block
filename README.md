

This is my first BASH script, so I'm sure there's plenty of room for improvement, suggestions welcome!

This BASH script converts 1m resolution ESRI grid data with 2000 columns and 2000 rows into a list of XYZ co-ordinates. It also generates sea a level point cloud base surface and closes the sides with four appropriately shaped point cloud surfaces.  The resulting list can be opened into CloudCompare and saved as a PLY mesh. This PLY mesh can then be imported into MeshLab and exported as an STL from which GCODE can be generated for 3d printing or CNC routing.

Dependancies;
gdal
awk
seq
paste
sed
cat
