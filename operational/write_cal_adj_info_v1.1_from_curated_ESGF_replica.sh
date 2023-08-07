#!/bin/bash

# This script will work it's way through the directories and convert all the files

# Set up some paths
ESGF_DIR="/mnt/curated_ESGF_replica"
THIS_DIR=`pwd`
echo $PWD
info_file="cal_adj_info.csv"
rm $info_file
NO_OVERWRITE="TRUE"
CA_STR="cal-adj"

function hasLongIndices {
  hasLongIndices_DIR=$1
  hasLongIndices_filename=$2
  hasLongIndices_varname=${hasLongIndices_filename%%_*}
  hasLongIndices_indices=`ncdump -h $hasLongIndices_DIR/$hasLongIndices_filename | grep index`
  if [[ $hasLongIndices_indices == *"L"* ]]
  then
    return 1
  else
    return 0
  fi
}  

# Setting a flag to get the header written
INFO_HEADER_WRITTEN=0  

# pmip3_gcms="bcc-csm1-1 CCSM4 CNRM-CM5 COSMOS-ASO CSIRO-Mk3-6-0 CSIRO-Mk3L-1-2 EC-EARTH-2-2 FGOALS-g2 FGOALS-s2 GISS-E2-R HadCM3 HadGEM2-CC HadGEM2-ES IPSL-CM5A-LR KCM1-2-2 LOVECLIM MIROC-ESM MPI-ESM-P MRI-CGCM3"
# pmip3_expts="midHolocene lgm"
# for gcm in $pmip3_gcms
# do
#   for expt in $pmip3_expts
#   do
#     case $expt in 
#     midHolocene)
#       expt_yr=-6000
#       ;;
#     lig127k)
#       expt_yr=-127000  
#       ;;
#     lgm)
#       expt_yr=-21000
#       ;;
#     *)
#       echo "Unrecognised experiment of: " $expt
#       exit
#       ;;
#     esac    
#     input_dir=$ESGF_DIR/$gcm/$expt
#     if [ -d $input_dir ] 
#     then
#       output_dir=$ESGF_DIR/$gcm/$expt\-$CA_STR
#       mkdir -p $output_dir
#       cd $input_dir
#       ncfiles=`ls -d *mon_*.nc`
#       #echo "$ncfiles"
#       cd $THIS_DIR
#       for ncfile in $ncfiles
#       do
#         if [ $ncfile != "*.nc" ]; then #Only enter this loop if there are any monthly nc files
#           echo $ncfile
#           input_file=$ncfile
#           output_file=${input_file//$expt/$expt\-$CA_STR}
#           if [ $NO_OVERWRITE == "TRUE" ] && [ -f $output_dir/$output_file ]; then 
#             #skip over this one
#             message=`echo "Not overwriting "$output_file`
#             # echo $message
#           else
#             if [ $INFO_HEADER_WRITTEN == 0 ]; then
#               echo  "activity,variable,time_freq,calendar_type,begageBP,endageBP,agestep,begyrCE,nsimyrs,interp_method,no_negatives,match_mean,tol,source_path,source_file,adjusted_path,adjusted_file" >> $info_file
#               INFO_HEADER_WRITTEN=1  
#             fi 
#             #manipulate string
#             echo $input_file 
#             no_nc=`echo ${input_file%.nc}`
#             yr_str=${no_nc##*_}
#             prior_str=${no_nc%_*}
#             variable=${no_nc%%_*}
#             echo $variable
#             no_var=${no_nc#*_}
#             time_freq=${no_var%%_*}
#             start_yr=`echo $yr_str | cut -c-4`
#             end_yr=`echo ${yr_str##*-} | cut -c-4`
#             let length=$((10#$end_yr))-$((10#$start_yr))+1
#             calendar=`ncdump -h $input_dir/$input_file | grep time | grep calendar | cut -d\" -f2`
#             if [ $variable != 'msfmtz' ] && [ $variable != 'msftmyz' ]; then
#               if [ $variable == 'pr' ] || [ $variable == 'siconc' ]; then
#                 # both precipitation and sea ice concentration cannot go negative, so set that switch to TRUE 
#                 no_negatives="TRUE"
#               else
#                 no_negatives="FALSE"
#               fi 
#               #write names into csv file
#               echo 'PMIP3,'$variable','$time_freq','$calendar','$expt_yr','$expt_yr',1,'$start_yr','$length',Harzallah,'$no_negatives',TRUE,0.01,'$input_dir','$input_file','$output_dir','$output_file >> $info_file
#             fi   
#           fi
#         fi
#       done
#     fi
#   done
# done


