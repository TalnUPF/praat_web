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
##### MODULE 6 ############################################################
###### Computation of speech rate										  #
###########################################################################
form Parameters
	text directory /home/upf/Escritorio/en_read_speech/textgrids_is/
	comment Annotate selected tiers
	real from_tier 3
	real to_tier 8
endform

## Uncomment and indent if several files within a folder need to be processed (for Local use only)
#Create Strings as file list: "list", directory$ + "/*.TextGrid"
#numberOfFiles = Get number of strings
#for ifile to numberOfFiles
#	selectObject: "Strings list"
#	fileName$ = Get string: ifile
#	basename$ = fileName$ - "_result_mod03.TextGrid"
Read from file: directory$ + basename$ "_result_mod03.TextGrid"
from_tier = 1
# Select number of tiers
to_tier = Get number of tiers

## Compute SR for whole speech
dur$ = Get feature from interval: 1, 1, "dur(sec)"
dur = number (dur$)
# Get number of words (must be equal to number of intervals at word tier, i.e. n.2)
n_words = Get number of intervals: 2
sr_w_tot = n_words / dur
sr_w_tot$ = fixed$ (sr_w_tot, 2)
Insert feature to interval: 1, 1, "sr_w", sr_w_tot$


## Computer SR for each span

for t from from_tier to to_tier
	n_int = Get number of intervals: t
	for i to n_int
		n_words$ = Get feature from interval: t, i, "n_words"
		n_words = number (n_words$)
		dur_int$ = Get feature from interval: t, i, "dur(sec)"
		dur_int = number (dur_int$)
		sr_word = n_words / dur_int
		sr_word$ = fixed$ (sr_word, 2)
		Insert feature to interval: t, i, "sr_w", sr_word$
	endfor
endfor

## Compute SR standard deviation at sentence level (i.e., P1L1 tier n.3)

n_sent = Get number of intervals: 3
mean = 0
sent = 0
for s to n_sent
	lab_sent$ = Get head of interval: 3, s
	if lab_sent$ <> ""
		mean_sent$ = Get feature from interval: 3, s, "sr_w"
		mean_sent = number (mean_sent$)
		sqr = (mean_sent - sr_w_tot)^2
		mean = mean + sqr
		sent += 1
	endif
endfor
std = 0
if mean <> 0
	std = sqrt(mean/sent)
	std$ = fixed$(std, 2)
	Insert feature to interval: 1,1, "std_sr", std$
	appendInfoLine: "std SR = ", std
endif

# Compute z_score of SR at all tiers
for t from from_tier to to_tier
	n_int2 = Get number of intervals: t
	for i to n_int2
		sr_span$ = Get feature from interval: t, i, "sr_w"
		sr_span = number (sr_span$)
		z_sr = (sr_span-sr_w_tot)/std
		z_sr$ = fixed$ (z_sr, 2)
		Insert feature to interval: t, i, "z_sr", z_sr$
	endfor
endfor	

# Save changes to directory
Save as text file: directory$ + basename$ + "_result_mod04.TextGrid"
#endfor
select all
Remove

appendInfoLine: "Module 6 completed"

#### END OF SCRIPT ##################################################################