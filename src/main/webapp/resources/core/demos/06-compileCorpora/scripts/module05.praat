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
##### MODULE 5 ############################################################
###### Annotation of linguistic features								  #
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
#	fileName$ = Get string: ifile
#	basename$ = fileName$ - "_result_mod02.TextGrid"
Read from file: directory$ + basename$ + "_result.TextGrid"
from_tier = 1
# Select number of tiers
to_tier = Get number of tiers

# Write features to thematicity tiers (as especified in formulaire)
for t from from_tier to to_tier
	n_int = Get number of intervals: t
	for i to n_int
		lab$ = Get head of interval: t, i
		start = Get starting point: t, i
		end = Get end point: t, i
		
		lab_string$ = ""
		n_spans = 0
		
		if lab$ <> ""
			# Write number of words in each span
			low_int = Get high interval at time: 2, start
			check_lab$ = Get head of interval: 2, low_int
			high_int = Get low interval at time: 2, end
			n_words = (high_int - low_int)+1
			n_words$ = string$(n_words)
			Insert feature to interval: t, i, "n_words", n_words$
			
			# loop over following tiers to get commStr string
			n_tier = t + 1
			if n_tier <= to_tier
				for n from n_tier to to_tier
					low_int2 = Get high interval at time: n, start
					check_lab2$ = Get head of interval: n, low_int2
					high_int2 = Get low interval at time: n, end
					if check_lab2$ <> ""
						n_int_comm = (high_int2 - low_int2)+1
						n_spans = n_spans + n_int_comm
						for b from low_int2 to high_int2
							lab$ = Get head of interval: n, b
							lab_string$ = lab_string$ + lab$
						endfor
						#appendInfoLine: "Lab string is ", lab_string$
					endif
				endfor
			endif
			if n_spans <> 0
				n_spans$ = string$ (n_spans)
				Insert feature to interval: t, i, "n_spans", n_spans$
				Insert feature to interval: t, i, "commStr", lab_string$
			endif
		endif
	endfor
# Save changes to directory
endfor
Write to text file: directory$ + basename$ + "_result.TextGrid"
#endfor
select all
Remove

appendInfoLine: "Module 5 completed"
########### END OF SCRIPT ##############
