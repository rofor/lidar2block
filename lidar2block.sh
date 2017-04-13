#!/bin/bash

#### to do ########
# thinning variable

################################################## prep ###############################################
  /usr/bin/rm -rf -R temp ;# delete old temp directory
  /usr/bin/rm -rf  block.xyz ;# delete old temp directory
  mkdir temp # make new temp directory
  sed -e '1,6d'  $1 > temp/matrix.xyz # strip ersi headers
##################################### extract terrain z for each face #################################
echo "Extracting Z values"
# north terrain z
  head -n1 temp/matrix.xyz > temp/fr.xyz # print first row of matrix #
    tr -s ' '  '\n' < temp/fr.xyz > temp/ntzm.xyz # transpose row to column
        awk '{print $1/1000}' temp/ntzm.xyz > temp/ntzf.xyz # scale
          awk -F. '{print $1}' temp/ntzf.xyz > temp/ntz.xyz # cull float
# east terrain z
  awk '{print $(NF-1)}' temp/matrix.xyz > temp/etzm.xyz # print second from last column of matrix
      awk '{print $1/1000}' temp/etzm.xyz > temp/etzf.xyz # scale
        awk -F. '{print $1}' temp/etzf.xyz > temp/etzr.xyz # cull float
          tac temp/etzr.xyz > temp/etz.xyz # reverse list
# south terrain z
    tail -n1 temp/matrix.xyz > temp/lr.xyz # print last row of matrix
      tr -s ' '  '\n' < temp/lr.xyz > temp/stzm.xyz # transpose row to column
          awk '{print $1/1000}' temp/stzm.xyz > temp/stzf.xyz # scale
            awk -F. '{print $1}' temp/stzf.xyz > temp/stz.xyz # cull float
# west terrain z
    awk '{print $1}' temp/matrix.xyz > temp/wtzm.xyz # print first column of matrix
        awk '{print $1/1000}' temp/wtzm.xyz > temp/wtzf.xyz # scale
          awk -F. '{print $1}' temp/wtzf.xyz > temp/wtzr.xyz # cull float
            tac temp/wtzr.xyz > temp/wtz.xyz # reverse list
echo "Done."
############################################### generate faces #######################################
echo "Generating faces.."
# north face
  sed 1d temp/ntz.xyz |  while read -r nline; do  # read lines of file one by one and perform loop each time
        seq 1 1 $nline >> temp/nz.xyz   # generate sequence of number whos maximum is the value of the current line
        nvar=$((nvar+1))   # count current file line
        for i in `seq 1 1 $nline`; do echo "$nvar";done >> temp/nx.xyz # repeat current line number for every iteration of each lines sequence
        for i in `seq 1 1 $nline`; do echo "2000";done >> temp/ny.xyz # repeat interger for every iteration of each lines sequence
    done  # specify file to read
          paste -d ' ' temp/nx.xyz temp/ny.xyz temp/nz.xyz > temp/n.xyz # paste x, y, z into 3 columns and save
# east face
    sed 1d temp/etz.xyz | while read -r eline; do  # read lines of file one by one and perform loop each time
        seq 1 1 $eline >> temp/ez.xyz   # generate sequence of number whos maximum is the value of the current line
        evar=$((evar+1))   # count current file line
        for i in `seq 1 1 $eline`; do echo "$evar";done >> temp/ey.xyz # repeat current line number for every iteration of each lines sequence
        for i in `seq 1 1 $eline`; do echo "2000";done >> temp/ex.xyz # repeat interger for every iteration of each lines sequence
    done  # specify file to read
          paste -d ' ' temp/ex.xyz temp/ey.xyz temp/ez.xyz > temp/e.xyz # paste x, y, z into 3 columns and save
# south face
    sed 1d temp/stz.xyz | while read -r sline; do  # read lines of file one by one and perform loop each time
        seq 1 1 $sline >> temp/sz.xyz   # generate sequence of number whos maximum is the value of the current line
        svar=$((svar+1))   # count current file line
        for i in `seq 1 1 $sline`; do echo "$svar";done >> temp/sx.xyz # repeat current line number for every iteration of each lines sequence
        for i in `seq 1 1 $sline`; do echo "1";done >> temp/sy.xyz # repeat interger for every  iteration of each lines sequence
    done # specify file to read
          paste -d ' ' temp/sx.xyz temp/sy.xyz temp/sz.xyz > temp/s.xyz # paste x, y, z into 3 columns and save
# west face
    sed 1d temp/wtz.xyz | while read -r wline; do  # read lines of file one by one and perform loop each time
        seq 1 1 $wline >> temp/wz.xyz   # generate sequence of number whos maximum is the value of the current line
        wvar=$((wvar+1))   # count current file line
        for i in `seq 1 1 $wline`; do echo "$wvar";done >> temp/wy.xyz # repeat current line number for every iteration of each lines sequence
        for i in `seq 1 1 $wline`; do echo "1";done >> temp/wx.xyz # repeat interger for every iteration of each lines sequence
    done # specify file to read
          paste -d ' ' temp/wx.xyz temp/wy.xyz temp/wz.xyz > temp/w.xyz # paste x, y, z into 3 columns and save

# base
for i in `seq 2000`; do echo "2000";done > temp/basez.xyz
    sed 1d temp/basez.xyz | while read -r bline; do  # read lines of file one by one and perform loop each time
        seq 1 1 $bline >> temp/bx.xyz   # generate sequence of number whos maximum is the value of the current line
        bvar=$((bvar+1))   # count current file line
        for i in `seq 1 1 $bline`; do echo "$bvar";done >> temp/by.xyz # repeat current line number for every iteration of each lines sequence
        for i in `seq 1 1 $bline`; do echo "1";done >> temp/bz.xyz # repeat interger for every iteration of each lines sequence
    done # specify file to read
          paste -d ' ' temp/bx.xyz temp/by.xyz temp/bz.xyz > temp/0-base.xyz && # paste x, y, z into 3 columns and save
echo "Done."

############################################ generate terrain point cloud ##########################################
echo " Generating terrain.."

# add line to set xllcorner and yllcorner to 1
    sed 's/\xllcorner.*/xllcorner          1/' $1 > temp/xllcorner.asc
    sed 's/\yllcorner.*/yllcorner          1/' temp/xllcorner.asc > temp/yllcorner.asc
		gdal_translate -of XYZ temp/yllcorner.asc temp/cloud.xyz # generate point cloud from raster
		awk '{print $1, $2, $3/1000}' temp/cloud.xyz > temp/0-terrain.xyz # divide z axis by 100 to generate terrain point cloud
  #  cat floatless.xyz | sed -re 's/([0-9]+\.[0-9]{2})[0-9]+/\1/g' > 0-terrain.xyz # cull all by two decimal places
echo "Done."

################################################## generate sides point cloud #######################################
echo "Combining.."
    cat temp/n.xyz temp/e.xyz temp/s.xyz temp/w.xyz > temp/0-sides.xyz # combine faces
    cat temp/0-base.xyz temp/0-sides.xyz  temp/0-terrain.xyz > block.xyz # combine to block
echo "All done. Now import block.xyz into cloud-compare, save as .ply (binary) import into MeshLab and save as .stl(binary)"