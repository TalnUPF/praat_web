#!/usr/bin/env python
# -*- coding: utf-8 -*-
import codecs
from itertools import tee, islice, chain, izip
import sys
import re

directory = sys.argv[1]
basename = sys.argv[2]

tx = open(directory + basename + ".txt", "r")
raw_txt = tx.read()
################################
# Read from txt
txt_list = raw_txt.split("\n")

l1PList = []
l1TList = []
l2PList = []
l2TList = []
for idx,sentence in enumerate(txt_list):
	words = sentence.split()
	count_levT = 0
	count_levP = 0
	start_T = []
	start_P = []
	for word in words:
		if "{" in word :
			#print "Cond Prop ", word
			addP = word.count("{")
			count_levP += addP
			if "[" in word and "]" in word:
				segm = re.split("[\{\[\]]", word)
				#print "Condition B1", segm
				span = segm[3]
				startP = segm[2]
				start_P.append(startP)
				l2TList.append([span, startP, startP])
				#print "start_P List ", start_P
			elif "[" in word :
				segm = re.split("[\{\[]", word)
				#print "Condition B2", segm
				startP = segm[2]
				start_P.append(startP)
				addT = word.count("[")
				count_levT += addT
				for a in addT:
					start_T.append(startP)
			else: 
				startP = word.split("{")[1]
				start_P.append(startP)
		##### Propositions
		elif "]" in word and "}" in word :
			#print "Cond B3", word
			count_end = word.count("]")
			segm = re.split("[\]\}]", word)
			span2 = segm[1]
			end_prop = segm[2]
			wordE = segm[0]
			if count_end == 2:
				#print "Condition B3a. Start Them", start_T
				span1 = segm[3]
				start2 = start_T.pop()
				l2TList.append([span2, start2, wordE])
				count_levT -= 1
				start1 = start_T.pop()
				l1TList.append([span1,start1, wordE])
				count_levT -= 1
				#print "Start Prop", start_P
				startP = start_P.pop()
				l2PList.append([end_prop,startP,wordE])
				#print "COUNT THEM = ",count_levT
				#print "List Prop2", l2PList

		elif "[" in word :
			#print "Cond 1 ", word
			check = word.find("}")
			addT = word.count("[")
			count_levT = count_levT + addT
			#print addT
			#print "Count Them", count_levT
			if "]" in word:
				segm = re.split("[\[\]]", word)
				wordR = segm[1]
				count_end = word.count("]")
				span1 = segm[2]
				
				#print "Condition A",segm
				#print "Count end", count_end
				#print "Count THEM = ", count_levT
				if count_levT == 2 and count_end == 2:
					#print "Cond 1 a"
					span2 = segm[2]
					span1 = segm[3]
					l2TList.append([span2, wordR, wordR])
					count_levT -= 1
					startOK = start_T.pop()
					l1TList.append([span1, startOK, wordR])
					count_levT -= 1
				elif count_levT == 2 and count_end == 1 and addT == 2:
					#print "Cond 1 x"
					span1 = segm[3]
					wordR = segm[2]
					l2TList.append([span1, wordR, wordR])
					count_levT -= 1
					start_T.append(wordR)

				elif count_levT == 2 and count_end == 1 :
					#print "Cond 1 y"
					l2TList.append([span1, wordR, wordR])
					count_levT -= 1
				elif count_end == 2:
					#print "Cond 1 b"
					span2 = segm[2]
					span1 = segm[3]
					l2TList.append([span2, wordR, wordR])
					count_levT -= 1
				elif count_levT == 1 and count_end == 2:
					#print "Cond 1 c"
					startOK = start_T.pop()
					l1TList.append([span1, startOK, wordR])
					count_levT -= 1
				elif count_levT == 1:
					#print "Cond 1 d"
					l1TList.append([span1, wordR, wordR])
					count_levT -= 1
			elif addT == 2 :
				#print "Cond 2"
				start = word.split("[")
				#print "Split 2 is = ", start
				if len(start) == 3 :
					#print "Cond 2a"
					startOK = start[2]
					start_T.append(startOK)
					start_T.append(startOK)
					#print start_T
				else :
					#print "Cond 2b"
					start_T.append(start[1])
			else :
				#print "Cond 3"
				start = word.split("[")[1]
				#print "Split 1 is = ", start
				start_T.append(start)
				#print "Count THEM", count_levT
			## Pending other cases
		elif "]" in word and check == -1:
			#print "Cond 4 ", word
			#print "Count Them", count_levT
			end_span = word.split("]")[0]
			count_end = word.count("]")
			#print "End = ", count_end
			span = word.split("]")
			# End of 2 spans, 2 different starts
			if count_levT == 2 and count_end == 2:
				#print "Cond 4a", end_span
				#print "start_T", start_T
				start2 = start_T.pop()
				#print start2
				#print "New list is = ", start_T
				l2TList.append([span[1], start2, end_span])
				#print "List 2t", l2TList
				count_levT -= 1
			# End of 1 span, 2 same starts
			elif count_levT == 2 and count_end == 1:
				#print "Cond 4b", end_span
				start = start_T.pop()
				l2TList.append([span[1], start, end_span])
				count_levT -= 1
			elif count_levT == 1:
				#print "Cond 4c", end_span
				start = start_T.pop()
				l1TList.append([span[1], start, end_span])
				count_levT -= 1
		

