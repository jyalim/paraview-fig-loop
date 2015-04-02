#!/usr/bin/env bash
# Python Script assumes binary is a .vtk
# NOTE THE USE OF PERIODS IN FILE NAMES AND IMAGE FORMAT
# NOTE TRAILING / in $inputpath
# REMOVE TODO in Comments after fit for machine

# XXX inputpath=${3:-$(pwd)} # If in correct working directory

defaultchunk=${1:-1} # 1 for serial else 10 on dingo, 5 on comp2 
totalnumfigs=${2:-100} # NOTE: Nicer if range divides total# of figs
inputpath=${3:-'/home/data/work/Soln_splitCyl3D/Ro280runM2M39/'} # TODO
inputfile=${4:-'Re1.50d4Ro280Ga1_bi_m2_he.'} # TODO NOTE THE PERIOD
outputfile=${5:-'zRe1.50d4Ro280Ga1_m2_he.'}  # TODO
imageformat=${6:-'.jpg'}                     # NOTE THE PERIOD
startchunk=${7:-1}                           # TODO
timeout=${8:-0}                              # TODO

totalchunk=$(python -c "print int( $totalnumfigs / $defaultchunk )")
 
template='trimmed-pvbatch.template.py'
workfile='work.py'


errlog='pvbatch-error.log'

pvopts='--use-offscreen-rendering'

beginfoo() {
  in=${1}
  let in--
  echo $((defaultchunk * in + 1))
}

endfoo() {
  in=${1}
  let in
  echo $((defaultchunk * in + 1))
}

# 
for k in $(seq $startchunk $totalchunk); do
  begin=$(beginfoo $k)
  end=$(endfoo $k)
  [[ $k -gt $totalchunk ]] && end=$totalchunk || : 
  echo "Working on $begin to $((end-1)) out of $totalnumfigs"
  sed -e 's/{{begin}}/'${begin}'/g'              \
      -e 's/{{end}}/'${end}'/g'                  \
      -e 's+{{inputpath}}+'${inputpath}'+g'      \
      -e 's+{{inputfile}}+'${inputfile}'+g'      \
      -e 's+{{outputfile}}+'${outputfile}'+g'    \
      -e 's/{{imageformat}}/'${imageformat}'/g'  \
      $template > $workfile
  pvbatch $pvopts $workfile && : || echo fail $begin to $end >> $errlog
  sleep $timeout # give pvbatch time to close paraview
done
echo "Complete."
