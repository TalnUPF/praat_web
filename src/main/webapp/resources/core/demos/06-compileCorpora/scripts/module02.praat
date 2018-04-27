###########################################################################
#                                                                      	  #
#  Praat Script: PROSODY TAGGER                                     	  #
#  Copyright (C) 2018  Mónica Domínguez-Bajo - Universitat Pompeu Fabra   #
#																		  #
#    This program is free software: you can redistribute it and/or modify #
#    it under the terms of the GNU General Public License as published by #
#    the Free Software Foundation, either version 3 of the License, or    #
#    (at your option) any later version.                                  #
#                                                                         #
#    This program is distributed in the hope that it will be useful,      #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of       #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        #
#    GNU General Public License for more details.                         #
#                                                                         #
#    You should have received a copy of the GNU General Public License    #
#    along with this program.  If not, see http://www.gnu.org/licenses/   #
#                                                                         #
###########################################################################
##### MODULE 1 ############################################################
###### Generation of objects from wav file								  #
###########################################################################
clearinfo
form Parameters
	text directory 
	text basename 
endform

# Variables for objects in Menu
sound$ = "Sound " + basename$ 
#text$ = "TextGrid " + basename$
int$ = "Intensity " + basename$ 
#peak$ = "IntensityTier " + basename$
pitch$ = "Pitch " + basename$ 

Read from file: directory$ + basename$  + ".wav"

# Create Intensity Object
selectObject: sound$
To Intensity: 100, 0, "yes"

# Extract peaks
#To IntensityTier (peaks)
#n_peaks = Get number of points

# Create Pitch object
selectObject: sound$
To Pitch: 0, 75, 300

selectObject: int$
Write to binary file: directory$ + basename$ + ".Intensity"

selectObject: pitch$
Write to binary file: directory$ + basename$ + ".Pitch"

# clean Menu
select all
Remove

appendInfoLine: "Module 2 finished"
############### END OF MODULE 1 ####################