#print "Level 1 T", l1TList
#print "Level 2 T", l2TList
#print "Level 1 P", l1PList
#print "Level 2 P", l2PList
#############################################################
################################
# Look up words in TextGrid
tg = open(directory + basename + ".TextGrid", "r+")
raw_txtgr = tg.read()
#print "TextGrid has been opened"

# Header info
raw_txtgr = raw_txtgr.replace("\r", "")
txtgr_list = raw_txtgr.split("\n")
n_tiers = int(txtgr_list[6].split("=")[1])
#print "N. of tiers = ", n_tiers
xmin = txtgr_list[3].split("=")[1]
xmax = txtgr_list[4].split("=")[1]

# Tiers info
tier_start = [8]
int_id = [13]
for t in xrange(n_tiers-1):
	n_int = int(txtgr_list[int_id[-1]].split("=")[1])
	new_start = tier_start[-1] + 6 + (4 * n_int)
	tier_start.append(new_start)
	int_id.append(new_start + 5)
#print tier_start
#print int_id

#Loop over intervals in each tier to store word info in intList
intList = []
for idx,i in enumerate(int_id):
	intloop_start = i + 1
	intloop_end = 0
	if idx + 1 <= len(tier_start)-1:
		intloop_end = tier_start[idx+1]
	else:
		intloop_end = len(txtgr_list)-1
	#print "Start = ", intloop_start
	#print "End = ", intloop_end
	if intloop_end != 0 and intloop_start < len(txtgr_list)-3:
		blocks = []
		dif = ((intloop_end - intloop_start))/4
		#print "Dif =", dif
		if dif > 1:
			start = intloop_start
			for d in xrange(1, dif+1):
				#print d
				blocks.append(start)
				start += 4
		else:
			blocks.append(intloop_start)
		if blocks != []:
			#print blocks
			for b in blocks:
			#	print "tier = ", idx +1
				int_n = txtgr_list[b][19]
				#print "Interval n = ", int_n
				xmin = txtgr_list[b+1].split("=")[1]
				xmax = txtgr_list[b+2].split("=")[1]
				text = txtgr_list[b+3].split("=")[1]
				#print text[2:-2]
				intList.append([int_n,xmin,xmax,text[2:-2]])
				#print "time, txt = ", xmin,xmax,txt
#print "Intervals list contains = ", intList

#####################################################
#####################################################
# Insert new tiers with thematicity
tierList = ["L1P","L1T","L2P", "L2T"]
listList = [[l1PList], [l1TList], [l2PList], [l2TList]]
new_txtgr = txtgr_list[:6]
tiers_new = n_tiers + len(tierList)
#print "Total tiers = ", tiers_new
change_tiers = "size = " + str(tiers_new)
new_txtgr.append(change_tiers)
new_txtgr.extend(txtgr_list[7:-1])

