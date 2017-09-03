import os, gdal

in_path = '/home/rofor/Data/Lidar/'
input_filename = 'st8994_DTM_1M.asc'

out_path = '/home/rofor/Data/Lidar/test/'
output_filename = 'tile_'

tile_size_x = 100
tile_size_y = 100

ds = gdal.Open(in_path + input_filename)
band = ds.GetRasterBand(1)
xsize = band.XSize
ysize = band.YSize

for i in range(0, xsize, tile_size_x):
    for j in range(0, ysize, tile_size_y):
        com_string = "gdal_translate -of AAIGrid -srcwin " + str(i)+ ", " + str(j) + ", " + str(tile_size_x) + ", " + str(tile_size_y) + " " + str(in_path) + str(input_filename) + " " + str(out_path) + str(output_filename) + str(i) + "_" + str(j) + ".asc"
        os.system(com_string)
