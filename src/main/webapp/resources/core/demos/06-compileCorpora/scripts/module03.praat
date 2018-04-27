###########################################################################
#                                                                      	  #
#  Praat Script: COMPILATION OF CORPORA                                	  #
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
##### MODULE 3 ############################################################
###### Extraction of acoustic parameters								  #
###########################################################################
clearinfo
form Parameters
	text directory 
	text basename 
endform

## Uncomment and indent if several files within a folder need to be processed (for Local use only)
#Create Strings as file list: "list", directory$ + "/*.TextGrid"
#numberOfFiles = Get number of strings
#for ifile to numberOfFiles
#selectObject: "Strings list"

Read from file: directory$ + basename$ + "_result.TextGrid"
Read from file: directory$ + basename$ + ".Pitch"
Read from file: directory$ + basename$ + ".Intensity"
# Variables for objects in Menu
text$ = "TextGrid " + basename$ + "_result"
pitch$ = "Pitch " + basename$
int$ = "Intensity " + basename$
############################################################
# Write features to a general tier "whole_speech" n.1
############################################################
selectObject: text$
from_tier = 1
# Select number of tiers
to_tier = Get number of tiers
dur = Get total duration
dur$ = fixed$(dur, 2)
selectObject: int$
meanint = Get mean: 0, 0, "dB"
stdint = Get standard deviation: 0, 0
meanint$ = fixed$ (meanint, 0)
stdint$ = fixed$ (stdint, 2)
selectObject: pitch$
meanF0 = Get mean: 0, 0, "Hertz"
stdF0 = Get standard deviation: 0, 0, "Hertz"
meanF0$ = fixed$ (meanF0, 0)
stdF0$ = fixed$ (stdF0, 2)
selectObject: text$
#Insert interval tier: 1, "whole_speech"
Insert feature to interval: 1, 1, "int(dB)", meanint$
Insert feature to interval: 1, 1, "stdint(dB)", stdint$
Insert feature to interval: 1, 1, "f0(Hz)", meanF0$
Insert feature to interval: 1, 1, "stdf0(Hz)", stdF0$
Insert feature to interval: 1, 1, "dur(sec)", dur$
#############################################################
# Write features for specified tiers relative to "all" tier
#############################################################
selectObject: text$
#loop over tiers to annotate
for t from from_tier+1 to to_tier
	pre_tier = t-1
	count_back_tier = pre_tier -1
	n_int = Get number of intervals: t
	# loop over intervals
	for i from 1 to n_int
		selectObject: text$
		int_label$ = Get label of interval: t, i
		# Annotate only labeled intervals
		if int_label$ != ""
			start = Get starting point: t, i
			end = Get end point: t, i
			mid_t = ((end - start)/2) + start
			dur_int = end - start
			selectObject: int$
			int_i = Get mean: start, end, "dB"
			stdint_i = Get standard deviation: start, end
			int_min_t = Get time of minimum: start, end, "Parabolic"
			norm_min_t = (int_min_t-start)/(end-start)

			selectObject: pitch$
			f0_int = Get mean: start, end, "Hertz"
			stdF0_int = Get standard deviation: start, end, "Hertz"
			f0_max_t = Get time of maximum: start, end, "Hertz", "Parabolic"
			norm_max_t = (f0_max_t-start)/(end-start)

		# Calculate z-scores of each interval (reference to extracted values from the whole sound)
			# Relative duration of interval compared to total duration of file (NB. not z-score)
			z_int = (int_i - meanint) / stdint
			z_f0 = (f0_int - meanF0) / stdF0
			z_dur = (dur_int / dur)

			# Write features
			selectObject: text$	
			int_i$ = fixed$ (int_i, 0)
			stdint_i$ = fixed$ (stdint_i, 0)
			z_int$ = fixed$ (z_int, 2)
			norm_min_t$ = fixed$ (norm_min_t, 2)
			f0_int$ = fixed$ (f0_int, 0)
			stdF0_int$ = fixed$ (stdF0_int, 0)
			z_f0$ = fixed$ (z_f0, 2)
			norm_max_t$ = fixed$ (norm_max_t, 2)
			dur_int$ = fixed$ (dur_int, 2)
			z_dur$ = fixed$ (z_dur, 2)
			Insert feature to interval: t, i, "int(dB)", int_i$
			Insert feature to interval: t, i, "stdint(dB)", stdint_i$
			Insert feature to interval: t, i, "f0(Hz)", f0_int$
			Insert feature to interval: t, i, "stdf0(Hz)", stdF0_int$
			Insert feature to interval: t, i, "dur(sec)", dur_int$
			Insert feature to interval: t, i, "maxF0_t", norm_max_t$
			Insert feature to interval: t, i, "minInt_t", norm_min_t$
			Insert feature to interval: t, i, "z_int", z_int$
			Insert feature to interval: t, i, "z_f0", z_f0$
			Insert feature to interval: t, i, "z_dur", z_dur$
		endif
	endfor
endfor
# Save changes to directory
Write to text file: directory$ + basename$ + "_result_mod01.TextGrid"
#endfor
select all
Remove

appendInfoLine: "Module 3 finished"

########### END OF SCRIPT ##############