for ix,lst in enumerate(listList):
	if lst != [[]]:
		#print "Entering list = ", ix
		new_tier = n_tiers + ix+ 1
		#print "New tier = ", new_tier
		tier_n = "    item ["+ str(new_tier) +"]:"
		tier_type = "        class = \"IntervalTier\""
		tier_name = "        name = \""+ tierList[ix] + "\""
		tier_xmin = "        xmin = 0 "
		tier_xmax = "        xmax = "+ str(xmax)

		new_txtgr.extend([tier_n, tier_type, tier_name, tier_xmin, tier_xmax])
		#####################################################################
		# Loop over lists
		newinter = []
		startThem = 0
		endThem = 0
		labelThem = 0
		for items in intList:
			#print items
			wordcheck = items[3]
			#print wordcheck
			for spans in lst:
				#print "LOOP spans"
				for idx,s in enumerate(spans):
					#print "span"
					#print s
					for y,x in enumerate(s):
						if wordcheck == x:
							labelThem = s[0]
							#print "Match found = ", s[0]
							#print "position = ", idx
							if y == 1 :
								startThem = items[1]
							if y == 2 :
								endThem = items[2]
			if startThem != 0 and endThem != 0 :
				#print "Writing intervals"
				newinter.append([startThem,endThem,labelThem])
				startThem = 0
				endThem = 0
		#if ix == 2:
		#	print "New intervals contain = ", newinter

		###########################################################
		# Write new intervals
		size = str(len(newinter))
		tier_nint = "        intervals: size = " 
		new_txtgr.append(tier_nint)
		pos = len(new_txtgr)-1
		#print "New int list =  ", newinter
		new_count = 0
		for count,n in enumerate(newinter) :
			#print "Entering new interval list"
			#if ix == 2:
			#	print "Check final = ", n[1], "xmax = ", xmax
			#	print "Check Length = ", len(newinter), "Count = ", count
			## Insert initial and final intervals
			if count == 0 and n[0] != 0 :
				#print "Cond 1"
				new_count += 1
				int_num = "        intervals [" + str(new_count) +"]:"
				int_xmin= "            xmin = 0"
				int_xmax= "            xmax =" + str(n[0])
				int_txt = "            text = \"\""
				new_txtgr.extend([int_num,int_xmin,int_xmax,int_txt])

				new_count += 1
				int_num = "        intervals [" + str(new_count) +"]:"
				int_xmin= "            xmin =" + str(n[0])
				int_xmax= "            xmax =" + str(n[1])
				int_txt = "            text = \""+ str(n[2]) + "\""
				new_txtgr.extend([int_num,int_xmin,int_xmax,int_txt])
				if count == len(newinter)-1 and n[1] != xmax:
					new_count += 1
					int_num = "        intervals [" + str(new_count) +"]:"
					int_xmin= "            xmin =" + str(n[1])
					int_xmax= "            xmax =" + str(xmax)
					int_txt = "            text = \"\""
					new_txtgr.extend([int_num,int_xmin,int_xmax,int_txt])
			elif count == len(newinter)-1 and n[1] != xmax:	
				new_count += 1
				int_num = "        intervals [" + str(new_count) +"]:"
				int_xmin= "            xmin =" + str(n[0])
				int_xmax= "            xmax =" + str(n[1])
				int_txt = "            text = \""+ str(n[2]) + "\""
				new_txtgr.extend([int_num,int_xmin,int_xmax,int_txt])

				new_count += 1
				int_num = "        intervals [" + str(new_count) +"]:"
				int_xmin= "            xmin =" + str(n[1])
				int_xmax= "            xmax =" + str(xmax)
				int_txt = "            text = \"\""
				new_txtgr.extend([int_num,int_xmin,int_xmax,int_txt])
			else:
				#print "Cond 3"
				new_count += 1
				int_num = "        intervals [" + str(new_count) +"]:"
				int_xmin= "            xmin =" + str(n[0])
				int_xmax= "            xmax =" + str(n[1])
				int_txt = "            text = \""+ str(n[2]) + "\""
				new_txtgr.extend([int_num,int_xmin,int_xmax,int_txt])
		# Update number of intervals according to empty initial and end
		if new_count != 0 :
			size = str(new_count)
			tier_nint += size
			#print tier_nint
			#print "Position = ",pos
			new_txtgr.insert(pos,tier_nint)
			del new_txtgr[pos+1]
	else:
		#print "Empty list = ", ix 
		new_tier = n_tiers + ix + 1
		#print "New tier = ", new_tier
		### changes ###
		#new_txtgr = txtgr_list[:6]
		#change_tiers = "size = " + str(new_tier)
		#new_txtgr.append(change_tiers)
		#new_txtgr.extend(txtgr_list[7:-1])
		### change end ###

		tier_n = "    item ["+ str(new_tier) +"]:"
		tier_type = "        class = \"IntervalTier\""
		tier_name = "        name = \""+ tierList[ix] + "\""
		tier_xmin = "        xmin = 0 "
		tier_xmax = "        xmax = "+ str(xmax)

		new_txtgr.extend([tier_n, tier_type, tier_name, tier_xmin, tier_xmax])
		tier_nint = "        intervals: size = 1" 
		new_txtgr.append(tier_nint)

		int_num = "        intervals [\"1\"]:"
		int_xmin= "            xmin = 0"
		int_xmax= "            xmax = " + str(xmax)
		int_txt = "            text = \"\""
		new_txtgr.extend([int_num,int_xmin,int_xmax,int_txt])

######################################################
# Print result file
result = open(directory + basename + "_result.TextGrid", "w")
newfile = "\n".join(new_txtgr)
result.write(newfile)

tx.close()
tg.close()
result.close()