#PMIP4
pmip4_gcms="ACCESS-ESM1-5 AWI-ESM-1-1-LR CESM2 CESM2-FV2 CESM2-WACCM-FV2 CNRM-CM6-1 EC-Earth3-LR FGOALS-f3-L FGOALS-g3 GISS-E2-1-G HadGEM3-GC31-LL INM-CM4-8 IPSL-CM6A-LR MIROC-ES2L MPI-ESM1-2-LR MRI-ESM2-0 NESM3 NorESM1-F NorESM2-LM UofT-CCSM-4"
pmip4_expts="midHolocene lig127k lgm"

for gcm in $pmip4_gcms
do
  for expt in $pmip4_expts
  do
    case $expt in 
    midHolocene)
      expt_yr=-6000
      ;;
    lig127k)
      expt_yr=-127000  
      ;;
    lgm)
      expt_yr=-21000
      ;;
    *)
      echo "Unrecognised experiment of: " $expt
      exit
      ;;
    esac    
    input_dir=$ESGF_DIR/$gcm/$expt
    if [ -d $input_dir ] 
    then
      output_dir=$ESGF_DIR/$gcm/$expt\-$CA_STR
      mkdir -p $output_dir
      cd $input_dir
      ncfiles=`ls -d *mon_*.nc`
      #echo "$ncfiles"
      cd $THIS_DIR
      for ncfile in $ncfiles
      do
        if [ $ncfile != "*.nc" ]; then #Only enter this loop if there are any monthly nc files
          input_file=$ncfile
          output_file=${input_file//$expt/$expt\-$CA_STR}
          if [ $NO_OVERWRITE == "TRUE" ] && [ -f $output_dir/$output_file ]; then 
            #skip over this one
            message=`echo "Not overwriting "$output_dir/$output_file`
            # echo $message
          else
            hasLongIndices $ESGF_DIR/$gcm/$expt $ncfile
            if [ $? == 1 ]; then
              ncatted -a physics_index,global,d,, -a forcing_index,global,d,, -a realization_index,global,d,, -a initialization_index,global,d,, $ESGF_DIR/$gcm/$expt/$ncfile
            fi
            if [ $INFO_HEADER_WRITTEN == 0 ]; then
              echo  "activity,variable,time_freq,calendar_type,begageBP,endageBP,agestep,begyrCE,nsimyrs,interp_method,no_negatives,match_mean,tol,source_path,source_file,adjusted_path,adjusted_file" > $info_file 
              INFO_HEADER_WRITTEN=1  
            fi 
            #manipulate string
            no_nc=`echo ${input_file%.nc}`
            yr_str=${no_nc##*_}
            prior_str=${no_nc%_*}
            variable=${no_nc%%_*}
            no_var=${no_nc#*_}
            time_freq=${no_var%%_*}
            start_yr=`echo $yr_str | cut -c-4`
            end_yr=`echo ${yr_str##*-} | cut -c-4`
            let length=$((10#$end_yr))-$((10#$start_yr))+1
            calendar=`ncdump -h $input_dir/$input_file | grep time | grep calendar | cut -d\" -f2`
            if [[ $calendar == "365_day noleap" ]]; then
              ncatted -a calendar,time,o,c,365_day $input_dir/$input_file
              calendar=`ncdump -h $input_dir/$input_file | grep time | grep calendar | cut -d\" -f2`
            fi
            case $variable in
              *"msf"* )
                echo "skipping meridional streamfunction: " $input_dir/$input_file
                ;;
                # both precipitation and sea ice concentration cannot go negative, so set that switch to TRUE 
              "pr" )
                no_negatives="TRUE"
                #write names into csv file
                echo 'PMIP4,'$variable','$time_freq','$calendar','$expt_yr','$expt_yr',1,'$start_yr','$length',Harzallah,'$no_negatives',TRUE,0.01,"'$input_dir'/","'$input_file'","'$output_dir'/","'$output_file'"' >> $info_file 
                ;;
              "siconc" )   
                no_negatives="TRUE"
                #write names into csv file
                echo 'PMIP4,'$variable','$time_freq','$calendar','$expt_yr','$expt_yr',1,'$start_yr','$length',Harzallah,'$no_negatives',TRUE,0.01,"'$input_dir'/","'$input_file'","'$output_dir'/","'$output_file'"' >> $info_file 
                ;;
              *)
                no_negatives="FALSE"
                #write names into csv file
                echo 'PMIP4,'$variable','$time_freq','$calendar','$expt_yr','$expt_yr',1,'$start_yr','$length',Harzallah,'$no_negatives',TRUE,0.01,"'$input_dir'/","'$input_file'","'$output_dir'/","'$output_file'"' >> $info_file 
                ;;
            esac 
          fi
        fi
      done
    fi
  done
done
