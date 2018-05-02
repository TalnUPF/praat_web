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
##### MODULE 7 ############################################################
###### Export TextGrid to csv file		 								  #
###########################################################################
clearinfo
form Parameters
	text directory 
	text basename 
endform

titleline$ = "file,tier,interval,label,z_int,z_f0,z_dur,z_sr,minInt_t,maxF0_t,z_int_p,z_f0_p,z_dur_p,int(dB),f0(Hz),dur(s),sr,n_words,commStr"
appendFileLine: directory$ + basename$ + ".csv", titleline$

## Uncomment and indent if several files within a folder need to be processed (for Local use only)
#Create Strings as file list: "list", directory$ + "/*.TextGrid"
#numberOfFiles = Get number of strings
#for ifile to numberOfFiles
#	selectObject: "Strings list"
#fileName$ = Get string: ifile
#basename$ = fileName$ - "_result_mod01.TextGrid"

Read from file: directory$ + basename$ + "_result.TextGrid"
from_tier = 1
# Select number of tiers
to_tier = Get number of tiers
#appendFileLine: directory$ + resultFile$ +"_"+ basename$ + ".txt", titleline$
for t from from_tier to to_tier
	n_int = Get number of intervals: t
	for i to n_int
		int_lab$ = Get head of interval: t, i
		if int_lab$ != ""
			int$ = Get feature from interval: t, i, "z_int"
			f0$ = Get feature from interval: t, i, "z_f0"
			dur$ = Get feature from interval: t, i, "z_dur"
			z_sr$ = Get feature from interval: t, i, "z_sr"
			minint$ = Get feature from interval: t, i, "minInt_t"
			maxf0$ = Get feature from interval: t, i, "maxF0_t"
			int_p$ = Get feature from interval: t, i, "z_int_p"
			f0_p$ = Get feature from interval: t, i, "z_f0_p"
			dur_p$ = Get feature from interval: t, i, "z_dur_p"
			in$ = Get feature from interval: t, i, "int(dB)"
			f$ = Get feature from interval: t, i, "f0(Hz)"
			du$ = Get feature from interval: t, i, "dur(sec)"
			sr$ = Get feature from interval: t, i, "sr_w"
			n_words$ = Get feature from interval: t, i, "n_words"
			commStr$ = Get feature from interval: t, i, "commStr"

			appendFileLine: directory$ +resultFile$ + ".csv",basename$,",",t,",",i,",",int_lab$,",",int$,",",f0$,",",dur$,",",z_sr$,",",minint$,",",maxf0$,",",int_p$,",",f0_p$,",",dur_p$,",",in$,",",f$,",",du$,",",sr$,",",n_words$,",",commStr$
		endif
	endfor
endfor
#endfor
select all
Remove

appendInfoLine: "Features have been extracted to a csv file"

######### END OF SCRIPT ########
