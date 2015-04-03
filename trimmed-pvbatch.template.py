#!/usr/bin/env pvbatch --use-offscreen-rendering

try: 
  paraview.simple
except: 
  from paraview.simple import *

# Set up Rendering initialization

inputpath="{{inputpath}}"
inputfile="{{inputfile}}" 

for i in range( {{begin}} , {{end}} ): 
  binfile = '{}{}{:04d}.vtk'.format(inputpath, inputfile, i) 
  # Set up Frame
  # Render()
  figfile = '{{outputfile}}{:04d}{{imageformat}}'.format(i) 
  # View
  # WriteImage
  # Delete Frame
