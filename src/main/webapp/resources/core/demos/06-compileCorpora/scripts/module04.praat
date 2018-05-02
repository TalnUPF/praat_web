###########################################################################
#                                                                      	  #
#  Praat Script: COMPILATION OF CORPORA                                   #
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
##### MODULE 4 ############################################################
###### Computation of normalized parameters								  #
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
#	selectObject: "Strings list"
#fileName$ = Get string: ifile
#basename$ = fileName$ - "_result_mod01.TextGrid"

Read from file: directory$ + basename$ + "_result.TextGrid"
from_tier = 3
# Select number of tiers
to_tier = Get number of tiers
# Calculate z-scores of each interval (reference to previous level)
for t from from_tier to to_tier
	n_int = Get number of intervals: t
	for i to n_int
		lab$ = Get head of interval: t, i
		if lab$ <> ""
			# Extract features from interval
			int_i$ = Get feature from interval: t, i, "int(dB)"
			int_i = number (int_i$)
			f0_int$ = Get feature from interval: t, i, "f0(Hz)"
			f0_int = number (f0_int$)
			dur_int$ = Get feature from interval: t, i, "dur(sec)"
			dur_int = number (dur_int$)

			start = Get starting point: t, i
			end = Get end point: t, i
			mid_t = ((end - start)/2) + start
			# Look for referent previous tier (tier -1 or tier -2)
			pre_tier = 0
			pre_i = 0
			pre_lab$ = ""
			pre1_tier = t - 1
			pre2_tier = t - 2
			pre1_i = Get interval at time: pre1_tier, mid_t
			pre1_lab$ = Get head of interval: pre1_tier, pre1_i
			pre2_i = Get interval at time: pre2_tier, mid_t
			pre2_lab$ = Get head of interval: pre2_tier, pre2_i
			if pre1_lab$ <> ""
				pre_tier = pre1_tier
				pre_i = pre1_i
				pre_lab$ = pre1_lab$
			elif pre2_lab$ <> ""
				pre_tier = pre2_tier
				pre_i = pre2_i
				pre_lab$ = pre2_lab$
			else
			 	appendInfoLine: "No referent tier has been found"
		 	endif
		 	if pre_tier <> 0		
				# Extract features from previous tier
				pre_int$ = Get feature from interval: pre_tier, pre_i, "int(dB)"
				pre_stdint$ = Get feature from interval: pre_tier, pre_i, "stdint(dB)"
				pre_f0$ = Get feature from interval: pre_tier, pre_i, "f0(Hz)"
				pre_stdf0$ = Get feature from interval: pre_tier, pre_i, "stdf0(Hz)"
				pre_dur$ = Get feature from interval: pre_tier, pre_i, "dur(sec)"
				pre_int = number(pre_int$)
				pre_stdint = number(pre_stdint$)
				pre_f0 = number(pre_f0$)
				pre_stdf0 = number(pre_stdf0$)
				pre_dur = number(pre_dur$)

				# Calculate z-scores of each interval (reference to previous tier i.e. level)
				# Relative duration of interval compared to previous tier (NB. not z-score, nor percentage: decimal)
				z_int_pre = (int_i - pre_int) / pre_stdint
				z_f0_pre = (f0_int - pre_f0) / pre_stdf0
				z_dur_pre = dur_int / pre_dur

				# Write features
				z_int_pre$ = fixed$ (z_int_pre, 2)
				z_f0_pre$ = fixed$ (z_f0_pre, 2)
				z_dur_pre$ = fixed$ (z_dur_pre, 2)
				Insert feature to interval: t, i, "z_int_p", z_int_pre$
				Insert feature to interval: t, i, "z_f0_p", z_f0_pre$
				Insert feature to interval: t, i, "z_dur_p", z_dur_pre$
				Insert feature to interval: t, i, "ref_them", pre_lab$
			endif
		endif
	endfor
endfor
# Save changes to directory
Write to text file: directory$ + basename$ + "_result.TextGrid"
#endfor
select all
Remove

appendInfoLine: "Module 4 completed"

########### END OF SCRIPT ##############
